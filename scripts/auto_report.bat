@echo off
setlocal EnableExtensions
chcp 65001 >nul

rem Audit: resolve every path relative to this script; no delete commands are used.
set "ROOT=%~dp0.."
for %%I in ("%ROOT%") do set "ROOT=%%~fI"
set "LOG_FILE=%ROOT%\data\log-he-thong.log"
set "REPORT_DIR=%ROOT%\backup"
set "REPORT_FILE=%REPORT_DIR%\bao-cao-su-co.txt"

echo [AUDIT] Project root: "%ROOT%"
echo [AUDIT] Log source: "%LOG_FILE%"
echo [AUDIT] Append-only report: "%REPORT_FILE%"

if not exist "%LOG_FILE%" (
    echo [ERROR] Khong tim thay file log: "%LOG_FILE%"
    exit /b 2
)
if not exist "%REPORT_DIR%" mkdir "%REPORT_DIR%"
if not exist "%REPORT_DIR%" (
    echo [ERROR] Khong tao duoc thu muc backup.
    exit /b 3
)

echo.>> "%REPORT_FILE%"
echo ===== BAO CAO SU CO HE THONG =====>> "%REPORT_FILE%"
echo Thoi gian chay: %date% %time%>> "%REPORT_FILE%"
echo Nguon: data\log-he-thong.log>> "%REPORT_FILE%"
echo Bo loc: CRITICAL, ERROR 404, TIMEOUT>> "%REPORT_FILE%"
echo ---------------------------------->> "%REPORT_FILE%"

rem type streams the file into findstr through a pipe; it does not load the whole log in a variable.
type "%LOG_FILE%" | findstr /I /C:"CRITICAL" /C:"ERROR 404" /C:"TIMEOUT" >> "%REPORT_FILE%"
set "FILTER_RC=%ERRORLEVEL%"
if "%FILTER_RC%"=="1" echo Khong tim thay dong phu hop trong lan chay nay.>> "%REPORT_FILE%"
if "%FILTER_RC%"=="2" (
    echo [ERROR] findstr gap loi khi doc/loc log.>> "%REPORT_FILE%"
    echo [ERROR] findstr gap loi khi doc/loc log.
    exit /b 4
)
echo ===== KET THUC =====>> "%REPORT_FILE%"
echo Hoan tat. Bao cao da duoc ghi noi vao: "%REPORT_FILE%"
exit /b 0
