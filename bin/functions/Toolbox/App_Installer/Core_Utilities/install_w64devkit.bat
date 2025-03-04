@echo off

:install_w64devkit
REM Check if 7-Zip is installed
7z > nul 2>&1
if %errorlevel% neq 0 (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] 7z 命令没找到 PATH.%reset%
    echo %red_fg_strong%7-Zip 没安装或没添加到系统变量PATH中.%reset%
    echo %red_fg_strong%To install 7-Zip go to:%reset% %blue_bg%/ 工具箱 /APP安装选项 /核心应用 /安装 7-Zip%reset%
    pause
    goto :app_installer_core_utilities
)

REM Check if the folder exists
if exist "%w64devkit_install_path%" (
    REM Remove w64devkit folder if it already exist
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在移除已存在的 w64devkit安装信息...
    rmdir /s /q "%w64devkit_install_path%"
)

REM Download w64devkit zip archive
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在下载 w64devkit...
curl -L -o "%w64devkit_download_path%" "%w64devkit_download_url%"

REM Extract w64devkit zip archive
7z x "%w64devkit_download_path%" -o"C:\"

REM Remove leftovers
del "%w64devkit_download_path%"

REM Get the current PATH value from the registry
for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v PATH') do set "current_path=%%B"

REM Check if the paths are already in the current PATH
echo %current_path% | find /i "%w64devkit_path_bin%" > nul
set "ff_path_exists=%errorlevel%"

setlocal enabledelayedexpansion

REM Append the new paths to the current PATH only if they don't exist
if %ff_path_exists% neq 0 (
    set "new_path=%current_path%;%w64devkit_path_bin%"
    echo.
    echo [DEBUG] "current_path is:%cyan_fg_strong% %current_path%%reset%"
    echo.
    echo [DEBUG] "w64devkit_path_bin is:%cyan_fg_strong% %w64devkit_path_bin%%reset%"
    echo.
    echo [DEBUG] "new_path is:%cyan_fg_strong% !new_path!%reset%"

    REM Update the PATH value in the registry
    reg add "HKCU\Environment" /v PATH /t REG_EXPAND_SZ /d "!new_path!" /f

    REM Update the PATH value for the current session
    setx PATH "!new_path!" > nul
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%w64devkit 已添加到 PATH中.%reset%
) else (
    set "new_path=%current_path%"
    echo %blue_fg_strong%[信息] w64devkit 已存在于 PATH中.%reset%
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%w64devkit已安装.%reset%

REM Prompt user to restart
echo 正在重启启动器...
timeout /t 5
cd /d %stl_root%
start %stl_root%Launcher.bat
exit