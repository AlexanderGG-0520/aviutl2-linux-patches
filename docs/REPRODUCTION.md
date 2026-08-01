# AviUtl2 on Linux — 実機確認済み再構築手順

最終更新: 2026-08-01

この文書は、CachyOS上でAviUtl2の起動、文字表示、DirectWriteテキスト編集、Fcitx5/Mozc、日本語入力、L-SMASH Works custom r1284、AV1/NVDEC、AviUtl2 Catalogまで実際に成功した環境を、実行済みコマンドから再構築するための手順である。

## 0. この文書の保証範囲

この手順で確認済みなのは、次の二つである。

1. 既存の正常な`prefix-ge`、patched GE-Proton runner、known-good prefix backupを使い、最終prefixを再構築する経路
2. 既存のconfigured source/build treeからDXVK、Wine DWrite、L-SMASH Worksを再buildする経路

次はまだ確認できていない。

- 完全な空環境からAviUtl2本体を初回配置する工程
- GE-Proton 11-1を取得してpatched runnerをゼロから完成させる全工程
- Wine source treeとWine build treeをゼロから作る全configure command
- `Tahoma-Noto-Regular.otf`と`Tahoma-Noto-Bold.otf`を生成する工程
- `nvidia-libs-v1.0.2`を初回取得・展開する工程
- 別ユーザー、別`$HOME`、別GPU、別driver、別Wine、別DXVKでの完全再現

したがって、この文書を**clean-room install手順**として扱ってはならない。未確認工程を推測で補わず、確認済みの再構築経路として扱う。

## 1. 確認済みの最終結果

同一prefixで次をすべて確認した。

- AviUtl2 2.1.2のメインウィンドウ表示
- 日本語UIの文字化けなし
- patched DXVKによるDXGI format 69回避
- patched Wine DWriteによる`HitTestPoint()`と`HitTestTextRange()`
- テキスト選択、キャレット移動、再編集
- Fcitx5/Mozcによる入力、変換、Enter確定
- L-SMASH Works custom r1284認識
- AV1 Main 10-bit素材の読み込み
- AV1再生
- 冒頭、中央、終盤へのシーク
- `av1_cuvid`によるNVIDIA NVDEC
- hardware-frame-transfer failureなし
- AviUtl2 Catalog 0.3.3の導入、初期設定、通常起動
- Catalog導入後のcustom r1284再配置
- Catalog再起動後もr1284のSHA-256が変化しないこと

## 2. 最終成功環境の固定値

| 項目 | 値 |
| --- | --- |
| OS | CachyOS |
| GPU | NVIDIA GeForce RTX 4060 Ti 8 GB |
| NVIDIA driver | 610.43.3 |
| GE-Proton | 11-1 |
| Wine | wine-staging 11.0 |
| DXVK | 2.7.1 |
| AviUtl2 | 2.1.2 |
| IME | Fcitx5 + Mozc |
| Catalog | 0.3.3 |
| 作業root | `/home/alex/Games/aviutl2` |
| repository | `/home/alex/projects/aviutl2-linux-patches` |
| base GE prefix | `/home/alex/Games/aviutl2/prefix-ge` |
| final prefix | `/home/alex/Games/aviutl2/prefix-ge-nvdec-test` |
| patched runner checkpoint | `/home/alex/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test.backup-20260731-135348` |
| known-good prefix checkpoint | `/home/alex/Games/aviutl2/prefix-ge-nvdec-test.backup-20260731-135410` |
| r1284 build output | `/home/alex/Games/aviutl2/build/l-smash-works-nvdec-repro-03/output` |

### 2.1 最終artifact

| ファイル | SHA-256 |
| --- | --- |
| `lwinput.aui2` | `db465570a4c049624f369086232cf47c387975d54fa615d895d090fe1a17bbe0` |
| `lsmash.ini` | `10620155d1470ea270121f67357f3da89cb8151ffac651c049e98238253a9a9f` |
| Catalog installer | `5591a5baa931f94322aff13096c63147126ca90d3844610ce7827b2f9b44d84e` |

### 2.2 DXVK DLL

| ファイル | SHA-256 |
| --- | --- |
| `d3d11.dll` | `1c706356495405d2f929e7169f03964ea6d1af5d7e21f2de93fd9c0e82d25364` |
| `dxgi.dll` | `ec02eb37620ff52361cb45376a4611fc4210d96e71d0363f1cc9807f151c01be` |
| `d3d10core.dll` | `3bf5fec5115649dfb6fed1613a4c3f9487c2f2aaf74c2786d9f9d7d21a2f1482` |
| `d3dcompiler_47.dll` | `4432bbd1a390874f3f0a503d45cc48d346abc3a8c0213c289f4b615bf0ee84f3` |

### 2.3 NVIDIA Wine wrapper

| ファイル | SHA-256 |
| --- | --- |
| `nvcuda.dll` | `86a7db21366704af4e0e61884aaaafb80b2e87d427c4214dcb775d17b37fd7cc` |
| `nvcuvid.dll` | `fd51c2f98f8006f097240a1d2cf53d72a6d1b741618fb679226ec563d2ad0944` |
| `nvencodeapi64.dll` | `6f28193dd276c257d3e80ee03627f2cb0bb94dec6582cf9c04c32744d088b75a` |

## 3. 重要な原則

- system Wineとpatched GE-Protonを混ぜない。
- `prefix-ge`と`prefix-ge-nvdec-test`を混ぜない。
- DXVK、DWrite、NVIDIA wrapper、L-SMASH Works、Catalogを同時に変更しない。
- source build成功だけで実用再現成功と判定しない。
- AV1が再生できただけでNVDEC成功と判定しない。libdav1d fallbackでも再生できる。
- Catalogは先に導入し、custom r1284は最後にoverlayする。
- CatalogでL-SMASH WorksのUpdate、Reinstall、Remove、初期セットアップ再実行を行わない。
- `%APPDATA%\aviutl2-catalog\installed.json`、`hash-cache.json`、`catalog\index.json`を手動編集しない。

---

# Part A — 2026-08-01に再確認した最終再構築経路

## 4. 使用シェル

