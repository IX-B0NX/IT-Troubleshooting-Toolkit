@echo off
setlocal enabledelayedexpansion
:: --- VERSION CONTROL ---
set "VERSION=1.0.0"
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
echo  1. Network Refresher (DNS/IP Reset)
echo  2. System Repair (SFC/DISM)
echo  3. Generate System Report (Hardware/Tasks)
echo  4. Continuous Ping Monitor
echo  5. Exit
echo ======================================================
set /p choice="Select an option (1-5): "

if "%choice%"=="1" goto network
if "%choice%"=="2" goto repair
if "%choice%"=="3" goto report
if "%choice%"=="4" goto pingtest
if "%choice%"=="5" exit
goto menu

:network
cls
echo [Action] Resetting Network Stack...
ipconfig /release
ipconfig /renew
ipconfig /flushdns
netsh winsock reset
echo.
echo Done! Network settings refreshed.
pause
goto menu

:repair
cls
echo [Action] Running System Health Checks...
echo Phase 1: SFC Scan...
sfc /scannow
echo Phase 2: DISM Repair...
Dism /Online /Cleanup-Image /RestoreHealth
echo.
echo System repair complete.
pause
goto menu

:report
cls
echo [Action] Generating System Report...
set out="%userprofile%\Desktop\IT_Report_%computername%.txt"
echo SYSTEM REPORT - v%VERSION% > %out%
echo Date/Time: %date% %time% >> %out%
echo -------------------------------- >> %out%
systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"System Type" >> %out%
echo. >> %out%
echo [RUNNING TASKS] >> %out%
tasklist >> %out%
echo.
echo Success! Report saved to Desktop.
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