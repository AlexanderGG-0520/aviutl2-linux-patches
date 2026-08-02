# AviUtl2 on Linux — 新規インストール手順

最終更新: 2026-08-02

この文書は、AviUtl2 2.1.3をCachyOS / Arch Linux上の新しいWine prefixへ導入するための手順である。
既存prefixや日時付きbackupからの復旧は`REPRODUCTION.md`へ分離する。

検証基準:

| 項目 | 値 |
| --- | --- |
| shell | fish 4.8.1 |
| GE-Proton | 11-1 |
| Wine | wine-staging 11.0 |
| DXVK | 2.7.1 |
| AviUtl2 | 2.1.2 |
| IME | Fcitx5 + Mozc |
| Catalog | 0.3.3 |
| GPU | NVIDIA |

未検証のversionへ読み替えず、最初はこの組み合わせで導入する。

## 1. 依存関係

実行・取得・検証用:

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
    github-cli \
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

DXVK、Wine DWrite、L-SMASH Worksをsource buildする場合:

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

LutrisへLinux Runnerとして登録する場合:

```fish
sudo pacman -S --needed \
    lutris
```

## 2. repositoryと標準path

```fish
set ROOT \
    "$HOME/Games/aviutl2"

set REPO \
    "$HOME/projects/aviutl2-linux-patches"

set PREFIX \
    "$ROOT/prefix"

set ARTIFACT_ROOT \
    "$ROOT/artifacts"

set AVIUTL2_SOURCE_DIR \
    "$ARTIFACT_ROOT/AviUtl2-2.1.2"

set DXVK_ARTIFACT_DIR \
    "$ARTIFACT_ROOT/dxvk-2.7.1-aviutl2/x64"

set FONT_SOURCE_DIR \
    "$ARTIFACT_ROOT/fonts"

set NVIDIA_WRAPPER_DIR \
    "$ARTIFACT_ROOT/nvidia-libs-v1.0.2/x64"

set LSMASH_ARTIFACT_DIR \
    "$ROOT/build/l-smash-works-nvdec-repro-03/output"

set GE_PROTON_ROOT \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set GE_WINE \
    "$GE_PROTON_ROOT/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_PROTON_ROOT/files/bin/wineserver"

set GE_LIBS \
    "$GE_PROTON_ROOT/files/lib64:$GE_PROTON_ROOT/files/lib:$GE_PROTON_ROOT/files/lib/wine/x86_64-unix:$GE_PROTON_ROOT/files/lib/wine/i386-unix"

set DXVK_CONFIG_FILE \
    "$ROOT/nvidia-dxvk.conf"

set DLL_OVERRIDES \
    'nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'
```

repositoryを取得する。

```fish
mkdir -p \
    "$HOME/projects" \
    "$ROOT" \
    "$ARTIFACT_ROOT"

if not test -d "$REPO/.git"
    git clone \
        https://github.com/AlexanderGG-0520/aviutl2-linux-patches.git \
        "$REPO"
end

cd "$REPO"
git status --short --branch
```

## 3. GE-Proton 11-1を取得する

`latest`ではなく固定releaseを使用する。

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

stock runnerからpatched runnerを完成させるWine DWrite buildは`REPRODUCTION.md`のWine / DWrite節を使用する。
`GE_PROTON_ROOT`は完成したpatched runnerのpathへ固定する。

## 4. AviUtl2 2.1.2を取得する

AviUtl2本体はrepositoryへ再配布せず、公式ZIPを直接取得する。

```fish
function prepare_aviutl2_213
    set -l download_dir "$ROOT/downloads"
    set -l archive "$download_dir/aviutl2_v2.1.3.zip"
    set -l extract_dir "$ROOT/build/aviutl2-v2.1.3-extract"

    mkdir -p "$download_dir" "$ROOT/build" "$ARTIFACT_ROOT"
    or return 1

    curl \
        --fail \
        --location \
        --retry 3 \
        --output "$archive" \
        "https://spring-fragrance.mints.ne.jp/aviutl/aviutl2_v2.1.3.zip"
    or return 1

    rm -rf "$extract_dir" "$AVIUTL2_SOURCE_DIR"
    mkdir -p "$extract_dir" "$AVIUTL2_SOURCE_DIR"
    or return 1

    bsdtar -xf "$archive" -C "$extract_dir"
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

実在するbuild scriptを使用する。

```text
scripts/build-dxvk-aviutl2.sh
```

このscriptはDXVKをcommit `c3dd74be6baec53786d4e064a572185b70347a17`へ固定し、
`patches/dxvk/0001-aviutl2-format-support.patch`を適用して次を生成する。

```text
d3d11.dll
dxgi.dll
d3d10core.dll
SHA256SUMS
BUILD-METADATA
```

`d3dcompiler_47.dll`はDXVK artifactではない。GE-Proton / Wineがprefixへ配置するものを使用する。

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

work/output pathは新規でなければならない。既存pathがある場合は別名を指定する。

```fish
pushd "$DXVK_ARTIFACT_DIR"
sha256sum -c SHA256SUMS
file d3d11.dll dxgi.dll d3d10core.dll
popd
```

## 6. 日本語fontを取得・生成する

`noto-fonts-cjk`のTTCから、Wine DirectWriteがTahomaとして解決できるlocal compatibility OTFを生成する。

```fish
python3 \
    "$REPO/scripts/prepare-aviutl2-fonts.py" \
    --output-dir "$FONT_SOURCE_DIR"
