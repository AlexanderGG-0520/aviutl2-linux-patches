# AviUtl2 on Linux — 新規インストール手順

最終更新: 2026-08-02

この文書は、CachyOS / Arch Linux上でAviUtl2 2.1.3を新しいWine prefixへ導入する手順である。
コマンドはFish 4.8.1を前提とする。

重要:

- `GE_PROTON_ROOT`は各利用者の`$HOME`配下にあるpatched GE-Proton runnerを指す。
- `/home/alex`など、別利用者の絶対pathを流用しない。
- `GE_WINE`、`GE_WINESERVER`、`GE_LIBS`は`GE_PROTON_ROOT`から毎回再計算する。
- Section 13は起動・UI・text編集・IMEの確認だけを扱う。NVDEC/NVENC検証はSection 14へ分離する。

検証基準:

| 項目 | 値 |
| --- | --- |
| shell | Fish 4.8.1 |
| GE-Proton | 11-1 patched runner |
| Wine | wine-staging 11.0 |
| DXVK | 2.7.1 |
| AviUtl2 | 2.1.3 |
| IME | Fcitx5 + Mozc |
| Catalog | 0.3.3 |
| GPU | NVIDIA |

## 1. 依存関係

```fish
sudo pacman -S --needed \
    fish \
    git \
    curl \
    tar \
    libarchive \
    python \
    python-fonttools \
    noto-fonts-cjk \
    file \
    binutils \
    coreutils \
    findutils \
    grep \
    sed \
    fcitx5 \
    fcitx5-mozc \
    nvidia-utils \
    lib32-nvidia-utils \
    vulkan-icd-loader \
    lib32-vulkan-icd-loader \
    vulkan-tools
```

source buildも行う場合:

```fish
sudo pacman -S --needed \
    base-devel \
    autoconf \
    automake \
    libtool \
    cmake \
    meson \
    ninja \
    nasm \
    pkgconf \
    mingw-w64-binutils \
    mingw-w64-crt \
    mingw-w64-gcc \
    mingw-w64-headers \
    mingw-w64-winpthreads
```

## 2. repositoryと環境変数

repository:

```fish
set REPO \
    "$HOME/projects/aviutl2-linux-patches"

if not test -d "$REPO/.git"
    mkdir -p "$HOME/projects"

    git clone \
        https://github.com/AlexanderGG-0520/aviutl2-linux-patches.git \
        "$REPO"
end

cd "$REPO"
git pull --ff-only
```

patched runner候補を確認する:

```fish
find \
    "$HOME/.local/share/Steam/compatibilitytools.d" \
    -mindepth 1 \
    -maxdepth 1 \
    -type d \
    -name 'GE-Proton11-1*' \
    -print
```

Nanashi環境のpatched runnerは次である:

```text
$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test
```

現在のFish sessionに古い`/home/alex`由来の変数が残らないよう、標準pathを一括で再設定する:

```fish
function set_aviutl2_install_env --argument-names ge_proton_root
    set -g ROOT \
        "$HOME/Games/aviutl2"

    set -g REPO \
        "$HOME/projects/aviutl2-linux-patches"

    set -g PREFIX \
        "$ROOT/prefix"

    set -g ARTIFACT_ROOT \
        "$ROOT/artifacts"

    set -g AVIUTL2_SOURCE_DIR \
        "$ARTIFACT_ROOT/AviUtl2-2.1.3"

    set -g DXVK_ARTIFACT_DIR \
        "$ARTIFACT_ROOT/dxvk-2.7.1-aviutl2/x64"

    set -g FONT_SOURCE_DIR \
        "$ARTIFACT_ROOT/fonts"

    set -g NVIDIA_WRAPPER_DIR \
        "$ARTIFACT_ROOT/nvidia-libs-v1.0.2/x64"

    set -g LSMASH_WORK \
        "$ROOT/build/l-smash-works-nvdec-repro-03"

    set -g LSMASH_ARTIFACT_DIR \
        "$LSMASH_WORK/output"

    set -g GE_PROTON_ROOT \
        (string replace -r '/+$' '' -- "$ge_proton_root")

    set -g GE_WINE \
        "$GE_PROTON_ROOT/files/bin/wine"

    if not test -x "$GE_WINE"
        set -g GE_WINE \
            "$GE_PROTON_ROOT/files/lib/wine/x86_64-unix/wine"
    end

    set -g GE_WINESERVER \
        "$GE_PROTON_ROOT/files/bin/wineserver"

    set -g GE_LIBS \
        "$GE_PROTON_ROOT/files/lib64:$GE_PROTON_ROOT/files/lib:$GE_PROTON_ROOT/files/lib/wine/x86_64-unix:$GE_PROTON_ROOT/files/lib/wine/i386-unix"

    set -g DXVK_CONFIG_FILE \
        "$ROOT/nvidia-dxvk.conf"

    set -g DLL_OVERRIDES \
        'nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

    for path in \
        "$GE_PROTON_ROOT" \
        "$GE_WINE" \
        "$GE_WINESERVER"

        if not test -e "$path"
            echo "ERROR: missing runner path: $path" >&2
            return 1
        end
    end
end

set_aviutl2_install_env \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"
```

