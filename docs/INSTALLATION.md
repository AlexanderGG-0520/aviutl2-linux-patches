# AviUtl2 on Linux — 新規インストール手順

最終更新: 2026-08-02

この文書は、AviUtl2をLinux上の**新しいWine prefixへ導入するための手順**である。
既存prefix、既知正常backup、壊れた環境からの復旧は目的にしない。

- 新規導入: この`INSTALLATION.md`
- source buildと再現性検証: `REPRODUCTION.md`
- 実行済みコマンドの監査: `AVIUTL2-COMMAND-LEDGER-BUNDLE/`
- 既知の障害と切り分け: `TROUBLESHOOTING.md`

## 0. 現在の保証範囲

この手順は、次の構成で成功した環境を基準にしている。

| 項目 | 検証値 |
| --- | --- |
| OS | CachyOS x86_64 |
| shell | fish 4.8.1 |
| compositor | Hyprland / Wayland |
| GPU | NVIDIA GeForce RTX 4060 Ti |
| GE-Proton | 11-1 |
| Wine | wine-staging 11.0 |
| DXVK | 2.7.1 |
| AviUtl2 | 2.1.2 |
| IME | Fcitx5 + Mozc |
| Catalog | 0.3.3 |

このrepositoryは、AviUtl2、GE-Proton、Wine、DXVK、FFmpeg、L-SMASH Works、NVIDIA wrapperなどの第三者バイナリ本体を配布しない。
そのため、インストール開始前に必要なartifactを利用者側で用意する必要がある。

次の取得・生成工程は、まだクリーン環境で最後まで検証されていない。

- GE-Proton 11-1の取得からpatched runner完成までの全工程
- Wine source/build treeの初回configure
- `Tahoma-Noto-Regular.otf`と`Tahoma-Noto-Bold.otf`の生成
- `nvidia-libs-v1.0.2`の取得・展開
- AviUtl2本体の公式入手元からの自動配置
- 空prefixをCLIだけで生成する単独の確定済みcommand

この文書では、それらを推測で補わない。
必要artifactを揃えた後の**新規prefixへの導入**を主対象とする。

---

# 1. インストール方式

推奨方式は次である。

```text
prepared artifacts
├── patched GE-Proton 11-1 runner
├── patched DXVK 2.7.1 x64 DLL set
├── AviUtl2 2.1.2 files
├── Japanese font files
├── NVIDIA Wine wrapper x64 DLLs
└── custom L-SMASH Works r1284 output
        ↓
new Wine prefix
        ↓
AviUtl2 Catalog 0.3.3
        ↓
custom r1284 final overlay
```

復旧用backupを入力にしない。
同じprefixへ、次の順番で一度だけ導入する。

1. patched runnerを確定
2. 新規Wine prefixを作成
3. AviUtl2本体を配置
4. patched DXVKを配置
5. 日本語フォントを配置
6. NVIDIA wrapperを配置
7. Wine registryを設定
8. custom L-SMASH Works r1284を配置
9. Fcitx5/Mozc用設定を登録
10. AviUtl2単体を検証
11. Catalog 0.3.3を導入
12. custom r1284を最後に再配置
13. 最終検証

---

# 2. 必要artifact

インストール開始前に、次を用意する。

## 2.1 必須

```text
AviUtl2 2.1.2本体
patched GE-Proton 11-1 runner
patched DXVK 2.7.1 x64 DLL set
Japanese font files
NVIDIA Wine wrapper x64 DLLs
custom L-SMASH Works r1284 output
AV1 Main 10-bit検証素材
```

## 2.2 patched DXVK

必要ファイル:

```text
d3d11.dll
dxgi.dll
d3d10core.dll
d3dcompiler_47.dll
```

Alex環境で確認したSHA-256:

```text
d3d11.dll
  1c706356495405d2f929e7169f03964ea6d1af5d7e21f2de93fd9c0e82d25364

dxgi.dll
  ec02eb37620ff52361cb45376a4611fc4210d96e71d0363f1cc9807f151c01be

d3d10core.dll
  3bf5fec5115649dfb6fed1613a4c3f9487c2f2aaf74c2786d9f9d7d21a2f1482

d3dcompiler_47.dll
  4432bbd1a390874f3f0a503d45cc48d346abc3a8c0213c289f4b615bf0ee84f3
```

sourceから作る場合は`REPRODUCTION.md`のDXVK節を使用する。

## 2.3 patched DWrite runner

runnerは、少なくとも次を実装したWine DWriteを含む必要がある。

```text
IDWriteTextLayout::HitTestTextRange()
IDWriteTextLayout::HitTestPoint()
IDWriteTextLayout::HitTestTextPosition()
```

Alex環境で最終使用したrunner内の`dwrite.dll`:

```text
files/lib/wine/x86_64-windows/dwrite.dll
SHA-256:
0b9f579547233d09c859361f0a31d572591dbe6207480c33a1e6773d677fbb3c
```

source buildを行う場合は`REPRODUCTION.md`のWine DWrite節を使用する。

## 2.4 日本語フォント

必要ファイル:

```text
NotoSansCJK-Regular.ttc
NotoSansCJK-Bold.ttc
Tahoma-Noto-Regular.otf
Tahoma-Noto-Bold.otf
```

