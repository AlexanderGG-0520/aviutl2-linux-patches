# AviUtl2 on Linux — 最初に成功した構築手順

最終整理日: 2026-08-01

この文書は、2026-07-30から2026-07-31にかけて実際に成功したAviUtl2環境の構築経路を、そのとき実行された操作順に沿って記録する。

## 0. この文書が記録するもの

この成功経路は、完全なクリーン環境から全コンポーネントを一括構築したものではない。

実際の経路は次のとおりだった。

1. 通常Wineで既にAviUtl2が配置されていた`prefix`を基準にする
2. GE-Proton 11-1の内部Wineで新しい`prefix-ge`を作成する
3. 既存`prefix`からAviUtl2、Catalog管理下のProgramData、既存DLLを`prefix-ge`へ移す
4. AviUtl2用に修正したDXVKの`d3d11.dll`を導入する
5. 動作した`prefix-ge`を`prefix-ge-nvdec-test`へ丸ごと複製する
6. L-SMASH WorksとFFmpegのAV1 CUVID/NVDEC対応を導入する
7. GE-Proton本体も別名へ複製し、Wine DirectWrite修正版を導入する
8. 同じprefixへAviUtl2 Catalogを導入する
9. Catalogが公式L-SMASH Worksで上書きした場合は、custom `lwinput.aui2`を最後に戻す
10. 固定したWine、prefix、DLL override、DXVK設定で起動する

したがって、この文書の正本は「既存の動作状態を保持しながら、一段階ずつ置き換えて成功した経路」である。

次のものは正本の主経路ではない。

- 空ディレクトリだけを作成してprefixとして扱う
- `default_pfx`や依存DLLを推測して独自に組み立てる
- 未検証の全環境export/importを主経路にする
- Nanashi環境で失敗した操作を確認済み操作として混ぜる
- source buildが通っただけでAviUtl2の再現成功とする
- Catalogの設定・DB・hash-cacheを手作業で再生成する

---

## 1. 確認済みの最終結果

元のCachyOS環境では次を確認した。

- AviUtl2 2.1.2のメインウィンドウ起動
- DXVKのD3D11 format 69回避
- AV1ファイルの読み込み
- AV1再生
- シーク
- `av1_cuvid`
- NVIDIA NVDEC hardware frame transfer
- テキスト選択
- テキスト編集状態への移行
- Fcitx5/Mozcによる入力・変換・確定
- AviUtl2 Catalog
- Catalog更新後のcustom L-SMASH Works復旧

確認済み構成:

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
| 基準prefix | `~/Games/aviutl2/prefix` |
| GE prefix | `~/Games/aviutl2/prefix-ge` |
| NVDEC/test prefix | `~/Games/aviutl2/prefix-ge-nvdec-test` |
| 通常GE-Proton | `~/.local/share/Steam/compatibilitytools.d/GE-Proton11-1` |
| patched GE-Proton | `~/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test` |
| DXVK base | `c3dd74be6baec53786d4e064a572185b70347a17` |
| Wine source base | `31af7f983b2e345d11340b120ae3a39d88c9338a` |
| L-SMASH Works base | `a47764915f06fcd472e26ba2fbf25aff4b9d252e` |
| L-SMASH Works patched commit | `393df5ef669707f776261e4ac1bcc7e9a9a227ab` |

---

## 2. 最終状態の重要な識別値

最初の成功環境に残っている最終DXVK系DLLは次の組み合わせだった。

| ファイル | SHA-256 |
| --- | --- |
| `d3d11.dll` | `1c706356495405d2f929e7169f03964ea6d1af5d7e21f2de93fd9c0e82d25364` |
| `dxgi.dll` | `ec02eb37620ff52361cb45376a4611fc4210d96e71d0363f1cc9807f151c01be` |
| `d3d10core.dll` | `3bf5fec5115649dfb6fed1613a4c3f9487c2f2aaf74c2786d9f9d7d21a2f1482` |
| `d3dcompiler_47.dll` | `4432bbd1a390874f3f0a503d45cc48d346abc3a8c0213c289f4b615bf0ee84f3` |

