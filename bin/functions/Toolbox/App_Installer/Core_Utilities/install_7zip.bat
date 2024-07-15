@echo off

:install_7zip
title STL [��װ-7Z]
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[��Ϣ]%reset% ���ڰ�װ 7-Zip...
winget install -e --id 7zip.7zip

rem Get the current PATH value from the registry
for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v PATH') do set "current_path=%%B"

rem Check if the paths are already in the current PATH
echo %current_path% | find /i "%zip7_install_path%" > nul
set "zip7_path_exists=%errorlevel%"

setlocal enabledelayedexpansion

REM Append the new paths to the current PATH only if they don't exist
if %zip7_path_exists% neq 0 (
    set "new_path=%current_path%;%zip7_install_path%"
    echo.
    echo [DEBUG] "current_path is:%cyan_fg_strong% %current_path%%reset%"
    echo.
    echo [DEBUG] "zip7_install_path is:%cyan_fg_strong% %zip7_install_path%%reset%"
    echo.
    echo [DEBUG] "new_path is:%cyan_fg_strong% !new_path!%reset%"

    REM Update the PATH value in the registry
    reg add "HKCU\Environment" /v PATH /t REG_EXPAND_SZ /d "!new_path!" /f

    REM Update the PATH value for the current session
    setx PATH "!new_path!" > nul
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[��Ϣ]%reset% %green_fg_strong%7-zip �Ѽ���ϵͳ���� PATH.%reset%
) else (
    set "new_path=%current_path%"
    echo %blue_fg_strong%[��Ϣ] 7-Zip �Ѿ�������ϵͳ���� PATH.%reset%
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[��Ϣ]%reset% %green_fg_strong%7-Zip �ɹ���װ.%reset%

REM Prompt user to restart
echo ��������������...
timeout /t 5
cd /d %stl_root%
start %stl_root%Launcher.bat
exit
