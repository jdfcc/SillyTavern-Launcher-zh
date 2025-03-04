@echo off
REM SillyTavern Launcher (STL)
REM 作者: Deffcolony
REM 汉化：你喜欢什么芝士
REM 描述:
REM 此脚本可以启动、备份和卸载应用程序
REM
REM 此脚本用于windows系统
REM 发现任何问题或BUG。报告 以下GitHub 仓库
REM
REM GitHub: https://github.com/vircus/SillyTavern-Launcher-zh
REM Issues: https://github.com/vircus/SillyTavern-Launcher-zh/issues
title STL [启动检查]
setlocal

set "stl_version=1.2.1"
set "stl_title_pid=STL [TROUBLESHOOTING]"

REM ANSI编码的颜色
set "reset=[0m"

REM 前景色
set "white_fg_strong=[90m"
set "red_fg_strong=[91m"
set "green_fg_strong=[92m"
set "yellow_fg_strong=[93m"
set "blue_fg_strong=[94m"
set "magenta_fg_strong=[95m"
set "cyan_fg_strong=[96m"

REM 正常背景色
set "red_bg=[41m"
set "blue_bg=[44m"
set "yellow_bg=[43m"

REM 环境变量 (winget)
set "winget_path=%userprofile%\AppData\Local\Microsoft\WindowsApps"

REM 环境变量 (miniconda3)
set "miniconda_path=%userprofile%\miniconda3"
set "miniconda_path_mingw=%userprofile%\miniconda3\Library\mingw-w64\bin"
set "miniconda_path_usrbin=%userprofile%\miniconda3\Library\usr\bin"
set "miniconda_path_bin=%userprofile%\miniconda3\Library\bin"
set "miniconda_path_scripts=%userprofile%\miniconda3\Scripts"

REM Environment Variables (7-Zip)
set "zip7_version=7z2301-x64"
set "zip7_install_path=%ProgramFiles%\7-Zip"
set "zip7_download_path=%TEMP%\%zip7_version%.exe"

REM Environment Variables (FFmpeg)
set "ffmpeg_download_url=https://www.gyan.dev/ffmpeg/builds/ffmpeg-git-full.7z"
set "ffmpeg_download_path=%~dp0bin\ffmpeg.7z"
set "ffmpeg_install_path=C:\ffmpeg"
set "ffmpeg_path_bin=%ffmpeg_install_path%\bin"

REM Environment Variables (w64devkit)
set "w64devkit_download_url=https://github.com/skeeto/w64devkit/releases/download/v1.22.0/w64devkit-1.22.0.zip"
set "w64devkit_download_path=%~dp0bin\w64devkit-1.22.0.zip"
set "w64devkit_install_path=C:\w64devkit"
set "w64devkit_path_bin=%w64devkit_install_path%\bin"

REM Environment Variables (Node.js)
set "node_installer_path=%temp%\NodejsInstaller.msi"

REM Define variables to track module status (EXTRAS)
set "extras_modules_path=%~dp0bin\settings\modules-extras.txt"
set "cuda_trigger=false"
set "rvc_trigger=false"
set "talkinghead_trigger=false"
set "caption_trigger=false"
set "summarize_trigger=false"
set "listen_trigger=false"
set "whisper_trigger=false"
set "edge_tts_trigger=false"
set "websearch_trigger=false"

REM Define variables to track module status (XTTS)
set "xtts_modules_path=%~dp0bin\settings\modules-xtts.txt"
set "xtts_cuda_trigger=false"
set "xtts_hs_trigger=false"
set "xtts_deepspeed_trigger=false"
set "xtts_cache_trigger=false"
set "xtts_listen_trigger=false"
set "xtts_model_trigger=false"

REM Define variables to track module status (STABLE DIFUSSION WEBUI)
set "sdwebui_modules_path=%~dp0bin\settings\modules-sdwebui.txt"
set "sdwebui_autolaunch_trigger=false"
set "sdwebui_api_trigger=false"
set "sdwebui_listen_trigger=false"
set "sdwebui_port_trigger=false"
set "sdwebui_optsdpattention_trigger=false"
set "sdwebui_themedark_trigger=false"
set "sdwebui_skiptorchcudatest_trigger=false"
set "sdwebui_lowvram_trigger=false"
set "sdwebui_medvram_trigger=false"

REM Define variables to track module status (TEXT GENERATION WEBUI OOBABOOGA)
set "ooba_modules_path=%~dp0bin\settings\modules-ooba.txt"
set "ooba_autolaunch_trigger=false"
set "ooba_extopenai_trigger=false"
set "ooba_listen_trigger=false"
set "ooba_listenport_trigger=false"
set "ooba_apiport_trigger=false"
set "ooba_verbose_trigger=false"

REM Define variables for install locations (核心app)
set "stl_root=%~dp0"
set "st_install_path=%~dp0SillyTavern"
set "extras_install_path=%~dp0SillyTavern-extras"
set "st_backup_path=%~dp0SillyTavern-backups"

REM Define variables for install locations (图片生成)
set "image_generation_dir=%~dp0image-generation"
set "sdwebui_install_path=%image_generation_dir%\stable-diffusion-webui"
set "sdwebuiforge_install_path=%image_generation_dir%\stable-diffusion-webui-forge"
set "comfyui_install_path=%image_generation_dir%\ComfyUI"
set "fooocus_install_path=%image_generation_dir%\Fooocus"

REM Define variables for install locations (文本生成)
set "text_completion_dir=%~dp0text-completion"
set "ooba_install_path=%text_completion_dir%\text-generation-webui"
set "koboldcpp_install_path=%text_completion_dir%\dev-koboldcpp"
set "llamacpp_install_path=%text_completion_dir%\dev-llamacpp"
set "tabbyapi_install_path=%text_completion_dir%\tabbyAPI"

REM Define variables for install locations (语音生成)
set "voice_generation_dir=%~dp0voice-generation"
set "alltalk_install_path=%voice_generation_dir%\alltalk_tts"
set "xtts_install_path=%voice_generation_dir%\xtts"
set "rvc_install_path=%voice_generation_dir%\Retrieval-based-Voice-Conversion-WebUI"

REM Define variables for the core directories
set "bin_dir=%~dp0bin"
set "log_dir=%bin_dir%\logs"
set "functions_dir=%bin_dir%\functions"

REM Define variables for the directories for Toolbox
set "toolbox_dir=%functions_dir%\Toolbox"
set "troubleshooting_dir=%toolbox_dir%\Troubleshooting"
set "backup_dir=%toolbox_dir%\Backup"

REM Define variables for the directories for APP安装
set "app_installer_image_generation_dir=%functions_dir%\Toolbox\App_Installer\Image_Generation"
set "app_installer_text_completion_dir=%functions_dir%\Toolbox\App_Installer\Text_Completion"
set "app_installer_voice_generation_dir=%functions_dir%\Toolbox\App_Installer\Voice_Generation"
set "app_installer_core_utilities_dir=%functions_dir%\Toolbox\App_Installer\Core_Utilities"

REM Define variables for the directories for APP卸载
set "app_uninstaller_image_generation_dir=%functions_dir%\Toolbox\App_Uninstaller\Image_Generation"
set "app_uninstaller_text_completion_dir=%functions_dir%\Toolbox\App_Uninstaller\Text_Completion"
set "app_uninstaller_voice_generation_dir=%functions_dir%\Toolbox\App_Uninstaller\Voice_Generation"
set "app_uninstaller_core_utilities_dir=%functions_dir%\Toolbox\App_Uninstaller\Core_Utilities"

REM Define variables for the directories for Editor
set "editor_image_generation_dir=%functions_dir%\Toolbox\Editor\Image_Generation"
set "editor_text_completion_dir=%functions_dir%\Toolbox\Editor\Text_Completion"
set "editor_voice_generation_dir=%functions_dir%\Toolbox\Editor\Voice_Generation"
set "editor_core_utilities_dir=%functions_dir%\Toolbox\Editor\Core_Utilities"

REM Define variables for logging
set "logs_stl_console_path=%log_dir%\stl.log"
set "logs_st_console_path=%log_dir%\st_console_output.log"


REM Create the logs folder if it doesn't exist
if not exist "%log_dir%" (
    mkdir "%log_dir%"
)

set "log_invalidinput=[错误] 输入无效。请输入一个有效数字."
set "echo_invalidinput=%red_fg_strong%[错误] 输入无效。请输入一个有效数字.%reset%"

cd /d "%~dp0"

REM Check if folder path has no spaces
echo "%CD%"| findstr /C:" " >nul && (
    echo %red_fg_strong%[错误] 路径不能有空格！请将其删除或替换为: - %reset%
    echo 包含空格的文件夹会使启动器不稳定
    echo path: %red_bg%%~dp0%reset%
    pause
    exit /b 1
)

REM Check if folder path has no special characters
echo "%CD%"| findstr /R /C:"[!#\$%&()\*+,;<=>?@\[\]\^`{|}~]" >nul && (
    echo %red_fg_strong%[错误] 路径不能有特殊字符！请删除它们.%reset%
    echo 包含特殊字符的文件夹会使启动器在以下情况下不稳定: "[!#\$%&()\*+,;<=>?@\[\]\^`{|}~]" 
    echo path: %red_bg%%~dp0%reset%
    pause
    exit /b 1
)

REM Check if launcher has updates
title STL [更新ST-Launcher]
git fetch origin
for /f %%i in ('git branch --show-current') do set stl_current_branch=%%i
REM Get the list of commits between local and remote branch
for /f %%i in ('git rev-list HEAD..%stl_current_branch%@{upstream}') do (
    goto :startupcheck_found_update
)

REM If no updates are available, skip the update process
echo [ %green_fg_strong%OK%reset% ] SillyTavern-Launcher 是最新的.%reset%
goto :startupcheck_no_update

:startupcheck_found_update
cls
echo %blue_fg_strong%[信息]%reset% %cyan_fg_strong%SillyTavern Launcher的新更新可用!(没试过更新，更新后可能失去汉化)%reset%
set /p "update_choice=现在更新? [Y/n]: "
if /i "%update_choice%"=="" set update_choice=Y
if /i "%update_choice%"=="Y" (
    REM Update the repository
    git pull
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%SillyTavern-Launcher 更新成功. 正在重启 launcher...%reset%
    timeout /t 10
    start launcher.bat
    exit
) else (
    goto :startupcheck_no_update
)



:startupcheck_no_update
title STL [启动检查]
REM Check if the folder exists
if not exist "%~dp0bin" (
    mkdir "%~dp0bin"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% Created folder: "bin"  
)
REM Check if the folder exists
if not exist "%~dp0bin\settings" (
    mkdir "%~dp0bin\settings"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% Created folder: "settings"  
)


REM Create modules-extras if it doesn't exist
if not exist %extras_modules_path% (
    type nul > %extras_modules_path%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% Created text file: "modules-extras.txt"  
)
REM Load modules-extras flags from modules
for /f "tokens=*" %%a in (%extras_modules_path%) do set "%%a"


REM Create modules-xtts if it doesn't exist
if not exist %xtts_modules_path% (
    type nul > %xtts_modules_path%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% Created text file: "modules-xtts.txt"  
)
REM Load modules-xtts flags from modules-xtts
for /f "tokens=*" %%a in (%xtts_modules_path%) do set "%%a"


REM Create modules-sdwebui if it doesn't exist
if not exist %sdwebui_modules_path% (
    type nul > %sdwebui_modules_path%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% Created text file: "modules-sdwebui.txt"  
)
REM Load modules-xtts flags from modules-xtts
for /f "tokens=*" %%a in (%sdwebui_modules_path%) do set "%%a"


REM Create modules-ooba if it doesn't exist
if not exist %ooba_modules_path% (
    type nul > %ooba_modules_path%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% Created text file: "modules-ooba.txt"  
)
REM Load modules-ooba flags from modules-ooba
for /f "tokens=*" %%a in (%ooba_modules_path%) do set "%%a"


REM Get the current PATH value from the registry
for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v PATH') do set "current_path=%%B"

REM Check if the paths are already in the current PATH
echo %current_path% | find /i "%winget_path%" > nul
set "ff_path_exists=%errorlevel%"

setlocal enabledelayedexpansion

REM Append the new paths to the current PATH only if they don't exist
if %ff_path_exists% neq 0 (
    set "new_path=%current_path%;%winget_path%"
    echo.
    echo [DEBUG] "current_path is:%cyan_fg_strong% %current_path%%reset%"
    echo.
    echo [DEBUG] "winget_path is:%cyan_fg_strong% %winget_path%%reset%"
    echo.
    echo [DEBUG] "new_path is:%cyan_fg_strong% !new_path!%reset%"

    REM Update the PATH value in the registry
    reg add "HKCU\Environment" /v PATH /t REG_EXPAND_SZ /d "!new_path!" /f

    REM Update the PATH value for the current session
    setx PATH "!new_path!" > nul
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%winget 添加进系统变量 PATH.%reset%
) else (
    set "new_path=%current_path%"
    echo [ %green_fg_strong%OK%reset% ] 找到系统变量 PATH: winget%reset%
)

REM Check if winget is installed; if not, then install it
winget --version > nul 2>&1
if %errorlevel% neq 0 (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[警告] winget 没有安装.%reset%
    REM Check if the folder exists
    if not exist "%~dp0bin" (
        mkdir "%~dp0bin"
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 创建目录: "bin"  
    ) else (
        echo [ %green_fg_strong%OK%reset% ] 发现目录: "bin"%reset%
    )
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在安装 winget...
    curl -L -o "%~dp0bin\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    start "" "%~dp0bin\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%winget 成功安装. 请重启启动器.%reset%
    pause
    exit
) else (
    echo [ %green_fg_strong%OK%reset% ] Found app: %cyan_fg_strong%winget%reset%
)

REM Check if Git is installed if not then install git
git --version > nul 2>&1
if %errorlevel% neq 0 (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[警告] Git 未安装.%reset%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在用 winget 安装 Git...
    winget install -e --id Git.Git
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%Git is installed. 请重启启动器.%reset%
    pause
    exit
) else (
    echo [ %green_fg_strong%OK%reset% ] Found app: %cyan_fg_strong%Git%reset%
)

REM Get the current PATH value from the registry
for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v PATH') do set "current_path=%%B"

REM Check if the paths are already in the current PATH
echo %current_path% | find /i "%miniconda_path%" > nul
set "ff_path_exists=%errorlevel%"

REM Append the new paths to the current PATH only if they don't exist
if %ff_path_exists% neq 0 (
    set "new_path=%current_path%;%miniconda_path%;%miniconda_path_mingw%;%miniconda_path_usrbin%;%miniconda_path_bin%;%miniconda_path_scripts%"
    echo.
    echo [DEBUG] "current_path is:%cyan_fg_strong% %current_path%%reset%"
    echo.
    echo [DEBUG] "miniconda_path is:%cyan_fg_strong% %miniconda_path%%reset%"
    echo.
    echo [DEBUG] "new_path is:%cyan_fg_strong% !new_path!%reset%"

    REM Update the PATH value in the registry
    reg add "HKCU\Environment" /v PATH /t REG_EXPAND_SZ /d "!new_path!" /f

    REM Update the PATH value for the current session
    setx PATH "!new_path!" > nul
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%miniconda3 added to PATH.%reset%
) else (
    set "new_path=%current_path%"
    echo [ %green_fg_strong%OK%reset% ] Found PATH: miniconda3%reset%
)

REM Check if Miniconda3 is installed if not then install Miniconda3
call conda --version > nul 2>&1
if %errorlevel% neq 0 (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[警告] Miniconda3 未安装. 不能找到命令: conda%reset%
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 检查Miniconda3是否存在于应用程序列表中...
    winget uninstall --id Anaconda.Miniconda3
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在用 winget 安装 Miniconda3...
    winget install -e --id Anaconda.Miniconda3
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%Miniconda3 成功安装. Please restart the Installer.%reset%
    pause
    exit
) else (
    echo [ %green_fg_strong%OK%reset% ] Found app: %cyan_fg_strong%Miniconda3%reset%
)

REM Run PowerShell command to retrieve VRAM size and divide by 1GB
for /f "usebackq tokens=*" %%i in (`powershell -Command "$qwMemorySize = (Get-ItemProperty -Path 'HKLM:\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0*' -Name HardwareInformation.qwMemorySize -ErrorAction SilentlyContinue).'HardwareInformation.qwMemorySize'; if ($null -ne $qwMemorySize -and $qwMemorySize -is [array]) { $qwMemorySize = [double]$qwMemorySize[0] } else { $qwMemorySize = [double]$qwMemorySize }; if ($null -ne $qwMemorySize) { [math]::Round($qwMemorySize/1GB) } else { 'Property not found' }"`) do (
    set "VRAM=%%i"
)