`Tahoma-Noto-*.otf`の生成commandはまだ未回収である。
生成元が不明なファイルを第三者へ再配布しない。

## 2.5 NVIDIA Wine wrapper

必要ファイル:

```text
nvcuda.dll
nvcuvid.dll
nvencodeapi64.dll
```

Alex環境で確認したSHA-256:

```text
nvcuda.dll
  86a7db21366704af4e0e61884aaaafb80b2e87d427c4214dcb775d17b37fd7cc

nvcuvid.dll
  fd51c2f98f8006f097240a1d2cf53d72a6d1b741618fb679226ec563d2ad0944

nvencodeapi64.dll
  6f28193dd276c257d3e80ee03627f2cb0bb94dec6582cf9c04c32744d088b75a
```

## 2.6 L-SMASH Works r1284

必要ファイル:

```text
lwinput.aui2
lsmash.ini
```

最終採用artifact:

```text
revision:
  L-SMASH Works File Reader for AviUtl2 r1284 by Mr-Ojii

lwinput.aui2 SHA-256:
  db465570a4c049624f369086232cf47c387975d54fa615d895d090fe1a17bbe0

lsmash.ini SHA-256:
  10620155d1470ea270121f67357f3da89cb8151ffac651c049e98238253a9a9f
```

sourceから生成する場合:

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

---

# 3. Fish変数

以下は利用者自身のpathへ書き換える。
`/home/alex`やbackup directoryをそのままコピーしない。

```fish
set ROOT \
    "$HOME/Games/aviutl2"

set REPO \
    "$HOME/projects/aviutl2-linux-patches"

set PREFIX \
    "$ROOT/prefix"

set GE_PROTON_ROOT \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set GE_WINE \
    "$GE_PROTON_ROOT/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_PROTON_ROOT/files/bin/wineserver"

set GE_LIBS \
    "$GE_PROTON_ROOT/files/lib64:$GE_PROTON_ROOT/files/lib:$GE_PROTON_ROOT/files/lib/wine/x86_64-unix:$GE_PROTON_ROOT/files/lib/wine/i386-unix"

set AVIUTL2_SOURCE_DIR \
    "/path/to/AviUtl2"

set DXVK_ARTIFACT_DIR \
    "/path/to/patched-dxvk-x64"

set FONT_SOURCE_DIR \
    "/path/to/aviutl2-fonts"

set NVIDIA_WRAPPER_DIR \
    "/path/to/nvidia-libs-v1.0.2/x64"

set LSMASH_ARTIFACT_DIR \
    "$ROOT/build/l-smash-works-nvdec-repro-03/output"

set AV1_TEST_FILE \
    "/path/to/av1-main10-test.mp4"

set DXVK_CONFIG_FILE \
    "$ROOT/nvidia-dxvk.conf"

set DLL_OVERRIDES \
    'nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'
```

repositoryの設定例を配置する。

```fish
mkdir -p \
    "$ROOT"

cp -a \
    "$REPO/config/nvidia-dxvk.conf" \
    "$DXVK_CONFIG_FILE"
```

`config/nvidia-dxvk.conf`が存在しない場合はここで停止する。

---

# 4. Preflight

## 4.1 helperを定義する

以下は対話Fishで使用できる。
`return`はfunction内部だけで使用する。

```fish
function require_path
    set path "$argv[1]"

    if not test -e "$path"
        echo "ERROR: missing path: $path" >&2
        return 1
    end

    echo "OK: $path"
end

function stop_prefix_wine
    env \
        WINEPREFIX="$PREFIX" \
        LD_LIBRARY_PATH="$GE_LIBS" \
        "$GE_WINESERVER" \
        -k \
        2>/dev/null

    or true

    env \
        WINEPREFIX="$PREFIX" \
        LD_LIBRARY_PATH="$GE_LIBS" \
        "$GE_WINESERVER" \
        -w \
        2>/dev/null

    or true
end
```

## 4.2 command確認

```fish
for command_name in \
    fish \
    git \
    gh \
    python3 \
    sha256sum \
    file \
    find \
    strings \
    install \
    sed \
    grep

    command -q "$command_name"

    or echo "MISSING COMMAND: $command_name" >&2
end
```

1件でも`MISSING COMMAND`が出た場合は停止する。

## 4.3 runner確認

```fish
require_path "$GE_WINE"
and require_path "$GE_WINESERVER"
and require_path "$GE_PROTON_ROOT/files/lib/wine/x86_64-windows/dwrite.dll"
```

```fish
file \
    "$GE_WINE"

env \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" \
    --version

sha256sum \
    "$GE_PROTON_ROOT/files/lib/wine/x86_64-windows/dwrite.dll"
```

期待するWine version:

```text
wine-11.0 (Staging)
```

## 4.4 artifact確認

