# AviUtl2 on Linux — ローカル修正の再現手順

最終更新日: 2026-07-31

## 1. この文書の目的

この文書は、次のリポジトリに保存されているローカル修正を別環境へ適用し、元環境と同じAviUtl2実行構成を再現するための手順である。

```text
https://github.com/AlexanderGG-0520/aviutl2-linux-patches
```

対象となる修正は次の3つである。

```text
patches/dxvk/0001-aviutl2-format-support.patch

patches/wine/0001-implement-dwrite-hit-testing.patch

patches/l-smash-works/0001-transfer-hardware-frames-before-output.patch
```

これらに加えて、次の設定と導入・起動スクリプトを使用する。

```text
config/nvidia-dxvk.conf
config/lsmash.ini

scripts/install-dwrite.fish
scripts/launch-aviutl2.example.fish
scripts/manage-aviutl2-catalog-lutris.sh
```

単にAviUtl2、DXVK、Wine、L-SMASH Worksの公式版を導入しただけでは、元環境の修正は再現されない。

必ずこのリポジトリのパッチ、設定ファイル、導入スクリプトを使用する。

---

## 2. 確認済みの構成

元環境では次の構成で動作を確認した。

| 項目             | 使用環境                                                                   |
| -------------- | ---------------------------------------------------------------------- |
| OS             | CachyOS                                                                |
| GPU            | NVIDIA GeForce RTX 4060 Ti 8 GB                                        |
| NVIDIA Driver  | 610.43.3                                                               |
| GE-Proton      | GE-Proton 11-1                                                         |
| Wine           | wine-staging 11.0                                                      |
| DXVK           | 2.7.1                                                                  |
| AviUtl2        | 2.1.2                                                                  |
| IME            | Fcitx5 + Mozc                                                          |
| Wine prefix    | `~/Games/aviutl2/prefix-ge-nvdec-test`                                 |
| パッチ済みGE-Proton | `~/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test` |

確認済みの機能:

```text
AviUtl2の起動
DXVK format 69問題の回避
AV1ファイルの読み込み
AV1の再生
AV1のシーク
NVIDIA NVDECの利用
テキスト選択
テキスト編集状態への移行
Fcitx5 / Mozcによる入力・変換・確定
AviUtl2 Catalogの同一prefixでの利用
Catalog更新後のパッチ済みL-SMASH Works復旧
```

別のWine、GE-Proton、DXVK、GPU、ドライバ、IME、デスクトップ環境で同じ結果になることは保証しない。

---

## 3. このリポジトリだけでは生成できないもの

このリポジトリには、次をゼロから生成するスクリプトは現時点では収録されていない。

```text
GE-Proton 11-1相当のWineソースツリー
設定済みWineビルドツリー
MinGW向けFFmpeg・L-SMASH・dav1d・libvpx・libvpl等の依存関係
```

そのため、Wine DWriteの再ビルドには、次の2つが既に存在することを前提とする。

```text
$WINE_SRC
$WINE_BUILD
```

期待する内容:

```text
$WINE_SRC/dlls/dwrite/layout.c

$WINE_BUILD/Makefile
$WINE_BUILD/dlls/dwrite/x86_64-windows/
```

L-SMASH Worksのビルドには、MinGW向け依存関係を格納した次のprefixが既に存在することを前提とする。

```text
$CROSS_PREFIX
```

この前提が満たされていない状態を「再現完了」とは扱わない。

---

## 4. 使用するシェル

対話用コマンドはFish 4.xを前提とする。

```text
fish
```

次は使用しない。

```text
Fish対話シェル直下での return
Fish対話シェル直下での exit
Bash用の heredoc をFishへ貼り付けること
```

リポジトリ内の`.sh`スクリプトはBashで実行する。

---

## 5. 必要パッケージ

CachyOS / Arch Linux系:

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
    lutris \
    github-cli
```

`bsdtar`は`libarchive`に含まれる。

NVIDIAドライバ、Vulkan、Fcitx5、Mozcは各環境に合わせて導入する。

---

## 6. 共通変数

Fishで次を設定する。

```fish
set ROOT "$HOME/Games/aviutl2"
set REPO "$HOME/projects/aviutl2-linux-patches"

set GE_ORIGINAL \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set PREFIX \
    "$ROOT/prefix-ge-nvdec-test"

set GE_WINE \
    "$GE_TEST/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_TEST/files/bin/wineserver"

set GE_LIBS \
    "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"

set DXVK_SRC \
    "$ROOT/src/dxvk-2.7.1-aviutl2"