`d3d11.dll`には次の文字列が含まれる。

```text
AviUtl2 compatibility: format 69 unsupported; returning S_OK
```

重要:

最初の成功時は、四つのDLLを最初から同一の新規DXVK buildで一括置換したわけではない。

- `dxgi.dll`
- `d3d10core.dll`
- `d3dcompiler_47.dll`

は既に動いていた基準prefixからGE prefixへコピーされた。

その後、AviUtl2 format 69修正版の`d3d11.dll`だけが更新された。

これは一般化された理想構成ではなく、実際に成功した履歴上の構成であるため、この文書では事実どおり記録する。

最初のcustom L-SMASH Works:

| 項目 | 値 |
| --- | --- |
| サイズ | `26945536` bytes |
| SHA-256 | `fce81e0257a6730ada0729ffddfdb51d1528f8b4bdfb61488a7d01b074ab0fc3` |
| 表示 | `L-SMASH Works File Reader for AviUtl2 r1284 by Mr-Ojii` |

2026-08-01に同じ固定ソースから再構築した機能同等版:

| 項目 | 値 |
| --- | --- |
| サイズ | `26945536` bytes |
| SHA-256 | `db465570a4c049624f369086232cf47c387975d54fa615d895d090fe1a17bbe0` |
| 表示 | `L-SMASH Works File Reader for AviUtl2 r1284 by Mr-Ojii` |

二つのSHAが異なる理由は、FFmpegのconfigure文字列に絶対build prefixが埋め込まれるためである。

---

## 3. 絶対に混ぜないもの

各段階では一つの要素だけを変更する。

同時に変更してはならない。

- GE-Proton
- Wine prefix
- DXVK
- Wine DirectWrite
- L-SMASH Works
- `lsmash.ini`
- DLL override
- 起動コマンド
- Catalog
- Lutris設定

最終起動では次を使用しない。

- system Wine
- Lutris Wine Runner
- UMU
- LutrisのDXVK自動管理
- 別バージョンのGE-Proton
- 別prefix

LutrisはLinux Runnerから固定wrapperを起動するためだけに使用する。

---

# Part A — 実際に成功した順序

## 4. 基本変数

Fishで実行する。

```fish
set ROOT \
    "$HOME/Games/aviutl2"

set BASE_PREFIX \
    "$ROOT/prefix"

set GE_PREFIX \
    "$ROOT/prefix-ge"

set NV_PREFIX \
    "$ROOT/prefix-ge-nvdec-test"

set GE_BASE \
    "$HOME/.local/share/Steam/compatibilitytools.d"

set GE_DIR \
    "$GE_BASE/GE-Proton11-1"

set GE_TEST \
    "$GE_BASE/GE-Proton11-1-aviutl2-test"

set GE_WINE \
    "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_DIR/files/bin/wineserver"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

set OVERRIDES \
    'nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'
```

必須の既存状態を確認する。

```fish
test -f \
    "$BASE_PREFIX/drive_c/AviUtl2/aviutl2.exe"

test -d \
    "$BASE_PREFIX/drive_c/ProgramData/aviutl2"

for file in \
    d3d11.dll \
    dxgi.dll \
    d3d10core.dll \
    d3dcompiler_47.dll

    test -f \
        "$BASE_PREFIX/drive_c/windows/system32/$file"
end
```

一つでも存在しない場合、この成功経路の前提を満たしていない。別の方法を推測して続行しない。

---

## 5. GE-Proton 11-1を配置

履歴上は公式release archiveを取得して展開した。