```fish
function preflight_installation_artifacts
    for path in \
        "$AVIUTL2_SOURCE_DIR/aviutl2.exe" \
        "$DXVK_ARTIFACT_DIR/d3d11.dll" \
        "$DXVK_ARTIFACT_DIR/dxgi.dll" \
        "$DXVK_ARTIFACT_DIR/d3d10core.dll" \
        "$DXVK_ARTIFACT_DIR/d3dcompiler_47.dll" \
        "$FONT_SOURCE_DIR/NotoSansCJK-Regular.ttc" \
        "$FONT_SOURCE_DIR/NotoSansCJK-Bold.ttc" \
        "$FONT_SOURCE_DIR/Tahoma-Noto-Regular.otf" \
        "$FONT_SOURCE_DIR/Tahoma-Noto-Bold.otf" \
        "$NVIDIA_WRAPPER_DIR/nvcuda.dll" \
        "$NVIDIA_WRAPPER_DIR/nvcuvid.dll" \
        "$NVIDIA_WRAPPER_DIR/nvencodeapi64.dll" \
        "$LSMASH_ARTIFACT_DIR/lwinput.aui2" \
        "$LSMASH_ARTIFACT_DIR/lsmash.ini" \
        "$AV1_TEST_FILE"

        require_path "$path"

        or return 1
    end
end

preflight_installation_artifacts
```

1件でも`ERROR`が出た場合は、その場で停止し、次へ進まない。

SHA-256を保存する。

```fish
mkdir -p \
    "$ROOT/evidence/installation"

sha256sum \
    "$DXVK_ARTIFACT_DIR/d3d11.dll" \
    "$DXVK_ARTIFACT_DIR/dxgi.dll" \
    "$DXVK_ARTIFACT_DIR/d3d10core.dll" \
    "$DXVK_ARTIFACT_DIR/d3dcompiler_47.dll" \
    "$NVIDIA_WRAPPER_DIR/nvcuda.dll" \
    "$NVIDIA_WRAPPER_DIR/nvcuvid.dll" \
    "$NVIDIA_WRAPPER_DIR/nvencodeapi64.dll" \
    "$LSMASH_ARTIFACT_DIR/lwinput.aui2" \
    "$LSMASH_ARTIFACT_DIR/lsmash.ini" \
    | tee \
        "$ROOT/evidence/installation/input-SHA256SUMS"
```

---

# 5. 新規Wine prefixを作成する

## 5.1 重要な停止条件

既存prefixを上書きしない。

```fish
if test -e "$PREFIX"
    echo "ERROR: prefix already exists: $PREFIX" >&2
    echo "Choose a new PREFIX for installation." >&2
end
```

`PREFIX`が既に存在する場合は、削除・移動せず、別pathを選ぶ。

## 5.2 bootstrap

空prefixを直接`wineboot -u`した過去の試行では、prefix自体は作成されたものの、`libvkd3d`、`wined3d`、`dxgi`不足が記録された。
そのcommandは最終成功手順として確定していないため、この文書では自動実行しない。

次のどちらかで、GE-Proton 11-1を使用した新規64-bit prefixを作成する。

1. Lutrisなどのfrontendで、runnerを`GE_PROTON_ROOT`へ固定してprefixを作成する
2. Nanashi環境でCLI bootstrap commandを個別に検証し、その結果をIssueへ記録する

作成後、次が存在しなければ停止する。

```fish
for path in \
    "$PREFIX/user.reg" \
    "$PREFIX/system.reg" \
    "$PREFIX/userdef.reg" \
    "$PREFIX/drive_c/windows/system32"

    require_path "$path"
end
```

この工程で別versionのWine、system Wine、別prefixを混ぜない。

---

# 6. AviUtl2本体を配置する

AviUtl2 2.1.2の正規に入手したファイルを`C:\AviUtl2`へ配置する。

```fish
mkdir -p \
    "$PREFIX/drive_c/AviUtl2"

cp -a \
    "$AVIUTL2_SOURCE_DIR/." \
    "$PREFIX/drive_c/AviUtl2/"
```

確認する。

```fish
require_path \
    "$PREFIX/drive_c/AviUtl2/aviutl2.exe"

file \
    "$PREFIX/drive_c/AviUtl2/aviutl2.exe"
```

ProgramData用directoryを作成する。

```fish
mkdir -p \
    "$PREFIX/drive_c/ProgramData/aviutl2/Plugin"
```

AviUtl2本体の入手・展開方法は、配布元の条件に従う。
repositoryへ本体をcommitしない。

---

# 7. patched DXVKを導入する

Wineを停止する。

```fish
stop_prefix_wine
```

4ファイルを同じbuildから配置する。

```fish
function install_dxvk
    set system32 \
        "$PREFIX/drive_c/windows/system32"

    for dll in \
        d3d11 \
        dxgi \
        d3d10core \
        d3dcompiler_47

        install \
            -m 0644 \
            "$DXVK_ARTIFACT_DIR/$dll.dll" \
            "$system32/$dll.dll"

        or return 1
    end
end

install_dxvk
```

DLL overrideを登録する。

```fish
function register_dxvk_overrides
    for dll in \
        d3d11 \
        dxgi \
        d3d10core

        env \
            WINEPREFIX="$PREFIX" \
            LD_LIBRARY_PATH="$GE_LIBS" \
            "$GE_WINE" \
            reg add \
            'HKEY_CURRENT_USER\Software\Wine\DllOverrides' \
            /v "$dll" \
            /d native,builtin \
            /f

        or return 1
    end

    env \
        WINEPREFIX="$PREFIX" \
        LD_LIBRARY_PATH="$GE_LIBS" \
        "$GE_WINE" \
        reg add \
        'HKEY_CURRENT_USER\Software\Wine\DllOverrides' \
        /v d3dcompiler_47 \
        /d native,builtin \
        /f
end

register_dxvk_overrides
```