REM Check if the SillyTavern folder exists
if not exist "%st_install_path%" (
    set "update_status_st=%red_bg%[错误] SillyTavern 没找到 in: "%~dp0"%reset%"
    goto :no_st_install_path
)


REM Change the current directory to 'sillytavern' folder
cd /d "%st_install_path%"

REM Check for updates
git fetch origin

REM Get the list of commits between local and remote branch
for /f %%i in ('git rev-list HEAD..%current_branch%@{upstream}') do (
    set "update_status_st=%yellow_fg_strong%Update Available%reset%"
    goto :found_update
)

set "update_status_st=%green_fg_strong%Up to Date%reset%"
:found_update

REM ############################################################
REM ################## HOME - FRONTEND #########################
REM ############################################################
:home
:no_st_install_path
cd /d "%st_install_path%"
title STL [主页]
cls

set "SSL_INFO_FILE=%~dp0\SillyTavern\certs\SillyTavernSSLInfo.txt"
set "sslOptionSuffix="

REM Check if the SSL info file exists and set the suffix
if exist "%SSL_INFO_FILE%" (
    set "sslOptionSuffix= (With SSL)"
)

echo %blue_fg_strong%/ 主页%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?
echo 1. 启动 SillyTavern%sslOptionSuffix%
echo 2. 启动 SillyTavern 且移除 Cloudflare link %sslOptionSuffix%
REM Check if the custom shortcut file exists and is not empty
set "custom_name=Create Custom App Shortcut to Launch with SillyTavern"  ; Initialize to default
if exist "%~dp0bin\settings\custom-shortcut.txt" (
    set /p custom_name=<"%~dp0bin\settings\custom-shortcut.txt"
    if "!custom_name!"=="" set "custom_name=Create Custom Shortcut"
)
echo 3. %custom_name%
echo 4. 更新管理选项
echo 5. 工具箱
echo 6. 支持
echo 7. 查看本机GPU可以运行的更多LLM模型。
echo 0. 退出

echo =========== 版本状态 =============
REM Get the current Git branch
for /f %%i in ('git branch --show-current') do set current_branch=%%i
echo SillyTavern branch: %cyan_fg_strong%%current_branch%%reset%
echo SillyTavern: %update_status_st%
echo STL 版本: %stl_version%
echo GPU 显存: %cyan_fg_strong%%VRAM% GB%reset%
echo =================================

set "choice="
set /p "choice=选择 (默认 1): "

REM Default to choice 1 if no input is provided
if not defined choice set "choice=1"

REM ################## HOME - BACKEND #########################
if "%choice%"=="1" (
    call %functions_dir%\launch\start_st.bat
    if %errorlevel% equ 1 goto :home
) else if "%choice%"=="2" (
    start "" "%~dp0SillyTavern\Remote-Link.cmd"
    echo "SillyTavern Remote Link Cloudflare Tunnel Launched"
    call %functions_dir%\launch\start_st.bat
    if %errorlevel% equ 1 goto :home
) else if "%choice%"=="3" (
    if exist "%~dp0bin\settings\custom-shortcut.txt" (
        call :launch_custom_shortcut
    ) else (
        call :create_custom_shortcut
    )
) else if "%choice%"=="4" (
    call :update_manager
) else if "%choice%"=="5" (
    call :toolbox
) else if "%choice%"=="6" (
    call :support
) else if "%choice%"=="7" (
    set "caller=home"
    if exist "%functions_dir%\launch\info_vram.bat" (
        call %functions_dir%\launch\info_vram.bat
        goto :home
    ) else (
        echo [%DATE% %TIME%] 错误: info_vram.bat 没找到 in: %functions_dir%\launch >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] info_vram.bat 没找到 in: %functions_dir%\launch%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 运行自动修复...
        git pull
        pause
        goto :home
    )
) else if "%choice%"=="0" (
    set "caller=home"
    if exist "%functions_dir%\launch\exit_stl.bat" (
        call %functions_dir%\launch\exit_stl.bat
        goto :home
    ) else (
        echo [%DATE% %TIME%] 错误: exit_stl.bat 没找到 in: %functions_dir%\launch >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] exit_stl.bat 没找到 in: %functions_dir%\launch%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 运行自动修复...
        git pull
        pause
        goto :home
    )
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :home
)
goto :home

REM ############################################################
REM ############## 更新管理选项 - FRONTEND ###################
REM ############################################################
:update_manager
title STL [更新管理选项]
cls
echo %blue_fg_strong%/ 主页 / 更新管理选项%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?

echo 1. 文本生成
echo 2. 语音生成
echo 3. 图片生成
echo 4. 核心app
echo 0. 返回

set /p update_manager_choice=选择: 

REM ############## 更新管理选项 - BACKEND ####################
if "%update_manager_choice%"=="1" (
    call :update_manager_text_completion
) else if "%update_manager_choice%"=="2" (
    call :update_manager_voice_generation
) else if "%update_manager_choice%"=="3" (
    call :update_manager_image_generation
) else if "%update_manager_choice%"=="4" (
    call :update_manager_core_utilities
) else if "%update_manager_choice%"=="0" (
    goto :home
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :update_manager
)


REM ############################################################
REM ########## 更新管理选项 文本生成 - FRONTEND #######
REM ############################################################
:update_manager_text_completion
title STL [文本生成更新管理选项]
cls
echo %blue_fg_strong%/ 主页 / 更新管理选项 / 文本生成%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?

echo 1. 更新 Text generation web UI (oobabooga)
echo 2. 更新 koboldcpp
echo 3. 更新 TabbyAPI
echo 0. 返回

set /p update_manager_txt_comp_choice=选择: 

REM ########## 更新管理选项 文本生成 - BACKEND #########
if "%update_manager_txt_comp_choice%"=="1" (
    call :update_ooba
) else if "%update_manager_txt_comp_choice%"=="2" (
    call :update_koboldcpp
) else if "%update_manager_txt_comp_choice%"=="3" (
    call :update_tabbyapi
) else if "%update_manager_txt_comp_choice%"=="0" (
    goto :update_manager
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :update_manager_text_completion
)

:update_ooba
REM Check if text-generation-webui directory exists
if not exist "%ooba_install_path%" (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[警告] text-generation-webui 目录没有发现，跳过更新.%reset%
    pause
    goto :update_manager_text_completion
)

REM Update text-generation-webui
set max_retries=3
set retry_count=0

:retry_update_ooba
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在更新 text-generation-webui...
cd /d "%ooba_install_path%"
call git pull
if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[警告] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_update_ooba
    echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] 更新失败 text-generation-webui repository after %max_retries% retries.%reset%
    pause
    goto :update_manager_text_completion
)

start "" "update_wizard_windows.bat"
echo When the update is finished:
pause
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%text-generation-webui 更新成功.%reset%
pause
goto :update_manager_text_completion

:update_koboldcpp
REM Check if dev-koboldcpp directory exists
if not exist "%koboldcpp_install_path%" (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[警告] dev-koboldcpp 目录没有发现，跳过更新.%reset%
    pause
    goto :update_manager_text_completion
)

REM Check if koboldcpp file exists [koboldcpp NVIDIA]
if exist "%koboldcpp_install_path%\koboldcpp.exe" (
    REM Remove koboldcpp
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 删除现有 koboldcpp.exe
    del "%koboldcpp_install_path%\koboldcpp.exe"
    curl -L -o "%koboldcpp_install_path%\koboldcpp.exe" "https://github.com/LostRuins/koboldcpp/releases/latest/download/koboldcpp.exe"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%koboldcpp 更新成功.%reset%
    pause
    goto :update_manager_text_completion
)
REM Check if koboldcpp file exists [koboldcpp AMD]
if exist "%koboldcpp_install_path%\koboldcpp_rocm.exe" (
    REM Remove koboldcpp_rocm
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 删除现有 koboldcpp_rocm.exe
    del "%koboldcpp_install_path%\koboldcpp_rocm.exe"
    curl -L -o "%koboldcpp_install_path%\koboldcpp_rocm.exe" "https://github.com/YellowRoseCx/koboldcpp-rocm/releases/latest/download/koboldcpp_rocm.exe"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%koboldcpp_rocm 更新成功.%reset%
    pause
    goto :update_manager_text_completion
)


:update_tabbyapi
REM Check if tabbyAPI directory exists
if not exist "%tabbyapi_install_path%" (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[警告] tabbyAPI 目录没有发现，跳过更新.%reset%
    pause
    goto :update_manager_text_completion
)

REM Update tabbyAPI
set max_retries=3
set retry_count=0

:retry_update_tabbyapi
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在更新 tabbyAPI...
cd /d "%tabbyapi_install_path%"
call git pull
if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[警告] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_update_tabbyapi
    echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] 更新失败 tabbyAPI repository after %max_retries% retries.%reset%
    pause
    goto :update_manager_text_completion
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%tabbyAPI 更新成功.%reset%
pause
goto :update_manager_text_completion


REM ############################################################
REM ########## 更新管理选项 语音生成 - FRONTEND ######
REM ############################################################
:update_manager_voice_generation
title STL [更新管理选项 语音生成]
cls
echo %blue_fg_strong%/ 主页 / 更新管理选项 / 语音生成%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?

echo 1. 更新 AllTalk
echo 2. 更新 XTTS
echo 3. 更新 RVC
echo 0. 返回

set /p update_manager_voice_gen_choice=选择: 

REM ########## 更新管理选项 文本生成 - BACKEND ########
if "%update_manager_voice_gen_choice%"=="1" (
    call :update_alltalk
) else if "%update_manager_voice_gen_choice%"=="2" (
    call :update_xtts
) else if "%update_manager_voice_gen_choice%"=="3" (
    call :update_rvc
) else if "%update_manager_voice_gen_choice%"=="0" (
    goto :update_manager
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :update_manager_voice_generation
)

:update_alltalk
REM Check if alltalk_tts directory exists
if not exist "%alltalk_install_path%" (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[警告] alltalk_tts 目录没有发现，跳过更新.%reset%
    pause
    goto :update_manager_voice_generation
)

REM Update alltalk_tts
set max_retries=3
set retry_count=0

:retry_update_alltalk
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在更新 alltalk_tts...
cd /d "%alltalk_install_path%"
call git pull
if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[警告] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_update_alltalk
    echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] 更新失败 alltalk_tts repository after %max_retries% retries.%reset%
    pause
    goto :update_manager_voice_generation
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%alltalk_tts 更新成功.%reset%
pause
goto :update_manager_voice_generation


:update_xtts
REM Check if XTTS directory exists
if not exist "%xtts_install_path%" (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[警告] xtts 目录没有发现，跳过更新.%reset%
    pause
    goto :update_manager_voice_generation
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在更新 XTTS...
call conda activate xtts
pip install --upgrade xtts-api-server
call conda deactivate
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%XTTS 更新成功.%reset%
pause
goto :update_manager_voice_generation


:update_rvc
REM Check if the folder exists
if not exist "%rvc_install_path%" (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[警告] Retrieval-based-Voice-Conversion-WebUI 目录没有发现，跳过更新.%reset%
    pause
    goto :update_manager_voice_generation
)

REM Update Retrieval-based-Voice-Conversion-WebUI
set max_retries=3
set retry_count=0

:retry_update_rvc
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在更新 Retrieval-based-Voice-Conversion-WebUI...
cd /d "%rvc_install_path%"
call git pull
if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[警告] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_update_rvc
    echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] 更新失败 Retrieval-based-Voice-Conversion-WebUI repository after %max_retries% retries.%reset%
    pause
    goto :update_manager_voice_generation
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%Retrieval-based-Voice-Conversion-WebUI 更新成功.%reset%
pause
goto :update_manager_voice_generation


REM ############################################################
REM ######## 更新管理选项 图像生成 - FRONTEND ########
REM ############################################################
:update_manager_image_generation
title STL [更新管理 图像生成]
cls
echo %blue_fg_strong%/ 主页 / 更新管理选项 / 图片生成%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?

echo 1. 更新 Stable Diffusion web UI
echo 2. 更新 Stable Diffusion web UI Forge
echo 3. 更新 ComfyUI
echo 4. 更新 Fooocus
echo 0. 返回

set /p update_manager_img_gen_choice=选择: 

REM ######## 更新管理选项 图像生成 - BACKEND #########
if "%update_manager_img_gen_choice%"=="1" (
    call :update_sdwebui
) else if "%update_manager_img_gen_choice%"=="2" (
    goto :update_sdwebuiforge
) else if "%update_manager_img_gen_choice%"=="3" (
    goto :update_comfyui
) else if "%update_manager_img_gen_choice%"=="4" (
    goto :update_fooocus
) else if "%update_manager_img_gen_choice%"=="0" (
    goto :update_manager
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :update_manager_image_generation
)

:update_sdwebui
REM Check if the folder exists
if not exist "%sdwebui_install_path%" (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[警告] stable-diffusion-webui 目录没有发现，跳过更新.%reset%
    pause
    goto :update_manager_image_generation
)

REM Update stable-diffusion-webui
set max_retries=3
set retry_count=0

:retry_update_sdwebui
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在更新 stable-diffusion-webui...
cd /d "%sdwebui_install_path%"
call git pull
if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[警告] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_update_sdwebui
    echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] 更新失败 stable-diffusion-webui repository after %max_retries% retries.%reset%
    pause
    goto :update_manager_image_generation
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%stable-diffusion-webui 更新成功.%reset%
pause
goto :update_manager_image_generation


:update_sdwebuiforge
REM Check if the folder exists
if not exist "%sdwebuiforge_install_path%" (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[警告] stable-diffusion-webui-forge 目录没有发现，跳过更新.%reset%
    pause
    goto :update_manager_image_generation
)

REM Update stable-diffusion-webui-forge
set max_retries=3
set retry_count=0

:retry_update_sdwebuiforge
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在更新 stable-diffusion-webui-forge...
cd /d "%sdwebuiforge_install_path%"
call git pull
if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[警告] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_update_sdwebuiforge
    echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] 更新失败 stable-diffusion-webui-forge repository after %max_retries% retries.%reset%
    pause
    goto :update_manager_image_generation
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%stable-diffusion-webui-forge 更新成功.%reset%
pause
goto :update_manager_image_generation


:update_comfyui
REM Check if the folder exists
if not exist "%comfyui_install_path%" (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[警告] ComfyUI 目录没有发现，跳过更新.%reset%
    pause
    goto :update_manager_image_generation
)

REM Update ComfyUI
set max_retries=3
set retry_count=0

:retry_update_comfyui
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在更新 ComfyUI...
cd /d "%comfyui_install_path%"
call git pull
if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[警告] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_update_comfyui
    echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] 更新失败 ComfyUI repository after %max_retries% retries.%reset%
    pause
    goto :update_manager_image_generation
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%ComfyUI 更新成功.%reset%
pause
goto :update_manager_image_generation


:update_fooocus
REM Check if the folder exists
if not exist "%fooocus_install_path%" (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[警告] Fooocus 目录没有发现，跳过更新.%reset%
    pause
    goto :update_manager_image_generation
)

REM Update Fooocus
set max_retries=3
set retry_count=0

:retry_update_fooocus
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在更新 Fooocus...
cd /d "%fooocus_install_path%"
call git pull
if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[警告] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_update_fooocus
    echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] 更新失败 Fooocus repository after %max_retries% retries.%reset%
    pause
    goto :update_manager_image_generation
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%Fooocus 更新成功.%reset%
pause
goto :update_manager_image_generation


REM ############################################################
REM ######## 更新管理选项 CORE UTILITIES - FRONTEND #########
REM ############################################################
:update_manager_core_utilities
title STL [更新管理 核心APP]
cls
echo %blue_fg_strong%/ 主页 / 更新管理 / 核心app%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?
echo 1. 更新 SillyTavern
echo 2. 更新 Extras
echo 3. 更新 7-Zip
echo 4. 更新 FFmpeg
echo 5. 更新 Node.js
echo 6. 更新 yq
echo 0. 返回

set /p update_manager_core_util_choice=选择: 

REM ######## 更新管理选项 CORE UTILITIES - BACKEND #########
if "%update_manager_core_util_choice%"=="1" (
    call :update_st
) else if "%update_manager_core_util_choice%"=="2" (
    call :update_extras
) else if "%update_manager_core_util_choice%"=="3" (
    call :update_7zip
) else if "%update_manager_core_util_choice%"=="4" (
    call :update_ffmpeg
) else if "%update_manager_core_util_choice%"=="5" (
    call :update_nodejs
) else if "%update_manager_core_util_choice%"=="6" (
    call :update_yq
) else if "%update_manager_core_util_choice%"=="0" (
    goto :update_manager
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :update_manager_core_utilities
)

:update_st
REM Check if SillyTavern directory exists
if not exist "%st_install_path%" (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[警告] SillyTavern 目录没有发现，跳过更新.%reset%
    pause
    goto :update_manager_core_utilities
)

REM Update SillyTavern
set max_retries=3
set retry_count=0

