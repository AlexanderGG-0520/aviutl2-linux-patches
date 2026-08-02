# AviUtl2 on Linux — 新規インストール手順

最終更新: 2026-08-02

この文書は、CachyOS / Arch Linux上でAviUtl2 2.1.3を新しいWine prefixへ導入する手順である。
コマンドはFish 4.8.1を前提とする。

重要:

- runnerの有効性をdirectory名で判定しない。`GE-Proton11-1`という名前でも、必要なpatched `dwrite.dll`が導入されていれば使用できる。
- 新規構築では、元runnerを保持するため`GE-Proton11-1-aviutl2`という別名copyを作る手順を推奨する。ただし、この名前自体は動作条件ではない。
- runtimeで使用するrunnerは、Section 3.2でbuildした`dwrite.dll`とrunner内の`dwrite.dll`が`cmp`でbyte単位に一致するものだけである。
- directory名、更新日時、backup fileの有無、runner候補の並び順だけではpatched runnerと判定しない。
- Fishを再起動した場合でも、Section 13の直前に使用するrunner pathと`dwrite.dll`の一致を再検証する。
- `GE_WINE`、`GE_WINESERVER`、`GE_DWRITE`、`GE_LIBS`は、選択した`GE_PROTON_ROOT`から毎回再計算する。
- Section 13は診断起動、UI、text編集、IMEの確認を扱う。Section 13が完了するまでSection 14へ進まない。
- NVDEC/NVENC検証はSection 14へ分離する。

検証基準:

| 項目 | 値 |
| --- | --- |
| shell | Fish 4.8.1 |
| GE-Proton | 11-1 + verified patched `dwrite.dll` |
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

## 3. GE-Proton 11-1とpatched DWriteを作成・検証する

### 3.1 GE-Proton 11-1を取得する

ここで取得するrunnerは、まだrepositoryのDWrite patchを含まない複製元である。
このdirectoryへpatched `dwrite.dll`を直接導入する方式と、Section 3.2のように別名copyへ導入する方式のどちらでもよい。
最終的な有効性はdirectory名ではなく、build成果物との`cmp`で判定する。

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

新規構築では、元runnerを保持するため`$GE_PATCHED`へcopyして導入する。
既存環境で`GE-Proton11-1`へpatched DLLを直接導入済みの場合でも、Section 3.3の内容検証に合格すればruntime runnerとして使用できる。

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

### 3.3 runtimeで使用するrunnerを内容で検証する

新規構築では、直前に作成したrunnerを初期値にする:

```fish
set GE_PROTON_ROOT \
    "$GE_PATCHED"
```

既存環境で別のrunnerへpatched `dwrite.dll`を直接導入済みの場合は、実際に使用するpathへ変更する。
例えば、Alex環境のように`GE-Proton11-1`自体へ導入したrunnerも指定できる:

```fish
set GE_PROTON_ROOT \
    "$GE_BASE/GE-Proton11-1"
```

runner内の実pathを、選択した`GE_PROTON_ROOT`から計算する:

```fish
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
    "$GE_PROTON_ROOT/files/lib/x86_64-linux-gnu:$GE_PROTON_ROOT/files/lib/i386-linux-gnu"
```

pathの存在とDLLの同一性を検証する:

```fish
function validate_patched_ge_runner
    for path in \
        "$GE_PROTON_ROOT" \
        "$GE_WINE" \
        "$GE_WINESERVER" \
        "$GE_DWRITE" \
        "$BUILT_DWRITE"

        if not test -e "$path"
            echo "ERROR: runner prerequisite is missing: $path" >&2
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
        echo "ERROR: selected runner does not contain the built patched dwrite.dll" >&2
        sha256sum \
            "$BUILT_DWRITE" \
            "$GE_DWRITE"
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
`GE_PROTON_ROOT`のbasenameが`GE-Proton11-1`か`GE-Proton11-1-aviutl2`かは合否に関係しない。

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

Section 3で内容を検証したrunner rootを明示指定する:

```fish
fish \
    "$REPO/scripts/preflight-aviutl2-installation.fish" \
    --root "$ROOT" \
    --ge-proton-root "$GE_PROTON_ROOT" \
    --aviutl2-source-dir "$AVIUTL2_SOURCE_DIR" \
    --lsmash-artifact-dir "$LSMASH_ARTIFACT_DIR"
