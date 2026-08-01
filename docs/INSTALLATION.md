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
- 空prefixをCLIだけで生成する単独の確定済みcommand

この文書では、それらを推測で補わない。
必要artifactを揃えた後の**新規prefixへの導入**を主対象とする。


NVEncのAV1/HEVC出力分岐は、NVIDIA Video Codec SDKとNVEncCの`--check-features`に基づいて選択する。
Alex環境のRTX 4060 TiではAV1 NVENCを選択できるが、HEVC分岐を含むAviUtl2からの最終出力検証はNanashi環境で追加確認する。
NVDECの入力デコード分岐とNVENCの出力エンコード分岐を混同しない。

## 0.1 CachyOS / Arch Linuxの依存関係

この文書のコマンドはFishを前提にする。
まず、実行・取得・検証に使用するpackageを導入する。

```fish
sudo pacman -S --needed \
    fish \
    git \
    curl \
    tar \
    libarchive \
    python \
    github-cli \
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

Lutrisから固定launcherを登録する場合は、追加で導入する。

```fish
sudo pacman -S --needed \
    lutris
```

DXVK、Wine DWrite、L-SMASH Worksをsourceからbuildする場合のみ、次も導入する。
prepared artifactを配置するだけなら、このbuild dependency節は省略できる。

```fish
sudo pacman -S --needed \
    base-devel \
    autoconf \
    automake \
    libtool \
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

導入後、主要commandが解決できることを確認する。

```fish
for command_name in \
    fish \
    git \
    curl \
    tar \
    bsdtar \
    python3 \
    gh \
    file \
    strings \
    sha256sum \
    vulkaninfo \
    nvidia-smi

    command -q "$command_name"

    or echo "MISSING COMMAND: $command_name" >&2
end
```

source buildも行う場合は、追加で確認する。

```fish
for command_name in \
    make \
    cmake \
    meson \
    ninja \
    nasm \
    pkg-config \
    x86_64-w64-mingw32-gcc \
    x86_64-w64-mingw32-g++ \
    x86_64-w64-mingw32-ar \
    x86_64-w64-mingw32-ranlib \
    x86_64-w64-mingw32-strip \
    x86_64-w64-mingw32-windres \
    x86_64-w64-mingw32-objdump

    command -q "$command_name"

    or echo "MISSING BUILD COMMAND: $command_name" >&2
end
```

## 0.2 repositoryを取得する

```fish
set PROJECTS_DIR \
    "$HOME/projects"

set REPO \
    "$PROJECTS_DIR/aviutl2-linux-patches"

mkdir -p \
    "$PROJECTS_DIR"

if not test -d "$REPO/.git"
    git clone \
        https://github.com/AlexanderGG-0520/aviutl2-linux-patches.git \
        "$REPO"
end

cd \
    "$REPO"

git status \
    --short \
    --branch
```

既にclone済みの場合は、作業中の変更を破棄せずに状態を確認してから更新する。

## 0.3 GE-Proton 11-1を固定取得する

`latest`を取得してはいけない。
成功環境で使用した`GE-Proton11-1`のx86-64 archiveと、同じreleaseのchecksumを取得する。

```fish
set GE_DOWNLOAD_DIR \
    "/tmp/ge-proton11-1"

set GE_BASE \
    "$HOME/.local/share/Steam/compatibilitytools.d"

set GE_ARCHIVE \
    "$GE_DOWNLOAD_DIR/GE-Proton11-1.tar.gz"

set GE_CHECKSUM \
    "$GE_DOWNLOAD_DIR/GE-Proton11-1.sha512sum"

mkdir -p \
    "$GE_DOWNLOAD_DIR" \
    "$GE_BASE"
```

```fish
curl \
    --fail \
    --location \
    --retry 3 \
    --output "$GE_ARCHIVE" \
    "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton11-1/GE-Proton11-1.tar.gz"

and curl \
    --fail \
    --location \
    --retry 3 \
    --output "$GE_CHECKSUM" \
    "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton11-1/GE-Proton11-1.sha512sum"
```

checksum fileはarchiveのbasenameを参照するため、download directory内で検証する。

```fish
pushd \
    "$GE_DOWNLOAD_DIR"

sha512sum \
    -c \
    GE-Proton11-1.sha512sum

set GE_VERIFY_STATUS \
    $status

popd

test $GE_VERIFY_STATUS -eq 0
```

`GE-Proton11-1.tar.gz: OK`を確認してから展開する。

```fish
if not test -d "$GE_BASE/GE-Proton11-1"
    tar \
        -xzf "$GE_ARCHIVE" \
        -C "$GE_BASE"
end
```

展開結果を確認する。

```fish
set GE_STOCK_ROOT \
    "$GE_BASE/GE-Proton11-1"

set GE_STOCK_LIBS \
    "$GE_STOCK_ROOT/files/lib64:$GE_STOCK_ROOT/files/lib:$GE_STOCK_ROOT/files/lib/wine/x86_64-unix:$GE_STOCK_ROOT/files/lib/wine/i386-unix"

file \
    "$GE_STOCK_ROOT/files/lib/wine/x86_64-unix/wine"

env \
    LD_LIBRARY_PATH="$GE_STOCK_LIBS" \
    "$GE_STOCK_ROOT/files/lib/wine/x86_64-unix/wine" \
    --version
```

この時点ではまだstock runnerである。
`REPRODUCTION.md`のWine DWrite節に従ってpatched `dwrite.dll`を導入し、別名のrunnerへ固定してから本手順を続行する。

> GE-Proton upstreamは、Steam外のnon-Steam applicationをProtonとして起動する場合はUMU経由をsupport対象としている。このprojectで直接`files/lib/wine/x86_64-unix/wine`を呼ぶ構成は、実機で成功したproject固有の固定構成であり、GE-Proton upstreamのsupport範囲とは区別する。

## 0.4 curlで取得してよいもの・取得元未確定のもの

現時点で固定URLと検証方法を記載できるのは、少なくとも次である。

```text
AviUtl2 2.1.2 official ZIP
GE-Proton 11-1 archive
GE-Proton 11-1 SHA-512 checksum
GitHub API / release assets used by AviUtl2 Catalog
```

次については、取得元・再配布条件・生成方法をまだ完全に確定できていないため、架空のcurl commandを追加しない。

```text
Tahoma-Noto-Regular.otf
Tahoma-Noto-Bold.otf
nvidia-libs-v1.0.2 wrapper bundle
prepared patched DXVK binary bundle
prepared patched GE-Proton runner bundle
```

これらの取得方法が確定した時点で、URL、version、checksum、licenseまたは配布条件をセットで追記する。

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
└── source-built custom L-SMASH Works r1284 output
        ↓
new Wine prefix
        ↓
AviUtl2 Catalog 0.3.3
        ↓
NVEnc output plugin
├── AV1 NVENC branch
└── HEVC NVENC branch
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
12. NVEncを導入し、`--check-features`でAV1またはHEVCを選択
13. 選択したNVENC codecで短い出力試験を行う
14. custom r1284を最後に再配置
15. 最終検証

---

# 2. 必要artifact

インストール開始前に、次を用意する。

## 2.1 AviUtl2 2.1.2本体を公式サイトから取得する

AviUtl2本体はrepositoryへ再配布せず、ＫＥＮくんの公式サイトからZIP版を直接取得する。
公式配布ページでは2.1.2のZIPが`aviutl2_v2.1.2.zip`として公開されている。

次のfunctionは、公式ZIPを取得し、展開結果から`aviutl2.exe`を検出して、標準artifact directoryへ正規化する。

