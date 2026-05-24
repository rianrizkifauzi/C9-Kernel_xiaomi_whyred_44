@echo off
chcp 65001 >nul
title Live Panic Catcher

set "ADB=C:\Users\Krojzanovic\Documents\platform-tools\adb.exe"
set "OUT=%~dp0panic-logs"

if not exist "%OUT%" mkdir "%OUT%"

echo ========================================================
echo  LIVE PANIC CATCHER (no root needed)
echo ========================================================
echo.
echo Cara pake:
echo   1. JANGAN buka manager dulu
echo   2. Pastikan hape udah booting normal ke homescreen
echo   3. Jalankan script ini DULU (akan record terus-menerus)
echo   4. Setelah script jalan, BARU buka manager rsuntk -^> tunggu reboot
echo   5. Begitu hape booting balik, balik ke jendela ini -^> Ctrl+C
echo   6. Logs akan otomatis dipull
echo.
pause

echo.
echo === Cek device ===
"%ADB%" devices
echo.

echo === Clearing logcat buffer ===
"%ADB%" logcat -c

echo.
echo === Recording logcat (semua buffer) ===
echo Ctrl+C untuk stop setelah hape reboot
echo.

start /min "" cmd /c ""%ADB%" logcat -b all -v threadtime > "%OUT%\logcat-live.log" 2>&1"
start /min "" cmd /c ""%ADB%" shell "while true; do dmesg 2>/dev/null; sleep 1; done" > "%OUT%\dmesg-stream.log" 2>&1"

echo Recording started. Sekarang BUKA MANAGER rsuntk di hape.
echo.
echo Setelah hape REBOOT dan booting balik, tekan tombol apapun di sini
echo untuk stop recording.
echo.
pause >nul

echo.
echo === Stopping recorders ===
taskkill /F /IM adb.exe >nul 2>&1
"%ADB%" start-server >nul

echo.
echo === Final pull (last_kmsg fallback) ===
"%ADB%" shell "su -c 'cat /sys/fs/pstore/console-ramoops-0' 2>/dev/null" > "%OUT%\console-ramoops-su.log" 2>&1
"%ADB%" shell "cat /proc/last_kmsg 2>/dev/null" > "%OUT%\last_kmsg-after.log" 2>&1

echo === File sizes ===
dir "%OUT%"
echo.
pause
