# AviUtl2 Linux 再現手順

本書はこのプロジェクトの正本である `docs/REPRODUCTION.md` である。原環境で確認済みの再現基準と、Nanashi で未確認の再現・検証手順を明確に分けて記載する。Nanashi で成功した実測結果は、この同じ文書の該当箇所を更新して確認済み手順として固定する。

各コードブロックは一つずつ実行し、出力、絶対 path、hash、結果を記録する。エラーまたは想定外の出力があれば停止し、本文全体を一括実行しない。

## 1. 現在の再現性

### 1.1 元環境で確認済み

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

### 1.2 元環境の固定値

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

### 1.3 DXVK format 69 patch の確認済み動作

[`STATUS.md`](STATUS.md) と [`FINAL-SUMMARY.md`](FINAL-SUMMARY.md) は、この原環境での AviUtl2 起動、format 69 回避、AV1、NVDEC、テキスト、Mozc、Catalog を記録している。DXVK の基準は `2.7.1`、base commit は `c3dd74be6baec53786d4e064a572185b70347a17`、patch は [`0001-aviutl2-format-support.patch`](../patches/dxvk/0001-aviutl2-format-support.patch) である。

Git 履歴 `509123c` は原環境で記録された DXVK build command の根拠であり、Nanashi で同じ command が成功したことを意味しない。

patch は通常の `CheckFormatSupport` を先に実行し、通常の成功結果を変更しない。通常の失敗後だけ、実行ファイルが `aviutl2.exe`、format が `DXGI_FORMAT_G8R8_G8B8_UNORM`（数値 69）、flags pointer が非 null の場合に flags を 0 にし、`S_OK` を返す。`VK_FORMAT_UNDEFINED` のときだけに限定しない。この動作は原環境の確認であり、Nanashi での runtime 確認ではない。

### 1.4 未確認範囲

2026-07-31時点では、別ユーザーのクリーン環境において、すべてのコンポーネントをソースから再ビルドして最後まで動作させることには成功していない。

特に次の点は未確定である。

- 現在リポジトリにあるDXVKパッチは、元環境で使われた39行の変更を整理して作り直したものであり、元の変更とバイト単位で同一ではない
- 現在リポジトリにあるWine DWriteパッチが、元環境へ最後に導入されたDLLと完全に同一の実装であることは未確認
- L-SMASH Worksの依存ライブラリ一式について、すべてのGitコミットが固定されていない
- 別環境での完全なソース再ビルドは未完了

したがって、現段階で「確認済みの再現」と呼べるのは、動作済みバイナリを移植する経路である。

---

## 2. 絶対に守る条件

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

## 3. ディレクトリ構成

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

set GE_INSTALL_DESTINATION \
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

## 4. 必要パッケージ

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

## 5. パッチリポジトリを取得

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

## 6. 推奨経路: 動作済み環境からバイナリを移植する

この経路が、2026-07-31時点の正規再現手順である。

### 6.1 元環境側で変数を設定

動作済み環境で実行する。

```fish
set ROOT \
    "$HOME/Games/aviutl2"

set PREFIX \
    "$ROOT/prefix-ge-nvdec-test"

set GE_EXPORT_SOURCE \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINESERVER \
    "$GE_EXPORT_SOURCE/files/bin/wineserver"

set SYSTEM32 \
    "$PREFIX/drive_c/windows/system32"

set PLUGIN_DIR \
    "$PREFIX/drive_c/ProgramData/aviutl2/Plugin"

set EXPORT_PARENT \
    "$ROOT/export"

set EXPORT \
    "$EXPORT_PARENT/aviutl2-known-good"
```

Git 履歴 `b75f119` は、archive へコピーする元 directory 名として未接尾辞の `GE-Proton11-1` を記録している。一方、対象環境の導入先は `GE-Proton11-1-aviutl2-test` であり、source と destination は意図的に別の役割である。repository には source の `dwrite.dll` が patched 版だったことを hash で裏付ける記録はないため、下の runtime file 確認で不足があれば export を止め、別 directory を推測して選ばない。実行中の patched runtime と同一の source であることを確認できない場合も export を止める。

### 6.2 必須ファイルを検査