```fish
set GE_ARCHIVE \
    "/tmp/GE-Proton11-1.tar.gz"

if not test -x "$GE_WINE"
    mkdir -p \
        "$GE_BASE"

    curl \
        --fail \
        --location \
        --retry 3 \
        --output "$GE_ARCHIVE" \
        "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton11-1/GE-Proton11-1.tar.gz"

    and tar \
        -xzf "$GE_ARCHIVE" \
        -C "$GE_BASE"
end
```

確認する。

```fish
file \
    "$GE_WINE"

env \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" \
    --version
```

確認済み期待値:

```text
wine-staging 11.0
```

---

## 6. GE-Proton用prefixを作成

この工程は2026-07-30 21:33 JSTに実際に行われた。

基準prefixを使っているWineを停止する。

```fish
env \
    WINEPREFIX="$BASE_PREFIX" \
    wineserver -k \
    2>/dev/null

sleep 1
```

履歴上は既存の`prefix-ge`を削除して作り直した。

再実行時は、削除ではなく先に退避する。

```fish
if test -e "$GE_PREFIX"
    set STAMP \
        (date +%Y%m%d-%H%M%S)

    mv \
        "$GE_PREFIX" \
        "$GE_PREFIX.before-recreate-$STAMP"
end
```

GE-Proton内部Wineでprefixを作成する。

```fish
env \
    WINEPREFIX="$GE_PREFIX" \
    WINEARCH=win64 \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" \
    wineboot -u

env \
    WINEPREFIX="$GE_PREFIX" \
    "$GE_WINESERVER" \
    -w
```

必須構造を確認する。

```fish
for path in \
    "$GE_PREFIX/user.reg" \
    "$GE_PREFIX/system.reg" \
    "$GE_PREFIX/userdef.reg" \
    "$GE_PREFIX/drive_c/windows/system32"

    test -e "$path"
end
```

`user.reg`または`system.reg`がないディレクトリをprefixとして扱ってはならない。

---

## 7. 基準prefixからAviUtl2状態を移す

AviUtl2本体をコピーする。

```fish
rm -rf \
    "$GE_PREFIX/drive_c/AviUtl2"

cp -a \
    "$BASE_PREFIX/drive_c/AviUtl2" \
    "$GE_PREFIX/drive_c/AviUtl2"
```

Catalog管理下のProgramDataをコピーする。

```fish
mkdir -p \
    "$GE_PREFIX/drive_c/ProgramData"

rm -rf \
    "$GE_PREFIX/drive_c/ProgramData/aviutl2"

cp -a \
    "$BASE_PREFIX/drive_c/ProgramData/aviutl2" \
    "$GE_PREFIX/drive_c/ProgramData/aviutl2"
```

基準prefixの既存DLLを移す。

```fish
for dll in \
    d3d11 \
    dxgi \
    d3d10core \
    d3dcompiler_47

    set src \
        "$BASE_PREFIX/drive_c/windows/system32/$dll.dll"

    set dst \
        "$GE_PREFIX/drive_c/windows/system32/$dll.dll"

    if test -f "$src"
        install \
            -m 0644 \
            "$src" \
            "$dst"
    end
end
```

確認する。

```fish
sha256sum \
    "$GE_PREFIX/drive_c/windows/system32/d3d11.dll" \
    "$GE_PREFIX/drive_c/windows/system32/dxgi.dll" \
    "$GE_PREFIX/drive_c/windows/system32/d3d10core.dll" \
    "$GE_PREFIX/drive_c/windows/system32/d3dcompiler_47.dll"
```

---

## 8. AviUtl2 format 69修正版d3d11.dllを導入

実際のbuild sourceと出力先:

```fish
set DXVK_SRC \
    "$ROOT/src/dxvk-2.7.1-aviutl2"

set DXVK_OUT \
    "$ROOT/runtime/dxvk-2.7.1-aviutl2"
```

履歴に残っている成功build command:

```fish
meson compile \
    -C "$DXVK_SRC/build.w64" \
    -j (nproc)

and meson install \
    -C "$DXVK_SRC/build.w64"
```