以下はFishで実行した。

## 5. 変数を設定する

```fish
set ROOT \
    "$HOME/Games/aviutl2"

set REPO \
    "$HOME/projects/aviutl2-linux-patches"

set GE_PREFIX \
    "$ROOT/prefix-ge"

set NV_PREFIX \
    "$ROOT/prefix-ge-nvdec-test"

set GOOD_PREFIX \
    "$ROOT/prefix-ge-nvdec-test.backup-20260731-135410"

set GOOD_FONTS \
    "$GOOD_PREFIX/drive_c/windows/Fonts"

set GE_OK \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test.backup-20260731-135348"

set GE_OK_WINE \
    "$GE_OK/files/lib/wine/x86_64-unix/wine"

set GE_OK_WINESERVER \
    "$GE_OK/files/bin/wineserver"

set GE_OK_LIBS \
    "$GE_OK/files/lib64:$GE_OK/files/lib:$GE_OK/files/lib/wine/x86_64-unix:$GE_OK/files/lib/wine/i386-unix"
```

この`GE_OK`は最終成功したpatched runnerのcheckpointである。通常のGE-Proton 11-1へ読み替えない。

## 6. 前提を確認する

実行済みの確認コマンド:

```fish
for command_name in \
    gh \
    python3 \
    sha256sum \
    file \
    find

    command -q "$command_name"

    or begin
        echo "ERROR: missing command: $command_name" >&2
        return 1
    end
end
```

```fish
for path in \
    "$NV_PREFIX/drive_c/AviUtl2/aviutl2.exe" \
    "$GE_OK_WINE" \
    "$GE_OK_WINESERVER" \
    "$GE_OK/files/lib/wine/x86_64-windows/dwrite.dll"

    test -e "$path"

    or begin
        echo "ERROR: missing path: $path" >&2
        return 1
    end
end
```

新しく`NV_PREFIX`を作り直す場合は、上の`NV_PREFIX`確認より先に次節のcloneを行う。

## 7. 正常な`prefix-ge`からfinal prefixをcloneする

この工程は、空directoryをprefixとして扱わず、既にAviUtl2起動とDXVK format 69到達を確認した`prefix-ge`全体を複製する。

Wineを停止する。

```fish
env \
    WINEPREFIX="$GE_PREFIX" \
    LD_LIBRARY_PATH="$GE_OK_LIBS" \
    "$GE_OK_WINESERVER" \
    -k \
    2>/dev/null

and env \
    WINEPREFIX="$GE_PREFIX" \
    LD_LIBRARY_PATH="$GE_OK_LIBS" \
    "$GE_OK_WINESERVER" \
    -w \
    2>/dev/null

or return 1
```

既存final prefixを退避する。

```fish
if test -e "$NV_PREFIX"
    set STAMP \
        (date +%Y%m%d-%H%M%S)

    mv \
        "$NV_PREFIX" \
        "$NV_PREFIX.before-current-clone-$STAMP"
end
```

cloneする。

```fish
cp -a \
    --reflink=auto \
    "$GE_PREFIX" \
    "$NV_PREFIX"

or return 1
```

cloneの同一性を確認する。

```fish
for relative in \
    user.reg \
    system.reg \
    userdef.reg \
    drive_c/AviUtl2/aviutl2.exe \
    drive_c/windows/system32/d3d11.dll \
    drive_c/windows/system32/dxgi.dll \
    drive_c/windows/system32/d3d10core.dll \
    drive_c/windows/system32/d3dcompiler_47.dll

    cmp \
        --silent \
        "$GE_PREFIX/$relative" \
        "$NV_PREFIX/$relative"

    or begin
        echo "ERROR: clone mismatch: $relative" >&2
        return 1
    end

    echo "MATCH: $relative"
end
```

実機では8対象すべてで`MATCH`を確認した。

## 8. 日本語フォントを復旧する

この工程はknown-good prefixに存在するフォントを使用する。フォントの生成コマンドは履歴から回収できていない。

存在を確認する。

```fish
for file in \
    "$GOOD_FONTS/NotoSansCJK-Regular.ttc" \
    "$GOOD_FONTS/NotoSansCJK-Bold.ttc" \
    "$GOOD_FONTS/Tahoma-Noto-Regular.otf" \
    "$GOOD_FONTS/Tahoma-Noto-Bold.otf"

    test -f "$file"

    or begin
        echo "ERROR: known-good font is missing: $file" >&2
        return 1
    end

    echo "OK: $file"
end
```

base/final prefixのWineを停止する。

```fish
for PREFIX in \
    "$GE_PREFIX" \
    "$NV_PREFIX"

    env \
        WINEPREFIX="$PREFIX" \
        LD_LIBRARY_PATH="$GE_OK_LIBS" \
        "$GE_OK_WINESERVER" \
        -k \
        2>/dev/null

    or true

    env \
        WINEPREFIX="$PREFIX" \
        LD_LIBRARY_PATH="$GE_OK_LIBS" \
        "$GE_OK_WINESERVER" \
        -w \
        2>/dev/null

    or true
end

sleep 1
```

フォントを配置する。

```fish
for PREFIX in \
    "$GE_PREFIX" \
    "$NV_PREFIX"

    set DEST_FONTS \
        "$PREFIX/drive_c/windows/Fonts"

    mkdir -p \
        "$DEST_FONTS"

    or return 1

    for font in (find \
        "$GOOD_FONTS" \
        -maxdepth 1 \
        -type f \
        -name 'NotoSansCJK-*.ttc' \
        -print)

        install \
            -m 0644 \
            "$font" \
            "$DEST_FONTS/"

        or return 1
    end

    install \
        -m 0644 \
        "$GOOD_FONTS/Tahoma-Noto-Regular.otf" \
        "$DEST_FONTS/Tahoma-Noto-Regular.otf"

    and install \
        -m 0644 \
        "$GOOD_FONTS/Tahoma-Noto-Bold.otf" \
        "$DEST_FONTS/Tahoma-Noto-Bold.otf"

    or return 1
end
```

registry keyを設定する。

```fish
set REG_FONTS \
    'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Fonts'

set REG_SUBS \
    'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\FontSubstitutes'
```

