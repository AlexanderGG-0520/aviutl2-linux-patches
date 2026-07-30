# AviUtl2 on Linux — 再現手順

最終更新日: 2026-07-31

> [!IMPORTANT]
> この文書は、元環境で成功した構成を基準に、別環境で再現確認するための手順である。
> 2026-07-31 時点では、クリーン環境からの全工程は未完了である。
> 未確認の工程を「再現済み」とは記載しない。

## 1. 対象構成

- AviUtl2 2.1.2
- GE-Proton 11-1 / wine-staging 11.0
- DXVK 2.7.1
- Wine DirectWrite patch
- NVIDIA NVDEC
- patched L-SMASH Works
- Fcitx5 + Mozc
- 非ポータブル構成
- Lutris の Linux Runner から固定ランチャーを起動

最終構成:

```text
Lutris
└── Linux Runner
    └── 固定ランチャー
        ├── GE-Proton11-1-aviutl2-test
        ├── prefix-ge-nvdec-test
        ├── patched DXVK
        ├── patched Wine DWrite
        ├── patched L-SMASH Works
        ├── AviUtl2
        └── AviUtl2 Catalog
```

## 2. 重要な前提

### 2.1 `setup.exe` は使用しない

AviUtl2 本体は公式 ZIP を Linux 側で取得・検証・展開し、次へ直接配置する。

```text
C:\AviUtl2
```

Wine 上で `setup.exe` を実行すると、環境によって次のエラーが発生する。

```text
zipFile->BindToHandler() failed
HRESULT: 0x80070002
Place: System::Zip::openFile()
```

### 2.2 実行バイナリを混在させない

元環境と管理スクリプトで実際に使用した値は次である。

```text
Wine:
$GE_TEST/files/lib/wine/x86_64-unix/wine

wineserver:
$GE_TEST/files/bin/wineserver
```

`$GE_TEST/files/bin/wine` を使う別手順と混在させない。

### 2.3 Lutris の Wine Runner を使わない

Lutris には Wine、Proton、DXVK の選択を任せない。
Linux Runner からリポジトリ内の固定ランチャーを呼ぶ。

## 3. 必要パッケージ

CachyOS / Arch Linux 系の基本パッケージ:

```fish
sudo pacman -S --needed \
    base-devel \
    git \
    curl \
    libarchive \
    meson \
    ninja \
    cmake \
    nasm \
    autoconf \
    automake \
    libtool \
    pkgconf \
    mingw-w64-gcc \
    freetype2 \
    lutris
```

この一覧だけでは、MinGW 側の Vulkan-Headers が揃うとは限らない。
DXVK ビルド前に必ずヘッダー検査を行う。

## 4. 共通変数

Fish で次を設定する。

```fish
set ROOT "$HOME/Games/aviutl2"
set REPO "$HOME/projects/aviutl2-linux-patches"

set GE_ORIGINAL \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_WINE \
    "$GE_TEST/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_TEST/files/bin/wineserver"

set GE_LIBS \
    "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"

set DXVK_CONFIG_FILE "$ROOT/nvidia-dxvk.conf"
```

作業ディレクトリ:

```fish
mkdir -p \
    "$ROOT/src" \
    "$ROOT/build" \
    "$ROOT/runtime" \
    "$ROOT/downloads" \
    "$ROOT/logs"
```

リポジトリ:

```fish
if test -d "$REPO/.git"
    git -C "$REPO" pull --ff-only origin main
else
    git clone \
        https://github.com/AlexanderGG-0520/aviutl2-linux-patches.git \
        "$REPO"
end
```

DXVK 設定を管理スクリプトの既定パスへ配置する。

```fish
cp \
    "$REPO/config/nvidia-dxvk.conf" \
    "$DXVK_CONFIG_FILE"
```

## 5. GE-Proton を複製

元の GE-Proton を直接変更しない。

```fish
if not test -d "$GE_ORIGINAL"
    echo "ERROR: GE-Proton 11-1 not found: $GE_ORIGINAL"
end

if test -d "$GE_TEST"
    set TS (date +%Y%m%d-%H%M%S)

    mv \
        "$GE_TEST" \
        "$GE_TEST.before-recreate-$TS"
end

cp -a \
    "$GE_ORIGINAL" \
    "$GE_TEST"
```

### 5.1 パス検査

