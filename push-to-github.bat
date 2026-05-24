@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul
title Push Whyred Builder ke GitHub

echo ================================================================
echo   Whyred Kernel Builder - Auto Push Script
echo ================================================================
echo.

REM === Cek Git ===
where git >nul 2>nul
if errorlevel 1 (
    echo [ERROR] Git belum terinstall.
    echo Download dulu di: https://git-scm.com/download/win
    echo.
    pause
    exit /b 1
)

REM === Cek lokasi script ===
cd /d "%~dp0"
if not exist ".github\workflows\build.yml" (
    echo [ERROR] Script ini harus dijalankan di folder whyred-ksun-susfs-build.
    echo Lokasi sekarang: %CD%
    echo.
    pause
    exit /b 1
)

echo Folder kerja: %CD%
echo.

REM === Input GitHub username ===
set /p GH_USER=Masukkan username GitHub kamu: 
if "!GH_USER!"=="" (
    echo [ERROR] Username kosong, batal.
    pause
    exit /b 1
)

REM === Cek & setup git identity ===
echo.
echo === Cek Git Identity ===
for /f "delims=" %%i in ('git config --global user.name 2^>nul') do set "GIT_NAME=%%i"
for /f "delims=" %%i in ('git config --global user.email 2^>nul') do set "GIT_EMAIL=%%i"

if "!GIT_NAME!"=="" (
    echo Git user.name belum di-set.
    set /p GIT_NAME=Nama untuk commit [default: !GH_USER!]: 
    if "!GIT_NAME!"=="" set "GIT_NAME=!GH_USER!"
    git config --global user.name "!GIT_NAME!"
    echo Set user.name = !GIT_NAME!
) else (
    echo user.name  = !GIT_NAME!
)

if "!GIT_EMAIL!"=="" (
    echo Git user.email belum di-set.
    echo.
    echo Tips: pake email noreply GitHub biar email asli ga ke-expose:
    echo   !GH_USER!@users.noreply.github.com
    echo.
    set /p GIT_EMAIL=Email untuk commit [Enter pake noreply]: 
    if "!GIT_EMAIL!"=="" set "GIT_EMAIL=!GH_USER!@users.noreply.github.com"
    git config --global user.email "!GIT_EMAIL!"
    echo Set user.email = !GIT_EMAIL!
) else (
    echo user.email = !GIT_EMAIL!
)
echo.

REM === Repo & branch ===
set "REPO_NAME=whyred-ksun-susfs-build"
set /p REPO_INPUT=Nama repo [default: %REPO_NAME%]: 
if not "!REPO_INPUT!"=="" set "REPO_NAME=!REPO_INPUT!"

set "BRANCH=main"
set /p BRANCH_INPUT=Branch name [default: main]: 
if not "!BRANCH_INPUT!"=="" set "BRANCH=!BRANCH_INPUT!"

set "REMOTE_URL=https://github.com/!GH_USER!/!REPO_NAME!.git"

echo.
echo ----------------------------------------------------------------
echo   Akan push ke: !REMOTE_URL!
echo   Branch:       !BRANCH!
echo   Author:       !GIT_NAME! ^<!GIT_EMAIL!^>
echo ----------------------------------------------------------------
echo.
echo PASTIKAN repo '!REPO_NAME!' SUDAH DIBUAT di GitHub (kosong, tanpa README).
echo Buka: https://github.com/new
echo.
set /p CONFIRM=Lanjut push? (y/N): 
if /i not "!CONFIRM!"=="y" (
    echo Dibatalkan.
    pause
    exit /b 0
)

echo.
echo === [1/6] git init ===
if exist ".git" (
    echo Git repo sudah ada, skip init.
) else (
    git init
    if errorlevel 1 goto :err
)

echo.
echo === [2/6] git add ===
git add .
if errorlevel 1 goto :err

echo.
echo === [3/6] git commit ===
git diff --cached --quiet
if errorlevel 1 (
    git commit -m "init: whyred ksun+susfs builder"
    if errorlevel 1 goto :err
) else (
    REM Cek apakah sudah ada commit
    git rev-parse HEAD >nul 2>nul
    if errorlevel 1 (
        echo [ERROR] Tidak ada perubahan dan tidak ada commit sebelumnya.
        goto :err
    ) else (
        echo Tidak ada perubahan baru, pakai commit yang sudah ada.
    )
)

echo.
echo === [4/6] git branch -M !BRANCH! ===
git branch -M !BRANCH!
if errorlevel 1 goto :err

echo.
echo === [5/6] setup remote origin ===
git remote remove origin 2>nul
git remote add origin "!REMOTE_URL!"
if errorlevel 1 goto :err

echo.
echo === [6/6] git push ===
echo.
echo Kalau ini push pertama kali, browser akan kebuka untuk login GitHub.
echo (atau prompt username/password - pake PAT di kolom password)
echo.
git push -u origin !BRANCH!
if errorlevel 1 goto :err

echo.
echo ================================================================
echo   SUKSES! Repo udah ke-push.
echo ================================================================
echo.
echo Buka: https://github.com/!GH_USER!/!REPO_NAME!
echo.
echo LANGKAH SELANJUTNYA:
echo   1. Buka link di atas
echo   2. Settings - Actions - General
echo   3. Workflow permissions: pilih "Read and write permissions" - Save
echo   4. Tab Actions - Build Whyred Kernel - Run workflow
echo.
pause
exit /b 0

:err
echo.
echo [ERROR] Step gagal. Cek pesan error di atas.
echo.
echo Tips:
echo   - Pastikan repo "!REPO_NAME!" sudah dibuat di GitHub.
echo   - Pastikan login GitHub udah benar (Git Credential Manager / browser).
echo   - Kalau "remote already exists", run script ulang aja.
echo.
pause
exit /b 1
