# AviUtl2 Linux 再現手順

## 1. この文書の位置付け

本書はこのプロジェクトの正本である `docs/REPRODUCTION.md` である。原環境で確認済みの再現基準と、Nanashi で未確認の再現・検証手順を明確に分けて記載する。「確認済み」は repository evidence がある事実だけを指し、「Nanashiで未確認」は実測待ちの候補手順を指す。
Nanashi で成功した実測結果は、この `REPRODUCTION.md` の未確認部分を更新し、確認済み手順として固定する。各コードブロックは一つずつ実行し、出力・絶対パス・hash・結果を記録する。エラーまたは想定外の出力があれば停止し、本文全体を一括実行しない。
## 2. 今回変更しないもの

現在の format 69 実験で対象になるのは、同じ DXVK build 出力にある `d3d11.dll`、`dxgi.dll`、`d3d10core.dll` の三つだけである。GE-Proton の版、Wine prefix 構造、Wine DWrite、L-SMASH Works、`lsmash.ini`、`nvidia-dxvk.conf`、AviUtl2 の実行ファイルとデータ、Fcitx5、Mozc、AviUtl2 Catalog、Lutris 設定、NVIDIA driver、Vulkan ICD、既存 Nanashi 起動ラッパー、その他の DLL は変更しない。
これは新規環境の導入、全環境の import、または generic installer の手順ではない。
## 3. 確認済みの再現基準

### 原環境で確認済みの構成

[`STATUS.md`](STATUS.md) と [`FINAL-SUMMARY.md`](FINAL-SUMMARY.md) は、CachyOS の Alex 原環境で GE-Proton 11-1 / wine-staging 11.0、DXVK 2.7.1、NVIDIA GeForce RTX 4060 Ti、NVIDIA driver 610.43.3、Fcitx5/Mozc を使った動作を記録している。AviUtl2 起動、DXVK format 69 回避、AV1 の読み込み・再生・シーク、`av1_cuvid`、NVDEC、テキスト編集、Mozc、Catalog はこの原環境で確認済みである。
DXVK の基準は `2.7.1`、base commit は `c3dd74be6baec53786d4e064a572185b70347a17`、patch は [`0001-aviutl2-format-support.patch`](../patches/dxvk/0001-aviutl2-format-support.patch) である。
### patch の確認済み動作

patch は通常の `CheckFormatSupport` 処理を先に実行し、通常の成功結果を変更しない。通常の失敗後だけ、実行ファイルが `aviutl2.exe`、format が `DXGI_FORMAT_G8R8_G8B8_UNORM`（数値 69）、flags pointer が非 null の場合に flags を 0 にし、`S_OK` を返す。`VK_FORMAT_UNDEFINED` のときだけに限定しない。
### 原環境で記録された build コマンド

LutrisのWine Runner、UMU、Lutris側のDXVK管理に実行環境を任せてはならない。

```text
Lutris
└── Linux Runner
    └── 固定起動ラッパー
        ├── GE-Proton11-1-aviutl2-test
        ├── prefix-ge-nvdec-test
        ├── patched DXVK 2.7.1
        ├── patched Wine DWrite
        ├── patched L-SMASH Works
        └── AviUtl2
```

---

# 1. 現在の再現性

## 1.1 元環境で確認済み

| 項目 | 結果 |
| --- | --- |
| AviUtl2のメインウィンドウ起動 | 確認済み |
| DXVK format 69回避 | 確認済み |
| AV1ファイル読み込み | 確認済み |
| AV1再生 | 確認済み |
| シーク | 確認済み |
| `av1_cuvid` | 確認済み |
| NVDEC hardware frame transfer | 確認済み |
| テキスト選択 | 確認済み |
| テキスト編集状態への移行 | 確認済み |
| Fcitx5 / Mozc入力・変換・確定 | 確認済み |
| AviUtl2 Catalog | 確認済み |
| Catalog更新後のL-SMASH Works復旧 | 確認済み |

## 1.2 元環境の固定値

| 項目 | 値 |
| --- | --- |
| OS | CachyOS |
| GPU | NVIDIA GeForce RTX 4060 Ti 8 GB |
| NVIDIA Driver | 610.43.3 |
| GE-Proton | 11-1 |
| Wine | wine-staging 11.0 |
| DXVK | 2.7.1 |
| AviUtl2 | 2.1.2 |
| IME | Fcitx5 + Mozc |
| Prefix | `~/Games/aviutl2/prefix-ge-nvdec-test` |
| Patched GE-Proton | `~/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test` |
| DXVK base | `c3dd74be6baec53786d4e064a572185b70347a17` |
| DXVK tag | `v2.7.1` |
| Wine source base | `31af7f983b2e345d11340b120ae3a39d88c9338a` |
| L-SMASH Works base | `a47764915f06fcd472e26ba2fbf25aff4b9d252e` |
| L-SMASH Works patched commit | `393df5ef669707f776261e4ac1bcc7e9a9a227ab` |

## 1.3 未確認範囲

2026-07-31時点では、別ユーザーのクリーン環境において、すべてのコンポーネントをソースから再ビルドして最後まで動作させることには成功していない。

特に次の点は未確定である。

- 現在リポジトリにあるDXVKパッチは、元環境で使われた39行の変更を整理して作り直したものであり、元の変更とバイト単位で同一ではない
- 現在リポジトリにあるWine DWriteパッチが、元環境へ最後に導入されたDLLと完全に同一の実装であることは未確認
- L-SMASH Worksの依存ライブラリ一式について、すべてのGitコミットが固定されていない
- 別環境での完全なソース再ビルドは未完了