```

生成物:

```text
NotoSansCJK-Regular.ttc
NotoSansCJK-Bold.ttc
Tahoma-Noto-Regular.otf
Tahoma-Noto-Bold.otf
SHA256SUMS
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

生成した`Tahoma-Noto-*.otf`はlocal compatibility用途であり、MicrosoftのTahoma本体ではない。
repositoryへcommitしない。

## 7. NVIDIA Wine wrapperを取得する

SveSop/nvidia-libs `v1.0.2`の通常archiveをGitHub Releases APIから取得する。

```fish
fish \
    "$REPO/scripts/prepare-nvidia-libs.fish" \
    --output-dir "$NVIDIA_WRAPPER_DIR"
```

生成物:

```text
nvcuda.dll
nvcuvid.dll
nvencodeapi64.dll
SHA256SUMS
SHA256SUMS.expected
```

```fish
pushd "$NVIDIA_WRAPPER_DIR"
sha256sum -c SHA256SUMS.expected
file nvcuda.dll nvcuvid.dll nvencodeapi64.dll
popd
```

## 8. custom L-SMASH Works r1284を完全buildする

```fish
set LSMASH_WORK \
    "$ROOT/build/l-smash-works-nvdec-repro-03"

fish \
    "$REPO/scripts/build-l-smash-works-nvdec.fish" \
    --work-dir "$LSMASH_WORK" \
    --jobs (nproc)
```

成功時:

```text
$LSMASH_ARTIFACT_DIR/lwinput.aui2
$LSMASH_ARTIFACT_DIR/lsmash.ini
$LSMASH_ARTIFACT_DIR/PROVENANCE.txt
$LSMASH_ARTIFACT_DIR/SHA256SUMS
```

```fish
pushd "$LSMASH_ARTIFACT_DIR"
sha256sum -c SHA256SUMS
popd
```

## 9. artifact preflight

固定名の`av1-main10-test.mp4`は要求しない。
NVDEC検証時は、利用者が正当に用意した任意のAV1 Main 10-bit素材をGUIから選択する。
NVENC出力検証はAviUtl2の内部生成objectで行えるため、外部動画fileは不要である。

```fish
function require_path
    set path "$argv[1]"

    if not test -e "$path"
        echo "ERROR: missing path: $path" >&2
        return 1
    end

    echo "OK: $path"
end

function preflight_installation_artifacts
    for path in \
        "$GE_WINE" \
        "$GE_WINESERVER" \
        "$GE_PROTON_ROOT/files/lib/wine/x86_64-windows/dwrite.dll" \
        "$AVIUTL2_SOURCE_DIR/aviutl2.exe" \
        "$DXVK_ARTIFACT_DIR/d3d11.dll" \
        "$DXVK_ARTIFACT_DIR/dxgi.dll" \
        "$DXVK_ARTIFACT_DIR/d3d10core.dll" \
        "$FONT_SOURCE_DIR/NotoSansCJK-Regular.ttc" \
        "$FONT_SOURCE_DIR/NotoSansCJK-Bold.ttc" \
        "$FONT_SOURCE_DIR/Tahoma-Noto-Regular.otf" \
        "$FONT_SOURCE_DIR/Tahoma-Noto-Bold.otf" \
        "$NVIDIA_WRAPPER_DIR/nvcuda.dll" \
        "$NVIDIA_WRAPPER_DIR/nvcuvid.dll" \
        "$NVIDIA_WRAPPER_DIR/nvencodeapi64.dll" \
        "$LSMASH_ARTIFACT_DIR/lwinput.aui2" \
        "$LSMASH_ARTIFACT_DIR/lsmash.ini" \
        "$DXVK_CONFIG_FILE"

        require_path "$path"
        or return 1
    end
end

preflight_installation_artifacts
```