確認する。

```fish
sha256sum \
    "$PREFIX/drive_c/windows/system32/d3d11.dll" \
    "$PREFIX/drive_c/windows/system32/dxgi.dll" \
    "$PREFIX/drive_c/windows/system32/d3d10core.dll" \
    "$PREFIX/drive_c/windows/system32/d3dcompiler_47.dll"
```

```fish
strings \
    "$PREFIX/drive_c/windows/system32/d3d11.dll" \
    | grep -E \
        'AviUtl2 compatibility|AviUtl2 trace'
```

期待marker:

```text
AviUtl2 compatibility: format 69 unsupported; returning S_OK
```

```fish
env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" \
    reg query \
    'HKEY_CURRENT_USER\Software\Wine\DllOverrides'
```

---

# 8. 日本語フォントを導入する

Wineを停止する。

```fish
stop_prefix_wine
```

フォントを配置する。

```fish
function install_aviutl2_fonts
    set dest_fonts \
        "$PREFIX/drive_c/windows/Fonts"

    mkdir -p \
        "$dest_fonts"

    or return 1

    install \
        -m 0644 \
        "$FONT_SOURCE_DIR/NotoSansCJK-Regular.ttc" \
        "$dest_fonts/NotoSansCJK-Regular.ttc"

    and install \
        -m 0644 \
        "$FONT_SOURCE_DIR/NotoSansCJK-Bold.ttc" \
        "$dest_fonts/NotoSansCJK-Bold.ttc"

    and install \
        -m 0644 \
        "$FONT_SOURCE_DIR/Tahoma-Noto-Regular.otf" \
        "$dest_fonts/Tahoma-Noto-Regular.otf"

    and install \
        -m 0644 \
        "$FONT_SOURCE_DIR/Tahoma-Noto-Bold.otf" \
        "$dest_fonts/Tahoma-Noto-Bold.otf"
end

install_aviutl2_fonts
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
function register_aviutl2_fonts
    env \
        WINEPREFIX="$PREFIX" \
        LD_LIBRARY_PATH="$GE_LIBS" \
        "$GE_WINE" \
        reg add "$REG_FONTS" \
        /v 'Noto Sans CJK JP (TrueType)' \
        /d 'NotoSansCJK-Regular.ttc' \
        /f

    and env \
        WINEPREFIX="$PREFIX" \
        LD_LIBRARY_PATH="$GE_LIBS" \
        "$GE_WINE" \
        reg add "$REG_FONTS" \
        /v 'Noto Sans CJK JP Bold (TrueType)' \
        /d 'NotoSansCJK-Bold.ttc' \
        /f

    and env \
        WINEPREFIX="$PREFIX" \
        LD_LIBRARY_PATH="$GE_LIBS" \
        "$GE_WINE" \
        reg add "$REG_FONTS" \
        /v 'Tahoma (OpenType)' \
        /d 'Tahoma-Noto-Regular.otf' \
        /f

    and env \
        WINEPREFIX="$PREFIX" \
        LD_LIBRARY_PATH="$GE_LIBS" \
        "$GE_WINE" \
        reg add "$REG_FONTS" \
        /v 'Tahoma Bold (OpenType)' \
        /d 'Tahoma-Noto-Bold.otf' \
        /f
end

register_aviutl2_fonts
```

古いTahoma substituteを削除する。

```fish
env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" \
    reg delete "$REG_SUBS" \
    /v Tahoma \
    /f

or true
```

UI aliasesを登録する。

```fish
function register_aviutl2_font_substitutes
    for name in \
        'MS Shell Dlg' \
        'MS Shell Dlg 2'

        env \
            WINEPREFIX="$PREFIX" \
            LD_LIBRARY_PATH="$GE_LIBS" \
            "$GE_WINE" \
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
            LD_LIBRARY_PATH="$GE_LIBS" \
            "$GE_WINE" \
            reg add "$REG_SUBS" \
            /v "$name" \
            /d 'Noto Sans CJK JP' \
            /f

        or return 1
    end
end

register_aviutl2_font_substitutes
```

反映する。

```fish
env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" \
    wineboot -u

and env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINESERVER" \
    -w
```

確認する。

```fish
env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" \
    reg query "$REG_FONTS" \
    /v 'Tahoma (OpenType)'

and env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" \
    reg query "$REG_FONTS" \
    /v 'Noto Sans CJK JP (TrueType)'

and env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" \
    reg query "$REG_SUBS" \
    /v 'MS Shell Dlg'

and env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" \
    reg query "$REG_SUBS" \
    /v 'Yu Gothic UI'
```

期待値:

```text
Tahoma (OpenType)              Tahoma-Noto-Regular.otf
Noto Sans CJK JP (TrueType)    NotoSansCJK-Regular.ttc
MS Shell Dlg                   Tahoma
Yu Gothic UI                   Noto Sans CJK JP
```

---

# 9. NVIDIA Wine wrapperを導入する

Wineを停止する。

```fish
stop_prefix_wine
```

Alex環境では、`system32`の3ファイルはwrapper directoryへのsymlinkだった。
同じ状態を新規prefixに作る。

