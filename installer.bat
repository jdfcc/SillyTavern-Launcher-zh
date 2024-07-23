@echo off
REM SillyTavern Installer
REM Created by: Deffcolony
REM
REM Description:
REM This script can install sillytavern and/or extras with shortcut to open the launcher.bat
REM
REM This script is intended for use on Windows systems.
REM report any issues or bugs on the GitHub ²Ö¿â.
REM
REM GitHub: https://github.com/vircus/SillyTavern-Launcher-zh
REM Issues: https://github.com/vircus/SillyTavern-Launcher-zh/issues
title STL °²×° [×´Ì¬¼ì²é]
setlocal

REM ANSI Escape Code for Colors
set "reset=[0m"

REM Strong Foreground Colors
set "white_fg_strong=[90m"
set "red_fg_strong=[91m"
set "green_fg_strong=[92m"
set "yellow_fg_strong=[93m"
set "blue_fg_strong=[94m"
set "magenta_fg_strong=[95m"
set "cyan_fg_strong=[96m"

REM Normal Background Colors
set "red_bg=[41m"
set "blue_bg=[44m"
set "yellow_bg=[43m"

REM Environment Variables (winget)
set "winget_path=%userprofile%\AppData\Local\Microsoft\WindowsApps"

REM Environment Variables (miniconda3)
set "miniconda_path=%userprofile%\miniconda3"
set "miniconda_path_mingw=%userprofile%\miniconda3\Library\mingw-w64\bin"
set "miniconda_path_usrbin=%userprofile%\miniconda3\Library\usr\bin"
set "miniconda_path_bin=%userprofile%\miniconda3\Library\bin"
set "miniconda_path_scripts=%userprofile%\miniconda3\Scripts"

REM Define the paths and filenames for the shortcut creation (launcher.bat)
set "stl_shortcutTarget=%~dp0launcher.bat"
set "stl_iconFile=%~dp0st-launcher.ico"
set "stl_desktopPath=%userprofile%\Desktop"
set "stl_shortcutName=ST-Launcher.lnk"
set "stl_startIn=%~dp0"
set "stl_comment=SillyTavern Launcher"

REM Define the paths and filenames for the shortcut creation (start.bat)
set "st_shortcutTarget=%~dp0SillyTavern\start.bat"
set "st_iconFile=%~dp0st.ico"
set "st_desktopPath=%userprofile%\Desktop"
set "st_shortcutName=SillyTavern.lnk"
set "st_startIn=%~dp0"
set "st_comment=SillyTavern"

cd /d "%~dp0"

REM Check if folder path has no spaces
echo "%CD%"| findstr /C:" " >nul && (
    echo %red_fg_strong%[´íÎó] Â·¾¶²»ÄÜÓĞ¿Õ¸ñ£¡Çë½«ÆäÉ¾³ı»òÌæ»»Îª: - %reset%
    echo °üº¬¿Õ¸ñµÄÎÄ¼ş¼Ğ»áÊ¹Æô¶¯Æ÷²»ÎÈ¶¨
    echo path: %red_bg%%~dp0%reset%
    pause
    exit /b 1
)

REM Check if folder path has no special characters
echo "%CD%"| findstr /R /C:"[!#\$%&()\*+,;<=>?@\[\]\^`{|}~]" >nul && (
    echo %red_fg_strong%[´íÎó]  Â·¾¶²»ÄÜÓĞÌØÊâ×Ö·û£¡ÇëÉ¾³ıËüÃÇ.%reset%
    echo °üº¬ÌØÊâ×Ö·ûµÄÎÄ¼ş¼Ğ»áÊ¹Æô¶¯Æ÷ÔÚÒÔÏÂÇé¿öÏÂ²»ÎÈ¶¨: "[!#\$%&()\*+,;<=>?@\[\]\^`{|}~]" 
    echo path: %red_bg%%~dp0%reset%
    pause
    exit /b 1
)

REM Get the current PATH value from the registry
for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v PATH') do set "current_path=%%B"

REM Check if the paths are already in the current PATH
echo %current_path% | find /i "%winget_path%" > nul
set "ff_path_exists=%errorlevel%"

setlocal enabledelayedexpansion

REM Append the new paths to the current PATH only if they don't exist
if %ff_path_exists% neq 0 (
    set "new_path=%current_path%;%winget_path%"
    echo.
    echo [DEBUG] "current_path is:%cyan_fg_strong% %current_path%%reset%"
    echo.
    echo [DEBUG] "winget_path is:%cyan_fg_strong% %winget_path%%reset%"
    echo.
    echo [DEBUG] "new_path is:%cyan_fg_strong% !new_path!%reset%"

    REM Update the PATH value in the registry
    reg add "HKCU\Environment" /v PATH /t REG_EXPAND_SZ /d "!new_path!" /f

    REM Update the PATH value for the current session
    setx PATH "!new_path!" > nul
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% %green_fg_strong%winget ÒÑ¼ÓÈëÏµÍ³»·¾³±äÁ¿ PATH.%reset%
) else (
    set "new_path=%current_path%"
    echo %blue_fg_strong%[ĞÅÏ¢] winget ÔÚ»·¾³±äÁ¿ÖĞÒÑ´æÔÚ PATH.%reset%
)