set DXVK_OUT \
    "$ROOT/runtime/dxvk-2.7.1-aviutl2"

set WINE_SRC \
    "$ROOT/src/wine-ge11-1-dwrite"

set WINE_BUILD \
    "$ROOT/build/wine-ge11-1-dwrite"

set LSW_SRC \
    "$ROOT/src/L-SMASH-Works-nvdec"

set LSW_BUILD \
    "$ROOT/build/l-smash-works-nvdec"

set CROSS_PREFIX \
    "$LSW_BUILD/prefix"

set AVIUTL2_TARGET \
    "$PREFIX/drive_c/AviUtl2"

set PLUGIN_DIR \
    "$PREFIX/drive_c/ProgramData/aviutl2/Plugin"

set DXVK_CONFIG_FILE \
    "$ROOT/nvidia-dxvk.conf"
```

作業ディレクトリを作成する。

```fish
mkdir -p \
    "$ROOT/src" \
    "$ROOT/build" \
    "$ROOT/runtime" \
    "$ROOT/downloads" \
    "$ROOT/logs"
```

---

## 7. パッチリポジトリを取得

```fish
if test -d "$REPO/.git"
    git -C "$REPO" pull --ff-only origin main
else
    git clone \
        https://github.com/AlexanderGG-0520/aviutl2-linux-patches.git \
        "$REPO"
end
```

必要なファイルを確認する。

```fish
for path in \
    "$REPO/patches/dxvk/0001-aviutl2-format-support.patch" \
    "$REPO/patches/wine/0001-implement-dwrite-hit-testing.patch" \
    "$REPO/patches/l-smash-works/0001-transfer-hardware-frames-before-output.patch" \
    "$REPO/config/nvidia-dxvk.conf" \
    "$REPO/config/lsmash.ini" \
    "$REPO/scripts/install-dwrite.fish" \
    "$REPO/scripts/launch-aviutl2.example.fish" \
    "$REPO/scripts/manage-aviutl2-catalog-lutris.sh"

    if test -f "$path"
        echo "OK: $path"
    else
        echo "MISSING: $path"
    end
end
```

`MISSING`が1つでも出た場合は、以降へ進まない。

DXVK設定を、既存ランチャーが参照する場所へ配置する。

```fish
cp \
    "$REPO/config/nvidia-dxvk.conf" \
    "$DXVK_CONFIG_FILE"
```

確認:

```fish
cat "$DXVK_CONFIG_FILE"
```

期待値:

```text
dxgi.hideNvidiaGpu = False
```

---

## 8. GE-Proton 11-1をテスト用に複製

元のGE-Protonを直接変更しない。

最初に存在確認する。

```fish
if test -d "$GE_ORIGINAL"
    echo "OK: Original GE-Proton exists"
    echo "$GE_ORIGINAL"
else
    echo "ERROR: Original GE-Proton is missing"
    echo "$GE_ORIGINAL"
end
```

`GE_TEST`が既に存在する場合は、内容を確認せず上書きしない。

```fish
if test -d "$GE_TEST"
    echo "INFO: Test GE-Proton already exists"
    echo "$GE_TEST"
else
    cp -a \
        "$GE_ORIGINAL" \
        "$GE_TEST"

    echo "OK: Test GE-Proton was created"
end
```

実際に使用するWineとwineserverを確認する。

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
```

ライブラリーディレクトリを確認する。

```fish
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

Wineバージョン確認:

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

---

## 9. Wine prefixを準備

prefixが存在しない場合のみ作成する。

```fish
if test -d "$PREFIX/drive_c"
    echo "INFO: Wine prefix already exists"
    echo "$PREFIX"
else
    env \
        WINEPREFIX="$PREFIX" \
        LD_LIBRARY_PATH="$GE_LIBS" \
        "$GE_WINE" \
        wineboot -u
end
```

確認:

```fish
if test -d "$PREFIX/drive_c"
    echo "OK: Wine prefix exists"
else
    echo "ERROR: Wine prefix was not created"
end
```

---

## 10. AviUtl2本体を公式ZIPから配置

AviUtl2本体の`setup.exe`は使用しない。

Wine上でセットアップを実行すると、環境によって次のエラーが発生するためである。

```text
zipFile->BindToHandler() failed
HRESULT: 0x80070002
Place: System::Zip::openFile()
```

公式ZIPをLinux側で取得・検証・展開し、Wine prefixへ直接配置する。

### 10.1 ダウンロード

```fish
set AVIUTL2_VERSION "2.1.2"
set AVIUTL2_FILE "aviutl2_v$AVIUTL2_VERSION.zip"

