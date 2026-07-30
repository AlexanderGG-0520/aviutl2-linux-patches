AviUtl2 on Linux — 再現手順

最終更新日: 2026-07-31

関連リポジトリ:

https://github.com/AlexanderGG-0520/aviutl2-linux-patches

1. 方針

この手順では、AviUtl2 の setup.exe を Wine 上で実行しない。

代わりに、公式配布の ZIP を Linux 側で curl により取得し、bsdtar で展開して Wine prefix の C:\AviUtl2 に直接配置する。

公式 ZIP を curl で取得
→ Linux 側で ZIP を検証
→ Linux 側で展開
→ Wine prefix の drive_c/AviUtl2 へ配置
→ DXVK / Wine DWrite / L-SMASH Works の各パッチを適用
→ Lutris から固定環境で起動

setup.exe を使用しない理由

Wine や GE-Proton のバージョンによっては、AviUtl2 のセットアップ処理中に Windows Shell の ZIP ハンドラーが利用できず、次のようなエラーで停止することがある。

zipFile->BindToHandler() failed.
HRESULT: 0x80070002
File not found.
Place: System::Zip::openFile()

ZIP を Linux 側で展開すれば、この Windows Shell API 経路を通らないため、Wine バージョン差によるセットアップ失敗を回避できる。

AviUtl2 公式ドキュメントでも、インストーラを使用しない場合は本体と付属ファイルを任意のフォルダへ配置できると説明されている。

2. この手順で再現する構成

AviUtl2 を GE-Proton 11-1 で起動

AviUtl2 本体を公式 ZIP から直接配置

DXVK 2.7.1 の D3D11 format 69 対策

Wine DirectWrite の HitTestTextRange() と HitTestPoint() 実装

NVIDIA NVDEC による AV1 デコード

L-SMASH Works のハードウェアフレーム転送

Fcitx5 / Mozc を有効にしたテキスト編集

AviUtl2 Catalog を同じ Wine prefix で利用

このリポジトリはパッチ、設定例、ドキュメント、補助スクリプトを配布する。

AviUtl2、Wine、GE-Proton、DXVK、L-SMASH Works、FFmpeg、NVIDIA のバイナリ本体は配布しない。

3. 検証済み環境

項目

検証値

OS

CachyOS

GPU

NVIDIA GeForce RTX 4060 Ti 8 GB

NVIDIA Driver

610.43.3

GE-Proton

11-1

Wine

wine-staging 11.0

DXVK

2.7.1

AviUtl2

2.1.2

IME

Fcitx5 + Mozc

Wine prefix

~/Games/aviutl2/prefix-ge-nvdec-test

パッチ済み GE-Proton

~/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test

別の Wine、GE-Proton、DXVK、GPU、ドライバ、IME、デスクトップ環境で同じ結果になることは保証しない。

特に Wine DWrite パッチは、GE-Proton 11-1 相当の Wine ソースを基準にしている。

4. 必要パッケージ

CachyOS / Arch Linux 系:

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

bsdtar は libarchive パッケージに含まれる。

GPU ドライバ、Vulkan、Fcitx5、Mozc は各環境に合わせて導入する。

5. 作業ディレクトリ

set ROOT "$HOME/Games/aviutl2"
set REPO "$HOME/projects/aviutl2-linux-patches"

mkdir -p \
    "$ROOT/src" \
    "$ROOT/build" \
    "$ROOT/runtime" \
    "$ROOT/downloads" \
    "$ROOT/logs"

パッチリポジトリを取得する。

if test -d "$REPO/.git"
    git -C "$REPO" pull --ff-only origin main
else
    git clone \
        https://github.com/AlexanderGG-0520/aviutl2-linux-patches.git \
        "$REPO"
end

6. GE-Proton 11-1 をテスト用に複製

既存の GE-Proton 本体を直接変更しない。

set GE_ORIGINAL \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

if test -d "$GE_TEST"
    set TS (date +%Y%m%d-%H%M%S)

    mv \
        "$GE_TEST" \
        "$GE_TEST.before-recreate-$TS"
end

cp -a \
    "$GE_ORIGINAL" \
    "$GE_TEST"

Wine バージョンを確認する。

set GE_LIBS \
    "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"

env \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_TEST/files/lib/wine/x86_64-unix/wine" \
    --version

検証環境の期待値:

wine-staging 11.0

7. Wine prefix を準備

set PREFIX "$ROOT/prefix-ge-nvdec-test"
set GE_WINE "$GE_TEST/files/lib/wine/x86_64-unix/wine"
set GE_WINESERVER "$GE_TEST/files/bin/wineserver"

prefix がまだ存在しない場合:

if not test -d "$PREFIX/drive_c"
    env \
        WINEPREFIX="$PREFIX" \
        LD_LIBRARY_PATH="$GE_LIBS" \
        "$GE_WINE" wineboot -u