REM Check if Winget is installed; if not, then install it
winget --version > nul 2>&1
if %errorlevel% neq 0 (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[¾¯¸æ] Winget Ã»ÓĞ°²×°ÔÚÏµÍ³ÖĞ.%reset%
    REM Check if the folder exists
    if not exist "%~dp0bin" (
        mkdir "%~dp0bin"
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ´´½¨ÎÄ¼ş¼Ğ: "bin"  
    ) else (
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢] "bin" ÎÄ¼ş¼ĞÒÑ´æÔÚ.%reset%
    )
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÕıÔÚ°²×° Winget...
    curl -L -o "%~dp0bin\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    start "" "%~dp0bin\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% %green_fg_strong%Winget ³É¹¦°²×°. ÇëÖØÆôÆô¶¯Æ÷.%reset%
    pause
    exit
) else (
    echo %blue_fg_strong%[ĞÅÏ¢] Winget ÒÑ¾­°²×°ºÃÁË.%reset%
)
endlocal

REM Check if Git is installed if not then install git
git --version > nul 2>&1
if %errorlevel% neq 0 (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[¾¯¸æ] Git Î´°²×° .%reset%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÕıÔÚÓÃ Winget°²×° Git ...
    winget install -e --id Git.Git
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% %green_fg_strong%Git °²×°³É¹¦£¬ÇëÖØÆô°²×°Æ÷.%reset%
    pause
    exit
) else (
    echo %blue_fg_strong%[ĞÅÏ¢] Git ÒÑ¾­°²×°ºÃÁË.%reset%
)

REM Get the current PATH value from the registry
for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v PATH') do set "current_path=%%B"

REM Check if the paths are already in the current PATH
echo %current_path% | find /i "%miniconda_path%" > nul
set "ff_path_exists=%errorlevel%"

setlocal enabledelayedexpansion

REM Append the new paths to the current PATH only if they don't exist
if %ff_path_exists% neq 0 (
    set "new_path=%current_path%;%miniconda_path%;%miniconda_path_mingw%;%miniconda_path_usrbin%;%miniconda_path_bin%;%miniconda_path_scripts%"
    echo.
    echo [DEBUG] "current_path is:%cyan_fg_strong% %current_path%%reset%"
    echo.
    echo [DEBUG] "miniconda_path is:%cyan_fg_strong% %miniconda_path%%reset%"
    echo.
    echo [DEBUG] "new_path is:%cyan_fg_strong% !new_path!%reset%"

    REM Update the PATH value in the registry
    reg add "HKCU\Environment" /v PATH /t REG_EXPAND_SZ /d "!new_path!" /f

    REM Update the PATH value for the current session
    setx PATH "!new_path!" > nul
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% %green_fg_strong%miniconda3 ÒÑ¼ÓÈëÏµÍ³»·¾³±äÁ¿ PATH.%reset%
) else (
    set "new_path=%current_path%"
    echo %blue_fg_strong%[ĞÅÏ¢] miniconda3 ÒÑ¾­´æÔÚÏµÍ³»·¾³±äÁ¿ PATH.%reset%
)

REM Check if Miniconda3 is installed if not then install Miniconda3
call conda --version > nul 2>&1
if %errorlevel% neq 0 (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[¾¯¸æ] Miniconda3 Î´°²×° .%reset%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÕıÔÚ °²×° Miniconda3 ...
    winget install -e --id Anaconda.Miniconda3
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% %green_fg_strong%Miniconda3 °²×°³É¹¦£¬ÇëÖØÆô°²×°Æ÷.%reset%
    pause
    exit
) else (
    echo %blue_fg_strong%[ĞÅÏ¢] Miniconda3 ÒÑ¾­°²×°ºÃÁË.%reset%
)

REM Check if Python App Execution Aliases exist
if exist "%LOCALAPPDATA%\Microsoft\WindowsApps\python.exe" (
    REM Disable App Execution Aliases for python.exe
    powershell.exe Remove-Item "%LOCALAPPDATA%\Microsoft\WindowsApps\python.exe" -Force
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% %green_fg_strong%ÒÆ³ıÖ´ĞĞ±ğÃû for python.exe%reset%
) else (
    echo %blue_fg_strong%[ĞÅÏ¢] python.exe Ö´ĞĞ±ğÃûÒÑÒÆ³ı.%reset%
)

REM Check if python3.exe App Execution Alias exists
if exist "%LOCALAPPDATA%\Microsoft\WindowsApps\python3.exe" (
    REM Disable App Execution Aliases for python3.exe
    powershell.exe Remove-Item "%LOCALAPPDATA%\Microsoft\WindowsApps\python3.exe" -Force
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% %green_fg_strong%ÒÆ³ıÖ´ĞĞ±ğÃû for python3.exe%reset%
) else (
    echo %blue_fg_strong%[ĞÅÏ¢]  python3.exe Ö´ĞĞ±ğÃûÒÑÒÆ³ı.%reset%
)


REM Installer menu - Frontend
:installer
title STL [°²×°]
cls
echo %blue_fg_strong%/ °²×°%reset%
echo ---------------------------------------------------------------
echo ÄãÏëÅªÉ¶àÏ£¿
echo 1. °²×° SillyTavern
echo 2. °²×° Extras
echo 3. °²×° XTTS
echo 4. °²×° ÒÔÉÏÈ«²¿
echo 5. Ö§³Ö
echo 0. Àë¿ª

set "choice="
set /p "choice=Ñ¡Ôñ (Ä¬ÈÏ 1): "

REM Default to choice 1 if no input is provided
if not defined choice set "choice=1"