Fontsを登録する。

```fish
for PREFIX in \
    "$GE_PREFIX" \
    "$NV_PREFIX"

    env \
        WINEPREFIX="$PREFIX" \
        LD_LIBRARY_PATH="$GE_OK_LIBS" \
        "$GE_OK_WINE" \
        reg add "$REG_FONTS" \
        /v 'Noto Sans CJK JP (TrueType)' \
        /d 'NotoSansCJK-Regular.ttc' \
        /f

    and env \
        WINEPREFIX="$PREFIX" \
        LD_LIBRARY_PATH="$GE_OK_LIBS" \
        "$GE_OK_WINE" \
        reg add "$REG_FONTS" \
        /v 'Noto Sans CJK JP Bold (TrueType)' \
        /d 'NotoSansCJK-Bold.ttc' \
        /f

    and env \
        WINEPREFIX="$PREFIX" \
        LD_LIBRARY_PATH="$GE_OK_LIBS" \
        "$GE_OK_WINE" \
        reg add "$REG_FONTS" \
        /v 'Tahoma (OpenType)' \
        /d 'Tahoma-Noto-Regular.otf' \
        /f

    and env \
        WINEPREFIX="$PREFIX" \
        LD_LIBRARY_PATH="$GE_OK_LIBS" \
        "$GE_OK_WINE" \
        reg add "$REG_FONTS" \
        /v 'Tahoma Bold (OpenType)' \
        /d 'Tahoma-Noto-Bold.otf' \
        /f

    or return 1
end
```

古いTahoma substituteを削除する。

```fish
for PREFIX in \
    "$GE_PREFIX" \
    "$NV_PREFIX"

    env \
        WINEPREFIX="$PREFIX" \
        LD_LIBRARY_PATH="$GE_OK_LIBS" \
        "$GE_OK_WINE" \
        reg delete "$REG_SUBS" \
        /v Tahoma \
        /f

    or true
end
```

UI aliasesを登録する。

```fish
for PREFIX in \
    "$GE_PREFIX" \
    "$NV_PREFIX"

    for name in \
        'MS Shell Dlg' \
        'MS Shell Dlg 2'

        env \
            WINEPREFIX="$PREFIX" \
            LD_LIBRARY_PATH="$GE_OK_LIBS" \
            "$GE_OK_WINE" \
            reg add "$REG_SUBS" \
            /v "$name" \
            /d Tahoma \
            /f

        or return 1
    end

    for name in \
        'MS Gothic' \
        'MS UI Gothic' \
        'MS PGothic' \
        'MS Mincho' \
        'MS PMincho' \
        'Meiryo' \
        'Meiryo UI' \
        'Yu Gothic' \
        'Yu Gothic UI' \
        'Yu Mincho'

        env \
            WINEPREFIX="$PREFIX" \
            LD_LIBRARY_PATH="$GE_OK_LIBS" \
            "$GE_OK_WINE" \
            reg add "$REG_SUBS" \
            /v "$name" \
            /d 'Noto Sans CJK JP' \
            /f

        or return 1
    end
end
```

反映する。

```fish
for PREFIX in \
    "$GE_PREFIX" \
    "$NV_PREFIX"

    env \
        WINEPREFIX="$PREFIX" \
        LD_LIBRARY_PATH="$GE_OK_LIBS" \
        "$GE_OK_WINE" \
        wineboot -u

    and env \
        WINEPREFIX="$PREFIX" \
        LD_LIBRARY_PATH="$GE_OK_LIBS" \
        "$GE_OK_WINESERVER" \
        -w

    or return 1
end
```

登録を確認する。

```fish
env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_OK_LIBS" \
    "$GE_OK_WINE" \
    reg query "$REG_FONTS" \
    /v 'Tahoma (OpenType)'

and env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_OK_LIBS" \
    "$GE_OK_WINE" \
    reg query "$REG_FONTS" \
    /v 'Noto Sans CJK JP (TrueType)'

and env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_OK_LIBS" \
    "$GE_OK_WINE" \
    reg query "$REG_SUBS" \
    /v 'MS Shell Dlg'

and env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_OK_LIBS" \
    "$GE_OK_WINE" \
    reg query "$REG_SUBS" \
    /v 'Yu Gothic UI'

or return 1
```

期待値:

```text
Tahoma (OpenType)              Tahoma-Noto-Regular.otf
Noto Sans CJK JP (TrueType)    NotoSansCJK-Regular.ttc
MS Shell Dlg                   Tahoma
Yu Gothic UI                   Noto Sans CJK JP
```

## 9. NVIDIA Wine wrapperを復旧する

初回取得・展開コマンドは未回収である。確認済み手順はknown-good prefix内のsymlinkをfinal prefixへ復元する方法である。

変数を設定し、sourceを確認する。

```fish
set GOOD_SYSTEM32 \
    "$GOOD_PREFIX/drive_c/windows/system32"

set NV_SYSTEM32 \
    "$NV_PREFIX/drive_c/windows/system32"

for dll in \
    nvcuda \
    nvcuvid \
    nvencodeapi64

    set source \
        "$GOOD_SYSTEM32/$dll.dll"

    test -L "$source"

    or begin
        echo "ERROR: known-good NVIDIA symlink is missing: $source" >&2
        return 1
    end

    set target \
        (readlink -f "$source")

    test -f "$target"

    or begin
        echo "ERROR: symlink target is missing: $source -> $target" >&2
        return 1
    end

    echo "$source -> $target"
    file "$target"
    sha256sum "$target"
end
```

既存DLLを退避するdirectoryを作る。

```fish
set STAMP \
    (date +%Y%m%d-%H%M%S)

set NV_DLL_BACKUP \
    "$ROOT/backups/nvidia-dlls-before-restore-$STAMP"

mkdir -p \
    "$NV_DLL_BACKUP"

or return 1
```

symlinkを復元する。