## 10. 新規prefixとAviUtl2配置

空prefixのbootstrapはrunner・host差異の影響を受けるため、Nanashi環境ではIssueへ実行commandと結果を記録する。
作成済みprefixに最低限次が存在することを確認する。

```fish
for path in \
    "$PREFIX/user.reg" \
    "$PREFIX/system.reg" \
    "$PREFIX/userdef.reg" \
    "$PREFIX/drive_c/windows/system32"

    require_path "$path"
    or return 1
end
```

AviUtl2本体とProgramDataを配置する。

```fish
mkdir -p \
    "$PREFIX/drive_c/AviUtl2" \
    "$PREFIX/drive_c/ProgramData/aviutl2/Plugin"

cp -a \
    "$AVIUTL2_SOURCE_DIR/." \
    "$PREFIX/drive_c/AviUtl2/"
```

## 11. DXVK・font・NVIDIA wrapperをprefixへ導入する

Wineを停止する。

```fish
env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINESERVER" -k 2>/dev/null

or true
```

DXVK:

```fish
for dll in d3d11 dxgi d3d10core
    install -m 0644 \
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

    install -m 0644 \
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

## 12. L-SMASH Worksを配置する

```fish
set PLUGIN_DIR \
    "$PREFIX/drive_c/ProgramData/aviutl2/Plugin"

install -m 0644 \
    "$LSMASH_ARTIFACT_DIR/lwinput.aui2" \
    "$PLUGIN_DIR/lwinput.aui2"

install -m 0644 \
    "$LSMASH_ARTIFACT_DIR/lsmash.ini" \
    "$PLUGIN_DIR/lsmash.ini"
```

`lsmash.ini`の必須値:

```ini
libavsmash_disabled=1
libav_disabled=0
preferred_decoders=av1_cuvid
```

Catalog導入後は、`scripts/install-l-smash-works-nvdec.fish`を使用してcustom r1284を最後にoverlayし、
`Mr-Ojii.L-SMASH-Works`を更新停止する。

## 13. registry、IME、起動

必要なfont registry、DLL override、`InputStyle=overthespot`の詳細は`REPRODUCTION.md`の確認済みcommandを使用する。
起動時の固定値:

```fish
cd "$PREFIX/drive_c/AviUtl2"

env \
    XMODIFIERS='@im=fcitx' \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES="$DLL_OVERRIDES" \
    DXVK_CONFIG_FILE="$DXVK_CONFIG_FILE" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG=-all \
    "$GE_WINE" \
    ./aviutl2.exe
```

成功条件:

```text
AviUtl2メインウィンドウが表示される
日本語UIを読める
format 69 error dialogが出ない
text選択・caret移動・再編集ができる
Mozcで日本語入力・変換・Enter確定できる
AV1 Main 10-bit素材を読み込み、再生・seekできる
複数のactive av1_cuvid contextがある
nvcuvid/CUDA/hardware-frame-transfer failureがない
```

## 14. CatalogとNVENC分岐

Catalog 0.3.3を同じprefixへ導入し、次を設定する。

```text
AviUtl2 root: C:\AviUtl2
Portable mode: disabled
```

NVEnc output plugin導入後、`NVEncC64.exe --check-features`を実行して分岐する。

```text
AV1 Encode supported:
  AV1 NVENC / 10-bit

AV1 unsupported, HEVC supported:
  HEVC NVENC
  Main10 supportedなら10-bit
  Main10 unsupportedなら8-bit
```

固定の入力動画は不要である。AviUtl2内部生成objectで5〜10秒のtimelineを作り、選択codecで出力する。
GPU型番だけで判断せず、`--check-features`の実測結果を保存する。

Catalog導入後はcustom r1284を最後にoverlayし、Catalog再起動前後で`lwinput.aui2`のSHA-256が変わらないことを確認する。

## 15. 関連文書

```text
docs/REPRODUCTION.md
  source build、registry、runtime log、成功環境の詳細

docs/L-SMASH-WORKS-NVDEC.md
  custom r1284とNVDECの詳細

docs/TROUBLESHOOTING.md
  既知障害と切り分け

docs/AVIUTL2-COMMAND-LEDGER-BUNDLE/
  実行済みcommandの監査資料
```