```fish
for path in \
    "$GE_EXPORT_SOURCE" \
    "$GE_EXPORT_SOURCE/files/lib/wine/x86_64-unix/wine" \
    "$GE_EXPORT_SOURCE/files/bin/wineserver" \
    "$GE_EXPORT_SOURCE/files/lib/wine/x86_64-windows/dwrite.dll" \
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

```fish
test -d "$GE_EXPORT_SOURCE"
test -x "$GE_EXPORT_SOURCE/files/lib/wine/x86_64-unix/wine"
test -x "$GE_EXPORT_SOURCE/files/bin/wineserver"
test -f "$GE_EXPORT_SOURCE/files/lib/wine/x86_64-windows/dwrite.dll"
```

1つでも`MISSING`が出た状態ではエクスポートしない。

### 6.3 Wineプロセスを停止

```fish
env \
    WINEPREFIX="$PREFIX" \
    "$GE_WINESERVER" -k \
    2>/dev/null

sleep 1
```

### 6.4 動作済みバイナリをステージング

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
    "$GE_EXPORT_SOURCE" \
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

### 6.5 ビルド情報を保存

```fish
begin
    echo "Exported at: "(date --iso-8601=seconds)
    echo "Host: "(hostname)
    echo "Kernel: "(uname -r)
    echo
    echo "GE-Proton:"
    echo "$GE_EXPORT_SOURCE"
    echo
    echo "Wine:"
    env \
        LD_LIBRARY_PATH="$GE_EXPORT_SOURCE/files/lib64:$GE_EXPORT_SOURCE/files/lib:$GE_EXPORT_SOURCE/files/lib/wine/x86_64-unix:$GE_EXPORT_SOURCE/files/lib/wine/i386-unix" \
        "$GE_EXPORT_SOURCE/files/lib/wine/x86_64-unix/wine" --version
    echo
    echo "NVIDIA:"
    nvidia-smi \
        --query-gpu=name,driver_version \
        --format=csv,noheader \
        2>/dev/null
end > "$EXPORT/metadata/BUILD-INFO.txt"
```

### 6.6 全ファイルのSHA-256を作成

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

### 6.7 アーカイブを作成

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

## 7. 対象環境でアーカイブを確認して展開する

この節は一つ実行 → 出力確認 → 実測値を記録 → 成功した場合だけ次へ進む、という手作業の手順である。展開・確認に失敗した場合は、後続の導入・コピー・Wine 操作を行わない。

以前のこの経路では、旧 7.3 節の `cd "$IMPORT"` と、その後の `$IMPORT/ge/GE-Proton11-1-aviutl2-test` が、展開済みの root と GE-Proton ディレクトリを確認する前に参照していた。ここでの `No such file or directory` は後続コマンド自体が根本原因と確定したことを意味しない。アーカイブ未展開、展開失敗、展開先相違、アーカイブ内 top-level root 相違、存在しない名前の固定、または必須 asset 欠落のいずれでも起こり得る。

アーカイブ path、listing、展開出力、展開後 path を記録するまで原因は未確定として扱う。最初に失敗した archive または path の確認で停止し、後続手順を実行しない。

### 7.1 対象環境の基準 path を設定

対象環境で実行する。ここでは導入先の基準だけを設定し、archive 内部の名前は設定しない。

```fish
set ROOT \
    "$HOME/Games/aviutl2"

set PREFIX \
    "$ROOT/prefix-ge-nvdec-test"

set GE_INSTALL_DESTINATION \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set COMPAT_DIR \
    "$HOME/.local/share/Steam/compatibilitytools.d"
```

`GE_INSTALL_DESTINATION` は archive 内の名前ではなく、導入先として既存の構成資料に記録された path である。

### 7.2 アーカイブを発見して記録

第 6.7 節の作成記録では、archive は `aviutl2-known-good.tar.zst` である。転送済みの候補を表示する。ただし、候補が 0 件または複数件なら選択せず停止する。

```fish
set ARCHIVE_CANDIDATES \
    (find "$HOME/Downloads" -maxdepth 1 -type f -name 'aviutl2-known-good.tar.zst' -print)