```fish
function install_nvidia_wrappers
    set system32 \
        "$PREFIX/drive_c/windows/system32"

    for dll in \
        nvcuda \
        nvcuvid \
        nvencodeapi64

        rm -f \
            "$system32/$dll.dll"

        or return 1

        ln -s \
            "$NVIDIA_WRAPPER_DIR/$dll.dll" \
            "$system32/$dll.dll"

        or return 1
    end
end

install_nvidia_wrappers
```

Wine overrideを登録する。

```fish
function register_nvidia_overrides
    for dll in \
        nvcuda \
        nvcuvid \
        nvencodeapi64

        env \
            WINEPREFIX="$PREFIX" \
            LD_LIBRARY_PATH="$GE_LIBS" \
            "$GE_WINE" \
            reg add \
            'HKEY_CURRENT_USER\Software\Wine\DllOverrides' \
            /v "$dll" \
            /d native \
            /f

        or return 1
    end
end

register_nvidia_overrides
```

確認する。

```fish
for dll in \
    nvcuda \
    nvcuvid \
    nvencodeapi64

    ls -l \
        "$PREFIX/drive_c/windows/system32/$dll.dll"

    file \
        "$NVIDIA_WRAPPER_DIR/$dll.dll"

    sha256sum \
        "$PREFIX/drive_c/windows/system32/$dll.dll"

    env \
        WINEPREFIX="$PREFIX" \
        LD_LIBRARY_PATH="$GE_LIBS" \
        "$GE_WINE" \
        reg query \
        'HKEY_CURRENT_USER\Software\Wine\DllOverrides' \
        /v "$dll"
end
```

3件とも`REG_SZ native`であることを確認する。
Wine traceでwrapperが`builtin`と表示されても、それだけで失敗とは判定しない。

---

# 10. custom L-SMASH Works r1284を導入する

Catalogをまだ導入しない場合は、まず直接配置できる。
ただし最終的にはCatalog導入後にもう一度overlayする。

```fish
set PLUGIN_DIR \
    "$PREFIX/drive_c/ProgramData/aviutl2/Plugin"

set ACTIVE_LWINPUT \
    "$PLUGIN_DIR/lwinput.aui2"

set ACTIVE_INI \
    "$PLUGIN_DIR/lsmash.ini"
```

```fish
stop_prefix_wine

mkdir -p \
    "$PLUGIN_DIR"
```

```fish
install \
    -m 0644 \
    "$LSMASH_ARTIFACT_DIR/lwinput.aui2" \
    "$ACTIVE_LWINPUT"

and install \
    -m 0644 \
    "$LSMASH_ARTIFACT_DIR/lsmash.ini" \
    "$ACTIVE_INI"
```

NVDEC設定を固定する。

```fish
sed -i \
    -e 's/^libavsmash_disabled=.*/libavsmash_disabled=1/' \
    -e 's/^libav_disabled=.*/libav_disabled=0/' \
    -e 's/^preferred_decoders=.*/preferred_decoders=av1_cuvid/' \
    "$ACTIVE_INI"
```

確認する。

```fish
sha256sum \
    "$ACTIVE_LWINPUT" \
    "$ACTIVE_INI"
```

```fish
begin
    strings \
        -a \
        -n 6 \
        "$ACTIVE_LWINPUT"

    strings \
        -a \
        -e l \
        -n 6 \
        "$ACTIVE_LWINPUT"
end \
    | grep -E \
        'L-SMASH Works File Reader for AviUtl2 r1284 by Mr-Ojii|av1_cuvid|--enable-cuvid|--enable-decoder=av1_cuvid' \
    | sort \
        -u
```

```fish
grep -nE \
    '^(libavsmash_disabled|libav_disabled|preferred_decoders)=' \
    "$ACTIVE_INI"
```

期待値:

```text
libavsmash_disabled=1
libav_disabled=0
preferred_decoders=av1_cuvid
```

---

# 11. Fcitx5/Mozcを設定する

ホスト側を確認する。

```fish
printf 'XMODIFIERS=%s\n' \
    (printenv XMODIFIERS)

pgrep -a -f \
    'fcitx5|mozc'
```

期待値:

```text
XMODIFIERS=@im=fcitx
fcitx5 process
mozc_server process
```

AviUtl2専用`InputStyle`を登録する。

```fish
env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" \
    reg add \
    'HKCU\Software\Wine\AppDefaults\aviutl2.exe\X11 Driver' \
    /v InputStyle \
    /t REG_SZ \
    /d overthespot \
    /f
```

確認する。

```fish
env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" \
    reg query \
    'HKCU\Software\Wine\AppDefaults\aviutl2.exe\X11 Driver' \
    /v InputStyle
```

期待値:

```text
InputStyle    REG_SZ    overthespot
```

---

# 12. 起動launcherを作る

repositoryのexample launcherを利用する。

```fish
set LAUNCHER \
    "$ROOT/launch-aviutl2.fish"

cp -a \
    "$REPO/scripts/launch-aviutl2.example.fish" \
    "$LAUNCHER"

chmod +x \
    "$LAUNCHER"
```

launcher内のdefault pathが今回の変数と一致しない場合は、実行時環境変数で上書きする。

