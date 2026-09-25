@echo off
setlocal enabledelayedexpansion
title Windows Debloater ^& Privacy Hardener v1.0

:: ===================================================
:: Check Administrator Privileges
:: ===================================================
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] ERROR: This script requires Administrator privileges.
    echo Please right-click 'win_debloater.bat' and select 'Run as Administrator'.
    echo.
    pause
    exit /b 1
)

:menu
cls
echo ===================================================================
echo                  Windows Debloater ^& Hardener
echo ===================================================================
echo  [1] Full Debloat (Telemetry + Bloatware Apps + Registry Tweaks)
echo  [2] Disable Telemetry ^& Tracking Services Only
echo  [3] Remove Pre-installed AppX Bloatware (Xbox, Cortana, Bing, etc.)
echo  [4] Apply Registry Tweaks (Explorer ^& Privacy Improvements)
echo  [5] Create System Restore Point (Recommended before starting)
echo  [6] Revert Telemetry Services ^& Restore Defaults
echo  [0] Exit
echo ===================================================================
set /p choice="Select an option [0-6]: "

if "%choice%"=="1" goto full_debloat
if "%choice%"=="2" goto disable_telemetry
if "%choice%"=="3" goto remove_bloatware
if "%choice%"=="4" goto registry_tweaks
if "%choice%"=="5" goto restore_point
if "%choice%"=="6" goto revert_defaults
if "%choice%"=="0" exit /b 0

echo [!] Invalid selection. Try again.
timeout /t 2 >nul
goto menu

:: ===================================================
:: Create Restore Point
:: ===================================================
:restore_point
cls
echo [*] Creating System Restore Point...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Enable-ComputerRestore -Drive 'C:\' -ErrorAction SilentlyContinue; Checkpoint-Computer -Description 'Before-Win-Debloat' -RestorePointType 'MODIFY_SETTINGS'"
if %errorlevel% equ 0 (
    echo [+] Restore point created successfully.
) else (
    echo [!] Note: Restore point creation failed or System Restore is disabled.
)
echo.
pause
goto menu

:: ===================================================
:: Disable Telemetry Services & Tasks
:: ===================================================
:disable_telemetry
cls
echo [*] Disabling Telemetry ^& Diagnostic Services...

:: Stop & Disable Services
for %%s in (
    "DiagTrack"
    "dmwappushservice"
    "WerSvc"
    "PcaSvc"
    "sysmain"
    "MapsBroker"
) do (
    echo   [-] Disabling service: %%~s
    sc stop "%%~s" >nul 2>&1
    sc config "%%~s" start= disabled >nul 2>&1
)

echo [*] Disabling Telemetry Scheduled Tasks...
schtasks /change /tn "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Autochk\Proxy" /disable >nul 2>&1

echo [+] Telemetry services and tasks disabled.
echo.
if "%~1"=="nofinish" goto :eof
pause
goto menu

:: ===================================================
:: Remove AppX Bloatware
:: ===================================================
:remove_bloatware
cls
echo [*] Removing Pre-installed AppX Bloatware Packages...
echo [*] (This may take a few moments...)

powershell -NoProfile -ExecutionPolicy Bypass -Command "^
$apps = @(^
    'Microsoft.BingNews',^
    'Microsoft.BingWeather',^
    'Microsoft.GetHelp',^
    'Microsoft.Getstarted',^
    'Microsoft.MicrosoftOfficeHub',^
    'Microsoft.MicrosoftSolitaireCollection',^
    'Microsoft.People',^
    'Microsoft.SkypeApp',^
    'Microsoft.Xbox.TCUI',^
    'Microsoft.XboxApp',^
    'Microsoft.XboxGameOverlay',^
    'Microsoft.XboxGamingOverlay',^
    'Microsoft.XboxIdentityProvider',^
    'Microsoft.XboxSpeechToTextOverlay',^
    'Microsoft.YourPhone',^
    'Microsoft.ZuneMusic',^
    'Microsoft.ZuneVideo'^
);^
foreach ($app in $apps) {^
    Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue;^
    Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -eq $app } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue;^
}"

echo [+] Bloatware applications removed.
echo.
if "%~1"=="nofinish" goto :eof
pause
goto menu

:: ===================================================
:: Apply Registry Tweaks
:: ===================================================
:registry_tweaks
cls
echo [*] Applying Privacy ^& Explorer Registry Tweaks...

:: Disable Telemetry in Registry
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocation" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f >nul 2>&1

:: Explorer Tweaks: Show File Extensions & Hidden Files
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d 1 /f >nul 2>&1

echo [+] Registry tweaks applied.
echo.
if "%~1"=="nofinish" goto :eof
pause
goto menu

:: ===================================================
:: Full Debloat
:: ===================================================
:full_debloat
cls
echo ===================================================
echo             Starting Full System Debloat
echo ===================================================
echo.
call :disable_telemetry nofinish
call :remove_bloatware nofinish
call :registry_tweaks nofinish

echo ===================================================
echo [+] Full Debloat process complete!
echo [!] A system restart is recommended to apply all changes.
echo ===================================================
pause
goto menu

:: ===================================================
:: Revert Services to Default
:: ===================================================
:revert_defaults
cls
echo [*] Re-enabling Telemetry Services ^& Defaults...

for %%s in (
    "DiagTrack"
    "SysMain"
    "MapsBroker"
) do (
    echo   [+] Enabling service: %%~s
    sc config "%%~s" start= auto >nul 2>&1
    sc start "%%~s" >nul 2>&1
)

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 1 /f >nul 2>&1

echo [+] Default services restored.
echo.
pause
goto menu
