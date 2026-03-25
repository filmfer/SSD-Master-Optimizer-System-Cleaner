# Lista de serviços a monitorizar
$services = @("SysMain", "DiagTrack")
$issuesFound = @()

foreach ($serviceName in $services) {
    $svc = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    if ($svc -and $svc.StartType -ne "Disabled") {
        $issuesFound += "O servico $serviceName foi REATIVADO (Status: $($svc.StartType))."
    }
}

# Verifica o Modo de Pesquisa no Registro
$searchMode = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Search" -Name "IndexingCompletedFully" -ErrorAction SilentlyContinue
if ($searchMode -and $searchMode.IndexingCompletedFully -ne 0) {
    $issuesFound += "O Windows Search voltou ao modo Aprimorado (IA)."
}

# Se houver problemas, envia notificação
if ($issuesFound.Count -gt 0) {
    $msg = $issuesFound -join "`n"
    powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('$msg', 'Alerta de Performance SSD')"
}