```fish
env \
    AVIUTL2_ROOT="$ROOT" \
    AVIUTL2_PREFIX="$PREFIX" \
    GE_PROTON_ROOT="$GE_PROTON_ROOT" \
    XMODIFIERS='@im=fcitx' \
    "$LAUNCHER"
```

launcherを使わない直接起動:

```fish
cd \
    "$PREFIX/drive_c/AviUtl2"

env \
    XMODIFIERS='@im=fcitx' \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES="$DLL_OVERRIDES" \
    DXVK_CONFIG_FILE="$DXVK_CONFIG_FILE" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG=-all \
    "$GE_WINE" \
    ./aviutl2.exe
```

起動時に確認する。

```text
メインウィンドウが表示される
日本語UIが読める
format 69のerror dialogが出ない
L-SMASH Works r1284が認識される
```

終了コードだけで成功判定しない。

---

# 13. AviUtl2単体を検証する

## 13.1 AV1/NVDEC

検証ログ:

```fish
set NVDEC_LOG \
    "$ROOT/logs/aviutl2-install-nvdec.log"

mkdir -p \
    "$ROOT/logs"

rm -f \
    "$NVDEC_LOG"
```

```fish
cd \
    "$PREFIX/drive_c/AviUtl2"

env \
    XMODIFIERS='@im=fcitx' \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES="$DLL_OVERRIDES" \
    DXVK_CONFIG_FILE="$DXVK_CONFIG_FILE" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG='-all,+timestamp,+loaddll,+seh' \
    "$GE_WINE" \
    ./aviutl2.exe \
    &> "$NVDEC_LOG"
```

GUIで実施する。

1. AV1 Main 10-bit素材を読み込む
2. 再生する
3. 冒頭へシークする
4. 中央へシークする
5. 終盤へシークする
6. 再度再生する
7. 正常終了する

ログ確認:

```fish
grep -nEi \
    'av1_cuvid|nvcuda|nvcuvid|Cannot load nvcuvid|Failed loading nvcuvid|CUDA_ERROR|av_hwframe_transfer_data failed|Unhandled exception|unhandled page fault' \
    "$NVDEC_LOG" \
    | tail -n 500
```

成功条件:

```text
AV1を読み込める
再生が進む
複数位置へシークできる
複数の [av1_cuvid @ ...] contextがある
nvcuda.dll / nvcuvid.dllのload evidenceがある
Cannot load nvcuvid.dllがない
Failed loading nvcuvid.がない
CUDA initialization failureがない
hardware-frame-transfer failureがない
クラッシュしない
```

次は単独では失敗ではない。

```text
Invalid pkt_timebase, passing timestamps as-is.
The "surfaces" option is deprecated.
```

AV1が再生できただけではNVDEC成功ではない。
`libdav1d` fallbackでも再生できる。

## 13.2 DWrite/Mozc

```fish
set TEXT_LOG \
    "$ROOT/logs/aviutl2-install-text-mozc.log"

rm -f \
    "$TEXT_LOG"
```

```fish
cd \
    "$PREFIX/drive_c/AviUtl2"

env \
    XMODIFIERS='@im=fcitx' \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES="$DLL_OVERRIDES" \
    DXVK_CONFIG_FILE="$DXVK_CONFIG_FILE" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG='-all,+timestamp,+dwrite,+xim,+imm,+seh' \
    "$GE_WINE" \
    ./aviutl2.exe \
    &> "$TEXT_LOG"
```

GUIで実施する。

1. テキストオブジェクトを追加
2. ASCII文字列を入力
3. 一部をマウス選択
4. 文字列内をクリックしてキャレット移動
5. 削除と追加入力
6. `にほんごにゅうりょく`と入力
7. `日本語入力`へ変換
8. Enterで確定
9. 確定済み日本語を再選択・再編集
10. 正常終了

ログ確認:

```fish
grep -nE \
    'dwritetextlayout_HitTest(Point|TextRange)' \
    "$TEXT_LOG" \
    | tail -n 100
```

```fish
grep -nEi \
    'HitTest(Point|TextRange).*stub|E_NOTIMPL|80004001|Unhandled exception|unhandled page fault|C\+\+ exception' \
    "$TEXT_LOG"

or echo "No fatal text-editing errors found."
```

```fish
grep -nEi \
    'requesting L"overthespot"|selected style 0x404' \
    "$TEXT_LOG" \
    | head -n 30
```

成功条件:

```text
HitTestPointが呼ばれる
HitTestTextRangeが呼ばれる
stubではない
E_NOTIMPLがない
overthespot / 0x404が選択される
文字選択できる
キャレット移動できる
Mozc入力・変換・Enter確定できる
確定後に再編集できる
クラッシュしない
```

---

# 14. AviUtl2 Catalog 0.3.3を導入する

## 14.1 変数

```fish
set CATALOG_VERSION \
    "0.3.3"

set CATALOG_REPO \
    "Neosku/aviutl2-catalog"

set CATALOG_CACHE \
    "$ROOT/downloads/aviutl2-catalog-$CATALOG_VERSION"

set CATALOG_LOG_DIR \
    "$ROOT/logs/catalog-installation-"(date +%Y%m%d-%H%M%S)
```

## 14.2 installerを取得する

```fish
mkdir -p \
    "$CATALOG_CACHE" \
    "$CATALOG_LOG_DIR"
```

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
```

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
```

