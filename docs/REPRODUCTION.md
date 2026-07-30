# AviUtl2 on Linux — 再現手順

最終確認日: 2026-07-31

関連リポジトリ:

- https://github.com/AlexanderGG-0520/aviutl2-linux-patches

## 1. この手順の対象

この文書は、次の構成を再現するための手順である。

- AviUtl2 を GE-Proton 11-1 で起動
- DXVK 2.7.1 の D3D11 format 69 対策
- NVIDIA NVDEC による AV1 デコード
- L-SMASH Works のハードウェアフレーム転送
- Wine DirectWrite の `HitTestTextRange()` と `HitTestPoint()` 実装
- Fcitx5/Mozc を有効にしたテキスト編集
- 同一 prefix 内での AviUtl2 Catalog 利用

このリポジトリはパッチと設定を配布する。AviUtl2 や各上流プロジェクトのバイナリは含まない。

## 2. 検証済み構成

| 項目 | バージョン |
| --- | --- |
| OS | CachyOS |
| GPU | NVIDIA GeForce RTX 4060 Ti 8 GB |
| NVIDIA Driver | 610.43.3 |
| GE-Proton | 11-1 |
| Wine | wine-staging 11.0 |
| DXVK | 2.7.1 |
| IME | Fcitx5 + Mozc |
| L-SMASH Works | base `a47764915f06fcd472e26ba2fbf25aff4b9d252e` |
| L-SMASH patch commit | `393df5ef669707f776261e4ac1bcc7e9a9a227ab` |
| DXVK base | `c3dd74be6baec53786d4e064a572185b70347a17` |

Wine は GE-Proton 11-1 に対応するソーススナップショットを使用する。検証時に展開した Wine ソースは `31af7f983b2e345d11340b120ae3a39d88c9338a` を基準にしていた。

## 3. 必要パッケージ

CachyOS / Arch Linux 系では、少なくとも次を準備する。

```fish
sudo pacman -S --needed \
    base-devel \
    curl \
    git \
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

GPU ドライバ、Vulkan、Fcitx5、Mozc は各環境に合わせて導入する。

## 4. 作業ディレクトリ

```fish
set ROOT "$HOME/Games/aviutl2"
set REPO "$HOME/projects/aviutl2-linux-patches"

mkdir -p \
    "$ROOT/src" \
    "$ROOT/build" \
    "$ROOT/runtime" \
    "$ROOT/logs"

git clone \
    https://github.com/AlexanderGG-0520/aviutl2-linux-patches.git \
    "$REPO"
```

推奨パス:

```text
AviUtl2 root:
~/Games/aviutl2

Wine prefix:
~/Games/aviutl2/prefix-ge-nvdec-test

Patched GE-Proton:
~/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test
```

## 5. GE-Proton をテスト用に複製

既存の GE-Proton 11-1 を直接改変しない。

```fish
set GE_ORIGINAL \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

rm -rf "$GE_TEST"
cp -a "$GE_ORIGINAL" "$GE_TEST"
```

## 6. Wine prefix と AviUtl2

### 6.1 prefix と GE-Proton のコマンドを設定

```fish
set PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_WINE \
    "$GE_TEST/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_TEST/files/bin/wineserver"

set GE_LIBS \
    "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"
```

### 6.2 公式インストーラを `curl` で取得

再現性を優先し、検証時に使用した AviUtl2 2.1.2 を固定して取得する。
新しいバージョンへ変更する場合は、公式配布ページを確認して
`AVIUTL2_VERSION` を更新する。

```fish
set AVIUTL2_VERSION "2.1.2"
set AVIUTL2_FILENAME (string join '' \
    "AviUtl2_v" "$AVIUTL2_VERSION" "_setup.exe")

set DOWNLOAD_DIR "$ROOT/downloads"
set AVIUTL2_INSTALLER "$DOWNLOAD_DIR/$AVIUTL2_FILENAME"
set AVIUTL2_PART (string join '' "$AVIUTL2_INSTALLER" ".part")
set AVIUTL2_URL \
    "https://spring-fragrance.mints.ne.jp/aviutl/$AVIUTL2_FILENAME"

mkdir -p "$DOWNLOAD_DIR"

if curl \
        --fail \
        --location \
        --retry 3 \
        --retry-delay 2 \
        --output "$AVIUTL2_PART" \
        "$AVIUTL2_URL"

    mv \
        "$AVIUTL2_PART" \
        "$AVIUTL2_INSTALLER"

    file "$AVIUTL2_INSTALLER"
