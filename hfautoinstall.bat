@echo off
setlocal enabledelayedexpansion

:: BEFORE MODIFICATION, COPYING, SELLING, COMPILING, ETC., PLEASE CHECK THE LICENSE.
:: THIS LICENSE DOES NOT CONSTITUTE LEGAL ADVICE.

:: This is the windows version of this autoinstaller.
:: To us the macos/linux version, go to the .sh file

:: ---------------------------------------------------
::       Hardened Firefox Autoinstaller - 1.0
:: ---------------------------------------------------
:: Hardened Firefox is an autoinstaller that simplifies the process of installing hardened Firefox.
:: It allows beginners to easily harden Firefox without manual configurations.
:: 
:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:: Making hardening Firefox easier ;)

:menu
cls
echo [==============================]
echo |   Hardened Firefox Autoinstaller 1.0   |
echo [==============================]
echo Hardened Firefox, easier
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo 1) Start
echo 2) Help
echo 3) Quit
echo ---------------------------------------------
set /p option="Select an option: "
if "%option%"=="1" (
    cls
    echo Please go to about:support, and fill in your profile directory here.
    echo 1. Type in about:support in the URL bar
    echo 2. Check for a section named profile directory
    echo 3. Fill in the file path to the profile directory.
    echo The file path must be exactly from C:\ to your profile directory.
    echo You can copy in the terminal with CTRL-C
    echo You can paste in the terminal with CTRL-V
    echo --------------------------------------------------------------------
    set /p fp="Enter profile directory: "

    :: Validate directory
    if not exist "!fp!\" (
        echo [!] Invalid directory! Please try again.
        timeout /t 2 >nul
        goto menu
    )

    echo The process will start now.
    timeout /t 2 >nul
    cls
    echo Changing directories to !fp!...
    pushd "!fp!" || (echo [!] Failed to change directory. & exit /b 1)

    echo Downloading hardened Firefox files...
    set files=user.js updater.bat prefsCleaner.bat
    for %%f in (%files%) do (
        powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/arkenfox/user.js/refs/heads/master/%%f' -OutFile '%%f'" || (echo [!] Failed to download %%f. & exit /b 1)
    )

    echo Done
    echo Closing all instances of Firefox...
    taskkill /F /IM firefox.exe >nul 2>&1 || echo [!] No Firefox instances to close.
    echo Done
    echo Updating Firefox...
    call updater.bat || (echo [!] Update script failed. & exit /b 1)
    echo Done
    echo Cleaning preferences...
    call prefsCleaner.bat -s || (echo [!] Cleaning preferences failed. & exit /b 1)
    echo Done
    echo Finished! Hardened Firefox is ready to use.
    exit /b 0
) else if "%option%"=="2" (
    cls
    echo This is a hardened Firefox autoinstaller for beginners.
    echo You must have Firefox installed to use this program.
    echo This program makes installing hardened Firefox easier!
    echo More documentation will be on the GitHub page.
    echo This is the Windows version of this autoinstaller.
    echo.
    pause
    goto menu
) else if "%option%"=="3" (
    exit /b 0
) else (
    echo [!] Invalid option!
    timeout /t 2 >nul
    goto menu
)
