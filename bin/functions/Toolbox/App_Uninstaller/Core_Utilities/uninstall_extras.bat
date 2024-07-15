@echo off

:uninstall_extras
title STL [UNINSTALL EXTRAS]
setlocal enabledelayedexpansion
chcp 65001 > nul

REM Confirm with the user before proceeding
echo.
echo %red_bg%�X�T�T�T�T DANGER ZONE �T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�[%reset%
echo %red_bg%�U WARNING: This will delete all data of Extras                                                  �U%reset%
echo %red_bg%�U If you want to keep any data, make sure to create a backup before proceeding.                 �U%reset%
echo %red_bg%�^�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�a%reset%
echo.
set /p "confirmation=Are you sure you want to proceed? [Y/N]: "
if /i "%confirmation%"=="Y" (

    REM Remove the Conda environment
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[��Ϣ]%reset% Removing the Conda enviroment: %cyan_fg_strong%extras%reset%
    call conda deactivate
    call conda remove --name extras --all -y
    call conda clean -a -y

    REM Remove the folder SillyTavern-extras
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[��Ϣ]%reset% Removing the SillyTavern-extras directory...
    cd /d "%~dp0"
    rmdir /s /q "%extras_install_path%"

    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[��Ϣ]%reset% %green_fg_strong%Extras has been uninstalled successfully.%reset%
    pause
    goto :app_uninstaller_core_utilities
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[��Ϣ]%reset% Uninstall canceled.
    pause
    goto :app_uninstaller_core_utilities
)