したがって、現段階で「確認済みの再現」と呼べるのは、動作済みバイナリを移植する経路である。

---

# 2. 絶対に守る条件

以下を同時に変更してはならない。

- WineまたはGE-Proton
- Wine prefix
- DXVK
- DWrite
- L-SMASH Works
- DLL override
- 起動コマンド

変更は必ず一段階ずつ行い、各段階で動作を確認する。

また、以下は使用しない。

- システムの`wine`コマンドによる最終起動
- Lutris Wine Runner
- UMUによるProton自動選択
- Lutris側のDXVK自動管理
- AviUtl2の`setup.exe`
- パッチが適用できない状態での`--reject`
- パッチ失敗後の手動部分適用を「再現成功」と扱うこと
- 複数のWineまたはDXVKを混在させた検証

---

# 3. ディレクトリ構成

この文書では次のパスを使用する。

```text
~/Games/aviutl2/
├── build/
├── downloads/
├── export/
├── import/
├── logs/
├── prefix-ge-nvdec-test/
├── runtime/
├── scripts/
├── src/
└── nvidia-dxvk.conf

~/.local/share/Steam/compatibilitytools.d/
└── GE-Proton11-1-aviutl2-test/
```

Fishで変数を設定する。

```fish
set ROOT \
    "$HOME/Games/aviutl2"

set REPO \
    "$HOME/projects/aviutl2-linux-patches"

set PREFIX \
    "$ROOT/prefix-ge-nvdec-test"

set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

mkdir -p \
    "$ROOT/build" \
    "$ROOT/downloads" \
    "$ROOT/export" \
    "$ROOT/import" \
    "$ROOT/logs" \
    "$ROOT/runtime" \
    "$ROOT/scripts" \
    "$ROOT/src"
```

この変数は新しいターミナルを開くたびに再設定する。

---

# 4. 必要パッケージ

CachyOS / Arch Linux系では次を導入する。

```fish
sudo pacman -S --needed \
    base-devel \
    git \
    curl \
    jq \
    libarchive \
    zstd \
    meson \
    ninja \
    glslang \
    vulkan-headers \
    mingw-w64-gcc \
    cmake \
    nasm \
    autoconf \
    automake \
    libtool \
    pkgconf \
    flex \
    bison \
    freetype2 \
    lutris
```

`bsdtar`は`libarchive`に含まれる。

`vulkan-headers`パッケージを導入しても、DXVKのGit submodule取得を省略してはならない。

NVIDIAドライバ、Vulkan ICD、Fcitx5、Mozcは使用環境に合わせて別途用意する。

確認する。

```fish
for tool in \
    git \
    curl \
    jq \
    bsdtar \
    tar \
    meson \
    ninja \
    x86_64-w64-mingw32-gcc

    command -v "$tool"
end
```

---

# 5. パッチリポジトリを取得

```fish
if test -d "$REPO/.git"
    git -C "$REPO" fetch origin
    git -C "$REPO" pull --ff-only origin main
else
    git clone \
        https://github.com/AlexanderGG-0520/aviutl2-linux-patches.git \
        "$REPO"
end
```

状態を記録する。

```fish
git -C "$REPO" status --short
git -C "$REPO" rev-parse HEAD
```

---

# 6. 推奨経路: 動作済み環境からバイナリを移植する

この経路が、2026-07-31時点の正規再現手順である。

## 6.1 元環境側で変数を設定

動作済み環境で実行する。

```fish
set ROOT \
    "$HOME/Games/aviutl2"

set PREFIX \
    "$ROOT/prefix-ge-nvdec-test"

set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINESERVER \
    "$GE_TEST/files/bin/wineserver"

set SYSTEM32 \
    "$PREFIX/drive_c/windows/system32"

set PLUGIN_DIR \
    "$PREFIX/drive_c/ProgramData/aviutl2/Plugin"

set EXPORT_PARENT \
    "$ROOT/export"

set EXPORT \
    "$EXPORT_PARENT/aviutl2-known-good"
```

## 6.2 必須ファイルを検査

```fish
for path in \
    "$GE_TEST" \
    "$SYSTEM32/d3d11.dll" \
    "$SYSTEM32/dxgi.dll" \
    "$SYSTEM32/d3d10core.dll" \
    "$PLUGIN_DIR/lwinput.aui2" \
    "$PLUGIN_DIR/lsmash.ini" \
    "$ROOT/nvidia-dxvk.conf"

    if test -e "$path"
        echo "OK: $path"
    else
        echo "MISSING: $path"
    end
end
```

1つでも`MISSING`が出た状態ではエクスポートしない。

## 6.3 Wineプロセスを停止

```fish
env \
    WINEPREFIX="$PREFIX" \
    "$GE_WINESERVER" -k \
    2>/dev/null

sleep 1
```

## 6.4 動作済みバイナリをステージング

```fish
rm -rf "$EXPORT"

mkdir -p \
    "$EXPORT/ge" \
    "$EXPORT/dxvk" \
    "$EXPORT/plugin" \
    "$EXPORT/config" \
    "$EXPORT/metadata"
```

パッチ済みGE-Proton全体をコピーする。

```fish
cp -a \
    "$GE_TEST" \
    "$EXPORT/ge/"
```

実際に使用しているDXVK DLLをコピーする。

