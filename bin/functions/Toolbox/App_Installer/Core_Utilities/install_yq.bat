@echo off

:install_yq
title STL [��װ-YQ]
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% ���ڰ�װ yq...
winget install -e --id MikeFarah.yq
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%yq �Ѱ�װ.%reset%

REM Prompt user to restart
echo ��������������...
timeout /t 5
cd /d %stl_root%
start %stl_root%Launcher.bat
exit