@echo off
setlocal

REM Set necessary environment variables for Node.js
set NODE_ENV=production

REM Determine the command to run
if "%1"=="ssl" (
    set NODE_CMD=node server.js --ssl
) else (
    set NODE_CMD=node server.js
)

REM Start the Node.js server and log the output using PowerShell Tee-Object, suppressing specific warnings
echo 使用命令启动Node.js服务器: %NODE_CMD%
powershell -Command "& {%NODE_CMD% 2>&1 | Where-Object {$_ -notmatch 'Security has been overridden'} | Tee-Object -FilePath '%logs_st_console_path%'}"
echo Node.js服务器已启动。
pause

REM Pause to keep the window open
pause