```fish
for path in \
    "$GE_WINE" \
    "$GE_WINESERVER"

    if test -x "$path"
        echo "OK: $path"
    else
        echo "MISSING: $path"
    end
end

for path in \
    "$GE_TEST/files/lib64" \
    "$GE_TEST/files/lib" \
    "$GE_TEST/files/lib/wine/x86_64-unix" \
    "$GE_TEST/files/lib/wine/i386-unix"

    if test -d "$path"
        echo "OK: $path"
    else
        echo "MISSING: $path"
    end
end
```

`MISSING` が1つでも出た場合は、以降へ進まない。

Wine バージョン確認:

```fish
env \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" \
    --version
```

元環境の期待値:

```text
wine-staging 11.0
```

## 6. Wine prefix を作成

```fish
if not test -d "$PREFIX/drive_c"
    env \
        WINEPREFIX="$PREFIX" \
        LD_LIBRARY_PATH="$GE_LIBS" \
        "$GE_WINE" \
        wineboot -u
end
```

確認:

```fish
test -d "$PREFIX/drive_c"
and echo "OK: prefix exists"
```

## 7. AviUtl2 を公式 ZIP から配置

```fish
set AVIUTL2_VERSION "2.1.2"
set AVIUTL2_FILE "aviutl2_v$AVIUTL2_VERSION.zip"
set AVIUTL2_URL \
    "https://spring-fragrance.mints.ne.jp/aviutl/$AVIUTL2_FILE"
set AVIUTL2_ZIP \
    "$ROOT/downloads/$AVIUTL2_FILE"
```

取得:

```fish
rm -f "$AVIUTL2_ZIP.part"

curl \
    --fail \
    --location \
    --retry 3 \
    --retry-all-errors \
    --output "$AVIUTL2_ZIP.part" \
    "$AVIUTL2_URL"

if test $status -eq 0
    mv \
        "$AVIUTL2_ZIP.part" \
        "$AVIUTL2_ZIP"
else
    echo "ERROR: AviUtl2 ZIP download failed"
end
```

検証:

```fish
file "$AVIUTL2_ZIP"
bsdtar -tf "$AVIUTL2_ZIP" >/dev/null
and echo "OK: ZIP archive is readable"

sha256sum "$AVIUTL2_ZIP"
```

展開と配置:

```fish
set STAGE (mktemp -d)

bsdtar -xf \
    "$AVIUTL2_ZIP" \
    -C "$STAGE"

set AVIUTL2_EXE (find \
    "$STAGE" \
    -type f \
    -iname aviutl2.exe \
    | head -n 1)

set AVIUTL2_TARGET \
    "$PREFIX/drive_c/AviUtl2"

if test -z "$AVIUTL2_EXE"
    echo "ERROR: aviutl2.exe was not found in ZIP"
else
    env \
        WINEPREFIX="$PREFIX" \
        "$GE_WINESERVER" -k \
        2>/dev/null

    sleep 1

    if test -d "$AVIUTL2_TARGET"
        set TS (date +%Y%m%d-%H%M%S)

        mv \
            "$AVIUTL2_TARGET" \
            "$AVIUTL2_TARGET.before-zip-install-$TS"
    end

    set AVIUTL2_SOURCE \
        (dirname "$AVIUTL2_EXE")

    mkdir -p "$AVIUTL2_TARGET"

    cp -a \
        "$AVIUTL2_SOURCE/." \
        "$AVIUTL2_TARGET/"
end

rm -rf "$STAGE"
```

非ポータブル構成を維持する。

```fish
rm -rf "$AVIUTL2_TARGET/data"
```

確認:

```fish
test -f "$AVIUTL2_TARGET/aviutl2.exe"
and echo "OK: AviUtl2 installed"
```

## 8. DXVK 2.7.1

### 8.1 ソース取得

```fish
set DXVK_SRC \
    "$ROOT/src/dxvk-2.7.1-aviutl2"

set DXVK_OUT \
    "$ROOT/runtime/dxvk-2.7.1-aviutl2"

if not test -d "$DXVK_SRC/.git"
    git clone \
        --recursive \
        --branch v2.7.1 \
        --depth 1 \
        https://github.com/doitsujin/dxvk.git \
        "$DXVK_SRC"
else
    git -C "$DXVK_SRC" submodule \
        update \
        --init \
        --recursive
end
```

必ず基準を確認する。

```fish
git -C "$DXVK_SRC" rev-parse HEAD
git -C "$DXVK_SRC" describe --tags --always --dirty
git -C "$DXVK_SRC" status --short
```

期待する基準:

```text
c3dd74be6baec53786d4e064a572185b70347a17
v2.7.1
```

