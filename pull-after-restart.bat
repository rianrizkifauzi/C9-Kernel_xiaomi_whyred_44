@echo off
chcp 65001 >nul
title Pull Last_kmsg After Manager Crash

set "ADB=C:\Users\Krojzanovic\Documents\platform-tools\adb.exe"
set "OUT=%~dp0crash-logs"

if not exist "%OUT%" mkdir "%OUT%"

echo === Cek device ===
"%ADB%" devices
echo.

echo === Kernel version current ===
"%ADB%" shell "cat /proc/version" > "%OUT%\version.txt" 2>&1
type "%OUT%\version.txt"
echo.

echo === [1] /proc/last_kmsg (panic dari reboot kemarin) ===
"%ADB%" shell "cat /proc/last_kmsg" > "%OUT%\last_kmsg.log" 2>&1
echo.

echo === [2] pstore (kalau ada) ===
"%ADB%" shell "ls -la /sys/fs/pstore/ 2>/dev/null" > "%OUT%\pstore-list.txt" 2>&1
"%ADB%" shell "cat /sys/fs/pstore/console-ramoops-0 2>/dev/null" > "%OUT%\pstore-console.log" 2>&1
"%ADB%" shell "cat /sys/fs/pstore/dmesg-ramoops-0 2>/dev/null" > "%OUT%\pstore-dmesg.log" 2>&1
echo.

echo === [3] dmesg current (sebelum kita restart manager) ===
"%ADB%" shell "dmesg" > "%OUT%\dmesg-current.log" 2>&1
echo.

echo === [4] Cek apakah KSU init message muncul ===
"%ADB%" shell "dmesg | grep -i ksu" > "%OUT%\dmesg-ksu.log" 2>&1
type "%OUT%\dmesg-ksu.log"
echo.

echo === [5] Manager process info ===
"%ADB%" shell "pm list packages | grep -i kernelsu" > "%OUT%\manager-package.txt" 2>&1
type "%OUT%\manager-package.txt"
echo.

echo === File sizes ===
dir "%OUT%"
echo.
echo Log saved to: %OUT%
echo Yang penting cek: last_kmsg.log
pause