end

以後、Windows 側では次のパスとして扱う。

AviUtl2:
C:\AviUtl2

プラグイン・設定:
C:\ProgramData\aviutl2

Linux 側:

~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2

~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/ProgramData/aviutl2

8. AviUtl2 公式 ZIP を curl で取得

この手順ではバージョンを固定し、再現性を優先する。

set AVIUTL2_VERSION "2.1.2"
set AVIUTL2_FILE "aviutl2_v$AVIUTL2_VERSION.zip"

set AVIUTL2_URL \
    "https://spring-fragrance.mints.ne.jp/aviutl/$AVIUTL2_FILE"

set AVIUTL2_ZIP \
    "$ROOT/downloads/$AVIUTL2_FILE"

不完全なダウンロードを正式ファイル名で残さないよう、最初は .part へ保存する。

rm -f \
    "$AVIUTL2_ZIP.part"

curl \
    --fail \
    --location \
    --retry 3 \
    --retry-all-errors \
    --output "$AVIUTL2_ZIP.part" \
    "$AVIUTL2_URL"

if test $status -ne 0
    echo "ERROR: AviUtl2 ZIPのダウンロードに失敗"
else
    mv \
        "$AVIUTL2_ZIP.part" \
        "$AVIUTL2_ZIP"

    echo "Downloaded:"
    echo "$AVIUTL2_ZIP"
end

9. ZIP を検証

ファイル形式を確認する。

file \
    "$AVIUTL2_ZIP"

アーカイブ一覧を読み取れるか確認する。

bsdtar -tf \
    "$AVIUTL2_ZIP" \
    >/dev/null

if test $status -eq 0
    echo "OK: ZIP archive is readable"
else
    echo "ERROR: ZIP archive is invalid"
end

必要に応じて SHA-256 を記録する。

sha256sum \
    "$AVIUTL2_ZIP"

公式配布側がチェックサムを公開している場合は、その値と照合する。

公開されていない場合でも、導入記録として SHA-256 を保存しておくと再現確認に利用できる。

10. ZIP を一時ディレクトリへ展開

set STAGE (mktemp -d)

bsdtar -xf \
    "$AVIUTL2_ZIP" \
    -C "$STAGE"

aviutl2.exe を検索する。

set AVIUTL2_EXE (find \
    "$STAGE" \
    -type f \
    -iname aviutl2.exe \
    | head -n 1)

if test -z "$AVIUTL2_EXE"
    echo "ERROR: ZIP内にaviutl2.exeが見つからない"

    find \
        "$STAGE" \
        -maxdepth 3 \
        -type f \
        -print
else
    echo "Found:"
    echo "$AVIUTL2_EXE"
end

11. C:\AviUtl2 へ配置

set AVIUTL2_TARGET \
    "$PREFIX/drive_c/AviUtl2"

AviUtl2 と wineserver を停止する。

env \
    WINEPREFIX="$PREFIX" \
    "$GE_WINESERVER" -k \
    2>/dev/null

sleep 1

既存の本体フォルダをバックアップする。

if test -d "$AVIUTL2_TARGET"
    set TS (date +%Y%m%d-%H%M%S)

    mv \
        "$AVIUTL2_TARGET" \
        "$AVIUTL2_TARGET.before-zip-install-$TS"
end

ZIP 内の aviutl2.exe があるフォルダを、そのまま C:\AviUtl2 へコピーする。

if test -n "$AVIUTL2_EXE"
    set AVIUTL2_SOURCE \
        (dirname "$AVIUTL2_EXE")

    mkdir -p \
        "$AVIUTL2_TARGET"

    cp -a \
        "$AVIUTL2_SOURCE/." \
        "$AVIUTL2_TARGET/"
end

配置確認:

if test -f "$AVIUTL2_TARGET/aviutl2.exe"
    echo "OK:"
    echo "$AVIUTL2_TARGET/aviutl2.exe"
else
    echo "ERROR: aviutl2.exe was not installed"
end

一時ディレクトリを削除する。

rm -rf \
    "$STAGE"

12. 非ポータブル構成を維持する

AviUtl2 本体フォルダ内に data フォルダを作成しない。

rm -rf \
    "$AVIUTL2_TARGET/data"

これにより、設定、プラグイン、スクリプト、フォントは次へ保存される。

C:\ProgramData\aviutl2

Linux 側:

$PREFIX/drive_c/ProgramData/aviutl2

この構成では、AviUtl2 本体ZIPを更新しても ProgramData\aviutl2 のプラグイン類は原則として維持される。

13. DXVK 2.7.1 パッチ

13.1 ソース取得

set DXVK_SRC \
    "$ROOT/src/dxvk-2.7.1-aviutl2"