count $ARCHIVE_CANDIDATES
printf '%s\n' $ARCHIVE_CANDIDATES
test (count $ARCHIVE_CANDIDATES) -eq 1
```

候補がちょうど 1 件であることを確認してから、その絶対 path を入力する。

```fish
read -P '確認済み archive の絶対パス: ' ARCHIVE_PATH
test -f "$ARCHIVE_PATH"
test -s "$ARCHIVE_PATH"
test "$ARCHIVE_PATH" = "$ARCHIVE_CANDIDATES[1]"
realpath "$ARCHIVE_PATH"
ls -lh "$ARCHIVE_PATH"
sha256sum "$ARCHIVE_PATH"
```

`test -f` または `test -s` が失敗した場合、あるいは入力 path が表示した唯一の候補と一致しない場合は停止する。

```text
ARCHIVE_PATH:
ARCHIVE_SIZE:
ARCHIVE_SHA256:
```

ここで計算した SHA-256 は使用した archive を記録する値である。独立して既知の期待値と照合しない限り、意図した既知正常 archive であることの証明にはならない。

### 7.3 外部 SHA-256 がある場合の照合

第 6.7 節は `.sha256` sidecar を作成し、archive とともに転送することを記録している。実際に転送された sidecar がある場合だけ、その絶対 path を入力して比較する。

```fish
read -P '確認済み archive SHA-256 sidecar の絶対パス: ' ARCHIVE_HASH
test -f "$ARCHIVE_HASH"
set EXPECTED_ARCHIVE_SHA256 \
    (string split -m 1 ' ' (string trim (head -n 1 "$ARCHIVE_HASH")))[1]
set ACTUAL_ARCHIVE_SHA256 \
    (string split -m 1 ' ' (sha256sum "$ARCHIVE_PATH"))[1]
printf '%s\n' "$EXPECTED_ARCHIVE_SHA256" "$ACTUAL_ARCHIVE_SHA256"
test "$ACTUAL_ARCHIVE_SHA256" = "$EXPECTED_ARCHIVE_SHA256"
```

この `test` が成功したときだけ sidecar の期待 SHA-256 と archive の SHA-256 は一致している。sidecar がない、読めない、形式が不明、または値が一致しない場合は展開しない。新たに計算した SHA-256 だけでは真正性を確認できない。

```text
ARCHIVE_HASH_PATH:
期待 SHA-256:
照合結果:
```

### 7.4 展開前に archive 内容を確認

第 6.7 節の作成 command は `tar --zstd` を使用しているため、repository 内の記録に対応する listing command は次である。listing が失敗した場合は展開しない。

```fish
tar --zstd -tf "$ARCHIVE_PATH"
```

出力を確認し、次を実測値として記録する。第 6.7 節から期待できる top-level root は `aviutl2-known-good`、必須 asset は `SHA256SUMS`、`ge`、`dxvk`、`plugin`、`config` 以下である。しかし実際の listing にそれらがない、top-level root が一意に決められない、または実測 layout が後続 path と異なる場合は停止する。

```text
archive 形式:
top-level entries:
EXPECTED_EXTRACT_ROOT:
GE-Proton directory:
prefix/environment directory:
required step-8 source path:
```

GE-Proton directory と prefix/environment directory は archive に含まれている場合にだけ記録する。第 6.4 節は元環境の GE-Proton 全体を `ge/` へコピーするが、Wine prefix は archive にコピーしない。listing が空、必須 asset がない、または後続で使う source path が確認できない場合は、ここで停止する。

### 7.5 新規展開先を準備して記録

既存 data を上書きしない。live Wine prefix と installed GE-Proton の外にあり、すでに存在する親 directory を一つ選ぶ。新しい最終展開先は `EXTRACT_PARENT/EXPECTED_EXTRACT_ROOT` とし、まだ存在してはならない。削除や自動 cleanup は行わない。

```fish
read -P '既存の新規展開用 parent 絶対パス: ' EXTRACT_PARENT
test -d "$EXTRACT_PARENT"
set EXTRACT_PARENT \
    (realpath "$EXTRACT_PARENT")
printf '%s\n' "$EXTRACT_PARENT"

set PREFIX_ABS \
    (realpath -m "$PREFIX")
set GE_INSTALL_DESTINATION_ABS \
    (realpath -m "$GE_INSTALL_DESTINATION")