:retry_update_st
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在更新 SillyTavern...
cd /d "%st_install_path%"
call git pull
if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[警告] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_update_st
    echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] 更新失败 SillyTavern repository after %max_retries% retries.%reset%
    pause
    goto :update_manager_core_utilities
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%SillyTavern 更新成功.%reset%
pause
goto :update_manager_core_utilities


:update_extras
REM Check if SillyTavern-extras directory exists
if not exist "%extras_install_path%" (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[警告] SillyTavern-extras 目录没有发现，跳过更新.%reset%
    pause
    goto :update_manager_core_utilities
)

REM Update SillyTavern-extras
set max_retries=3
set retry_count=0

:retry_update_extras
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在更新 SillyTavern-extras...
cd /d "%extras_install_path%"
call git pull
if %errorlevel% neq 0 (
    set /A retry_count+=1
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[警告] Retry %retry_count% of %max_retries%%reset%
    if %retry_count% lss %max_retries% goto :retry_update_extras
    echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] 更新失败 SillyTavern-extras repository after %max_retries% retries.%reset%
    pause
    goto :update_manager_core_utilities
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%SillyTavern-extras 更新成功.%reset%
pause
goto :update_manager_core_utilities


:update_7zip
winget upgrade 7zip.7zip
pause
goto :update_manager_core_utilities


:update_ffmpeg
REM Check if 7-Zip is installed
7z > nul 2>&1
if %errorlevel% neq 0 (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] 7z command 没找到 in PATH.%reset%
    echo %red_fg_strong%7-Zip 未安装或没找到 in the system PATH.%reset%
    echo %red_fg_strong%To install 7-Zip go to:%reset% %blue_bg%/ 工具箱 / APP安装 / 核心app / 安装 7-Zip%reset%
    pause
    goto :app_installer_core_utilities
)

REM Check if the folder exists
if exist "%ffmpeg_install_path%" (
    REM Remove ffmpeg folder if it already exist
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 删除现有 ffmpeg 安装信息...
    rmdir /s /q "%ffmpeg_install_path%
)


echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在下载 FFmpeg 存档文件...
curl -L -o "%ffmpeg_download_path%" "%ffmpeg_download_url%"

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 创建 ffmpeg 目录...
if not exist "%ffmpeg_install_path%" (
    mkdir "%ffmpeg_install_path%"
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 提取 FFmpeg 存档文件...
7z x "%ffmpeg_download_path%" -o"%ffmpeg_install_path%"


echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在移动 FFmpeg 内容到 C:\ffmpeg...
for /d %%i in ("%ffmpeg_install_path%\ffmpeg-*-full_build") do (
    xcopy "%%i\bin" "%ffmpeg_install_path%\bin" /E /I /Y
    xcopy "%%i\doc" "%ffmpeg_install_path%\doc" /E /I /Y
    xcopy "%%i\presets" "%ffmpeg_install_path%\presets" /E /I /Y
    rd "%%i" /S /Q
)

del "%ffmpeg_download_path%"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%ffmpeg 更新成功.%reset%
pause
goto :update_manager_core_utilities


:update_nodejs
winget upgrade OpenJS.NodeJS
pause
goto :update_manager_core_utilities


:update_yq
winget upgrade MikeFarah.yq
pause
goto :update_manager_core_utilities



REM ############################################################
REM ################# TOOLBOX - FRONTEND #######################
REM ############################################################
:toolbox
title STL [工具箱]
cls
echo %blue_fg_strong%/ 主页 / 工具箱%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?
REM color 7
echo 1. APP启动选项
echo 2. APP安装选项
echo 3. APP卸载选项
echo 4. 编辑选项
echo 5. 备份
echo 6. 切换分支
echo 7. 故障排除
echo 8. 重置快捷方式
echo 0. 返回

set /p toolbox_choice=选择: 

REM ################# TOOLBOX - BACKEND #######################
if "%toolbox_choice%"=="1" (
    call :app_launcher
) else if "%toolbox_choice%"=="2" (
    call :app_installer
) else if "%toolbox_choice%"=="3" (
    call :app_uninstaller
) else if "%toolbox_choice%"=="4" (
    call :editor
) else if "%toolbox_choice%"=="5" (
    call :backup
) else if "%toolbox_choice%"=="6" (
    call :switch_branch
) else if "%toolbox_choice%"=="7" (
    call :troubleshooting
) else if "%toolbox_choice%"=="8" (
    call :reset_custom_shortcut
) else if "%toolbox_choice%"=="0" (
    goto :home
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :toolbox
)


REM ############################################################
REM ############## APP LAUNCHER - FRONTEND #####################
REM ############################################################
:app_launcher
title STL [APP启动选项]
cls
echo %blue_fg_strong%/ 主页 / 工具箱 / APP启动选项%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?

echo 1. 文本生成
echo 2. 语音生成
echo 3. 图片生成
echo 4. 核心app
echo 0. 返回

set /p app_launcher_choice=选择: 

REM ############## 安装选项 - BACKEND ####################
if "%app_launcher_choice%"=="1" (
    call :app_launcher_text_completion
) else if "%app_launcher_choice%"=="2" (
    call :app_launcher_voice_generation
) else if "%app_launcher_choice%"=="3" (
    call :app_launcher_image_generation
) else if "%app_launcher_choice%"=="4" (
    call :app_launcher_core_utilities
) else if "%app_launcher_choice%"=="0" (
    goto :toolbox
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_launcher
)


REM ############################################################
REM ########## APP LAUNCHER 文本生成 - FRONTEND #########
REM ############################################################
:app_launcher_text_completion
title STL [文本生成APP启动选项]
cls
echo %blue_fg_strong%/ 主页 / 工具箱 / APP启动选项 / 文本生成%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?

echo 1. 启动 Text generation web UI (oobabooga)
echo 2. 启动 koboldcpp
echo 3. 启动 TabbyAPI
echo 0. 返回

set /p app_launcher_txt_comp_choice=选择: 

REM ########## APP LAUNCHER 文本生成 - BACKEND #########
if "%app_launcher_txt_comp_choice%"=="1" (
    call :start_ooba
) else if "%app_launcher_txt_comp_choice%"=="2" (
    call :start_koboldcpp
) else if "%app_launcher_txt_comp_choice%"=="3" (
    call :start_tabbyapi
) else if "%app_launcher_txt_comp_choice%"=="0" (
    goto :app_launcher
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_launcher_text_completion
)

:start_ooba
REM Read modules-ooba and find the ooba_start_command line
set "ooba_start_command="

for /F "tokens=*" %%a in ('findstr /I "ooba_start_command=" "%ooba_modules_path%"') do (
    set "%%a"
)

if not defined ooba_start_command (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] 未启用模块.%reset%
    echo %red_bg%请确保您启用了至少一个“编辑OOBA模块”中的模块.%reset%
    echo.
    echo %blue_bg%我们将把您重定向到编辑OOBA模块菜单.%reset%
    pause
    set "caller=editor_text_completion"
    if exist "%editor_text_completion_dir%\edit_ooba_modules.bat" (
        call %editor_text_completion_dir%\edit_ooba_modules.bat
        goto :app_launcher_text_completion
    ) else (
        echo [%DATE% %TIME%] 错误: edit_ooba_modules.bat 没找到 in: %editor_text_completion_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] edit_ooba_modules.bat 没找到 in: %editor_text_completion_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 运行自动修复...
        git pull
        pause
        goto :app_launcher_text_completion
    )
)

set "ooba_start_command=%ooba_start_command:ooba_start_command=%"

REM Start Text generation web UI oobabooga with desired configurations
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 文本生成web UI oobabooga在新窗口中启动。
cd /d "%ooba_install_path%" && %ooba_start_command%
goto :home


:start_koboldcpp
REM Start koboldcpp with desired configurations
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% koboldcpp在一个新窗口中启动。

cd /d "%koboldcpp_install_path%"
start "" "koboldcpp.exe"
goto :home


:start_tabbyapi
REM Run conda activate from the Miniconda installation
call "%miniconda_path%\Scripts\activate.bat"

REM Activate the extras environment
call conda activate tabbyapi

REM Start TabbyAPI with desired configurations
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% TabbyAPI在新窗口中启动。

start cmd /k "title TabbyAPI && cd /d %tabbyapi_install_path% && python start.py"
goto :home


REM ############################################################
REM ########## APP LAUNCHER 语音生成 - FRONTEND ########
REM ############################################################
:app_launcher_voice_generation
title STL [语音生成APP启动选项]
cls
echo %blue_fg_strong%/ 主页 / 工具箱 / APP启动选项 / 语音生成%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?

echo 1. 启动 AllTalk
echo 2. 启动 XTTS
echo 3. 启动 RVC
echo 0. 返回

set /p app_launcher_voice_gen_choice=选择: 

REM ########## APP LAUNCHER 文本生成 - BACKEND #########
if "%app_launcher_voice_gen_choice%"=="1" (
    call :start_alltalk
) else if "%app_launcher_voice_gen_choice%"=="2" (
    call :start_xtts
) else if "%app_launcher_voice_gen_choice%"=="3" (
    call :start_rvc
) else if "%app_launcher_voice_gen_choice%"=="0" (
    goto :app_launcher
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_launcher_voice_generation
)


:start_alltalk
REM Activate the alltalk environment
call conda activate alltalk

REM Start AllTalk
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% AllTalk 在新窗口中启动。
start cmd /k "title AllTalk && cd /d %alltalk_install_path% && python script.py"
goto :home


:start_xtts
REM Activate the xtts environment
call conda activate xtts

REM Start XTTS
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% XTTS 在新窗口中启动。

REM Read modules-xtts and find the xtts_start_command line
set "xtts_start_command="

for /F "tokens=*" %%a in ('findstr /I "xtts_start_command=" "%xtts_modules_path%"') do (
    set "%%a"
)

if not defined xtts_start_command (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] 未启用模块!%reset%
    echo %red_bg%请确保您启用了至少一个模块 from Edit XTTS Modules.%reset%
    echo.
    echo %blue_bg%我们将把您重定向到 Edit XTTS Modules menu.%reset%
    pause
    goto :edit_xtts_modules
)

set "xtts_start_command=%xtts_start_command:xtts_start_command=%"
start cmd /k "title XTTSv2 API Server && cd /d %xtts_install_path% && %xtts_start_command%"
goto :home


:start_rvc
REM Activate the alltalk environment
call conda activate rvc

REM Start RVC with desired configurations
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% RVC 在新窗口中启动。
start cmd /k "title RVC && cd /d %rvc_install_path% && python infer-web.py --port 7897"
goto :home


REM ############################################################
REM ######## APP LAUNCHER 图像生成 - FRONTEND ##########
REM ############################################################
:app_launcher_image_generation
title STL [图片生成APP启动选项]
cls
echo %blue_fg_strong%/ 主页 / 工具箱 / APP启动选项 / 图片生成%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?

echo 1. 启动 Stable Diffusion web UI
echo 2. 启动 Stable Diffusion web UI Forge
echo 3. 启动 ComfyUI
echo 4. 启动 Fooocus
echo 0. 返回

set /p app_launcher_img_gen_choice=选择: 

REM ######## APP LAUNCHER 图像生成 - BACKEND #########
if "%app_launcher_img_gen_choice%"=="1" (
    call :start_sdwebui
) else if "%app_launcher_img_gen_choice%"=="2" (
    goto :start_sdwebuiforge
) else if "%app_launcher_img_gen_choice%"=="3" (
    goto :start_comfyui
) else if "%app_launcher_img_gen_choice%"=="4" (
    goto :start_fooocus
) else if "%app_launcher_img_gen_choice%"=="0" (
    goto :app_launcher
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_launcher_image_generation
)


:start_sdwebui
cd /d "%sdwebui_install_path%"

REM Run conda activate from the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 激活Miniconda环境...
call "%miniconda_path%\Scripts\activate.bat"

REM Activate the sdwebui environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 激活Conda环境: %cyan_fg_strong%sdwebui%reset%
call conda activate sdwebui


REM Read modules-sdwebui and find the sdwebui_start_command line
set "sdwebui_start_command="

for /F "tokens=*" %%a in ('findstr /I "sdwebui_start_command=" "%sdwebui_modules_path%"') do (
    set "%%a"
)

if not defined sdwebui_start_command (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] 未启用模块.%reset%
    echo %red_bg%请确保您启用了至少一个模块 from Edit SDWEBUI Modules.%reset%
    echo.
    echo %blue_bg%我们将把您重定向到 Edit SDWEBUI Modules menu.%reset%
    pause
    goto :edit_sdwebui_modules
)

set "sdwebui_start_command=%sdwebui_start_command:sdwebui_start_command=%"

REM Start Stable Diffusion WebUI with desired configurations
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% Stable Diffusion WebUI 在新窗口中启动。
start cmd /k "title SDWEBUI && cd /d %sdwebui_install_path% && %sdwebui_start_command%"
goto :home

:start_sdwebuiforge
cd /d "%sdwebuiforge_install_path%"

REM Run conda activate from the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 激活Miniconda环境...
call "%miniconda_path%\Scripts\activate.bat"

REM Activate the sdwebui environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 激活Conda环境: %cyan_fg_strong%sdwebuiforge%reset%
call conda activate sdwebuiforge

REM Start Stable Diffusion WebUI Forge with desired configurations
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% Stable Diffusion WebUI Forge 在新窗口中启动。
REM start cmd /k "title SDWEBUIFORGE && cd /d %sdwebuiforge_install_path% && %sdwebuiforge_start_command%"
start cmd /k "title SDWEBUIFORGE && cd /d %sdwebuiforge_install_path% && python launch.py"
goto :home

:start_comfyui
REM Run conda activate from the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 激活Miniconda环境...
call "%miniconda_path%\Scripts\activate.bat"

REM Activate the comfyui environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 激活Conda环境: %cyan_fg_strong%comfyui%reset%
call conda activate comfyui

REM Start ComfyUI with desired configurations
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% ComfyUI 在新窗口中启动。
start cmd /k "title ComfyUI && cd /d %comfyui_install_path% && python main.py --auto-launch --listen --port 7901"
goto :home


:start_fooocus
REM Run conda activate from the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 激活Miniconda环境...
call "%miniconda_path%\Scripts\activate.bat"

REM Activate the fooocus environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 激活Conda环境: %cyan_fg_strong%fooocus%reset%
call conda activate fooocus

REM Start Fooocus with desired configurations
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% Fooocus 在新窗口中启动。
start cmd /k "title Fooocus && cd /d %fooocus_install_path% && python entry_with_update.py"
goto :home


REM ############################################################
REM ######## APP LAUNCHER 图像生成 - FRONTEND ##########
REM ############################################################
:app_launcher_core_utilities
title STL [图片生成APP启动选项]
cls
echo %blue_fg_strong%/ 主页 / 工具箱 / APP启动选项 / 核心app%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?

echo 1. 启动 Extras
echo 0. 返回

set /p app_launcher_core_util_choice=选择: 

REM ######## APP LAUNCHER 图像生成 - BACKEND #########
if "%app_launcher_core_util_choice%"=="1" (
    call :start_extras
) else if "%app_launcher_core_util_choice%"=="0" (
    goto :app_launcher
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_launcher_core_utilities
)


:start_extras
REM Run conda activate from the Miniconda installation
call "%miniconda_path%\Scripts\activate.bat"

REM Activate the extras environment
call conda activate extras

REM Start SillyTavern Extras with desired configurations
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% Extras 在新窗口中启动。

REM Read modules-extras and find the extras_start_command line
set "extras_start_command="

for /F "tokens=*" %%a in ('findstr /I "extras_start_command=" "%extras_modules_path%"') do (
    set "%%a"
)

if not defined extras_start_command (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] 未启用模块!%reset%
    echo %red_bg%请确保至少启用了一个模块 from Edit Extras Modules.%reset%
    echo.
    echo %blue_bg%我们将把您重定向到 Edit Extras Modules menu.%reset%
    pause
    goto :edit_extras_modules
)

set "extras_start_command=%extras_start_command:extras_start_command=%"
start cmd /k "title SillyTavern Extras && cd /d %extras_install_path% && %extras_start_command%"
goto :home


REM ############################################################
REM ############## 安装选项 - FRONTEND ####################
REM ############################################################
:app_installer
title STL [APP安装选项]
cls
echo %blue_fg_strong%/ 主页 / 工具箱 / APP安装%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?

echo 1. 文本生成
echo 2. 语音生成
echo 3. 图片生成
echo 4. 核心app
echo 0. 返回

set /p app_installer_choice=选择: 

REM ############## 安装选项 - BACKEND ####################
if "%app_installer_choice%"=="1" (
    call :app_installer_text_completion
) else if "%app_installer_choice%"=="2" (
    call :app_installer_voice_generation
) else if "%app_installer_choice%"=="3" (
    call :app_installer_image_generation
) else if "%app_installer_choice%"=="4" (
    call :app_installer_core_utilities
) else if "%app_installer_choice%"=="0" (
    goto :toolbox
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_installer
)