set AVIUTL2_URL \
    "https://spring-fragrance.mints.ne.jp/aviutl/$AVIUTL2_FILE"

set AVIUTL2_ZIP \
    "$ROOT/downloads/$AVIUTL2_FILE"
```

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

    echo "OK: Downloaded"
    echo "$AVIUTL2_ZIP"
else
    echo "ERROR: AviUtl2 ZIP download failed"
end
```

### 10.2 ZIPを検証

```fish
file "$AVIUTL2_ZIP"

if bsdtar -tf "$AVIUTL2_ZIP" >/dev/null
    echo "OK: ZIP archive is readable"
else
    echo "ERROR: ZIP archive is invalid"
end

sha256sum "$AVIUTL2_ZIP"
```

### 10.3 展開と配置

```fish
set STAGE (mktemp -d)

if bsdtar -xf \
    "$AVIUTL2_ZIP" \
    -C "$STAGE"

    echo "OK: ZIP extracted"
else
    echo "ERROR: ZIP extraction failed"
end
```

```fish
set AVIUTL2_EXE (find \
    "$STAGE" \
    -type f \
    -iname aviutl2.exe \
    | head -n 1)

if test -n "$AVIUTL2_EXE"
    echo "OK: Found AviUtl2"
    echo "$AVIUTL2_EXE"
else
    echo "ERROR: aviutl2.exe was not found"
end
```

AviUtl2とwineserverを停止する。

```fish
env \
    WINEPREFIX="$PREFIX" \
    "$GE_WINESERVER" -k \
    2>/dev/null

sleep 1
```

既存のAviUtl2をバックアップする。

```fish
if test -d "$AVIUTL2_TARGET"
    set TS (date +%Y%m%d-%H%M%S)

    mv \
        "$AVIUTL2_TARGET" \
        "$AVIUTL2_TARGET.before-zip-install-$TS"
end
```

配置する。

```fish
if test -n "$AVIUTL2_EXE"
    set AVIUTL2_SOURCE \
        (dirname "$AVIUTL2_EXE")

    mkdir -p "$AVIUTL2_TARGET"

    cp -a \
        "$AVIUTL2_SOURCE/." \
        "$AVIUTL2_TARGET/"
end
```

非ポータブル構成を維持するため、本体フォルダ内の`data`を削除する。

```fish
rm -rf \
    "$AVIUTL2_TARGET/data"
```

確認:

```fish
if test -f "$AVIUTL2_TARGET/aviutl2.exe"
    echo "OK: AviUtl2 installed"
    echo "$AVIUTL2_TARGET/aviutl2.exe"
else
    echo "ERROR: AviUtl2 installation failed"
end
```

一時ディレクトリを削除する。

```fish
rm -rf "$STAGE"
```

---

## 11. DXVK 2.7.1へローカル修正を適用

使用するパッチ:

```text
patches/dxvk/0001-aviutl2-format-support.patch
```

このパッチは、次の条件をすべて満たした問い合わせだけを回避する。

```text
実行ファイル名がaviutl2.exe
DXGI formatがDXGI_FORMAT_G8R8_G8B8_UNORM
Vulkan mappingがVK_FORMAT_UNDEFINED
```

### 11.1 DXVKをサブモジュール込みで取得

```fish
if test -d "$DXVK_SRC/.git"
    echo "INFO: Existing DXVK source tree found"
    echo "$DXVK_SRC"

    git -C "$DXVK_SRC" submodule \
        sync \
        --recursive

    git -C "$DXVK_SRC" submodule \
        update \
        --init \
        --recursive
else
    git clone \
        --recursive \
        --branch v2.7.1 \
        --depth 1 \
        https://github.com/doitsujin/dxvk.git \
        "$DXVK_SRC"
end
```

基準バージョンを確認する。

```fish
git -C "$DXVK_SRC" describe \
    --tags \
    --exact-match \
    HEAD

git -C "$DXVK_SRC" status --short
```

期待値:

```text
v2.7.1
```

`v2.7.1`以外の場合は、パッチを適用しない。

### 11.2 DXVK同梱Vulkan-Headersを確認

DXVK 2.7.1は、次のサブモジュールを使用する。

```text
include/vulkan
include/spirv
include/native/directx
subprojects/libdisplay-info
```

Vulkanヘッダーを確認する。