REM Installer menu - Backend
if "%choice%"=="1" (
    call :install_sillytavern
) else if "%choice%"=="2" (
    call :install_extras
) else if "%choice%"=="3" (
    call :install_xtts
) else if "%choice%"=="4" (
    call :install_all
) else if "%choice%"=="5" (
    call :support
) else if "%choice%"=="0" (
    exit
) else (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[´íÎó] ÊäÈëÎŞĞ§.ÇëÊäÈëÒ»¸öÓĞĞ§Êı×Ö.%reset%
    pause
    goto :installer
)

:install_sillytavern
title STL [°²×° SILLYTAVERN]
cls
echo %blue_fg_strong%/ °²×° / °²×° SillyTavern%reset%
echo ---------------------------------------------------------------
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÕıÔÚ°²×° SillyTavern...

set max_retries=3
set retry_count=0

:retry_install_sillytavern
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ¿ËÂ¡ SillyTavern ²Ö¿â...
git clone https://github.com/SillyTavern/SillyTavern.git

if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[¾¯¸æ] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_install_sillytavern
    echo %red_bg%[%time%]%reset% %red_fg_strong%[´íÎó] ¿ËÂ¡²Ö¿âÊ§°Ü ÔÚ %max_retries% ÔÙÊÔ.%reset%
    pause
    goto :installer
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% %green_fg_strong%SillyTavern ÒÑ³É¹¦°²×°.%reset%

REM Ask if the user wants to create a shortcut
set /p create_shortcut=ÄãÏë´´½¨×ÀÃæ¿ì½İ·½Ê½Âğ? [Y/n] 
if /i "%create_shortcut%"=="Y" (

    REM Create the shortcut
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ´´½¨¿ì½İ·½Ê½ ST-Launcher...
    %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -Command ^
        "$WshShell = New-Object -ComObject WScript.Shell; " ^
        "$Shortcut = $WshShell.CreateShortcut('%stl_desktopPath%\%stl_shortcutName%'); " ^
        "$Shortcut.TargetPath = '%stl_shortcutTarget%'; " ^
        "$Shortcut.IconLocation = '%stl_iconFile%'; " ^
        "$Shortcut.WorkingDirectory = '%stl_startIn%'; " ^
        "$Shortcut.Description = '%stl_comment%'; " ^
        "$Shortcut.Save()"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% %green_fg_strong%¿ì½İ·½Ê½ÒÑ´´½¨ÔÚ×ÀÃæ.%reset%

    REM Create the shortcut (start.bat)
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ´´½¨¿ì½İ·½Ê½ SillyTavern...
    %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -Command ^
        "$WshShell = New-Object -ComObject WScript.Shell; " ^
        "$Shortcut = $WshShell.CreateShortcut('%st_desktopPath%\%st_shortcutName%'); " ^
        "$Shortcut.TargetPath = '%st_shortcutTarget%'; " ^
        "$Shortcut.IconLocation = '%st_iconFile%'; " ^
        "$Shortcut.WorkingDirectory = '%st_startIn%'; " ^
        "$Shortcut.Description = '%st_comment%'; " ^
        "$Shortcut.Save()"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% %green_fg_strong%¿ì½İ·½Ê½ÒÑ´´½¨ÔÚ×ÀÃæ.%reset%
)


REM Ask if the user wants to start the launcher.bat
set /p start_launcher=ÏÖÔÚ´ò¿ªÆô¶¯Æ÷? [Y/n] 
if /i "%start_launcher%"=="Y" (
    REM Run the launcher
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÔÚĞÂ´°¿Ú´ò¿ªÆô¶¯Æ÷...
    cd /d "%~dp0"
    start cmd /k launcher.bat
    exit
)
goto :installer


:install_extras
title STL [°²×° EXTRAS]
cls
echo %blue_fg_strong%/ °²×° / °²×° Extras%reset%
echo ---------------------------------------------------------------
setlocal enabledelayedexpansion
chcp 65001 > nul

REM Confirm with the user before proceeding
echo.
echo %red_bg%a?¡±a??a??a??a?? INSTALL SUMMARY a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a?¡ª%reset%
echo %red_bg%a?¡® Extras has been DISCONTINUED since April 2024 and WON'T receive any new updates or modules.   a?¡®%reset%
echo %red_bg%a?¡® The vast majority of modules are available natively in the main SillyTavern application.      a?¡®%reset%
echo %red_bg%a?¡® You may still install and use it but DON'T expect to get support if you face any issues.      a?¡®%reset%
echo %red_bg%a?¡® Below is a list of package requirements that will get installed:                              a?¡®%reset%
echo %red_bg%a?¡® * SillyTavern-extras [Size: 65 MB]                                                            a?¡®%reset%
echo %red_bg%a?¡® * Visual Studio BuildTools 2022 [Size: 3,10 GB]                                               a?¡®%reset%
echo %red_bg%a?¡® * Miniconda3 [INSTALLED] [Size: 630 MB]                                                       a?¡®%reset%
echo %red_bg%a?¡® * Miniconda3 env - extras [Size: 9,98 GB]                                                     a?¡®%reset%
echo %red_bg%a?¡® * Git [INSTALLED] [Size: 338 MB]                                                              a?¡®%reset%
echo %red_bg%a?¡® * Microsoft Visual C++ 2015-2022 Redistributable (x64) [Size: 20,6 MB]                        a?¡®%reset%
echo %red_bg%a?¡® * Microsoft Visual C++ 2015-2022 Redistributable (x86) [Size: 18 MB]                          a?¡®%reset%
echo %red_bg%a?¡® TOTAL INSTALL SIZE: 13,67 GB                                                                  a?¡®%reset%
echo %red_bg%a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??%reset%
echo.
set /p "confirmation=ÄúÈ·¶¨Òª¼ÌĞøÂğ? [Y/N]: "
if /i "%confirmation%"=="Y" (
    goto :install_extras_y
) else (
    goto :installer
)