```

preflightの出力に表示された`ge_proton_root`、`wine`、`wineserver`、`dwrite.dll`が、Section 3.3で検証した同じrunner配下にあることを確認する。
runnerのdirectory名は合否条件にしない。
`missing path`が1件でも出た場合や、使用runnerを変更した場合は、Section 3.3の`cmp`を再実行してからprefix作成へ進む。

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

Section 13では、clean buildしたpatched `dwrite.dll`を導入したGE-Proton runnerを使用して、AviUtl2を診断起動する。

Nanashi環境では、次のrunnerへpatched `dwrite.dll`を直接導入した状態で、AviUtl2がクラッシュせず起動した。

```text
$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1
```

runnerのdirectory名は動作条件ではない。実在するrunnerを指定し、clean build成果物とrunner内の`dwrite.dll`がbyte単位で一致することを確認する。

Fishを再起動した場合やSection 13だけを実行する場合は、必要な変数を再設定する。

```fish
set ROOT \
    "$HOME/Games/aviutl2"

set REPO \
    "$HOME/projects/aviutl2-linux-patches"

set PREFIX \
    "$ROOT/prefix"

set DXVK_CONFIG_FILE \
    "$ROOT/nvidia-dxvk.conf"

set DWRITE_CLEAN_WORK \
    "$ROOT/build/dwrite-clean"

set WINE_BUILD \
    "$DWRITE_CLEAN_WORK/build"

set BUILT_DWRITE \
    "$WINE_BUILD/dlls/dwrite/x86_64-windows/dwrite.dll"

set GE_PROTON_ROOT \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

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

set STOCK_DWRITE_SHA256 \
    "6d92b541c36f2157be264e5803497ab8f17777c1f575e6704fe3450d00f00e32"
```

別名runnerへpatched DLLを導入した場合は、`GE_PROTON_ROOT`だけを実在するrunner pathへ変更する。
runner名だけでpatched runnerかどうかを判定してはならない。

### 13.1 使用するrunnerを検証する

```fish
function validate_section13_runner
    for path in \
        "$GE_PROTON_ROOT" \
        "$BUILT_DWRITE" \
        "$GE_DWRITE" \
        "$REPO/scripts/diagnose-aviutl2-launch.fish"

        if not test -e "$path"
            echo "ERROR: missing Section 13 prerequisite: $path" >&2
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
        echo "ERROR: built and installed dwrite.dll differ" >&2

        sha256sum \
            "$BUILT_DWRITE" \
            "$GE_DWRITE"

        return 1
    end

    set GE_DWRITE_SHA256 \
        (sha256sum "$GE_DWRITE" | string split ' ')[1]

    if test "$GE_DWRITE_SHA256" = "$STOCK_DWRITE_SHA256"
        echo "ERROR: stock DWrite is still installed" >&2
        return 1
    end

    printf '%s\n' \
        "GE_PROTON_ROOT=$GE_PROTON_ROOT" \
        "GE_WINE=$GE_WINE" \
        "GE_WINESERVER=$GE_WINESERVER" \
        "BUILT_DWRITE=$BUILT_DWRITE" \
        "GE_DWRITE=$GE_DWRITE" \
        "GE_DWRITE_SHA256=$GE_DWRITE_SHA256"

    sha256sum \
        "$BUILT_DWRITE" \
        "$GE_DWRITE"
end

validate_section13_runner
set SECTION13_RUNNER_STATUS \
    $status

test $SECTION13_RUNNER_STATUS -eq 0
```

`SECTION13_RUNNER_STATUS`が0以外の場合は、診断起動へ進まない。

合格条件は次のとおり。

```text
runner directoryが実在する
Wineが実行可能
wineserverが実行可能
clean build成果物が存在する
runner内のPE版dwrite.dllが存在する
build成果物とrunner内dwrite.dllがcmpで一致する
runner内dwrite.dllが既知のstock SHA-256ではない
```

置換対象は次のPE DLLである。

```text
files/lib/wine/x86_64-windows/dwrite.dll
```

次のUnix側libraryを置換してはならない。

```text
files/lib/wine/x86_64-unix/dwrite.so
```

### 13.2 診断scriptのsyntaxを確認する

```fish
fish -n \
    "$REPO/scripts/diagnose-aviutl2-launch.fish"
