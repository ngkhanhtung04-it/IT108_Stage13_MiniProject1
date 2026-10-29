@echo off
setlocal
set "ROOT=%~dp0.."
for %%I in ("%ROOT%") do set "ROOT=%%~fI"
for %%D in (docs scripts data backup) do if not exist "%ROOT%\%%D" mkdir "%ROOT%\%%D"
if not exist "%ROOT%\.env" (
    > "%ROOT%\.env" echo APP_ENV=development
    >> "%ROOT%\.env" echo DB_HOST=localhost
    >> "%ROOT%\.env" echo DB_PORT=3306
    >> "%ROOT%\.env" echo DB_NAME=greentech_demo
    >> "%ROOT%\.env" echo DB_USER=demo_user
    >> "%ROOT%\.env" echo DB_PASSWORD=CHANGE_ME_FAKE_ONLY
)
echo Da kiem tra tao du cau truc docs scripts data backup.
echo Luu y: .env la cau hinh gia dinh va duoc .gitignore loai khoi Git.