REM ############################################################
REM ######## 安装选项 文本生成 - FRONTEND ##########
REM ############################################################
:app_installer_text_completion
title STL [安装选项 文本生成]
cls
echo %blue_fg_strong%/ 主页 / 工具箱 / APP安装 / 文本生成%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?

echo 1. 安装 Text generation web UI oobabooga
echo 2. koboldcpp [安装选项]
echo 3. TabbyAPI [安装选项]
echo 4. 安装 llamacpp
echo 0. 返回

set /p app_installer_txt_comp_choice=选择: 

REM ######## 安装选项 文本生成 - BACKEND ##########
if "%app_installer_txt_comp_choice%"=="1" (
    set "caller=app_installer_text_completion"
    if exist "%app_installer_text_completion_dir%\install_ooba.bat" (
        call %app_installer_text_completion_dir%\install_ooba.bat
        goto :app_installer_text_completion
    ) else (
        echo [%DATE% %TIME%] 错误: install_ooba.bat 没找到 in: %app_installer_text_completion_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] install_ooba.bat 没找到 in: %app_installer_text_completion_dir%%reset%
        pause
        goto :app_installer_text_completion
    )
) else if "%app_installer_txt_comp_choice%"=="2" (
    call :install_koboldcpp_menu
) else if "%app_installer_txt_comp_choice%"=="3" (
    call :install_tabbyapi_menu
) else if "%app_installer_txt_comp_choice%"=="4" (
    set "caller=app_installer_text_completion"
    if exist "%app_installer_text_completion_dir%\install_llamacpp.bat" (
        call %app_installer_text_completion_dir%\install_llamacpp.bat
        goto :app_installer_text_completion
    ) else (
        echo [%DATE% %TIME%] 错误: install_llamacpp.bat 没找到 in: %app_installer_text_completion_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] install_llamacpp.bat 没找到 in: %app_installer_text_completion_dir%%reset%
        pause
        goto :app_installer_text_completion
    )
) else if "%app_installer_txt_comp_choice%"=="0" (
    goto :app_installer
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_installer_text_completion
)


REM ############################################################
REM ######## 安装选项 KOBOLDCPP - FRONTEND ################
REM ############################################################
:install_koboldcpp_menu
title STL [安装 KOBOLDCPP]
cls
echo %blue_fg_strong%/ 主页 / 工具箱 / APP安装 / 文本生成 / koboldcpp%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?

echo 1. 安装 koboldcpp from prebuild .exe [推荐]
echo 2. 构建dll文件并编译.exe安装程序 [高级]
echo 0. 返回

set /p app_installer_koboldcpp_choice=选择: 

REM ######## 安装选项 KOBOLDCPP - BACKEND ##########
if "%app_installer_koboldcpp_choice%"=="1" (
    set "caller=app_installer_text_completion_koboldcpp"
    if exist "%app_installer_text_completion_dir%\install_koboldcpp.bat" (
        call %app_installer_text_completion_dir%\install_koboldcpp.bat
        goto :app_installer_text_completion
    ) else (
        echo [%DATE% %TIME%] 错误: install_koboldcpp.bat 没找到 in: %app_installer_text_completion_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] install_koboldcpp.bat 没找到 in: %app_installer_text_completion_dir%%reset%
        pause
        goto :install_koboldcpp_menu
    )
) else if "%app_installer_koboldcpp_choice%"=="2" (
    set "caller=app_installer_text_completion_koboldcpp"
    if exist "%app_installer_text_completion_dir%\install_koboldcpp_raw.bat" (
        call %app_installer_text_completion_dir%\install_koboldcpp_raw.bat
        goto :app_installer_text_completion
    ) else (
        echo [%DATE% %TIME%] 错误: install_koboldcpp_raw.bat 没找到 in: %app_installer_text_completion_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] install_koboldcpp_raw.bat 没找到 in: %app_installer_text_completion_dir%%reset%
        pause
        goto :install_koboldcpp_menu
    )
) else if "%app_installer_koboldcpp_choice%"=="0" (
    goto :app_installer_text_completion
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_koboldcpp_menu
)


REM ############################################################
REM ######## 安装选项 TABBYAPI - FRONTEND #################
REM ############################################################
:install_tabbyapi_menu
title STL [安装选项 TABBYAPI]

REM Check if the folder exists
if exist "%tabbyapi_install_path%" (
    REM Activate the tabbyapi environment
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 停用Conda环境: %cyan_fg_strong%tabbyapi%reset%
    call conda deactivate
)

cls
echo %blue_fg_strong%/ 主页 / 工具箱 / APP安装 / 文本生成 / TabbyAPI %reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?

echo 1. 安装 TabbyAPI
echo 2. LLM模型 [安装选项]
echo 0. 返回

set /p app_installer_tabbyapi_choice=选择: 

REM ##### 安装选项 TABBYAPI - BACKEND ######
if "%app_installer_tabbyapi_choice%"=="1" (
    set "caller=app_installer_text_completion_tabbyapi"
    if exist "%app_installer_text_completion_dir%\install_tabbyapi.bat" (
        call %app_installer_text_completion_dir%\install_tabbyapi.bat
        goto :install_tabbyapi_menu
    ) else (
        echo [%DATE% %TIME%] 错误: install_tabbyapi.bat 没找到 in: %app_installer_text_completion_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] install_tabbyapi.bat 没找到 in: %app_installer_text_completion_dir%%reset%
        pause
        goto :install_tabbyapi_menu
    )
) else if "%app_installer_tabbyapi_choice%"=="2" (
    goto :install_tabbyapi_model_menu
) else if "%app_installer_tabbyapi_choice%"=="0" (
    goto :app_installer_text_completion
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_tabbyapi_menu
)


REM ############################################################
REM ##### 安装选项 TABBYAPI 模型 - FRONTEND #############
REM ############################################################
:install_tabbyapi_model_menu
title STL [安装选项TABBYAPI MODELS]

REM Check if the folder exists
if not exist "%tabbyapi_install_path%" (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] TabbyAPI 未安装，请先安装.%reset%
    pause
    goto :install_tabbyapi_menu
)

REM Run conda activate from the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 激活Miniconda环境...
call "%miniconda_path%\Scripts\activate.bat"

REM Activate the tabbyapi environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 激活Conda环境: %cyan_fg_strong%tabbyapi%reset%
call conda activate tabbyapi

cd /d "%tabbyapi_install_path%"

cls
echo %blue_fg_strong%/ 主页 / 工具箱 / APP安装 / 文本生成 / TabbyAPI / 模型%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?

echo 1. 安装 Hathor_Aleph-L3-8B-v0.72-exl2 [V0.72 RP, Cybersecurity, Programming, Biology/Anatomy 未经审查]
echo 2. 安装 Hathor_Stable-L3-8B-v0.5-exl2 [V0.5 RP, Cybersecurity, Programming, Biology/Anatomy 未经审查]
echo 3. 安装 Hathor-L3-8B-v.01-exl2 [V0.1 RP 未经审查]
echo 4. 安装 自定义LLM模型
echo 0. 返回

set /p app_installer_tabbyapi_model_choice=选择: 

REM ######## 安装选项 TABBYAPI 模型 - BACKEND #########
if "%app_installer_tabbyapi_model_choice%"=="1" (
    call :install_tabbyapi_model_hathorv07
) else if "%app_installer_tabbyapi_model_choice%"=="2" (
    goto :install_tabbyapi_model_hathorv05
) else if "%app_installer_tabbyapi_model_choice%"=="3" (
    goto :install_tabbyapi_model_hathorv01
) else if "%app_installer_tabbyapi_model_choice%"=="4" (
    goto :install_tabbyapi_model_custom
) else if "%app_installer_tabbyapi_model_choice%"=="0" (
    goto :install_tabbyapi_menu
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_tabbyapi_model_menu
)


:install_tabbyapi_model_hathorv07
cd /d "%tabbyapi_install_path%\models"
REM Install model Based on VRAM Size
if %VRAM% lss 8 (
echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] 对不起，需要至少8GB 显存或更多才能运行本地LLM%reset%
pause
goto :install_tabbyapi_model_menu
) else if %VRAM% lss 12 (
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 检测到GPU显存: %cyan_fg_strong%%VRAM% GB%reset%
REM Check if model exists
if exist "Hathor_Aleph-L3-8B-v0.72-exl2-5_0" (
    REM Remove model if it already exists
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 删除现有LLM模型...
    rmdir /s /q "Hathor_Aleph-L3-8B-v0.72-exl2-5_0"
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在下载LLM模型 size bits: 5.0
echo %cyan_fg_strong%下载需要一段时间，大约5分钟或更长时间，具体取决于您的网速.%reset%
echo %cyan_fg_strong%当您看到：解包对象：100时，请等待，直到您看到绿色文本中的成功安装LLM模型.%reset%
git clone --single-branch --branch 5_0 https://huggingface.co/bartowski/Hathor_Aleph-L3-8B-v0.72-exl2 Hathor_Aleph-L3-8B-v0.72-exl2-5_0
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%已成功安装LLM模型: Hathor_Stable-L3-8B-v0.5-exl2%reset%
pause
goto :install_tabbyapi_model_menu
) else if %VRAM% equ 12 (
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 检测到GPU显存: %cyan_fg_strong%%VRAM% GB%reset%
REM Check if model exists
if exist "Hathor_Aleph-L3-8B-v0.72-exl2-6_5" (
    REM Remove model if it already exists
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 删除现有LLM模型...
    rmdir /s /q "Hathor_Aleph-L3-8B-v0.72-exl2-6_5"
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在下载LLM模型 size bits: 6.0
echo %cyan_fg_strong%The download will take a while, approximately 5 minutes or more, depending on your internet speed.%reset%
echo %cyan_fg_strong%当您看到：解包对象：100时，请等待，直到您看到绿色文本中的成功安装LLM模型.%reset%
git clone --single-branch --branch 6_5 https://huggingface.co/bartowski/Hathor_Aleph-L3-8B-v0.72-exl2 Hathor_Aleph-L3-8B-v0.72-exl2-6_5
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%已成功安装LLM模型: Hathor_Aleph-L3-8B-v0.72-exl2-6_5%reset%
pause
goto :install_tabbyapi_model_menu
) else if %VRAM% gtr 12 (
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 检测到GPU显存: %cyan_fg_strong%%VRAM% GB%reset%
REM Check if model exists
if exist "Hathor_Aleph-L3-8B-v0.72-exl2-6_5" (
    REM Remove model if it already exists
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 删除现有LLM模型...
    rmdir /s /q "Hathor_Aleph-L3-8B-v0.72-exl2-6_5"
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在下载LLM模型 size bits: 6.0
echo %cyan_fg_strong%The download will take a while, approximately 5 minutes or more, depending on your internet speed.%reset%
echo %cyan_fg_strong%当您看到：解包对象：100时，请等待，直到您看到绿色文本中的成功安装LLM模型.%reset%
git clone --single-branch --branch 6_5 https://huggingface.co/bartowski/Hathor_Aleph-L3-8B-v0.72-exl2 Hathor_Aleph-L3-8B-v0.72-exl2-6_5
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%已成功安装LLM模型: Hathor_Aleph-L3-8B-v0.72-exl2-6_5%reset%
pause
goto :install_tabbyapi_model_menu
) else (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] 检测到意外数量的显存或无法检测显存。请检查您的系统规格.%reset%
    pause
    goto :install_tabbyapi_model_menu
)

:install_tabbyapi_model_hathorv05
cd /d "%tabbyapi_install_path%\models"
REM Install model Based on VRAM Size
if %VRAM% lss 8 (
echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] 对不起，需要至少8GB显存或更多才能运行本地LLM%reset%
pause
goto :install_tabbyapi_model_menu
) else if %VRAM% lss 12 (
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 检测到GPU显存: %cyan_fg_strong%%VRAM% GB%reset%
REM Check if model exists
if exist "Hathor_Stable-L3-8B-v0.5-exl2-5_0" (
    REM Remove model if it already exists
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 删除现有LLM模型...
    rmdir /s /q "Hathor_Stable-L3-8B-v0.5-exl2-5_0"
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在下载LLM模型 size bits: 5.0
echo %cyan_fg_strong%The download will take a while, approximately 5 minutes or more, depending on your internet speed.%reset%
echo %cyan_fg_strong%当您看到：解包对象：100时，请等待，直到您看到绿色文本中的成功安装LLM模型.%reset%
git clone --single-branch --branch 5_0 https://huggingface.co/bartowski/Hathor_Stable-L3-8B-v0.5-exl2 Hathor_Stable-L3-8B-v0.5-exl2-5_0
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%已成功安装LLM模型: Hathor_Stable-L3-8B-v0.5-exl2%reset%
pause
goto :install_tabbyapi_model_menu
) else if %VRAM% equ 12 (
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 检测到GPU显存: %cyan_fg_strong%%VRAM% GB%reset%
REM Check if model exists
if exist "Hathor_Stable-L3-8B-v0.5-exl2-6_5" (
    REM Remove model if it already exists
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 删除现有LLM模型...
    rmdir /s /q "Hathor_Stable-L3-8B-v0.5-exl2-6_5"
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在下载LLM模型 size bits: 6.0
REM set GIT_CURL_VERBOSE=1
REM set GIT_TRACE=1
echo %cyan_fg_strong%The download will take a while, approximately 5 minutes or more, depending on your internet speed.%reset%
echo %cyan_fg_strong%当您看到：解包对象：100时，请等待，直到您看到绿色文本中的成功安装LLM模型.%reset%
git clone --single-branch --branch 6_5 https://huggingface.co/bartowski/Hathor_Stable-L3-8B-v0.5-exl2 Hathor_Stable-L3-8B-v0.5-exl2-6_5
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%已成功安装LLM模型: Hathor_Stable-L3-8B-v0.5-exl2%reset%
pause
goto :install_tabbyapi_model_menu
) else if %VRAM% gtr 12 (
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 检测到GPU显存: %cyan_fg_strong%%VRAM% GB%reset%
REM Check if model exists
if exist "Hathor_Stable-L3-8B-v0.5-exl2-6_5" (
    REM Remove model if it already exists
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 删除现有LLM模型...
    rmdir /s /q "Hathor_Stable-L3-8B-v0.5-exl2-6_5"
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在下载LLM模型 size bits: 6.0
REM set GIT_CURL_VERBOSE=1
REM set GIT_TRACE=1
echo %cyan_fg_strong%The download will take a while, approximately 5 minutes or more, depending on your internet speed.%reset%
echo %cyan_fg_strong%当您看到：解包对象：100时，请等待，直到您看到绿色文本中的成功安装LLM模型.%reset%
git clone --single-branch --branch 6_5 https://huggingface.co/bartowski/Hathor_Stable-L3-8B-v0.5-exl2 Hathor_Stable-L3-8B-v0.5-exl2-6_5
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%已成功安装LLM模型: Hathor_Stable-L3-8B-v0.5-exl2%reset%
pause
goto :install_tabbyapi_model_menu
) else (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] 检测到意外数量的显存或无法检测显存。请检查您的系统规格.%reset%
    pause
    goto :install_tabbyapi_model_menu
)


:install_tabbyapi_model_hathorv01
cd /d "%tabbyapi_install_path%\models"
REM Install model Based on VRAM Size
if %VRAM% lss 8 (
echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] 对不起，需要至少8GB显存或更多才能运行本地LLM%reset%
pause
goto :install_tabbyapi_model_menu
) else if %VRAM% lss 12 (
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset%检测到GPU显存: %cyan_fg_strong%%VRAM% GB%reset%
REM Check if model exists
if exist "Hathor-L3-8B-v.01-exl2-5_0" (
    REM Remove model if it already exists
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 删除现有LLM模型...
    rmdir /s /q "Hathor-L3-8B-v.01-exl2-5_0"
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset%正在下载LLM模型 size bits: 5.0
git clone --single-branch --branch 5_0 https://huggingface.co/bartowski/Hathor-L3-8B-v.01-exl2 Hathor-L3-8B-v.01-exl2-5_0
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%已成功安装LLM模型: Hathor-L3-8B-v.01-exl2%reset%
pause
goto :install_tabbyapi_model_menu
) else if %VRAM% equ 12 (
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset%检测到GPU显存: %cyan_fg_strong%%VRAM% GB%reset%
REM Check if model exists
if exist "Hathor-L3-8B-v.01-exl2-6_5" (
    REM Remove model if it already exists
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 删除现有LLM模型...
    rmdir /s /q "Hathor-L3-8B-v.01-exl2-6_5"
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset%正在下载LLM模型 size bits: 6.0
git clone --single-branch --branch 6_5 https://huggingface.co/bartowski/Hathor-L3-8B-v.01-exl2 Hathor-L3-8B-v.01-exl2-6_5
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%已成功安装LLM模型: Hathor-L3-8B-v.01-exl2%reset%
pause
goto :install_tabbyapi_model_menu
) else if %VRAM% gtr 12 (
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset%检测到GPU显存: %cyan_fg_strong%%VRAM% GB%reset%
REM Check if model exists
if exist "Hathor-L3-8B-v.01-exl2-6_5" (
    REM Remove model if it already exists
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 删除现有LLM模型...
    rmdir /s /q "Hathor-L3-8B-v.01-exl2-6_5"
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset%正在下载LLM模型 size bits: 6.0
git clone --single-branch --branch 6_5 https://huggingface.co/bartowski/Hathor-L3-8B-v.01-exl2 Hathor-L3-8B-v.01-exl2-6_5
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%已成功安装LLM模型: Hathor-L3-8B-v.01-exl2%reset%
pause
goto :install_tabbyapi_model_menu
) else (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] 检测到意外数量的显存或无法检测显存。请检查您的系统规格.%reset%
    pause
    goto :install_tabbyapi_model_menu
)

:install_tabbyapi_model_custom
cls
set /p tabbyapimodelurl="(输入0取消 )插入模型 URL: "
if "%tabbyapimodelurl%"=="0" goto :install_tabbyapi_model_menu


echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在下载...
cd /d "%tabbyapi_install_path%\models"
git clone %tabbyapimodelurl%
pause
goto :install_tabbyapi_model_menu


REM ############################################################
REM ######## 安装选项 语音生成 - FRONTEND #########
REM ############################################################
:app_installer_voice_generation
title STL [语音生成 安装选项]
cls
echo %blue_fg_strong%/ 主页 / 工具箱 / APP安装 / 语音生成%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?

echo 1. 安装 AllTalk
echo 2. 安装 XTTS
echo 3. 安装 RVC
echo 0. 返回

set /p app_installer_voice_gen_choice=选择: 

REM ######## 安装选项 语音生成 - BACKEND #########
if "%app_installer_voice_gen_choice%"=="1" (
    set "caller=app_installer_voice_generation"
    if exist "%app_installer_voice_generation_dir%\install_alltalk.bat" (
        call %app_installer_voice_generation_dir%\install_alltalk.bat
        goto :app_installer_voice_generation
    ) else (
        echo [%DATE% %TIME%] 错误: install_alltalk.bat 没找到 in: %app_installer_voice_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] install_alltalk.bat 没找到 in: %app_installer_voice_generation_dir%%reset%
        pause
        goto :app_installer_voice_generation
    )
) else if "%app_installer_voice_gen_choice%"=="2" (
    set "caller=app_installer_voice_generation"
    if exist "%app_installer_voice_generation_dir%\install_xtts.bat" (
        call %app_installer_voice_generation_dir%\install_xtts.bat
        goto :app_installer_voice_generation
    ) else (
        echo [%DATE% %TIME%] 错误: install_xtts.bat 没找到 in: %app_installer_voice_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] install_xtts.bat 没找到 in: %app_installer_voice_generation_dir%%reset%
        pause
        goto :app_installer_voice_generation
    )
) else if "%app_installer_voice_gen_choice%"=="3" (
    set "caller=app_installer_voice_generation"
    if exist "%app_installer_voice_generation_dir%\install_rvc.bat" (
        call %app_installer_voice_generation_dir%\install_rvc.bat
        goto :app_installer_voice_generation
    ) else (
        echo [%DATE% %TIME%] 错误: install_rvc.bat 没找到 in: %app_installer_voice_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] install_rvc.bat 没找到 in: %app_installer_voice_generation_dir%%reset%
        pause
        goto :app_installer_voice_generation
    )
) else if "%app_installer_voice_gen_choice%"=="0" (
    goto :app_installer
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_installer_voice_generation
)



REM ############################################################
REM ######## 安装选项 图像生成 - FRONTEND #########
REM ############################################################
:app_installer_image_generation
title STL [图片生成APP安装选项]
cls
echo %blue_fg_strong%/ 主页 / 工具箱 / APP安装 / 图片生成%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?

echo 1. Stable Diffusion web UI [安装选项]
echo 2. Stable Diffusion web UI Forge [安装选项]
echo 3. 安装 ComfyUI
echo 4. 安装 Fooocus
echo 0. 返回

set /p app_installer_img_gen_choice=选择: 

REM ######## 安装选项 图像生成 - BACKEND #########
if "%app_installer_img_gen_choice%"=="1" (
    call :install_sdwebui_menu
) else if "%app_installer_img_gen_choice%"=="2" (
    goto :install_sdwebuiforge_menu
) else if "%app_installer_img_gen_choice%"=="3" (
    set "caller=app_installer_image_generation"
    if exist "%app_installer_image_generation_dir%\install_comfyui.bat" (
        call %app_installer_image_generation_dir%\install_comfyui.bat
        goto :app_installer_image_generation
    ) else (
        echo [%DATE% %TIME%] 错误: install_comfyui.bat 没找到 in: %app_installer_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] install_comfyui.bat 没找到 in: %app_installer_image_generation_dir%%reset%
        pause
        goto :app_installer_image_generation
    )
) else if "%app_installer_img_gen_choice%"=="4" (
    set "caller=app_installer_image_generation"
    if exist "%app_installer_image_generation_dir%\install_fooocus.bat" (
        call %app_installer_image_generation_dir%\install_fooocus.bat
        goto :app_installer_image_generation
    ) else (
        echo [%DATE% %TIME%] 错误: install_fooocus.bat 没找到 in: %app_installer_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] install_fooocus.bat 没找到 in: %app_installer_image_generation_dir%%reset%
        pause
        goto :app_installer_image_generation
    )
) else if "%app_installer_img_gen_choice%"=="0" (
    goto :app_installer
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_installer_image_generation
)


