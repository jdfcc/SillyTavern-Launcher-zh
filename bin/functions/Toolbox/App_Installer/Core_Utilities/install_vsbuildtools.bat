@echo off

:install_vsbuildtools
REM Check if file exists
if not exist "%bin_dir%\vs_buildtools.exe" (
    REM Check if the folder exists
    if not exist "%bin_dir%" (
        mkdir "%bin_dir%"
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[��Ϣ]%reset% �����ļ���: "bin"  
    ) else (
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[��Ϣ] "bin" �ļ����Ѵ���.%reset%
    )
    curl -L -o "%bin_dir%\vs_buildtools.exe" "https://aka.ms/vs/17/release/vs_BuildTools.exe"
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[��Ϣ] "vs_buildtools.exe"�ļ��Ѵ��ڣ������������°汾...%reset%
    del "%bin_dir%\vs_buildtools.exe"
    curl -L -o "%bin_dir%\vs_buildtools.exe" "https://aka.ms/vs/17/release/vs_BuildTools.exe"
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[��Ϣ]%reset% ���ڰ�װ Visual Studio BuildTools 2022...
start "" "%bin_dir%\vs_buildtools.exe" --norestart --passive --downloadThenInstall --includeRecommended --add Microsoft.VisualStudio.Workload.NativeDesktop --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Workload.MSBuildTools
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[��Ϣ]%reset% %green_fg_strong%��װ���:%reset%
pause

REM Prompt user to restart
echo ��������������...
timeout /t 5
cd /d %stl_root%
start %stl_root%Launcher.bat
exit