確認:

```fish
printf '%s\n' \
    "HOME=$HOME" \
    "ROOT=$ROOT" \
    "PREFIX=$PREFIX" \
    "GE_PROTON_ROOT=$GE_PROTON_ROOT" \
    "GE_WINE=$GE_WINE" \
    "GE_WINESERVER=$GE_WINESERVER"
```

Nanashi環境で`/home/alex`が1件でも表示された場合は、そのまま進めず、このSection 2を同じFish sessionで再実行する。

## 3. GE-Proton 11-1

stock GE-Proton 11-1の取得:

```fish
set GE_DOWNLOAD_DIR \
    "$ROOT/downloads/ge-proton11-1"

set GE_BASE \
    "$HOME/.local/share/Steam/compatibilitytools.d"

mkdir -p \
    "$GE_DOWNLOAD_DIR" \
    "$GE_BASE"

curl \
    --fail \
    --location \
    --retry 3 \
    --output "$GE_DOWNLOAD_DIR/GE-Proton11-1.tar.gz" \
    "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton11-1/GE-Proton11-1.tar.gz"

and curl \
    --fail \
    --location \
    --retry 3 \
    --output "$GE_DOWNLOAD_DIR/GE-Proton11-1.sha512sum" \
    "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton11-1/GE-Proton11-1.sha512sum"
```

```fish
pushd "$GE_DOWNLOAD_DIR"
sha512sum -c GE-Proton11-1.sha512sum
set GE_VERIFY_STATUS $status
popd

test $GE_VERIFY_STATUS -eq 0
```

```fish
if not test -d "$GE_BASE/GE-Proton11-1"
    tar \
        -xzf "$GE_DOWNLOAD_DIR/GE-Proton11-1.tar.gz" \
        -C "$GE_BASE"
end
```

AviUtl2のtext編集にはpatched Wine DWriteが必要である。
patched runnerの作成経路は`docs/REPRODUCTION.md`のWine / DWrite節を使用し、完成先を`GE_PROTON_ROOT`へ設定する。

## 4. AviUtl2 2.1.3を取得する

```fish
function prepare_aviutl2_213
    set -l download_dir "$ROOT/downloads"
    set -l archive "$download_dir/aviutl2_v2.1.3.zip"
    set -l extract_dir "$ROOT/build/aviutl2-v2.1.3-extract"

    mkdir -p \
        "$download_dir" \
        "$ROOT/build" \
        "$ARTIFACT_ROOT"
    or return 1

    curl \
        --fail \
        --location \
        --retry 3 \
        --output "$archive" \
        "https://spring-fragrance.mints.ne.jp/aviutl/aviutl2_v2.1.3.zip"
    or return 1

    rm -rf \
        "$extract_dir" \
        "$AVIUTL2_SOURCE_DIR"

    mkdir -p \
        "$extract_dir" \
        "$AVIUTL2_SOURCE_DIR"
    or return 1

    bsdtar \
        -xf "$archive" \
        -C "$extract_dir"
    or return 1

    set -l aviutl2_exe \
        (find "$extract_dir" -type f -iname 'aviutl2.exe' -print -quit)

    test -n "$aviutl2_exe"
    or begin
        echo "ERROR: aviutl2.exe was not found" >&2
        return 1
    end

    cp -a \
        (dirname "$aviutl2_exe")/. \
        "$AVIUTL2_SOURCE_DIR/"
    or return 1

    file "$AVIUTL2_SOURCE_DIR/aviutl2.exe"
    sha256sum "$archive"
end

prepare_aviutl2_213
```