REM ############################################################
REM ##### 安装选项 STABLE DIFUSSION WEBUI - FRONTEND ######
REM ############################################################
:install_sdwebui_menu
title STL [SDWEBUI安装]

REM Check if the folder exists
if exist "%sdwebui_install_path%" (
    REM Activate the sdwebui environment
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 停用Conda环境: %cyan_fg_strong%sdwebui%reset%
    call conda deactivate
)

cls
echo %blue_fg_strong%/ 主页 / 工具箱 / APP安装 / 图片生成 / Stable Diffusion web UI %reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?

echo 1. 安装 Stable Diffusion web UI
echo 2. 安装 扩展
echo 3. 模型 [安装选项]
echo 0. 返回

set /p app_installer_sdwebui_choice=选择: 

REM ##### 安装选项 STABLE DIFUSSION WEBUI - BACKEND ######
if "%app_installer_sdwebui_choice%"=="1" (
    set "caller=app_installer_image_generation_sdwebui"
    if exist "%app_installer_image_generation_dir%\install_sdwebui.bat" (
        call %app_installer_image_generation_dir%\install_sdwebui.bat
        goto :install_sdwebui_menu
    ) else (
        echo [%DATE% %TIME%] 错误: install_sdwebui.bat 没找到 in: %app_installer_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] install_sdwebui.bat 没找到 in: %app_installer_image_generation_dir%%reset%
        pause
        goto :install_sdwebui_menu
    )
) else if "%app_installer_sdwebui_choice%"=="2" (
    goto :install_sdwebui_extensions
) else if "%app_installer_sdwebui_choice%"=="3" (
    goto :install_sdwebui_model_menu
) else if "%app_installer_sdwebui_choice%"=="0" (
    goto :app_installer_image_generation
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_sdwebui_menu
)


:install_sdwebui_extensions
REM Check if the folder exists
if not exist "%sdwebui_install_path%" (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] Stable Diffusion Webui 未安装，请先安装.%reset%
    pause
    goto :install_sdwebui_menu
)

REM Clone extensions for stable-diffusion-webui
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在克隆扩展 for stable-diffusion-webui...
cd /d "%sdwebui_install_path%\extensions"
git clone https://github.com/alemelis/sd-webui-ar.git
git clone https://github.com/butaixianran/Stable-Diffusion-Webui-Civitai-Helper.git
git clone https://github.com/DominikDoom/a1111-sd-webui-tagcomplete.git
git clone https://github.com/EnsignMK/danbooru-prompt.git
git clone https://github.com/fkunn1326/openpose-editor.git
git clone https://github.com/Mikubill/sd-webui-controlnet.git
git clone https://github.com/ashen-sensored/sd_webui_SAG.git
git clone https://github.com/NoCrypt/sd-fast-pnginfo.git
git clone https://github.com/Bing-su/adetailer.git
git clone https://github.com/hako-mikan/sd-webui-supermerger.git
git clone https://github.com/AlUlkesh/stable-diffusion-webui-images-browser.git
git clone https://github.com/hako-mikan/sd-webui-regional-prompter.git
git clone https://github.com/Gourieff/sd-webui-reactor.git
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui-rembg.git

REM Installs better upscaler models
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在安装 Better Upscaler models...
cd /d "%sdwebui_install_path%\models"
mkdir ESRGAN && cd ESRGAN
curl -o 4x-AnimeSharp.pth https://huggingface.co/Kim2091/AnimeSharp/resolve/main/4x-AnimeSharp.pth
curl -o 4x-UltraSharp.pth https://huggingface.co/lokCX/4x-Ultrasharp/resolve/main/4x-UltraSharp.pth
pause
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%扩展 for Stable Diffusion web UI 成功安装.%reset%
goto :install_sdwebui_menu


REM ############################################################
REM ##### 安装选项 SDWEBUI 模型 - FRONTEND ##############
REM ############################################################
:install_sdwebui_model_menu
title STL [安装SDWEBUILLM模型选项]

REM Check if the folder exists
if not exist "%sdwebui_install_path%" (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] Stable Diffusion Webui 未安装，请先安装.%reset%
    pause
    goto :install_sdwebui_menu
)

REM Run conda activate from the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 激活Miniconda环境...
call "%miniconda_path%\Scripts\activate.bat"

REM Activate the sdwebui environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 激活Conda环境: %cyan_fg_strong%sdwebui%reset%
call conda activate sdwebui

cd /d "%sdwebui_install_path%"

cls
echo %blue_fg_strong%/ 主页 / 工具箱 / APP安装 / 图片生成 / Stable Diffusion web UI / 模型%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?

echo 1. 安装 Hassaku [ANIME MODEL]
echo 2. 安装 YiffyMix [FURRY MODEL]
echo 3. 安装 Perfect World [REALISM MODEL]
echo 4. 安装 自定义LLM模型
echo 5. Add API Key from civitai
echo 0. 返回

set /p app_installer_sdwebui_model_choice=选择: 

REM ######## 安装选项 图像生成 - BACKEND #########
if "%app_installer_sdwebui_model_choice%"=="1" (
    call :install_sdwebui_model_hassaku
) else if "%app_installer_sdwebui_model_choice%"=="2" (
    goto :install_sdwebui_model_yiffymix
) else if "%app_installer_sdwebui_model_choice%"=="3" (
    goto :install_sdwebui_model_perfectworld
) else if "%app_installer_sdwebui_model_choice%"=="4" (
    goto :install_sdwebui_model_custom
) else if "%app_installer_sdwebui_model_choice%"=="5" (
    goto :install_sdwebui_model_apikey
) else if "%app_installer_sdwebui_model_choice%"=="0" (
    goto :install_sdwebui_menu
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_sdwebui_model_menu
)

:install_sdwebui_model_hassaku
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在下载 Hassaku Model...
civitdl 2583 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%更改安装 Hassaku Model in: "%sdwebui_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebui_model_menu


:install_sdwebui_model_yiffymix
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在下载 YiffyMix Model...
civitdl 3671 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%更改安装 YiffyMix Model in: "%sdwebui_install_path%\models\Stable-diffusion"%reset%

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在下载 YiffyMix Config...
civitdl 3671 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%更改安装 YiffyMix Config in: "%sdwebui_install_path%\models\Stable-diffusion"%reset%

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在下载 YiffyMix VAE...
civitdl 3671 -s basic "models\VAE"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%更改安装 YiffyMix VAE in: "%sdwebui_install_path%\models\VAE"%reset%
pause
goto :install_sdwebui_model_menu


:install_sdwebui_model_perfectworld
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在下载 Perfect World Model...
civitdl 8281 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%更改安装 Perfect World Model in: "%sdwebui_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebui_model_menu


:install_sdwebui_model_custom
cls
set /p civitaimodelid="输入0取消)插入模型ID: "

if "%civitaimodelid%"=="0" goto :install_sdwebui_model_menu

REM Check if the input is a valid number
echo %civitaimodelid%| findstr /R "^[0-9]*$" > nul
if errorlevel 1 (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_sdwebui_model_custom
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在下载...
civitdl %civitaimodelid% -s basic "models\Stable-diffusion"
pause
goto :install_sdwebui_model_menu


:install_sdwebui_model_apikey
cls
set /p civitaiapikey="(输入0取消)插入API KEY: "

if "%civitaiapikey%"=="0" goto :install_sdwebui_model_menu

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%Adding API key...
civitconfig default --api-key %civitaiapikey%
pause
goto :install_sdwebui_model_menu

REM ############################################################
REM ## 安装选项 STABLE DIFUSSION WEBUI FORGE - FRONTEND ###
REM ############################################################
:install_sdwebuiforge_menu
title STL [安装选项 STABLE DIFUSSION WEBUI FORGE]

REM Check if the folder exists
if exist "%sdwebuiforge_install_path%" (
    REM Activate the sdwebuiforge environment
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 停用Conda环境: %cyan_fg_strong%sdwebui%reset%
    call conda deactivate
)

cls
echo %blue_fg_strong%/ 主页 / 工具箱 / APP安装 / Stable Diffusion web UI Forge %reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?

echo 1. 安装 Stable Diffusion web UI Forge
echo 2. 安装 扩展
echo 3. LLM模型 [安装选项]
echo 0. 返回

set /p app_installer_sdwebuiforge_choice=选择: 

REM ## 安装选项 STABLE DIFUSSION WEBUI FORGE - BACKEND ###
if "%app_installer_sdwebuiforge_choice%"=="1" (
    set "caller=app_installer_image_generation_sdwebuiforge"
    if exist "%app_installer_image_generation_dir%\install_sdwebuiforge.bat" (
        call %app_installer_image_generation_dir%\install_sdwebuiforge.bat
        goto :install_sdwebuiforge_menu
    ) else (
        echo [%DATE% %TIME%] 错误: install_sdwebuiforge.bat 没找到 in: %app_installer_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] install_sdwebuiforge.bat 没找到 in: %app_installer_image_generation_dir%%reset%
        pause
        goto :install_sdwebuiforge_menu
    )
) else if "%app_installer_sdwebuiforge_choice%"=="2" (
    goto :install_sdwebuiforge_extensions
) else if "%app_installer_sdwebuiforge_choice%"=="3" (
    goto :install_sdwebuiforge_model_menu
) else if "%app_installer_sdwebuiforge_choice%"=="0" (
    goto :app_installer_image_generation
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_sdwebuiforge_menu
)


:install_sdwebuiforge_extensions
REM Check if the folder exists
if not exist "%sdwebuiforge_install_path%" (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] Stable Diffusion WebUI Forge 未安装，请先安装.%reset%
    pause
    goto :install_sdwebuiforge_menu
)

REM Clone extensions for stable-diffusion-webui-forge
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% Cloning extensions for stable-diffusion-webui-forge...
cd /d "%sdwebuiforge_install_path%\extensions"
git clone https://github.com/alemelis/sd-webui-ar.git
git clone https://github.com/butaixianran/Stable-Diffusion-Webui-Civitai-Helper.git
git clone https://github.com/DominikDoom/a1111-sd-webui-tagcomplete.git
git clone https://github.com/EnsignMK/danbooru-prompt.git
git clone https://github.com/fkunn1326/openpose-editor.git
git clone https://github.com/Mikubill/sd-webui-controlnet.git
git clone https://github.com/ashen-sensored/sd_webui_SAG.git
git clone https://github.com/NoCrypt/sd-fast-pnginfo.git
git clone https://github.com/Bing-su/adetailer.git
git clone https://github.com/hako-mikan/sd-webui-supermerger.git
git clone https://github.com/AlUlkesh/stable-diffusion-webui-images-browser.git
git clone https://github.com/hako-mikan/sd-webui-regional-prompter.git
git clone https://github.com/Gourieff/sd-webui-reactor.git
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui-rembg.git

REM Installs better upscaler models
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在安装 Better Upscaler models...
cd /d "%sdwebuiforge_install_path%\models"
mkdir ESRGAN && cd ESRGAN
curl -o 4x-AnimeSharp.pth https://huggingface.co/Kim2091/AnimeSharp/resolve/main/4x-AnimeSharp.pth
curl -o 4x-UltraSharp.pth https://huggingface.co/lokCX/4x-Ultrasharp/resolve/main/4x-UltraSharp.pth
pause
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%扩展 for Stable Diffusion WebUI Forge 成功安装.%reset%
goto :install_sdwebuiforge_menu