出力を確認する。

```fish
set PATCHED_D3D11 \
    "$DXVK_OUT/bin/d3d11.dll"

test -f \
    "$PATCHED_D3D11"

strings \
    "$PATCHED_D3D11" \
    | grep -E \
        'AviUtl2 compatibility|AviUtl2 trace'
```

Wineを停止してから置換する。

```fish
env \
    WINEPREFIX="$GE_PREFIX" \
    "$GE_WINESERVER" \
    -k \
    2>/dev/null

sleep 1

set STAMP \
    (date +%Y%m%d-%H%M%S)

cp -a \
    "$GE_PREFIX/drive_c/windows/system32/d3d11.dll" \
    "$GE_PREFIX/drive_c/windows/system32/d3d11.dll.before-aviutl2-$STAMP"

install \
    -m 0644 \
    "$PATCHED_D3D11" \
    "$GE_PREFIX/drive_c/windows/system32/d3d11.dll"
```

コピー一致を確認する。

```fish
sha256sum \
    "$PATCHED_D3D11" \
    "$GE_PREFIX/drive_c/windows/system32/d3d11.dll"

cmp \
    --silent \
    "$PATCHED_D3D11" \
    "$GE_PREFIX/drive_c/windows/system32/d3d11.dll"

and echo \
    "OK: d3d11.dll matches"
```

最終成功snapshotでは、prefix内の`d3d11.dll`は次だった。

```text
1c706356495405d2f929e7169f03964ea6d1af5d7e21f2de93fd9c0e82d25364
```

---

## 9. `prefix-ge`でAviUtl2を直接起動

設定ファイル:

```fish
set DXVK_CONFIG_FILE \
    "$ROOT/nvidia-dxvk.conf"
```

内容:

```text
dxgi.hideNvidiaGpu = False
```

直接起動する。

```fish
env \
    WINEPREFIX="$GE_PREFIX" \
    "$GE_WINESERVER" \
    -k \
    2>/dev/null

sleep 1

cd \
    "$GE_PREFIX/drive_c/AviUtl2"

env \
    WINEPREFIX="$GE_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$DXVK_CONFIG_FILE" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG=-all \
    "$GE_WINE" \
    ./aviutl2.exe
```

この段階ではメインウィンドウが出ることを確認する。

---

## 10. 動作したGE prefixをNVDEC試験用に複製

これは2026-07-31 02:57 JSTに実際に行われた重要な工程である。

空prefixを作り直したのではない。動作した`prefix-ge`全体を複製した。

```fish
env \
    WINEPREFIX="$GE_PREFIX" \
    "$GE_WINESERVER" \
    -k \
    2>/dev/null

sleep 1
```

既存の対象がある場合は削除せず退避する。

```fish
if test -e "$NV_PREFIX"
    set STAMP \
        (date +%Y%m%d-%H%M%S)

    mv \
        "$NV_PREFIX" \
        "$NV_PREFIX.before-clone-$STAMP"
end
```

複製する。

```fish
cp -a \
    --reflink=auto \
    "$GE_PREFIX" \
    "$NV_PREFIX"
```

確認する。

```fish
for path in \
    "$NV_PREFIX/user.reg" \
    "$NV_PREFIX/system.reg" \
    "$NV_PREFIX/userdef.reg" \
    "$NV_PREFIX/drive_c/windows/system32" \
    "$NV_PREFIX/drive_c/AviUtl2/aviutl2.exe" \
    "$NV_PREFIX/drive_c/ProgramData/aviutl2"

    test -e "$path"
end
```

ここを`mkdir -p "$NV_PREFIX/drive_c/AviUtl2"`だけで代用してはならない。

---

## 11. NVIDIA DLL overrideを設定

履歴上は`nvcuda`と`nvcuvid`をnativeとして登録した。