## 5. patched DXVK 2.7.1をbuildする

```fish
set DXVK_WORK \
    "$ROOT/build/dxvk-2.7.1-aviutl2-source"

mkdir -p \
    (dirname "$DXVK_WORK") \
    (dirname "$DXVK_ARTIFACT_DIR")

bash \
    "$REPO/scripts/build-dxvk-aviutl2.sh" \
    --work-dir "$DXVK_WORK" \
    --output-dir "$DXVK_ARTIFACT_DIR"
```

work/output directoryは新規pathでなければならない。

```fish
pushd "$DXVK_ARTIFACT_DIR"
sha256sum -c SHA256SUMS
file d3d11.dll dxgi.dll d3d10core.dll
popd
```

## 6. 日本語fontを生成する

```fish
python3 \
    "$REPO/scripts/prepare-aviutl2-fonts.py" \
    --output-dir "$FONT_SOURCE_DIR"
```

```fish
pushd "$FONT_SOURCE_DIR"
sha256sum -c SHA256SUMS

file \
    NotoSansCJK-Regular.ttc \
    NotoSansCJK-Bold.ttc \
    Tahoma-Noto-Regular.otf \
    Tahoma-Noto-Bold.otf

popd
```

## 7. NVIDIA Wine wrapperを取得する

```fish
fish \
    "$REPO/scripts/prepare-nvidia-libs.fish" \
    --output-dir "$NVIDIA_WRAPPER_DIR"
```

```fish
pushd "$NVIDIA_WRAPPER_DIR"
sha256sum -c SHA256SUMS.expected
file nvcuda.dll nvcuvid.dll nvencodeapi64.dll
popd
```

## 8. custom L-SMASH Works r1284をbuildする

```fish
fish \
    "$REPO/scripts/build-l-smash-works-nvdec.fish" \
    --work-dir "$LSMASH_WORK" \
    --jobs (nproc)
```

```fish
pushd "$LSMASH_ARTIFACT_DIR"
sha256sum -c SHA256SUMS
popd
```

## 9. DXVK設定fileを作成する

```fish
printf '%s\n' \
    'dxgi.hideNvidiaGpu = False' \
    > "$DXVK_CONFIG_FILE"

cat "$DXVK_CONFIG_FILE"
```

期待値:

```text
dxgi.hideNvidiaGpu = False
```

## 10. artifact preflight

session内の`GE_WINE`を直接検査せず、patched runner rootを明示指定する:

```fish
fish \
    "$REPO/scripts/preflight-aviutl2-installation.fish" \
    --root "$ROOT" \
    --ge-proton-root "$GE_PROTON_ROOT" \
    --aviutl2-source-dir "$AVIUTL2_SOURCE_DIR" \
    --lsmash-artifact-dir "$LSMASH_ARTIFACT_DIR"
```

出力の先頭で次を確認する:

```text
HOME=/home/nanashi
root=/home/nanashi/Games/aviutl2
ge_proton_root=/home/nanashi/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test
```

## 11. 新規prefixとAviUtl2本体を配置する

```fish
fish \
    "$REPO/scripts/bootstrap-aviutl2-prefix.fish" \
    --prefix "$PREFIX" \
    --ge-proton-root "$GE_PROTON_ROOT"
```

```fish
mkdir -p \
    "$PREFIX/drive_c/AviUtl2" \
    "$PREFIX/drive_c/ProgramData/aviutl2/Plugin"

cp -a \
    "$AVIUTL2_SOURCE_DIR/." \
    "$PREFIX/drive_c/AviUtl2/"
```

## 12. DXVK、font、NVIDIA wrapper、L-SMASH Worksを配置する

Wineを停止する。既に停止している場合のnonzero終了は無視する:

```fish
env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINESERVER" \
    -k \
    2>/dev/null

or true
```

DXVK:

