@echo off

REM Check if the folder exists
if not exist "%st_install_path%" (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] 目录:%reset% %red_bg%SillyTavern%reset% %red_fg_strong%未找到.%reset%
    echo %red_fg_strong%请确保SillyAvern位于: %~dp0%reset%
    pause
    exit /b 1
)

REM Check if Node.js is installed
node --version > nul 2>&1
if %errorlevel% neq 0 (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] 在系统环境变量PATH中找不到node命令。%reset%
    echo %red_fg_strong%Node.js未安装或在系统变量PATH中找不到。%reset%
    echo %red_fg_strong%安装Node.js，请转到:%reset% %blue_bg%/ 工具箱 /安装选项 / 核心APP / 安装 Node.js%reset%
    pause
    exit /b 1
)

setlocal
set "command=%~1"
start /B cmd /C "%command%"
for /f "tokens=2 delims=," %%a in ('tasklist /FI "IMAGENAME eq cmd.exe" /FO CSV /NH') do (
    set "pid=%%a"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 使用PID启动进程: %cyan_fg_strong%!pid!%reset%
    echo !pid!>>"%log_dir%\pids.txt"
    goto :st_found_pid
)
:st_found_pid
endlocal

REM Check if SSL info file exists and set the command accordingly
set "sslPathsFound=false"
if exist "%SSL_INFO_FILE%" (
    for /f %%i in ('type "%SSL_INFO_FILE%"') do (
        set "sslPathsFound=true"
        goto :ST_SSL_Start
    )
)

:ST_SSL_Start
if "%sslPathsFound%"=="true" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% SillyTavern在新窗口中使用SSL打开。
    start cmd /k "title SillyTavern && cd /d %st_install_path% && call npm install --no-audit && call %functions_dir%\launch\log_wrapper.bat ssl"
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% SillyTavern在新窗口中打开。
    start cmd /k "title SillyTavern && cd /d %st_install_path% && call npm install --no-audit && call %functions_dir%\launch\log_wrapper.bat"
)

REM Clear the old log file if it exists
if exist "%logs_st_console_path%" (
    del "%logs_st_console_path%"
)
REM Wait for log file to be created, timeout after 60 seconds (20 iterations of 3 seconds)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 等待Sillytavern完全启动...
set "counter=0"
:wait_for_log
timeout /t 3 > nul
set /a counter+=1
if not exist "%logs_st_console_path%" (
    if %counter% lss 20 (
        goto :wait_for_log
    ) else (
        echo %red_bg%[%time%]%reset% %red_fg_strong%[错误]%reset% 找不到日志文件，出现问题。请关闭所有SillyAvon命令窗口，然后重试。
        pause
        goto :home
    )
)


goto :scan_log

:scan_log
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% 找到日志文件，正在扫描日志以查找错误...

:loop
REM Use PowerShell to search for the error message
powershell -Command "try { $content = Get-Content '%logs_st_console_path%' -Raw; if ($content -match 'Error: Cannot find module') { exit 1 } elseif ($content -match 'SillyTavern is listening on:') { exit 0 } else { exit 2 } } catch { exit 2 }"
set "ps_errorlevel=%errorlevel%"

if %ps_errorlevel% equ 0 (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[信息]%reset% %green_fg_strong%SillyTavern 启动成功. 正在返回...%reset%
    timeout /t 10
    exit /b 0
) else if %ps_errorlevel% equ 1 (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[错误] Node.js 代码: 依赖未找到%reset%
    goto :attemptnodefix
) else (
    timeout /t 3 > nul
    goto :loop
)

:attemptnodefix
set /p "choice=运行故障排除以修复此错误吗? (如果是，请先关闭任何打开的SillyTavern命令窗口)  [Y/n]: "
if /i "%choice%"=="" set choice=Y
if /i "%choice%"=="Y" (
    set "caller=home"
    call "%troubleshooting_dir%\remove_node_modules.bat"
    if %errorlevel% equ 0 goto :home
)
exit /b 1