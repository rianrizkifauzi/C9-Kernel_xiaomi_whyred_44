C9-Kernel-linux version-4.4
Codename: Genesis
Type: Stable

Changelog R1.0 :

_• First public release of C9-Kernel for Xiaomi Whyred (Redmi Note 5 Pro)._
_• Compiled using Proton Clang (kdrag0n) latest._
_• Bump version to Linux 4.4.302 (CIP-LTS)._
_• Base on android-4.4-stable from user-why-red/android_kernel_xiaomi_sdm660_44 (commit e0183e3c)._
_• Integrate KernelSU-Next legacy as non-GKI root solution._
_• Force KSU_VERSION to 33129 to match Manager v3.2.0-spoofed bundled ksud._
_• Apply manual hooks from kucingoranye/kernel_patches:_
_  → ksu_handle_execveat in fs/exec.c (su detection on exec syscall)._
_  → ksu_handle_stat in fs/stat.c (vfs_statx hook)._
_  → ksu_handle_faccessat in fs/open.c (path access intercept)._
_  → ksu_handle_vfs_read in fs/read_write.c (vfs_read intercept)._
_  → ksu_handle_sys_reboot in kernel/reboot.c (KSUN driver requirement)._
_  → is_ksu_transition in security/selinux/hooks.c (SELinux NNP/nosuid bypass for ksud)._
_• Backport path_umount from kernel 5.10.9 by backslashxx (required by KSUN driver on 4.4)._
_• Add C9 branding: CONFIG_LOCALVERSION="-C9-Genesis-KSUN-v1.0"._
_• Build identity: JorianPonomaref@whyred-actions._
_• AnyKernel3 flashable zip with custom banner._
_• Tested working: KernelSU-Next Manager v3.2.0 (33129), Zygisk Next 1.3.4-746, module installation via Manager normal._

Known Issues :

_• Shamiko module not supported (deprecated for KSU; use Zygisk Next built-in DenyList instead)._
_• Volume-key safe-mode trigger not active (input.c hook skipped due to context drift)._
_• SUSFS not enabled in this build._

Credits :

_• Base kernel by user-why-red (San-Kernel team)._
_• KernelSU-Next driver by ThRE-Team & upstream KernelSU-Next/KernelSU-Next._
_• Hook patches by kucingoranye._
_• Zygisk Next by 5ec1cff & Nullptr._
_• AnyKernel3 by osm0sis._
