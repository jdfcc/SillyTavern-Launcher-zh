@echo off

:install_yq
title STL [安装-YQ]
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% 正在安装 yq...
winget install -e --id MikeFarah.yq
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%yq 已安装.%reset%

REM Prompt user to restart
echo 正在重启启动器...
timeout /t 5
cd /d %stl_root%
start %stl_root%Launcher.bat
exit