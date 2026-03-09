@echo off
setlocal enabledelayedexpansion
:: --- VERSION CONTROL ---
set "VERSION=1.2.0"
:: -----------------------

title IT Troubleshooting Toolkit v%VERSION%
mode con: cols=95 lines=35
color 0B

:: --- ADMIN CHECK ---
net session >nul 2>&1
if %errorLevel% neq 0 (
    color 0C
    echo ======================================================
    echo [ERROR] ADMINISTRATIVE PRIVILEGES REQUIRED
    echo ======================================================
    echo Right-click this file and "Run as Administrator".
    echo ======================================================
    pause
    exit
)

:menu
cls
:: --- SYSTEM QUICK LOOK ---
echo ==========================================================================================
echo   IT TOOLKIT v%VERSION%  ^|  Host: %computername%  ^|  User: %username%
echo ==========================================================================================
:: Scrape active IPv4
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr "IPv4" ^| findstr "192. 10. 172."') do set "IP=%%a"
:: Get Last Boot Time
for /f "tokens=1-6 delims= " %%a in ('powershell -command "Get-CimInstance Win32_OperatingSystem | Select-Object -ExpandProperty LastBootUpTime"') do set "BOOT=%%a"
:: Identify Active Network Adapter
for /f "tokens=*" %%i in ('powershell -command "Get-NetAdapter | Where-Object Status -eq 'Up' | Select-Object -ExpandProperty Name"') do set "ADAPTER=%%i"

echo   IP: %IP:~1% [%ADAPTER%]  ^|  Booted: %BOOT%  ^|  Date: %date%
echo ==========================================================================================
echo.
echo   [DIAGNOSTICS]                    [ADMIN TOOLS]
echo    1. Network Refresher             9. Reset Windows Update
echo    2. System Repair (SFC/DISM)     10. Reset Print Spooler
echo    3. Hardware/Battery Info        11. Enable Remote Desktop (RDP)
echo    4. Drive Health (SMART)         12. Update All Apps (Winget)
echo.
echo   [EMERGENCY FIXES]                [ADVANCED INFO]
echo    5. Refresh Explorer Shell       13. BIOS/Firmware Info
echo    6. Recover Wi-Fi Passwords      14. Check Activation Status
echo    7. Continuous Ping              15. Locate BSOD MiniDumps
echo.
echo   [SYSTEM]
echo    16. Generate System Report      17. Disk Cleanup
echo    18. EXIT
echo.
echo ==========================================================================================
set /p choice="Enter Selection (1-18): "

if "%choice%"=="1" goto network
if "%choice%"=="2" goto repair
if "%choice%"=="3" goto hardware
if "%choice%"=="4" goto drivehealth
if "%choice%"=="5" goto explorer
if "%choice%"=="6" goto wifi
if "%choice%"=="7" goto pingtest
if "%choice%"=="9" goto fixupdates
if "%choice%"=="10" goto spooler
if "%choice%"=="11" goto enablerdp
if "%choice%"=="12" goto winget
if "%choice%"=="13" goto bios
if "%choice%"=="14" goto activation
if "%choice%"=="15" goto minidump
if "%choice%"=="16" goto report
if "%choice%"=="17" goto cleanup
if "%choice%"=="18" goto end
goto menu

:repair
cls
echo [WARNING] This process may take 15-30 minutes. 
set /p confirm="Continue? (Y/N): "
if /i not "%confirm%"=="Y" goto menu
echo [Action] Running System Health Checks...
sfc /scannow
Dism /Online /Cleanup-Image /RestoreHealth
echo ^G
echo [COMPLETE] System files verified and repaired.
pause
goto menu

:winget
cls
echo [Action] Searching for app updates via Winget...
winget upgrade --all
echo ^G
echo [COMPLETE] All eligible apps updated.
pause
goto menu

:network
cls
echo [Action] Refreshing Network Stack...
ipconfig /release >nul & ipconfig /renew >nul & ipconfig /flushdns >nul
netsh winsock reset >nul
echo [OK] Network refreshed. ^G
pause
goto menu

:hardware
cls
echo [Action] Hardware Discovery...
powershell -command "Write-Host 'Serial: ' (Get-CimInstance Win32_Bios).SerialNumber -ForegroundColor Cyan; Write-Host 'Model: ' (Get-CimInstance Win32_ComputerSystem).Model -ForegroundColor Cyan"
powercfg /batteryreport /output "%userprofile%\Desktop\Battery_Report.html" >nul
echo [OK] Hardware info pulled; Battery report on Desktop.
pause
goto menu

:wifi
cls
echo [Action] Saved Profiles:
netsh wlan show profiles | findstr "All User Profile"
echo.
set /p profile="Enter Exact Profile Name: "
netsh wlan show profile name="%profile%" key=clear | findstr "Key Content"
pause
goto menu

:bios
cls
powershell -command "Get-CimInstance Win32_Bios | Select-Object Manufacturer, Name, ReleaseDate, SMBIOSBIOSVersion | fl"
pause
goto menu

:activation
cls
cscript //nologo %systemroot%\system32\slmgr.vbs /xpr
pause
goto menu

:minidump
cls
if exist C:\Windows\Minidump (
    dir C:\Windows\Minidump\*.dmp /B /O-D
) else (
    echo [INFO] No BSOD logs found.
)
pause
goto menu

:explorer
cls
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe
echo [OK] Explorer Refreshed.
pause
goto menu

:cleanup
cls
cleanmgr /sagerun:1
pause
goto menu

:drivehealth
cls
powershell -command "Get-PhysicalDisk | Select-Object DeviceId, FriendlyName, HealthStatus | ft"
pause
goto menu

:fixupdates
cls
net stop wuauserv /y >nul 2>&1
net stop bits /y >nul 2>&1
rd /s /q %systemroot%\SoftwareDistribution
net start wuauserv >nul 2>&1
net start bits >nul 2>&1
echo [OK] Updates reset. ^G
pause
goto menu

:enablerdp
cls
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f >nul
netsh advfirewall firewall set rule group="remote desktop" new enable=Yes >nul
echo [OK] RDP Enabled and Firewall open.
pause
goto menu

:report
cls
set out="%userprofile%\Desktop\IT_Report_%computername%.txt"
echo REPORT v%VERSION% > %out%
systeminfo | findstr /B /C:"OS" >> %out%
tasklist >> %out%
echo [OK] Saved to Desktop.
pause
goto menu

:pingtest
cls
set /p target="Target: "
echo Press Ctrl+C to stop.
:loop
echo [%time%] Pinging %target%...
ping -n 1 %target% | findstr "Reply" || echo [!] TIMEOUT
timeout /t 2 >nul
goto loop

:end
cls
echo ======================================================
echo   Toolkit Closing. Cleaning temporary variables...
echo ======================================================
endlocal
timeout /t 2 >nul
exit