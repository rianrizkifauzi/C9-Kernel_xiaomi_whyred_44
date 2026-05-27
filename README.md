# C9 Kernel Builder · Xiaomi Whyred (4.4)

[![Build C9 Kernel KSUN](https://github.com/rianrizkifauzi/C9-Kernel_xiaomi_whyred_44/actions/workflows/build.yml/badge.svg?branch=main)](https://github.com/rianrizkifauzi/C9-Kernel_xiaomi_whyred_44/actions/workflows/build.yml)

Automated GitHub Actions builder untuk **C9 Custom Kernel** — Linux 4.4.x untuk **Xiaomi Whyred** (Redmi Note 5 Pro / SDM636) dengan KernelSU-Next root integration.

> **Looking for download?** Lihat repo release: **[C9-Kernel_releases](https://github.com/rianrizkifauzi/C9-Kernel_releases)**
> **Version history?** Lihat **[CHANGELOG.md](CHANGELOG.md)**

---

## Specs

| Field | Value |
|---|---|
| Device | Xiaomi Whyred (Redmi Note 5 Pro) |
| SoC | Qualcomm SDM636 |
| Kernel | Linux 4.4.302 (CIP-LTS) |
| Base source | [user-why-red/android_kernel_xiaomi_sdm660_44](https://github.com/user-why-red/android_kernel_xiaomi_sdm660_44) `android-4.4-stable` |
| Toolchain | [Proton Clang](https://github.com/kdrag0n/proton-clang) |
| Root | KernelSU-Next legacy branch |
| KSU_VERSION | 33129 |
| Hooks | Manual hook from [kucingoranye/kernel_patches](https://github.com/kucingoranye/kernel_patches) |

---

## Hook integration

7 manual hooks injected via `patch -p1`:

| File | Hook | Purpose |
|---|---|---|
| `fs/exec.c` | `ksu_handle_execveat` | Intercept exec syscall (su detection) |
| `fs/stat.c` | `ksu_handle_stat` | vfs_statx hook (path hiding base) |
| `fs/open.c` | `ksu_handle_faccessat` | faccessat hook |
| `fs/read_write.c` | `ksu_handle_vfs_read` | vfs_read hook |
| `kernel/reboot.c` | `ksu_handle_sys_reboot` | sys_reboot hook (KSUN requirement) |
| `security/selinux/hooks.c` | `is_ksu_transition` | NNP/nosuid bypass for ksud spawn |
| `drivers/input/input.c` | (skipped — context conflict) | Volume-key safe-mode trigger |

Plus `path_umount` backport from kernel 5.10.9 ([backslashxx](https://github.com/kylieeXD/android_kernel_xiaomi_rosemary/commit/03dfb735ac04649b768a77a03acf88cd4528c855)) → required by KSUN driver on 4.4.

---

## Trigger build

### From GitHub UI

1. Tab **[Actions](../../actions/workflows/build.yml)**
2. Klik **Run workflow**
3. Defaults sudah work untuk whyred — tinggal `Run workflow`
4. Tunggu ~10-12 menit
5. Download zip dari [releases repo](https://github.com/rianrizkifauzi/C9-Kernel_releases/releases)

### Customize build

| Input | Default | Description |
|---|---|---|
| `kernel_repo` | `user-why-red/android_kernel_xiaomi_sdm660_44` | Source kernel repo |
| `kernel_branch` | `android-4.4-stable` | Branch name |
| `kernel_commit` | `e0183e3c` | Pin commit (or `head`) |
| `defconfig` | `auto` | Defconfig (autodetect) |
| `ksun_repo` | `ThRE-Team/KernelSU-Next` | KSU implementation |
| `ksun_branch` | `legacy` | KSU branch |
| `hook_strategy` | `kucingoranye_patch` | Hook injection method |
| `enable_susfs` | `false` | Enable SUSFS patches |

---

## Output naming

Format zip: `C9-Kernel-<codename>-KSUN-v1.0-<YYYYMMDD-HHMM>-<sha>.zip`

Example: `C9-Kernel-whyred-KSUN-v1.0-20260527-0352-e0183e3c0.zip`

---

## Credits

- **San-Kernel** ([user-why-red](https://github.com/user-why-red)) — base kernel source
- **KernelSU-Next** ([upstream](https://github.com/KernelSU-Next/KernelSU-Next), [ThRE-Team fork](https://github.com/ThRE-Team/KernelSU-Next))
- **kucingoranye** ([kernel_patches](https://github.com/kucingoranye/kernel_patches)) — manual hook + path_umount
- **Dr-TSNG / 5ec1cff** ([ZygiskNext](https://github.com/Dr-TSNG/ZygiskNext))
- **kdrag0n** ([proton-clang](https://github.com/kdrag0n/proton-clang))
- **AnyKernel3** ([osm0sis](https://github.com/osm0sis/AnyKernel3))

Built by **JorianPonomaref**.

---

## License

Build scripts under MIT. Kernel source under **GPL-2.0** (inherited from upstream).