### 8.2 パッチ適用

```fish
set DXVK_PATCH \
    "$REPO/patches/dxvk/0001-aviutl2-format-support.patch"

if git -C "$DXVK_SRC" apply --check "$DXVK_PATCH"
    git -C "$DXVK_SRC" apply "$DXVK_PATCH"
    echo "OK: DXVK patch applied"
else if git -C "$DXVK_SRC" apply --reverse --check "$DXVK_PATCH"
    echo "OK: DXVK patch is already applied"
else
    echo "ERROR: DXVK patch does not match this source tree"
    git -C "$DXVK_SRC" describe --tags --always --dirty
    git -C "$DXVK_SRC" status --short
end
```

最後の `ERROR` が出た場合は、ビルドへ進まない。
`--reject` や手動の部分適用で「再現成功」と扱わない。

2026-07-31 の別環境では、次で停止している。

```text
patch failed: src/d3d11/d3d11_device.cpp:30
patch does not apply
```

### 8.3 MinGW 側 Vulkan-Headers の検査

```fish
# DXVKソースの場所を確認
echo "$DXVK_SRC"

if not test -d "$DXVK_SRC/.git"
    echo "ERROR: DXVK source repository not found: $DXVK_SRC"
    return 1
end

# サブモジュール設定を同期して取得
git -C "$DXVK_SRC" submodule sync --recursive

and git -C "$DXVK_SRC" submodule update \
    --init \
    --recursive

or begin
    echo "ERROR: Failed to initialize DXVK submodules"
    return 1
end

# Vulkan-Headersの実体を確認
set VK_INCLUDE "$DXVK_SRC/include/vulkan/include"
set VK_HEADER  "$VK_INCLUDE/vulkan/vulkan.h"

if not test -f "$VK_HEADER"
    echo "ERROR: Vulkan header not found:"
    echo "$VK_HEADER"

    echo
    echo "Submodule status:"
    git -C "$DXVK_SRC" submodule status --recursive

    return 1
end

echo "OK: Vulkan-Headers found:"
echo "$VK_HEADER"

# DXVKのinclude pathを明示してMinGWで検査
printf '#include <vulkan/vulkan.h>\nint main(void){return 0;}\n' \
    | x86_64-w64-mingw32-gcc \
        -I"$VK_INCLUDE" \
        -x c \
        -E - \
        >/dev/null

if test $status -ne 0
    echo "ERROR: MinGW cannot include DXVK Vulkan-Headers"
    return 1
end

echo "OK: MinGW can include DXVK Vulkan-Headers"
```

`ERROR` の場合は Meson を実行しない。
ホスト側で Vulkan が動作していても、MinGW クロスコンパイラからヘッダーが見えるとは限らない。

2026-07-31 の別環境では、次で停止している。

```text
Check usable header "vulkan/vulkan.h" : NO
ERROR: Missing Vulkan-Headers
```

### 8.4 ビルド

パッチ適用と Vulkan-Headers 検査の両方が通った場合だけ実行する。

```fish
rm -rf "$DXVK_SRC/build.w64"

meson setup \
    "$DXVK_SRC/build.w64" \
    "$DXVK_SRC" \
    --cross-file "$DXVK_SRC/build-win64.txt" \
    --buildtype release \
    --prefix "$DXVK_OUT"

and meson compile \
    -C "$DXVK_SRC/build.w64" \
    -j (nproc)

and meson install \
    -C "$DXVK_SRC/build.w64"

or begin
    echo "ERROR: DXVK build failed"
    return 1
end

echo "OK: DXVK build and install completed"
```

`meson setup` が失敗した後に出る次のエラーは二次障害である。

```text
Current directory is not a meson build directory
Install data not found
```

### 8.5 生成物確認

```fish
for dll in d3d11.dll dxgi.dll d3d10core.dll
    set dll_path "$DXVK_OUT/bin/$dll"

    if test -f "$dll_path"
        echo "OK: $dll_path"
    else
        echo "ERROR: Missing DLL: $dll_path"
    end
end
```

パッチ文字列:

```fish
strings "$DXVK_OUT/bin/d3d11.dll" \
    | grep -E \
        'AviUtl2 compatibility|AviUtl2 trace'
```

### 8.6 Prefix へ導入