```fish
gh release download \
    "$CATALOG_TAG" \
    --repo "$CATALOG_REPO" \
    --pattern "$CATALOG_ASSET" \
    --dir "$CATALOG_CACHE" \
    --clobber

set CATALOG_INSTALLER \
    "$CATALOG_CACHE/$CATALOG_ASSET"

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

## 14.3 installerを実行する

```fish
stop_prefix_wine
```

```fish
env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='dwrite=b' \
    WINEDEBUG=-all \
    "$GE_WINE" \
    "$CATALOG_INSTALLER" \
    &> "$CATALOG_LOG_DIR/catalog-installer.log"

set INSTALL_STATUS \
    $status

echo "Installer status: $INSTALL_STATUS"
echo "Installer log: $CATALOG_LOG_DIR/catalog-installer.log"
```

`Installer status: 0`を確認する。

Catalog executableを検索する。

```fish
set CATALOG_EXES (
    find \
        "$PREFIX/drive_c" \
        -type f \
        \( \
            -iname 'AviUtl2_Catalog.exe' \
            -o -iname 'aviutl2-catalog.exe' \
        \) \
        -print \
        2>/dev/null
)

printf '%s\n' \
    $CATALOG_EXES
```

1件だけであることを確認し、設定する。

```fish
set CATALOG_EXE \
    "$CATALOG_EXES[1]"
```

## 14.4 初回起動

```fish
env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES="$DLL_OVERRIDES" \
    DXVK_CONFIG_FILE="$DXVK_CONFIG_FILE" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG=-all \
    "$GE_WINE" \
    "$CATALOG_EXE" \
    &> "$CATALOG_LOG_DIR/catalog-first-launch.log"
```

GUIで設定する。

```text
AviUtl2:       インストール済み
AviUtl2 root:  C:\AviUtl2
Portable mode: 無効
```

必要プラグインを導入し、Catalogを通常終了する。

この段階でCatalogが公式L-SMASH Worksを配置しても正常である。
まだ最終状態ではない。

---

# 15. Catalog後にcustom r1284を最後にoverlayする

Catalogを閉じた後、Wineを停止する。

```fish
stop_prefix_wine
```

repositoryにhelperが存在する場合はこれを使用する。

```fish
"$REPO/scripts/install-l-smash-works-nvdec.fish" \
    --prefix \
    "$PREFIX" \
    --artifact-dir \
    "$LSMASH_ARTIFACT_DIR"
```

helperの必須動作:

```text
Mr-Ojii.L-SMASH-Worksをpackage_updates_paused_idsへ追加
custom lwinput.aui2を配置
lsmash.iniを配置
artifactとactive fileの一致を検証
installed.jsonを変更しない
hash-cache.jsonを変更しない
```

helperが現在のcheckoutに存在しない場合は、Catalog統合を完了扱いにしない。
手動で`installed.json`を編集しない。

active pluginを確認する。

```fish
sha256sum \
    "$LSMASH_ARTIFACT_DIR/lwinput.aui2" \
    "$ACTIVE_LWINPUT"

cmp \
    --silent \
    "$LSMASH_ARTIFACT_DIR/lwinput.aui2" \
    "$ACTIVE_LWINPUT"

and echo "MATCH: active lwinput.aui2 is verified r1284"
```

Catalog settingsを検索する。

```fish
set CATALOG_SETTINGS_LIST (
    find \
        "$PREFIX/drive_c/users" \
        -type f \
        -ipath '*/AppData/*/aviutl2-catalog/settings.json' \
        -print \
        2>/dev/null
)

printf '%s\n' \
    $CATALOG_SETTINGS_LIST
```

1件だけであることを確認する。

```fish
set CATALOG_SETTINGS \
    "$CATALOG_SETTINGS_LIST[1]"
```

JSONとpause状態を確認する。

```fish
python3 \
    -m json.tool \
    "$CATALOG_SETTINGS" \
    >/dev/null
```

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
```

---

# 16. Catalog再起動後の保持確認

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
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES="$DLL_OVERRIDES" \
    DXVK_CONFIG_FILE="$DXVK_CONFIG_FILE" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG=-all \
    "$GE_WINE" \
    "$CATALOG_EXE" \
    &> "$CATALOG_LOG_DIR/catalog-after-r1284-overlay.log"
```

次を実行せずに閉じる。

```text
Update
Reinstall
Remove / Uninstall
initial setupからのL-SMASH Works再導入
```

終了後:

```fish
stop_prefix_wine

set R1284_SHA_AFTER_CATALOG (
    sha256sum "$ACTIVE_LWINPUT" \
        | string split ' '
)[1]

echo "Before Catalog: $R1284_SHA_BEFORE_CATALOG"
echo "After Catalog:  $R1284_SHA_AFTER_CATALOG"

if test "$R1284_SHA_BEFORE_CATALOG" = "$R1284_SHA_AFTER_CATALOG"
    echo "SUCCESS: Catalog did not replace custom r1284"
else
    echo "ERROR: Catalog replaced custom r1284" >&2
end
```

期待値:

```text
Before Catalog:
  db465570a4c049624f369086232cf47c387975d54fa615d895d090fe1a17bbe0

After Catalog:
  db465570a4c049624f369086232cf47c387975d54fa615d895d090fe1a17bbe0