not string match -q -- "$PREFIX_ABS" "$EXTRACT_PARENT"
and not string match -q -- "$PREFIX_ABS/*" "$EXTRACT_PARENT"
and not string match -q -- "$GE_INSTALL_DESTINATION_ABS" "$EXTRACT_PARENT"
and not string match -q -- "$GE_INSTALL_DESTINATION_ABS/*" "$EXTRACT_PARENT"

read -P 'archive listing で確認した top-level root 名: ' EXPECTED_EXTRACT_ROOT
set EXTRACT_DESTINATION \
    "$EXTRACT_PARENT/$EXPECTED_EXTRACT_ROOT"

test ! -e "$EXTRACT_DESTINATION"
realpath -m "$EXTRACT_DESTINATION"
```

`EXTRACT_PARENT` または `EXTRACT_DESTINATION` が `$PREFIX`、`$GE_INSTALL_DESTINATION`、それらの配下、または installed GE-Proton directory である場合は選び直す。確認した parent と最終展開先を記録する。

```text
EXTRACT_PARENT:
EXPECTED_EXTRACT_ROOT:
EXTRACT_DESTINATION:
```

### 7.6 archive を展開

前節の全確認が成功した場合だけ、独立したこの command を一度実行する。

```fish
tar \
    --zstd \
    -xf "$ARCHIVE_PATH" \
    -C "$EXTRACT_PARENT"

echo "展開 command の終了 status: $status"
```

展開 command が失敗した場合、または展開後の必須 path が存在しない場合は、ここで停止する。後続手順を実行しない。

### 7.7 展開後の実測 layout と必須 asset を確認

destination directory が存在するだけでは展開成功とは扱わない。listing で記録した root を実際に確認してから、その絶対 path を入力する。

```fish
read -P '確認済みの展開後 root 絶対パス: ' EXTRACTED_ROOT
realpath "$EXTRACTED_ROOT"
set EXTRACTED_ROOT \
    (realpath "$EXTRACTED_ROOT")
test -d "$EXTRACTED_ROOT"
test -d "$EXTRACT_DESTINATION"
test -f "$EXTRACTED_ROOT/SHA256SUMS"
test "$EXTRACTED_ROOT" = (realpath "$EXTRACT_DESTINATION")
test (basename "$EXTRACTED_ROOT") = "$EXPECTED_EXTRACT_ROOT"
```

`EXTRACTED_ROOT` が記録済みの `EXTRACT_DESTINATION` と一致し、root 名が `EXPECTED_EXTRACT_ROOT` と一致することを確認する。異なる場合は、その差を記録して停止する。次に、listing で確認した実際の GE-Proton source directory を絶対 path で入力する。名前を推測してはならない。

```fish
read -P '確認済みの展開後 GE-Proton source 絶対パス: ' IMPORT_GE
realpath "$IMPORT_GE"
set IMPORT_GE \
    (realpath "$IMPORT_GE")
test -d "$IMPORT_GE"
string match -q -- "$EXTRACTED_ROOT/*" "$IMPORT_GE"

for path in \
    "$EXTRACTED_ROOT/dxvk/d3d11.dll" \
    "$EXTRACTED_ROOT/dxvk/dxgi.dll" \
    "$EXTRACTED_ROOT/dxvk/d3d10core.dll" \
    "$EXTRACTED_ROOT/plugin/lwinput.aui2" \
    "$EXTRACTED_ROOT/plugin/lsmash.ini" \
    "$EXTRACTED_ROOT/config/nvidia-dxvk.conf"

    test -f "$path"
    ls -lh "$path"