```fish
set VK_INCLUDE \
    "$DXVK_SRC/include/vulkan/include"

set VK_HEADER \
    "$VK_INCLUDE/vulkan/vulkan.h"

if test -f "$VK_HEADER"
    echo "OK: DXVK Vulkan-Headers exists"
    echo "$VK_HEADER"
else
    echo "ERROR: DXVK Vulkan-Headers is missing"
    git -C "$DXVK_SRC" submodule status --recursive
end
```

SPIR-Vヘッダーも確認する。

```fish
set SPIRV_HEADER \
    "$DXVK_SRC/include/spirv/include/spirv/unified1/spirv.hpp"

if test -f "$SPIRV_HEADER"
    echo "OK: DXVK SPIRV-Headers exists"
else
    echo "ERROR: DXVK SPIRV-Headers is missing"
end
```

MinGWの標準include pathだけを検査する次のコマンドは、DXVKのサブモジュールを参照しないため、DXVKビルドの必須判定には使用しない。

```text
x86_64-w64-mingw32-gcc -x c -E -
```

必要ならDXVKのinclude pathを明示して検査する。

```fish
printf '#include <vulkan/vulkan.h>\nint main(void){return 0;}\n' \
    | x86_64-w64-mingw32-gcc \
        -I"$VK_INCLUDE" \
        -x c \
        -E - \
        >/dev/null

if test $status -eq 0
    echo "OK: MinGW can include DXVK Vulkan-Headers"
else
    echo "ERROR: MinGW cannot include DXVK Vulkan-Headers"
end
```

### 11.3 DXVKパッチを適用

```fish
set DXVK_PATCH \
    "$REPO/patches/dxvk/0001-aviutl2-format-support.patch"
```

```fish
if git -C "$DXVK_SRC" apply \
    --check \
    "$DXVK_PATCH"

    git -C "$DXVK_SRC" apply \
        "$DXVK_PATCH"

    if test $status -eq 0
        echo "OK: DXVK patch applied"
    else
        echo "ERROR: DXVK patch application failed"
    end

else if git -C "$DXVK_SRC" apply \
    --reverse \
    --check \
    "$DXVK_PATCH"

    echo "INFO: DXVK patch is already applied"

else
    echo "ERROR: DXVK patch does not match this source tree"
    echo
    git -C "$DXVK_SRC" describe \
        --tags \
        --always \
        --dirty

    git -C "$DXVK_SRC" status --short
end
```

次が出た場合はビルドへ進まない。

```text
patch does not apply
```

`--reject`による部分適用や、失敗したhunkを無視した状態を再現成功とは扱わない。

### 11.4 DXVKをビルド

失敗済みのMesonディレクトリを削除する。

```fish
rm -rf \
    "$DXVK_SRC/build.w64"
```

Meson setup:

```fish
meson setup \
    "$DXVK_SRC/build.w64" \
    "$DXVK_SRC" \
    --cross-file "$DXVK_SRC/build-win64.txt" \
    --buildtype release \
    --prefix "$DXVK_OUT"
```

`meson setup`が成功したことを確認する。

```fish
if test -f "$DXVK_SRC/build.w64/build.ninja"
    echo "OK: Meson build directory created"
else
    echo "ERROR: Meson setup failed"
end
```

成功した場合のみコンパイルする。

```fish
if test -f "$DXVK_SRC/build.w64/build.ninja"
    meson compile \
        -C "$DXVK_SRC/build.w64" \
        -j (nproc)
else
    echo "ERROR: DXVK compile skipped because setup failed"
end
```

コンパイル成功後にインストールする。

```fish
if test -f "$DXVK_SRC/build.w64/build.ninja"
    meson install \
        -C "$DXVK_SRC/build.w64"
else
    echo "ERROR: DXVK install skipped because setup failed"
end
```

生成物を確認する。

```fish
for dll in \
    d3d11.dll \
    dxgi.dll \
    d3d10core.dll

    if test -f "$DXVK_OUT/bin/$dll"
        echo "OK: $DXVK_OUT/bin/$dll"
    else
        echo "MISSING: $DXVK_OUT/bin/$dll"
    end
end
```

### 11.5 パッチ済みDXVKをprefixへ導入

```fish
set SYSTEM32 \
    "$PREFIX/drive_c/windows/system32"

set TS \
    (date +%Y%m%d-%H%M%S)
```