else
    echo "ERROR: AviUtl2 installer download failed"
end
```

`curl` が HTTP エラーを返した場合は、壊れたファイルを完成品として扱わず、
`.part` のまま残る。公式配布ページでバージョンとURLを確認してから再実行する。

### 6.3 インストーラを同じ prefix で実行

```fish
mkdir -p "$PREFIX"

env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDEBUG=-all \
    "$GE_WINE" \
    "$AVIUTL2_INSTALLER"
```

セットアップ画面では、インストール先を次にする。

```text
C:\AviUtl2
```

インストール完了後の実体:

```text
$PREFIX/drive_c/AviUtl2/aviutl2.exe
```

確認:

```fish
if test -f "$PREFIX/drive_c/AviUtl2/aviutl2.exe"
    echo "OK: AviUtl2 installed"
else
    echo "ERROR: aviutl2.exe was not found"
end
```

AviUtl2 本体の利用条件は公式配布元に従う。

## 7. DXVK パッチ

### 7.1 ソース取得

```fish
set DXVK_SRC "$ROOT/src/dxvk-2.7.1-aviutl2"
set DXVK_OUT "$ROOT/runtime/dxvk-2.7.1-aviutl2"

git clone \
    --branch v2.7.1 \
    --depth 1 \
    https://github.com/doitsujin/dxvk.git \
    "$DXVK_SRC"
```

### 7.2 パッチ適用

```fish
git -C "$DXVK_SRC" apply \
    "$REPO/patches/dxvk/0001-aviutl2-format-support.patch"
```

確認:

```fish
git -C "$DXVK_SRC" diff --check
```

### 7.3 ビルド

```fish
meson setup \
    "$DXVK_SRC/build.w64" \
    "$DXVK_SRC" \
    --cross-file "$DXVK_SRC/build-win64.txt" \
    --buildtype release \
    --prefix "$DXVK_OUT"

meson compile \
    -C "$DXVK_SRC/build.w64" \
    -j (nproc)

meson install \
    -C "$DXVK_SRC/build.w64"
```

生成物:

```text
$DXVK_OUT/bin/d3d11.dll
$DXVK_OUT/bin/dxgi.dll
$DXVK_OUT/bin/d3d10core.dll
```

### 7.4 prefix へ導入

AviUtl2 を停止してから行う。

```fish
set SYSTEM32 "$PREFIX/drive_c/windows/system32"
set TS (date +%Y%m%d-%H%M%S)

for dll in d3d11.dll dxgi.dll d3d10core.dll
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

最低限の確認:

```fish
strings "$SYSTEM32/d3d11.dll" \
    | grep -E \
        'AviUtl2 compatibility|AviUtl2 trace'
```

## 8. Wine DirectWrite パッチ

### 8.1 ソース準備

GE-Proton 11-1 に対応する Wine ソースを用意し、次へ展開する。

```fish
set WINE_SRC "$ROOT/src/wine-ge11-1-dwrite"
set WINE_BUILD "$ROOT/build/wine-ge11-1-dwrite"
```

検証時の基準コミット:

```text
31af7f983b2e345d11340b120ae3a39d88c9338a
```

### 8.2 パッチ適用

Wine ソースが Git リポジトリでなくても適用できる。

```fish
cd "$WINE_SRC"

patch -p1 < \
    "$REPO/patches/wine/0001-implement-dwrite-hit-testing.patch"
```

### 8.3 Wine build tree を configure

GE-Proton と ABI が合うように、同じ世代の Wine ソースと同等のビルド条件を使う。

```fish
mkdir -p "$WINE_BUILD"
cd "$WINE_BUILD"

"$WINE_SRC/configure" \
    --enable-win64
```

GE-Proton の完全な再ビルドを行う場合は、GE-Proton 側のビルド手順を優先する。

### 8.4 DWrite のみ再ビルド

`make dlls/dwrite` や `make -B` は使用しない。

```fish
rm -f \
    "$WINE_BUILD/dlls/dwrite/x86_64-windows/layout.o" \
    "$WINE_BUILD/dlls/dwrite/x86_64-windows/dwrite.dll"

make -C "$WINE_BUILD" \
    -j(nproc) \
    dlls/dwrite/x86_64-windows/dwrite.dll
```

生成物:

```text
$WINE_BUILD/dlls/dwrite/x86_64-windows/dwrite.dll
```

### 8.5 パッチ済み GE-Proton へ導入

リポジトリのスクリプトを使う。

```fish
"$REPO/scripts/install-dwrite.fish" \
    "$WINE_BUILD" \
    "$GE_TEST"
```

このスクリプトは既存の DLL をタイムスタンプ付きでバックアップしてから置換する。

## 9. L-SMASH Works NVDEC パッチ

### 9.1 ソース取得

```fish
set LSW_SRC "$ROOT/src/L-SMASH-Works-nvdec"

git clone \
    https://github.com/Mr-Ojii/L-SMASH-Works.git \
    "$LSW_SRC"

git -C "$LSW_SRC" checkout \
    a47764915f06fcd472e26ba2fbf25aff4b9d252e
```

### 9.2 パッチ適用

このパッチは `git format-patch` 形式である。

```fish
git -C "$LSW_SRC" am \
    "$REPO/patches/l-smash-works/0001-transfer-hardware-frames-before-output.patch"
```

期待されるパッチ済みコミット:

```text
393df5ef669707f776261e4ac1bcc7e9a9a227ab
```

### 9.3 クロスビルド用依存関係

検証時は次のような x86_64-w64-mingw32 用の静的ライブラリを、専用 prefix へ用意した。

```text
FFmpeg 8.1
l-smash
obuparse
dav1d
libvpx
game-music-emu
libvpl
```

例:

```fish
set LSW_BUILD "$ROOT/build/l-smash-works-nvdec"
set CROSS_PREFIX "$LSW_BUILD/prefix"

set -gx PATH "$LSW_BUILD/bin" $PATH
set -gx PKG_CONFIG_PATH "$CROSS_PREFIX/lib/pkgconfig"
set -gx PKG_CONFIG_LIBDIR "$CROSS_PREFIX/lib/pkgconfig"
```

この依存関係一式の完全な自動ビルドは、現時点のリポジトリには含まれていない。各ライブラリを `x86_64-w64-mingw32` 向けに静的ビルドし、`$CROSS_PREFIX` へインストールする必要がある。

### 9.4 AviUtl2 input plugin のビルド

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

make -j(nproc) input
```

生成物:

```text
$LSW_SRC/AviUtl2/lwinput.aui2
```

確認:

```fish
file "$LSW_SRC/AviUtl2/lwinput.aui2"

strings -a "$LSW_SRC/AviUtl2/lwinput.aui2" \
    | grep -E \
        'av1_cuvid|av_hwframe_transfer_data|L-SMASH Works File Reader'
```

### 9.5 plugin をインストール

```fish
set PLUGIN_DIR \
    "$PREFIX/drive_c/ProgramData/aviutl2/Plugin"

mkdir -p "$PLUGIN_DIR"

set TS (date +%Y%m%d-%H%M%S)

if test -f "$PLUGIN_DIR/lwinput.aui2"
    cp -a \
        "$PLUGIN_DIR/lwinput.aui2" \
        "$PLUGIN_DIR/lwinput.aui2.backup-$TS"
end

cp \
    "$LSW_SRC/AviUtl2/lwinput.aui2" \
    "$PLUGIN_DIR/lwinput.aui2"

cp \
    "$REPO/config/lsmash.ini" \
    "$PLUGIN_DIR/lsmash.ini"
```

最終設定:

```ini
libavsmash_disabled=1
libav_disabled=0
preferred_decoders=av1_cuvid
```

## 10. NVIDIA DLL

NVIDIA の Wine 用 DLL が prefix から利用できる必要がある。

起動時の override:

```text
nvcuda,nvcuvid,nvencodeapi64=n
```

DLL の配置やシンボリックリンクは、使用している NVIDIA ドライバと Wine/Proton パッケージの構成に合わせる。

対象:

```text
nvcuda.dll
nvcuvid.dll
nvencodeapi64.dll
```

## 11. 起動

リポジトリの起動例をコピーして、必要に応じてパスを調整する。

```fish
cp \
    "$REPO/scripts/launch-aviutl2.example.fish" \
    "$REPO/scripts/launch-aviutl2.local.fish"

chmod +x \
    "$REPO/scripts/launch-aviutl2.local.fish"
```

最終的に使用した主要な環境変数:

```fish
set GE_WINE \
    "$GE_TEST/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_TEST/files/bin/wineserver"

