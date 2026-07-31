# AviUtl2 on Linux — Reproduction Guide

最終更新日: 2026-07-31

この文書は、CachyOS上で実際に動作したAviUtl2環境を、別のArch Linux系環境へ再現するための手順である。

## 重要な結論

2026-07-31時点で、最も確実な再現方法は次のとおりである。

1. 動作済み環境から、実際に使用しているパッチ済みバイナリをハッシュ付きで書き出す
2. 対象環境へそのバイナリを移す
3. 対象環境では新しいWine prefixを作る
4. AviUtl2本体は公式ZIPから直接配置する
5. 動作済みのDXVK、GE-Proton、DWrite、L-SMASH Worksを導入する
6. 最後に固定ラッパーから起動する
7. LutrisはLinux Runnerから固定ラッパーを呼ぶだけにする

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
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

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

```fish
scripts/manage-aviutl2-catalog-lutris.sh lutris-install
```

Catalogでは次の構成を使用する。

```text
AviUtl2 installation:
  Installed

Install root:
  C:\AviUtl2

Portable mode:
  Disabled
```

Catalog更新後は、独自の`lwinput.aui2`が上書きまたは削除される可能性がある。

更新後に必ず確認する。

```fish
set PLUGIN_DIR \
    "$PREFIX/drive_c/ProgramData/aviutl2/Plugin"

sha256sum \
    "$IMPORT/plugin/lwinput.aui2" \
    "$PLUGIN_DIR/lwinput.aui2"
```

異なる場合は復旧する。

```fish
set TS \
    (date +%Y%m%d-%H%M%S)

if test -f "$PLUGIN_DIR/lwinput.aui2"
    cp -a \
        "$PLUGIN_DIR/lwinput.aui2" \
        "$PLUGIN_DIR/lwinput.aui2.catalog-$TS"
end

cp -a \
    "$IMPORT/plugin/lwinput.aui2" \
    "$PLUGIN_DIR/lwinput.aui2"

cp -a \
    "$IMPORT/plugin/lsmash.ini" \
    "$PLUGIN_DIR/lsmash.ini"
```

---

# 19. 独立したDXVKソース再ビルド

この章は、動作済みDLLの移植とは別の検証経路である。

移植経路の検証中に、このビルド成果物を混ぜてはならない。

## 19.1 現在の位置づけ

元環境で実際に動いたDXVKソースは、次の状態だった。

```text
base:
  c3dd74be6baec53786d4e064a572185b70347a17
  v2.7.1

local diff:
  src/d3d11/d3d11_device.cpp
  36 insertions
  3 deletions
```

現在リポジトリに保存されているパッチは、問題を狭い条件へ限定するために整理された実装である。

そのため、現在のパッチから生成したDLLは、元環境のDLLと同じSHA-256にはならない可能性がある。

ソースからビルドできたことと、元環境と同じ動作を再現できたことを混同してはならない。

## 19.2 クリーンソースを取得

```fish
set DXVK_SRC \
    "$ROOT/src/dxvk-2.7.1-aviutl2"

set DXVK_OUT \
    "$ROOT/runtime/dxvk-2.7.1-aviutl2"

rm -rf \
    "$DXVK_SRC" \
    "$DXVK_OUT"

git clone \
    --branch v2.7.1 \
    --depth 1 \
    --recurse-submodules \
    https://github.com/doitsujin/dxvk.git \
    "$DXVK_SRC"
```

サブモジュールを再確認する。

```fish
git -C "$DXVK_SRC" \
    submodule update \
    --init \
    --recursive
```

基準コミットを確認する。

```fish
git -C "$DXVK_SRC" rev-parse HEAD
git -C "$DXVK_SRC" describe --tags --always
git -C "$DXVK_SRC" status --short
```

期待値:

```text
c3dd74be6baec53786d4e064a572185b70347a17
v2.7.1
```

## 19.3 Vulkan-Headersサブモジュールを確認

DXVKはVulkan-Headersを次へ持っている。

```text
include/vulkan
```

確認する。

```fish
git -C "$DXVK_SRC" \
    submodule status \
    include/vulkan

test -f \
    "$DXVK_SRC/include/vulkan/include/vulkan/vulkan.h"

echo $status
```

最後の出力が`0`である必要がある。

次が存在しない状態でMesonを実行してはならない。

```text
$DXVK_SRC/include/vulkan/include/vulkan/vulkan.h
```

ホスト側の`/usr/include/vulkan/vulkan.h`だけが存在していても、DXVK submodule不足の代替にはならない。

## 19.4 DXVKパッチを適用

```fish
set DXVK_PATCH \
    "$REPO/patches/dxvk/0001-aviutl2-format-support.patch"
```