```fish
function prepare_aviutl2_212
    set -l root \
        "$HOME/Games/aviutl2"

    set -l download_dir \
        "$root/downloads"

    set -l archive \
        "$download_dir/aviutl2_v2.1.2.zip"

    set -l extract_dir \
        "$root/build/aviutl2-v2.1.2-extract"

    set -l artifact_dir \
        "$root/artifacts/AviUtl2-2.1.2"

    mkdir -p \
        "$download_dir" \
        "$root/build" \
        "$root/artifacts"

    or return 1

    curl \
        --fail \
        --location \
        --retry 3 \
        --output "$archive" \
        "https://spring-fragrance.mints.ne.jp/aviutl/aviutl2_v2.1.2.zip"

    or return 1

    sha256sum \
        "$archive"

    rm -rf \
        "$extract_dir"

    mkdir -p \
        "$extract_dir"

    or return 1

    bsdtar \
        -xf "$archive" \
        -C "$extract_dir"

    or return 1

    set -l aviutl2_exe \
        (find "$extract_dir" \
            -type f \
            -iname 'aviutl2.exe' \
            -print \
            -quit)

    if test -z "$aviutl2_exe"
        echo "ERROR: aviutl2.exe was not found in: $archive" >&2
        return 1
    end

    rm -rf \
        "$artifact_dir"

    mkdir -p \
        "$artifact_dir"

    or return 1

    cp -a \
        (dirname "$aviutl2_exe")/. \
        "$artifact_dir/"

    or return 1

    test -f \
        "$artifact_dir/aviutl2.exe"

    or begin
        echo "ERROR: normalized aviutl2.exe is missing" >&2
        return 1
    end

    file \
        "$artifact_dir/aviutl2.exe"

    echo "AviUtl2 artifact: $artifact_dir"
end

prepare_aviutl2_212
```

正常に完了すると、少なくとも次が存在する。

```text
$HOME/Games/aviutl2/artifacts/AviUtl2-2.1.2/aviutl2.exe
```

公式サイトはプログラムファイルの不特定多数への再配布を控えるよう案内している。
取得したZIPや展開済み本体を、このpatch repositoryへcommitしない。

AviUtl2本体以外に、インストール開始前に次のartifactも必要になる。

```text
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

## 2.6 NVEnc output plugin

CatalogからAviUtl2 2対応のNVEnc output pluginを導入する。
導入後、prefix内に次が存在する必要がある。

```text
C:\ProgramData\aviutl2\Plugin\exe_files\NVEncC\...\NVEncC64.exe
```

codecの選択はGPU名だけで決めず、実際のdriverが返す`NVEncC64.exe --check-features`を正本にする。

```text
AV1 Encodeがsupported:
  AV1 NVENC branch

AV1 Encodeがunsupported、HEVC Encodeがsupported:
  HEVC NVENC branch

AV1とHEVCの両方がunsupported:
  NVENC出力工程を停止
```

NVIDIAのNVENC仕様では、AV1 encodeはAda世代以降、HEVC Main profileは第2世代Maxwell以降が基本となる。
HEVC Main10はPascal世代以降が基本となるが、最終判断は`--check-features`の実測結果を使用する。

仕様根拠:

```text
NVIDIA Video Codec SDK 13.1 — NVENC Application Note
NVIDIA Video Codec SDK 13.1 — NVENC Video Encoder API Programming Guide
rigaya/NVEnc — Readme / --check-features
```

AV1/HEVCの分岐は**出力エンコード**の分岐である。
`av1_cuvid`を使うL-SMASH Worksの節は**入力デコード**の検証であり、別の機能として扱う。

## 2.7 L-SMASH Works r1284をsourceから完全buildする

このrepositoryには、固定commitの依存関係を取得し、MinGW-w64でcross-buildして、最終的な`lwinput.aui2`まで生成するscriptを収録する。

```text
scripts/scripts/build-l-smash-works-nvdec.fish
```

このscriptは次を一括して行う。

1. L-SMASH Worksを検証済みbase commitへ固定する
2. repositoryのhardware-frame-transfer patchを`git am`で適用する
3. revision生成に必要なL-SMASH Worksの全履歴を取得する
4. zlib、game-music-emu、dav1d、libvpx、nv-codec-headers、libvplをcross-buildする
5. FFmpegを`av1_cuvid`有効でcross-buildする
6. obuparseとl-smashをcross-buildする
7. patched L-SMASH Works r1284をbuildする
8. `lwinput.aui2`と`config/lsmash.ini`をoutput directoryへ配置する
9. r1284表記、CUVID configure marker、PE32+形式を検証する
10. `PROVENANCE.txt`と`SHA256SUMS`を生成する

使用するpatch:

```text
patches/l-smash-works/0001-transfer-hardware-frames-before-output.patch
```

このpatchは、CUVIDなどのhardware decoderが返すGPU上のframeを、出力処理の前に`av_hwframe_transfer_data()`でsoftware frameへ転送する。

### 2.7.1 build依存関係を確認する

0.1節のsource-build packageを導入済みであることを確認する。

```fish
for command_name in \
    git \
    cmake \
    meson \
    ninja \
    nasm \
    make \
    pkg-config \
    nproc \
    file \
    strings \
    sha256sum \
    x86_64-w64-mingw32-gcc \
    x86_64-w64-mingw32-g++ \
    x86_64-w64-mingw32-ar \
    x86_64-w64-mingw32-ranlib \
    x86_64-w64-mingw32-strip \
    x86_64-w64-mingw32-windres \
    x86_64-w64-mingw32-objdump

    command -q "$command_name"

    or echo "MISSING BUILD COMMAND: $command_name" >&2
end
```

不足がある状態でbuildへ進まない。

### 2.7.2 fresh work directoryで完全buildする

GitHub Contents APIで追加されたfileは実行bitを持たない場合があるため、直接実行ではなく`fish`へ渡す。

```fish
set REPO \
    "$HOME/projects/aviutl2-linux-patches"

set LSMASH_WORK \
    "$HOME/Games/aviutl2/build/l-smash-works-nvdec-repro-03"

fish \
    "$REPO/scripts/scripts/build-l-smash-works-nvdec.fish" \
    --work-dir "$LSMASH_WORK" \
    --jobs (nproc)
```

scriptは既存work directoryを再利用しない。同名directoryが存在する場合は、中身を確認せず削除せず、別名のfresh directoryを指定する。

```fish
set LSMASH_WORK \
    "$HOME/Games/aviutl2/build/l-smash-works-nvdec-repro-04"

fish \
    "$REPO/scripts/scripts/build-l-smash-works-nvdec.fish" \
    --work-dir "$LSMASH_WORK" \
    --jobs (nproc)
```

### 2.7.3 固定source identity

| Component | Commit |
| --- | --- |
| L-SMASH Works base | `a47764915f06fcd472e26ba2fbf25aff4b9d252e` |
| L-SMASH Works patched | `393df5ef669707f776261e4ac1bcc7e9a9a227ab` |
| zlib | `da607da739fa6047df13e66a2af6b8bec7c2a498` |
| game-music-emu | `fe8da4b6d3876d7542c2fb69d94487e19836d678` |
| dav1d | `54706fc6bc0cdecab7e9593974a4039cc038fca7` |
| libvpx | `ade52487a37ef76a0f209bd39bea9fe67d6db4c4` |
| nv-codec-headers | `eddcea9e27f6b772057c9b3f87de2cc1737faffc` |
| libvpl | `674d015bcb294bc39fa276e99a652ea045423e82` |
| FFmpeg | `cfa62de001af8ffeb7e22561f246469c7b809951` |
| obuparse | `c2156b4a133714d0a9c04a7cd341efb1af415a33` |
| l-smash | `04315d02fef15a75f747493920724c91a62b8538` |

L-SMASH Worksのbase revision countは`1283`、patch適用後は`1284`でなければscriptが停止する。

### 2.7.4 生成物を確認する

成功時は次が生成される。

```text
$HOME/Games/aviutl2/build/l-smash-works-nvdec-repro-03/output/
├── lwinput.aui2
├── lsmash.ini
├── PROVENANCE.txt
└── SHA256SUMS
```

```fish
set LSMASH_OUTPUT \
    "$HOME/Games/aviutl2/build/l-smash-works-nvdec-repro-03/output"