end
```

内部 checksum manifest が listing にあり、すべての asset が存在する場合だけ検証する。

```fish
pushd "$EXTRACTED_ROOT"
sha256sum -c SHA256SUMS
popd
```

```text
actual extracted root:
actual GE-Proton source path:
required asset result:
internal SHA-256 result:
```

`IMPORT_GE` が `EXTRACTED_ROOT` 配下でない、必須 asset がない、manifest 検証が失敗する、または実測 layout が固定した後続 path と異なる場合は停止する。`No such file or directory` の原因調査に戻り、後続操作は行わない。

### 7.8 観測済み失敗の記録

以前の手順では `No such file or directory` が発生した。疑われるのは archive 展開または仮定した展開 layout であり、archive path、listing、展開結果、展開後 path を記録するまでは確認済み根本原因と扱わない。

```text
失敗した command:
欠落していた path:
archive path:
archive listing result:
extraction command result:
actual extracted root:
required asset result:
confirmed root cause:
```

---

## 8. パッチ済み GE-Proton を導入

次のすべてを確認するまで、この手順を実行しない。

- archive path を確認済み
- archive listing 成功
- archive top-level root を確認済み
- extraction 成功
- EXTRACTED_ROOT を確認済み
- この手順が参照する source path が実在
- required files が実在

この手順が消費する source path をもう一度確認する。

```fish
test -d "$IMPORT_GE"
ls -ld "$IMPORT_GE"
```

失敗した場合は、`No such file or directory` の原因調査に戻り、後続操作は行わない。`IMPORT_GE` は第 7.7 節で実測した archive 内 source path であり、`GE-Proton11-1-aviutl2-test` のような推測した archive 内 basename を使わない。

```fish
set TS \
    (date +%Y%m%d-%H%M%S)
```

既存の同名環境がある場合は退避する。

```fish
if test -e "$GE_INSTALL_DESTINATION"
    mv \
        "$GE_INSTALL_DESTINATION" \
        "$GE_INSTALL_DESTINATION.backup-$TS"
end
```

コピーする。

```fish
cp -a \
    "$IMPORT_GE" \
    "$GE_INSTALL_DESTINATION"
```

必須ファイルを確認する。

```fish
for path in \
    "$GE_INSTALL_DESTINATION/files/lib/wine/x86_64-unix/wine" \
    "$GE_INSTALL_DESTINATION/files/bin/wineserver" \
    "$GE_INSTALL_DESTINATION/files/lib/wine/x86_64-windows/dwrite.dll"

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
    "$GE_INSTALL_DESTINATION/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_INSTALL_DESTINATION/files/bin/wineserver"

set GE_LIBS \
    "$GE_INSTALL_DESTINATION/files/lib64:$GE_INSTALL_DESTINATION/files/lib:$GE_INSTALL_DESTINATION/files/lib/wine/x86_64-unix:$GE_INSTALL_DESTINATION/files/lib/wine/i386-unix"

env \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" --version
```

期待値:

```text
wine-staging 11.0
```

`$GE_INSTALL_DESTINATION/files/bin/wine`は使用しない。

---

## 9. 新しいWine prefixを作成

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

## 10. AviUtl2 2.1.2を公式ZIPから配置

### 10.1 ZIPを取得

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

### 10.2 ZIPを展開

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

### 10.3 `C:\AviUtl2`へ配置

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

## 11. 動作済みDXVKをprefixへ導入

### 11.1 DXVK設定

```fish
cp -a \
    "$EXTRACTED_ROOT/config/nvidia-dxvk.conf" \
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

### 11.2 DLLをコピー

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
        "$EXTRACTED_ROOT/dxvk/$dll" \
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
        "$EXTRACTED_ROOT/dxvk/$dll" \
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

## 12. 動作済みL-SMASH Worksを導入

```fish
set PLUGIN_DIR \
    "$PREFIX/drive_c/ProgramData/aviutl2/Plugin"

mkdir -p "$PLUGIN_DIR"
```

プラグインをコピーする。

```fish
cp -a \
    "$EXTRACTED_ROOT/plugin/lwinput.aui2" \
    "$PLUGIN_DIR/lwinput.aui2"

cp -a \
    "$EXTRACTED_ROOT/plugin/lsmash.ini" \
    "$PLUGIN_DIR/lsmash.ini"
```

ハッシュを比較する。

```fish
sha256sum \
    "$EXTRACTED_ROOT/plugin/lwinput.aui2" \
    "$PLUGIN_DIR/lwinput.aui2"

sha256sum \
    "$EXTRACTED_ROOT/plugin/lsmash.ini" \
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

## 13. 固定起動ラッパーを作成

### 13.1 ラッパー内容

次の内容を`~/Games/aviutl2/scripts/launch-aviutl2.fish`へ保存する。

```fish
#!/usr/bin/env fish

set ROOT \
    "$HOME/Games/aviutl2"

set PREFIX \
    "$ROOT/prefix-ge-nvdec-test"

set GE_INSTALL_DESTINATION \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set GE_WINE \
    "$GE_INSTALL_DESTINATION/files/lib/wine/x86_64-unix/wine"

