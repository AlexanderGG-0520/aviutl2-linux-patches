# AviUtl2 on Linux — 新規インストール手順

最終更新: 2026-08-02

この文書は、CachyOS / Arch Linux上でAviUtl2 2.1.3を新しいWine prefixへ導入する手順である。
コマンドはFish 4.8.1を前提とする。

重要:

- stock `GE-Proton11-1`はpatched runnerを作るための複製元にしか使用しない。AviUtl2のprefix作成、preflight、診断起動、通常起動へ渡してはならない。
- runtimeで使用するrunnerはSection 3.2が生成する`GE-Proton11-1-aviutl2`だけである。
- `GE_PROTON_ROOT`は必ず`$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2`へ設定する。runner候補の自動選択や手入力は行わない。
- Section 3.2でbuildした`dwrite.dll`とrunner内の`dwrite.dll`が`cmp`で一致しない場合は、prefix作成、preflight、Section 13へ進まない。
- Fishを再起動した場合でも、Section 13の直前にpatched runnerのpathと`dwrite.dll`を再検証する。
- `GE_WINE`、`GE_WINESERVER`、`GE_DWRITE`、`GE_LIBS`は、固定した`GE_PROTON_ROOT`から毎回再計算する。
- Section 13は診断起動、UI、text編集、IMEの確認を扱う。Section 13が完了するまでSection 14へ進まない。
- NVDEC/NVENC検証はSection 14へ分離する。

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
    flex \
    bison \
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

## 2. repositoryと基本path

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
    "$ARTIFACT_ROOT/AviUtl2-2.1.3"

set DXVK_ARTIFACT_DIR \
    "$ARTIFACT_ROOT/dxvk-2.7.1-aviutl2/x64"

set FONT_SOURCE_DIR \
    "$ARTIFACT_ROOT/fonts"

set NVIDIA_WRAPPER_DIR \
    "$ARTIFACT_ROOT/nvidia-libs-v1.0.2/x64"

set LSMASH_WORK \
    "$ROOT/build/l-smash-works-nvdec-repro-03"

set LSMASH_ARTIFACT_DIR \
    "$LSMASH_WORK/output"

set DXVK_CONFIG_FILE \
    "$ROOT/nvidia-dxvk.conf"

set DLL_OVERRIDES \
    'nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'
```

repositoryを取得・更新する:

```fish
if not test -d "$REPO/.git"
    mkdir -p "$HOME/projects"

    git clone \
        https://github.com/AlexanderGG-0520/aviutl2-linux-patches.git \
        "$REPO"
end

cd "$REPO"
git pull --ff-only
```

## 3. GE-Proton 11-1とpatched runnerを作成・固定する

### 3.1 stock GE-Proton 11-1を取得する

stock runnerはSection 3.2でpatched runnerを作るための複製元である。これを`GE_PROTON_ROOT`へ設定してAviUtl2を起動してはならない。

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

### 3.2 patched `dwrite.dll`をbuildしてrunnerへ導入する

AviUtl2のtext選択、caret移動、再編集には、Wine DWriteの`HitTestPoint()`、`HitTestTextPosition()`、`HitTestTextRange()`を実装・補強したDLLが必要である。
ここでは、実機で成功したValveSoftware Wineの固定commit、二つのrepository patch、`--enable-archs=x86_64`を使用する。

`make dlls/dwrite`はdirectory名と衝突して何もbuildしない場合がある。
`make -B`はWine全体のconfigureを強制し、DWriteと無関係な依存関係で失敗するため使用しない。

```fish
set WINE_COMMIT \
    "31af7f983b2e345d11340b120ae3a39d88c9338a"

set WINE_DOWNLOAD_DIR \
    "$ROOT/downloads/wine-ge11-1-dwrite"

set WINE_ARCHIVE \
    "$WINE_DOWNLOAD_DIR/wine-$WINE_COMMIT.tar.gz"

set WINE_SRC \
    "$ROOT/src/wine-ge11-1-dwrite"

set WINE_BUILD \
    "$ROOT/build/wine-ge11-1-dwrite"

set WINE_CONFIGURE_LOG \
    "$ROOT/logs/wine-dwrite-configure.log"

set DWRITE_PATCH_1 \
    "$REPO/patches/wine/0001-implement-dwrite-hit-testing.patch"