:install_extras_y
REM GPU menu - Frontend
echo ÄÄ¸öÊÇÄãµÄ GPU ?
echo 1. NVIDIA
echo 2. AMD
echo 3. None (CPU-only Ä£Ê½)
echo 0. È¡Ïû°²×°

setlocal enabledelayedexpansion
chcp 65001 > nul
REM Get GPU information
for /f "skip=1 delims=" %%i in ('wmic path win32_videocontroller get caption') do (
    set "gpu_info=!gpu_info! %%i"
)

echo.
echo %blue_bg%a?¡±a??a??a??a?? GPU ĞÅÏ¢ a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a?¡ª%reset%
echo %blue_bg%a?¡®                                               a?¡®%reset%
echo %blue_bg%a?¡®* %gpu_info:~1%                   a?¡®%reset%
echo %blue_bg%a?¡®                                               a?¡®%reset%
echo %blue_bg%a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??%reset%
echo.

endlocal
set /p gpu_choice=ÊäÈëÓëGPU¶ÔÓ¦µÄÊı×Ö: 

REM GPU menu - Backend
REM Set the GPU choice in an »·¾³ variable for choise callback
set "GPU_CHOICE=%gpu_choice%"

REM Check the user's response
if "%gpu_choice%"=="1" (
    REM Install pip requirements
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% GPU Ñ¡ÔñÉèÖÃÎª NVIDIA
    goto :install_extras_pre
) else if "%gpu_choice%"=="2" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% GPU Ñ¡ÔñÉèÖÃÎª AMD
    goto :install_extras_pre
) else if "%gpu_choice%"=="3" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% Ê¹ÓÃ CPU-only Ä£Ê½
    goto :install_extras_pre
) else if "%gpu_choice%"=="0" (
    goto :installer
) else (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[´íÎó] ÊäÈëÎŞĞ§.ÇëÊäÈëÒ»¸öÓĞĞ§Êı×Ö.%reset%
    pause
    goto :install_extras_y
)

:install_extras_pre
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÕıÔÚ°²×° Extras...

set max_retries=3
set retry_count=0

:retry_extras_pre
REM Clone the SillyTavern Extras ²Ö¿â
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ¿ËÂ¡ SillyTavern-extras ²Ö¿â...
git clone https://github.com/SillyTavern/SillyTavern-extras.git

if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[¾¯¸æ] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_extras_pre
    echo %red_bg%[%time%]%reset% %red_fg_strong%[´íÎó] ¿ËÂ¡²Ö¿âÊ§°Ü ÔÚ %max_retries% retries.%reset%
    pause
    goto :installer
)


REM Create a Conda »·¾³ named extras
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ´´½¨ Conda »·¾³: %cyan_fg_strong%extras%reset%
call conda create -n extras python=3.11 -y

REM Activate the conda »·¾³ named extras
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ¼¤»î Conda »·¾³: %cyan_fg_strong%extras%reset%
call conda activate extras

REM Navigate to the SillyTavern-extras Ä¿Â¼
cd "%~dp0SillyTavern-extras"

REM Use the GPU choice made earlier to install requirements for extras
if "%GPU_CHOICE%"=="1" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[extras]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÕıÔÚconda»·¾³ÖĞ´Órequirements.txtµÄÉèÖÃ°²×°NVIDIAÄ£¿é: %cyan_fg_strong%extras%reset%
    call conda install -c conda-forge faiss-gpu -y
    pip install -r requirements.txt
    goto :install_extras_post
) else if "%GPU_CHOICE%"=="2" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[extras]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÕıÔÚconda»·¾³ÖĞ´Órequirements-rocm.txtµÄÉèÖÃ°²×°AMDÄ£¿é: %cyan_fg_strong%extras%reset%
    pip install -r requirements-rocm.txt
    goto :install_extras_post
) else if "%GPU_CHOICE%"=="3" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[extras]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÕıÔÚconda»·¾³ÖĞ´Órequirements-silicon.txtµÄÉèÖÃ°²×°CPUÄ£¿é: %cyan_fg_strong%extras%reset%
    pip install -r requirements-silicon.txt
    goto :install_extras_post
)

:install_extras_post
echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[extras]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÕıÔÚ°²×° pip requirements from requirements-rvc.txt in conda enviroment: %cyan_fg_strong%extras%reset%
pip install -r requirements-rvc.txt
pip install tensorboardX

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÕıÔÚ°²×° Microsoft.VCRedist.2015+.x64...
winget install -e --id Microsoft.VCRedist.2015+.x64

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÕıÔÚ°²×° Microsoft.VCRedist.2015+.x86...
winget install -e --id Microsoft.VCRedist.2015+.x86

REM Check if file exists
if not exist "%temp%\vs_buildtools.exe" (
    curl -L -o "%temp%\vs_buildtools.exe" "https://aka.ms/vs/17/release/vs_BuildTools.exe"
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢] "vs_buildtools.exe" ÎÄ¼şÒÑ´æÔÚ.%reset%
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÕıÔÚ°²×° vs_BuildTools...
start "" "%temp%\vs_buildtools.exe" --norestart --passive --downloadThenInstall --includeRecommended --add Microsoft.VisualStudio.Workload.NativeDesktop --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Workload.MSBuildTools


echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% %green_fg_strong%Extras ÒÑ³É¹¦°²×°.%reset%

REM Ask if the user wants to start the launcher.bat
set /p start_launcher=ÏÖÔÚ´ò¿ªÆô¶¯Æ÷? [Y/n] 
if /i "%start_launcher%"=="Y" (
    REM Run the launcher
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÔÚĞÂ´°¿Ú´ò¿ªÆô¶¯Æ÷...
    cd /d "%~dp0"
    start cmd /k launcher.bat
    exit
)
goto :installer


:install_xtts
title STL [°²×° XTTS]
cls
echo %blue_fg_strong%/ °²×° / °²×° XTTS%reset%
echo ---------------------------------------------------------------

REM GPU menu - Frontend
echo ÄÄ¸öÊÇÄãµÄ GPU?
echo 1. NVIDIA
echo 2. AMD
echo 3. None (CPU-only Ä£Ê½)
echo 0. È¡Ïû°²×°

setlocal enabledelayedexpansion
chcp 65001 > nul
REM Get GPU information
for /f "skip=1 delims=" %%i in ('wmic path win32_videocontroller get caption') do (
    set "gpu_info=!gpu_info! %%i"
)

echo.
echo %blue_bg%a?¡±a??a??a??a?? GPU ĞÅÏ¢ a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a?¡ª%reset%
echo %blue_bg%a?¡®                                               a?¡®%reset%
echo %blue_bg%a?¡®* %gpu_info:~1%                   a?¡®%reset%
echo %blue_bg%a?¡®                                               a?¡®%reset%
echo %blue_bg%a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??%reset%
echo.

endlocal
set /p gpu_choice=ÊäÈëÓëGPU¶ÔÓ¦µÄÊı×Ö: 

REM GPU menu - Backend
REM Set the GPU choice in an »·¾³ variable for choise callback
set "GPU_CHOICE=%gpu_choice%"

REM Check the user's response
if "%gpu_choice%"=="1" (
    REM Install pip requirements
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% GPU Ñ¡ÔñÉèÖÃÎª NVIDIA
    goto :install_xtts_pre
) else if "%gpu_choice%"=="2" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% GPU Ñ¡ÔñÉèÖÃÎª AMD
    goto :install_xtts_pre
) else if "%gpu_choice%"=="3" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% Ê¹ÓÃ CPU-only Ä£Ê½
    goto :install_xtts_pre
) else if "%gpu_choice%"=="0" (
    goto :installer
) else (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[´íÎó] ÊäÈëÎŞĞ§.ÇëÊäÈëÒ»¸öÓĞĞ§Êı×Ö.%reset%
    pause
    goto :install_xtts
)
:install_xtts_pre
REM Check if the folder exists
if not exist "%~dp0voice-generation" (
    mkdir "%~dp0voice-generation"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ´´½¨ÎÄ¼ş¼Ğ: "voice-generation"  
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢] "voice-generation" ÎÄ¼ş¼ĞÒÑ´æÔÚ.%reset%
)
cd /d "%~dp0voice-generation"

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÕıÔÚ°²×° XTTS...

REM Activate the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ¼¤»î Miniconda »·¾³...
call "%miniconda_path%\Scripts\activate.bat"

REM Create a Conda »·¾³ named xtts
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ´´½¨ Conda »·¾³: %cyan_fg_strong%xtts%reset%
call conda create -n xtts python=3.10 -y

REM Activate the xtts »·¾³
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ¼¤»î Conda »·¾³: %cyan_fg_strong%xtts%reset%
call conda activate xtts

REM Use the GPU choice made earlier to install requirements for XTTS
if "%GPU_CHOICE%"=="1" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[xtts]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÕıÔÚ°²×° NVIDIA version of PyTorch in conda enviroment: %cyan_fg_strong%xtts%reset%
    pip install torch==2.1.1+cu118 torchvision==0.16.1+cu118  torchaudio==2.1.1+cu118 --index-url https://download.pytorch.org/whl/cu118
    goto :install_xtts_final
) else if "%GPU_CHOICE%"=="2" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[xtts]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÕıÔÚ°²×° AMD version of PyTorch in conda enviroment: %cyan_fg_strong%xtts%reset%
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm5.6
    goto :install_xtts_final
) else if "%GPU_CHOICE%"=="3" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[xtts]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÕıÔÚ°²×° CPU-only version of PyTorch in conda enviroment: %cyan_fg_strong%xtts%reset%
    pip install torch torchvision torchaudio
    goto :install_xtts_final
)
:install_xtts_final
REM Clone the xtts-api-server ²Ö¿â for voice examples
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ¿ËÂ¡ xtts-api-server ²Ö¿â...
git clone https://github.com/daswer123/xtts-api-server.git
cd /d "xtts-api-server"

REM Create requirements-custom.txt to install pip requirements
echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[xtts]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ´´½¨ ÎÄ¼ş: requirements-custom.txt%reset%
echo xtts-api-server > requirements-custom.txt
echo pydub >> requirements-custom.txt
echo stream2sentence >> requirements-custom.txt
echo spacy==3.7.4 >> requirements-custom.txt

REM Install pip requirements
echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[xtts]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÕıÔÚ°²×° pip requirements in conda enviroment: %cyan_fg_strong%xtts%reset%
pip install -r requirements-custom.txt