```fish
set SYSTEM32 \
    "$PREFIX/drive_c/windows/system32"
set TS (date +%Y%m%d-%H%M%S)

for dll in \
    d3d11.dll \
    dxgi.dll \
    d3d10core.dll

    if test -f "$SYSTEM32/$dll"
        cp -a \
            "$SYSTEM32/$dll" \
            "$SYSTEM32/$dll.backup-$TS"
    end

    cp \
        "$DXVK_OUT/bin/$dll" \
        "$SYSTEM32/$dll"
end
```

## 9. Wine DirectWrite

> [!WARNING]
> 元環境では DWrite パッチ済み DLL の動作を確認済みだが、クリーンな別環境でパッチ適用から導入までの全工程は未確認である。
> `patch --dry-run` が失敗した場合は、そのまま適用しない。

### 9.1 ソース取得

```fish
set WINE_COMMIT \
    "31af7f983b2e345d11340b120ae3a39d88c9338a"

set WINE_SRC \
    "$ROOT/src/wine-ge11-1-dwrite"

set WINE_BUILD \
    "$ROOT/build/wine-ge11-1-dwrite"

set WINE_ARCHIVE \
    "$ROOT/downloads/wine-$WINE_COMMIT.tar.gz"

rm -rf \
    "$WINE_SRC" \
    "$WINE_BUILD"

mkdir -p \
    "$WINE_SRC" \
    "$WINE_BUILD"

curl \
    --fail \
    --location \
    --output "$WINE_ARCHIVE" \
    "https://github.com/ValveSoftware/wine/archive/$WINE_COMMIT.tar.gz"

tar \
    --extract \
    --file "$WINE_ARCHIVE" \
    --directory "$WINE_SRC" \
    --strip-components=1
```

### 9.2 パッチ検査と適用

```fish
set DWRITE_PATCH \
    "$REPO/patches/wine/0001-implement-dwrite-hit-testing.patch"

patch \
    --directory="$WINE_SRC" \
    --strip=1 \
    --dry-run \
    < "$DWRITE_PATCH"
```

この dry-run が成功した場合だけ適用する。

```fish
patch \
    --directory="$WINE_SRC" \
    --strip=1 \
    < "$DWRITE_PATCH"
```

失敗時は `.rej` を残したまま作業を続けない。
元の開発ログでは、異なるパッチ版を使用した際に一部 hunk が失敗し、手動調整が必要だった。

### 9.3 Configure と DWrite ビルド

```fish
cd "$WINE_BUILD"

"$WINE_SRC/configure" \
    --enable-win64
```

`make dlls/dwrite` と `make -B` は使用しない。

```fish
rm -f \
    "$WINE_BUILD/dlls/dwrite/x86_64-windows/layout.o" \
    "$WINE_BUILD/dlls/dwrite/x86_64-windows/dwrite.dll"

make -C "$WINE_BUILD" \
    -j(nproc) \
    dlls/dwrite/x86_64-windows/dwrite.dll
```

導入:

```fish
"$REPO/scripts/install-dwrite.fish" \
    "$WINE_BUILD" \
    "$GE_TEST"
```

確認:

```fish
test -f \
    "$GE_TEST/files/lib/wine/x86_64-windows/dwrite.dll"

and echo "OK: dwrite.dll exists"
```

## 10. L-SMASH Works NVDEC

> [!WARNING]
> パッチとビルド済み成果物の動作は元環境で確認済みである。
> ただし、FFmpeg などの MinGW 静的依存関係をゼロから構築する完全自動手順は、このリポジトリにまだ存在しない。
> したがって、この章だけではクリーン環境から完全再現できない。

### 10.1 ソースとパッチ

```fish
set LSW_SRC \
    "$ROOT/src/L-SMASH-Works-nvdec"

if not test -d "$LSW_SRC/.git"
    git clone \
        https://github.com/Mr-Ojii/L-SMASH-Works.git \
        "$LSW_SRC"
end

git -C "$LSW_SRC" checkout \
    a47764915f06fcd472e26ba2fbf25aff4b9d252e

git -C "$LSW_SRC" am \
    "$REPO/patches/l-smash-works/0001-transfer-hardware-frames-before-output.patch"
```

期待するコミット:

```text
393df5ef669707f776261e4ac1bcc7e9a9a227ab
```

### 10.2 既存のクロスビルド依存関係を使う場合

```fish
set LSW_BUILD \
    "$ROOT/build/l-smash-works-nvdec"

set CROSS_PREFIX \
    "$LSW_BUILD/prefix"

set -gx PATH \
    "$LSW_BUILD/bin" \
    $PATH

set -gx PKG_CONFIG_PATH \
    "$CROSS_PREFIX/lib/pkgconfig"

set -gx PKG_CONFIG_LIBDIR \
    "$CROSS_PREFIX/lib/pkgconfig"
```