```

何も表示されず、終了statusが0であれば診断起動へ進む。

### 13.3 AviUtl2を診断起動する

```fish
fish \
    "$REPO/scripts/diagnose-aviutl2-launch.fish" \
    --root "$ROOT" \
    --prefix "$PREFIX" \
    --ge-proton-root "$GE_PROTON_ROOT" \
    --dxvk-config "$DXVK_CONFIG_FILE"
```

このscriptは、渡された`GE_PROTON_ROOT`から次のpathを内部で再計算する。

```text
GE_WINE
GE_WINESERVER
GE_DWRITE
GE_LIBS
```

診断scriptは次を実行する。

```text
runner、prefix、DXVK DLL、AviUtl2本体の存在確認
使用runnerとdwrite.dll SHA-256のログ保存
prefixのregistry設定
font substituteの設定
DLL overrideの設定
InputStyleの設定
既存Wine processの停止
絶対Unix pathによるaviutl2.exe起動
WINEDEBUGログの保存
Wine終了statusの取得
ログsizeとlog pathの表示
AviUtl2 EXE load記録の確認
DWrite hit-test stubの検出
fatal markerの検出
```

Nanashi環境では、この診断起動によってAviUtl2がクラッシュせず起動した。

以前のstock DWrite環境では、次の経路でAviUtl2が終了していた。

```text
stock dwrite.dll
↓
dwritetextlayout_HitTestTextPosition ... stub
↓
EXCEPTION_WINE_CXX_EXCEPTION
↓
AviUtl2終了
```

patched DWrite導入後にAviUtl2のウィンドウが表示され、即座に終了しなければ、このDWrite stub crash経路は突破できている。

### 13.4 診断ログを確認する

最新ログを取得する。

```fish
set LATEST_LOG \
    (find "$ROOT/logs" \
        -maxdepth 1 \
        -type f \
        -name 'aviutl2-section13-*.log' \
        -printf '%T@ %p\n' \
        | sort -nr \
        | head -n 1 \
        | cut -d' ' -f2-)

echo \
    "LATEST_LOG=$LATEST_LOG"
```

重要なfailure markerを確認する。

```fish
grep -nEi \
    'dwrite:.*stub|EXCEPTION_WINE_CXX_EXCEPTION|Unhandled exception|unhandled page fault|c0000135|Application could not be started|ShellExecuteEx failed|File not found|failed to load|could not load' \
    "$LATEST_LOG" \
    | tail -n 200
```

次のDWrite stubまたは例外が出ている場合は失敗である。

```text
fixme:dwrite:dwritetextlayout_HitTestPoint ... stub
fixme:dwrite:dwritetextlayout_HitTestTextPosition ... stub
fixme:dwrite:dwritetextlayout_HitTestTextRange ... stub
EXCEPTION_WINE_CXX_EXCEPTION
Unhandled exception
unhandled page fault
```

AviUtl2のウィンドウが表示され、操作中にクラッシュせず、上記のDWrite stub crash markerが出ていなければ、patched DWriteによる起動確認は成功とする。

### 13.5 GUIの回帰確認

AviUtl2がクラッシュせず起動した後、必要に応じて次を順次確認する。

```text
AviUtl2メインウィンドウが表示される
日本語UIを読める
format 69 error dialogが出ない
L-SMASH Works r1284が認識される
text objectを追加できる
text選択ができる
caretを移動できる
textを再編集できる
Mozcで日本語入力・変換・Enter確定できる
「プラグインを信頼する」を押しても落ちない
```

これらは起動後の回帰確認項目である。今回Nanashi環境で確認済みなのは、patched DWrite導入後の診断起動でAviUtl2がクラッシュせず起動したことである。

### 13.6 通常起動

診断起動でAviUtl2がクラッシュせず起動した後は、通常launcherを使用できる。

```fish
fish \
    "$REPO/scripts/launch-aviutl2.fish" \
    --prefix "$PREFIX" \
    --ge-proton-root "$GE_PROTON_ROOT" \
    --dxvk-config "$DXVK_CONFIG_FILE"
```

通常launcherにも、診断起動で使用したものと同じ`GE_PROTON_ROOT`を渡す。

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