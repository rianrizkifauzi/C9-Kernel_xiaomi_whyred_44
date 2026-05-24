# Cara Push & Trigger Build

## 1) Buat repo di GitHub

- Buka: https://github.com/new
- Repo name: `whyred-ksun-susfs-build`
- Visibility: **Public** (biar GitHub Actions runner gratis 2000 menit/bulan)
- **JANGAN** centang "Initialize with README"
- Klik **Create repository**

## 2) Push dari laptop

Buka **Git Bash** atau PowerShell di folder `whyred-ksun-susfs-build`:

```bash
cd "C:\Users\Krojzanovic\Documents\Build Kernel\whyred-ksun-susfs-build"
git init
git add .
git commit -m "init: whyred ksun+susfs builder"
git branch -M main
git remote add origin https://github.com/<USERNAME-LU>/whyred-ksun-susfs-build.git
git push -u origin main
```

Ganti `<USERNAME-LU>` sama username GitHub kamu.

> Belum install Git? Download di https://git-scm.com/download/win

## 3) Beri permission ke Actions

- Buka repo di GitHub → **Settings** → **Actions** → **General**
- Scroll ke **Workflow permissions**
- Pilih **Read and write permissions** → **Save**
  (ini biar workflow bisa bikin Releases otomatis)

## 4) Trigger build

- Tab **Actions** → **Build Whyred Kernel (KSUN + SUSFS)**
- Klik **Run workflow** (kanan atas)
- Isi parameter (default sudah OK), klik **Run workflow**
- Tunggu ~25-40 menit

## 5) Ambil hasil

- Build sukses → tab **Releases** → download `.zip`
- Atau di tab **Actions** → run yang sukses → **Artifacts**
- Flash via TWRP / OrangeFox

## Troubleshooting

### Defconfig tidak ditemukan
Kalau log error "Defconfig not found", workflow akan list nama defconfig
yang tersedia. Re-run dengan input `defconfig` yang benar.
Default whyred biasanya: `whyred_defconfig` atau `whyred-perf_defconfig`
atau `vendor/whyred-perf_defconfig`.

### SUSFS patch reject
Kalau ada `*.rej` file di artifact, berarti patch SUSFS bentrok dengan
source kernel. Solusi:
- Coba branch SUSFS lain (`kernel-4.9` kadang lebih kompatibel kalau
  source udah di-backport)
- Atau gunakan `enable_susfs: false` dulu untuk verify KSUN-only build

### Build error "no Image produced"
Cek `build.log` di artifact. Biasanya:
- Toolchain mismatch → ganti toolchain di step "Clone toolchain"
- Compiler version → kernel 4.4 kadang gak suka clang baru

## Source Kernel Alternatif

Kalau default repo gak cocok, coba ini (semua untuk whyred 4.4):

| Repo | Branch | Catatan |
|---|---|---|
| `clarencelol/kernel_xiaomi_whyred` | `lineage-21` | Default, recent |
| `STBC1009/kernel_xiaomi_sdm660` | `lineage-20` | Multi-device sdm660 |
| `Xiaomi-SDM660/android_kernel_xiaomi_sdm660` | `lineage-21` | Group maintained |
| `engstk/op7` | n/a | (just for reference, oneplus) |

Cara ganti: Run workflow dengan input `kernel_repo` dan `kernel_branch` baru.