for file_path in \
    "$LSMASH_OUTPUT/lwinput.aui2" \
    "$LSMASH_OUTPUT/lsmash.ini" \
    "$LSMASH_OUTPUT/PROVENANCE.txt" \
    "$LSMASH_OUTPUT/SHA256SUMS"

    test -s "$file_path"

    or echo "MISSING OR EMPTY: $file_path" >&2
end

sha256sum \
    -c \
    "$LSMASH_OUTPUT/SHA256SUMS"
```

binary markerを再確認する。

```fish
begin
    strings -a -n 5 "$LSMASH_OUTPUT/lwinput.aui2"
    strings -a --encoding=l -n 5 "$LSMASH_OUTPUT/lwinput.aui2"
end \
    | grep -E \
        'L-SMASH Works File Reader for AviUtl2 r1284 by Mr-Ojii|--enable-cuvid|--enable-decoder=av1_cuvid'
```

最低限、次の3種類が確認できること。

```text
L-SMASH Works File Reader for AviUtl2 r1284 by Mr-Ojii
--enable-cuvid
--enable-decoder=av1_cuvid
```

Alex環境の最終repro-03で得たartifact:

```text
lwinput.aui2 SHA-256:
  db465570a4c049624f369086232cf47c387975d54fa615d895d090fe1a17bbe0

lsmash.ini SHA-256:
  10620155d1470ea270121f67357f3da89cb8151ffac651c049e98238253a9a9f
```

absolute build prefixやtoolchain versionが異なる場合、機能的に同一でも`lwinput.aui2`のSHA-256は一致しないことがある。
SHA不一致だけで失敗とせず、`PROVENANCE.txt`、固定commit、r1284 marker、CUVID marker、runtime NVDEC検証を組み合わせて判定する。

build scriptはWine prefixへpluginをインストールしない。生成物をprefixへ配置する工程は、後続のL-SMASH Works導入節で行う。
---

# 3. Fish変数と標準ディレクトリ配置

この文書では、入力artifactをすべて`$HOME/Games/aviutl2/artifacts`へ配置する。
`/home/alex`や日時付きbackup directoryへ読み替えず、まず次の標準値をそのまま使用する。

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
    "$ARTIFACT_ROOT/AviUtl2-2.1.2"

set DXVK_ARTIFACT_DIR \
    "$ARTIFACT_ROOT/dxvk-2.7.1-aviutl2/x64"

set FONT_SOURCE_DIR \
    "$ARTIFACT_ROOT/fonts"

set NVIDIA_WRAPPER_DIR \
    "$ARTIFACT_ROOT/nvidia-libs-v1.0.2/x64"

set LSMASH_ARTIFACT_DIR \
    "$ROOT/build/l-smash-works-nvdec-repro-03/output"

set TEST_MEDIA_DIR \
    "$ROOT/test-media"

set AV1_TEST_FILE \
    "$TEST_MEDIA_DIR/av1-main10-test.mp4"

set NVENC_TEST_DIR \
    "$ROOT/test-output/nvenc"

set NVENC_FEATURE_LOG \
    "$ROOT/logs/nvencc-check-features.log"

set GE_PROTON_ROOT \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set GE_WINE \
    "$GE_PROTON_ROOT/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_PROTON_ROOT/files/bin/wineserver"

set GE_LIBS \
    "$GE_PROTON_ROOT/files/lib64:$GE_PROTON_ROOT/files/lib:$GE_PROTON_ROOT/files/lib/wine/x86_64-unix:$GE_PROTON_ROOT/files/lib/wine/i386-unix"

set DXVK_CONFIG_FILE \
    "$ROOT/nvidia-dxvk.conf"

set DLL_OVERRIDES \
    'nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'
```

標準ディレクトリを作成する。

```fish
mkdir -p \
    "$AVIUTL2_SOURCE_DIR" \
    "$DXVK_ARTIFACT_DIR" \
    "$FONT_SOURCE_DIR" \
    "$NVIDIA_WRAPPER_DIR" \
    "$TEST_MEDIA_DIR" \
    "$NVENC_TEST_DIR" \
    "$ROOT/logs" \
    "$ROOT/build"
```

配置後の構造は次のようにする。

```text
$HOME/Games/aviutl2/
├── artifacts/
│   ├── AviUtl2-2.1.2/
│   │   └── aviutl2.exe
│   ├── dxvk-2.7.1-aviutl2/
│   │   └── x64/
│   │       ├── d3d11.dll
│   │       ├── dxgi.dll
│   │       ├── d3d10core.dll
│   │       └── d3dcompiler_47.dll
│   ├── fonts/
│   │   ├── NotoSansCJK-Regular.ttc
│   │   ├── NotoSansCJK-Bold.ttc
│   │   ├── Tahoma-Noto-Regular.otf
│   │   └── Tahoma-Noto-Bold.otf
│   └── nvidia-libs-v1.0.2/
│       └── x64/
│           ├── nvcuda.dll
│           ├── nvcuvid.dll
│           └── nvencodeapi64.dll
├── build/
│   └── l-smash-works-nvdec-repro-03/
│       └── output/
│           ├── lwinput.aui2
│           └── lsmash.ini
├── test-media/
│   └── av1-main10-test.mp4
└── test-output/
    └── nvenc/
```

2.1節の`prepare_aviutl2_212`は、ZIP内のdirectory構造にかかわらず、`aviutl2.exe`を含むdirectoryを次へ正規化する。

```text
$HOME/Games/aviutl2/artifacts/AviUtl2-2.1.2/aviutl2.exe
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
    cp \
    find \
    file \
    grep \
    install \
    mkdir \
    python3 \
    sha256sum \
    strings

    command -q "$command_name"

    or begin
        echo "ERROR: missing command: $command_name" >&2
        false
    end
end
```

## 4.3 path確認

```fish
for path in \
    "$GE_WINE" \
    "$GE_WINESERVER" \
    "$GE_PROTON_ROOT/files/lib/wine/x86_64-windows/dwrite.dll" \
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
    "$AV1_TEST_FILE" \
    "$DXVK_CONFIG_FILE"

    require_path \
        "$path"

    or false
end
```

## 4.4 file identityを記録する

```fish
mkdir -p \
    "$ROOT/evidence/install"

sha256sum \
    "$GE_PROTON_ROOT/files/lib/wine/x86_64-windows/dwrite.dll" \
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
    "$AV1_TEST_FILE" \
    > "$ROOT/evidence/install/input-sha256.txt"
```

---

# 5. 新規Wine prefixを作成する

## 5.1 runnerを固定する

stock GE-Proton directoryを直接編集しない。
patched runnerは次の固定名へ配置する。

```text
$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test
```

このdirectoryへpatched `dwrite.dll`を配置済みである必要がある。

```fish
sha256sum \
    "$GE_PROTON_ROOT/files/lib/wine/x86_64-windows/dwrite.dll"
```

Alex環境の期待値:

```text
0b9f579547233d09c859361f0a31d572591dbe6207480c33a1e6773d677fbb3c
```

一致しない場合、byte-for-byte reproductionではない。
別buildを使用する場合は、そのsource commitとSHA-256を記録する。

## 5.2 prefix directoryを作る

```fish
if test -e "$PREFIX"
    echo "ERROR: prefix already exists: $PREFIX" >&2
    false
else
    mkdir -p \
        "$PREFIX"
end
```

この空directoryだけでWine prefixの初期化が完了したとは扱わない。
次の初回Wine commandまたは`wineboot -u`によってregistryと標準directoryが作られる。

