@echo off

:install_ffmpeg
title STL [INSTALL-FFMPEG]
REM Check if 7-Zip is installed
7z > nul 2>&1
if %errorlevel% neq 0 (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[����] 7z ����δ��ϵͳ����PATH�з��� .%reset%
    echo %red_fg_strong%7-Zip û�а�װ��û����ϵͳ����PATH��.%reset%
    echo %red_fg_strong%To install 7-Zip go to:%reset% %blue_bg%/ ������ / APP��װѡ�� / ����APP/ ��װ 7-Zip%reset%
    pause
    goto :app_installer_core_utilities
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[��Ϣ]%reset% �������� FFmpeg �浵�ļ�...
curl -L -o "%ffmpeg_download_path%" "%ffmpeg_download_url%"

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[��Ϣ]%reset% ��������ڣ����� ffmpeg Ŀ¼...
if not exist "%ffmpeg_install_path%" (
    mkdir "%ffmpeg_install_path%"
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[��Ϣ]%reset% ��ȡ FFmpeg �浵�ļ�...
7z x "%ffmpeg_download_path%" -o"%ffmpeg_install_path%"


echo %blue_bg%[%time%]%reset% %blue_fg_strong%[��Ϣ]%reset% �ƶ� FFmpeg ���ݵ� C:\ffmpeg...
for /d %%i in ("%ffmpeg_install_path%\ffmpeg-*-full_build") do (
    xcopy "%%i\bin" "%ffmpeg_install_path%\bin" /E /I /Y
    xcopy "%%i\doc" "%ffmpeg_install_path%\doc" /E /I /Y
    xcopy "%%i\presets" "%ffmpeg_install_path%\presets" /E /I /Y
    rd "%%i" /S /Q
)

rem Get the current PATH value from the registry
for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v PATH') do set "current_path=%%B"

rem Check if the paths are already in the current PATH
echo %current_path% | find /i "%ffmpeg_path_bin%" > nul
set "ff_path_exists=%errorlevel%"

setlocal enabledelayedexpansion

REM Append the new paths to the current PATH only if they don't exist
if %ff_path_exists% neq 0 (
    set "new_path=%current_path%;%ffmpeg_path_bin%"
    echo.
    echo [DEBUG] "current_path is:%cyan_fg_strong% %current_path%%reset%"
    echo.
    echo [DEBUG] "ffmpeg_path_bin is:%cyan_fg_strong% %ffmpeg_path_bin%%reset%"
    echo.
    echo [DEBUG] "new_path is:%cyan_fg_strong% !new_path!%reset%"

    REM Update the PATH value in the registry
    reg add "HKCU\Environment" /v PATH /t REG_EXPAND_SZ /d "!new_path!" /f

    REM Update the PATH value for the current session
    setx PATH "!new_path!" > nul
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[��Ϣ]%reset% %green_fg_strong%ffmpeg ����ӵ� PATH.%reset%
) else (
    set "new_path=%current_path%"
    echo %blue_fg_strong%[��Ϣ] ffmpeg �Ѿ������� PATH��.%reset%
)
del "%ffmpeg_download_path%"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[��Ϣ]%reset% %green_fg_strong%ffmpeg ��װ�ɹ�.%reset%

REM Prompt user to restart
echo ��������������...
timeout /t 5
cd /d %stl_root%
start %stl_root%Launcher.bat
exit