```fish
for dll in \
    nvcuda \
    nvcuvid \
    nvencodeapi64

    set current \
        "$NV_SYSTEM32/$dll.dll"

    set source \
        "$GOOD_SYSTEM32/$dll.dll"

    if test -e "$current"
        cp -a \
            "$current" \
            "$NV_DLL_BACKUP/$dll.dll"

        or return 1
    end

    rm -f \
        "$current"

    or return 1

    cp -a \
        "$source" \
        "$current"

    or return 1
end
```

復元結果を確認する。

```fish
for dll in \
    nvcuda \
    nvcuvid \
    nvencodeapi64

    set current \
        "$NV_SYSTEM32/$dll.dll"

    test -L "$current"

    or begin
        echo "ERROR: restored file is not a symlink: $current" >&2
        return 1
    end

    set target \
        (readlink -f "$current")

    test -f "$target"

    or begin
        echo "ERROR: restored symlink target is missing: $current" >&2
        return 1
    end

    ls -l "$current"
    file "$target"
    sha256sum "$current"
end
```

Wine overrideを登録する。

```fish
for dll in \
    nvcuda \
    nvcuvid \
    nvencodeapi64

    env \
        WINEPREFIX="$NV_PREFIX" \
        LD_LIBRARY_PATH="$GE_OK_LIBS" \
        "$GE_OK_WINE" \
        reg add \
        'HKEY_CURRENT_USER\Software\Wine\DllOverrides' \
        /v "$dll" \
        /d native \
        /f

    or return 1
end
```

確認する。

```fish
for dll in \
    nvcuda \
    nvcuvid \
    nvencodeapi64

    env \
        WINEPREFIX="$NV_PREFIX" \
        LD_LIBRARY_PATH="$GE_OK_LIBS" \
        "$GE_OK_WINE" \
        reg query \
        'HKEY_CURRENT_USER\Software\Wine\DllOverrides' \
        /v "$dll"

    or return 1
end
```

期待値は3件とも`REG_SZ native`である。Wineのload traceではwrapperが`builtin`と表示されたが、この状態でNVDECは成功した。

## 10. L-SMASH Works custom r1284をbuildする

現在のrepositoryで実際に成功したbuild command:

```fish
cd ~/projects/aviutl2-linux-patches

scripts/build-l-smash-works-nvdec.fish \
    --work-dir \
    "$HOME/Games/aviutl2/build/l-smash-works-nvdec-repro-03" \
    --jobs (nproc)
```

生成物:

```text
$HOME/Games/aviutl2/build/l-smash-works-nvdec-repro-03/output/lwinput.aui2
$HOME/Games/aviutl2/build/l-smash-works-nvdec-repro-03/output/lsmash.ini
$HOME/Games/aviutl2/build/l-smash-works-nvdec-repro-03/output/PROVENANCE.txt
$HOME/Games/aviutl2/build/l-smash-works-nvdec-repro-03/output/SHA256SUMS
```

artifactを確認する。

```fish
set ARTIFACT_DIR \
    "$ROOT/build/l-smash-works-nvdec-repro-03/output"

set BUILT_LWINPUT \
    "$ARTIFACT_DIR/lwinput.aui2"

set BUILT_INI \
    "$ARTIFACT_DIR/lsmash.ini"

test -f "$BUILT_LWINPUT"

or begin
    echo "ERROR: missing: $BUILT_LWINPUT" >&2
    return 1
end

sha256sum \
    "$BUILT_LWINPUT"
```

期待値:

```text
db465570a4c049624f369086232cf47c387975d54fa615d895d090fe1a17bbe0
```

markerを確認する。

```fish
begin
    strings \
        -a \
        -n 6 \
        "$BUILT_LWINPUT"

    strings \
        -a \
        -e l \
        -n 6 \
        "$BUILT_LWINPUT"
end \
    | grep -E \
        'L-SMASH Works File Reader for AviUtl2 r1284 by Mr-Ojii|av1_cuvid|--enable-decoder=av1_cuvid' \
    | sort \
        -u
```

## 11. r1284をfinal prefixへ導入する

導入前checkpointを作る。

```fish
env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_OK_LIBS" \
    "$GE_OK_WINESERVER" \
    -k \
    2>/dev/null

and env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_OK_LIBS" \
    "$GE_OK_WINESERVER" \
    -w \
    2>/dev/null

or return 1
```

```fish
set STAMP \
    (date +%Y%m%d-%H%M%S)

set PRE_LSMASH_BACKUP \
    "$NV_PREFIX.before-l-smash-$STAMP"

cp -a \
    --reflink=auto \
    "$NV_PREFIX" \
    "$PRE_LSMASH_BACKUP"

or return 1

echo "$PRE_LSMASH_BACKUP"
```

active pathsを設定する。

```fish
set PLUGIN_DIR \
    "$NV_PREFIX/drive_c/ProgramData/aviutl2/Plugin"

set ACTIVE_LWINPUT \
    "$PLUGIN_DIR/lwinput.aui2"

set ACTIVE_INI \
    "$PLUGIN_DIR/lsmash.ini"

mkdir -p \
    "$PLUGIN_DIR"

or return 1
```

既存ファイルをbackupする。

```fish
set STAMP \
    (date +%Y%m%d-%H%M%S)

for file in \
    "$ACTIVE_LWINPUT" \
    "$ACTIVE_INI"

    if test -f "$file"
        cp -a \
            "$file" \
            "$file.before-r1284-$STAMP"

        or return 1
    end
end
```

pluginを配置する。

```fish
install \
    -m 0644 \
    "$BUILT_LWINPUT" \
    "$ACTIVE_LWINPUT"

or return 1

cmp \
    --silent \
    "$BUILT_LWINPUT" \
    "$ACTIVE_LWINPUT"

or return 1
```

INIを配置する。

```fish
install \
    -m 0644 \
    "$BUILT_INI" \
    "$ACTIVE_INI"

or return 1
```

確認済みNVDEC設定へ揃える。

```fish
sed -i \
    -e 's/^libavsmash_disabled=.*/libavsmash_disabled=1/' \
    -e 's/^libav_disabled=.*/libav_disabled=0/' \
    -e 's/^preferred_decoders=.*/preferred_decoders=av1_cuvid/' \
    "$ACTIVE_INI"

or return 1
```

確認する。