set DWRITE_PATCH_2 \
    "$REPO/patches/wine/0002-harden-dwrite-hittestpoint.patch"

set GE_STOCK \
    "$GE_BASE/GE-Proton11-1"

set GE_PATCHED \
    "$GE_BASE/GE-Proton11-1-aviutl2"
```

source取得、patch適用、configure、DWrite build、runner作成を一つのfunctionで実行する:

```fish
function build_patched_dwrite_runner
    for path in \
        "$GE_STOCK" \
        "$DWRITE_PATCH_1" \
        "$DWRITE_PATCH_2" \
        "$REPO/scripts/install-dwrite.fish"

        if not test -e "$path"
            echo "ERROR: missing required path: $path" >&2
            return 1
        end
    end

    mkdir -p \
        "$WINE_DOWNLOAD_DIR" \
        (dirname "$WINE_SRC") \
        (dirname "$WINE_BUILD") \
        "$ROOT/logs"
    or return 1

    if not test -f "$WINE_ARCHIVE"
        curl \
            --fail \
            --location \
            --retry 3 \
            --output "$WINE_ARCHIVE" \
            "https://github.com/ValveSoftware/wine/archive/$WINE_COMMIT.tar.gz"
        or return 1
    end

    rm -rf \
        "$WINE_SRC" \
        "$WINE_BUILD"

    mkdir -p \
        "$WINE_SRC" \
        "$WINE_BUILD"
    or return 1

    tar \
        --extract \
        --file "$WINE_ARCHIVE" \
        --directory "$WINE_SRC" \
        --strip-components=1
    or return 1

    grep -nF \
        'stable release Wine 11.0' \
        "$WINE_SRC/ANNOUNCE.md"
    or begin
        echo "ERROR: the extracted source is not the expected Wine 11.0 tree" >&2
        return 1
    end

    patch \
        --directory="$WINE_SRC" \
        --strip=1 \
        --dry-run \
        < "$DWRITE_PATCH_1"
    or return 1

    patch \
        --directory="$WINE_SRC" \
        --strip=1 \
        < "$DWRITE_PATCH_1"
    or return 1

    patch \
        --directory="$WINE_SRC" \
        --strip=1 \
        --dry-run \
        < "$DWRITE_PATCH_2"
    or return 1

    patch \
        --directory="$WINE_SRC" \
        --strip=1 \
        < "$DWRITE_PATCH_2"
    or return 1

    if test -e "$WINE_SRC/dlls/dwrite/layout.c.rej"
        echo "ERROR: DWrite patch reject exists" >&2
        return 1
    end

    grep -nF \
        'layout_get_erun_for_position' \
        "$WINE_SRC/dlls/dwrite/layout.c"
    or begin
        echo "ERROR: HitTestTextPosition implementation marker was not found" >&2
        return 1
    end

    grep -nF \
        'No effective run for text position' \
        "$WINE_SRC/dlls/dwrite/layout.c"
    or begin
        echo "ERROR: patched HitTestTextPosition body was not found" >&2
        return 1
    end

    pushd "$WINE_SRC"
    or return 1

    ./autogen.sh
    set AUTOGEN_STATUS $status

    popd

    test $AUTOGEN_STATUS -eq 0
    or return 1

    pushd "$WINE_BUILD"
    or return 1

    "$WINE_SRC/configure" \
        --enable-archs=x86_64 \
        2>&1 \
        | tee "$WINE_CONFIGURE_LOG"

    set CONFIGURE_STATUS $pipestatus[1]

    popd

    test $CONFIGURE_STATUS -eq 0
    or begin
        echo "ERROR: Wine configure failed; see $WINE_CONFIGURE_LOG" >&2
        return 1
    end

    rm -f \
        "$WINE_BUILD/dlls/dwrite/x86_64-windows/layout.o" \
        "$WINE_BUILD/dlls/dwrite/x86_64-windows/dwrite.dll"

    make \
        -C "$WINE_BUILD" \
        -j(nproc) \
        dlls/dwrite/x86_64-windows/dwrite.dll
    or return 1

    set BUILT_DWRITE \
        "$WINE_BUILD/dlls/dwrite/x86_64-windows/dwrite.dll"

    test -f "$BUILT_DWRITE"
    or begin
        echo "ERROR: patched dwrite.dll was not generated" >&2
        return 1
    end

    file "$BUILT_DWRITE"
    or return 1

    if test -e "$GE_PATCHED"
        set STAMP \
            (date +%Y%m%d-%H%M%S)

        mv \
            "$GE_PATCHED" \
            "$GE_PATCHED.before-dwrite-$STAMP"
        or return 1
    end

    cp -a \
        --reflink=auto \
        "$GE_STOCK" \
        "$GE_PATCHED"
    or return 1

    fish \
        "$REPO/scripts/install-dwrite.fish" \
        "$WINE_BUILD" \
        "$GE_PATCHED"
    or return 1

    set INSTALLED_DWRITE \
        "$GE_PATCHED/files/lib/wine/x86_64-windows/dwrite.dll"

    cmp \
        --silent \
        "$BUILT_DWRITE" \
        "$INSTALLED_DWRITE"
    or begin
        echo "ERROR: built and installed dwrite.dll differ" >&2
        return 1
    end

    for path in \
        "$GE_PATCHED/files/bin/wineserver" \
        "$INSTALLED_DWRITE"

        test -e "$path"
        or begin
            echo "ERROR: patched runner is incomplete: $path" >&2
            return 1
        end
    end

    sha256sum \
        "$BUILT_DWRITE" \
        "$INSTALLED_DWRITE"

    echo "PATCHED_RUNNER=$GE_PATCHED"