```fish
for dll in \
    d3d11.dll \
    dxgi.dll \
    d3d10core.dll

    cp -a \
        "$SYSTEM32/$dll" \
        "$EXPORT/dxvk/$dll"
end
```

パッチ済みL-SMASH Worksと設定をコピーする。

```fish
cp -a \
    "$PLUGIN_DIR/lwinput.aui2" \
    "$EXPORT/plugin/lwinput.aui2"

cp -a \
    "$PLUGIN_DIR/lsmash.ini" \
    "$EXPORT/plugin/lsmash.ini"
```

DXVK設定をコピーする。

```fish
cp -a \
    "$ROOT/nvidia-dxvk.conf" \
    "$EXPORT/config/nvidia-dxvk.conf"
```

## 6.5 ビルド情報を保存

```fish
begin
    echo "Exported at: "(date --iso-8601=seconds)
    echo "Host: "(hostname)
    echo "Kernel: "(uname -r)
    echo
    echo "GE-Proton:"
    echo "$GE_TEST"
    echo
    echo "Wine:"
    env \
        LD_LIBRARY_PATH="$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix" \
        "$GE_TEST/files/lib/wine/x86_64-unix/wine" --version
    echo
    echo "NVIDIA:"
    nvidia-smi \
        --query-gpu=name,driver_version \
        --format=csv,noheader \
        2>/dev/null
end > "$EXPORT/metadata/BUILD-INFO.txt"
```

## 6.6 全ファイルのSHA-256を作成

```fish
cd "$EXPORT"

find . \
    -type f \
    ! -name SHA256SUMS \
    -print0 \
    | sort -z \
    | xargs -0 sha256sum \
    > SHA256SUMS
```

検証する。

```fish
sha256sum -c SHA256SUMS
```

すべて`OK`になる必要がある。

## 6.7 アーカイブを作成

```fish
set ARCHIVE \
    "$EXPORT_PARENT/aviutl2-known-good.tar.zst"

rm -f "$ARCHIVE"

tar \
    --zstd \
    -cf "$ARCHIVE" \
    -C "$EXPORT_PARENT" \
    aviutl2-known-good
```

アーカイブのSHA-256を保存する。

```fish
sha256sum "$ARCHIVE" \
    | tee "$ARCHIVE.sha256"
```

次の2ファイルを対象環境へ転送する。

```text
aviutl2-known-good.tar.zst
aviutl2-known-good.tar.zst.sha256
```

AviUtl2本体はこのアーカイブへ含めない。対象環境で公式ZIPから取得する。

---

# 7. 対象環境へ動作済みバイナリを導入

## 7.1 変数を設定

対象環境で実行する。

```fish
set ROOT \
    "$HOME/Games/aviutl2"

set PREFIX \
    "$ROOT/prefix-ge-nvdec-test"

set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set COMPAT_DIR \
    "$HOME/.local/share/Steam/compatibilitytools.d"

set ARCHIVE \
    "$HOME/Downloads/aviutl2-known-good.tar.zst"

set ARCHIVE_HASH \
    "$HOME/Downloads/aviutl2-known-good.tar.zst.sha256"

set IMPORT_PARENT \
    "$ROOT/import"

set IMPORT \
    "$IMPORT_PARENT/aviutl2-known-good"

mkdir -p \
    "$ROOT/downloads" \
    "$ROOT/logs" \
    "$ROOT/scripts" \
    "$IMPORT_PARENT" \
    "$COMPAT_DIR"
```

## 7.2 転送したアーカイブを検証

SHA-256ファイル内のパスが元環境の絶対パスになっている場合は、次のようにアーカイブ本体を直接比較する。

```fish
cat "$ARCHIVE_HASH"
sha256sum "$ARCHIVE"
```

両方のSHA-256が一致しなければ展開しない。

## 7.3 アーカイブを展開

```fish
rm -rf "$IMPORT"

tar \
    --zstd \
    -xf "$ARCHIVE" \
    -C "$IMPORT_PARENT"
```

内部ファイルを検証する。

```fish
cd "$IMPORT"
sha256sum -c SHA256SUMS
```

すべて`OK`になる必要がある。

---

# 8. パッチ済みGE-Protonを導入

```fish
set IMPORT_GE \
    "$IMPORT/ge/GE-Proton11-1-aviutl2-test"

set TS \
    (date +%Y%m%d-%H%M%S)
```

既存の同名環境がある場合は退避する。

```fish
if test -e "$GE_TEST"
    mv \
        "$GE_TEST" \
        "$GE_TEST.backup-$TS"
end
```

コピーする。

```fish
cp -a \
    "$IMPORT_GE" \
    "$GE_TEST"
```

必須ファイルを確認する。

```fish
for path in \
    "$GE_TEST/files/lib/wine/x86_64-unix/wine" \
    "$GE_TEST/files/bin/wineserver" \
    "$GE_TEST/files/lib/wine/x86_64-windows/dwrite.dll"

    if test -e "$path"
        echo "OK: $path"
    else
        echo "MISSING: $path"
    end
end
```

Wineを確認する。

```fish
set GE_WINE \
    "$GE_TEST/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_TEST/files/bin/wineserver"

set GE_LIBS \
    "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"

env \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" --version
```

期待値:

```text
wine-staging 11.0
```

`$GE_TEST/files/bin/wine`は使用しない。

---

# 9. 新しいWine prefixを作成

既存prefixがある場合は削除せず退避する。