REM ############################################################
REM ##### 安装选项 SDWEBUI 模型 - FRONTEND ##############
REM ############################################################
:install_sdwebuiforge_model_menu
title STL [安装选项SDWEBUIFORGELLM模型]

REM Check if the folder exists
if not exist "%sdwebuiforge_install_path%" (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] Stable Diffusion WebUI Forge 未安装，请先安装.%reset%
    pause
    goto :install_sdwebuiforge_menu
)

REM Run conda activate from the Miniconda installation
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 激活Miniconda环境...
call "%miniconda_path%\Scripts\activate.bat"

REM Activate the sdwebuiforge environment
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 激活Conda环境: %cyan_fg_strong%sdwebuiforge%reset%
call conda activate sdwebuiforge

cd /d "%sdwebuiforge_install_path%"

cls
echo %blue_fg_strong%/ 主页 / 工具箱 / APP安装 / SDWEBUIFORGE 模型%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?

echo 1. Install Hassaku [ANIME MODEL]
echo 2. Install YiffyMix [FURRY MODEL]
echo 3. Install Perfect World [REALISM MODEL]
echo 4. Install a custom model
echo 0. 返回

set /p app_installer_sdwebuiforge_model_choice=选择: 

REM ######## 安装选项 图像生成 - BACKEND #########
if "%app_installer_sdwebuiforge_model_choice%"=="1" (
    call :install_sdwebuiforge_model_hassaku
) else if "%app_installer_sdwebuiforge_model_choice%"=="2" (
    goto :install_sdwebuiforge_model_yiffymix
) else if "%app_installer_sdwebuiforge_model_choice%"=="3" (
    goto :install_sdwebuiforge_model_perfectworld
) else if "%app_installer_sdwebuiforge_model_choice%"=="4" (
    goto :install_sdwebuiforge_model_custom
) else if "%app_installer_sdwebuiforge_model_choice%"=="0" (
    goto :install_sdwebuiforge_menu
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_sdwebuiforge_model_menu
)

:install_sdwebuiforge_model_hassaku
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在下载 Hassaku Model...
civitdl 2583 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%更改安装 Hassaku Model in: "%sdwebui_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebuiforge_model_menu


:install_sdwebuiforge_model_yiffymix
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在下载 YiffyMix Model...
civitdl 3671 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%更改安装 YiffyMix Model in: "%sdwebui_install_path%\models\Stable-diffusion"%reset%

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在下载 YiffyMix Config...
civitdl 3671 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%更改安装 YiffyMix Config in: "%sdwebui_install_path%\models\Stable-diffusion"%reset%

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在下载 YiffyMix VAE...
civitdl 3671 -s basic "models\VAE"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%更改安装 YiffyMix VAE in: "%sdwebui_install_path%\models\VAE"%reset%
pause
goto :install_sdwebuiforge_model_menu


:install_sdwebuiforge_model_perfectworld
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 正在下载 Perfect World Model...
civitdl 8281 -s basic "models\Stable-diffusion"
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%更改安装 Perfect World Model in: "%sdwebui_install_path%\models\Stable-diffusion"%reset%
pause
goto :install_sdwebuiforge_model_menu


:install_sdwebuiforge_model_custom
cls
set /p civitaimodelid="(输入0取消)插入模型ID: "

if "%civitaimodelid%"=="0" goto :install_sdwebuiforge_model_menu

REM Check if the input is a valid number
echo %civitaimodelid%| findstr /R "^[0-9]*$" > nul
if errorlevel 1 (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :install_sdwebuiforge_model_custom
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%正在下载...
civitdl %civitaimodelid% -s basic "models\Stable-diffusion"

pause
goto :install_sdwebuiforge_model_menu



REM ############################################################
REM ######## 安装选项 CORE UTILITIES - FRONTEND ###########
REM ############################################################
:app_installer_core_utilities
title STL [核心APP安装选项]
cls
echo %blue_fg_strong%/ 主页 / 工具箱 / APP安装 / 核心app%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?

echo 1. 安装 7-Zip
echo 2. 安装 FFmpeg
echo 3. 安装 Node.js
echo 4. 安装 yq
echo 5. 安装 Visual Studio BuildTools
echo 6. 安装 CUDA Toolkit
echo 7. 安装 w64devkit
echo 0. 返回

set /p app_installer_core_util_choice=选择: 

REM ######## 安装选项 CORE UTILITIES - BACKEND ###########
if "%app_installer_core_util_choice%"=="1" (
    set "caller=app_installer_core_utilities"
    if exist "%app_installer_core_utilities_dir%\install_7zip.bat" (
        call %app_installer_core_utilities_dir%\install_7zip.bat
    ) else (
        echo [%DATE% %TIME%] 错误: install_7zip.bat 没找到 in: %app_installer_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] install_7zip.bat 没找到 in: %app_installer_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 运行自动修复...
        git pull
        pause
        goto :app_installer_core_utilities
    )
) else if "%app_installer_core_util_choice%"=="2" (
    set "caller=app_installer_core_utilities"
    if exist "%app_installer_core_utilities_dir%\install_ffmpeg.bat" (
        call %app_installer_core_utilities_dir%\install_ffmpeg.bat
    ) else (
        echo [%DATE% %TIME%] 错误: install_ffmpeg.bat 没找到 in: %app_installer_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] install_ffmpeg.bat 没找到 in: %app_installer_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 运行自动修复...
        git pull
        pause
        goto :app_installer_core_utilities
    )
) else if "%app_installer_core_util_choice%"=="3" (
    set "caller=app_installer_core_utilities"
    if exist "%app_installer_core_utilities_dir%\install_nodejs.bat" (
        call %app_installer_core_utilities_dir%\install_nodejs.bat
    ) else (
        echo [%DATE% %TIME%] 错误: install_nodejs.bat 没找到 in: %app_installer_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] install_nodejs.bat 没找到 in: %app_installer_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 运行自动修复...
        git pull
        pause
        goto :app_installer_core_utilities
    )
) else if "%app_installer_core_util_choice%"=="4" (
    set "caller=app_installer_core_utilities"
    if exist "%app_installer_core_utilities_dir%\install_yq.bat" (
        call %app_installer_core_utilities_dir%\install_yq.bat
    ) else (
        echo [%DATE% %TIME%] 错误: install_yq.bat 没找到 in: %app_installer_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] install_yq.bat 没找到 in: %app_installer_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 运行自动修复...
        git pull
        pause
        goto :app_installer_core_utilities
    )
) else if "%app_installer_core_util_choice%"=="5" (
    set "caller=app_installer_core_utilities"
    if exist "%app_installer_core_utilities_dir%\install_vsbuildtools.bat" (
        call %app_installer_core_utilities_dir%\install_vsbuildtools.bat
    ) else (
        echo [%DATE% %TIME%] 错误: install_vsbuildtools.bat 没找到 in: %app_installer_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] install_vsbuildtools.bat 没找到 in: %app_installer_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 运行自动修复...
        git pull
        pause
        goto :app_installer_core_utilities
    )
) else if "%app_installer_core_util_choice%"=="6" (
    set "caller=app_installer_core_utilities"
    if exist "%app_installer_core_utilities_dir%\install_cudatoolkit.bat" (
        call %app_installer_core_utilities_dir%\install_cudatoolkit.bat
    ) else (
        echo [%DATE% %TIME%] 错误: install_cudatoolkit.bat 没找到 in: %app_installer_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] install_cudatoolkit.bat 没找到 in: %app_installer_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 运行自动修复...
        git pull
        pause
        goto :app_installer_core_utilities
    )
) else if "%app_installer_core_util_choice%"=="7" (
    set "caller=app_installer_core_utilities"
    if exist "%app_installer_core_utilities_dir%\install_w64devkit.bat" (
        call %app_installer_core_utilities_dir%\install_w64devkit.bat
    ) else (
        echo [%DATE% %TIME%] 错误: install_w64devkit.bat 没找到 in: %app_installer_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] install_w64devkit.bat 没找到 in: %app_installer_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 运行自动修复...
        git pull
        pause
        goto :app_installer_core_utilities
    )
) else if "%app_installer_core_util_choice%"=="0" (
    goto :app_installer
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_installer_core_utilities
)



REM ############################################################
REM ############## 卸载选项 - FRONTEND ##################
REM ############################################################
:app_uninstaller
title STL [APP卸载选项]
cls
echo %blue_fg_strong%/ 主页 / 工具箱 / APP卸载%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?

echo 1. 文本生成
echo 2. 语音生成
echo 3. 图片生成 
echo 4. 核心app
echo 0. 返回

set /p app_uninstaller_choice=选择: 

REM ############## 卸载选项 - BACKEND ####################
if "%app_uninstaller_choice%"=="1" (
    call :app_uninstaller_text_completion
) else if "%app_uninstaller_choice%"=="2" (
    call :app_uninstaller_voice_generation
) else if "%app_uninstaller_choice%"=="3" (
    call :app_uninstaller_image_generation
) else if "%app_uninstaller_choice%"=="4" (
    call :app_uninstaller_core_utilities
) else if "%app_uninstaller_choice%"=="0" (
    goto :toolbox
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_uninstaller
)



REM ############################################################
REM ######## 卸载选项 文本生成 - FRONTEND ########
REM ############################################################
:app_uninstaller_text_completion
title STL [卸载选项 文本生成]
cls
echo %blue_fg_strong%/ 主页 / 工具箱 / APP卸载 / 文本生成%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?

echo 1. 卸载 Text generation web UI oobabooga
echo 2. 卸载 koboldcpp
echo 3. 卸载 TabbyAPI
echo 4. 卸载 llamacpp
echo 0. 返回

set /p app_uninstaller_text_completion_choice=选择: 

REM ####### 卸载选项 文本生成 - BACKEND ##########
if "%app_uninstaller_text_completion_choice%"=="1" (
    set "caller=app_uninstaller_text_completion"
    if exist "%app_uninstaller_text_completion_dir%\uninstall_ooba.bat" (
        call %app_uninstaller_text_completion_dir%\uninstall_ooba.bat
        goto :app_uninstaller_text_completion
    ) else (
        echo [%DATE% %TIME%] 错误: uninstall_ooba.bat 没找到 in: %app_uninstaller_text_completion_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] uninstall_ooba.bat 没找到 in: %app_uninstaller_text_completion_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 运行自动修复...
        git pull
        pause
        goto :app_uninstaller_text_completion
    )
) else if "%app_uninstaller_text_completion_choice%"=="2" (
    set "caller=app_uninstaller_text_completion"
    if exist "%app_uninstaller_text_completion_dir%\uninstall_koboldcpp.bat" (
        call %app_uninstaller_text_completion_dir%\uninstall_koboldcpp.bat
        goto :app_uninstaller_text_completion
    ) else (
        echo [%DATE% %TIME%] 错误: uninstall_koboldcpp.bat 没找到 in: %app_uninstaller_text_completion_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] uninstall_koboldcpp.bat 没找到 in: %app_uninstaller_text_completion_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 运行自动修复...
        git pull
        pause
        goto :app_uninstaller_text_completion
    )
) else if "%app_uninstaller_text_completion_choice%"=="3" (
    set "caller=app_uninstaller_text_completion"
    if exist "%app_uninstaller_text_completion_dir%\uninstall_tabbyapi.bat" (
        call %app_uninstaller_text_completion_dir%\uninstall_tabbyapi.bat
        goto :app_uninstaller_text_completion
    ) else (
        echo [%DATE% %TIME%] 错误: uninstall_tabbyapi.bat 没找到 in: %app_uninstaller_text_completion_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] uninstall_tabbyapi.bat 没找到 in: %app_uninstaller_text_completion_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 运行自动修复...
        git pull
        pause
        goto :app_uninstaller_text_completion
    )
) else if "%app_uninstaller_text_completion_choice%"=="4" (
    set "caller=app_uninstaller_text_completion"
    if exist "%app_uninstaller_text_completion_dir%\uninstall_llamacpp.bat" (
        call %app_uninstaller_text_completion_dir%\uninstall_llamacpp.bat
        goto :app_uninstaller_text_completion
    ) else (
        echo [%DATE% %TIME%] 错误: uninstall_llamacpp.bat 没找到 in: %app_uninstaller_text_completion_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] uninstall_llamacpp.bat 没找到 in: %app_uninstaller_text_completion_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 运行自动修复...
        git pull
        pause
        goto :app_uninstaller_text_completion
    )
) else if "%app_uninstaller_text_completion_choice%"=="0" (
    goto :app_uninstaller
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_uninstaller_text_completion
)



REM ############################################################
REM ######## 卸载选项 语音生成 - FRONTEND #######
REM ############################################################
:app_uninstaller_voice_generation
title STL [卸载选项 语音生成]
cls
echo %blue_fg_strong%/ 主页 / 工具箱 / APP卸载 / 语音生成%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?

echo 1. 卸载 AllTalk
echo 2. 卸载 XTTS
echo 3. 卸载 rvc
echo 0. 返回

set /p app_uninstaller_voice_gen_choice=选择: 

REM ######## 卸载选项 语音生成 - BACKEND #########
if "%app_uninstaller_voice_gen_choice%"=="1" (
    set "caller=app_uninstaller_voice_generation"
    if exist "%app_uninstaller_voice_generation_dir%\uninstall_alltalk.bat" (
        call %app_uninstaller_voice_generation_dir%\uninstall_alltalk.bat
        goto :app_uninstaller_voice_generation
    ) else (
        echo [%DATE% %TIME%] 错误: uninstall_alltalk.bat 没找到 in: %app_uninstaller_voice_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] uninstall_alltalk.bat 没找到 in: %app_uninstaller_voice_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 运行自动修复...
        git pull
        pause
        goto :app_uninstaller_voice_generation
    )
) else if "%app_uninstaller_voice_gen_choice%"=="2" (
    set "caller=app_uninstaller_voice_generation"
    if exist "%app_uninstaller_voice_generation_dir%\uninstall_xtts.bat" (
        call %app_uninstaller_voice_generation_dir%\uninstall_xtts.bat
        goto :app_uninstaller_voice_generation
    ) else (
        echo [%DATE% %TIME%] 错误: uninstall_xtts.bat 没找到 in: %app_uninstaller_voice_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] uninstall_xtts.bat 没找到 in: %app_uninstaller_voice_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 运行自动修复...
        git pull
        pause
        goto :app_uninstaller_voice_generation
    )
) else if "%app_uninstaller_voice_gen_choice%"=="3" (
    set "caller=app_uninstaller_voice_generation"
    if exist "%app_uninstaller_voice_generation_dir%\uninstall_rvc.bat" (
        call %app_uninstaller_voice_generation_dir%\uninstall_rvc.bat
        goto :app_uninstaller_voice_generation
    ) else (
        echo [%DATE% %TIME%] 错误: uninstall_rvc.bat 没找到 in: %app_uninstaller_voice_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] uninstall_rvc.bat 没找到 in: %app_uninstaller_voice_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 运行自动修复...
        git pull
        pause
        goto :app_uninstaller_voice_generation
    )
) else if "%app_uninstaller_voice_gen_choice%"=="0" (
    goto :app_uninstaller
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_uninstaller_voice_generation
)



REM ############################################################
REM ######## 卸载选项 图像生成 - FRONTEND #######
REM ############################################################
:app_uninstaller_image_generation
title STL [卸载选项 图像生成]
cls
echo %blue_fg_strong%/ 主页 / 工具箱 / APP卸载 / 图片生成%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?

echo 1. 卸载 Stable Diffusion web UI
echo 2. 卸载 Stable Diffusion web UI Forge
echo 3. 卸载 ComfyUI
echo 4. 卸载 Fooocus
echo 0. 返回

set /p app_uninstaller_img_gen_choice=选择: 