```fish
for dll in \
    nvcuda \
    nvcuvid

    env \
        WINEPREFIX="$NV_PREFIX" \
        LD_LIBRARY_PATH="$GE_LIBS" \
        "$GE_WINE" \
        reg add \
        'HKEY_CURRENT_USER\Software\Wine\DllOverrides' \
        /v "$dll" \
        /d native \
        /f
end
```

最終起動では環境変数でも明示する。

```text
nvcuda,nvcuvid,nvencodeapi64=n
```

Wine prefixのSystem32へNVIDIA Linux driver本体をコピーする手順ではない。Wineのnative NVIDIA bridgeとホスト側driverを使用する。

---

## 12. custom L-SMASH Works r1284を導入

### 12.1 最初の成功時に使ったartifact

```fish
set LSMASH_BUILT \
    "$ROOT/src/L-SMASH-Works-nvdec/AviUtl2/lwinput.aui2"

set PLUGIN_DIR \
    "$NV_PREFIX/drive_c/ProgramData/aviutl2/Plugin"

set ACTIVE_LWINPUT \
    "$PLUGIN_DIR/lwinput.aui2"

set STAMP \
    (date +%Y%m%d-%H%M%S)

mkdir -p \
    "$PLUGIN_DIR"

cp -a \
    "$ACTIVE_LWINPUT" \
    "$ACTIVE_LWINPUT.before-hwframe-transfer-$STAMP"

cp -f \
    "$LSMASH_BUILT" \
    "$ACTIVE_LWINPUT"

sha256sum \
    "$LSMASH_BUILT" \
    "$ACTIVE_LWINPUT"
```

確認値:

```text
fce81e0257a6730ada0729ffddfdb51d1528f8b4bdfb61488a7d01b074ab0fc3
```

### 12.2 2026-08-01に再現確認したsource build

現在のリポジトリでは次を使用する。

```fish
cd \
    "$HOME/projects/aviutl2-linux-patches"

scripts/build-l-smash-works-nvdec.fish \
    --work-dir \
    "$ROOT/build/l-smash-works-nvdec-repro-03" \
    --jobs (nproc)
```

確認済み出力:

```text
~/Games/aviutl2/build/l-smash-works-nvdec-repro-03/output
```

確認済みSHA-256:

```text
db465570a4c049624f369086232cf47c387975d54fa615d895d090fe1a17bbe0
```

この再構築では次を静的に確認済み。

- L-SMASH Works HEAD `393df5ef669707f776261e4ac1bcc7e9a9a227ab`
- Git history count `1284`
- `r1284`
- `CONFIG_CUVID=yes`
- `CONFIG_FFNVCODEC=yes`
- `CONFIG_AV1_CUVID_DECODER=yes`
- `--enable-decoder=av1_cuvid`
- PE32+ x86-64
- 最終リンク成功

### 12.3 `lsmash.ini`

active設定を次にする。

```fish
set LSMASH_INI \
    "$PLUGIN_DIR/lsmash.ini"

sed -i \
    -e 's/^libavsmash_disabled=.*/libavsmash_disabled=1/' \
    -e 's/^libav_disabled=.*/libav_disabled=0/' \
    -e 's/^preferred_decoders=.*/preferred_decoders=av1_cuvid/' \
    "$LSMASH_INI"

grep -nE \
    'libavsmash_disabled|libav_disabled|preferred_decoders' \
    "$LSMASH_INI"
```

期待値:

```ini
libavsmash_disabled=1
libav_disabled=0
preferred_decoders=av1_cuvid
```

既存indexを消して再生成させる場合:

```fish
find \
    "$NV_PREFIX/drive_c/AviUtl2" \
    -type f \
    \( \
        -iname '*.lwi' \
        -o -iname '*.lwi2' \
    \) \
    -print \
    -delete
```

---

## 13. GE-Protonを複製してDirectWrite修正版を導入

通常のGE-Protonを直接変更しない。