set GE_LIBS \
    "$GE_INSTALL_DESTINATION/files/lib64:$GE_INSTALL_DESTINATION/files/lib:$GE_INSTALL_DESTINATION/files/lib/wine/x86_64-unix:$GE_INSTALL_DESTINATION/files/lib/wine/i386-unix"

set AVIUTL2_EXE \
    "$PREFIX/drive_c/AviUtl2/aviutl2.exe"

set DXVK_CONFIG \
    "$ROOT/nvidia-dxvk.conf"

set DLL_OVERRIDES \
    'nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

set missing_required 0

for required in \
    "$GE_WINE" \
    "$AVIUTL2_EXE" \
    "$DXVK_CONFIG"

    if not test -e "$required"
        echo "ERROR: required path does not exist: $required" >&2
        set missing_required 1
    end
end

if test "$missing_required" -ne 0
    exit 1
end

cd "$PREFIX/drive_c/AviUtl2"
or exit 1

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

## 14. 最初の直接起動

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

## 15. DLLロード経路を検証

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

## 16. 段階別の機能確認

一度にすべてを試さず、次の順番で検証する。

### Phase 1: 起動

確認項目:

- メインウィンドウが出る
- 数分間維持できる
- 正常終了できる
- format 69エラーがない
- ページフォルトがない

### Phase 2: テキスト

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

### Phase 3: 動画

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

### Phase 4: Mozc

確認項目:

1. Fcitx5を有効にする
2. 日本語を入力する
3. 変換候補を表示する
4. 候補を選択する
5. 確定する
6. テキスト編集を継続する

IMEを無効化した状態だけで成功しても、最終成功とは扱わない。

---

## 17. Lutrisへ登録

AviUtl2の直接起動が成功した後だけ実施する。

### 17.1 Runner

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

### 17.2 設計上の禁止事項

次の構成へ変更してはならない。

```text
Lutris Wine Runner
└── Lutrisが選択したWine
    └── Lutrisが選択したDXVK
```

この構成では、元環境で確認したGE-Proton、prefix、DWrite、DXVKが使用される保証がなくなる。

---

## 18. AviUtl2 Catalog

Catalog は AviUtl2 本体の起動確認後にだけ導入する。管理スクリプトを使う場合は、実行前に [`LUTRIS-CATALOG.md`](LUTRIS-CATALOG.md) の手順と設定値を確認する。

```fish
cd "$REPO"
scripts/manage-aviutl2-catalog-lutris.sh status
```

Catalog 更新後は独自の `lwinput.aui2` が上書きされる可能性がある。第 12 節の source asset とコピー先の SHA-256 を比較し、異なる場合は第 12 節の確認済み source から手動復旧する。

---

## 19. Nanashiでの format 69 差分検証

これは第 6–16 節の全環境移植とは別の診断である。既存の Nanashi 環境を固定し、同一 build の `d3d11.dll`、`dxgi.dll`、`d3d10core.dll` だけを差分として扱う。Nanashi での build、DLL load、format 69 実行、画面表示、テキスト、Mozc、AV1、NVDEC、復元は未確認である。[`STATUS.md`](STATUS.md) の patch 適用失敗と `Missing Vulkan-Headers` を解消済みと扱わない。

### 19.1 実測 path と build 出力

作業親は prefix 外の既存 directory を選び、既存の Nanashi prefix、GE-Proton、起動ラッパーを変更しない。

```fish
read -P 'Nanashi prefix の絶対パス: ' NANASHI_PREFIX
read -P 'Nanashi System32 の絶対パス: ' NANASHI_SYSTEM32
read -P 'Nanashi wineserver の絶対パス: ' NANASHI_WINESERVER
read -P '既存の Nanashi 起動ラッパー絶対パス: ' NANASHI_LAUNCH_WRAPPER
read -P 'prefix 外の既存 DXVK 作業親絶対パス: ' DXVK_WORK_PARENT
realpath "$NANASHI_PREFIX" "$NANASHI_SYSTEM32" "$NANASHI_WINESERVER" "$NANASHI_LAUNCH_WRAPPER" "$DXVK_WORK_PARENT"
```