```fish
set TS \
    (date +%Y%m%d-%H%M%S)

if test -d "$PREFIX"
    env \
        WINEPREFIX="$PREFIX" \
        "$GE_WINESERVER" -k \
        2>/dev/null

    sleep 1

    mv \
        "$PREFIX" \
        "$PREFIX.backup-$TS"
end
```

新規prefixを作成する。

```fish
mkdir -p "$PREFIX"

env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" wineboot -u
```

prefixを確認する。

```fish
for path in \
    "$PREFIX/drive_c" \
    "$PREFIX/drive_c/windows/system32" \
    "$PREFIX/user.reg" \
    "$PREFIX/system.reg"

    if test -e "$path"
        echo "OK: $path"
    else
        echo "MISSING: $path"
    end
end
```

---

# 10. AviUtl2 2.1.2を公式ZIPから配置

## 10.1 ZIPを取得

```fish
set AVIUTL2_URL \
    "https://spring-fragrance.mints.ne.jp/aviutl/aviutl2_v2.1.2.zip"

set AVIUTL2_ZIP \
    "$ROOT/downloads/aviutl2_v2.1.2.zip"

curl \
    --fail \
    --location \
    "$AVIUTL2_URL" \
    --output "$AVIUTL2_ZIP"
```

ZIPを検査する。

```fish
file "$AVIUTL2_ZIP"
bsdtar -tf "$AVIUTL2_ZIP" | head -n 30
```

## 10.2 ZIPを展開

```fish
set AVIUTL2_TEMP \
    "$ROOT/build/aviutl2-v2.1.2"

rm -rf "$AVIUTL2_TEMP"
mkdir -p "$AVIUTL2_TEMP"

bsdtar \
    -xf "$AVIUTL2_ZIP" \
    -C "$AVIUTL2_TEMP"
```

`aviutl2.exe`を探索する。

```fish
set AVIUTL2_SOURCE_EXE \
    (find "$AVIUTL2_TEMP" \
        -type f \
        -iname aviutl2.exe \
        -print \
        -quit)

echo "$AVIUTL2_SOURCE_EXE"
```

何も表示されなければ先へ進まない。

## 10.3 `C:\AviUtl2`へ配置

```fish
set AVIUTL2_SOURCE_DIR \
    (dirname "$AVIUTL2_SOURCE_EXE")

set AVIUTL2_DIR \
    "$PREFIX/drive_c/AviUtl2"

rm -rf "$AVIUTL2_DIR"
mkdir -p "$AVIUTL2_DIR"

cp -a \
    "$AVIUTL2_SOURCE_DIR/." \
    "$AVIUTL2_DIR/"
```

非ポータブル構成にする。

```fish
rm -rf "$AVIUTL2_DIR/data"
```

確認する。

```fish
file "$AVIUTL2_DIR/aviutl2.exe"
```

`setup.exe`は実行しない。

---

# 11. 動作済みDXVKをprefixへ導入

## 11.1 DXVK設定

```fish
cp -a \
    "$IMPORT/config/nvidia-dxvk.conf" \
    "$ROOT/nvidia-dxvk.conf"
```

内容を確認する。

```fish
cat "$ROOT/nvidia-dxvk.conf"
```

最低限、次が必要である。

```ini
dxgi.hideNvidiaGpu = False
```

## 11.2 DLLをコピー

```fish
set SYSTEM32 \
    "$PREFIX/drive_c/windows/system32"

set TS \
    (date +%Y%m%d-%H%M%S)

for dll in \
    d3d11.dll \
    dxgi.dll \
    d3d10core.dll

    if test -f "$SYSTEM32/$dll"
        cp -a \
            "$SYSTEM32/$dll" \
            "$SYSTEM32/$dll.before-aviutl2-$TS"
    end

    cp -a \
        "$IMPORT/dxvk/$dll" \
        "$SYSTEM32/$dll"
end
```

コピー元とコピー先のハッシュを比較する。

```fish
for dll in \
    d3d11.dll \
    dxgi.dll \
    d3d10core.dll

    echo
    echo "=== $dll ==="

    sha256sum \
        "$IMPORT/dxvk/$dll" \
        "$SYSTEM32/$dll"
end
```

各DLLについて、2つのSHA-256が一致する必要がある。

パッチ文字列を確認する。

```fish
strings "$SYSTEM32/d3d11.dll" \
    | grep -E \
        'AviUtl2 compatibility|AviUtl2 trace'
```

元環境で確認されたDLLでは、次のいずれかが含まれる。

```text
AviUtl2 compatibility
AviUtl2 trace: CheckFormatSupport
```

---

# 12. 動作済みL-SMASH Worksを導入

```fish
set PLUGIN_DIR \
    "$PREFIX/drive_c/ProgramData/aviutl2/Plugin"

mkdir -p "$PLUGIN_DIR"
```

プラグインをコピーする。

```fish
cp -a \
    "$IMPORT/plugin/lwinput.aui2" \
    "$PLUGIN_DIR/lwinput.aui2"

cp -a \
    "$IMPORT/plugin/lsmash.ini" \
    "$PLUGIN_DIR/lsmash.ini"
```

ハッシュを比較する。

```fish
sha256sum \
    "$IMPORT/plugin/lwinput.aui2" \
    "$PLUGIN_DIR/lwinput.aui2"

sha256sum \
    "$IMPORT/plugin/lsmash.ini" \
    "$PLUGIN_DIR/lsmash.ini"
```