set GE_LIBS \
    "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"

env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$REPO/config/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG=-all \
    "$GE_WINE" \
    "$PREFIX/drive_c/AviUtl2/aviutl2.exe"
```

## 12. AviUtl2 Catalog

AviUtl2 Catalog は同じ prefix にインストールする。

初回設定:

```text
AviUtl2 root:
C:\AviUtl2

Portable mode:
無効
```

非ポータブルモードのデータ:

```text
C:\ProgramData\aviutl2
```

Linux 側:

```text
$PREFIX/drive_c/ProgramData/aviutl2
```

Lutris では Linux Runner から固定ランチャーを呼び、Lutris に Wine/Proton/DXVK を自動選択させない構成が安全である。

## 13. Catalog 更新後の L-SMASH Works 復旧

Catalog で L-SMASH Works を更新すると、独自 `lwinput.aui2` が公式版で上書きされる。

更新後は次を再実行する。

```fish
set PLUGIN_DIR \
    "$PREFIX/drive_c/ProgramData/aviutl2/Plugin"

cp \
    "$LSW_SRC/AviUtl2/lwinput.aui2" \
    "$PLUGIN_DIR/lwinput.aui2"

cp \
    "$REPO/config/lsmash.ini" \
    "$PLUGIN_DIR/lsmash.ini"
```

その後、AV1 の読み込み、再生、シークを確認する。

可能なら Catalog 上で L-SMASH Works の更新を一時停止する。

## 14. 動作確認

### 14.1 DXVK

```fish
strings \
    "$PREFIX/drive_c/windows/system32/d3d11.dll" \
    | grep \
        'AviUtl2 compatibility'
```

### 14.2 L-SMASH Works

```fish
strings -a \
    "$PREFIX/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2" \
    | grep -E \
        'av1_cuvid|L-SMASH Works File Reader'
```

### 14.3 DWrite

デバッグ時のみ:

```fish
set LOG "$ROOT/logs/aviutl2-dwrite-check.log"

env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$REPO/config/nvidia-dxvk.conf" \
    WINEDEBUG='-all,+dwrite,+seh' \
    "$GE_WINE" \
    "$PREFIX/drive_c/AviUtl2/aviutl2.exe" \
    &> "$LOG"
```

確認:

```fish
grep -nEi \
    'HitTestPoint|HitTestTextRange|stub|E_NOTIMPL|80004001' \
    "$LOG" \
    | tail -n 100
```

次のような `stub` が残っていないことを確認する。

```text
fixme:dwrite:dwritetextlayout_HitTestPoint ... stub
```

### 14.4 実機テスト

1. AviUtl2 を起動
2. AV1 動画を読み込む
3. 再生する
4. 複数位置へシークする
5. テキストオブジェクトを作成する
6. 選択範囲を操作する
7. Mozc で日本語を入力・変換・確定する

## 15. ロールバック

### DXVK

各 DLL の `backup-<timestamp>` を元のファイル名へ戻す。

### DWrite

`install-dwrite.fish` が作成した次のバックアップを戻す。

```text
dwrite.dll.backup-<timestamp>
```

### L-SMASH Works

```text
lwinput.aui2.backup-<timestamp>
```

を `lwinput.aui2` へ戻す。

## 16. 既知の注意点

- `make dlls/dwrite` はディレクトリを完了済みターゲットと判断する場合がある
- `make -B` は Wine configure を強制し、無関係な依存関係で停止する場合がある
- ビルドに失敗した後、古い DLL を再コピーするとパッチが反映されたように見える
- DWrite の確認では、実行ログに `stub` が残っていないかを見る
- Catalog の更新は独自 L-SMASH Works を上書きする
- patched GE-Proton は通常の GE-Proton と別ディレクトリで管理する
- 他の Wine/GE-Proton/DXVK バージョンではパッチがそのまま適用できない場合がある

## 17. 再現完了の基準

次をすべて満たした時点で再現完了とする。

- AviUtl2 が起動する
- D3D11 format 69 で停止しない
- AV1 を読み込める
- AV1 を再生できる
- シークできる
- `av1_cuvid` が使用される
- テキスト選択で停止しない
- テキスト編集状態へ入れる
- Mozc の入力、変換、確定ができる
- Catalog を同じ prefix で起動できる
- Catalog 更新後も独自 L-SMASH Works を復旧できる