```fish
sha256sum \
    "$ACTIVE_LWINPUT"

grep -nE \
    '^(libavsmash_disabled|libav_disabled|preferred_decoders)=' \
    "$ACTIVE_INI"
```

期待値:

```text
lwinput.aui2 SHA-256:
  db465570a4c049624f369086232cf47c387975d54fa615d895d090fe1a17bbe0

libavsmash_disabled=1
libav_disabled=0
preferred_decoders=av1_cuvid
```

## 12. Fcitx5/Mozc用InputStyleを設定する

ホスト側を確認する。

```fish
printf 'XMODIFIERS=%s\n' \
    (printenv XMODIFIERS)

pgrep -a -f \
    'fcitx5|mozc'
```

AviUtl2専用設定を登録する。

```fish
env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_OK_LIBS" \
    "$GE_OK_WINE" \
    reg add \
    'HKCU\Software\Wine\AppDefaults\aviutl2.exe\X11 Driver' \
    /v InputStyle \
    /t REG_SZ \
    /d overthespot \
    /f

or return 1
```

確認する。

```fish
env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_OK_LIBS" \
    "$GE_OK_WINE" \
    reg query \
    'HKCU\Software\Wine\AppDefaults\aviutl2.exe\X11 Driver' \
    /v InputStyle

or return 1
```

期待値:

```text
InputStyle    REG_SZ    overthespot
```

## 13. 通常起動する

```fish
cd \
    "$NV_PREFIX/drive_c/AviUtl2"

env \
    XMODIFIERS='@im=fcitx' \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_OK_LIBS" \
    WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG=-all \
    "$GE_OK_WINE" \
    ./aviutl2.exe
```

ここで次を確認する。

- メインウィンドウが出る
- 日本語UIが文字化けしない
- L-SMASH Works r1284が認識される

---

# Part B — 実用検証

## 14. AV1検証素材

実際に使用した元動画:

```text
/run/media/alex/6A0CF5D10CF59871/編集/録画データ/2026-07-15 15-32-57.mp4
```

履歴上で実行したvideo-only remux:

```fish
set VIDEO \
    "/run/media/alex/6A0CF5D10CF59871/編集/録画データ/2026-07-15 15-32-57.mp4"

set CUVID_TEST \
    "$GE_PREFIX/drive_c/AviUtl2/av1-cuvid-test.mp4"

rm -f "$CUVID_TEST"

ffmpeg \
    -hide_banner \
    -i "$VIDEO" \
    -map 0:v:0 \
    -c copy \
    -tag:v av01 \
    -map_metadata -1 \
    -map_chapters -1 \
    -movflags +faststart \
    "$CUVID_TEST"
```

最終検証では`C:\AviUtl2\av1-cuvid-test.mp4`を使用した。

## 15. NVDECを検証する

ログを初期化する。

```fish
set NVDEC_LOG \
    "$ROOT/logs/aviutl2-nvdec-native-libs-retest.log"

rm -f \
    "$NVDEC_LOG"
```

load trace付きで起動する。

```fish
cd \
    "$NV_PREFIX/drive_c/AviUtl2"

env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_OK_LIBS" \
    WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG='-all,+timestamp,+loaddll,+nvcuda,+nvcuvid' \
    "$GE_OK_WINE" \
    ./aviutl2.exe \
    &> "$NVDEC_LOG"
```

GUIで次を実施する。

1. `C:\AviUtl2\av1-cuvid-test.mp4`を読み込む
2. プレビューに映像が出ることを確認する
3. 再生し、フレームが進むことを確認する
4. 冒頭、中央、終盤へ何度かシークする
5. 映像が更新され、クラッシュしないことを確認する
6. AviUtl2を閉じる

ログを確認する。

```fish
grep -nEi \
    'nvcuda\.dll|nvcuvid\.dll|\[av1_cuvid|Cannot load nvcuvid|Failed loading nvcuvid|CUDA_ERROR|av_hwframe_transfer_data.*fail|hardware frame.*fail|hwframe.*fail' \
    "$NVDEC_LOG" \
    | tail -n 250
```

合格条件:

- `nvcuda.dll`と`nvcuvid.dll`のload行がある
- 異なるaddressの`[av1_cuvid @ ...]`が複数ある
- `Cannot load nvcuvid.dll`がない
- `Failed loading nvcuvid.`がない
- `CUDA_ERROR`がない
- hardware frame transfer failureがない

`Invalid pkt_timebase`と`surfaces option is deprecated`は、この検証では致命的エラーではなかった。

## 16. DWriteとMozcを検証する

Wineを停止する。

```fish
env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_OK_LIBS" \
    "$GE_OK_WINESERVER" \
    -k \
    2>/dev/null

and env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_OK_LIBS" \
    "$GE_OK_WINESERVER" \
    -w \
    2>/dev/null

or return 1
```

ログを初期化する。

```fish
set TEXT_LOG \
    "$ROOT/logs/aviutl2-text-mozc-reproduction.log"

mkdir -p \
    "$ROOT/logs"

rm -f \
    "$TEXT_LOG"

cd \
    "$NV_PREFIX/drive_c/AviUtl2"
```

trace付きで起動する。

```fish
env \
    XMODIFIERS='@im=fcitx' \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_OK_LIBS" \
    WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG='-all,+timestamp,+dwrite,+xim,+imm,+seh' \
    "$GE_OK_WINE" \
    ./aviutl2.exe \
    &> "$TEXT_LOG"
```

GUIで次を実施する。

1. テキストオブジェクトを追加する
2. 半角英数字を入力する
3. 文字列の一部をマウスで選択する
4. キャレットを移動する
5. 削除と追加入力を行う
6. Mozcを有効にする
7. `にほんごにゅうりょく`と入力する
8. `日本語入力`へ変換する
9. Enterで確定する
10. 確定した日本語を再選択・再編集する
11. クラッシュしないことを確認する
12. AviUtl2を閉じる

DWriteを確認する。

```fish
echo "=== DWrite hit tests ==="

grep -nE \
    'dwritetextlayout_HitTest(Point|TextRange)' \
    "$TEXT_LOG" \
    | tail -n 100
```