設定を確認する。

```fish
grep -E \
    'libavsmash_disabled|libav_disabled|preferred_decoders' \
    "$PLUGIN_DIR/lsmash.ini"
```

必要な設定:

```ini
libavsmash_disabled=1
libav_disabled=0
preferred_decoders=av1_cuvid
```

プラグインに必要な文字列が含まれるか確認する。

```fish
strings -a "$PLUGIN_DIR/lwinput.aui2" \
    | grep -E \
        'av1_cuvid|av_hwframe_transfer_data|L-SMASH Works File Reader'
```

コンパイラ最適化やstripの状態によって、一部の文字列が表示されない可能性はある。

その場合でも、エクスポート元とコピー先のSHA-256が一致していれば、同一バイナリが導入されている。

---

# 13. 固定起動ラッパーを作成

## 13.1 ラッパー内容

次の内容を`~/Games/aviutl2/scripts/launch-aviutl2.fish`へ保存する。

```fish
#!/usr/bin/env fish

set ROOT \
    "$HOME/Games/aviutl2"

set PREFIX \
    "$ROOT/prefix-ge-nvdec-test"

set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set GE_WINE \
    "$GE_TEST/files/lib/wine/x86_64-unix/wine"

set GE_LIBS \
    "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"

set AVIUTL2_EXE \
    "$PREFIX/drive_c/AviUtl2/aviutl2.exe"

set DXVK_CONFIG \
    "$ROOT/nvidia-dxvk.conf"

set DLL_OVERRIDES \
    'nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

for required in \
    "$GE_WINE" \
    "$AVIUTL2_EXE" \
    "$DXVK_CONFIG"

    if not test -e "$required"
        echo "ERROR: required path does not exist: $required" >&2
    end
end

cd "$PREFIX/drive_c/AviUtl2"

env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES="$DLL_OVERRIDES" \
    DXVK_CONFIG_FILE="$DXVK_CONFIG" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG=-all \
    "$GE_WINE" \
    "$AVIUTL2_EXE"
```

Fishから安全に作成する場合は、エディタを使う。

```fish
nvim "$ROOT/scripts/launch-aviutl2.fish"
```

実行権限を付ける。

```fish
chmod +x \
    "$ROOT/scripts/launch-aviutl2.fish"
```

構文を検査する。

```fish
fish -n \
    "$ROOT/scripts/launch-aviutl2.fish"
```

何も表示されなければ構文エラーはない。

---

# 14. 最初の直接起動

Lutrisを使う前に、必ずターミナルから直接起動する。

```fish
"$ROOT/scripts/launch-aviutl2.fish" \
    2>&1 \
    | tee "$ROOT/logs/aviutl2-first-launch.log"
```

確認項目:

- AviUtl2のメインウィンドウが表示される
- 起動直後に終了しない
- format 69エラー画面が出ない
- 未処理ページフォルトが出ない
- `HitTestTextRange()`または`HitTestPoint()`エラーが出ない

ログを検査する。

```fish
grep -nEi \
    'format 69|CheckFormatSupport|Unhandled page fault|Unhandled exception|E_NOTIMPL|HitTestTextRange|HitTestPoint|80004001|80004005' \
    "$ROOT/logs/aviutl2-first-launch.log" \
    | tail -n 200
```

`Unhandled page fault`、`Unhandled exception`、`E_NOTIMPL`が出た場合は、Lutris設定へ進まない。

---

# 15. DLLロード経路を検証

通常起動で問題がある場合だけ、DLLロードログを取得する。

```fish
set LOAD_LOG \
    "$ROOT/logs/aviutl2-loaddll.log"

env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=info \
    WINEDEBUG='+loaddll' \
    "$GE_WINE" \
    "$PREFIX/drive_c/AviUtl2/aviutl2.exe" \
    &> "$LOAD_LOG"
```

確認する。

```fish
grep -nEi \
    'd3d11\.dll|dxgi\.dll|d3d10core\.dll|dwrite\.dll|aviutl2\.exe' \
    "$LOAD_LOG" \
    | tail -n 200
```

想定外のシステムWine、別prefix、別DXVKが読み込まれていないことを確認する。

---

# 16. 段階別の機能確認

一度にすべてを試さず、次の順番で検証する。

## Phase 1: 起動

確認項目:

- メインウィンドウが出る
- 数分間維持できる
- 正常終了できる
- format 69エラーがない
- ページフォルトがない

## Phase 2: テキスト

確認項目:

1. テキストオブジェクトを作成する
2. テキストを入力する
3. 文字列を選択する
4. 編集状態へ入る
5. カーソル位置を変更する

失敗時に確認する文字列:

```text
HitTestTextRange
HitTestPoint
HitTestTextPosition
E_NOTIMPL
0x80004001
0x80004005
```

## Phase 3: 動画

確認項目:

1. AV1動画を開く
2. 映像が表示される
3. 再生できる
4. 一時停止できる
5. シークできる
6. 何度か前後へシークしてもクラッシュしない

`lsmash.ini`で次を維持する。

```ini
libavsmash_disabled=1
libav_disabled=0
preferred_decoders=av1_cuvid
```

## Phase 4: Mozc

確認項目:

1. Fcitx5を有効にする
2. 日本語を入力する
3. 変換候補を表示する
4. 候補を選択する
5. 確定する
6. テキスト編集を継続する

IMEを無効化した状態だけで成功しても、最終成功とは扱わない。