end

build_patched_dwrite_runner
```

`build_patched_dwrite_runner`がstatus 0で終了し、二つのSHA-256が一致した場合だけ次へ進む。
この工程が置換するのはrunner内のPE DLLである`files/lib/wine/x86_64-windows/dwrite.dll`だけであり、`dwrite.so`を別buildのものへ置換してはならない。

### 3.3 patched runnerをruntime用として固定・検証する

runner候補の列挙や手入力は行わない。Section 3.2で生成した`$GE_PATCHED`を、そのまま唯一のruntime runnerとして固定する。

```fish
set GE_PROTON_ROOT \
    "$GE_PATCHED"

set EXPECTED_GE_PROTON_ROOT \
    "$GE_BASE/GE-Proton11-1-aviutl2"

set GE_WINE \
    "$GE_PROTON_ROOT/files/bin/wine"

if not test -x "$GE_WINE"
    set GE_WINE \
        "$GE_PROTON_ROOT/files/lib/wine/x86_64-unix/wine"
end

set GE_WINESERVER \
    "$GE_PROTON_ROOT/files/bin/wineserver"

set GE_DWRITE \
    "$GE_PROTON_ROOT/files/lib/wine/x86_64-windows/dwrite.dll"

set BUILT_DWRITE \
    "$WINE_BUILD/dlls/dwrite/x86_64-windows/dwrite.dll"

set GE_LIBS \
    "$GE_PROTON_ROOT/files/lib64:$GE_PROTON_ROOT/files/lib:$GE_PROTON_ROOT/files/lib/wine/x86_64-unix:$GE_PROTON_ROOT/files/lib/wine/i386-unix"
```

pathとDLLの同一性を検証する:

```fish
function validate_patched_ge_runner
    if test "$GE_PROTON_ROOT" != "$EXPECTED_GE_PROTON_ROOT"
        echo "ERROR: GE_PROTON_ROOT is not the patched runner" >&2
        echo "EXPECTED: $EXPECTED_GE_PROTON_ROOT" >&2
        echo "ACTUAL:   $GE_PROTON_ROOT" >&2
        return 1
    end

    if test "$GE_PROTON_ROOT" = "$GE_BASE/GE-Proton11-1"
        echo "ERROR: stock GE-Proton11-1 must never be used at runtime" >&2
        return 1
    end

    for path in \
        "$GE_PROTON_ROOT" \
        "$GE_WINE" \
        "$GE_WINESERVER" \
        "$GE_DWRITE" \
        "$BUILT_DWRITE"

        if not test -e "$path"
            echo "ERROR: patched runner prerequisite is missing: $path" >&2
            return 1
        end
    end

    if not test -x "$GE_WINE"
        echo "ERROR: Wine is not executable: $GE_WINE" >&2
        return 1
    end

    if not test -x "$GE_WINESERVER"
        echo "ERROR: wineserver is not executable: $GE_WINESERVER" >&2
        return 1
    end

    cmp \
        --silent \
        "$BUILT_DWRITE" \
        "$GE_DWRITE"
    or begin
        echo "ERROR: runtime runner does not contain the built patched dwrite.dll" >&2
        return 1
    end

    printf '%s\n' \
        "GE_PROTON_ROOT=$GE_PROTON_ROOT" \
        "GE_WINE=$GE_WINE" \
        "GE_WINESERVER=$GE_WINESERVER" \
        "GE_DWRITE=$GE_DWRITE" \
        "BUILT_DWRITE=$BUILT_DWRITE"

    sha256sum \
        "$BUILT_DWRITE" \
        "$GE_DWRITE"
