@echo off

:install_nodejs
title STL [INSTALL NODEJS]
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[��Ϣ]%reset% ���ڰ�װ Node.js...
winget install -e --id OpenJS.NodeJS
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[��Ϣ]%reset% %green_fg_strong%Node.js�Ѱ�װ.%reset%

REM Prompt user to restart
echo ��������������...
timeout /t 5
cd /d %stl_root%
start %stl_root%Launcher.bat
exit