```fish
for dll in \
    d3d11.dll \
    dxgi.dll \
    d3d10core.dll

    set DLL_SRC \
        "$DXVK_OUT/bin/$dll"

    set DLL_DST \
        "$SYSTEM32/$dll"

    if not test -f "$DLL_SRC"
        echo "ERROR: Source DLL is missing"
        echo "$DLL_SRC"

    else
        if test -f "$DLL_DST"
            cp -a \
                "$DLL_DST" \
                "$DLL_DST.backup-$TS"
        end

        cp \
            "$DLL_SRC" \
            "$DLL_DST"

        echo "Installed:"
        echo "$DLL_DST"
    end
end
```

SHA-256を確認する。

```fish
for dll in \
    d3d11.dll \
    dxgi.dll \
    d3d10core.dll

    sha256sum \
        "$DXVK_OUT/bin/$dll" \
        "$SYSTEM32/$dll"
end
```

各ペアのSHA-256が一致していることを確認する。

---

## 12. Wine DirectWriteへローカル修正を適用

使用するパッチ:

```text
patches/wine/0001-implement-dwrite-hit-testing.patch
```

このパッチはWine DWriteの次を修正する。

```text
HitTestTextRange()
HitTestPoint()
HitTestTextPosition()を利用するヒットテスト処理
```

### 12.1 既存Wineソース・ビルドツリーを確認

このリポジトリは、`$WINE_SRC`と`$WINE_BUILD`をゼロから生成しない。

次が存在することを確認する。

```fish
printf 'WINE_SRC=%s\n' "$WINE_SRC"
printf 'WINE_BUILD=%s\n' "$WINE_BUILD"
```

```fish
for path in \
    "$WINE_SRC/dlls/dwrite/layout.c" \
    "$WINE_BUILD/Makefile" \
    "$REPO/patches/wine/0001-implement-dwrite-hit-testing.patch" \
    "$GE_TEST/files/lib/wine/x86_64-windows/dwrite.dll"

    if test -e "$path"
        echo "OK: $path"
    else
        echo "MISSING: $path"
    end
end
```

`$WINE_SRC`はGitリポジトリである必要はない。

必要なのは、対象ソースと設定済みビルドツリーが存在することである。

### 12.2 Wineパッチを適用

```fish
set DWRITE_PATCH \
    "$REPO/patches/wine/0001-implement-dwrite-hit-testing.patch"
```

まず通常方向のdry-runを行う。

```fish
patch \
    --batch \
    --forward \
    --directory="$WINE_SRC" \
    --strip=1 \
    --dry-run \
    <"$DWRITE_PATCH"

set DWRITE_FORWARD_STATUS $status
```

未適用なら実際に適用する。

```fish
if test $DWRITE_FORWARD_STATUS -eq 0
    patch \
        --batch \
        --forward \
        --directory="$WINE_SRC" \
        --strip=1 \
        <"$DWRITE_PATCH"

    if test $status -eq 0
        echo "OK: DWrite patch applied"
    else
        echo "ERROR: DWrite patch application failed"
    end
else
    echo "INFO: Forward dry-run failed; checking whether patch is already applied"
end
```

適用済みか確認する。

```fish
if test $DWRITE_FORWARD_STATUS -ne 0
    patch \
        --batch \
        --reverse \
        --directory="$WINE_SRC" \
        --strip=1 \
        --dry-run \
        <"$DWRITE_PATCH"

    if test $status -eq 0
        echo "INFO: DWrite patch is already applied"
    else
        echo "ERROR: DWrite patch does not match this Wine source"
    end
end
```

次が出た場合はビルドへ進まない。

```text
DWrite patch does not match this Wine source
```

### 12.3 DWriteだけを再ビルド

次は使用しない。

```text
make dlls/dwrite
make -B
```

対象オブジェクトとDLLを削除する。

```fish
rm -f \
    "$WINE_BUILD/dlls/dwrite/x86_64-windows/layout.o" \
    "$WINE_BUILD/dlls/dwrite/x86_64-windows/dwrite.dll"
```

PE DLLの完全なターゲット名を指定してビルドする。

```fish
make \
    -C "$WINE_BUILD" \
    -j(nproc) \
    dlls/dwrite/x86_64-windows/dwrite.dll
```

生成物を確認する。

```fish
set DWRITE_DLL \
    "$WINE_BUILD/dlls/dwrite/x86_64-windows/dwrite.dll"

if test -f "$DWRITE_DLL"
    echo "OK: Patched dwrite.dll was built"
    sha256sum "$DWRITE_DLL"
else
    echo "ERROR: Patched dwrite.dll was not generated"
    echo "$DWRITE_DLL"
end
```

### 12.4 既存スクリプトでGE-Protonへ導入

リポジトリ内の導入スクリプトを使用する。