end

validate_patched_ge_runner
```

この検証がstatus 0で終了し、二つのSHA-256が一致するまでSection 4以降へ進まない。
出力中の`GE_PROTON_ROOT`が`.../GE-Proton11-1`で終わっている場合は失敗である。必ず`.../GE-Proton11-1-aviutl2`で終わらなければならない。

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

Section 3で固定・検証したpatched runner rootだけを明示指定する:

```fish
fish \
    "$REPO/scripts/preflight-aviutl2-installation.fish" \
    --root "$ROOT" \
    --ge-proton-root "$GE_PROTON_ROOT" \
    --aviutl2-source-dir "$AVIUTL2_SOURCE_DIR" \
    --lsmash-artifact-dir "$LSMASH_ARTIFACT_DIR"
```

preflightの出力に表示された`ge_proton_root`が`$GE_BASE/GE-Proton11-1-aviutl2`と一致し、`wine`、`wineserver`、`dwrite.dll`が同じrunner配下にあることを確認する。
`ge_proton_root`がstock版`.../GE-Proton11-1`を指している場合や、`missing path`が1件でも出た場合はprefix作成へ進まない。

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

## 13. registry、IME、診断起動、通常起動

Fishを再起動した場合やSection 13だけを実行した場合でも、古い`GE_PROTON_ROOT`を引き継がないよう、runtime runnerをここで再定義する。
この再定義を省略してはならない。

```fish
set GE_BASE \
    "$HOME/.local/share/Steam/compatibilitytools.d"

set GE_PROTON_ROOT \
    "$GE_BASE/GE-Proton11-1-aviutl2"

set WINE_BUILD \
    "$ROOT/build/wine-ge11-1-dwrite"

set BUILT_DWRITE \
    "$WINE_BUILD/dlls/dwrite/x86_64-windows/dwrite.dll"

set GE_DWRITE \
    "$GE_PROTON_ROOT/files/lib/wine/x86_64-windows/dwrite.dll"
```

stock runnerの誤指定と、build済みDLLとの差異を診断起動前に拒否する:

```fish
if test "$GE_PROTON_ROOT" = "$GE_BASE/GE-Proton11-1"
    echo "ERROR: stock GE-Proton11-1 must never be used for AviUtl2" >&2
    return 1
end

if not test "$GE_PROTON_ROOT" = "$GE_BASE/GE-Proton11-1-aviutl2"
    echo "ERROR: unexpected GE_PROTON_ROOT: $GE_PROTON_ROOT" >&2
    return 1
end

for path in \
    "$BUILT_DWRITE" \
    "$GE_DWRITE" \
    "$REPO/scripts/diagnose-aviutl2-launch.fish"

    test -e "$path"
    or begin
        echo "ERROR: missing Section 13 prerequisite: $path" >&2
        return 1
    end
end

cmp \
    --silent \
    "$BUILT_DWRITE" \
    "$GE_DWRITE"
or begin
    echo "ERROR: selected runtime runner does not contain the built patched dwrite.dll" >&2
    sha256sum \
        "$BUILT_DWRITE" \
        "$GE_DWRITE"
    return 1
end

printf '%s\n' \
    "GE_PROTON_ROOT=$GE_PROTON_ROOT" \
    "BUILT_DWRITE=$BUILT_DWRITE" \
    "GE_DWRITE=$GE_DWRITE"

sha256sum \
    "$BUILT_DWRITE" \
    "$GE_DWRITE"
