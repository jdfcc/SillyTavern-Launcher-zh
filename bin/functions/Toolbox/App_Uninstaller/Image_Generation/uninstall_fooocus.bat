@echo off

:uninstall_fooocus
title STL [UNINSTALL FOOOCUS]
setlocal enabledelayedexpansion
chcp 65001 > nul

REM Confirm with the user before proceeding
echo.
echo %red_bg%╔════ DANGER ZONE ══════════════════════════════════════════════════════════════════════════════╗%reset%
echo %red_bg%║ WARNING: This will delete all data of Fooocus                                                 ║%reset%
echo %red_bg%║ If you want to keep any data, make sure to create a backup before proceeding.                 ║%reset%
echo %red_bg%╚═══════════════════════════════════════════════════════════════════════════════════════════════╝%reset%
echo.
set /p "confirmation=Are you sure you want to proceed? [Y/N]: "
if /i "%confirmation%"=="Y" (

    REM Remove the Conda environment
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% Removing the Conda enviroment: %cyan_fg_strong%fooocus%reset%
    call conda deactivate
    call conda remove --name fooocus --all -y
    call conda clean -a -y

    REM Remove the folder Fooocus
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% Removing the Fooocus directory...
    cd /d "%~dp0"
    rmdir /s /q "%fooocus_install_path%"

    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%Fooocus has been uninstalled successfully.%reset%
    pause
    goto :app_uninstaller_image_generation
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% Uninstall canceled.
    pause
    goto :app_uninstaller_image_generation
)