set DXVK_OUT \
    "$ROOT/runtime/dxvk-2.7.1-aviutl2"

if not test -d "$DXVK_SRC/.git"
    git clone \
        --branch v2.7.1 \
        --depth 1 \
        https://github.com/doitsujin/dxvk.git \
        "$DXVK_SRC"
end

13.2 パッチ適用

git -C "$DXVK_SRC" apply \
    --check \
    "$REPO/patches/dxvk/0001-aviutl2-format-support.patch"

git -C "$DXVK_SRC" apply \
    "$REPO/patches/dxvk/0001-aviutl2-format-support.patch"

このパッチの回避処理は、次の条件をすべて満たす場合だけ有効になる。

実行ファイル名:
aviutl2.exe

DXGI format:
DXGI_FORMAT_G8R8_G8B8_UNORM

Vulkan mapping:
VK_FORMAT_UNDEFINED

他アプリや、有効な Vulkan マッピングが存在する環境では通常処理を維持する。

13.3 ビルド

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

13.4 prefix へ導入

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
            "$SYSTEM32/$dll.backup-$TS"
    end

    cp \
        "$DXVK_OUT/bin/$dll" \
        "$SYSTEM32/$dll"
end

14. Wine DirectWrite パッチ

14.1 ソースとビルドツリー

set WINE_SRC \
    "$ROOT/src/wine-ge11-1-dwrite"

set WINE_BUILD \
    "$ROOT/build/wine-ge11-1-dwrite"

GE-Proton 11-1 に対応する Wine ソースを用意する。

14.2 パッチ適用

cd \
    "$WINE_SRC"

patch -p1 < \
    "$REPO/patches/wine/0001-implement-dwrite-hit-testing.patch"

追加の HitTestPoint() 安定化パッチが存在する場合は、番号順に適用する。

for patch_file in \
    "$REPO"/patches/wine/0002-*.patch

    if test -f "$patch_file"
        patch -p1 < \
            "$patch_file"
    end
end

14.3 DWrite の再ビルド

make dlls/dwrite は使用しない。

make -B も使用しない。

rm -f \
    "$WINE_BUILD/dlls/dwrite/x86_64-windows/layout.o" \
    "$WINE_BUILD/dlls/dwrite/x86_64-windows/dwrite.dll"

make -C "$WINE_BUILD" \
    -j(nproc) \
    dlls/dwrite/x86_64-windows/dwrite.dll

14.4 パッチ済み GE-Proton へ導入

"$REPO/scripts/install-dwrite.fish" \
    "$WINE_BUILD" \
    "$GE_TEST"

15. L-SMASH Works NVDEC パッチ

15.1 ソース取得

set LSW_SRC \
    "$ROOT/src/L-SMASH-Works-nvdec"

if not test -d "$LSW_SRC/.git"
    git clone \
        https://github.com/Mr-Ojii/L-SMASH-Works.git \
        "$LSW_SRC"
end

git -C "$LSW_SRC" checkout \
    a47764915f06fcd472e26ba2fbf25aff4b9d252e

15.2 パッチ適用

git -C "$LSW_SRC" am \
    "$REPO/patches/l-smash-works/0001-transfer-hardware-frames-before-output.patch"

15.3 ビルド

検証時は、x86_64-w64-mingw32 用に静的ビルドした FFmpeg、L-SMASH、dav1d、libvpx、libvpl などを専用 prefix へ用意した。

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

AviUtl2 input plugin をビルドする。

cd \
    "$LSW_SRC/AviUtl2"

make distclean \
    2>/dev/null

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

15.4 プラグインを配置

set PLUGIN_DIR \
    "$PREFIX/drive_c/ProgramData/aviutl2/Plugin"

mkdir -p \
    "$PLUGIN_DIR"

生成された lwinput.aui2 を検索する。

set LWINPUT (find \
    "$LSW_SRC" \
    -type f \
    -name lwinput.aui2 \
    | head -n 1)

if test -z "$LWINPUT"
    echo "ERROR: lwinput.aui2 was not found"
else
    cp \
        "$LWINPUT" \
        "$PLUGIN_DIR/lwinput.aui2"
end

NVDEC 用設定を配置する。

cp \
    "$REPO/config/lsmash.ini" \
    "$PLUGIN_DIR/lsmash.ini"

期待する主な設定:

libavsmash_disabled=1
libav_disabled=0
preferred_decoders=av1_cuvid

16. DLL override と起動

set WINEDLLOVERRIDES_VALUE \
    "nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b"

AviUtl2 を起動する。

env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES="$WINEDLLOVERRIDES_VALUE" \
    DXVK_CONFIG_FILE="$REPO/config/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG=-all \
    "$GE_WINE" \
    "$AVIUTL2_TARGET/aviutl2.exe"