```fish
env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" \
    wineboot \
    -u
```

runnerにより`wineboot`の呼び出し方法が異なる場合は、ここで停止してrunner内の実体を確認する。

```fish
find \
    "$GE_PROTON_ROOT/files" \
    -maxdepth 4 \
    -type f \
    -iname 'wineboot*' \
    -o \
    -iname 'wine*'
```

初期化後:

```fish
env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINESERVER" \
    -w
```

次が作成されたことを確認する。

```fish
for path in \
    "$PREFIX/user.reg" \
    "$PREFIX/system.reg" \
    "$PREFIX/userdef.reg" \
    "$PREFIX/drive_c/windows/system32"

    require_path \
        "$path"

    or false
end
```

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

確認:

```fish
file \
    "$PREFIX/drive_c/AviUtl2/aviutl2.exe"

sha256sum \
    "$PREFIX/drive_c/AviUtl2/aviutl2.exe"
```

portable mode用`data` directoryは作らない。
この手順ではnon-portable modeを使用し、plugin dataを`C:\ProgramData\aviutl2`へ配置する。

AviUtl2本体の入手・展開方法は、配布元の条件に従う。

---

# 7. patched DXVKを配置する

## 7.1 Wineを停止する

```fish
stop_prefix_wine
```

## 7.2 DLLを配置する

```fish
for dll in \
    d3d11.dll \
    dxgi.dll \
    d3d10core.dll \
    d3dcompiler_47.dll

    install \
        -m 0644 \
        "$DXVK_ARTIFACT_DIR/$dll" \
        "$PREFIX/drive_c/windows/system32/$dll"

    or false
end
```

32-bit AviUtl2 DLLは導入しない。
AviUtl2 2.1.2は64-bitである。

## 7.3 SHA-256を確認する

```fish
sha256sum \
    "$PREFIX/drive_c/windows/system32/d3d11.dll" \
    "$PREFIX/drive_c/windows/system32/dxgi.dll" \
    "$PREFIX/drive_c/windows/system32/d3d10core.dll" \
    "$PREFIX/drive_c/windows/system32/d3dcompiler_47.dll"
```

## 7.4 patched behaviorを確認する

artifact内にpatch markerがある場合:

```fish
strings \
    "$PREFIX/drive_c/windows/system32/d3d11.dll" \
    | grep -E \
        'AviUtl2 compatibility|AviUtl2 trace'
```

期待されるbehavior:

```text
AviUtl2 compatibility: format 69 unsupported; returning S_OK
```

markerの有無だけではruntime successにならない。
実起動時に確認する。

---

# 8. 日本語フォントを配置する

## 8.1 ファイルを配置する

```fish
set WINDOWS_FONTS \
    "$PREFIX/drive_c/windows/Fonts"

mkdir -p \
    "$WINDOWS_FONTS"

install \
    -m 0644 \
    "$FONT_SOURCE_DIR/NotoSansCJK-Regular.ttc" \
    "$WINDOWS_FONTS/NotoSansCJK-Regular.ttc"

and install \
    -m 0644 \
    "$FONT_SOURCE_DIR/NotoSansCJK-Bold.ttc" \
    "$WINDOWS_FONTS/NotoSansCJK-Bold.ttc"

and install \
    -m 0644 \
    "$FONT_SOURCE_DIR/Tahoma-Noto-Regular.otf" \
    "$WINDOWS_FONTS/Tahoma-Noto-Regular.otf"

and install \
    -m 0644 \
    "$FONT_SOURCE_DIR/Tahoma-Noto-Bold.otf" \
    "$WINDOWS_FONTS/Tahoma-Noto-Bold.otf"
```

## 8.2 font registryを設定する

```fish
set REG_FONTS \
    'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Fonts'

set REG_SUBS \
    'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\FontSubstitutes'
```

```fish
env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" \
    reg \
    add "$REG_FONTS" \
    /v 'Noto Sans CJK JP (TrueType)' \
    /t REG_SZ \
    /d 'NotoSansCJK-Regular.ttc' \
    /f

and env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" \
    reg \
    add "$REG_FONTS" \
    /v 'Noto Sans CJK JP Bold (TrueType)' \
    /t REG_SZ \
    /d 'NotoSansCJK-Bold.ttc' \
    /f

and env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" \
    reg \
    add "$REG_FONTS" \
    /v 'Tahoma (OpenType)' \
    /t REG_SZ \
    /d 'Tahoma-Noto-Regular.otf' \
    /f

and env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" \
    reg \
    add "$REG_FONTS" \
    /v 'Tahoma Bold (OpenType)' \
    /t REG_SZ \
    /d 'Tahoma-Noto-Bold.otf' \
    /f
```

## 8.3 font substitutionsを設定する

```fish
for font in \
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
        reg \
        add "$REG_SUBS" \
        /v "$font" \
        /t REG_SZ \
        /d 'Noto Sans CJK JP' \
        /f

    or false
end
```

```fish
for font in \
    'MS Shell Dlg' \
    'MS Shell Dlg 2'

    env \
        WINEPREFIX="$PREFIX" \
        LD_LIBRARY_PATH="$GE_LIBS" \
        "$GE_WINE" \
        reg \
        add "$REG_SUBS" \
        /v "$font" \
        /t REG_SZ \
        /d 'Tahoma' \
        /f

    or false
end
```

old `Tahoma` substituteがある場合は削除する。

```fish
env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" \
    reg \
    delete "$REG_SUBS" \
    /v 'Tahoma' \
    /f \
    2>/dev/null

or true
```

## 8.4 registry更新を反映する

```fish
env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" \
    wineboot \
    -u

and env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINESERVER" \
    -w
```

---

# 9. NVIDIA Wine wrapperを配置する

## 9.1 system32へsymlinkする

```fish
stop_prefix_wine

for dll in \
    nvcuda.dll \
    nvcuvid.dll \
    nvencodeapi64.dll

    ln -sfn \
        "$NVIDIA_WRAPPER_DIR/$dll" \
        "$PREFIX/drive_c/windows/system32/$dll"

    or false
end
```

## 9.2 symlinkを確認する

```fish
for dll in \
    nvcuda.dll \
    nvcuvid.dll \
    nvencodeapi64.dll

    readlink -f \
        "$PREFIX/drive_c/windows/system32/$dll"
end
```

## 9.3 native overrideを登録する

```fish
set REG_OVERRIDES \
    'HKEY_CURRENT_USER\Software\Wine\DllOverrides'

for dll in \
    nvcuda \
    nvcuvid \
    nvencodeapi64

    env \
        WINEPREFIX="$PREFIX" \
        LD_LIBRARY_PATH="$GE_LIBS" \
        "$GE_WINE" \
        reg \
        add "$REG_OVERRIDES" \
        /v "$dll" \
        /t REG_SZ \
        /d 'native' \
        /f

    or false
end
```

Wine traceでこれらが`builtin`と表示される場合がある。
その表示だけを理由にoverrideやsymlinkを変更しない。
NVDEC runtime logと組み合わせて判定する。

---

# 10. custom L-SMASH Works r1284を配置する

## 10.1 ProgramData plugin directoryを作る

```fish
set PROGRAMDATA \
    "$PREFIX/drive_c/ProgramData/aviutl2"

set PLUGIN_DIR \
    "$PROGRAMDATA/Plugin"

mkdir -p \
    "$PLUGIN_DIR"
```

## 10.2 pluginとINIを配置する

```fish
install \
    -m 0644 \
    "$LSMASH_ARTIFACT_DIR/lwinput.aui2" \
    "$PLUGIN_DIR/lwinput.aui2"

and install \
    -m 0644 \
    "$LSMASH_ARTIFACT_DIR/lsmash.ini" \
    "$PLUGIN_DIR/lsmash.ini"
```