適用可能か確認する。

```fish
git -C "$DXVK_SRC" \
    apply \
    --check \
    "$DXVK_PATCH"
```

成功した場合のみ適用する。

```fish
git -C "$DXVK_SRC" \
    apply \
    "$DXVK_PATCH"
```

適用後を確認する。

```fish
git -C "$DXVK_SRC" diff --check
git -C "$DXVK_SRC" diff --stat
git -C "$DXVK_SRC" diff -- src/d3d11/d3d11_device.cpp
```

パッチ済みコードを確認する。

```fish
grep -RFn \
    --exclude-dir=.git \
    'AviUtl2 compatibility' \
    "$DXVK_SRC/src/d3d11"
```

パッチの`--check`に失敗した場合はビルドへ進まない。

## 19.5 DXVKをビルド

```fish
rm -rf \
    "$DXVK_SRC/build.w64" \
    "$DXVK_OUT"

meson setup \
    "$DXVK_SRC/build.w64" \
    "$DXVK_SRC" \
    --cross-file "$DXVK_SRC/build-win64.txt" \
    --buildtype release \
    --prefix "$DXVK_OUT"
```

`meson setup`が成功した場合のみ続行する。

```fish
meson compile \
    -C "$DXVK_SRC/build.w64" \
    -j (nproc)

and meson install \
    -C "$DXVK_SRC/build.w64"
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

パッチ文字列を確認する。

```fish
strings "$DXVK_OUT/bin/d3d11.dll" \
    | grep -E \
        'AviUtl2 compatibility|AviUtl2 trace'
```

## 19.6 独立prefixで検証する

既に動作しているprefixへ直接上書きしてはならない。

```fish
set SOURCE_TEST_PREFIX \
    "$ROOT/prefix-dxvk-source-test"
```

新しいprefixを作成し、同じAviUtl2 ZIPを配置したうえで、ビルドしたDLLを導入する。

このテストが完了するまでは、ソースビルド版を既知の正常環境へ混ぜない。

---

# 20. Wine DWriteソース再ビルド

この章も、動作済みGE-Protonの移植とは別の検証経路である。

## 20.1 注意事項

動作済み環境には、最終的にビルドされたDWriteが既に含まれている。

現在のリポジトリにあるWineパッチが、元環境へ最後に導入されたDWrite実装と完全に同一であることはまだ証明されていない。

したがって、ソース再ビルド版は別のGE-Protonコピーで検証する。

## 20.2 GE-Protonソースを取得

```fish
set PROTON_GE_SRC \
    "$ROOT/src/proton-ge-custom-GE-Proton11-1"

rm -rf "$PROTON_GE_SRC"

git clone \
    --filter=blob:none \
    --branch GE-Proton11-1 \
    --depth 1 \
    --recurse-submodules \
    https://github.com/GloriousEggroll/proton-ge-custom.git \
    "$PROTON_GE_SRC"
```

サブモジュールを取得する。

```fish
git -C "$PROTON_GE_SRC" \
    submodule update \
    --init \
    --recursive
```

GE-Protonタグを確認する。

```fish
git -C "$PROTON_GE_SRC" \
    log -1 \
    --oneline
```

確認時の先頭コミット:

```text
fd07a03 GE-Proton11-1 Released
```

Wineソースを設定する。

```fish
set WINE_SRC \
    "$PROTON_GE_SRC/wine"

set WINE_BUILD \
    "$ROOT/build/wine-ge11-1-dwrite-source-test"
```

Wineコミットを確認する。

```fish
git -C "$WINE_SRC" rev-parse HEAD
```

期待値:

```text
31af7f983b2e345d11340b120ae3a39d88c9338a
```

## 20.3 DWriteパッチを適用

```fish
set DWRITE_PATCH \
    "$REPO/patches/wine/0001-implement-dwrite-hit-testing.patch"
```

適用可能か確認する。

```fish
git -C "$WINE_SRC" \
    apply \
    --check \
    "$DWRITE_PATCH"
```

成功した場合のみ適用する。

```fish
git -C "$WINE_SRC" \
    apply \
    "$DWRITE_PATCH"
```

確認する。

```fish
git -C "$WINE_SRC" diff --check
git -C "$WINE_SRC" diff --stat
git -C "$WINE_SRC" diff -- dlls/dwrite/layout.c
```

## 20.4 Wineビルドツリーを作成

```fish
cd "$WINE_SRC"

./autogen.sh
```

```fish
rm -rf "$WINE_BUILD"
mkdir -p "$WINE_BUILD"

cd "$WINE_BUILD"

"$WINE_SRC/configure" \
    --enable-archs=x86_64