REM Create ÎÄ¼ş¼Ğ for xtts
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ´´½¨ xtts ÎÄ¼ş¼Ğ...
mkdir "%~dp0voice-generation\xtts"
mkdir "%~dp0voice-generation\xtts\speakers"
mkdir "%~dp0voice-generation\xtts\output"

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ½«ÓïÒôÊ¾ÀıÌí¼Óµ½speakersÄ¿Â¼...
xcopy "%~dp0voice-generation\xtts-api-server\example\*" "%~dp0voice-generation\xtts\speakers\" /y /e

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÕıÔÚÒÆ³ı the xtts-api-server Ä¿Â¼...
cd /d "%~dp0"
rmdir /s /q "%~dp0voice-generation\xtts-api-server"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% %green_fg_strong%XTTS ÒÑ³É¹¦°²×°%reset%
pause
goto :installer


:install_all
title STL [°²×° EVERYTHING]
cls
echo %blue_fg_strong%/ °²×° / °²×° Everything%reset%
echo ---------------------------------------------------------------
setlocal enabledelayedexpansion
chcp 65001 > nul

REM Confirm with the user before proceeding
echo.
echo %blue_bg%a?¡±a??a??a??a?? INSTALL SUMMARY a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a?¡ª%reset%
echo %blue_bg%a?¡® You are about to install all options from the installer.                                      a?¡®%reset%
echo %blue_bg%a?¡® This will include the following options: SillyTavern, SillyTavern-Extras and XTTS             a?¡®%reset%
echo %blue_bg%a?¡® Below is a list of package requirements that will get installed:                              a?¡®%reset%
echo %blue_bg%a?¡® * SillyTavern [Size: 478 MB]                                                                  a?¡®%reset%
echo %blue_bg%a?¡® * SillyTavern-extras [Size: 65 MB]                                                            a?¡®%reset%
echo %blue_bg%a?¡® * xtts [Size: 1.74 GB]                                                                        a?¡®%reset%
echo %blue_bg%a?¡® * Visual Studio BuildTools 2022 [Size: 3.10 GB]                                               a?¡®%reset%
echo %blue_bg%a?¡® * Miniconda3 [INSTALLED] [Size: 630 MB]                                                       a?¡®%reset%
echo %blue_bg%a?¡® * Miniconda3 env - xtts [Size: 6.98 GB]                                                       a?¡®%reset%
echo %blue_bg%a?¡® * Miniconda3 env - extras [Size: 9.98 GB]                                                     a?¡®%reset%
echo %blue_bg%a?¡® * Git [INSTALLED] [Size: 338 MB]                                                              a?¡®%reset%
echo %blue_bg%a?¡® * Node.js [Size: 87.5 MB]                                                                     a?¡®%reset%
echo %blue_bg%a?¡® * Microsoft Visual C++ 2015-2022 Redistributable (x64) [Size: 20.6 MB]                        a?¡®%reset%
echo %blue_bg%a?¡® * Microsoft Visual C++ 2015-2022 Redistributable (x86) [Size: 18 MB]                          a?¡®%reset%
echo %blue_bg%a?¡® TOTAL INSTALL SIZE: 22.56 GB                                                                  a?¡®%reset%
echo %blue_bg%a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??%reset%
echo.
set /p "confirmation=ÄúÈ·¶¨Òª¼ÌĞøÂğ? [Y/N]: "
if /i "%confirmation%"=="Y" (
    goto :install_all_y
) else (
    goto :installer
)


:install_all_y
REM GPU menu - Frontend
echo ÄÄ¸öÊÇÄãµÄ GPU?
echo 1. NVIDIA
echo 2. AMD
echo 3. None (CPU-only Ä£Ê½)
echo 0. È¡Ïû°²×°

setlocal enabledelayedexpansion
chcp 65001 > nul
REM Get GPU information
for /f "skip=1 delims=" %%i in ('wmic path win32_videocontroller get caption') do (
    set "gpu_info=!gpu_info! %%i"
)

echo.
echo %blue_bg%a?¡±a??a??a??a?? GPU ĞÅÏ¢ a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a?¡ª%reset%
echo %blue_bg%a?¡®                                               a?¡®%reset%
echo %blue_bg%a?¡®* %gpu_info:~1%                   a?¡®%reset%
echo %blue_bg%a?¡®                                               a?¡®%reset%
echo %blue_bg%a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??a??%reset%
echo.

endlocal
set /p gpu_choice=ÊäÈëÓëGPU¶ÔÓ¦µÄÊı×Ö: 

REM GPU menu - Backend
REM Set the GPU choice in an »·¾³ variable for choise callback
set "GPU_CHOICE=%gpu_choice%"

REM Check the user's response
if "%gpu_choice%"=="1" (
    REM Install pip requirements
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% GPU Ñ¡ÔñÉèÖÃÎª NVIDIA
    goto :install_all_pre
) else if "%gpu_choice%"=="2" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% GPU Ñ¡ÔñÉèÖÃÎª AMD
    goto :install_all_pre
) else if "%gpu_choice%"=="3" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% Ê¹ÓÃ CPU-only Ä£Ê½
    goto :install_all_pre
) else if "%gpu_choice%"=="0" (
    goto :installer
) else (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[´íÎó] ÊäÈëÎŞĞ§.ÇëÊäÈëÒ»¸öÓĞĞ§Êı×Ö.%reset%
    pause
    goto :install_all
)