`scripts/build-dxvk-aviutl2.sh` は DXVK 2.7.1 の base commit `c3dd74be6baec53786d4e064a572185b70347a17` と本 repository の patch を固定している。新しい source と output directory を指定し、script が成功しなければ置換へ進まない。

```fish
set DXVK_SRC "$DXVK_WORK_PARENT/dxvk-2.7.1-c3dd74be"
set DXVK_OUT "$DXVK_WORK_PARENT/dxvk-2.7.1-output"
test ! -e "$DXVK_SRC"
test ! -e "$DXVK_OUT"
"$REPO/scripts/build-dxvk-aviutl2.sh" --work-dir "$DXVK_SRC" --output-dir "$DXVK_OUT"
```

### 19.2 三 DLL の確認、backup、差分適用

`scripts/build-dxvk-aviutl2.sh` は install 後に各 DLL を探索し、`$DXVK_OUT/d3d11.dll`、`$DXVK_OUT/dxgi.dll`、`$DXVK_OUT/d3d10core.dll` へ明示的に copy する。したがって、この flat output path は script が保証する。確認済み path を変数へ記録し、marker は DLL load や format 69 実行の証拠ではない。

```fish
set DXVK_D3D11 "$DXVK_OUT/d3d11.dll"
set DXVK_DXGI "$DXVK_OUT/dxgi.dll"
set DXVK_D3D10CORE "$DXVK_OUT/d3d10core.dll"
test -f "$DXVK_D3D11"
test -s "$DXVK_D3D11"
test -f "$DXVK_DXGI"
test -s "$DXVK_DXGI"
test -f "$DXVK_D3D10CORE"
test -s "$DXVK_D3D10CORE"
realpath "$DXVK_D3D11" "$DXVK_DXGI" "$DXVK_D3D10CORE"
sha256sum "$DXVK_D3D11" "$DXVK_DXGI" "$DXVK_D3D10CORE"
grep -aF 'AviUtl2 compatibility' "$DXVK_D3D11"
```

現在の System32 DLL の hash を記録してから、prefix 外の新規 backup directory へ保存する。backup 後に originals と backup を両方表示し、三つすべての `cmp` が成功するまで置換しない。自動 rollback はしない。

```fish
set ORIGINAL_D3D11_SHA256 (sha256sum "$NANASHI_SYSTEM32/d3d11.dll" | string split ' ')[1]
set ORIGINAL_DXGI_SHA256 (sha256sum "$NANASHI_SYSTEM32/dxgi.dll" | string split ' ')[1]
set ORIGINAL_D3D10CORE_SHA256 (sha256sum "$NANASHI_SYSTEM32/d3d10core.dll" | string split ' ')[1]
printf '%s\n' "$ORIGINAL_D3D11_SHA256" "$ORIGINAL_DXGI_SHA256" "$ORIGINAL_D3D10CORE_SHA256"

set BACKUP_TIMESTAMP (date -u +%Y%m%dT%H%M%SZ)
set DLL_BACKUP "$DXVK_WORK_PARENT/dxvk-backup-$BACKUP_TIMESTAMP"
mkdir "$DLL_BACKUP"
cp "$NANASHI_SYSTEM32/d3d11.dll" "$DLL_BACKUP/d3d11.dll"
cp "$NANASHI_SYSTEM32/dxgi.dll" "$DLL_BACKUP/dxgi.dll"
cp "$NANASHI_SYSTEM32/d3d10core.dll" "$DLL_BACKUP/d3d10core.dll"
sha256sum "$NANASHI_SYSTEM32/d3d11.dll" "$NANASHI_SYSTEM32/dxgi.dll" "$NANASHI_SYSTEM32/d3d10core.dll"
sha256sum "$DLL_BACKUP/d3d11.dll" "$DLL_BACKUP/dxgi.dll" "$DLL_BACKUP/d3d10core.dll"
cmp -s "$NANASHI_SYSTEM32/d3d11.dll" "$DLL_BACKUP/d3d11.dll"
cmp -s "$NANASHI_SYSTEM32/dxgi.dll" "$DLL_BACKUP/dxgi.dll"
cmp -s "$NANASHI_SYSTEM32/d3d10core.dll" "$DLL_BACKUP/d3d10core.dll"
```

