# Whyred Kernel Builder — KernelSU Next + SUSFS

CI build pipeline untuk Xiaomi Redmi Note 5 Pro (whyred / SDM636) kernel 4.4
dengan integrasi **KernelSU Next** + **SUSFS** terbaru.

## Cara Pakai

1. Push repo ini ke akun GitHub kamu (lihat bawah).
2. Buka tab **Actions** → pilih workflow **Build Whyred Kernel**.
3. Klik **Run workflow** → isi parameter (atau pakai default).
4. Tunggu ~20-40 menit, hasil zip flashable ada di **Artifacts** + **Releases**.

## Parameter Workflow

| Input | Default | Keterangan |
|---|---|---|
| `kernel_repo` | `user-why-red/android_kernel_xiaomi_sdm660_44` | Source kernel whyred (active LTS 4.4) |
| `kernel_branch` | `android-4.4-stable` | Branch source kernel |
| `defconfig` | `auto` | Autodetect whyred/tulip/sdm660 defconfig |
| `ksun_branch` | `legacy` | KernelSU-Next branch (`legacy`=non-GKI, `legacy-susfs`=non-GKI+SUSFS, `next`=GKI only) |
| `susfs_branch` | `kernel-4.4` | Branch SUSFS dari simonpunk/susfs4ksu (hanya dipakai kalau enable_susfs=true dan ksun_branch != legacy-susfs) |
| `enable_susfs` | `false` | Apply SUSFS patches manual (set `false` kalau pakai `legacy-susfs`) |

## Push ke GitHub

```bash
cd "whyred-ksun-susfs-build"
git init
git add .
git commit -m "init: whyred ksun+susfs builder"
git branch -M main
git remote add origin https://github.com/<USERNAME>/whyred-ksun-susfs-build.git
git push -u origin main
```

## Catatan Teknis

- Build pakai **AOSP Clang r383902** (kompatibel kernel 4.4)
- AnyKernel3 zip akan di-template ulang dari `assets/anykernel/`
- Output zip: `artifacts/whyred-ksun-susfs-<sha>.zip`
- Kalau build gagal di patch SUSFS → biasanya karena conflict di `fs/namespace.c`,
  workflow akan tetap upload log error untuk debugging.

## Disclaimer

- Kernel 4.4 + SUSFS = unstable territory. Beberapa fitur SUSFS (sus_su, magic_mount)
  bisa bikin bootloop. Default config sudah di-set ke fitur yang aman.
- Kalau bootloop, flash ulang stock kernel pakai TWRP.