```fish
set WINE_SRC \
    "$ROOT/src/wine-ge11-1-dwrite"

set WINE_BUILD \
    "$ROOT/build/wine-ge11-1-dwrite"

if not test -d "$GE_TEST"
    cp -a \
        --reflink=auto \
        "$GE_DIR" \
        "$GE_TEST"
end
```

最終的に使用するWine:

```fish
set GE_TEST_WINE \
    "$GE_TEST/files/lib/wine/x86_64-unix/wine"

set GE_TEST_WINESERVER \
    "$GE_TEST/files/bin/wineserver"

set GE_TEST_LIBS \
    "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"
```

DWriteの確実な再buildは、対象objectとPE DLLだけを削除して正確なtargetをbuildする。

```fish
rm -f \
    "$WINE_BUILD/dlls/dwrite/x86_64-windows/layout.o" \
    "$WINE_BUILD/dlls/dwrite/x86_64-windows/dwrite.dll"

make \
    -C "$WINE_BUILD" \
    -j(nproc) \
    dlls/dwrite/x86_64-windows/dwrite.dll
```

`make dlls/dwrite`だけでは、既存directoryを完了済みtargetとして扱う場合がある。

`make -B`はWine全体のconfigureを再実行し、無関係な依存関係で失敗するため使わない。

リポジトリのinstallerを使用する。

```fish
cd \
    "$HOME/projects/aviutl2-linux-patches"

scripts/install-dwrite.fish \
    "$WINE_BUILD" \
    "$GE_TEST"
```

最初の成功時には、patched runner内の少なくとも次が置換された。

```text
files/lib/wine/x86_64-windows/dwrite.dll
files/lib/wine/x86_64-unix/dwrite.so
```

---

## 14. patched runnerでAviUtl2を起動

```fish
env \
    WINEPREFIX="$NV_PREFIX" \
    "$GE_TEST_WINESERVER" \
    -k \
    2>/dev/null

sleep 1

cd \
    "$NV_PREFIX/drive_c/AviUtl2"

env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_TEST_LIBS" \
    WINEDLLOVERRIDES="$OVERRIDES" \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG=-all \
    "$GE_TEST_WINE" \
    ./aviutl2.exe
```

確認する。

1. メインウィンドウが開く
2. テキストオブジェクトを作成できる
3. テキスト選択で停止しない
4. 編集状態へ入れる
5. Fcitx5/Mozcで入力・変換・確定できる
6. AV1を読み込める
7. 再生できる
8. 複数位置へシークできる

---

## 15. AviUtl2 Catalogを同じprefixへ導入

Catalogを導入したのは、AviUtl2、NVDEC、L-SMASH Works、DWriteの動作確認後だった。

必要パッケージ:

```fish
sudo pacman -S --needed \
    lutris \
    github-cli \
    xdg-utils \
    desktop-file-utils
```

リポジトリの管理scriptを使用する。

```fish
set REPO \
    "$HOME/projects/aviutl2-linux-patches"

"$REPO/scripts/manage-aviutl2-catalog-lutris.sh" \
    lutris-install
```

Catalog初期設定:

```text
AviUtl2:
  インストール済み

AviUtl2 root:
  C:\AviUtl2

Portable mode:
  無効
```

管理scriptの既定値は次である。

```text
prefix:
~/Games/aviutl2/prefix-ge-nvdec-test

GE-Proton:
~/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test
```

CatalogもAviUtl2と同じrunner、prefix、DLL override、DXVK設定で起動する。

---

## 16. Catalog操作後はcustom L-SMASH Worksを最後に戻す

Catalogのinstall、update、reinstallは公式L-SMASH Worksで`lwinput.aui2`を上書きすることがある。

最初の成功環境でも、Catalog操作後に公式r1283へ戻ったことを確認している。

したがって順序は必ず次にする。

1. Catalogのinstallまたはupdateを完了する
2. AviUtl2とCatalogを閉じる
3. custom `lwinput.aui2`を再配置する
4. `lsmash.ini`を再配置する
5. CatalogのL-SMASH Works更新を停止する
6. AviUtl2とCatalogを再確認する