fatal errorを確認する。

```fish
echo "=== Fatal text-editing errors ==="

grep -nEi \
    'HitTest(Point|TextRange).*stub|E_NOTIMPL|80004001|Unhandled exception|unhandled page fault|C\+\+ exception' \
    "$TEXT_LOG"

or echo "No fatal text-editing errors found."
```

XIM styleを確認する。

```fish
echo "=== XIM style ==="

grep -nEi \
    'requesting|selected style' \
    "$TEXT_LOG" \
    | head -n 30

or echo "No XIM style line found."
```

合格条件:

- `dwritetextlayout_HitTestPoint`がある
- `dwritetextlayout_HitTestTextRange`がある
- stubがない
- `E_NOTIMPL`がない
- 未処理例外がない
- AviUtl2 processで`overthespot`、`0x404 preedit position`が選択される
- Mozcで変換とEnter確定ができる

---

# Part C — AviUtl2 Catalog 0.3.3

## 17. Catalog用変数

```fish
set CATALOG_VERSION \
    "0.3.3"

set CATALOG_REPO \
    "Neosku/aviutl2-catalog"

set CATALOG_CACHE \
    "$ROOT/downloads/aviutl2-catalog-$CATALOG_VERSION"

set CATALOG_LOG_DIR \
    "$ROOT/logs/catalog-reproduction-"(date +%Y%m%d-%H%M%S)
```

## 18. Catalog導入前checkpoint

Wineを停止する。

```fish
env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_OK_LIBS" \
    "$GE_OK_WINESERVER" \
    -k \
    2>/dev/null

and env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_OK_LIBS" \
    "$GE_OK_WINESERVER" \
    -w \
    2>/dev/null

or return 1
```

checkpointを作る。

```fish
set CATALOG_PRE_BACKUP \
    "$NV_PREFIX.before-catalog-"(date +%Y%m%d-%H%M%S)

cp -a \
    --reflink=auto \
    "$NV_PREFIX" \
    "$CATALOG_PRE_BACKUP"

or return 1

echo "Catalog pre-install checkpoint:"
echo "$CATALOG_PRE_BACKUP"
```

実際のcheckpoint:

```text
/home/alex/Games/aviutl2/prefix-ge-nvdec-test.before-catalog-20260801-205941
```

## 19. Catalog installerを取得する

```fish
mkdir -p \
    "$CATALOG_CACHE" \
    "$CATALOG_LOG_DIR"

or return 1
```

release metadataを取得する。

```fish
set RELEASE_JSON \
    "$CATALOG_CACHE/release.json"

rm -f \
    "$RELEASE_JSON"

for tag in \
    "v$CATALOG_VERSION" \
    "$CATALOG_VERSION"

    if gh release view \
        "$tag" \
        --repo "$CATALOG_REPO" \
        --json tagName,assets \
        > "$RELEASE_JSON" \
        2>/dev/null

        set CATALOG_TAG \
            "$tag"

        break
    end
end

test -s "$RELEASE_JSON"

or begin
    echo "ERROR: Catalog 0.3.3 release not found" >&2
    return 1
end
```

x64 setup assetを解決する。

```fish
set CATALOG_ASSET (
    python3 -c '
import json
import re
import sys
from pathlib import Path

data = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
names = [asset["name"] for asset in data.get("assets", [])]

matches = [
    name for name in names
    if re.search(r"_x64-setup\.exe$", name, re.I)
]

if len(matches) != 1:
    raise SystemExit(
        "Expected exactly one x64 setup executable, found: "
        + repr(matches)
    )

print(matches[0])
' "$RELEASE_JSON"
)

or return 1
```

取得し、SHAを確認する。

```fish
gh release download \
    "$CATALOG_TAG" \
    --repo "$CATALOG_REPO" \
    --pattern "$CATALOG_ASSET" \
    --dir "$CATALOG_CACHE" \
    --clobber

or return 1

set CATALOG_INSTALLER \
    "$CATALOG_CACHE/$CATALOG_ASSET"

test -s "$CATALOG_INSTALLER"

or begin
    echo "ERROR: installer missing: $CATALOG_INSTALLER" >&2
    return 1
end

file \
    "$CATALOG_INSTALLER"

sha256sum \
    "$CATALOG_INSTALLER"
```

期待値:

```text
AviUtl2_Catalog_0.3.3_x64-setup.exe
5591a5baa931f94322aff13096c63147126ca90d3844610ce7827b2f9b44d84e
```

## 20. Catalogをインストールする

```fish
env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_OK_LIBS" \
    WINEDLLOVERRIDES='dwrite=b' \
    WINEDEBUG=-all \
    "$GE_OK_WINE" \
    "$CATALOG_INSTALLER" \
    &> "$CATALOG_LOG_DIR/catalog-installer.log"

set INSTALL_STATUS \
    $status

echo "Installer status: $INSTALL_STATUS"
echo "Installer log: $CATALOG_LOG_DIR/catalog-installer.log"

test $INSTALL_STATUS -eq 0

or return 1
```

実機では`Installer status: 0`を確認した。

Catalog executableを検出する。

```fish
set CATALOG_EXES (
    find \
        "$NV_PREFIX/drive_c" \
        -type f \
        \( \
            -iname 'AviUtl2_Catalog.exe' \
            -o -iname 'aviutl2-catalog.exe' \
        \) \
        -print \
        2>/dev/null
)

test (count $CATALOG_EXES) -eq 1

or begin
    echo "ERROR: expected exactly one Catalog executable" >&2
    printf '%s\n' $CATALOG_EXES
    return 1
end

set CATALOG_EXE \
    "$CATALOG_EXES[1]"

echo "Catalog executable:"
echo "$CATALOG_EXE"
```

確認済みpath:

```text
/home/alex/Games/aviutl2/prefix-ge-nvdec-test/drive_c/users/steamuser/AppData/Local/AviUtl2 カタログ/AviUtl2_Catalog.exe
```

## 21. Catalogを初回起動する

```fish
env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_OK_LIBS" \
    WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG=-all \
    "$GE_OK_WINE" \
    "$CATALOG_EXE" \
    &> "$CATALOG_LOG_DIR/catalog-first-launch.log"
```

