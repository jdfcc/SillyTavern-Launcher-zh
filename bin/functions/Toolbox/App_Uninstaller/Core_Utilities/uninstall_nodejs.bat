@echo off

:uninstall_nodejs
title STL [UNINSTALL-NODEJS]
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[��Ϣ]%reset% Uninstalling Node.js...
winget uninstall --id OpenJS.NodeJS
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[��Ϣ]%reset% %green_fg_strong%Node.js has been uninstalled successfully.%reset%
goto :app_uninstaller_core_utilities