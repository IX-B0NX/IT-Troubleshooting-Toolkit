@echo off
setlocal enabledelayedexpansion
:: --- VERSION CONTROL ---
set "VERSION=1.1.2"
:: -----------------------

title IT Troubleshooting Toolkit v%VERSION%
color 0B

:: --- ADMIN CHECK ---
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [Error] Please right-click and "Run as Administrator".
    pause
    exit
)

:menu
cls
echo ======================================================
echo          IT TROUBLESHOOTING TOOLKIT v%VERSION%
echo ======================================================
echo  [DIAGNOSTICS]
echo   1. Network Refresher
echo   2. System Repair (SFC/DISM)
echo   3. Battery Health Report
echo   4. Hardware Info (Serial/Model)
echo.
echo  [UTILITIES]
echo   5. Generate System Report
echo   6. Reset Print Spooler
echo   7. Continuous Ping Monitor
echo.
echo  [SYSTEM]
echo   8. Exit
echo ======================================================
set /p choice="Select an option (1-8): "

if "%choice%"=="1" goto network
if "%choice%"=="2" goto repair
if "%choice%"=="3" goto battery
if "%choice%"=="4" goto hardware
if "%choice%"=="5" goto report
if "%choice%"=="6" goto spooler
if "%choice%"=="7" goto pingtest
if "%choice%"=="8" exit
goto menu

:network
cls
echo [Action] Resetting Network Stack...
ipconfig /release >nul 2>&1
ipconfig /renew >nul 2>&1
ipconfig /flushdns >nul 2>&1
netsh winsock reset >nul 2>&1
echo Done! Network settings refreshed.
pause
goto menu

:repair
cls
echo [Action] Running System Health Checks...
echo Phase 1: SFC Scan...
sfc /scannow
echo.
echo Phase 2: DISM Repair...
Dism /Online /Cleanup-Image /RestoreHealth
echo System repair complete.
pause
goto menu

:battery
cls
echo [Action] Generating Battery Health Report...
powercfg /batteryreport /output "%userprofile%\Desktop\Battery_Report.html"
echo Report saved to Desktop as "Battery_Report.html"
pause
goto menu

:hardware
cls
echo [Action] Retrieving Hardware Identifiers...
echo ------------------------------------------
echo Serial Number:
powershell -command "Get-CimInstance Win32_Bios | Select-Object -ExpandProperty SerialNumber"
echo.
echo Model Name:
powershell -command "Get-CimInstance Win32_ComputerSystem | Select-Object -ExpandProperty Model"
echo ------------------------------------------
pause
goto menu

:report
cls
echo [Action] Generating Deep System Report...
set out="%userprofile%\Desktop\IT_Report_%computername%.txt"
echo SYSTEM REPORT - v%VERSION% > %out%
echo Date/Time: %date% %time% >> %out%
echo -------------------------------- >> %out%
systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"System Type" >> %out%
echo. >> %out%
echo [RUNNING TASKS] >> %out%
tasklist >> %out%
echo Success! Report saved to Desktop.
pause
goto menu

:spooler
cls
echo [Action] Resetting Print Spooler...
net stop spooler /y
echo Clearing old print jobs...
del /Q /F /S "%systemroot%\System32\Spool\Printers\*.*"
net start spooler
echo Print Spooler has been restarted.
pause
goto menu

:pingtest
cls
set /p target="Enter IP/Domain to monitor: "
echo Press Ctrl+C to stop.
:loop
echo [%time%] Pinging %target%...
ping -n 1 %target% | findstr "Reply" || echo [!] TIMEOUT at %time%
timeout /t 2 >nul
goto loop