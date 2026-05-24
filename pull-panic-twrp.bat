@echo off
chcp 65001 >nul
title Pull Kernel Panic Log via TWRP

set "ADB=C:\Users\Krojzanovic\Documents\platform-tools\adb.exe"
set "OUT=%~dp0panic-logs"

if not exist "%OUT%" mkdir "%OUT%"

echo ========================================================
echo  TWRP PANIC LOG PULLER
echo ========================================================
echo.
echo Cara pake:
echo   1. PASTIKAN HAPE LO BOOT KE TWRP DULU (volup+power)
echo   2. Trigger reboot lewat manager dulu sebelum boot ke twrp
echo   3. Baru jalanin script ini
echo.
echo Pstore butuh root, jadi via TWRP yang udah root-by-default.
echo.
pause

echo.
echo === Cek device ===
"%ADB%" devices
echo.

echo === Pastikan partisi system udah di-mount di TWRP ===
"%ADB%" shell "mount /system 2>/dev/null; mount /data 2>/dev/null; ls /sys/fs/pstore/" 2>&1 | tee "%OUT%\pstore-list.txt"
echo.

echo === Pull pstore files ===
"%ADB%" shell "cat /sys/fs/pstore/console-ramoops-0 2>/dev/null" > "%OUT%\console-ramoops-0.log"
"%ADB%" shell "cat /sys/fs/pstore/dmesg-ramoops-0 2>/dev/null" > "%OUT%\dmesg-ramoops-0.log"
"%ADB%" shell "cat /sys/fs/pstore/ftrace-ramoops-0 2>/dev/null" > "%OUT%\ftrace-ramoops-0.log"
"%ADB%" shell "cat /proc/last_kmsg 2>/dev/null" > "%OUT%\last_kmsg.log"
"%ADB%" shell "dmesg 2>/dev/null" > "%OUT%\dmesg-current.log"

echo === File sizes ===
dir "%OUT%"
echo.
echo Cek file yg paling besar - itu yang berisi panic info.
echo Buka pake notepad dan cari 'Call trace', 'Unable to handle', 'BUG:'
echo.
pause