## 10.3 SHA-256を確認する

```fish
sha256sum \
    "$LSMASH_ARTIFACT_DIR/lwinput.aui2" \
    "$PLUGIN_DIR/lwinput.aui2" \
    "$LSMASH_ARTIFACT_DIR/lsmash.ini" \
    "$PLUGIN_DIR/lsmash.ini"
```

prepared artifactとactive pluginのSHAが一致すること。

## 10.4 binary markerを確認する

```fish
strings \
    "$PLUGIN_DIR/lwinput.aui2" \
    | grep -E \
        'L-SMASH Works File Reader for AviUtl2 r1284 by Mr-Ojii|av1_cuvid|--enable-cuvid|--enable-decoder=av1_cuvid' \
    | sort \
    -u
```

最低限次が必要である。

```text
L-SMASH Works File Reader for AviUtl2 r1284 by Mr-Ojii
--enable-cuvid
--enable-decoder=av1_cuvid
av1_cuvid
```

## 10.5 lsmash.iniを確認する

```fish
grep -E \
    '^(libavsmash_disabled|libav_disabled|preferred_decoders)=' \
    "$PLUGIN_DIR/lsmash.ini"
```

期待値:

```ini
libavsmash_disabled=1
libav_disabled=0
preferred_decoders=av1_cuvid
```

---

# 11. Fcitx5/MozcとWine XIMを設定する

## 11.1 host processを確認する

```fish
pgrep \
    -a \
    fcitx5

pgrep \
    -a \
    mozc_server
```

起動していない場合:

```fish
fcitx5 \
    -d
```

MozcはFcitx5のinput methodとして有効化しておく。

## 11.2 InputStyleを登録する

AviUtl2専用`InputStyle`を登録する。

```fish
set REG_X11 \
    'HKEY_CURRENT_USER\Software\Wine\AppDefaults\aviutl2.exe\X11 Driver'

verb='add'
```

```fish
env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" \
    reg \
    add "$REG_X11" \
    /v 'InputStyle' \
    /t REG_SZ \
    /d 'overthespot' \
    /f
```

確認:

```fish
env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" \
    reg \
    query "$REG_X11" \
    /v 'InputStyle'
```

期待値:

```text
InputStyle    REG_SZ    overthespot
```

---

# 12. launcherを作る

launcherはprefixとrunnerを固定する。

```fish
set LAUNCHER \
    "$ROOT/launch-aviutl2.fish"
```

```fish
printf '%s\n' \
    '#!/usr/bin/env fish' \
    '' \
    'set ROOT "$HOME/Games/aviutl2"' \
    'set PREFIX "$ROOT/prefix"' \
    'set GE_PROTON_ROOT "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"' \
    'set GE_WINE "$GE_PROTON_ROOT/files/lib/wine/x86_64-unix/wine"' \
    'set GE_WINESERVER "$GE_PROTON_ROOT/files/bin/wineserver"' \
    'set GE_LIBS "$GE_PROTON_ROOT/files/lib64:$GE_PROTON_ROOT/files/lib:$GE_PROTON_ROOT/files/lib/wine/x86_64-unix:$GE_PROTON_ROOT/files/lib/wine/i386-unix"' \
    'set DXVK_CONFIG_FILE "$ROOT/nvidia-dxvk.conf"' \
    'set DLL_OVERRIDES "nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b"' \
    '' \
    'env WINEPREFIX="$PREFIX" "$GE_WINESERVER" -k 2>/dev/null' \
    'or true' \
    '' \
    'sleep 1' \
    '' \
    'cd "$PREFIX/drive_c/AviUtl2"' \
    'or return 1' \
    '' \
    'env \' \
    '    XMODIFIERS="@im=fcitx" \' \
    '    WINEPREFIX="$PREFIX" \' \
    '    LD_LIBRARY_PATH="$GE_LIBS" \' \
    '    WINEDLLOVERRIDES="$DLL_OVERRIDES" \' \
    '    DXVK_CONFIG_FILE="$DXVK_CONFIG_FILE" \' \
    '    DXVK_LOG_LEVEL=warn \' \
    '    WINEDEBUG=-all \' \
    '    "$GE_WINE" \' \
    '    ./aviutl2.exe' \
    > "$LAUNCHER"
```

```fish
chmod +x \
    "$LAUNCHER"
```

launcherはfunctionではなくscript fileなので、`return 1`は使用できない。
この生成例では次を修正する必要がある。

```text
cd ...
or exit 1
```

生成後に置換する。

```fish
sed -i \
    's/or return 1/or exit 1/' \
    "$LAUNCHER"
```

内容を確認する。

```fish
sed -n \
    '1,240p' \
    "$LAUNCHER"
```

---

# 13. AviUtl2単体を検証する

Catalogを導入する前に、base applicationを検証する。

## 13.1 通常起動

```fish
"$LAUNCHER"
```

確認項目:

```text
main windowが表示される
UIが安定している
日本語UIが読める
format 69 error dialogが出ない
```

## 13.2 DXVK logを取得する

```fish
set DXVK_LOG \
    "$ROOT/logs/dxvk-install-validation.log"

rm -f \
    "$DXVK_LOG"

cd \
    "$PREFIX/drive_c/AviUtl2"

and env \
    XMODIFIERS='@im=fcitx' \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES="$DLL_OVERRIDES" \
    DXVK_CONFIG_FILE="$DXVK_CONFIG_FILE" \
    DXVK_LOG_LEVEL=debug \
    WINEDEBUG=-all \
    "$GE_WINE" \
    ./aviutl2.exe \
    > "$DXVK_LOG" \
    2>&1
```

別terminalで確認する。

```fish
grep -E \
    'AviUtl2|format 69|d3d11|dxgi' \
    "$DXVK_LOG"
```

## 13.3 NVDEC runtime logを取得する

```fish
set NVDEC_LOG \
    "$ROOT/logs/nvdec-install-validation.log"

rm -f \
    "$NVDEC_LOG"

cd \
    "$PREFIX/drive_c/AviUtl2"

and env \
    XMODIFIERS='@im=fcitx' \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES="$DLL_OVERRIDES" \
    DXVK_CONFIG_FILE="$DXVK_CONFIG_FILE" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG='+loaddll,+seh' \
    "$GE_WINE" \
    ./aviutl2.exe \
    > "$NVDEC_LOG" \
    2>&1
```

GUI操作:

```text
AV1 Main 10-bit素材を読み込む
再生する
冒頭へseekする
中央へseekする
終盤へseekする
再度再生する
通常終了する
```

確認:

```fish
grep -E \
    'av1_cuvid|nvcuvid|nvcuda|Cannot load nvcuvid|Failed loading nvcuvid|CUDA|hardware frame|transfer' \
    "$NVDEC_LOG"
```

成功条件:

```text
複数の[av1_cuvid @ ...] context
再生とseekが成功
Cannot load nvcuvid.dllなし
Failed loading nvcuvid.なし
CUDA初期化失敗なし
hardware-frame-transfer failureなし
crashなし
```

AV1再生だけではNVDEC成功ではない。
software libdav1d fallbackでも再生できる。

## 13.4 DWrite/Mozc logを取得する

```fish
set TEXT_LOG \
    "$ROOT/logs/dwrite-mozc-install-validation.log"

rm -f \
    "$TEXT_LOG"

cd \
    "$PREFIX/drive_c/AviUtl2"

and env \
    XMODIFIERS='@im=fcitx' \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES="$DLL_OVERRIDES" \
    DXVK_CONFIG_FILE="$DXVK_CONFIG_FILE" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG='+dwrite,+xim,+imm,+seh' \
    "$GE_WINE" \
    ./aviutl2.exe \
    > "$TEXT_LOG" \
    2>&1
```

