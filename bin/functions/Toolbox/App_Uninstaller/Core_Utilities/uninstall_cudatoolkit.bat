@echo off

:uninstall_cudatoolkit
title STL [UNINSTALL-CUDATOOLKIT]
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[��Ϣ]%reset% Uninstalling CUDA Toolkit...
winget uninstall --id Nvidia.CUDA
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[��Ϣ]%reset% %green_fg_strong%CUDA Toolkit has been uninstalled successfully.%reset%
pause
goto :app_uninstaller_core_utilities