REM ######## 卸载选项 图像生成 - BACKEND #########
if "%app_uninstaller_img_gen_choice%"=="1" (
    set "caller=app_uninstaller_image_generation"
    if exist "%app_uninstaller_image_generation_dir%\uninstall_sdwebui.bat" (
        call %app_uninstaller_image_generation_dir%\uninstall_sdwebui.bat
        goto :app_uninstaller_image_generation
    ) else (
        echo [%DATE% %TIME%] 错误: uninstall_sdwebui.bat 没找到 in: %app_uninstaller_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] uninstall_sdwebui.bat 没找到 in: %app_uninstaller_image_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 运行自动修复...
        git pull
        pause
        goto :app_uninstaller_image_generation
    )
) else if "%app_uninstaller_img_gen_choice%"=="2" (
    set "caller=app_uninstaller_image_generation"
    if exist "%app_uninstaller_image_generation_dir%\uninstall_sdwebuiforge.bat" (
        call %app_uninstaller_image_generation_dir%\uninstall_sdwebuiforge.bat
        goto :app_uninstaller_image_generation
    ) else (
        echo [%DATE% %TIME%] 错误: uninstall_sdwebuiforge.bat 没找到 in: %app_uninstaller_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] uninstall_sdwebuiforge.bat 没找到 in: %app_uninstaller_image_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 运行自动修复...
        git pull
        pause
        goto :app_uninstaller_image_generation
    )
) else if "%app_uninstaller_img_gen_choice%"=="3" (
    set "caller=app_uninstaller_image_generation"
    if exist "%app_uninstaller_image_generation_dir%\uninstall_comfyui.bat" (
        call %app_uninstaller_image_generation_dir%\uninstall_comfyui.bat
        goto :app_uninstaller_image_generation
    ) else (
        echo [%DATE% %TIME%] 错误: uninstall_comfyui.bat 没找到 in: %app_uninstaller_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] uninstall_comfyui.bat 没找到 in: %app_uninstaller_image_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 运行自动修复...
        git pull
        pause
        goto :app_uninstaller_image_generation
    )
) else if "%app_uninstaller_img_gen_choice%"=="4" (
    set "caller=app_uninstaller_image_generation"
    if exist "%app_uninstaller_image_generation_dir%\uninstall_fooocus.bat" (
        call %app_uninstaller_image_generation_dir%\uninstall_fooocus.bat
        goto :app_uninstaller_image_generation
    ) else (
        echo [%DATE% %TIME%] 错误: uninstall_fooocus.bat 没找到 in: %app_uninstaller_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] uninstall_fooocus.bat 没找到 in: %app_uninstaller_image_generation_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 运行自动修复...
        git pull
        pause
        goto :app_uninstaller_image_generation
    )
) else if "%app_uninstaller_img_gen_choice%"=="0" (
    goto :app_uninstaller
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_uninstaller_image_generation
)


REM ############################################################
REM ######## 卸载选项 CORE UTILITIES - FRONTEND #########
REM ############################################################
:app_uninstaller_core_utilities
title STL [卸载选项 核心APP]
cls
echo %blue_fg_strong%/ 主页 / 工具箱 / APP卸载 / 核心app%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?
echo 1. 卸载 Extras
echo 2. 卸载 SillyTavern
echo 3. 卸载 7-Zip
echo 4. 卸载 FFmpeg
echo 5. 卸载 Node.js
echo 6. 卸载 yq
echo 7. 卸载 CUDA Toolkit
echo 8. 卸载 Visual Studio BuildTools
echo 9. 卸载 w64devkit
echo 0. 返回

set /p app_uninstaller_core_utilities_choice=选择: 

REM ######## 卸载选项 CORE UTILITIES - BACKEND #########
if "%app_uninstaller_core_utilities_choice%"=="1" (
    set "caller=app_uninstaller_core_utilities"
    if exist "%app_uninstaller_core_utilities_dir%\uninstall_extras.bat" (
        call %app_uninstaller_core_utilities_dir%\uninstall_extras.bat
        goto :app_uninstaller_core_utilities
    ) else (
        echo [%DATE% %TIME%] 错误: uninstall_extras.bat 没找到 in: %app_uninstaller_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] uninstall_extras.bat 没找到 in: %app_uninstaller_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 运行自动修复...
        git pull
        pause
        goto :app_uninstaller_core_utilities
    )
) else if "%app_uninstaller_core_utilities_choice%"=="2" (
    set "caller=app_uninstaller_core_utilities"
    if exist "%app_uninstaller_core_utilities_dir%\uninstall_st.bat" (
        call %app_uninstaller_core_utilities_dir%\uninstall_st.bat
        goto :app_uninstaller_core_utilities
    ) else (
        echo [%DATE% %TIME%] 错误: uninstall_st.bat 没找到 in: %app_uninstaller_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] uninstall_st.bat 没找到 in: %app_uninstaller_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 运行自动修复...
        git pull
        pause
        goto :app_uninstaller_core_utilities
    )
) else if "%app_uninstaller_core_utilities_choice%"=="3" (
    set "caller=app_uninstaller_core_utilities"
    if exist "%app_uninstaller_core_utilities_dir%\uninstall_7zip.bat" (
        call %app_uninstaller_core_utilities_dir%\uninstall_7zip.bat
        goto :app_uninstaller_core_utilities
    ) else (
        echo [%DATE% %TIME%] 错误: uninstall_7zip.bat 没找到 in: %app_uninstaller_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] uninstall_7zip.bat 没找到 in: %app_uninstaller_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 运行自动修复...
        git pull
        pause
        goto :app_uninstaller_core_utilities
    )
) else if "%app_uninstaller_core_utilities_choice%"=="4" (
    set "caller=app_uninstaller_core_utilities"
    if exist "%app_uninstaller_core_utilities_dir%\uninstall_ffmpeg.bat" (
        call %app_uninstaller_core_utilities_dir%\uninstall_ffmpeg.bat
        goto :app_uninstaller_core_utilities
    ) else (
        echo [%DATE% %TIME%] 错误: uninstall_ffmpeg.bat 没找到 in: %app_uninstaller_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] uninstall_ffmpeg.bat 没找到 in: %app_uninstaller_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 运行自动修复...
        git pull
        pause
        goto :app_uninstaller_core_utilities
    )
) else if "%app_uninstaller_core_utilities_choice%"=="5" (
    set "caller=app_uninstaller_core_utilities"
    if exist "%app_uninstaller_core_utilities_dir%\uninstall_nodejs.bat" (
        call %app_uninstaller_core_utilities_dir%\uninstall_nodejs.bat
        goto :app_uninstaller_core_utilities
    ) else (
        echo [%DATE% %TIME%] 错误: uninstall_nodejs.bat 没找到 in: %app_uninstaller_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] uninstall_nodejs.bat 没找到 in: %app_uninstaller_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 运行自动修复...
        git pull
        pause
        goto :app_uninstaller_core_utilities
    )
) else if "%app_uninstaller_core_utilities_choice%"=="6" (
    set "caller=app_uninstaller_core_utilities"
    if exist "%app_uninstaller_core_utilities_dir%\uninstall_yq.bat" (
        call %app_uninstaller_core_utilities_dir%\uninstall_yq.bat
        goto :app_uninstaller_core_utilities
    ) else (
        echo [%DATE% %TIME%] 错误: uninstall_yq.bat 没找到 in: %app_uninstaller_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] uninstall_yq.bat 没找到 in: %app_uninstaller_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 运行自动修复...
        git pull
        pause
        goto :app_uninstaller_core_utilities
    )
) else if "%app_uninstaller_core_utilities_choice%"=="7" (
    set "caller=app_uninstaller_core_utilities"
    if exist "%app_uninstaller_core_utilities_dir%\uninstall_cudatoolkit.bat" (
        call %app_uninstaller_core_utilities_dir%\uninstall_cudatoolkit.bat
        goto :app_uninstaller_core_utilities
    ) else (
        echo [%DATE% %TIME%] 错误: uninstall_cudatoolkit.bat 没找到 in: %app_uninstaller_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] uninstall_cudatoolkit.bat 没找到 in: %app_uninstaller_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 运行自动修复...
        git pull
        pause
        goto :app_uninstaller_core_utilities
    )
) else if "%app_uninstaller_core_utilities_choice%"=="8" (
    set "caller=app_uninstaller_core_utilities"
    if exist "%app_uninstaller_core_utilities_dir%\uninstall_vsbuildtools.bat" (
        call %app_uninstaller_core_utilities_dir%\uninstall_vsbuildtools.bat
        goto :app_uninstaller_core_utilities
    ) else (
        echo [%DATE% %TIME%] 错误: uninstall_vsbuildtools.bat 没找到 in: %app_uninstaller_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] uninstall_vsbuildtools.bat 没找到 in: %app_uninstaller_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 运行自动修复...
        git pull
        pause
        goto :app_uninstaller_core_utilities
    )
) else if "%app_uninstaller_core_utilities_choice%"=="9" (
    set "caller=app_uninstaller_core_utilities"
    if exist "%app_uninstaller_core_utilities_dir%\uninstall_w64devkit.bat" (
        call %app_uninstaller_core_utilities_dir%\uninstall_w64devkit.bat
        goto :app_uninstaller_core_utilities
    ) else (
        echo [%DATE% %TIME%] 错误: uninstall_w64devkit.bat 没找到 in: %app_uninstaller_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] uninstall_w64devkit.bat 没找到 in: %app_uninstaller_core_utilities_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 运行自动修复...
        git pull
        pause
        goto :app_uninstaller_core_utilities
    )
) else if "%app_uninstaller_core_util_choice%"=="0" (
    goto :app_uninstaller
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :app_uninstaller_core_utilities
)


REM ############################################################
REM ################# 编辑选项 - FRONTEND ########################
REM ############################################################
:editor
title STL [编辑选项]
cls
echo %blue_fg_strong%/ 主页 / 工具箱 / 编辑选项%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?

echo 1. 文本生成
echo 2. 语音生成 
echo 3. 图片生成 
echo 4. 核心app
echo 0. 返回

set /p editor_choice=选择: 

REM ################# 编辑选项 - BACKEND ########################
if "%editor_choice%"=="1" (
    call :editor_text_completion
) else if "%editor_choice%"=="2" (
    call :editor_voice_generation
) else if "%editor_choice%"=="3" (
    call :editor_image_generation
) else if "%editor_choice%"=="4" (
    call :editor_core_utilities
) else if "%editor_choice%"=="0" (
    goto :toolbox
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :editor
)


REM ############################################################
REM ######## 编辑选项 文本生成 - FRONTEND #################
REM ############################################################
:editor_text_completion
title STL [编辑选项 文本生成]
cls
echo %blue_fg_strong%/ 主页 / 工具箱 / 编辑选项 / 文本生成%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?

echo 1. 编辑 Text generation web UI oobabooga
echo 2. 编辑 koboldcpp
echo 3. 编辑 TabbyAPI
echo 0. 返回

set /p editor_text_completion_choice=选择: 

REM ####### 编辑选项 文本生成 - BACKEND ##########
if "%editor_text_completion_choice%"=="1" (
    set "caller=editor_text_completion"
    if exist "%editor_text_completion_dir%\edit_ooba_modules.bat" (
        call %editor_text_completion_dir%\edit_ooba_modules.bat
        goto :editor_text_completion
    ) else (
        echo [%DATE% %TIME%] 错误: edit_ooba_modules.bat 没找到 in: %editor_text_completion_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] edit_ooba_modules.bat 没找到 in: %editor_text_completion_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 运行自动修复...
        git pull
        pause
        goto :editor_text_completion
    )
) else if "%editor_text_completion_choice%"=="2" (
    set "caller=editor_text_completion"
    if exist "%editor_text_completion_dir%\edit_koboldcpp_modules.bat" (
        call %editor_text_completion_dir%\edit_koboldcpp_modules.bat
        goto :editor_text_completion
    ) else (
        echo [%DATE% %TIME%] 错误: edit_koboldcpp_modules.bat 没找到 in: %editor_text_completion_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] edit_koboldcpp_modules.bat 没找到 in: %editor_text_completion_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 运行自动修复...
        git pull
        pause
        goto :editor_text_completion
    )
) else if "%editor_text_completion_choice%"=="3" (
    set "caller=editor_text_completion"
    if exist "%editor_text_completion_dir%\edit_tabbyapi_modules.bat" (
        call %editor_text_completion_dir%\edit_tabbyapi_modules.bat
        goto :editor_text_completion
    ) else (
        echo [%DATE% %TIME%] 错误: edit_tabbyapi_modules.bat.bat 没找到 in: %editor_text_completion_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] edit_tabbyapi_modules.bat 没找到 in: %editor_text_completion_dir%%reset%
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 运行自动修复...
        git pull
        pause
        goto :editor_text_completion
    )
) else if "%editor_text_completion_choice%"=="0" (
    goto :editor
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :editor_text_completion
)

REM ############################################################
REM ######## 编辑选项 语音生成 - FRONTEND ################
REM ############################################################
:editor_voice_generation
title STL [编辑选项 语音生成]
cls
echo %blue_fg_strong%/ 主页 / 工具箱 / 编辑选项 / 语音生成%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?

echo 1. 编辑 XTTS Modules
echo 0. 返回

set /p editor_voice_generation_choice=选择: 

REM ######## 编辑选项 语音生成 - BACKEND #########
if "%editor_voice_generation_choice%"=="1" (
    set "caller=editor_voice_generation"
    if exist "%editor_voice_generation_dir%\edit_xtts_modules.bat" (
        call %editor_voice_generation_dir%\edit_xtts_modules.bat
        goto :editor_voice_generation
    ) else (
        echo [%DATE% %TIME%] 错误: edit_xtts_modules.bat 没找到 in: %editor_voice_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] edit_xtts_modules.bat 没找到 in: %editor_voice_generation_dir%%reset%
        pause
        goto :editor_voice_generation
    )
) else if "%editor_voice_generation_choice%"=="0" (
    goto :editor
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :editor_voice_generation
)


REM ############################################################
REM ######## 编辑选项 图像生成 - FRONTEND ################
REM ############################################################
:editor_image_generation
title STL [编辑选项 图像生成]
cls
echo %blue_fg_strong%/ 主页 / 工具箱 / 编辑选项 / 图片生成%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?

echo 1. 编辑 Stable Diffusion web UI
echo 2. 编辑 Stable Diffusion web UI Forge
echo 3. 编辑 ComfyUI
echo 4. 编辑 Fooocus
echo 0. 返回

set /p editor_image_generation_choice=选择: 

REM ######## 编辑选项 图像生成 - BACKEND #########
if "%editor_image_generation_choice%"=="1" (
    set "caller=editor_image_generation"
    if exist "%editor_image_generation_dir%\edit_sdwebui_modules.bat" (
        call %editor_image_generation_dir%\edit_sdwebui_modules.bat
        goto :editor_image_generation
    ) else (
        echo [%DATE% %TIME%] 错误: edit_sdwebui_modules.bat 没找到 in: %editor_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] edit_sdwebui_modules.bat 没找到 in: %editor_image_generation_dir%%reset%
        pause
        goto :editor_image_generation
    )
) else if "%editor_image_generation_choice%"=="2" (
    set "caller=editor_image_generation"
    if exist "%editor_image_generation_dir%\edit_sdwebuiforge_modules.bat" (
        call %editor_image_generation_dir%\edit_sdwebuiforge_modules.bat
        goto :editor_image_generation
    ) else (
        echo [%DATE% %TIME%] 错误: edit_sdwebuiforge_modules.bat 没找到 in: %editor_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] edit_sdwebuiforge_modules.bat 没找到 in: %editor_image_generation_dir%%reset%
        pause
        goto :editor_image_generation
    )
) else if "%editor_image_generation_choice%"=="3" (
    set "caller=editor_image_generation"
    if exist "%editor_image_generation_dir%\edit_comfyui_modules.bat" (
        call %editor_image_generation_dir%\edit_comfyui_modules.bat
        goto :editor_image_generation
    ) else (
        echo [%DATE% %TIME%] 错误: edit_comfyui_modules.bat 没找到 in: %editor_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] edit_comfyui_modules.bat 没找到 in: %editor_image_generation_dir%%reset%
        pause
        goto :editor_image_generation
    )
) else if "%editor_image_generation_choice%"=="4" (
    set "caller=editor_image_generation"
    if exist "%editor_image_generation_dir%\edit_fooocus_modules.bat" (
        call %editor_image_generation_dir%\edit_fooocus_modules.bat
        goto :editor_image_generation
    ) else (
        echo [%DATE% %TIME%] 错误: edit_fooocus_modules.bat 没找到 in: %editor_image_generation_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] edit_fooocus_modules.bat 没找到 in: %editor_image_generation_dir%%reset%
        pause
        goto :editor_image_generation
    )
) else if "%editor_image_generation_choice%"=="0" (
    goto :editor
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :editor_image_generation
)


REM ############################################################
REM ######## 编辑选项 CORE UTILITIES - FRONTEND ##################
REM ############################################################
:editor_core_utilities
title STL [编辑选项 核心APP]
cls
set "SSL_INFO_FILE=%~dp0SillyTavern\certs\SillyTavernSSLInfo.txt"
set "sslOption=2. Create and Use Self-Signed SSL Certificate with SillyTavern to encrypt your connection &echo       %blue_fg_strong%Read More: https://sillytavernai.com/launcher-ssl (press 9 to open)%reset%"