```

---

# 17. Lutrisへ登録する

LutrisではWine Runnerに自動選択させず、**Linux Runnerから固定launcherを起動する**。

設定例:

```text
Runner:
  Linux

Executable:
  /home/USER/Games/aviutl2/launch-aviutl2.fish

Working directory:
  /home/USER/Games/aviutl2/prefix/drive_c/AviUtl2
```

launcherが参照する値:

```text
AVIUTL2_ROOT
AVIUTL2_PREFIX
GE_PROTON_ROOT
```

Lutris、UMU、Wine Runnerの自動更新や自動DXVK導入によって、固定済みrunner、prefix、DLLを置き換えない。

---

# 18. インストール完了条件

同一prefix、同一runnerで次をすべて満たす。

## 18.1 起動

```text
AviUtl2メインウィンドウが表示される
日本語UIが読める
format 69 error dialogが出ない
通常終了できる
```

## 18.2 DWrite/Mozc

```text
テキストオブジェクトを追加できる
文字選択できる
キャレット移動できる
再編集できる
にほんごにゅうりょく → 日本語入力へ変換できる
Enter確定できる
HitTestPointがstubではない
HitTestTextRangeがstubではない
E_NOTIMPLがない
```

## 18.3 AV1/NVDEC

```text
AV1 Main 10-bitを読み込める
再生できる
冒頭・中央・終盤へシークできる
複数のactive av1_cuvid contextがある
nvcuvid load failureがない
CUDA initialization failureがない
hardware-frame-transfer failureがない
```

## 18.4 Catalog

```text
Catalog 0.3.3が起動する
AviUtl2 rootがC:\AviUtl2
Portable modeが無効
Mr-Ojii.L-SMASH-Worksがpaused
custom r1284がactive
Catalog再起動前後でSHA-256が同じ
```

---

# 19. インストール完了後のcheckpoint

すべての検証に合格した後にのみ作成する。

```fish
stop_prefix_wine

set FINAL_STAMP \
    (date +%Y%m%d-%H%M%S)

set FINAL_CHECKPOINT \
    "$PREFIX.installed-ok-$FINAL_STAMP"

cp -a \
    --reflink=auto \
    "$PREFIX" \
    "$FINAL_CHECKPOINT"

echo "Final installation checkpoint:"
echo "$FINAL_CHECKPOINT"
```

runnerのSHAも保存する。

```fish
sha256sum \
    "$GE_PROTON_ROOT/files/lib/wine/x86_64-windows/dwrite.dll" \
    "$PREFIX/drive_c/windows/system32/d3d11.dll" \
    "$PREFIX/drive_c/windows/system32/dxgi.dll" \
    "$PREFIX/drive_c/windows/system32/d3d10core.dll" \
    "$PREFIX/drive_c/windows/system32/d3dcompiler_47.dll" \
    "$PREFIX/drive_c/windows/system32/nvcuda.dll" \
    "$PREFIX/drive_c/windows/system32/nvcuvid.dll" \
    "$PREFIX/drive_c/windows/system32/nvencodeapi64.dll" \
    "$ACTIVE_LWINPUT" \
    "$ACTIVE_INI" \
    | tee \
        "$ROOT/evidence/installation/final-SHA256SUMS"
```

---

# 20. 絶対に行わない操作

```text
system Wineとpatched GE-Protonを混ぜる
別prefixへ途中で切り替える
異なるDXVK buildのDLLを混ぜる
LutrisにDXVKを自動上書きさせる
AV1が再生できただけでNVDEC成功と判定する
Catalog導入後の公式L-SMASH Worksを最終状態とする
installed.jsonをr1284へ手動変更する
hash-cache.jsonを削除・手動編集する
CatalogでL-SMASH WorksをUpdateする
CatalogでL-SMASH WorksをReinstallする
CatalogでL-SMASH WorksをRemoveする
```

---

# 21. 未解決のインストール工程

このINSTALLATION.mdを完全なclean-room手順にするには、次を別環境で実測する必要がある。

1. GE-Proton 11-1の取得commandとSHA-256
2. stock runnerからpatched runnerをゼロから作る全command
3. Wine source/build treeの初回configure command
4. 空prefixをCLIだけで正常bootstrapするcommand
5. AviUtl2 2.1.2の公式取得から`C:\AviUtl2`配置までのcommand
6. `Tahoma-Noto-*.otf`の合法かつ再現可能な生成方法
7. NVIDIA Wine wrapperの取得元、version、展開command
8. NVIDIA driverとVulkan ICDのpreflight
9. Nanashi環境でのLutris Linux Runner登録commandまたはexport可能な設定
10. clean prefixで最初から最後まで通した最終ログ

これらが確認されるまでは、この文書を「prepared artifactsからの新規prefix install手順」として扱う。
復旧手順としては扱わない。

---

# 22. 関連文書

```text
docs/INSTALLATION.md
  新規prefixへの導入

docs/REPRODUCTION.md
  source build、元環境の再現、実機検証

docs/L-SMASH-WORKS-NVDEC.md
  custom r1284/NVDECの詳細

docs/TROUBLESHOOTING.md
  既知障害と切り分け

docs/AVIUTL2-COMMAND-LEDGER-BUNDLE/
  実行済みcommandの監査資料
```
