@echo off

:install_nodejs
title STL [INSTALL NODEJS]
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在安装 Node.js...
winget install -e --id OpenJS.NodeJS
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%Node.js已安装.%reset%

REM Prompt user to restart
echo 正在重启启动器...
timeout /t 5
cd /d %stl_root%
start %stl_root%Launcher.bat
exit