```

出力の`GE_PROTON_ROOT`が必ず次と一致し、二つのSHA-256が一致していることを確認する:

```text
/home/<user>/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2
```

次のようにstock版を指している場合は、診断起動せずSection 3.2へ戻る:

```text
/home/<user>/.local/share/Steam/compatibilitytools.d/GE-Proton11-1
```

診断scriptのsyntaxを確認する:

```fish
fish -n \
    "$REPO/scripts/diagnose-aviutl2-launch.fish"
```

何も表示されなければ診断起動する:

```fish
fish \
    "$REPO/scripts/diagnose-aviutl2-launch.fish" \
    --root "$ROOT" \
    --prefix "$PREFIX" \
    --ge-proton-root "$GE_PROTON_ROOT" \
    --dxvk-config "$DXVK_CONFIG_FILE"
```

このscriptは、引数の`GE_PROTON_ROOT`から次を内部で再計算する。

```text
GE_WINE
GE_WINESERVER
GE_DWRITE
GE_LIBS
```

scriptは次を実行する。

```text
runner、prefix、DXVK DLL、AviUtl2本体の存在確認
使用runnerとdwrite.dll SHA-256のログ保存
registry、font substitute、DLL override、InputStyleの設定
既存Wine processの停止
絶対Unix pathによるaviutl2.exe起動
WINEDEBUG=+timestamp,+pid,+tid,+loaddll,+seh
ログ保存
Wine本体の終了status取得
ログサイズ、metadata、末尾、EXE load記録、重要エラーの表示
DWrite hit-test stubとfatal markerの自動判定
```

診断起動中にGUIで次を確認し、確認後にAviUtl2を閉じる:

```text
AviUtl2メインウィンドウが表示される
日本語UIを読める
format 69 error dialogが出ない
L-SMASH Works r1284が認識される
text objectを追加できる
text選択・caret移動・再編集ができる
Mozcで日本語入力・変換・Enter確定できる
```

次のいずれかに該当した場合、Section 13は失敗である:

```text
GE_PROTON_ROOTがGE-Proton11-1-aviutl2ではない
build済みdwrite.dllとrunner内dwrite.dllが一致しない
configure_exit_statusが0以外
aviutl2_exit_statusが0以外
ログが0 byte
aviutl2.exeのload記録がない
Application could not be started
ShellExecuteEx failed
File not found
c0000135
Unhandled exception
unhandled page fault
fixme:dwrite:dwritetextlayout_HitTestPoint ... stub
fixme:dwrite:dwritetextlayout_HitTestTextPosition ... stub
fixme:dwrite:dwritetextlayout_HitTestTextRange ... stub
EXCEPTION_WINE_CXX_EXCEPTION
ウィンドウが出ず即終了する
UI、text編集、Mozc確認のいずれかに失敗する
```

Section 13が失敗した場合はSection 14へ進まない。
診断ログ先頭の`GE_PROTON_ROOT`、`GE_DWRITE`、`GE_DWRITE_SHA256`と、`aviutl2_exit_status`、`aviutl2_log_size`、`aviutl2_log_path`、ログ末尾、重要エラーを保存して原因を切り分ける。

診断起動とGUI確認の両方に成功した後だけ、通常launcherを使用する:

```fish
fish \
    "$REPO/scripts/launch-aviutl2.fish" \
    --prefix "$PREFIX" \
    --ge-proton-root "$GE_PROTON_ROOT" \
    --dxvk-config "$DXVK_CONFIG_FILE"
```

通常launcherにも同じ`$GE_PROTON_ROOT`を渡す。stock版runnerへ差し替えてはならない。

## 14. GPU別のmedia検証とCatalog

Section 13の診断起動、GUI、text編集、Mozc確認がすべて成功した場合だけ、このSectionへ進む。

GPU型番だけで対応codecを決めず、driverとpluginの実測結果で判断する。

NVEnc output plugin導入後:

```text
NVEncC64.exe --check-features
```

AV1非対応GPUでは、AV1 hardware decode/encodeやactive `av1_cuvid` contextを合格条件にしない。
HEVC Main10対応環境ではHEVC NVDEC/NVENCを検証対象にできる。
AV1対応GPUではAV1 NVDEC/NVENCを別途検証できる。

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