GUI操作:

```text
テキストオブジェクトを追加
ASCIIを入力
一部を選択
クリックでcaret移動
削除と追記
にほんごにゅうりょくを入力
日本語入力へ変換
Enterで確定
確定後に再選択・再編集
通常終了
```

成功確認:

```fish
grep -E \
    'dwritetextlayout_HitTestPoint|dwritetextlayout_HitTestTextRange|overthespot|preedit position|status nothing' \
    "$TEXT_LOG"
```

失敗確認:

```fish
if grep -Eqi \
    'HitTestPoint.*stub|HitTestTextRange.*stub|E_NOTIMPL|80004001|Unhandled exception|unhandled page fault' \
    "$TEXT_LOG"

    echo "ERROR: fatal DWrite/SEH evidence found" >&2
    false
else
    echo "No fatal DWrite/SEH evidence found."
end
```

---

# 14. AviUtl2 Catalog 0.3.3を導入する

AviUtl2単体の全検証に合格した後だけ進む。

## 14.1 checkpointを作る

```fish
stop_prefix_wine

set STAMP \
    (date +%Y%m%d-%H%M%S)

set PRE_CATALOG_CHECKPOINT \
    "$ROOT/checkpoints/prefix.before-catalog-$STAMP"

mkdir -p \
    "$ROOT/checkpoints"

cp -a \
    --reflink=auto \
    "$PREFIX" \
    "$PRE_CATALOG_CHECKPOINT"
```

確認:

```fish
test -f \
    "$PRE_CATALOG_CHECKPOINT/drive_c/AviUtl2/aviutl2.exe"

and echo \
    "$PRE_CATALOG_CHECKPOINT"
```

## 14.2 installerを取得する

Catalog release assetは、versionとSHA-256を固定する。

```fish
set CATALOG_VERSION \
    '0.3.3'

set CATALOG_DOWNLOAD_DIR \
    "$ROOT/downloads/catalog-$CATALOG_VERSION"

mkdir -p \
    "$CATALOG_DOWNLOAD_DIR"
```

GitHub APIでreleaseを取得する。

```fish
curl \
    --fail \
    --location \
    --silent \
    --show-error \
    "https://api.github.com/repos/Neosku/aviutl2-catalog/releases/tags/v$CATALOG_VERSION" \
    > "$CATALOG_DOWNLOAD_DIR/release.json"
```

asset URLを抽出する。

```fish
set CATALOG_URL \
    (python3 - \
        "$CATALOG_DOWNLOAD_DIR/release.json" \
        <<'PY'
import json
import sys

path = sys.argv[1]
data = json.load(open(path, encoding="utf-8"))

for asset in data.get("assets", []):
    name = asset.get("name", "")
    if name == "AviUtl2_Catalog_0.3.3_x64-setup.exe":
        print(asset["browser_download_url"])
        raise SystemExit(0)

raise SystemExit("target asset not found")
PY
    )
```

取得する。

```fish
set CATALOG_INSTALLER \
    "$CATALOG_DOWNLOAD_DIR/AviUtl2_Catalog_0.3.3_x64-setup.exe"

curl \
    --fail \
    --location \
    --output "$CATALOG_INSTALLER" \
    "$CATALOG_URL"
```

確認:

```fish
sha256sum \
    "$CATALOG_INSTALLER"
```

期待値:

```text
5591a5baa931f94322aff13096c63147126ca90d3844610ce7827b2f9b44d84e
```

一致しない場合は実行しない。

## 14.3 installerを起動する

```fish
env \
    XMODIFIERS='@im=fcitx' \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES="$DLL_OVERRIDES" \
    "$GE_WINE" \
    "$CATALOG_INSTALLER"
```

installer完了後:

```fish
stop_prefix_wine
```

## 14.4 Catalog executableを探す

```fish
set CATALOG_EXE \
    (find \
        "$PREFIX/drive_c/users" \
        -type f \
        -iname 'AviUtl2_Catalog.exe' \
        -print \
        -quit)

require_path \
    "$CATALOG_EXE"
```

## 14.5 初期設定する

```fish
env \
    XMODIFIERS='@im=fcitx' \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES="$DLL_OVERRIDES" \
    "$GE_WINE" \
    "$CATALOG_EXE"
```

GUIで設定する。

```text
AviUtl2:       インストール済み
AviUtl2 root:  C:\AviUtl2
Portable mode: 無効
```

必要pluginを導入する。
Catalogが公式L-SMASH Worksを配置しても、この段階では異常ではない。
custom r1284は最後に再配置する。

Catalogを通常終了し、Wineを停止する。

```fish
stop_prefix_wine
```

## 14.6 NVEnc output pluginを導入する

CatalogのGUIからAviUtl2 2対応のNVEnc output pluginを導入し、Catalogを通常終了する。

導入後、prefix内の`NVEncC64.exe`を探す。

```fish
set NVENCC_EXE \
    (find \
        "$PREFIX/drive_c/ProgramData/aviutl2" \
        -type f \
        -iname 'NVEncC64.exe' \
        -print \
        -quit)

require_path \
    "$NVENCC_EXE"
```

同名binaryが複数ある場合は、次ですべて列挙し、Catalogが導入したplugin directory内のものを選ぶ。

```fish
find \
    "$PREFIX/drive_c/ProgramData/aviutl2" \
    -type f \
    -iname 'NVEncC64.exe' \
    -print
```

---

# 15. NVENC出力codecをAV1またはHEVCへ分岐する

この節はNVENCによる**出力エンコード**を検証する。
前節の`av1_cuvid`によるNVDEC入力デコードとは独立して判定する。

## 15.1 GPUとdriverを記録する

```fish
mkdir -p \
    "$ROOT/evidence/nvenc" \
    "$NVENC_TEST_DIR"

nvidia-smi \
    --query-gpu=name,driver_version,compute_cap \
    --format=csv,noheader \
    | tee \
        "$ROOT/evidence/nvenc/gpu-driver.txt"
```

`nvidia-smi`の世代名だけではcodecを決定しない。

## 15.2 NVEncC64.exeのfeatureを実測する

```fish
rm -f \
    "$NVENC_FEATURE_LOG"

set NVENCC_WINDOWS_PATH \
    (string replace \
        "$PREFIX/drive_c" \
        'C:' \
        "$NVENCC_EXE")

set NVENCC_WINDOWS_PATH \
    (string replace \
        -a \
        '/' \
        '\\' \
        "$NVENCC_WINDOWS_PATH")
```

```fish
cd \
    "$PREFIX/drive_c/AviUtl2"

and env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES="$DLL_OVERRIDES" \
    WINEDEBUG=-all \
    "$GE_WINE" \
    "$NVENCC_WINDOWS_PATH" \
    --check-features \
    > "$NVENC_FEATURE_LOG" \
    2>&1
```

全出力を保存し、表示する。

```fish
cat \
    "$NVENC_FEATURE_LOG"
```

## 15.3 分岐を決定する

feature log内のAV1 EncodeとHEVC Encodeのsupport状態を確認する。
出力書式がNVEnc versionによって異なるため、最初に関連行を抽出する。

```fish
grep -Ei \
    'AV1|HEVC|H\.265|Main10|10.?bit|encode' \
    "$NVENC_FEATURE_LOG" \
    | tee \
        "$ROOT/evidence/nvenc/codec-feature-lines.txt"
```

次の変数は、上の実測結果を読んで手動で設定する。
曖昧な自動grep判定だけで決定しない。

### AV1 Encodeが明示的にsupportedの場合

```fish
set NVENC_BRANCH \
    av1

set NVENC_CODEC \
    av1

set NVENC_BIT_DEPTH \
    10
```

### AV1 EncodeがunsupportedでHEVC Encodeがsupportedの場合