:install_all_pre
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÕıÔÚ°²×° SillyTavern + Extras + XTTS...
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÕıÔÚ°²×° SillyTavern...

set max_retries=3
set retry_count=0

:retry_st_extras_pre
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ¿ËÂ¡ SillyTavern ²Ö¿â...
git clone https://github.com/SillyTavern/SillyTavern.git

if %´íÎólevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[¾¯¸æ] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_st_extras_pre
    echo %red_bg%[%time%]%reset% %red_fg_strong%[´íÎó] ¿ËÂ¡²Ö¿âÊ§°Ü ÔÚ %max_retries% retries.%reset%
    pause
    goto :installer
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% %green_fg_strong%SillyTavern ÒÑ³É¹¦°²×°.%reset%

REM Clone the SillyTavern Extras ²Ö¿â
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÕıÔÚ°²×° Extras...
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ¿ËÂ¡ SillyTavern-extras ²Ö¿â...
git clone https://github.com/SillyTavern/SillyTavern-extras.git

REM Install script for XTTS 
    REM Check if the folder exists
    if not exist "%~dp0voice-generation" (
        mkdir "%~dp0voice-generation"
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ´´½¨ÎÄ¼ş¼Ğ: "voice-generation"  
    ) else (
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢] "voice-generation" ÎÄ¼ş¼ĞÒÑ´æÔÚ.%reset%
    )
    cd /d "%~dp0voice-generation"

    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÕıÔÚ°²×° XTTS...

    REM Activate the Miniconda installation
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ¼¤»î Miniconda »·¾³...
    call "%miniconda_path%\Scripts\activate.bat"

    REM Create a Conda »·¾³ named xtts
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ´´½¨ Conda »·¾³: %cyan_fg_strong%xtts%reset%
    call conda create -n xtts python=3.10 -y

    REM Activate the conda »·¾³ named xtts 
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ¼¤»î Conda »·¾³: %cyan_fg_strong%xtts%reset%
    call conda activate xtts

    REM Use the GPU choice made earlier to install requirements for XTTS
    if "%GPU_CHOICE%"=="1" (
        echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[xtts]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÕıÔÚ°²×° NVIDIA version of PyTorch in conda enviroment: %cyan_fg_strong%xtts%reset%
        pip install torch==2.1.1+cu118 torchvision==0.16.1+cu118  torchaudio==2.1.1+cu118 --index-url https://download.pytorch.org/whl/cu118
        goto :install_st_xtts
    ) else if "%GPU_CHOICE%"=="2" (
        echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[xtts]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÕıÔÚ°²×° AMD version of PyTorch in conda enviroment: %cyan_fg_strong%xtts%reset%
        pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm5.6
        goto :install_st_xtts
    ) else if "%GPU_CHOICE%"=="3" (
        echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[xtts]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÕıÔÚ°²×° CPU-only version of PyTorch in conda enviroment: %cyan_fg_strong%xtts%reset%
        pip install torch torchvision torchaudio
        goto :install_st_xtts
    )

    :install_st_xtts
    REM Clone the xtts-api-server ²Ö¿â for voice examples
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ¿ËÂ¡ xtts-api-server ²Ö¿â...
    git clone https://github.com/daswer123/xtts-api-server.git
    cd /d "xtts-api-server"

    REM Create requirements-custom.txt to install pip requirements
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[xtts]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ´´½¨ ÎÄ¼ş: requirements-custom.txt%reset%
    echo xtts-api-server > requirements-custom.txt
    echo pydub >> requirements-custom.txt
    echo stream2sentence >> requirements-custom.txt
    echo spacy==3.7.4 >> requirements-custom.txt

    REM Install pip requirements
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[xtts]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÕıÔÚ°²×° pip requirements in conda enviroment: %cyan_fg_strong%xtts%reset%
    pip install -r requirements-custom.txt

    REM Create ÎÄ¼ş¼Ğ for xtts
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ´´½¨ xtts ÎÄ¼ş¼Ğ...
    mkdir "%~dp0voice-generation\xtts"
    mkdir "%~dp0voice-generation\xtts\speakers"
    mkdir "%~dp0voice-generation\xtts\output"

    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ½«ÓïÒôÊ¾ÀıÌí¼Óµ½speakersÄ¿Â¼...
    xcopy "%~dp0voice-generation\xtts-api-server\example\*" "%~dp0voice-generation\xtts\speakers\" /y /e

    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÕıÔÚÒÆ³ı the xtts-api-server Ä¿Â¼...
    cd /d "%~dp0"
    rmdir /s /q "%~dp0voice-generation\xtts-api-server"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% %green_fg_strong%XTTS ÒÑ³É¹¦°²×°%reset%
REM End of install script for XTTS


REM Create a Conda »·¾³ named extras
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ´´½¨ Conda »·¾³: %cyan_fg_strong%extras%reset%
call conda create -n extras python=3.11 -y

REM Activate the conda »·¾³ named extras
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ¼¤»î Conda »·¾³: %cyan_fg_strong%extras%reset%
call conda activate extras

REM Navigate to the SillyTavern-extras Ä¿Â¼
cd "%~dp0SillyTavern-extras"