```fish
fish \
    "$REPO/scripts/install-dwrite.fish" \
    "$WINE_BUILD" \
    "$GE_TEST"
```

このスクリプトは、既存のGE-Proton側`dwrite.dll`をタイムスタンプ付きでバックアップし、生成済みDLLを次へコピーする。

```text
$GE_TEST/files/lib/wine/x86_64-windows/dwrite.dll
```

SHA-256を再確認する。

```fish
sha256sum \
    "$WINE_BUILD/dlls/dwrite/x86_64-windows/dwrite.dll" \
    "$GE_TEST/files/lib/wine/x86_64-windows/dwrite.dll"
```

2つのSHA-256が一致していることを確認する。

---

## 13. L-SMASH WorksへNVDEC修正を適用

使用するパッチ:

```text
patches/l-smash-works/0001-transfer-hardware-frames-before-output.patch
```

このパッチは、FFmpegのハードウェアデコーダが返したGPU側フレームを、出力前に次でCPU側フレームへ転送する。

```c
av_hwframe_transfer_data()
```

### 13.1 対象コミットを取得

```fish
if test -d "$LSW_SRC/.git"
    echo "INFO: Existing L-SMASH Works source tree found"
    echo "$LSW_SRC"
else
    git clone \
        https://github.com/Mr-Ojii/L-SMASH-Works.git \
        "$LSW_SRC"
end
```

対象コミットへcheckoutする。

```fish
git -C "$LSW_SRC" checkout \
    a47764915f06fcd472e26ba2fbf25aff4b9d252e
```

状態確認:

```fish
git -C "$LSW_SRC" rev-parse HEAD
git -C "$LSW_SRC" status --short
```

期待値:

```text
a47764915f06fcd472e26ba2fbf25aff4b9d252e
```

### 13.2 L-SMASH Worksパッチを適用

```fish
set LSW_PATCH \
    "$REPO/patches/l-smash-works/0001-transfer-hardware-frames-before-output.patch"
```

新しいcheckoutへ適用する場合:

```fish
git -C "$LSW_SRC" am \
    "$LSW_PATCH"
```

成功確認:

```fish
if test -d "$LSW_SRC/.git/rebase-apply"
    echo "ERROR: git am is incomplete"
    echo "Resolve or abort before continuing"
else
    echo "INFO: No incomplete git am state detected"
end
```

パッチが適用されたことを確認する。

```fish
grep -Rni \
    "av_hwframe_transfer_data" \
    "$LSW_SRC/common"
```

期待する変更対象:

```text
common/lwlibav_video.c
common/video_output.c
common/video_output.h
```

`git am`が失敗した場合は、次で中断状態を戻す。

```fish
git -C "$LSW_SRC" am --abort
```

失敗した状態を無視してビルドしない。

### 13.3 MinGW依存関係を確認

このリポジトリは、L-SMASH Worksが必要とするMinGW向け依存関係を構築しない。

```fish
printf 'CROSS_PREFIX=%s\n' "$CROSS_PREFIX"
```

最低限、pkg-config情報を確認する。

```fish
if test -d "$CROSS_PREFIX/lib/pkgconfig"
    echo "OK: MinGW pkg-config directory exists"
else
    echo "ERROR: MinGW pkg-config directory is missing"
end
```

環境変数を設定する。

```fish
set -gx PATH \
    "$LSW_BUILD/bin" \
    $PATH

set -gx PKG_CONFIG_PATH \
    "$CROSS_PREFIX/lib/pkgconfig"

set -gx PKG_CONFIG_LIBDIR \
    "$CROSS_PREFIX/lib/pkgconfig"
```

### 13.4 AviUtl2 input pluginをビルド

```fish
cd "$LSW_SRC/AviUtl2"
```

既存の生成物を消す。

```fish
make distclean \
    2>/dev/null
```

configure:

```fish
env \
    PKG_CONFIG_PATH="$CROSS_PREFIX/lib/pkgconfig" \
    PKG_CONFIG_LIBDIR="$CROSS_PREFIX/lib/pkgconfig" \
    ./configure \
    --cross-prefix=x86_64-w64-mingw32- \
    --prefix="$CROSS_PREFIX" \
    --extra-cflags="-I$CROSS_PREFIX/include" \
    --extra-ldflags="-L$CROSS_PREFIX/lib -static-libgcc -static-libstdc++ -static" \
    --extra-libs="-lpthread"
```

ビルド:

```fish
make \
    -j(nproc) \
    input
```

生成物を検索する。