三比較が成功した場合だけ、直前に対応する wineserver を停止して三 DLL を置換する。system wineserver、`pkill`、`killall`、広範囲の停止は使わない。

```fish
env \
    WINEPREFIX="$NANASHI_PREFIX" \
    "$NANASHI_WINESERVER" -k

env \
    WINEPREFIX="$NANASHI_PREFIX" \
    "$NANASHI_WINESERVER" -w
```

```fish
cp "$DXVK_D3D11" "$NANASHI_SYSTEM32/d3d11.dll"
cp "$DXVK_DXGI" "$NANASHI_SYSTEM32/dxgi.dll"
cp "$DXVK_D3D10CORE" "$NANASHI_SYSTEM32/d3d10core.dll"
sha256sum "$DXVK_D3D11" "$DXVK_DXGI" "$DXVK_D3D10CORE"
sha256sum "$NANASHI_SYSTEM32/d3d11.dll" "$NANASHI_SYSTEM32/dxgi.dll" "$NANASHI_SYSTEM32/d3d10core.dll"
cmp -s "$DXVK_D3D11" "$NANASHI_SYSTEM32/d3d11.dll"
cmp -s "$DXVK_DXGI" "$NANASHI_SYSTEM32/dxgi.dll"
cmp -s "$DXVK_D3D10CORE" "$NANASHI_SYSTEM32/d3d10core.dll"
```

三比較が成功するまで AviUtl2 を起動しない。

### 19.3 起動、判定、手動復元

既存の起動ラッパーで起動し、DLL 設置、DLL load、format 69 workaround 実行、main window、text、Mozc、AV1 の load/playback/seeking、NVDEC を独立に記録する。前の結果から後の結果を推論しない。format 69 の runtime trace が得られない場合は、その証拠方法を未解決と記録する。

```fish
"$NANASHI_LAUNCH_WRAPPER"
```

問題発生時は AviUtl2 を通常終了し、同じ wineserver の停止確認後に、確認済み backup の三 DLL だけを手動で戻す。これは failed launch 後にも単独で使える手順である。

```fish
env \
    WINEPREFIX="$NANASHI_PREFIX" \
    "$NANASHI_WINESERVER" -k

env \
    WINEPREFIX="$NANASHI_PREFIX" \
    "$NANASHI_WINESERVER" -w

cp "$DLL_BACKUP/d3d11.dll" "$NANASHI_SYSTEM32/d3d11.dll"
cp "$DLL_BACKUP/dxgi.dll" "$NANASHI_SYSTEM32/dxgi.dll"
cp "$DLL_BACKUP/d3d10core.dll" "$NANASHI_SYSTEM32/d3d10core.dll"
sha256sum "$NANASHI_SYSTEM32/d3d11.dll" "$NANASHI_SYSTEM32/dxgi.dll" "$NANASHI_SYSTEM32/d3d10core.dll"
sha256sum "$DLL_BACKUP/d3d11.dll" "$DLL_BACKUP/dxgi.dll" "$DLL_BACKUP/d3d10core.dll"
cmp -s "$NANASHI_SYSTEM32/d3d11.dll" "$DLL_BACKUP/d3d11.dll"
cmp -s "$NANASHI_SYSTEM32/dxgi.dll" "$DLL_BACKUP/dxgi.dll"
cmp -s "$NANASHI_SYSTEM32/d3d10core.dll" "$DLL_BACKUP/d3d10core.dll"
test "$ORIGINAL_D3D11_SHA256" = (sha256sum "$NANASHI_SYSTEM32/d3d11.dll" | string split ' ')[1]
test "$ORIGINAL_DXGI_SHA256" = (sha256sum "$NANASHI_SYSTEM32/dxgi.dll" | string split ' ')[1]
test "$ORIGINAL_D3D10CORE_SHA256" = (sha256sum "$NANASHI_SYSTEM32/d3d10core.dll" | string split ' ')[1]
```

```text
DXVK commit と patch SHA-256:
三 DLL の build hash / backup hash / 最終 hash:
DLL load:
format 69:
main window:
text:
Mozc:
AV1:
NVDEC:
手動復元:
次の blocker:
```

Nanashi 固有の記載を確認済みに更新できるのは、実行 command、実測 path、観測 output、hash、runtime behavior、復元結果がこの文書に記録された場合だけである。
