🚀 Key Features

🔍 Diagnostics
Network Refresher: Automated IP release/renew, DNS flush, and Winsock reset.

System Repair: Sequential execution of SFC /scannow and DISM /RestoreHealth with safety confirmations.

Hardware & Battery: Pulls BIOS serial numbers, model names, and generates detailed HTML battery health reports.

Drive Health: PowerShell-based S.M.A.R.T. status check for all physical disks.

🛠️ Admin & Emergency Tools
App Updates (Winget): One-click update for all third-party software (Chrome, Zoom, etc.) via Windows Package Manager.

Explorer Refresh: Instantly restarts explorer.exe to resolve taskbar or UI hangs.

Windows Update Reset: Clears corrupted SoftwareDistribution caches and restarts update services.

Remote Desktop (RDP): Automated Registry and Firewall provisioning to enable RDP access.

Wi-Fi Recovery: Retrieve clear-text passwords for any saved wireless profiles.

📋 Advanced Information
BIOS/Firmware: Detailed audit of manufacturer, version, and release dates.

Activation Status: Check Windows licensing and expiration info.

BSOD MiniDumps: Automated locator for Blue Screen crash logs.

🖥️ System Quick-Look (v1.2.0)
The main menu provides an instant snapshot of the machine's state:

Internal IPv4 Address (Filters for 192.x, 10.x, and 172.x ranges).

Active Network Adapter Name (Identifies if you are on Wi-Fi or Ethernet).

Last Boot Time: Professional uptime verification to confirm recent restarts.

🔧 Installation & Usage
Download the toolkit.bat file.

Run as Administrator: Right-click the file and select "Run as Administrator". This is required for 90% of the tools to function.

Navigate: Use the numbered menu to select your desired tool.

[!IMPORTANT]
Admin Check: If the script detects it is not running with elevated privileges, the console will turn RED and prevent execution to protect system integrity.

📜 Disclaimer
This toolkit is provided "as is" without warranty of any kind. The author is not responsible for any system damage or data loss resulting from the use of this script. Always ensure you have a valid backup before performing system repairs or registry modifications.

📂 Version History
v1.2.0 (Gold Master): Integrated System Quick-Look (IP/Uptime), Winget updates, RDP automation, and BIOS diagnostics. Added audio feedback (^G) and memory hygiene (endlocal).

v1.1.0: Added Battery Reports, Hardware IDs, and Print Spooler management.

v1.0.0: Initial release with core Network and System Repair tools.