```fish
set NVENC_BRANCH \
    hevc

set NVENC_CODEC \
    hevc
```

HEVC Main10または10-bit encodeが明示的にsupportedの場合:

```fish
set NVENC_BIT_DEPTH \
    10
```

HEVCはsupportedだがMain10がunsupportedの場合:

```fish
set NVENC_BIT_DEPTH \
    8
```

### AV1とHEVCの両方がunsupportedの場合

```fish
set NVENC_BRANCH \
    unsupported

set NVENC_CODEC \
    none
```

この場合はNVENC出力工程を停止する。
AviUtl2本体やNVDECの成功判定まで無効になるわけではない。

選択結果を保存する。

```fish
printf '%s\n' \
    "NVENC_BRANCH=$NVENC_BRANCH" \
    "NVENC_CODEC=$NVENC_CODEC" \
    "NVENC_BIT_DEPTH=$NVENC_BIT_DEPTH" \
    > "$ROOT/evidence/nvenc/selected-branch.txt"

cat \
    "$ROOT/evidence/nvenc/selected-branch.txt"
```

---

# 16A. AV1 NVENC branch

`NVENC_BRANCH=av1`の場合だけ実行する。

## 16A.1 試験入力をprefixへ配置する

NVEncCのcodec capabilityだけを分離して確認するため、入力はsoftware decodeする。
AV1 decode対応の有無を、この出力試験へ混ぜない。

```fish
set NVENC_INPUT_FILE \
    "$AV1_TEST_FILE"

install \
    -m 0644 \
    "$NVENC_INPUT_FILE" \
    "$PREFIX/drive_c/AviUtl2/nvenc-branch-input.mp4"
```

## 16A.2 AV1 NVENCの短時間CLI試験

NVEncCのversionごとにoption名が変化する可能性があるため、先にhelpを保存する。

```fish
env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES="$DLL_OVERRIDES" \
    WINEDEBUG=-all \
    "$GE_WINE" \
    "$NVENCC_WINDOWS_PATH" \
    --help \
    > "$ROOT/evidence/nvenc/nvencc-help.txt" \
    2>&1
```

実行例:

```fish
env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES="$DLL_OVERRIDES" \
    WINEDEBUG=-all \
    "$GE_WINE" \
    "$NVENCC_WINDOWS_PATH" \
    --avsw \
    --codec av1 \
    --output-depth 10 \
    --frames 120 \
    --input 'C:\AviUtl2\nvenc-branch-input.mp4' \
    --output 'C:\AviUtl2\nvenc-av1-test.mkv' \
    > "$ROOT/evidence/nvenc/av1-encode.log" \
    2>&1
```

確認:

```fish
set AV1_NVENC_OUTPUT \
    "$PREFIX/drive_c/AviUtl2/nvenc-av1-test.mkv"

file \
    "$AV1_NVENC_OUTPUT"

stat \
    --format='%n %s bytes' \
    "$AV1_NVENC_OUTPUT"

sha256sum \
    "$AV1_NVENC_OUTPUT" \
    > "$ROOT/evidence/nvenc/av1-output-sha256.txt"
```

成功条件:

```text
exit status 0
output fileが存在
output file sizeが0より大きい
logにAV1 encoder初期化成功がある
unsupported codec errorなし
NVENC initialization failureなし
```

## 16A.3 AviUtl2 NVEnc出力GUIで確認する

AviUtl2のNVEnc出力GUIでもcodecとしてAV1を選択し、短いprojectを出力する。
CLI試験だけでAviUtl2 plugin全体の成功とは判定しない。

記録する項目:

```text
選択plugin名
選択codec: AV1
bit depth: 10-bit
preset / quality mode
出力先
終了status
出力file size
plugin log
```

---

# 16B. HEVC NVENC branch

`NVENC_BRANCH=hevc`の場合だけ実行する。

Nanashi環境のRTX 2070 Superなど、AV1 NVENCを持たないがHEVC NVENCを持つGPUはこちらを使用する。
型番だけで決めず、必ず前節の`--check-features`で確定する。

## 16B.1 試験入力をprefixへ配置する

入力decode capabilityとHEVC encode capabilityを分離するため、`--avsw`を使用する。

```fish
set NVENC_INPUT_FILE \
    "$AV1_TEST_FILE"

install \
    -m 0644 \
    "$NVENC_INPUT_FILE" \
    "$PREFIX/drive_c/AviUtl2/nvenc-branch-input.mp4"
```

## 16B.2 HEVC NVENCの短時間CLI試験

10-bit supportedの場合:

```fish
set HEVC_DEPTH_OPTION \
    '--output-depth 10'
```

10-bit unsupportedの場合:

```fish
set HEVC_DEPTH_OPTION \
    '--output-depth 8'
```

Fishでは空白を含むoption文字列をそのまま1引数として渡してはいけない。
実行前にlistへ分ける。

```fish
if test "$NVENC_BIT_DEPTH" = '10'
    set HEVC_DEPTH_ARGS \
        --output-depth \
        10
else
    set HEVC_DEPTH_ARGS \
        --output-depth \
        8
end
```

実行:

```fish
env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES="$DLL_OVERRIDES" \
    WINEDEBUG=-all \
    "$GE_WINE" \
    "$NVENCC_WINDOWS_PATH" \
    --avsw \
    --codec hevc \
    $HEVC_DEPTH_ARGS \
    --frames 120 \
    --input 'C:\AviUtl2\nvenc-branch-input.mp4' \
    --output 'C:\AviUtl2\nvenc-hevc-test.mkv' \
    > "$ROOT/evidence/nvenc/hevc-encode.log" \
    2>&1
```

確認:

```fish
set HEVC_NVENC_OUTPUT \
    "$PREFIX/drive_c/AviUtl2/nvenc-hevc-test.mkv"

file \
    "$HEVC_NVENC_OUTPUT"

stat \
    --format='%n %s bytes' \
    "$HEVC_NVENC_OUTPUT"

sha256sum \
    "$HEVC_NVENC_OUTPUT" \
    > "$ROOT/evidence/nvenc/hevc-output-sha256.txt"
```

成功条件:

```text
exit status 0
output fileが存在
output file sizeが0より大きい
logにHEVC encoder初期化成功がある
unsupported codec errorなし
NVENC initialization failureなし
```

10-bitが失敗した場合、feature logでMain10がunsupportedなら8-bitへ切り替える。
feature logでMain10がsupportedなのに失敗した場合は、勝手に8-bitへfallbackせず原因を記録する。

## 16B.3 AviUtl2 NVEnc出力GUIで確認する

AviUtl2のNVEnc出力GUIでもcodecとしてHEVCを選択する。
bit depthは前節のfeature結果と一致させる。
CLI試験だけでAviUtl2 plugin全体の成功とは判定しない。

記録する項目:

```text
選択plugin名
選択codec: HEVC
bit depth: 10-bitまたは8-bit
preset / quality mode
出力先
終了status
出力file size
plugin log
```

---

# 17. custom r1284を最後にoverlayする

CatalogとNVEnc導入後に行う。

## 17.1 helperを実行する

```fish
stop_prefix_wine

"$REPO/scripts/install-l-smash-works-nvdec.fish" \
    --prefix "$PREFIX" \
    --artifact-dir "$LSMASH_ARTIFACT_DIR"
```

helperは次を行う。

```text
r1284/CUVID marker確認
INI確認
Catalog metadata hash記録
timestamp付きbackup
package_updates_paused_idsへ追加
plugin/INI配置
installed.json非変更確認
hash-cache.json非変更確認
```

## 17.2 active pluginを確認する

```fish
sha256sum \
    "$LSMASH_ARTIFACT_DIR/lwinput.aui2" \
    "$PLUGIN_DIR/lwinput.aui2"
```

byte一致が必要である。

