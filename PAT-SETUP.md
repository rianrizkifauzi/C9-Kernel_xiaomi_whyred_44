# Personal Access Token (PAT) setup — one-time

Workflow `Build C9 Kernel KSUN` perlu publish release ke repo lain (`C9-Kernel_releases`).
Default `GITHUB_TOKEN` cuma bisa akses repo sendiri, jadi kita butuh **Personal Access Token** dengan scope `public_repo`.

## Steps (5 menit)

### 1. Create PAT

1. Buka https://github.com/settings/tokens?type=beta (atau https://github.com/settings/personal-access-tokens/new untuk fine-grained)
2. Pilih **Generate new token (classic)** — lebih simpel
3. Settings:
   - **Note:** `C9 cross-repo release publish`
   - **Expiration:** 90 days (atau No expiration)
   - **Scopes:** check **`public_repo`** (cukup, gak perlu full `repo`)
4. Klik **Generate token**
5. **COPY** token (format: `ghp_xxxxxxxxxxxxxxxxxxxxxxxx`) — hanya muncul sekali!

### 2. Add token ke builder repo

1. Buka https://github.com/rianrizkifauzi/C9-Kernel_xiaomi_whyred_44/settings/secrets/actions
2. Klik **New repository secret**
3. Settings:
   - **Name:** `RELEASES_TOKEN` (must exact)
   - **Secret:** paste token ghp_xxx
4. Klik **Add secret**

### 3. Verify

Trigger build workflow lagi. Step `Create Release (cross-repo)` harusnya success dan release ter-publish ke `C9-Kernel_releases`.

## Token rotation

Kalo expire (90 hari), repeat steps 1 + edit existing `RELEASES_TOKEN` secret dengan token baru.