2026-08-01に確認した安全なinstaller:

```fish
cd \
    "$HOME/projects/aviutl2-linux-patches"

scripts/install-l-smash-works-nvdec.fish \
    --prefix \
    "$NV_PREFIX" \
    --artifact-dir \
    "$ROOT/build/l-smash-works-nvdec-repro-03/output"
```

このinstallerは次を行う。

- active pluginと設定のbackup
- `Mr-Ojii.L-SMASH-Works`の更新停止
- custom r1284のoverlay
- `installed.json`を変更しない
- `hash-cache.json`を変更しない
- copy後のSHA-256確認

Catalog上でcustom版が「不明」と表示されるのは正常である。

custom版導入後、L-SMASH Worksに対して次を実行しない。

- 更新
- 再インストール
- 削除
- 初期セットアップ

---

## 17. Catalogを起動

```fish
cd \
    "$HOME/projects/aviutl2-linux-patches"

scripts/manage-aviutl2-catalog-lutris.sh \
    launch
```

status確認:

```fish
scripts/manage-aviutl2-catalog-lutris.sh \
    status
```

Lutrisは生成されたlocal installerを使用し、Linux Runnerから管理scriptを起動する。

---

## 18. 最終的な固定起動条件

```fish
set ROOT \
    "$HOME/Games/aviutl2"

set PREFIX \
    "$ROOT/prefix-ge-nvdec-test"

set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set GE_WINE \
    "$GE_TEST/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_TEST/files/bin/wineserver"

set GE_LIBS \
    "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"

set OVERRIDES \
    'nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'
```

AviUtl2:

```fish
env \
    WINEPREFIX="$PREFIX" \
    "$GE_WINESERVER" \
    -k \
    2>/dev/null

sleep 1

cd \
    "$PREFIX/drive_c/AviUtl2"

env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES="$OVERRIDES" \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG=-all \
    "$GE_WINE" \
    ./aviutl2.exe
```

---

# Part B — 成功環境の検証

## 19. prefix完全性

```fish
for path in \
    "$PREFIX/user.reg" \
    "$PREFIX/system.reg" \
    "$PREFIX/userdef.reg" \
    "$PREFIX/drive_c/windows/system32" \
    "$PREFIX/drive_c/AviUtl2/aviutl2.exe" \
    "$PREFIX/drive_c/ProgramData/aviutl2"

    test -e "$path"

    or begin
        echo "MISSING: $path"
        return 1
    end
end
```

`user.reg`、`system.reg`、`userdef.reg`がない場合、そのdirectoryは正常なWine prefixではない。

---

## 20. DXVK identity

```fish
sha256sum \
    "$PREFIX/drive_c/windows/system32/d3d11.dll" \
    "$PREFIX/drive_c/windows/system32/dxgi.dll" \
    "$PREFIX/drive_c/windows/system32/d3d10core.dll" \
    "$PREFIX/drive_c/windows/system32/d3dcompiler_47.dll"

strings \
    "$PREFIX/drive_c/windows/system32/d3d11.dll" \
    | grep -F \
        'AviUtl2 compatibility: format 69 unsupported; returning S_OK'
```

元の成功snapshotの期待値:

```text
d3d11.dll:
1c706356495405d2f929e7169f03964ea6d1af5d7e21f2de93fd9c0e82d25364

dxgi.dll:
ec02eb37620ff52361cb45376a4611fc4210d96e71d0363f1cc9807f151c01be

d3d10core.dll:
3bf5fec5115649dfb6fed1613a4c3f9487c2f2aaf74c2786d9f9d7d21a2f1482

d3dcompiler_47.dll:
4432bbd1a390874f3f0a503d45cc48d346abc3a8c0213c289f4b615bf0ee84f3
```

---