## 17.3 Catalog pauseを確認する

Catalog settingsを探す。

```fish
set CATALOG_SETTINGS \
    (find \
        "$PREFIX/drive_c/users" \
        -type f \
        -path '*/AppData/Roaming/aviutl2-catalog/settings.json' \
        -print \
        -quit)

require_path \
    "$CATALOG_SETTINGS"
```

```fish
python3 - \
    "$CATALOG_SETTINGS" \
    <<'PY'
import json
import sys

path = sys.argv[1]
data = json.load(open(path, encoding="utf-8"))
paused = data.get("package_updates_paused_ids", [])
required = "Mr-Ojii.L-SMASH-Works"

print("paused:", paused)

if required not in paused:
    raise SystemExit(f"missing paused package: {required}")
PY
```

---

# 18. Catalog再起動後にr1284を保持できることを確認する

## 18.1 起動前hash

```fish
set BEFORE_CATALOG_HASH \
    (sha256sum \
        "$PLUGIN_DIR/lwinput.aui2" \
        | string split ' ' \
        | head -n 1)

printf '%s\n' \
    "$BEFORE_CATALOG_HASH" \
    > "$ROOT/evidence/install/lwinput-before-catalog.txt"
```

## 18.2 Catalogを通常起動する

```fish
env \
    XMODIFIERS='@im=fcitx' \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES="$DLL_OVERRIDES" \
    "$GE_WINE" \
    "$CATALOG_EXE"
```

L-SMASH Worksへの次の操作は禁止する。

```text
Update
Reinstall
Remove / Uninstall
initial setupによる再導入
```

Catalogを通常終了する。

```fish
stop_prefix_wine
```

## 18.3 起動後hash

```fish
set AFTER_CATALOG_HASH \
    (sha256sum \
        "$PLUGIN_DIR/lwinput.aui2" \
        | string split ' ' \
        | head -n 1)

printf '%s\n' \
    "$AFTER_CATALOG_HASH" \
    > "$ROOT/evidence/install/lwinput-after-catalog.txt"
```

比較する。

```fish
if test "$BEFORE_CATALOG_HASH" = "$AFTER_CATALOG_HASH"
    echo "MATCH: Catalog did not replace custom r1284"
else
    echo "ERROR: Catalog replaced or modified custom r1284" >&2
    false
end
```

expected Catalog presentation:

```text
installed: true
installed version: 不明
latest: false
```

これはcustom hashがofficial Catalog indexにないためであり、失敗ではない。

---

# 19. Lutrisへ登録する

LutrisではWine Runnerを使用しない。
Linux Runnerから固定launcherを起動する。

## 19.1 登録値

```text
Runner:
  Linux

Executable:
  /home/USER/Games/aviutl2/launch-aviutl2.fish

Working directory:
  /home/USER/Games/aviutl2/prefix/drive_c/AviUtl2
```

`USER`は実際のユーザー名へ置換する。
`$HOME`を入力できるfieldでは、次を使用する。

```text
$HOME/Games/aviutl2/launch-aviutl2.fish
```

Lutris側で別Wine、別DXVK、UMU、system Wineを選択しない。
launcherがrunnerとprefixを固定する。

---

# 20. 最終合格条件

## 20.1 起動

```text
AviUtl2メインウィンドウが表示される
format 69 errorなし
日本語UIが読める
```

## 20.2 text/DWrite/Mozc

```text
テキストオブジェクト作成
selection
caret移動
削除
追記
Mozc入力
日本語入力へ変換
Enter確定
確定後再編集
HitTestPoint logあり
HitTestTextRange logあり
stubなし
E_NOTIMPLなし
crashなし
```

## 20.3 AV1/NVDEC入力

```text
AV1 Main 10-bit読み込み
再生
冒頭/中央/終盤seek
multiple av1_cuvid context
nvcuvid load failureなし
CUDA failureなし
hardware-frame-transfer failureなし
```

## 20.4 NVENC出力

```text
NVEncC64.exe --check-features logを保存
AV1またはHEVC branchを実測で選択
選択codecでCLI短時間encodeが成功
output fileが非0 bytes
unsupported codec errorなし
NVENC initialization failureなし
AviUtl2のNVEnc出力GUIでも同じcodecで出力できる
```

AV1 branch:

```text
AV1 Encode supported
10-bit output
```

HEVC branch:

```text
HEVC Encode supported
Main10 supportedなら10-bit
Main10 unsupportedなら8-bit
```

## 20.5 Catalog

```text
Catalog 0.3.3が起動
AviUtl2 rootがC:\AviUtl2
portable mode無効
NVEnc output plugin導入済み
Mr-Ojii.L-SMASH-Worksがpause済み
Catalog再起動前後のr1284 SHA一致
```

## 20.6 最終checkpoint

全項目合格後:

```fish
stop_prefix_wine

set STAMP \
    (date +%Y%m%d-%H%M%S)

set FINAL_CHECKPOINT \
    "$ROOT/checkpoints/prefix.complete-install-$STAMP"

cp -a \
    --reflink=auto \
    "$PREFIX" \
    "$FINAL_CHECKPOINT"
```

記録する。

```fish
printf '%s\n' \
    "prefix=$PREFIX" \
    "runner=$GE_PROTON_ROOT" \
    "checkpoint=$FINAL_CHECKPOINT" \
    "created_at=(date --iso-8601=seconds)" \
    > "$ROOT/evidence/install/final-install.txt"
```

Fishでは上の`created_at=(...)`はcommand substitutionにならない。
実際には次を使用する。

```fish
printf '%s\n' \
    "prefix=$PREFIX" \
    "runner=$GE_PROTON_ROOT" \
    "checkpoint=$FINAL_CHECKPOINT" \
    "created_at="(date --iso-8601=seconds) \
    > "$ROOT/evidence/install/final-install.txt"
```

---

# 21. 禁止事項

```text
既存backupを新規installの入力にする
system Wineとpatched runnerを混ぜる
LutrisにWine versionを自動選択させる
DXVK DLLを異なるbuildから混ぜる
AV1が再生できただけでNVDEC成功と判定する
NVDECのAV1対応とNVENCのAV1対応を同一視する
--check-featuresを確認せずGPU名だけでNVENC codecを決める
AV1 encode非対応GPUでAV1を強制する
HEVC Main10非対応GPUで10-bitを強制する
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

1. GE-Proton 11-1 archiveの取得・SHA-512検証を別環境で実測する
2. stock runnerからpatched runnerをゼロから作る全command
3. Wine source/build treeの初回configure command
4. 空prefixをCLIだけで正常bootstrapするcommand
5. AviUtl2 2.1.2公式ZIPの取得・展開・`C:\AviUtl2`配置を別環境で実測する
6. Nanashi環境でのHEVC NVENC分岐とAviUtl2 NVEnc GUI出力の実測
7. Alex環境でのAV1 NVENC分岐とAviUtl2 NVEnc GUI出力の実測
8. `Tahoma-Noto-*.otf`の合法かつ再現可能な生成方法
9. NVIDIA Wine wrapperの取得元、version、展開command
10. NVIDIA driverとVulkan ICDのpreflight
11. Nanashi環境でのLutris Linux Runner登録commandまたはexport可能な設定
12. clean prefixで最初から最後まで通した最終ログ

これらが確認されるまでは、この文書を「prepared artifactsからの新規prefix install手順」として扱う。
復旧手順としては扱わない。

---

# 22. 関連文書

```text
docs/INSTALLATION.md
  新規prefixへの導入

docs/REPRODUCTION.md
  source build、再現性、固定commit、実行証拠

docs/AVIUTL2-COMMAND-LEDGER-BUNDLE/
  実行済みcommandと成功・失敗分類

docs/TROUBLESHOOTING.md
  既知errorと切り分け
```