REM Check if the SSL info file exists and read the expiration date
if exist "%SSL_INFO_FILE%" (
    for /f "skip=2 tokens=*" %%i in ('type "%SSL_INFO_FILE%"') do (
        set "expDate=%%i"
        goto :infoFound
    )
    :infoFound
        set "sslOption=2. Regenerate SillyTavern SSL - %expDate% &echo     %blue_fg_strong%SSL NOTE 1: You%reset% %red_fg_strong%WILL%reset% %blue_fg_strong%need to add the Self-Signed Cert as trusted in your browser on first launch. How to here: https://sillytavernai.com/launcher-ssl (press 9 to open)%reset% &echo     %blue_fg_strong%SSL NOTE 2: To remove the SSL press 8%reset%"

)

echo %blue_fg_strong%/ 主页 / 工具箱 / 编辑选项 / 核心app%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?
echo 1. 编辑 SillyTavern config.yaml
echo %sslOption%
echo 3. 编辑 Extras
echo 4. 编辑 Environment Variables
echo 0. 返回

set /p editor_core_utilities_choice=选择: 

REM ######## 编辑选项 CORE UTILITIES - FRONTEND ##################
if "%editor_core_utilities_choice%"=="1" (
    set "caller=editor_core_utilities"
    if exist "%editor_core_utilities_dir%\edit_st_config.bat" (
        call %editor_core_utilities_dir%\edit_st_config.bat
        goto :editor_core_utilities
    ) else (
        echo [%DATE% %TIME%] 错误: edit_st_config.bat 没找到 in: %editor_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] edit_st_config.bat 没找到 in: %editor_core_utilities_dir%%reset%
        pause
        goto :editor_core_utilities
    )
) else if "%editor_core_utilities_choice%"=="2" (
    call :create_st_ssl
) else if "%editor_core_utilities_choice%"=="3" (
    set "caller=editor_core_utilities"
    if exist "%editor_core_utilities_dir%\edit_extras_modules.bat" (
        call %editor_core_utilities_dir%\edit_extras_modules.bat
        goto :editor_core_utilities
    ) else (
        echo [%DATE% %TIME%] 错误: edit_extras_modules.bat 没找到 in: %editor_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] edit_extras_modules.bat 没找到 in: %editor_core_utilities_dir%%reset%
        pause
        goto :editor_core_utilities
    )
) else if "%editor_core_utilities_choice%"=="4" (
    set "caller=editor_core_utilities"
    if exist "%editor_core_utilities_dir%\edit_env_var.bat" (
        call %editor_core_utilities_dir%\edit_env_var.bat
        goto :editor_core_utilities
    ) else (
        echo [%DATE% %TIME%] 错误: edit_env_var.bat 没找到 in: %editor_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] edit_env_var.bat 没找到 in: %editor_core_utilities_dir%%reset%
        pause
        goto :editor_core_utilities
    )
) else if "%editor_core_utilities_choice%"=="8" (
    goto :delete_st_ssl
) else if "%editor_core_utilities_choice%"=="9" (
    echo Opening SillyTavernai.com SSL Info Page
    start "" "https://sillytavernai.com/launcher-ssl"
    goto :editor_core_utilities
) else if "%editor_core_utilities_choice%"=="0" (
    goto :editor
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :editor_core_utilities
)

:create_st_ssl
call "%functions_dir%\SSL\create_ssl.bat" no-pause
REM Check the error level returned by the main batch file
if %errorlevel% equ 0 (
    echo  %green_fg_strong%The SSL was created successfully.%reset%
) else (
    echo  %red_fg_strong%The SSL creation encountered an error. Please see \bin\SSL-Certs\ssl_error_log.txt for more info.%reset%
)
pause
goto :editor_core_utilities

:delete_st_ssl
REM Check if the SillyTavern\certs folder exists and delete it if it does
set "CERTS_DIR=%~dp0SillyTavern\certs"

if exist "%CERTS_DIR%" (
    echo %blue_fg_strong%Deleting %CERTS_DIR% ...%reset%
    rmdir /s /q "%CERTS_DIR%"
    if errorlevel 0 (
        echo  %green_fg_strong%The SillyTavern\certs folder has been successfully deleted.%reset%
    ) else (
        echo  %red_fg_strong%Failed to delete the SillyTavern\certs folder. Please check if the folder is in use and try again.%reset%
    )
) else (
    echo  %red_fg_strong%The SillyTavern\certs folder does not exist.%reset%
)
pause
goto :editor_core_utilities


REM ############################################################
REM ############## TROUBLESHOOTING - FRONTEND ##################
REM ############################################################
:troubleshooting
title STL [故障排除]
cls
echo %blue_fg_strong%/ 主页 / 工具箱 / 故障排除%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?
echo 1. R移除 node_modules 文件夹
echo 2. 清除 pip 缓存
echo 3. 修复未解决的冲突或未合并的文件[SillyTavern]
echo 4. 导出dxdiag信息
echo 5. 查找正在使用端口的应用程序
echo 6. 设定数据流[Set Onboarding Flow]
echo 0. 返回

REM Retrieve the PID of the current script using PowerShell TEMPORARY DISABLED UNTIL A BETTER WAY IS FOUND

REM for /f "delims=" %%G in ('powershell -NoProfile -Command "Get-Process | Where-Object { $_.MainWindowTitle -eq '%stl_title_pid%' } | Select-Object -ExpandProperty Id"') do (
REM     set "stl_PID=%%~G"
REM )
REM echo ======== INFO BOX ===============
REM echo STL PID: %cyan_fg_strong%%stl_PID%%reset%
REM echo =================================

set /p troubleshooting_choice=选择: 


REM ############## TROUBLESHOOTING - BACKEND ##################
if "%troubleshooting_choice%"=="1" (
    set "caller=troubleshooting"

    if exist "%troubleshooting_dir%\remove_node_modules.bat" (
        call %troubleshooting_dir%\remove_node_modules.bat
    ) else (
        echo [%DATE% %TIME%] 错误: remove_node_modules.bat 没找到 in: %troubleshooting_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] remove_node_modules.bat 没找到 in: %troubleshooting_dir%%reset%
        pause
        goto :troubleshooting
    )
) else if "%troubleshooting_choice%"=="2" (
    set "caller=troubleshooting"

    if exist "%troubleshooting_dir%\remove_pip_cache.bat" (
        call %troubleshooting_dir%\remove_pip_cache.bat
    ) else (
        echo [%DATE% %TIME%] 错误: remove_pip_cache.bat 没找到 in: %troubleshooting_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] remove_pip_cache.bat 没找到 in: %troubleshooting_dir%%reset%
        pause
        goto :troubleshooting
    )
) else if "%troubleshooting_choice%"=="3" (
    set "caller=troubleshooting"

    if exist "%troubleshooting_dir%\fix_github_conflicts.bat" (
        call %troubleshooting_dir%\fix_github_conflicts.bat
    ) else (
        echo [%DATE% %TIME%] 错误: fix_github_conflicts.bat 没找到 in: %troubleshooting_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] fix_github_conflicts.bat 没找到 in: %troubleshooting_dir%%reset%
        pause
        goto :troubleshooting
    )
) else if "%troubleshooting_choice%"=="4" (
    set "caller=troubleshooting"

    if exist "%troubleshooting_dir%\export_dxdiag.bat" (
        call %troubleshooting_dir%\export_dxdiag.bat
    ) else (
        echo [%DATE% %TIME%] 错误: export_dxdiag.bat 没找到 in: %troubleshooting_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] export_dxdiag.bat 没找到 in: %troubleshooting_dir%%reset%
        pause
        goto :troubleshooting
    )
) else if "%troubleshooting_choice%"=="5" (
    set "caller=troubleshooting"

    if exist "%troubleshooting_dir%\find_app_port.bat" (
        call %troubleshooting_dir%\find_app_port.bat
    ) else (
        echo [%DATE% %TIME%] 错误: find_app_port.bat 没找到 in: %troubleshooting_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] find_app_port.bat 没找到 in: %troubleshooting_dir%%reset%
        pause
        goto :troubleshooting
    )
) else if "%troubleshooting_choice%"=="6" (
    set "caller=troubleshooting"

    if exist "%troubleshooting_dir%\onboarding_flow.bat" (
        call %troubleshooting_dir%\onboarding_flow.bat
    ) else (
        echo [%DATE% %TIME%] 错误: onboarding_flow.bat 没找到 in: %troubleshooting_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] onboarding_flow.bat 没找到 in: %troubleshooting_dir%%reset%
        pause
        goto :troubleshooting
    )
) else if "%troubleshooting_choice%"=="0" (
    goto :toolbox
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :troubleshooting
)



REM ############################################################
REM ############## SWITCH BRANCH - FRONTEND ####################
REM ############################################################
:switch_branch
title STL [SWITCH-BRANCH]
cls
echo %blue_fg_strong%/ 主页 / 工具箱 / 切换分支%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?
echo 1. 切换到 Release - SillyTavern
echo 2. 切换到 Staging - SillyTavern
echo 0. 返回

REM Get the current Git branch
for /f %%i in ('git branch --show-current') do set current_branch=%%i
echo ======== 版本信息 =========
echo SillyTavern branch: %cyan_fg_strong%%current_branch%%reset%
echo =================================
set /p branch_choice=选择: 

REM ################# SWITCH BRANCH - BACKEND ########################
if "%branch_choice%"=="1" (
    call :switch_branch_release_st
) else if "%branch_choice%"=="2" (
    call :switch_branch_staging_st
) else if "%branch_choice%"=="0" (
    goto :toolbox
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :switch_branch
)


:switch_branch_release_st
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% Switching to release branch...
cd /d "%st_install_path%"
git switch release
pause
goto :switch_branch


:switch_branch_staging_st
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% Switching to staging branch...
cd /d "%st_install_path%"
git switch staging
pause
goto :switch_branch


REM ############################################################
REM ################# BACKUP - FRONTEND ########################
REM ############################################################
:backup
title STL [备份]
cls

REM Check if 7-Zip is installed
7z > nul 2>&1
if %errorlevel% neq 0 (
    goto :7zip_prompt
) else (
    goto :backup_options
)

:7zip_prompt
echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] 7z command 没找到 in PATH.%reset%
echo %red_fg_strong%7-Zip 未安装或没找到 in the system PATH. 7-Zip 进行备份时需要%reset%
REM Prompt user to install 7-Zip
echo 1. 安装 7-Zip
echo 2. 取消
set /p zip_choice="你想现在安装7-Zip 吗? (这将需要在安装后重新启动Launcher): "
REM Check if the user wants to install 7-Zip
if "%zip_choice%"=="1" (
    set "caller=backup"
    if exist "%app_installer_core_utilities_dir%\install_7zip.bat" (
        call %app_installer_core_utilities_dir%\install_7zip.bat
    ) else (
        echo [%DATE% %TIME%] 错误: install_7zip.bat 没找到 in: %app_installer_core_utilities_dir% >> %logs_stl_console_path%
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] install_7zip.bat 没找到 in: %app_installer_core_utilities_dir%%reset%
        pause
        goto :toolbox
    )
) else (
    echo 7-Zip 未安装, 不能创建备份...
    pause
    goto :toolbox
)
cls

:backup_options
echo %blue_fg_strong%/ 主页 / 工具箱 / 备份%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?
echo 1. 创建 备份
echo 2. 还原 备份
echo 0. 返回

set /p backup_choice=选择: 

REM ################# BACKUP - BACKEND ########################
if "%backup_choice%"=="1" (
    set "caller=backup"
    call %backup_dir%\create_backup.bat
    if %errorlevel% equ 1 (
        goto :home
    ) else (
        goto :backup
    )
) else if "%backup_choice%"=="2" (
    set "caller=backup"
    call %backup_dir%\restore_backup.bat
        if %errorlevel% equ 1 (
        goto :home
    ) else (
        goto :backup
    )
) else if "%backup_choice%"=="0" (
    goto :toolbox
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :backup
)


REM ############################################################
REM ############## SUPPORT - FRONTEND ##########################
REM ############################################################
:support
title STL [支持]
cls
echo %blue_fg_strong%/ 主页 / 支持%reset%
echo -------------------------------------------------------------
echo 你想弄啥嘞?
echo 1. 我想提issue[不你不想]
echo 2. 文档
echo 3. Discord
echo 0. 返回

set /p support_choice=选择: 

REM ############## SUPPORT - BACKEND ##########################
if "%support_choice%"=="1" (
    call :issue_report
) else if "%support_choice%"=="2" (
    call :documentation
) else if "%support_choice%"=="3" (
    call :discord
) else if "%support_choice%"=="0" (
    goto :home
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :support
)

:issue_report
start "" "https://github.com/SillyTavern/SillyTavern-Launcher/issues/new/choose"
goto :support

:documentation
start "" "https://docs.sillytavern.app/"
goto :support

:discord
start "" "https://discord.gg/sillytavern"
goto :support




REM ############################################################
REM ############ CREATE CUSTOM SHORTCUT - FRONTEND #############
REM ########### ADDED BY ROLYAT / BLUEPRINTCODING ##############
REM ############################################################
REM Allows users to create a home menu shortcut to launch any app from the toolbox with SillyTavern in one button push

REM This function sets up the shortcut on the homepage with the users selected option, it saves the users choice in a text file called "custom-shortcut.txt" in "\bin\settings"
:create_custom_shortcut
title STL [自定义快捷方式]
cls
echo %blue_fg_strong%/ 主页 / 创建自定义快捷方式%reset%
echo -------------------------------------------------------------
echo 创建自定义快捷方式，使用SillyAvern启动任何应用程序。 
echo 要重置快捷方式，请转到: %blue_bg%/ 主页 / 工具箱%reset%
echo ---------------------------------------------------------

REM Define options and corresponding commands in a structured format
set "option1=Oobabooga"
set "option2=Koboldcpp"
set "option3=TabbyAPI"
set "option4=AllTalk"
set "option5=XTTS"
set "option6=RVC"
set "option7=Stable Diffusion"
set "option8=Stable Diffusion Forge"
set "option9=ComfyUI"
set "option10=Fooocus"

REM Display each option using a loop
for /L %%i in (1,1,10) do (
    call echo %%i. %%option%%i%%
)

echo 按 0 取消
set /p user_apps="输入你的选择: "
if "%user_apps%"=="0" goto :home

REM Array-like structure for mapping names and commands
set "command1=call :start_ooba"
set "command2=call :start_koboldcpp"
set "command3=call :start_tabbyapi"
set "command4=call :start_alltalk"
set "command5=call :start_xtts"
set "command6=call :start_rvc"
set "command7=call :start_sdwebui"
set "command8=call :start_sdwebuiforge"
set "command9=call :start_comfyui"
set "command10=call :start_fooocus"

REM Retrieve the selected application name and command
call set "shortcut_name=Start SillyTavern With %%option%user_apps%%%"
call set "command=%%command%user_apps%%%"

REM Write the custom name and command to the settings file
echo %shortcut_name% > "%~dp0bin\settings\custom-shortcut.txt"
echo %command% >> "%~dp0bin\settings\custom-shortcut.txt"

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%Shortcut "%shortcut_name%" created successfully.%reset%
pause
goto :home

REM This command launches the custom shortcut if defined, it also launches SillyTavern, can't reuse the :start_st command as it goes to :home at the end, breaking the chaining
:launch_custom_shortcut
echo Executing custom shortcut...
echo Launching SillyTavern...
REM Check if Node.js is installed
node --version > nul 2>&1
if %errorlevel% neq 0 (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] Node.js 未安装或没找到 in the PATH.%reset%
    echo %red_fg_strong%去安装 Node.js, 在:%reset% %blue_bg%/ 工具箱 / APP安装 / 核心app / 安装 Node.js%reset%
    pause
    goto :home
)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% SillyTavern 在新窗口中启动。
start cmd /k "title SillyTavern && cd /d %st_install_path% && call npm install --no-audit && node server.js && pause && popd"

if exist "%~dp0bin\settings\custom-shortcut.txt" (
    setlocal EnableDelayedExpansion
    set "lineCount=0"
    for /f "delims=" %%a in ('type "%~dp0bin\settings\custom-shortcut.txt"') do (
        set /a lineCount+=1
        if !lineCount! equ 1 (
            set "appName=%%a"
            echo Launching !appName:Start SillyTavern With=!:...
        )
        if !lineCount! equ 2 (
            set "cmd=%%a"
            echo Now executing: !cmd!
            call !cmd!
            echo !appName:Start SillyTavern With=!: Launched in a new window.
        )
    )
    endlocal
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%已创建快捷方式.%reset%
) else (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] 未找到快捷方式。请先创建.%reset%
)
pause
goto :home

REM This command is called from the toolbox, it deletes the txt file that saves the users defined shortcut
:reset_custom_shortcut
if exist "%~dp0bin\settings\custom-shortcut.txt" (
    del "%~dp0bin\settings\custom-shortcut.txt"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%自定义快捷方式已重置.%reset%
    pause
    goto :home
) else (
    echo %yellow_bg%[%time%]%reset% %yellow_fg_strong%[警告] 未找到要重置的自定义快捷方式.%reset%
    pause
    goto :toolbox
)
