# Changelog

All notable changes to **C9 Kernel for Whyred (4.4)** will be documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [v1.0] — 2026-05-27

First public release.

### Added
- Linux kernel **4.4.302** base (CIP-LTS via [San-Kernel](https://github.com/user-why-red/android_kernel_xiaomi_sdm660_44) `android-4.4-stable @ e0183e3c`)
- **KernelSU-Next legacy branch** integration as non-GKI root solution
- **Manual hooks** (7 hooks) from [kucingoranye/kernel_patches](https://github.com/kucingoranye/kernel_patches):
  - `ksu_handle_execveat` (fs/exec.c) — exec syscall intercept for su detection
  - `ksu_handle_stat` (fs/stat.c) — vfs_statx hook
  - `ksu_handle_faccessat` (fs/open.c) — faccessat path access hook
  - `ksu_handle_vfs_read` (fs/read_write.c) — vfs_read intercept
  - `ksu_handle_sys_reboot` (kernel/reboot.c) — KSUN driver requirement
  - `is_ksu_transition` (security/selinux/hooks.c) — SELinux NNP/nosuid bypass for ksud
  - `ksu_handle_input_handle_event` (drivers/input/input.c) — _skipped, context drift_
- **path_umount backport** from kernel 5.10.9 ([backslashxx](https://github.com/kylieeXD/android_kernel_xiaomi_rosemary/commit/03dfb735ac04649b768a77a03acf88cd4528c855))
- **AnyKernel3** flashable zip with custom banner
- **C9 branding**: `CONFIG_LOCALVERSION="-C9-whyred-KSUN-v1.0"`, build identity `JorianPonomaref@whyred-actions`
- **Forced KSU_VERSION = 33129** to match Manager v3.2.0-spoofed bundled ksud (fixes Shamiko / strict-check module abort)

### Tested
- Boot: ✅ stable on Whyred + qassa ROM Android 10
- KernelSU-Next Manager v3.2.0-spoofed: ✅ Working (33129)
- Zygisk Next 1.3.4-746: ✅ install via Manager normal, daemon running, both zygote (32+64) injected
- Modules install (Magisk-style): ✅ via Manager normal
- TWRP / OrangeFox flashable

### Known issues
- Shamiko module: ❌ aborts with "version abnormal" — _Shamiko itself deprecated for KSU; use Zygisk Next built-in denylist instead_
- Volume-key safe-mode trigger: ❌ not active (input.c hook skipped)
- SUSFS: ❌ not enabled in this build

### Build environment
- GitHub Actions Ubuntu 22.04
- Toolchain: [Proton Clang](https://github.com/kdrag0n/proton-clang) (latest)
- Compile flags: Clang+GNU-LD hybrid for 4.4 compat

### Credits
- Base kernel: [user-why-red/android_kernel_xiaomi_sdm660_44](https://github.com/user-why-red/android_kernel_xiaomi_sdm660_44)
- KSU driver: [ThRE-Team/KernelSU-Next](https://github.com/ThRE-Team/KernelSU-Next) `legacy` branch (synced with [upstream](https://github.com/KernelSU-Next/KernelSU-Next))
- Hook patches: [kucingoranye/kernel_patches](https://github.com/kucingoranye/kernel_patches)

---

## [Unreleased]

Future plan:
- SUSFS integration (kernel-4.4 branch)
- Multi-device support (lavender, tulip)
- Performance tweaks

---

> Built by **JorianPonomaref**. Format: [Keep a Changelog](https://keepachangelog.com/).