---

# 17. Lutrisへ登録

AviUtl2の直接起動が成功した後だけ実施する。

## 17.1 Runner

Lutrisでは次を設定する。

| 項目 | 値 |
| --- | --- |
| Runner | Linux |
| Executable | `~/Games/aviutl2/scripts/launch-aviutl2.fish` |
| Working directory | `~/Games/aviutl2` |
| Arguments | なし |
| Wine prefix | 設定しない |
| Wine version | 設定しない |
| DXVK | Lutris側では有効化しない |
| VKD3D | Lutris側では有効化しない |
| UMU | 使用しない |

Lutrisは固定ラッパーを起動するだけにする。

## 17.2 設計上の禁止事項

次の構成へ変更してはならない。

```text
Lutris Wine Runner
└── Lutrisが選択したWine
    └── Lutrisが選択したDXVK
```

この構成では、元環境で確認したGE-Proton、prefix、DWrite、DXVKが使用される保証がなくなる。

---

# 18. AviUtl2 Catalog

CatalogはAviUtl2本体の起動確認後に導入する。

リポジトリの管理スクリプトを使う場合:

```fish
cd "$REPO"

chmod +x \
    scripts/manage-aviutl2-catalog-lutris.sh
```

状態確認:

```fish
scripts/manage-aviutl2-catalog-lutris.sh status
```

導入:

Git 履歴 `509123c` に、原環境の実行記録として次の Meson コマンドがある。これは原環境の evidence であり、Nanashi での成功を意味しない。
```fish
meson setup \
    "$DXVK_SRC/build.w64" \
    "$DXVK_SRC" \
    --cross-file "$DXVK_SRC/build-win64.txt" \
    --buildtype release \
    --prefix "$DXVK_OUT"
```
```fish
meson compile \
    -C "$DXVK_SRC/build.w64" \
    -j (nproc)
```
```fish
meson install \
    -C "$DXVK_SRC/build.w64"
```
## 4. Nanashiで未確認の事項

Nanashi の絶対 path、cross-file の由来、clean source 準備、patch 適用、build、DLL の同一出力由来、DLL load、format 69 実行、main window、text、Mozc、AV1、NVDEC、復元は未確認である。
[`STATUS.md`](STATUS.md) には別環境で patch 適用失敗と `Missing Vulkan-Headers` が記録されている。これらは Nanashi で解消済みと扱わず、失敗時は推測による変更をせず停止する。
## 5. Nanashiの実パス確認

次は読み取り専用の発見である。候補が複数なら選ばず、出力を記録して停止する。
```fish
git rev-parse --show-toplevel
```
```fish
find "$HOME/Games" -maxdepth 2 -type d -name aviutl2 -print
```
```fish
find "$HOME/Games/aviutl2" -maxdepth 2 -type d -name 'prefix-*' -print
```
```fish
find "$HOME/.local/share/Steam/compatibilitytools.d" -maxdepth 2 -type d -name 'GE-Proton*' -print
```
```fish
find "$HOME/.local/share/Steam/compatibilitytools.d" -type f -path '*/files/lib/wine/x86_64-unix/wine' -print
find "$HOME/.local/share/Steam/compatibilitytools.d" -type f -path '*/files/bin/wineserver' -print
```
```fish
find (git rev-parse --show-toplevel)/scripts -maxdepth 1 -type f -name '*launch*.fish' -print
```
確認した値を手で記入する。`DXVK_WORK_PARENT` は prefix 外の既存作業親である。
```text
NANASHI_ROOT:
NANASHI_PREFIX:
NANASHI_SYSTEM32:
NANASHI_GE:
NANASHI_WINE:
NANASHI_WINESERVER:
NANASHI_LAUNCH_WRAPPER:
DXVK_WORK_PARENT:
```
同じ対話 Fish session で記録値を入力する。異なる session では入力し直す。
```fish
set NANASHI_REPO (git rev-parse --show-toplevel)
read -P 'NANASHI_ROOT: ' NANASHI_ROOT
read -P 'NANASHI_PREFIX: ' NANASHI_PREFIX
read -P 'NANASHI_SYSTEM32: ' NANASHI_SYSTEM32
read -P 'NANASHI_GE: ' NANASHI_GE
read -P 'NANASHI_WINE: ' NANASHI_WINE
read -P 'NANASHI_WINESERVER: ' NANASHI_WINESERVER
read -P 'NANASHI_LAUNCH_WRAPPER: ' NANASHI_LAUNCH_WRAPPER
read -P 'DXVK_WORK_PARENT: ' DXVK_WORK_PARENT
realpath "$NANASHI_ROOT" "$NANASHI_PREFIX" "$NANASHI_SYSTEM32" "$NANASHI_GE" "$NANASHI_WINE" "$NANASHI_WINESERVER" "$NANASHI_LAUNCH_WRAPPER" "$DXVK_WORK_PARENT"
```

## 6. DXVK sourceの準備

この節は Nanashi で未実行であり、変更操作の個別承認後にだけ使う。既存 checkout を再利用・初期化・削除せず、新しい checkout を作る。成功条件は指定 commit、clean source tree、patch 検査成功である。一つでも満たさなければ build へ進まない。

```fish
set DXVK_SRC "$DXVK_WORK_PARENT/dxvk-2.7.1-c3dd74be"
git clone --recurse-submodules https://github.com/doitsujin/dxvk.git "$DXVK_SRC"
```

