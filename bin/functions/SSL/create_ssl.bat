@echo off
setlocal

:: Check if a specific argument is passed to detect if called by another batch file
set "pauseRequired=false"
set "silentMode=false"
if "%~1"=="" (
    set "pauseRequired=true"
) else (
    set "silentMode=true"
)

:: Redirect output to NUL if in silent mode
if "%silentMode%"=="true" (
    set "outputRedirection=>nul 2>&1"
) else (
    set "outputRedirection="
)

REM Set the SSL certificate directory and files
set "CERT_DIR=%st_install_path%\certs"
set "CERT_FILE=%CERT_DIR%\cert.pem"
set "KEY_FILE=%CERT_DIR%\privkey.pem"
set "CERT_INFO_FILE=%CERT_DIR%\SillyTavernSSLInfo.txt"
set "ERROR_LOG=%CERT_DIR%\error_log.txt"

:: Check if the SillyTavern directory exists
if not exist "%st_install_path%" (
    echo 请先安装 SillyTavern.
    if "%pauseRequired%"=="true" pause
    endlocal
    exit /b 1
)

:: Create the SSL certificate directory if it doesn't exist
if not exist "%CERT_DIR%" (
    mkdir "%CERT_DIR%"
    echo 创建目录 %CERT_DIR% %outputRedirection%
) else (
    echo 目录 %CERT_DIR%已存在. %outputRedirection%
)

:: Check if the certificate already exists and delete it if it does
if exist "%CERT_FILE%" (
    del "%CERT_FILE%"
    echo 已删除现有证书. %outputRedirection%
)

if exist "%KEY_FILE%" (
    del "%KEY_FILE%"
    echo 已删除现有密钥. %outputRedirection%
)

:: Find the Git installation directory
for /f "delims=" %%i in ('where git') do (
    set "gitPath=%%i"
    goto :foundGit
)

:foundGit
:: Extract the directory from the git.exe path
for %%i in ("%gitPath%") do set "gitDir=%%~dpi"

:: Remove the bin\ or cmd\ part to get the main Git installation directory
set "gitDir=%gitDir:bin\=%"
set "gitDir=%gitDir:cmd\=%"

echo Git 安装在目录: %gitDir% %outputRedirection%

:: Find openssl.exe within the Git installation directory
for /f "delims=" %%i in ('dir "%gitDir%" /s /b ^| findstr \\openssl.exe') do (
    set "opensslPath=%%i"
    goto :foundOpenSSL
)

:foundOpenSSL
echo OpenSSL 目录位于: %opensslPath% %outputRedirection%

:: Generate the self-signed certificate in PEM format
echo 生成自签名证书... %outputRedirection%
"%opensslPath%" req -x509 -newkey rsa:4096 -keyout "%KEY_FILE%" -out "%CERT_FILE%" -days 825 -nodes -subj "/CN=127.0.0.1" %outputRedirection%

if %errorlevel% neq 0 goto error
echo 证书生成完成. %outputRedirection%

:: Calculate the expiration date (today + 825 days) and format as mm/dd/yyyy
for /f %%i in ('powershell -command "[datetime]::Now.AddDays(825).ToString('MM/dd/yyyy')"') do (
    set "expDate=%%i"
)

:: Store the certificate and key path, and expiration date in the text file
echo %CERT_FILE% > "%CERT_INFO_FILE%"
echo %KEY_FILE% >> "%CERT_INFO_FILE%"
echo SSL 到期日期 (mm/dd/yyyy): %expDate% >> "%CERT_INFO_FILE%"
echo 存储在中的证书和密钥路径以及到期日期 %CERT_INFO_FILE%. %outputRedirection%

echo 完成. %outputRedirection%
if "%pauseRequired%"=="true" pause
endlocal
exit /b 0

:error
echo 发生错误。请检查控制台输出以了解详细信息. %outputRedirection%
:: Log the error to the log file
echo [%date% %time%] 生成证书时出错. >> "%ERROR_LOG%"
if "%pauseRequired%"=="true" pause
endlocal
exit /b 1
goto :eof