```fish
cd "$LSW_SRC/AviUtl2"

make distclean 2>/dev/null
or true

env \
    PKG_CONFIG_PATH="$CROSS_PREFIX/lib/pkgconfig" \
    PKG_CONFIG_LIBDIR="$CROSS_PREFIX/lib/pkgconfig" \
    ./configure \
    --cross-prefix=x86_64-w64-mingw32- \
    --prefix="$CROSS_PREFIX" \
    --extra-cflags="-I$CROSS_PREFIX/include" \
    --extra-ldflags="-L$CROSS_PREFIX/lib -static-libgcc -static-libstdc++ -static" \
    --extra-libs="-lpthread"

make \
    -j(nproc) \
    input
```

配置:

```fish
set PLUGIN_DIR \
    "$PREFIX/drive_c/ProgramData/aviutl2/Plugin"

mkdir -p "$PLUGIN_DIR"

cp \
    "$LSW_SRC/AviUtl2/lwinput.aui2" \
    "$PLUGIN_DIR/lwinput.aui2"

cp \
    "$REPO/config/lsmash.ini" \
    "$PLUGIN_DIR/lsmash.ini"
```

## 11. 起動

```fish
set WINEDLLOVERRIDES_VALUE \
    "nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b"

env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES="$WINEDLLOVERRIDES_VALUE" \
    DXVK_CONFIG_FILE="$DXVK_CONFIG_FILE" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG=-all \
    "$GE_WINE" \
    "$PREFIX/drive_c/AviUtl2/aviutl2.exe"
```

実運用では、同じ値を使用する固定ランチャーを Lutris の Linux Runner から起動する。

## 12. AviUtl2 Catalog

管理スクリプト:

```text
scripts/manage-aviutl2-catalog-lutris.sh
```

初回:

```fish
"$REPO/scripts/manage-aviutl2-catalog-lutris.sh" \
    lutris-install
```

Catalog 設定:

```text
AviUtl2:
  インストール済み

AviUtl2 root:
  C:\AviUtl2

Portable mode:
  無効
```

詳細は [`LUTRIS-CATALOG.md`](LUTRIS-CATALOG.md) を参照する。

## 13. 動作確認

### 13.1 DXVK

```fish
strings \
    "$PREFIX/drive_c/windows/system32/d3d11.dll" \
    | grep -E \
        'AviUtl2 compatibility|AviUtl2 trace'
```

### 13.2 L-SMASH Works

```fish
strings -a \
    "$PREFIX/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2" \
    | grep -E \
        'av1_cuvid|av_hwframe_transfer_data|L-SMASH Works File Reader'
```

### 13.3 DWrite

```fish
set LOG \
    "$ROOT/logs/aviutl2-dwrite-check.log"

env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES="$WINEDLLOVERRIDES_VALUE" \
    DXVK_CONFIG_FILE="$DXVK_CONFIG_FILE" \
    WINEDEBUG='-all,+dwrite,+seh' \
    "$GE_WINE" \
    "$PREFIX/drive_c/AviUtl2/aviutl2.exe" \
    &> "$LOG"
```

```fish
grep -nEi \
    'HitTestPoint|HitTestTextRange|stub|E_NOTIMPL|80004001' \
    "$LOG" \
    | tail -n 100
```

### 13.4 実機テスト

1. AviUtl2 が起動する
2. AV1 を読み込める
3. AV1 を再生できる
4. 複数位置へシークできる
5. `av1_cuvid` を使用できる
6. テキストオブジェクトを追加できる
7. テキスト選択でクラッシュしない
8. 編集状態へ入れる
9. Mozc で入力・変換・確定できる
10. Catalog を同じ prefix で起動できる

## 14. 再現完了条件

次をすべて満たした場合だけ、別環境での再現完了とする。

- クリーンな DXVK 2.7.1 ソースへパッチを自動適用できる
- MinGW 側 Vulkan-Headers 検査が通る
- DXVK の3 DLLを生成できる
- DWrite パッチを dry-run から自動適用できる
- DWrite DLLを生成・導入できる
- L-SMASH Works の依存関係を含めてビルドできる
- AviUtl2 が起動する
- AV1、NVDEC、シークを確認できる
- テキスト編集と Mozc を確認できる
- Catalog を確認できる

2026-07-31 時点では、この条件を別環境で満たしていない。