## 21. L-SMASH Works identity

```fish
set PLUGIN \
    "$PREFIX/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2"

sha256sum \
    "$PLUGIN"

begin
    strings \
        -a \
        -n 6 \
        "$PLUGIN"

    strings \
        -a \
        -e l \
        -n 6 \
        "$PLUGIN"
end \
    | grep -E \
        'L-SMASH Works File Reader for AviUtl2 r1284 by Mr-Ojii|av1_cuvid|--enable-decoder=av1_cuvid' \
    | sort \
        -u
```

---

## 22. Catalog identity

```fish
set CATALOG_EXE \
    (find \
        "$PREFIX/drive_c" \
        -type f \
        -iname 'AviUtl2_Catalog.exe' \
        -print \
        -quit)

echo \
    "$CATALOG_EXE"

test -f \
    "$CATALOG_EXE"
```

Catalog設定:

```fish
set CATALOG_SETTINGS \
    (find \
        "$PREFIX/drive_c/users" \
        -type f \
        -path '*/AppData/*/aviutl2-catalog/settings.json' \
        -print \
        -quit)

echo \
    "$CATALOG_SETTINGS"
```

---

## 23. 実用再現の合格条件

次をすべて実機で確認して初めて成功とする。

- prefixに三つのregistry fileがある
- patched GE-Proton内部Wineを使用している
- patched `d3d11.dll`が実際に読み込まれる
- format 69エラーで停止しない
- AviUtl2のメインウィンドウが開く
- AV1を読み込める
- AV1を再生できる
- 複数位置へシークできる
- `av1_cuvid`が使用される
- NVDEC hardware frameがsoftware frameへ転送される
- テキスト選択で停止しない
- テキスト編集状態へ入れる
- Mozcで入力・変換・確定できる
- Catalogを同じprefixで起動できる
- Catalog操作後もcustom L-SMASH Works r1284を復旧できる

---

# Part C — 失敗時の扱い

## 24. 今回実際に環境を壊した状態

次の状態はprefixではない。

```text
~/Games/aviutl2/prefix-ge-nvdec-test/
└── drive_c/
    └── AviUtl2/
```

特に次が欠落している状態では起動試験へ進まない。

```text
user.reg
system.reg
userdef.reg
drive_c/windows/system32
```

AviUtl2のファイルだけを新しいdirectoryへコピーしても、Wine prefix、Catalog、registry、WebView data、installer状態は復元されない。

---

## 25. known-good backup

2026-07-31に保存されたknown-good prefix:

```text
~/Games/aviutl2/prefix-ge-nvdec-test.backup-20260731-135410
```

known-good patched runner:

```text
~/.local/share/Steam/compatibilitytools.d/
└── GE-Proton11-1-aviutl2-test.backup-20260731-135348
```

壊れたactive prefixやactive runnerを上書きで修理しない。

1. known-good runnerのwineserverでWineを停止
2. known-good prefixとknown-good runnerを別々のstagingへ複製
3. 両方のstagingを検証
4. active prefixとactive runnerを時刻付きで退避
5. verified stagingを元のactive pathへrename
6. 途中で失敗した場合は両方を元のpathへ戻す
7. CatalogとAviUtl2を確認

リポジトリに同梱する復旧script:

```text
scripts/restore-known-good-aviutl2.fish
```

実行前監査:

```fish
scripts/restore-known-good-aviutl2.fish
```

復旧適用:

```fish
scripts/restore-known-good-aviutl2.fish \
    --apply
```

---

## 26. この文書へ含めないもの

次は別文書で扱う。

- Nanashi環境のloader failure
- 別マシンへのbinary migration
- 完全なclean-room build
- 別GE-Proton版
- 別Wine版
- AMD/Intel GPU
- 他のDXVK版
- 失敗した推測コマンド
- 途中で発生した`No such file or directory`を後付けで回避する分岐

これらを最初の成功経路へ混ぜない。