```fish
git -C "$DXVK_SRC" checkout --detach c3dd74be6baec53786d4e064a572185b70347a17
git -C "$DXVK_SRC" submodule update --init --recursive
git -C "$DXVK_SRC" rev-parse HEAD
git -C "$DXVK_SRC" status --short
```

```fish
set DXVK_PATCH "$NANASHI_REPO/patches/dxvk/0001-aviutl2-format-support.patch"
sha256sum "$DXVK_PATCH"
git -C "$DXVK_SRC" apply --check "$DXVK_PATCH"
git -C "$DXVK_SRC" apply "$DXVK_PATCH"
git -C "$DXVK_SRC" diff --check
git -C "$DXVK_SRC" diff -- src/d3d11/d3d11_device.cpp
```

patch 適用前の `status --short` は空、`rev-parse HEAD` は base commit と一致し、適用後の diff は本 patch だけでなければならない。

## 7. DXVKのビルド

第 3 節の Meson 三コマンドが Git 履歴 `509123c` で確認できる原環境 command である。Nanashi での実行と結果は未確認である。`$DXVK_SRC/build-win64.txt` の由来・作成方法は repository evidence で確定していない。ファイルがない、または `meson setup` が失敗する場合は、cross-file を推測で作成・変更せず停止する。

Nanashi で実行を承認された場合は、第 3 節の三 command を一つずつ実行し、各成功後にだけ次へ進む。

```fish
set DXVK_BUILD "$DXVK_SRC/build.w64"
set DXVK_OUT "$DXVK_WORK_PARENT/dxvk-2.7.1-output"
test -f "$DXVK_SRC/build-win64.txt"
meson --version
x86_64-w64-mingw32-gcc --version
```

```text
実行日時:
DXVK commit:
patch SHA-256:
Meson version:
MinGW compiler version:
build directory:
output directory:
build 結果:
```

## 8. 生成された3 DLLの確認

次は読み取り専用である。各 `count` が 1 であり、絶対 path が同じ `DXVK_OUT` の build output tree に属することを手で確認する。複数またはゼロなら選択せず停止する。

```fish
set D3D11_FOUND (find "$DXVK_OUT" -type f -name d3d11.dll -print)
set DXGI_FOUND (find "$DXVK_OUT" -type f -name dxgi.dll -print)
set D3D10CORE_FOUND (find "$DXVK_OUT" -type f -name d3d10core.dll -print)
count $D3D11_FOUND
count $DXGI_FOUND
count $D3D10CORE_FOUND
printf '%s\n' $D3D11_FOUND $DXGI_FOUND $D3D10CORE_FOUND
```

```fish
read -P 'd3d11.dll の確認済み出力: ' DXVK_D3D11
read -P 'dxgi.dll の確認済み出力: ' DXVK_DXGI
read -P 'd3d10core.dll の確認済み出力: ' DXVK_D3D10CORE
realpath "$DXVK_D3D11" "$DXVK_DXGI" "$DXVK_D3D10CORE"
sha256sum "$DXVK_D3D11" "$DXVK_DXGI" "$DXVK_D3D10CORE"
grep -aF 'AviUtl2 compatibility' "$DXVK_D3D11"
```

marker は patch を含む候補 DLL の証拠であり、DLL load や format 69 実行の証拠ではない。

| DLL | 確認済み絶対 path | SHA-256 |
| --- | --- | --- |
| d3d11.dll |  |  |
| dxgi.dll |  |  |
| d3d10core.dll |  |  |

## 9. WineとAviUtl2の停止

AviUtl2 を通常終了してから行う。確認済み GE-Proton の Wine と wineserver、および確認済み prefix だけを使う。system Wine、`pkill`、`killall`、広範囲のプロセス終了は使わない。対応する `wineserver -w` の成功が主な停止条件であり、失敗時は backup や置換へ進まない。

```fish
set GE_LIBS "$NANASHI_GE/files/lib64:$NANASHI_GE/files/lib:$NANASHI_GE/files/lib/wine/x86_64-unix:$NANASHI_GE/files/lib/wine/i386-unix"
env WINEPREFIX="$NANASHI_PREFIX" LD_LIBRARY_PATH="$GE_LIBS" "$NANASHI_WINESERVER" -k
```

```fish
env WINEPREFIX="$NANASHI_PREFIX" LD_LIBRARY_PATH="$GE_LIBS" "$NANASHI_WINESERVER" -w
```

## 10. 既存3 DLLのバックアップ

置換前に元の三 hash を表示する。一つの新しい時刻付き backup directory を prefix 外に作り、明示した三ファイルだけを copy する。各組の hash を手で照合し、三組すべて一致するまで置換は禁止である。

```fish
sha256sum "$NANASHI_SYSTEM32/d3d11.dll" "$NANASHI_SYSTEM32/dxgi.dll" "$NANASHI_SYSTEM32/d3d10core.dll"
set BACKUP_TIMESTAMP (date -u +%Y%m%dT%H%M%SZ)
set DLL_BACKUP "$DXVK_WORK_PARENT/dxvk-backup-$BACKUP_TIMESTAMP"
mkdir "$DLL_BACKUP"
```

```fish
cp "$NANASHI_SYSTEM32/d3d11.dll" "$DLL_BACKUP/d3d11.dll"
cp "$NANASHI_SYSTEM32/dxgi.dll" "$DLL_BACKUP/dxgi.dll"
cp "$NANASHI_SYSTEM32/d3d10core.dll" "$DLL_BACKUP/d3d10core.dll"
sha256sum "$DLL_BACKUP/d3d11.dll" "$DLL_BACKUP/dxgi.dll" "$DLL_BACKUP/d3d10core.dll"
```