リポジトリのサンプルランチャーを環境に合わせて編集して使用してもよい。

scripts/launch-aviutl2.example.fish

17. Lutris へ登録

Lutris の Wine Runner に環境選択を任せず、Linux Runner から固定した起動ラッパーを呼び出す。

Lutris
└── Linux Runner
    └── 起動ラッパー
        ├── GE-Proton11-1-aviutl2-test
        ├── prefix-ge-nvdec-test
        ├── patched DXVK
        ├── patched DWrite
        └── patched L-SMASH Works

これにより、Lutris や UMU が Wine、Proton、DXVK を自動更新・自動変更して検証済み環境から外れることを防ぐ。

18. AviUtl2 Catalog

Catalog は同じ prefix へ導入する。

AviUtl2 の場所:

C:\AviUtl2

ポータブルモード:

無効

非ポータブルモードでは、プラグインや設定は次に保存される。

C:\ProgramData\aviutl2

L-SMASH Works 更新時の注意

Catalog から L-SMASH Works を更新すると、パッチ済み lwinput.aui2 が公式版で上書きされる可能性がある。

その場合は次を再実行する。

cp \
    "$LWINPUT" \
    "$PLUGIN_DIR/lwinput.aui2"

cp \
    "$REPO/config/lsmash.ini" \
    "$PLUGIN_DIR/lsmash.ini"

可能な場合は、Catalog 側で L-SMASH Works を更新対象外または一時停止にする。

19. 動作確認

19.1 AviUtl2 が起動する

test -f \
    "$AVIUTL2_TARGET/aviutl2.exe"

and echo \
    "OK: AviUtl2 executable exists"

19.2 DXVK が読み込まれる

DXVK ログを有効にする。

mkdir -p \
    "$ROOT/logs/dxvk"

env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES="$WINEDLLOVERRIDES_VALUE" \
    DXVK_CONFIG_FILE="$REPO/config/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=info \
    DXVK_LOG_PATH="$ROOT/logs/dxvk" \
    WINEDEBUG=-all \
    "$GE_WINE" \
    "$AVIUTL2_TARGET/aviutl2.exe"

19.3 AV1 / NVDEC

AV1 ファイルを読み込める

再生できる

シークできる

av1_cuvid が選択される

lwinput.aui2 がパッチ済み版である

19.4 テキスト編集

テキストオブジェクトを追加できる

選択範囲を描画できる

編集状態へ入れる

Fcitx5 / Mozc で入力できる

変換候補を選択できる

文字列を確定できる

HitTestTextRange() または HitTestPoint() の E_NOTIMPL で停止しない

20. AviUtl2 本体の更新

新しい AviUtl2 ZIP へ更新するときは、最初にバージョンだけ変更する。

set AVIUTL2_VERSION "新しいバージョン"

次に、以下を再実行する。

8. ZIPをcurlで取得
9. ZIPを検証
10. 一時ディレクトリへ展開
11. C:\AviUtl2へ配置

C:\ProgramData\aviutl2 は本体フォルダとは別なので、非ポータブル構成であればプラグインや設定を維持できる。

ただし更新前には、次をバックアップすることを推奨する。

set TS \
    (date +%Y%m%d-%H%M%S)

cp -a \
    "$PREFIX/drive_c/ProgramData/aviutl2" \
    "$ROOT/backup-ProgramData-aviutl2-$TS"

21. ロールバック

AviUtl2 本体

find \
    "$PREFIX/drive_c" \
    -maxdepth 1 \
    -type d \
    -name "AviUtl2.before-zip-install-*"

使用するバックアップを確認したうえで、現在の本体と入れ替える。

DXVK

system32 内のタイムスタンプ付きバックアップを戻す。

DWrite

install-dwrite.fish が作成したバックアップを戻す。

L-SMASH Works

パッチ済み lwinput.aui2 と lsmash.ini を再配置する。

22. 完了条件

次の条件を満たした時点で再現完了とする。

setup.exe を使用せず、公式 ZIP から AviUtl2 を配置できた

AviUtl2 が起動する

DXVK format 69 問題を通過する

AV1 を読み込める

AV1 を再生できる

シークできる

NVDEC を利用できる

テキスト編集状態へ入れる

Fcitx5 / Mozc で入力・変換・確定できる

AviUtl2 Catalog を同じ prefix で利用できる

Catalog 更新後にパッチ済み L-SMASH Works を復旧できる

23. 参照先

AviUtl2 Linux patcheshttps://github.com/AlexanderGG-0520/aviutl2-linux-patches

AviUtl 公式配布ページhttps://spring-fragrance.mints.ne.jp/aviutl/

AviUtl2 ドキュメントhttps://docs.aviutl2.jp/