REM Use the GPU choice made earlier to install requirements for extras
if "%GPU_CHOICE%"=="1" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[extras]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÕıÔÚ°²×° ÔÚconda»·¾³ÖĞ´Órequirements.txt°²×°NVIDIAÄ£¿é: %cyan_fg_strong%extras%reset% 
    call conda install -c conda-forge faiss-gpu -y
    pip install -r requirements.txt
    goto :install_all_post
) else if "%GPU_CHOICE%"=="2" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[extras]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÕıÔÚ°²×° modules for AMD from requirements-rocm.txt in conda enviroment: %cyan_fg_strong%extras%reset% 
    pip install -r requirements-rocm.txt
    goto :install_all_post
) else if "%GPU_CHOICE%"=="3" (
    echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[extras]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÕıÔÚ°²×° modules for CPU from requirements-silicon.txt in conda enviroment: %cyan_fg_strong%extras%reset% 
    pip install -r requirements-silicon.txt
    goto :install_all_post
)

:install_all_post
echo %blue_bg%[%time%]%reset% %cyan_fg_strong%[extras]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÕıÔÚ°²×° pip requirements from requirements-rvc.txt in conda enviroment: %cyan_fg_strong%extras%reset% 
pip install -r requirements-rvc.txt
pip install tensorboardX

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÕıÔÚ°²×° Microsoft.VCRedist.2015+.x64...
winget install -e --id Microsoft.VCRedist.2015+.x64

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÕıÔÚ°²×° Microsoft.VCRedist.2015+.x86...
winget install -e --id Microsoft.VCRedist.2015+.x86

REM Check if file exists
if not exist "%temp%\vs_buildtools.exe" (
    curl -L -o "%temp%\vs_buildtools.exe" "https://aka.ms/vs/17/release/vs_BuildTools.exe"
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢] "vs_buildtools.exe" ÎÄ¼şÒÑ´æÔÚ.%reset%
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÕıÔÚ°²×° vs_BuildTools...
start "" "%temp%\vs_buildtools.exe" --norestart --passive --downloadThenInstall --includeRecommended --add Microsoft.VisualStudio.Workload.NativeDesktop --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Workload.MSBuildTools


echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% %green_fg_strong%Extras ÒÑ³É¹¦°²×°.%reset%


REM Ask if the user wants to create a shortcut
set /p create_shortcut=ÄãÏë´´½¨×ÀÃæ¿ì½İ·½Ê½Âğ? [Y/n] 
if /i "%create_shortcut%"=="Y" (

    REM Create the shortcut (launcher.bat)
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ´´½¨¿ì½İ·½Ê½ ST-Launcher...
    %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -Command ^
        "$WshShell = New-Object -ComObject WScript.Shell; " ^
        "$Shortcut = $WshShell.CreateShortcut('%stl_desktopPath%\%stl_shortcutName%'); " ^
        "$Shortcut.TargetPath = '%stl_shortcutTarget%'; " ^
        "$Shortcut.IconLocation = '%stl_iconFile%'; " ^
        "$Shortcut.WorkingDirectory = '%stl_startIn%'; " ^
        "$Shortcut.Description = '%stl_comment%'; " ^
        "$Shortcut.Save()"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% %green_fg_strong%¿ì½İ·½Ê½ÒÑ´´½¨ÔÚ×ÀÃæ.%reset%

    REM Create the shortcut (start.bat)
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ´´½¨¿ì½İ·½Ê½ SillyTavern...
    %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -Command ^
        "$WshShell = New-Object -ComObject WScript.Shell; " ^
        "$Shortcut = $WshShell.CreateShortcut('%st_desktopPath%\%st_shortcutName%'); " ^
        "$Shortcut.TargetPath = '%st_shortcutTarget%'; " ^
        "$Shortcut.IconLocation = '%st_iconFile%'; " ^
        "$Shortcut.WorkingDirectory = '%st_startIn%'; " ^
        "$Shortcut.Description = '%st_comment%'; " ^
        "$Shortcut.Save()"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% %green_fg_strong%¿ì½İ·½Ê½ÒÑ´´½¨ÔÚ×ÀÃæ.%reset%
)


REM Ask if the user wants to start the launcher.bat
set /p start_launcher=ÏÖÔÚ´ò¿ªÆô¶¯Æ÷? [Y/n] 
if /i "%start_launcher%"=="Y" (
    REM Run the launcher
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[ĞÅÏ¢]%reset% ÔÚĞÂ´°¿Ú´ò¿ªÆô¶¯Æ÷...
    cd /d "%~dp0"
    start cmd /k launcher.bat
    exit
)
goto :installer

REM Support menu - Frontend
:support
title STL [Ö§³Ö]
cls
echo %blue_fg_strong%/ °²×° / Ö§³Ö%reset%
echo ---------------------------------------------------------------
echo ÄãÏëÅªÉ¶ÀÕ?
echo 1. ÎÒÏë±¨ issue(²»Äã²»Ïë)
echo 2. ÎÄµµ
echo 3. Discord
echo 0. ·µ»Ø°²×°

set /p support_choice=Ñ¡Ôñ: 

REM Support menu - Backend
if "%support_choice%"=="1" (
    call :issue_report
) else if "%support_choice%"=="2" (
    call :documentation
) else if "%support_choice%"=="3" (
    call :discord
) else if "%support_choice%"=="0" (
    goto :installer
) else (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[´íÎó] ÊäÈëÎŞĞ§.ÇëÊäÈëÒ»¸öÓĞĞ§Êı×Ö.%reset%
    pause
    goto :support
)

:issue_report
start "" "https://github.com/vircus/SillyTavern-Launcher-zh/issues/new/choose"
goto :support

:documentation
start "" "https://docs.sillytavern.app/"
goto :support

:discord
start "" "https://discord.gg/sillytavern"
goto :support