```fish
for dll in d3d11 dxgi d3d10core
    install \
        -m 0644 \
        "$DXVK_ARTIFACT_DIR/$dll.dll" \
        "$PREFIX/drive_c/windows/system32/$dll.dll"
end
```

font:

```fish
set DEST_FONTS \
    "$PREFIX/drive_c/windows/Fonts"

mkdir -p "$DEST_FONTS"

for font_file in \
    NotoSansCJK-Regular.ttc \
    NotoSansCJK-Bold.ttc \
    Tahoma-Noto-Regular.otf \
    Tahoma-Noto-Bold.otf

    install \
        -m 0644 \
        "$FONT_SOURCE_DIR/$font_file" \
        "$DEST_FONTS/$font_file"
end
```

NVIDIA wrapper:

```fish
for dll in nvcuda nvcuvid nvencodeapi64
    rm -f \
        "$PREFIX/drive_c/windows/system32/$dll.dll"

    ln -s \
        "$NVIDIA_WRAPPER_DIR/$dll.dll" \
        "$PREFIX/drive_c/windows/system32/$dll.dll"
end
```

L-SMASH Works:

```fish
set PLUGIN_DIR \
    "$PREFIX/drive_c/ProgramData/aviutl2/Plugin"

install \
    -m 0644 \
    "$LSMASH_ARTIFACT_DIR/lwinput.aui2" \
    "$PLUGIN_DIR/lwinput.aui2"

install \
    -m 0644 \
    "$LSMASH_ARTIFACT_DIR/lsmash.ini" \
    "$PLUGIN_DIR/lsmash.ini"
```

設定確認:

```fish
grep -nE \
    '^(libavsmash_disabled|libav_disabled|preferred_decoders)=' \
    "$PLUGIN_DIR/lsmash.ini"
```

## 13. registry、IME、起動

font registry、font substitute、DLL override、AviUtl2専用`InputStyle=overthespot`を設定する:

```fish
fish \
    "$REPO/scripts/configure-aviutl2-prefix.fish" \
    --prefix "$PREFIX" \
    --ge-proton-root "$GE_PROTON_ROOT"
```

通常起動:

```fish
fish \
    "$REPO/scripts/launch-aviutl2.fish" \
    --prefix "$PREFIX" \
    --ge-proton-root "$GE_PROTON_ROOT" \
    --dxvk-config "$DXVK_CONFIG_FILE"
```

このSectionの成功条件:

```text
AviUtl2メインウィンドウが表示される
日本語UIを読める
format 69 error dialogが出ない
L-SMASH Works r1284が認識される
text objectを追加できる
text選択・caret移動・再編集ができる
Mozcで日本語入力・変換・Enter確定できる
```

NVDEC、NVENC、特定codecの成功条件はこのSectionへ含めない。

## 14. GPU別のmedia検証とCatalog

Nanashi環境はGeForce RTX 2070 SUPERである。

```text
HEVC Main10:
  NVDEC/NVENC検証対象

AV1:
  hardware decode/encodeの合格条件にしない
  input再生時はdav1d software decodeを想定する
  active av1_cuvid contextを要求しない
```

RTX 4060 TiなどAV1対応GPUでは、AV1 NVDEC/NVENCを別途検証できる。

NVEnc output plugin導入後は、推測ではなく次の実測結果でcodecを選ぶ:

```text
NVEncC64.exe --check-features
```

RTX 2070 SUPERではHEVC Main10を選び、AviUtl2内部生成objectで5〜10秒のtimelineを作成して出力する。
外部入力動画は不要である。

Catalog 0.3.3では次を設定する:

```text
AviUtl2 root: C:\AviUtl2
Portable mode: disabled
```

Catalog導入後はcustom r1284を最後にoverlayし、`Mr-Ojii.L-SMASH-Works`を更新停止する。

## 15. 関連文書

```text
docs/REPRODUCTION.md
  patched Wine DWrite、runtime log、成功環境の詳細

docs/L-SMASH-WORKS-NVDEC.md
  custom r1284とmedia decodeの詳細

docs/TROUBLESHOOTING.md
  既知障害と切り分け

docs/AVIUTL2-COMMAND-LEDGER-BUNDLE/
  実行済みcommandの監査資料
```
