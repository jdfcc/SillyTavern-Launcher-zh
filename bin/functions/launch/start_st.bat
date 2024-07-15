@echo off

REM Check if the folder exists
if not exist "%st_install_path%" (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[����] Ŀ¼:%reset% %red_bg%SillyTavern%reset% %red_fg_strong%δ�ҵ�.%reset%
    echo %red_fg_strong%��ȷ��SillyAvernλ��: %~dp0%reset%
    pause
    exit /b 1
)

REM Check if Node.js is installed
node --version > nul 2>&1
if %errorlevel% neq 0 (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[����] ��ϵͳ��������PATH���Ҳ���node���%reset%
    echo %red_fg_strong%Node.jsδ��װ����ϵͳ����PATH���Ҳ�����%reset%
    echo %red_fg_strong%��װNode.js����ת��:%reset% %blue_bg%/ ������ /��װѡ�� / ����APP / ��װ Node.js%reset%
    pause
    exit /b 1
)

setlocal
set "command=%~1"
start /B cmd /C "%command%"
for /f "tokens=2 delims=," %%a in ('tasklist /FI "IMAGENAME eq cmd.exe" /FO CSV /NH') do (
    set "pid=%%a"
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[��Ϣ]%reset% ʹ��PID��������: %cyan_fg_strong%!pid!%reset%
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
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[��Ϣ]%reset% SillyTavern���´�����ʹ��SSL�򿪡�
    start cmd /k "title SillyTavern && cd /d %st_install_path% && call npm install --no-audit && call %functions_dir%\launch\log_wrapper.bat ssl"
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[��Ϣ]%reset% SillyTavern���´����д򿪡�
    start cmd /k "title SillyTavern && cd /d %st_install_path% && call npm install --no-audit && call %functions_dir%\launch\log_wrapper.bat"
)

REM Clear the old log file if it exists
if exist "%logs_st_console_path%" (
    del "%logs_st_console_path%"
)
REM Wait for log file to be created, timeout after 60 seconds (20 iterations of 3 seconds)
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[��Ϣ]%reset% �ȴ�Sillytavern��ȫ����...
set "counter=0"
:wait_for_log
timeout /t 3 > nul
set /a counter+=1
if not exist "%logs_st_console_path%" (
    if %counter% lss 20 (
        goto :wait_for_log
    ) else (
        echo %red_bg%[%time%]%reset% %red_fg_strong%[����]%reset% �Ҳ�����־�ļ����������⡣��ر�����SillyAvon����ڣ�Ȼ�����ԡ�
        pause
        goto :home
    )
)


goto :scan_log

:scan_log
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[��Ϣ]%reset% �ҵ���־�ļ�������ɨ����־�Բ��Ҵ���...

:loop
REM Use PowerShell to search for the error message
powershell -Command "try { $content = Get-Content '%logs_st_console_path%' -Raw; if ($content -match 'Error: Cannot find module') { exit 1 } elseif ($content -match 'SillyTavern is listening on:') { exit 0 } else { exit 2 } } catch { exit 2 }"
set "ps_errorlevel=%errorlevel%"

if %ps_errorlevel% equ 0 (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[��Ϣ]%reset% %green_fg_strong%SillyTavern �����ɹ�. ���ڷ���...%reset%
    timeout /t 10
    exit /b 0
) else if %ps_errorlevel% equ 1 (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[����] Node.js ����: ����δ�ҵ�%reset%
    goto :attemptnodefix
) else (
    timeout /t 3 > nul
    goto :loop
)

:attemptnodefix
set /p "choice=���й����ų����޸��˴�����? (����ǣ����ȹر��κδ򿪵�SillyTavern�����)  [Y/n]: "
if /i "%choice%"=="" set choice=Y
if /i "%choice%"=="Y" (
    set "caller=home"
    call "%troubleshooting_dir%\remove_node_modules.bat"
    if %errorlevel% equ 0 goto :home
)
exit /b 1