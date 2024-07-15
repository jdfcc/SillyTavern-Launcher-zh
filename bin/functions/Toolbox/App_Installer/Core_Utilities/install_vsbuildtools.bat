@echo off

:install_vsbuildtools
REM Check if file exists
if not exist "%bin_dir%\vs_buildtools.exe" (
    REM Check if the folder exists
    if not exist "%bin_dir%" (
        mkdir "%bin_dir%"
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 创建文件夹: "bin"  
    ) else (
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息] "bin" 文件夹已存在.%reset%
    )
    curl -L -o "%bin_dir%\vs_buildtools.exe" "https://aka.ms/vs/17/release/vs_BuildTools.exe"
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息] "vs_buildtools.exe"文件已存在，正在下载最新版本...%reset%
    del "%bin_dir%\vs_buildtools.exe"
    curl -L -o "%bin_dir%\vs_buildtools.exe" "https://aka.ms/vs/17/release/vs_BuildTools.exe"
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在安装 Visual Studio BuildTools 2022...
start "" "%bin_dir%\vs_buildtools.exe" --norestart --passive --downloadThenInstall --includeRecommended --add Microsoft.VisualStudio.Workload.NativeDesktop --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Workload.MSBuildTools
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%安装完成:%reset%
pause

REM Prompt user to restart
echo 正在重启启动器...
timeout /t 5
cd /d %stl_root%
start %stl_root%Launcher.bat
exit