```

configureが失敗した場合は、生成済みの古いMakefileを使ってビルドを続行しない。

## 20.5 DWriteを対象指定でビルド

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

DWrite DLLをビルドする。

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

file "$DWRITE_DLL"
sha256sum "$DWRITE_DLL"
```

## 20.6 独立したGE-Protonコピーへ導入

既知の正常な`GE-Proton11-1-aviutl2-test`へ直接上書きしてはならない。

```fish
set GE_SOURCE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-source-test"

rm -rf "$GE_SOURCE_TEST"

cp -a \
    "$GE_TEST" \
    "$GE_SOURCE_TEST"
```

リポジトリのスクリプトを使う。

```fish
"$REPO/scripts/install-dwrite.fish" \
    "$WINE_BUILD" \
    "$GE_SOURCE_TEST"
```

このGE-Protonコピーと別prefixを使ってテキスト選択・編集を検証する。

---

# 21. L-SMASH Worksソース再ビルド

## 21.1 現在の制限

L-SMASH Works本体の基準コミットとパッチコミットは固定されている。

```text
base:
  a47764915f06fcd472e26ba2fbf25aff4b9d252e

patched:
  393df5ef669707f776261e4ac1bcc7e9a9a227ab
```

ただし、そのビルドに使用した以下の依存関係について、すべてのGitコミットはまだ固定されていない。

```text
FFmpeg 8.1
zlib
dav1d
libvpx
game-music-emu
libvpl
nv-codec-headers
obuparse
l-smash
```

したがって、依存prefixを一から作る経路は、現時点では完全な決定的再現ではない。

## 21.2 L-SMASH Worksソースを取得

```fish
set LSW_SRC \
    "$ROOT/src/L-SMASH-Works-nvdec"

rm -rf "$LSW_SRC"

git clone \
    https://github.com/Mr-Ojii/L-SMASH-Works.git \
    "$LSW_SRC"

git -C "$LSW_SRC" checkout \
    a47764915f06fcd472e26ba2fbf25aff4b9d252e
```

## 21.3 パッチを適用

```fish
git -C "$LSW_SRC" am \
    "$REPO/patches/l-smash-works/0001-transfer-hardware-frames-before-output.patch"
```

確認する。

```fish
git -C "$LSW_SRC" rev-parse HEAD
git -C "$LSW_SRC" status --short
```

期待値:

```text
393df5ef669707f776261e4ac1bcc7e9a9a227ab
```

## 21.4 既に依存prefixがある場合のビルド

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

必要ライブラリを確認する。

```fish
for library in \
    libavcodec.a \
    libavformat.a \
    libavutil.a \
    libswscale.a \
    libswresample.a \
    liblsmash.a \
    libobuparse.a

    if test -f "$CROSS_PREFIX/lib/$library"
        echo "OK: $CROSS_PREFIX/lib/$library"
    else
        echo "MISSING: $CROSS_PREFIX/lib/$library"
    end
end
```

1つでも`MISSING`が出る場合はビルドへ進まない。

AviUtl2 input pluginをビルドする。

```fish
cd "$LSW_SRC/AviUtl2"

make distclean \
    2>/dev/null

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
```

configureが成功した場合のみビルドする。

```fish
make \
    -j(nproc) \
    input
```

生成物:

```text
$LSW_SRC/AviUtl2/lwinput.aui2
```

確認する。

```fish
file "$LSW_SRC/AviUtl2/lwinput.aui2"

strings -a "$LSW_SRC/AviUtl2/lwinput.aui2" \
    | grep -E \
        'av1_cuvid|av_hwframe_transfer_data|L-SMASH Works File Reader'
```

この成果物も、既知の正常prefixへ直接上書きせず、別prefixで検証する。

---

# 22. 失敗時の切り分け

## 22.1 format 69で停止する

症状:

```text
device->CheckFormatSupport() failed.
HRESULT: 0x80004005
```

確認する。

```fish
strings "$PREFIX/drive_c/windows/system32/d3d11.dll" \
    | grep -E \
        'AviUtl2 compatibility|AviUtl2 trace'
```

何も出なければ、パッチ済み`d3d11.dll`が導入されていない可能性が高い。

また、`WINEDLLOVERRIDES`に次が必要である。

```text
d3d11,dxgi,d3d10core=n,b
```

## 22.2 format 69通過後にページフォルトする

システムWineで起動していないか確認する。

使用すべきバイナリ:

```text
~/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test/files/lib/wine/x86_64-unix/wine
```

使用してはならない例:

```text
/usr/bin/wine
wine
Lutrisが自動選択したWine
```

