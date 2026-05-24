@echo off
chcp 65001 >nul
title Pull Kernel Panic Log

set "ADB=C:\Users\Krojzanovic\Documents\platform-tools\adb.exe"
set "OUT=%~dp0panic-logs"

if not exist "%OUT%" mkdir "%OUT%"

echo === Cek device ===
"%ADB%" devices
echo.

echo === Pull pstore (panic console) ===
"%ADB%" shell "ls /sys/fs/pstore/" > "%OUT%\pstore-list.txt" 2>&1
type "%OUT%\pstore-list.txt"
echo.

echo === Pull console-ramoops-0 (the panic message) ===
"%ADB%" pull /sys/fs/pstore/console-ramoops-0 "%OUT%\console-ramoops-0.log" 2>&1
echo.

echo === Pull dmesg-ramoops-0 (oops/bug) ===
"%ADB%" pull /sys/fs/pstore/dmesg-ramoops-0 "%OUT%\dmesg-ramoops-0.log" 2>&1
echo.

echo === Pull ftrace-ramoops-0 (last function trace) ===
"%ADB%" pull /sys/fs/pstore/ftrace-ramoops-0 "%OUT%\ftrace-ramoops-0.log" 2>&1
echo.

echo === Pull last_kmsg fallback ===
"%ADB%" shell "cat /proc/last_kmsg 2>/dev/null" > "%OUT%\last_kmsg.log" 2>&1
echo.

echo === File sizes ===
dir "%OUT%"
echo.
echo Logs saved to: %OUT%
echo.
echo Buka file console-ramoops-0.log untuk lihat panic message-nya.
pause