GUIで確認・実行した内容:

```text
AviUtl2:       インストール済み
AviUtl2 root:  C:\AviUtl2
Portable mode: 無効
```

セットアップ、必要なプラグイン導入、通常起動を確認した後にCatalogを閉じた。

## 22. Catalog終了後にcustom r1284を最後にoverlayする

Wineを完全停止する。

```fish
env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_OK_LIBS" \
    "$GE_OK_WINESERVER" \
    -k \
    2>/dev/null

and env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_OK_LIBS" \
    "$GE_OK_WINESERVER" \
    -w \
    2>/dev/null

or return 1
```

helperを実行する。

```fish
"$REPO/scripts/install-l-smash-works-nvdec.fish" \
    --prefix \
    "$NV_PREFIX" \
    --artifact-dir \
    "$ARTIFACT_DIR"

or return 1
```

helperの確認済み結果:

- `Mr-Ojii.L-SMASH-Works`をpause
- custom r1284を配置
- active SHAがartifactと一致
- `installed.json` unchanged
- `hash-cache.json` unchanged

artifactとactive pluginを確認する。

```fish
sha256sum \
    "$BUILT_LWINPUT" \
    "$ACTIVE_LWINPUT"

cmp \
    --silent \
    "$BUILT_LWINPUT" \
    "$ACTIVE_LWINPUT"

or begin
    echo "ERROR: active lwinput.aui2 does not match r1284 artifact" >&2
    return 1
end

echo "MATCH: active lwinput.aui2 is verified r1284"
```

Catalog settingsを検出する。

```fish
set CATALOG_SETTINGS_LIST (
    find \
        "$NV_PREFIX/drive_c/users" \
        -type f \
        -ipath '*/AppData/*/aviutl2-catalog/settings.json' \
        -print \
        2>/dev/null
)

test (count $CATALOG_SETTINGS_LIST) -eq 1

or begin
    echo "ERROR: expected exactly one Catalog settings.json" >&2
    printf '%s\n' $CATALOG_SETTINGS_LIST
    return 1
end

set CATALOG_SETTINGS \
    "$CATALOG_SETTINGS_LIST[1]"

echo "Catalog settings:"
echo "$CATALOG_SETTINGS"
```

JSONを確認する。

```fish
python3 \
    -m json.tool \
    "$CATALOG_SETTINGS" \
    >/dev/null

or return 1

echo "settings.json: valid JSON"
```

pause状態を確認する。

```fish
env \
    CATALOG_SETTINGS="$CATALOG_SETTINGS" \
    python3 -c '
import json
import os
from pathlib import Path

path = Path(os.environ["CATALOG_SETTINGS"])
data = json.loads(path.read_text(encoding="utf-8-sig"))

paused = data.get("package_updates_paused_ids", [])
required = "Mr-Ojii.L-SMASH-Works"

print("package_updates_paused_ids:")
for package_id in paused:
    print(f"  {package_id}")

if required not in paused:
    raise SystemExit(
        f"ERROR: {required} is not paused"
    )

print(f"OK: {required} is paused")
'

or return 1
```

## 23. Catalog再起動後もr1284が維持されることを確認する

再起動前のSHAを保存する。

```fish
set R1284_SHA_BEFORE_CATALOG (
    sha256sum "$ACTIVE_LWINPUT" \
        | string split ' '
)[1]

echo "Before Catalog: $R1284_SHA_BEFORE_CATALOG"
```

Catalogを起動する。

```fish
env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_OK_LIBS" \
    WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG=-all \
    "$GE_OK_WINE" \
    "$CATALOG_EXE" \
    &> "$CATALOG_LOG_DIR/catalog-after-r1284-overlay.log"
```

L-SMASH WorksへのUpdate、Reinstall、Remove、初期セットアップ操作は行わずに閉じる。

終了後に比較する。

```fish
env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_OK_LIBS" \
    "$GE_OK_WINESERVER" \
    -w \
    2>/dev/null

or return 1

set R1284_SHA_AFTER_CATALOG (
    sha256sum "$ACTIVE_LWINPUT" \
        | string split ' '
)[1]

echo "Before Catalog: $R1284_SHA_BEFORE_CATALOG"
echo "After Catalog:  $R1284_SHA_AFTER_CATALOG"

test "$R1284_SHA_BEFORE_CATALOG" = "$R1284_SHA_AFTER_CATALOG"

or begin
    echo "ERROR: Catalog replaced custom r1284" >&2
    return 1
end

echo "SUCCESS: Catalog did not replace custom r1284"
```

確認済み結果:

```text
Before Catalog: db465570a4c049624f369086232cf47c387975d54fa615d895d090fe1a17bbe0
After Catalog:  db465570a4c049624f369086232cf47c387975d54fa615d895d090fe1a17bbe0
SUCCESS: Catalog did not replace custom r1284
```

---

# Part D — source buildとして確認済みの工程

## 24. DXVK 2.7.1

この節で使用したstock GE-Proton側の変数:

```fish
set GE_BASE \
    "$HOME/.local/share/Steam/compatibilitytools.d"

set GE_DIR \
    "$GE_BASE/GE-Proton11-1"

set GE_WINE \
    "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_DIR/files/bin/wineserver"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"
```

確認済みsource/output:

```fish
set DXVK_SRC \
    "$ROOT/src/dxvk-2.7.1-aviutl2"

set DXVK_OUT \
    "$ROOT/runtime/dxvk-2.7.1-aviutl2"
```

初回Meson setupとして履歴に残るコマンドは次である。ただし、`$SRC`と`$OUT`を設定した元commandはこのチャットから完全回収できていない。

```fish
meson setup \
    "$SRC/build.w64" \
    "$SRC" \
    --cross-file "$SRC/build-win64.txt" \
    --buildtype release \
    --prefix "$OUT"
```

既存configured build treeで実際に成功した再build:

```fish
meson compile \
    -C "$DXVK_SRC/build.w64" \
    -j (nproc)

and meson install \
    -C "$DXVK_SRC/build.w64"
```

markerを確認する。

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

期待marker:

```text
AviUtl2 compatibility: format 69 unsupported; returning S_OK
```

`prefix-ge`へ配置した実行済みcommand:

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

## 25. Wine DWrite

実際に成功した最終patch/rebuild/install command:

```fish
set ROOT "$HOME/Games/aviutl2"
set REPO "$HOME/projects/aviutl2-linux-patches"

set WINE_SRC "$ROOT/src/wine-ge11-1-dwrite"
set WINE_BUILD "$ROOT/build/wine-ge11-1-dwrite"

set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set PATCH \
    "$ROOT/0002-harden-dwrite-hittestpoint.patch"

git -C "$REPO" fetch \
    origin fix/dwrite-hittestpoint-efail

and git -C "$REPO" show \
    origin/fix/dwrite-hittestpoint-efail:patches/wine/0002-harden-dwrite-hittestpoint.patch \
    > "$PATCH"

and cd "$WINE_SRC"

and patch --dry-run -p1 < "$PATCH"

and patch -p1 < "$PATCH"

and rm -f \
    "$WINE_BUILD/dlls/dwrite/x86_64-windows/layout.o" \
    "$WINE_BUILD/dlls/dwrite/x86_64-windows/dwrite.dll"

and make -C "$WINE_BUILD" \
    -j(nproc) \
    dlls/dwrite/x86_64-windows/dwrite.dll

and "$REPO/scripts/install-dwrite.fish" \
    "$WINE_BUILD" \
    "$GE_TEST"
```

このcommandが前提とする`WINE_SRC`と`WINE_BUILD`の初回作成・configure commandは、チャット履歴から完全回収できていない。

また、最終実用検証ではこのrunnerをcheckpointした次を使用した。

```text
/home/alex/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test.backup-20260731-135348
```

## 26. L-SMASH Works

source buildは`10. L-SMASH Works custom r1284をbuildする`に記載したhelperで再現した。

固定source identity:

| 項目 | 値 |
| --- | --- |
| L-SMASH Works base | `a47764915f06fcd472e26ba2fbf25aff4b9d252e` |
| patched commit | `393df5ef669707f776261e4ac1bcc7e9a9a227ab` |
| local revision | `r1284` |

build scriptが確認した必須構成:

```text
CONFIG_CUVID=yes
CONFIG_FFNVCODEC=yes
CONFIG_AV1_CUVID_DECODER=yes
--enable-cuvid
--enable-decoder=av1_cuvid
```

---

# Part E — 成功判定

## 27. 起動成功

次をすべて満たす。

- processが起動しただけではなく、メインウィンドウが表示される
- 一定時間操作できる
- 日本語UIが文字化けしない
- format 69 error dialogで停止しない
- 通常終了できる

## 28. NVDEC成功

次をすべて満たす。

- AV1を読み込める
- プレビューが出る
- 再生が進む
- 複数位置へシークできる
- 複数の`av1_cuvid` decoder contextがある
- `Cannot load nvcuvid.dll`がない
- `Failed loading nvcuvid.`がない
- `CUDA_ERROR`がない
- hardware-frame-transfer failureがない
- クラッシュしない

## 29. DWrite/Mozc成功

次をすべて満たす。

- `HitTestPoint()`が実行される
- `HitTestTextRange()`が実行される
- stubでない
- `E_NOTIMPL`がない
- 文字選択とキャレット移動ができる
- Mozcで入力、変換、Enter確定できる
- 確定後に再編集できる
- クラッシュしない

## 30. Catalog統合成功

次をすべて満たす。

- Catalog 0.3.3 installerがstatus 0で終了する
- `C:\AviUtl2`を認識する
- Portable modeが無効
- Catalogを通常起動できる
- custom r1284を最後にoverlayできる
- `Mr-Ojii.L-SMASH-Works`がpauseされる
- `installed.json`と`hash-cache.json`を変更しない
- Catalog再起動前後でactive plugin SHAが同一

---

# Part F — 未回収工程

## 31. REPRODUCTION.mdをclean-room対応にするために残る作業

次のcommandは成功状態の構成要素として必要だが、このチャット履歴から完全な実行済みcommandを回収できなかった。

1. AviUtl2本体の初回取得と`C:\AviUtl2`への配置
2. `C:\ProgramData\aviutl2`の初回作成
3. GE-Proton 11-1の取得・展開を成功確認した完全command
4. Wine source treeの取得
5. Wine build treeのconfigure
6. `Tahoma-Noto-Regular.otf`と`Tahoma-Noto-Bold.otf`の生成
7. `nvidia-libs-v1.0.2`の取得・展開・初回symlink作成
8. DXVK source checkout、base commit固定、patch applyの一続きの成功command
9. patched runnerを完成後にportable bundleへexportするcommand
10. 別ユーザー環境へimportし、絶対path依存を除去するcommand

これらを未確認の一般論で補ってはならない。追加検証後にこの節から主手順へ移す。

## 32. 既知の危険な操作

- 有効なprefixを`rm -rf`して空directoryから推測で再作成する
- backupとactive pathを取り違える
- `~/projects/aviutl2-linux`を正規repositoryとして使う
- `nvcuvid.dll`がない状態でAV1再生だけを見てNVDEC成功と判定する
- stock GE-Proton、patched runner、prefix内DLLを混在させる
- Catalog導入後にr1284を戻さない
- CatalogでL-SMASH Worksを手動update/reinstall/removeする
- `installed.json`をcustom r1284へ手書き変更する

---

# 33. 正本として参照する監査資料

実行済みcommandと証拠は次を正本とする。

```text
AVIUTL2-EXECUTED-COMMAND-LEDGER.md
AVIUTL2-EXECUTED-COMMAND-LEDGER.json
AVIUTL2-LEDGER-PART-1-FINAL-SUCCESS.md
AVIUTL2-LEDGER-PART-2-FISH-HISTORY.md
AVIUTL2-LEDGER-PART-3-AUDITS-FAILURES.md
AVIUTL2-LEDGER-PART-4-SEQUENCE-INDEX.md
```

この文書と台帳が矛盾する場合、実行証拠を保持したcommand台帳を優先する。
