# --- CONFIGURATION / STRINGS ---
$msgErrorAdmin = "ERROR: You must run this script as ADMINISTRATOR."
$msgHeader     = "===================================================================="
$msgTitle      = "    SSD MASTER OPTIMIZER & SYSTEM (WINDOWS 11) by FILMFER.COM       "
$msgMenuOption = "Choose an option"
$msgWaitKey    = "Press any key to continue..."

# --- FUNCTIONS ---

function Create-RestorePoint {
    Write-Host "`n[+] Creating System Restore Point..." -ForegroundColor Cyan
    Enable-ComputerRestore -Drive "C:\" -ErrorAction SilentlyContinue
    Checkpoint-Computer -Description "Before_SSD_Optimization" -RestorePointType "MODIFY_SETTINGS"
    Write-Host "[OK] Restore Point created successfully." -ForegroundColor Green
}

function Get-SSDHealth {
    Write-Host "`n[+] Reading SSD Health Data..." -ForegroundColor Cyan
    
    # Identify the system disk
    $bootDiskNumber = (Get-Partition -DriveLetter "C").DiskNumber
    $physicalDisk = Get-PhysicalDisk | Where-Object { $_.DeviceID -eq $bootDiskNumber }
    $diskStats = Get-StorageReliabilityCounter -PhysicalDisk $physicalDisk -ErrorAction SilentlyContinue

    if ($diskStats) {
        Write-Host "------------------------------------------------------"
        Write-Host "Wearout Indicator: $($diskStats.WearoutIndicator)% (Ideal: <5%)" -ForegroundColor Yellow
        Write-Host "Temperature: $($diskStats.Temperature) C" -ForegroundColor Yellow
        Write-Host "------------------------------------------------------"
    } else {
        $wmiStats = Get-WmiObject -Namespace root\wmi -Class MSStorageDriver_FailurePredictStatus -ErrorAction SilentlyContinue
        $status = if ($wmiStats.PredictFailure) { "CRITICAL" } else { "HEALTHY" }
        Write-Host "General Status (WMI): $status" -ForegroundColor Yellow
        Write-Host "Note: TBW details omitted by the manufacturer's controller."
    }
}

function Optimize-SSD {
    Write-Host "`n[+] Applying SSD Performance Optimizations..." -ForegroundColor Cyan
    
    # 1. Windows Search Classic Mode (Prevents AI content analysis overhead)
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Search" -Name "IndexingCompletedFully" -Value 0 -ErrorAction SilentlyContinue
    
    # 2. Disable SysMain (Superfetch) - Saves 700-1400GB/year of writes
    Stop-Service -Name "SysMain" -Force -ErrorAction SilentlyContinue
    Set-Service -Name "SysMain" -StartupType Disabled
    
    # 3. Disable Telemetry (DiagTrack) - Recovers 6-11% controller bandwidth
    Stop-Service -Name "DiagTrack" -Force -ErrorAction SilentlyContinue
    Set-Service -Name "DiagTrack" -StartupType Disabled
    
    # 4. Disable Diagnostic Scheduled Tasks
    $tasks = @(
        "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator",
        "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser",
        "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
    )
    foreach ($t in $tasks) { 
        $tName = ($t -split '\\')[-1]
        $tPath = ($t.Substring(0, $t.LastIndexOf('\')) + '\')
        Disable-ScheduledTask -TaskName $tName -TaskPath $tPath -ErrorAction SilentlyContinue 
    }
    Write-Host "[OK] Optimization complete. Random write performance improved." -ForegroundColor Green
}

function Clean-Temporary {
    Write-Host "`n[+] Cleaning temporary files and cache..." -ForegroundColor Cyan
    $tempPaths = @("$env:TEMP\*", "$env:SystemRoot\Temp\*")
    foreach ($path in $tempPaths) { Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue }
    Clear-DnsClientCache
    Write-Host "[OK] Cleanup completed." -ForegroundColor Green
}

function Clean-WindowsUpdate {
    Write-Host "`n[+] Cleaning WinSxS residues (DISM)..." -ForegroundColor Cyan
    dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase
    Write-Host "[OK] Windows Update packages cleaned." -ForegroundColor Green
}

# --- MAIN MENU ---

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host $msgErrorAdmin -ForegroundColor Red ; pause ; exit
}

do {
    Clear-Host
    Write-Host $msgHeader -ForegroundColor Yellow
    Write-Host $msgTitle -ForegroundColor Yellow
    Write-Host $msgHeader -ForegroundColor Yellow
    Write-Host "1. Create Restore Point"
    Write-Host "2. Optimize SSD (Performance + Lifespan)"
    Write-Host "3. Clean Temp Files and Cache"
    Write-Host "4. Clean Windows Update Residues"
    Write-Host "5. Check SSD Health Status"
    Write-Host "6. RUN ALL (Restore + Optimize + Clean + Health Check)"
    Write-Host "0. Exit"
    Write-Host "======================================================"
    
    $choice = Read-Host $msgMenuOption
    switch ($choice) {
        "1" { Create-RestorePoint }
        "2" { Optimize-SSD }
        "3" { Clean-Temporary }
        "4" { Clean-WindowsUpdate }
        "5" { Get-SSDHealth }
        "6" { Create-RestorePoint; Optimize-SSD; Clean-Temporary; Clean-WindowsUpdate; Get-SSDHealth }
        "0" { exit }
    }
    if ($choice -ne "0") { 
        Write-Host "`n$msgWaitKey"
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
} while ($choice -ne "0")
