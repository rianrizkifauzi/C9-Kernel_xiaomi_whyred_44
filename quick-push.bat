@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul
title Quick Push

cd /d "%~dp0"

REM Resolve git path
set "GIT="
for %%G in (
    "C:\Program Files\Git\cmd\git.exe"
    "C:\Program Files (x86)\Git\cmd\git.exe"
    "%LOCALAPPDATA%\Programs\Git\cmd\git.exe"
) do (
    if exist "%%~G" set "GIT=%%~G"
)
if "!GIT!"=="" (
    where git >nul 2>nul && set "GIT=git"
)
if "!GIT!"=="" (
    echo [ERROR] Git not found
    pause
    exit /b 1
)

echo Using git: !GIT!
echo.

set "MSG=%~1"
if "!MSG!"=="" set "MSG=fix: rollback to v1.0.5-80-legacy (last prctl-based, fix manager panic on 4.4)"

echo === Status ===
"!GIT!" status --short
echo.

echo === Add ===
"!GIT!" add .

echo === Commit ===
"!GIT!" commit -m "!MSG!"

echo === Push ===
"!GIT!" push

echo.
echo === DONE ===
echo Cek di: https://github.com/rianrizkifauzi/whyred-ksun-susfs-build/actions
echo Trigger build manual di tab Actions.
echo.
pause
