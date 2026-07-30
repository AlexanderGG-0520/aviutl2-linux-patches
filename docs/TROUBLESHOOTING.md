# Troubleshooting

最終更新日: 2026-07-31

## `git apply`: patch does not apply

例:

```text
error: patch failed: src/d3d11/d3d11_device.cpp:30
error: src/d3d11/d3d11_device.cpp: patch does not apply
```

これは Wine prefix、`GE_WINE`、`GE_WINESERVER` の設定エラーではない。
DXVK パッチ適用コマンドが参照するのは、主に次の2つだけである。

```text
DXVK_SRC
REPO/patches/dxvk/0001-aviutl2-format-support.patch
```

確認:

```fish
set DXVK_PATCH \
    "$REPO/patches/dxvk/0001-aviutl2-format-support.patch"

git -C "$DXVK_SRC" apply \
    --reverse \
    --check \
    "$DXVK_PATCH"

echo "reverse status: $status"

git -C "$DXVK_SRC" describe \
    --tags \
    --always \
    --dirty

git -C "$DXVK_SRC" rev-parse HEAD
git -C "$DXVK_SRC" status --short
```

判定:

- reverse check が成功: すでに適用済み
- `v2.7.1` ではない: ソース基準が違う
- dirty: 既存変更がパッチ文脈と衝突している可能性
- clean `v2.7.1` でも失敗: 配布パッチ自体の再生成・再検証が必要

`--reject` で強制適用した状態を再現成功と扱わない。

## `Missing Vulkan-Headers`

例:

```text
Check usable header "vulkan/vulkan.h" : NO
ERROR: Missing Vulkan-Headers
```

これは DXVK の C++ コンパイルエラーではない。
Meson configure 中に、MinGW クロスコンパイラから Vulkan ヘッダーが見つからない状態である。

検査:

```fish
printf '#include <vulkan/vulkan.h>\nint main(void){return 0;}\n' \
    | x86_64-w64-mingw32-gcc \
        -x c \
        -E - \
        >/dev/null

echo "status: $status"
```

ホスト側の Vulkan ランタイムや `/usr/include/vulkan` が存在しても、クロスコンパイラの探索パスに含まれるとは限らない。

2026-07-31 時点では、別環境で使用する Vulkan-Headers の導入方法はまだ最終確認できていない。
確認前のパッケージ名や include path を標準手順として断定しない。

## Meson setup 失敗後の二次エラー

```text
Current directory is not a meson build directory
Install data not found
```

原因は、その前の `meson setup` が失敗したこと。
`meson compile` と `meson install` を個別に修正しても解決しない。

再試行時:

```fish
rm -rf "$DXVK_SRC/build.w64"
```

その後、Vulkan-Headers 問題を解決してから `meson setup` をやり直す。

## GE-Proton の Wine バイナリが見つからない

正本:

```text
$GE_TEST/files/lib/wine/x86_64-unix/wine
$GE_TEST/files/bin/wineserver
```

確認:

```fish
printf 'GE_TEST=%s\n' "$GE_TEST"
printf 'GE_WINE=%s\n' "$GE_WINE"
printf 'GE_WINESERVER=%s\n' "$GE_WINESERVER"

test -x "$GE_WINE"
and echo "OK: wine"

test -x "$GE_WINESERVER"
and echo "OK: wineserver"
```

`set` はパスが存在しなくても文字列を代入できる。
したがって、`set` が成功したことはファイルの存在確認にならない。

## Wine が共有ライブラリを読み込めない

元環境の値:

```fish
set GE_LIBS \
    "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"
```

確認:

```fish
env \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" \
    --version
```

ディレクトリ構成が異なる GE-Proton では、そのまま使用できない。
GE-Proton 11-1 の実ファイルを確認してから変更する。

## DWrite patch の hunk が失敗する

例:

```text
Hunk #1 FAILED
Hunk #2 FAILED
saving rejects to file dlls/dwrite/layout.c.rej
```

原因:

- Wine ソースコミットが違う
- すでに手動変更がある
- パッチが別の `layout.c` を基準にしている
- 古いパッチ版を使用している

必ず dry-run を行う。

```fish
patch \
    --directory="$WINE_SRC" \
    --strip=1 \
    --dry-run \
    < "$DWRITE_PATCH"
```

失敗した状態で本適用しない。
`.rej` ができた状態をそのままビルドしない。

## `make dlls/dwrite` が何もしない

`dlls/dwrite` は実在するディレクトリでもあるため、Make が完了済みターゲットとして扱う場合がある。

使用するターゲット:

```fish
rm -f \
    "$WINE_BUILD/dlls/dwrite/x86_64-windows/layout.o" \
    "$WINE_BUILD/dlls/dwrite/x86_64-windows/dwrite.dll"

make -C "$WINE_BUILD" \
    -j(nproc) \
    dlls/dwrite/x86_64-windows/dwrite.dll
```

## `make -B` で無関係な場所が失敗する

`make -B` は Wine 全体の configure や依存関係まで強制的に再実行する。
DWrite の修正確認には使用しない。

## AviUtl2 の setup で ZIP エラー

```text
zipFile->BindToHandler() failed
HRESULT: 0x80070002
Place: System::Zip::openFile()
```

Wine 上の `setup.exe` を使用しない。
公式 ZIP を Linux 側で `curl` と `bsdtar` により展開し、`C:\AviUtl2` へ直接配置する。

## Catalog 更新後に AV1 / NVDEC が壊れた

Catalog がカスタム `lwinput.aui2` を公式版で上書きした可能性が高い。

復旧:

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

その後、AV1 の読み込み、再生、シーク、`av1_cuvid` を再確認する。

## テキスト編集でクラッシュする

IME を疑う前に DWrite ログを確認する。

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

元環境では、根本原因は Fcitx5/Mozc ではなく Wine DirectWrite の未実装だった。
