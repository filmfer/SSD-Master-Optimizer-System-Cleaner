⚡ **SSD Master Optimizer & System Cleaner**

**Unlock your SSD's true potential by reclaiming up to 22% of random write performance.**

🚀

This tool was designed to address three specific Windows 11 settings that deliberately throttle your SSD performance to serve Microsoft's background infrastructure. By disabling these features, you stop the continuous, small random writes that compete for your SSD's controller bandwidth.

🛠️ **What this Script Fixes**
The default Windows 11 configuration imposes a "performance tax" on your hardware. Here is how we recover it:
 - 🔍 **Windows Search (Classic Mode):** Disables AI-enhanced content analysis that generates sustained SSD read/write access.
 - 🧠 **SysMain (Superfetch) Deactivation:** Stops a legacy feature that provides zero benefit to SSDs but consumes between 700 to 1,400 GB of write endurance per year.
 - 📡 **Telemetry & Staging:** Shuts down the behavioral data collection that consumes between 6% and 11% of your SSD controller's bandwidth.
 - 🧹 **Deep Cleanup:** Removes temporary caches and legacy Windows Update residues (WinSxS) using official DISM tools.
 - 🏥 **Health Monitor:** Provides real-time SSD wearout indicators and temperature data.

📊 **Performance Recovery Gains**
Based on independent storage benchmark testing (e.g., CrystalDiskMark):

  **Metric**                                       **Improvement**
  Random Write Performance                      +14% to +22%
  Sequential Write Throughput                   +4% to +8%
  Random Read Performance                       +6% to +9%
  Application Load Times                        +3% to +17%

🚀 **One-Liner para Execução Direta (PowerShell)**

This command downloads the script from your repository, bypasses execution restrictions, and runs it with Administrator privileges.

    powershell -NoProfile -ExecutionPolicy Bypass -Command "iex (New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/filmfer/SSD-Master-Optimizer-System-Cleaner/main/Windows_SSD_Master_Optimizer.ps1')"

⚠️ **DISCLAIMER & LEGAL NOTICE**
**USE AT YOUR OWN RISK.**🛑
 - **No Liability:** This script is provided "as is" without any warranty. The author (FILMFER.COM) cannot be held legally responsible for any data loss, system instability, or hardware damage resulting from the use of this tool.
 - **System Changes:** This script modifies system services, registry keys, and deletes temporary files. It is highly recommended to use Option 1 (Create Restore Point) before applying any optimizations.
 - **Updates:** Windows Updates may periodically restore these settings to their default, performance-degrading states. It is recommended to run this tool monthly.

💻 **Installation & Usage**
 1. Open PowerShell as Administrator.
 2. Run the command provided in the one-liner or download the *.ps1* file manually.
 3. Follow the interactive menu.

🌟 **Contribution**
Found a bug or have a suggestion? Feel free to open an Issue or submit a Pull Request.
**Powered by FILMFER.COM** | Let your SSD do what you paid for it to do.

## ⚖️ **License**
This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.