## 22.3 `HitTestTextRange()`または`HitTestPoint()`で停止する

確認する。

```fish
sha256sum \
    "$GE_TEST/files/lib/wine/x86_64-windows/dwrite.dll"
```

エクスポート元の`SHA256SUMS`と一致する必要がある。

また、overrideに次が必要である。

```text
dwrite=b
```

## 22.4 AV1が読めない

確認する。

```fish
grep -E \
    'libavsmash_disabled|libav_disabled|preferred_decoders' \
    "$PREFIX/drive_c/ProgramData/aviutl2/Plugin/lsmash.ini"
```

必要値:

```ini
libavsmash_disabled=1
libav_disabled=0
preferred_decoders=av1_cuvid
```

さらに、`lwinput.aui2`がエクスポート元と同じSHA-256であることを確認する。

## 22.5 NVIDIAが隠される

確認する。

```fish
cat "$ROOT/nvidia-dxvk.conf"
```

必要値:

```ini
dxgi.hideNvidiaGpu = False
```

起動時に次を渡す。

```text
DXVK_CONFIG_FILE=~/Games/aviutl2/nvidia-dxvk.conf
```

NVIDIA DLL override:

```text
nvcuda,nvcuvid,nvencodeapi64=n
```

## 22.6 Lutrisからだけ失敗する

LutrisのRunnerが`Wine`になっていないか確認する。

正しいRunner:

```text
Linux
```

Lutrisからターミナルと同じラッパーを直接呼び出す。

---

# 23. 最終確認チェックリスト

## バイナリ

- [ ] パッチ済みGE-Protonの内部ハッシュ検証が成功した
- [ ] `d3d11.dll`がエクスポート元と一致した
- [ ] `dxgi.dll`がエクスポート元と一致した
- [ ] `d3d10core.dll`がエクスポート元と一致した
- [ ] `lwinput.aui2`がエクスポート元と一致した
- [ ] `lsmash.ini`がエクスポート元と一致した
- [ ] `nvidia-dxvk.conf`がエクスポート元と一致した

## 起動経路

- [ ] GE-Proton内のWineを直接使用している
- [ ] prefixが`prefix-ge-nvdec-test`である
- [ ] システムWineを使用していない
- [ ] `LD_LIBRARY_PATH`がGE-Protonへ固定されている
- [ ] `WINEDLLOVERRIDES`が固定されている
- [ ] LutrisはLinux Runnerである
- [ ] Lutris側のWine/DXVK管理を使用していない

## AviUtl2

- [ ] 公式ZIPから直接配置した
- [ ] `C:\AviUtl2\aviutl2.exe`が存在する
- [ ] ポータブル用`data`ディレクトリを使用していない
- [ ] メインウィンドウが起動する
- [ ] 正常終了できる

## テキスト

- [ ] テキストを作成できる
- [ ] テキストを選択できる
- [ ] 編集状態へ入れる
- [ ] カーソルを移動できる
- [ ] Mozcで入力・変換・確定できる

## 動画

- [ ] AV1を読み込める
- [ ] 再生できる
- [ ] 一時停止できる
- [ ] シークできる
- [ ] 複数回シークしてもクラッシュしない
- [ ] `av1_cuvid`が選択される

## Catalog

- [ ] Catalogを同じprefixで起動できる
- [ ] インストール先が`C:\AviUtl2`である
- [ ] ポータブルモードが無効である
- [ ] 更新後もパッチ済み`lwinput.aui2`が維持されている

---

# 24. 再現成功の判定

次のすべてを満たして、初めて再現成功と扱う。

```text
AviUtl2起動
+
正常終了
+
テキスト選択
+
テキスト編集
+
Mozc入力・変換・確定
+
AV1読み込み
+
AV1再生
+
シーク
+
NVDEC
```

次だけでは再現成功と扱わない。

```text
パッチが適用できた
ビルドが通った
DLLが生成された
メインウィンドウが一度だけ表示された
IMEを無効にすると動いた
AV1を読み込まずに起動できた
```

---

# 25. 現段階の正式な扱い

2026-07-31時点の正式な判定は次のとおりである。

```text
元のCachyOS環境:
  実用動作確認済み

動作済みバイナリのエクスポート:
  手順確立

別環境へのバイナリ移植:
  検証対象

DXVKのクリーンソース再ビルド:
  recursive submodule取得を含む修正版手順
  最終動作確認待ち

Wine DWriteのクリーンソース再ビルド:
  元の最終DLLとの一致未確認

L-SMASH Works依存関係の完全再ビルド:
  依存コミット固定未完了

別環境での完全な最終再現:
  未確認
```

未確認の工程を、確認済みとして記録してはならない。