```fish
set LWINPUT (find \
    "$LSW_SRC" \
    -type f \
    -name lwinput.aui2 \
    | head -n 1)

if test -n "$LWINPUT"
    echo "OK: lwinput.aui2 was built"
    echo "$LWINPUT"
else
    echo "ERROR: lwinput.aui2 was not found"
end
```

### 13.5 パッチ済みプラグインと設定を配置

```fish
mkdir -p "$PLUGIN_DIR"
```

```fish
if test -n "$LWINPUT"
    cp \
        "$LWINPUT" \
        "$PLUGIN_DIR/lwinput.aui2"

    echo "Installed:"
    echo "$PLUGIN_DIR/lwinput.aui2"
else
    echo "ERROR: lwinput.aui2 installation skipped"
end
```

NVDEC設定を配置する。

```fish
cp \
    "$REPO/config/lsmash.ini" \
    "$PLUGIN_DIR/lsmash.ini"
```

期待する主要設定:

```ini
libavsmash_disabled=1
libav_disabled=0
preferred_decoders=av1_cuvid
```

確認:

```fish
grep -E \
    '^(libavsmash_disabled|libav_disabled|preferred_decoders)=' \
    "$PLUGIN_DIR/lsmash.ini"
```

---

## 14. AviUtl2を既存ランチャーで起動

リポジトリ内のFishランチャーを使用する。

```fish
env \
    AVIUTL2_ROOT="$ROOT" \
    AVIUTL2_PREFIX="$PREFIX" \
    GE_PROTON_ROOT="$GE_TEST" \
    fish "$REPO/scripts/launch-aviutl2.example.fish"
```

このランチャーは次を使用する。

```text
Wine:
$GE_TEST/files/lib/wine/x86_64-unix/wine

wineserver:
$GE_TEST/files/bin/wineserver
```

DLL override:

```text
nvcuda,nvcuvid,nvencodeapi64=n
d3d11,dxgi,d3d10core=n,b
d3dcompiler_47=n,b
dwrite=b
```

DXVK設定:

```text
$ROOT/nvidia-dxvk.conf
```

---

## 15. DXVKログを有効にして確認

```fish
mkdir -p \
    "$ROOT/logs/dxvk"
```

```fish
env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES="nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b" \
    DXVK_CONFIG_FILE="$DXVK_CONFIG_FILE" \
    DXVK_LOG_LEVEL=info \
    DXVK_LOG_PATH="$ROOT/logs/dxvk" \
    WINEDEBUG=-all \
    "$GE_WINE" \
    "$AVIUTL2_TARGET/aviutl2.exe"
```

確認項目:

```text
DXVKログが生成される
d3d11.dllがDXVKとして読み込まれる
dxgi.dllがDXVKとして読み込まれる
AviUtl2がformat 69問い合わせで停止しない
```

---

## 16. AviUtl2 Catalogを同じprefixへ導入

AviUtl2本体の導入では`setup.exe`を使用しないが、AviUtl2 Catalogはリポジトリの管理スクリプトから公式インストーラを既存prefixへ導入する。

管理スクリプト:

```text
scripts/manage-aviutl2-catalog-lutris.sh
```

最初に状態を確認する。

```fish
env \
    AVIUTL2_ROOT="$ROOT" \
    AVIUTL2_PREFIX="$PREFIX" \
    GE_PROTON_ROOT="$GE_TEST" \
    bash "$REPO/scripts/manage-aviutl2-catalog-lutris.sh" \
    status
```

Lutris用インストール:

```fish
env \
    AVIUTL2_ROOT="$ROOT" \
    AVIUTL2_PREFIX="$PREFIX" \
    GE_PROTON_ROOT="$GE_TEST" \
    bash "$REPO/scripts/manage-aviutl2-catalog-lutris.sh" \
    lutris-install
```

Lutrisを介さずインストールだけ行う場合:

```fish
env \
    AVIUTL2_ROOT="$ROOT" \
    AVIUTL2_PREFIX="$PREFIX" \
    GE_PROTON_ROOT="$GE_TEST" \
    bash "$REPO/scripts/manage-aviutl2-catalog-lutris.sh" \
    install-only
```

Catalog起動:

```fish
env \
    AVIUTL2_ROOT="$ROOT" \
    AVIUTL2_PREFIX="$PREFIX" \
    GE_PROTON_ROOT="$GE_TEST" \
    bash "$REPO/scripts/manage-aviutl2-catalog-lutris.sh" \
    launch
```

Catalog側の初期設定:

```text
AviUtl2は既にインストール済み
AviUtl2 root: C:\AviUtl2
Portable mode: 無効
```

非ポータブル構成では、プラグインと設定は次に保存される。

```text
C:\ProgramData\aviutl2
```

Linux側:

```text
$PREFIX/drive_c/ProgramData/aviutl2
```

---

## 17. Catalog更新後のL-SMASH Works復旧

CatalogからL-SMASH Worksを更新すると、パッチ済み`lwinput.aui2`が公式版で上書きされる可能性がある。

その場合は、パッチ済みプラグインと設定を再配置する。

```fish
if test -n "$LWINPUT"
    cp \
        "$LWINPUT" \
        "$PLUGIN_DIR/lwinput.aui2"
else
    echo "ERROR: LWINPUT is not set"
end
```

```fish
cp \
    "$REPO/config/lsmash.ini" \
    "$PLUGIN_DIR/lsmash.ini"
```

再配置後、AV1の読み込み、再生、シーク、NVDEC使用を再確認する。

---

## 18. 動作確認

### 18.1 AviUtl2本体

```fish
if test -f "$AVIUTL2_TARGET/aviutl2.exe"
    echo "OK: AviUtl2 executable exists"
else
    echo "ERROR: AviUtl2 executable is missing"
end
```

### 18.2 DXVK

確認項目:

```text
AviUtl2が起動する
format 69問い合わせで停止しない
DXVKログが生成される
パッチ済みd3d11.dllがprefixへ配置されている
```

### 18.3 Wine DirectWrite

確認項目:

```text
テキストオブジェクトを追加できる
選択範囲を描画できる
編集状態へ入れる
HitTestTextRange()のE_NOTIMPLで停止しない
HitTestPoint()のE_NOTIMPLで停止しない
```

### 18.4 Fcitx5 / Mozc

確認項目:

```text
日本語入力を開始できる
変換候補を表示できる
候補を選択できる
文字列を確定できる
```

### 18.5 L-SMASH Works / NVDEC

確認項目:

```text
AV1ファイルを読み込める
AV1を再生できる
シークできる
av1_cuvidが選択される
パッチ済みlwinput.aui2が配置されている
```

### 18.6 AviUtl2 Catalog

確認項目:

```text
同じWine prefixで起動できる
AviUtl2 rootがC:\AviUtl2になっている
Portable modeが無効になっている
ProgramData\aviutl2へプラグインが保存される
```

---

## 19. 再現完了条件

次をすべて満たした場合のみ、再現完了とする。

```text
公式ZIPからAviUtl2本体を配置できた

DXVK 2.7.1へ
patches/dxvk/0001-aviutl2-format-support.patch
を適用できた

パッチ済みDXVKをビルドできた

d3d11.dll
dxgi.dll
d3d10core.dll
をprefixへ配置できた

既存Wineソースへ
patches/wine/0001-implement-dwrite-hit-testing.patch
を適用できた

既存Wineビルドツリーで
dwrite.dll
を再ビルドできた

scripts/install-dwrite.fish
でパッチ済みdwrite.dllをGE-Protonへ導入できた

L-SMASH Worksへ
patches/l-smash-works/0001-transfer-hardware-frames-before-output.patch
を適用できた

パッチ済みlwinput.aui2をビルド・配置できた

config/lsmash.ini
を配置できた

scripts/launch-aviutl2.example.fish
からAviUtl2を起動できた

AV1の読み込み・再生・シークを確認できた

NVDECを利用できた

テキスト選択・編集を確認できた

Fcitx5 / Mozcで入力・変換・確定できた

AviUtl2 Catalogを同じprefixで利用できた
```

公式ソースだけをビルドし、リポジトリ内のパッチを適用していない状態は再現完了ではない。

---

## 20. 現時点の制限

このリポジトリだけでは、次は完全自動化されていない。

```text
GE-Proton 11-1相当Wineソースの取得
Wine staging / GE-Proton固有パッチの再構成
Wineビルドツリーの新規configure
MinGW向けFFmpeg依存関係の構築
L-SMASH Works依存関係の完全自動ビルド
```

これらを別環境でもゼロから再現可能にするには、今後、ソース取得コミット、Wine configure引数、依存ライブラリーの固定バージョンとビルドスクリプトを追加する必要がある。

それまでは、この文書が保証する範囲は次である。

```text
準備済みの対象ソース・ビルド環境へ
リポジトリ内のローカル修正を適用し、
生成物を既存GE-Proton・Wine prefixへ導入して
動作確認するところまで
```