```text
backup directory:
original d3d11 SHA-256:
backup d3d11 SHA-256:
original dxgi SHA-256:
backup dxgi SHA-256:
original d3d10core SHA-256:
backup d3d10core SHA-256:
一致確認:
```

## 11. 3 DLLの交換

三ファイルの交換は atomic ではない。端末と SSH 接続を安定させ、途中で中断しない。copy が一つでも失敗したら続行せず、起動もしない。自動 retry と自動 rollback はしない。手動交換には中断リスクが残る。

```fish
cp "$DXVK_D3D11" "$NANASHI_SYSTEM32/d3d11.dll"
cp "$DXVK_DXGI" "$NANASHI_SYSTEM32/dxgi.dll"
cp "$DXVK_D3D10CORE" "$NANASHI_SYSTEM32/d3d10core.dll"
```

```fish
sha256sum "$NANASHI_SYSTEM32/d3d11.dll" "$NANASHI_SYSTEM32/dxgi.dll" "$NANASHI_SYSTEM32/d3d10core.dll"
```

表示した三 hash を第 8 節の build hash と手で比較する。三つすべて一致するまで AviUtl2 を起動しない。

## 12. AviUtl2の起動と確認

prefix 外に run ごとの log directory を作る。既存の確認済み Nanashi wrapper をそのまま使い、新しい wrapper や Wine 設定を作らない。wrapper がこの directory へ DXVK log を出す既存設定を持つかは未確認であり、空なら log 出力先を推測して変更しない。

```fish
set RUN_TIMESTAMP (date -u +%Y%m%dT%H%M%SZ)
set RUN_LOG_DIR "$DXVK_WORK_PARENT/dxvk-format69-log-$RUN_TIMESTAMP"
mkdir "$RUN_LOG_DIR"
sha256sum "$NANASHI_SYSTEM32/d3d11.dll" "$NANASHI_SYSTEM32/dxgi.dll" "$NANASHI_SYSTEM32/d3d10core.dll"
printf '%s\n' "$RUN_TIMESTAMP" "$NANASHI_LAUNCH_WRAPPER" "$NANASHI_PREFIX" "$NANASHI_GE" "$RUN_LOG_DIR"
```

```fish
"$NANASHI_LAUNCH_WRAPPER"
```

終了後、実際に得られた log を指定して読む。marker だけから format 69 成功を判断しない。patch が `CheckFormatSupport format=69 hr=0 flags=0` を出力することは repository evidence では確認できないため、その trace がなければ format 69 runtime 証拠の方法は未解決として記録する。

```fish
read -P '確認対象の DXVK log: ' DXVK_LOG
grep -aF 'AviUtl2 compatibility' "$DXVK_LOG"
grep -aF 'CheckFormatSupport format=69 hr=0 flags=0' "$DXVK_LOG"
```

成功水準は独立に記録する。(1) 意図した DLL の設置、(2) 意図した DXVK の load、(3) format 69 workaround 実行、(4) main window 表示、(5) text 編集、(6) Mozc、(7) AV1 load/playback/seeking、(8) NVDEC。前の水準から後の水準を推論しない。

## 13. 問題発生時の手動復元

復元も中断してはならない。AviUtl2 を通常終了し、第 9 節と同じ wineserver を停止してから、現在の三 hash を記録する。確認済み backup の三ファイルだけを exact System32 名へ戻す。copy 後の三 hash が第 10 節の元 hash とすべて一致するまで起動しない。

```fish
sha256sum "$NANASHI_SYSTEM32/d3d11.dll" "$NANASHI_SYSTEM32/dxgi.dll" "$NANASHI_SYSTEM32/d3d10core.dll"
cp "$DLL_BACKUP/d3d11.dll" "$NANASHI_SYSTEM32/d3d11.dll"
cp "$DLL_BACKUP/dxgi.dll" "$NANASHI_SYSTEM32/dxgi.dll"
cp "$DLL_BACKUP/d3d10core.dll" "$NANASHI_SYSTEM32/d3d10core.dll"
sha256sum "$NANASHI_SYSTEM32/d3d11.dll" "$NANASHI_SYSTEM32/dxgi.dll" "$NANASHI_SYSTEM32/d3d10core.dll"
```

## 14. Nanashi実行結果

```markdown
実行日:
機械:
リポジトリ commit:
DXVK commit:
patch SHA-256:
実際に使った build コマンド:
build 結果:
生成 DLL の path と hash:
元 DLL の hash:
backup path と hash:
最終設置 hash:
wrapper path:
log path:
format-69 結果:
main-window 結果:
text 結果:
Mozc 結果:
AV1 結果:
NVDEC 結果:
rollback 実施と結果:
次の blocker:
```

## 15. この文書を確認済み状態へ更新する条件

Nanashi 固有の記載を「未確認」から「確認済み」へ変えられるのは、実行済み command、実測した path、実際に観測した output、記録済み hash、確認済み runtime behavior、実施済みまたは独立に検証済みの restoration による裏付けがある場合だけである。

失敗した推測、未使用の分岐、未実行の候補 command は確認済み手順へ入れない。Nanashi の実測値が得られたら、この同じ文書の該当節と第 14 節を更新する。
