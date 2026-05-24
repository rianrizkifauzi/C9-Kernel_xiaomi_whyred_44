@echo off
chcp 65001 >nul
title Pull Bootloop Logs

set "ADB=C:\Users\Krojzanovic\Documents\platform-tools\adb.exe"
set "OUTDIR=%~dp0bootloop-logs"

echo ================================================================
echo   Pull Bootloop Logs from Device (TWRP/OFox mode)
echo ================================================================
echo.

if not exist "%OUTDIR%" mkdir "%OUTDIR%"
echo Output: %OUTDIR%
echo.

echo === Cek koneksi ===
"%ADB%" devices
echo.

echo === [1] /proc/last_kmsg (kernel panic dari boot bootloop) ===
"%ADB%" shell "cat /proc/last_kmsg" > "%OUTDIR%\01-last_kmsg.log" 2>&1
echo Done.

echo === [2] pstore (persistent ramoops) ===
"%ADB%" shell "ls /sys/fs/pstore/" > "%OUTDIR%\02-pstore-list.txt" 2>&1
"%ADB%" shell "cat /sys/fs/pstore/console-ramoops-0" > "%OUTDIR%\02-pstore-console.log" 2>&1
"%ADB%" shell "cat /sys/fs/pstore/dmesg-ramoops-0" > "%OUTDIR%\02-pstore-dmesg.log" 2>&1
echo Done.

echo === [3] dmesg saat ini (recovery) ===
"%ADB%" shell "dmesg" > "%OUTDIR%\03-dmesg.log" 2>&1
echo Done.

echo === [4] Kernel info ===
"%ADB%" shell "cat /proc/version" > "%OUTDIR%\04-version.txt" 2>&1
"%ADB%" shell "uname -a" >> "%OUTDIR%\04-version.txt" 2>&1
echo Done.

echo === [5] Cmdline ===
"%ADB%" shell "cat /proc/cmdline" > "%OUTDIR%\05-cmdline.txt" 2>&1
echo Done.

echo === [6] Recovery cache ===
"%ADB%" shell "ls -la /cache/recovery/" > "%OUTDIR%\06-cache-list.txt" 2>&1
"%ADB%" shell "cat /cache/recovery/last_log" > "%OUTDIR%\06-recovery_last.log" 2>&1
"%ADB%" shell "cat /cache/recovery/last_kmsg" > "%OUTDIR%\06-recovery_last_kmsg.log" 2>&1
echo Done.

echo === [7] Block partitions ===
"%ADB%" shell "ls -la /dev/block/bootdevice/by-name/ 2>/dev/null | head -30" > "%OUTDIR%\07-partitions.txt" 2>&1
echo Done.

echo === [8] Rangkuman size files ===
dir "%OUTDIR%"
echo.
echo ================================================================
echo   SELESAI
echo ================================================================
echo Lokasi: %OUTDIR%
echo.
pause
