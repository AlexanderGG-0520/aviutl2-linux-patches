# AviUtl2 Linux 再現手順

## 1. この文書の位置付け

本書はこのプロジェクトの正本である `docs/REPRODUCTION.md` である。原環境で確認済みの再現基準と、Nanashi で未確認の再現・検証手順を明確に分けて記載する。「確認済み」は repository evidence がある事実だけを指し、「Nanashiで未確認」は実測待ちの候補手順を指す。
Nanashi で成功した実測結果は、この `REPRODUCTION.md` の未確認部分を更新し、確認済み手順として固定する。各コードブロックは一つずつ実行し、出力・絶対パス・hash・結果を記録する。エラーまたは想定外の出力があれば停止し、本文全体を一括実行しない。
## 2. 今回変更しないもの

現在の format 69 実験で対象になるのは、同じ DXVK build 出力にある `d3d11.dll`、`dxgi.dll`、`d3d10core.dll` の三つだけである。GE-Proton の版、Wine prefix 構造、Wine DWrite、L-SMASH Works、`lsmash.ini`、`nvidia-dxvk.conf`、AviUtl2 の実行ファイルとデータ、Fcitx5、Mozc、AviUtl2 Catalog、Lutris 設定、NVIDIA driver、Vulkan ICD、既存 Nanashi 起動ラッパー、その他の DLL は変更しない。
これは新規環境の導入、全環境の import、または generic installer の手順ではない。
## 3. 確認済みの再現基準

### 原環境で確認済みの構成

[`STATUS.md`](STATUS.md) と [`FINAL-SUMMARY.md`](FINAL-SUMMARY.md) は、CachyOS の Alex 原環境で GE-Proton 11-1 / wine-staging 11.0、DXVK 2.7.1、NVIDIA GeForce RTX 4060 Ti、NVIDIA driver 610.43.3、Fcitx5/Mozc を使った動作を記録している。AviUtl2 起動、DXVK format 69 回避、AV1 の読み込み・再生・シーク、`av1_cuvid`、NVDEC、テキスト編集、Mozc、Catalog はこの原環境で確認済みである。
DXVK の基準は `2.7.1`、base commit は `c3dd74be6baec53786d4e064a572185b70347a17`、patch は [`0001-aviutl2-format-support.patch`](../patches/dxvk/0001-aviutl2-format-support.patch) である。
### patch の確認済み動作

patch は通常の `CheckFormatSupport` 処理を先に実行し、通常の成功結果を変更しない。通常の失敗後だけ、実行ファイルが `aviutl2.exe`、format が `DXGI_FORMAT_G8R8_G8B8_UNORM`（数値 69）、flags pointer が非 null の場合に flags を 0 にし、`S_OK` を返す。`VK_FORMAT_UNDEFINED` のときだけに限定しない。
### 原環境で記録された build コマンド

Git 履歴 `509123c` に、原環境の実行記録として次の Meson コマンドがある。これは原環境の evidence であり、Nanashi での成功を意味しない。
```fish
meson setup \
    "$DXVK_SRC/build.w64" \
    "$DXVK_SRC" \
    --cross-file "$DXVK_SRC/build-win64.txt" \
    --buildtype release \
    --prefix "$DXVK_OUT"
```
```fish
meson compile \
    -C "$DXVK_SRC/build.w64" \
    -j (nproc)
```
```fish
meson install \
    -C "$DXVK_SRC/build.w64"
```
## 4. Nanashiで未確認の事項

Nanashi の絶対 path、cross-file の由来、clean source 準備、patch 適用、build、DLL の同一出力由来、DLL load、format 69 実行、main window、text、Mozc、AV1、NVDEC、復元は未確認である。
[`STATUS.md`](STATUS.md) には別環境で patch 適用失敗と `Missing Vulkan-Headers` が記録されている。これらは Nanashi で解消済みと扱わず、失敗時は推測による変更をせず停止する。
## 5. Nanashiの実パス確認

次は読み取り専用の発見である。候補が複数なら選ばず、出力を記録して停止する。
```fish
git rev-parse --show-toplevel
```
```fish
find "$HOME/Games" -maxdepth 2 -type d -name aviutl2 -print
```
```fish
find "$HOME/Games/aviutl2" -maxdepth 2 -type d -name 'prefix-*' -print
```
```fish
find "$HOME/.local/share/Steam/compatibilitytools.d" -maxdepth 2 -type d -name 'GE-Proton*' -print
```
```fish
find "$HOME/.local/share/Steam/compatibilitytools.d" -type f -path '*/files/lib/wine/x86_64-unix/wine' -print
find "$HOME/.local/share/Steam/compatibilitytools.d" -type f -path '*/files/bin/wineserver' -print
```
```fish
find (git rev-parse --show-toplevel)/scripts -maxdepth 1 -type f -name '*launch*.fish' -print
```
確認した値を手で記入する。`DXVK_WORK_PARENT` は prefix 外の既存作業親である。
```text
NANASHI_ROOT:
NANASHI_PREFIX:
NANASHI_SYSTEM32:
NANASHI_GE:
NANASHI_WINE:
NANASHI_WINESERVER:
NANASHI_LAUNCH_WRAPPER:
DXVK_WORK_PARENT:
```
同じ対話 Fish session で記録値を入力する。異なる session では入力し直す。
```fish
set NANASHI_REPO (git rev-parse --show-toplevel)
read -P 'NANASHI_ROOT: ' NANASHI_ROOT
read -P 'NANASHI_PREFIX: ' NANASHI_PREFIX
read -P 'NANASHI_SYSTEM32: ' NANASHI_SYSTEM32
read -P 'NANASHI_GE: ' NANASHI_GE
read -P 'NANASHI_WINE: ' NANASHI_WINE
read -P 'NANASHI_WINESERVER: ' NANASHI_WINESERVER
read -P 'NANASHI_LAUNCH_WRAPPER: ' NANASHI_LAUNCH_WRAPPER
read -P 'DXVK_WORK_PARENT: ' DXVK_WORK_PARENT
realpath "$NANASHI_ROOT" "$NANASHI_PREFIX" "$NANASHI_SYSTEM32" "$NANASHI_GE" "$NANASHI_WINE" "$NANASHI_WINESERVER" "$NANASHI_LAUNCH_WRAPPER" "$DXVK_WORK_PARENT"
```

## 6. DXVK sourceの準備

この節は Nanashi で未実行であり、変更操作の個別承認後にだけ使う。既存 checkout を再利用・初期化・削除せず、新しい checkout を作る。成功条件は指定 commit、clean source tree、patch 検査成功である。一つでも満たさなければ build へ進まない。

```fish
set DXVK_SRC "$DXVK_WORK_PARENT/dxvk-2.7.1-c3dd74be"
git clone --recurse-submodules https://github.com/doitsujin/dxvk.git "$DXVK_SRC"
```

```fish
git -C "$DXVK_SRC" checkout --detach c3dd74be6baec53786d4e064a572185b70347a17
git -C "$DXVK_SRC" submodule update --init --recursive
git -C "$DXVK_SRC" rev-parse HEAD
git -C "$DXVK_SRC" status --short
```

```fish
set DXVK_PATCH "$NANASHI_REPO/patches/dxvk/0001-aviutl2-format-support.patch"
sha256sum "$DXVK_PATCH"
git -C "$DXVK_SRC" apply --check "$DXVK_PATCH"
git -C "$DXVK_SRC" apply "$DXVK_PATCH"
git -C "$DXVK_SRC" diff --check
git -C "$DXVK_SRC" diff -- src/d3d11/d3d11_device.cpp
```

patch 適用前の `status --short` は空、`rev-parse HEAD` は base commit と一致し、適用後の diff は本 patch だけでなければならない。

## 7. DXVKのビルド

第 3 節の Meson 三コマンドが Git 履歴 `509123c` で確認できる原環境 command である。Nanashi での実行と結果は未確認である。`$DXVK_SRC/build-win64.txt` の由来・作成方法は repository evidence で確定していない。ファイルがない、または `meson setup` が失敗する場合は、cross-file を推測で作成・変更せず停止する。

Nanashi で実行を承認された場合は、第 3 節の三 command を一つずつ実行し、各成功後にだけ次へ進む。

```fish
set DXVK_BUILD "$DXVK_SRC/build.w64"
set DXVK_OUT "$DXVK_WORK_PARENT/dxvk-2.7.1-output"
test -f "$DXVK_SRC/build-win64.txt"
meson --version
x86_64-w64-mingw32-gcc --version
```

```text
実行日時:
DXVK commit:
patch SHA-256:
Meson version:
MinGW compiler version:
build directory:
output directory:
build 結果:
```

## 8. 生成された3 DLLの確認

次は読み取り専用である。各 `count` が 1 であり、絶対 path が同じ `DXVK_OUT` の build output tree に属することを手で確認する。複数またはゼロなら選択せず停止する。

```fish
set D3D11_FOUND (find "$DXVK_OUT" -type f -name d3d11.dll -print)
set DXGI_FOUND (find "$DXVK_OUT" -type f -name dxgi.dll -print)
set D3D10CORE_FOUND (find "$DXVK_OUT" -type f -name d3d10core.dll -print)
count $D3D11_FOUND
count $DXGI_FOUND
count $D3D10CORE_FOUND
printf '%s\n' $D3D11_FOUND $DXGI_FOUND $D3D10CORE_FOUND
```

```fish
read -P 'd3d11.dll の確認済み出力: ' DXVK_D3D11
read -P 'dxgi.dll の確認済み出力: ' DXVK_DXGI
read -P 'd3d10core.dll の確認済み出力: ' DXVK_D3D10CORE
realpath "$DXVK_D3D11" "$DXVK_DXGI" "$DXVK_D3D10CORE"
sha256sum "$DXVK_D3D11" "$DXVK_DXGI" "$DXVK_D3D10CORE"
grep -aF 'AviUtl2 compatibility' "$DXVK_D3D11"
```

marker は patch を含む候補 DLL の証拠であり、DLL load や format 69 実行の証拠ではない。

| DLL | 確認済み絶対 path | SHA-256 |
| --- | --- | --- |
| d3d11.dll |  |  |
| dxgi.dll |  |  |
| d3d10core.dll |  |  |

## 9. WineとAviUtl2の停止

AviUtl2 を通常終了してから行う。確認済み GE-Proton の Wine と wineserver、および確認済み prefix だけを使う。system Wine、`pkill`、`killall`、広範囲のプロセス終了は使わない。対応する `wineserver -w` の成功が主な停止条件であり、失敗時は backup や置換へ進まない。

```fish
set GE_LIBS "$NANASHI_GE/files/lib64:$NANASHI_GE/files/lib:$NANASHI_GE/files/lib/wine/x86_64-unix:$NANASHI_GE/files/lib/wine/i386-unix"
env WINEPREFIX="$NANASHI_PREFIX" LD_LIBRARY_PATH="$GE_LIBS" "$NANASHI_WINESERVER" -k
```

```fish
env WINEPREFIX="$NANASHI_PREFIX" LD_LIBRARY_PATH="$GE_LIBS" "$NANASHI_WINESERVER" -w
```

## 10. 既存3 DLLのバックアップ

置換前に元の三 hash を表示する。一つの新しい時刻付き backup directory を prefix 外に作り、明示した三ファイルだけを copy する。各組の hash を手で照合し、三組すべて一致するまで置換は禁止である。

```fish
sha256sum "$NANASHI_SYSTEM32/d3d11.dll" "$NANASHI_SYSTEM32/dxgi.dll" "$NANASHI_SYSTEM32/d3d10core.dll"
set BACKUP_TIMESTAMP (date -u +%Y%m%dT%H%M%SZ)
set DLL_BACKUP "$DXVK_WORK_PARENT/dxvk-backup-$BACKUP_TIMESTAMP"
mkdir "$DLL_BACKUP"
```

```fish
cp "$NANASHI_SYSTEM32/d3d11.dll" "$DLL_BACKUP/d3d11.dll"
cp "$NANASHI_SYSTEM32/dxgi.dll" "$DLL_BACKUP/dxgi.dll"
cp "$NANASHI_SYSTEM32/d3d10core.dll" "$DLL_BACKUP/d3d10core.dll"
sha256sum "$DLL_BACKUP/d3d11.dll" "$DLL_BACKUP/dxgi.dll" "$DLL_BACKUP/d3d10core.dll"
```

```text
backup directory:
original d3d11 SHA-256:
backup d3d11 SHA-256:
original dxgi SHA-256:
backup dxgi SHA-256:
original d3d10core SHA-256:
backup d3d10core SHA-256:
一致確認:
```

## 11. 3 DLLの交換

三ファイルの交換は atomic ではない。端末と SSH 接続を安定させ、途中で中断しない。copy が一つでも失敗したら続行せず、起動もしない。自動 retry と自動 rollback はしない。手動交換には中断リスクが残る。

```fish
cp "$DXVK_D3D11" "$NANASHI_SYSTEM32/d3d11.dll"
cp "$DXVK_DXGI" "$NANASHI_SYSTEM32/dxgi.dll"
cp "$DXVK_D3D10CORE" "$NANASHI_SYSTEM32/d3d10core.dll"
```

```fish
sha256sum "$NANASHI_SYSTEM32/d3d11.dll" "$NANASHI_SYSTEM32/dxgi.dll" "$NANASHI_SYSTEM32/d3d10core.dll"
```

表示した三 hash を第 8 節の build hash と手で比較する。三つすべて一致するまで AviUtl2 を起動しない。

## 12. AviUtl2の起動と確認

prefix 外に run ごとの log directory を作る。既存の確認済み Nanashi wrapper をそのまま使い、新しい wrapper や Wine 設定を作らない。wrapper がこの directory へ DXVK log を出す既存設定を持つかは未確認であり、空なら log 出力先を推測して変更しない。

```fish
set RUN_TIMESTAMP (date -u +%Y%m%dT%H%M%SZ)
set RUN_LOG_DIR "$DXVK_WORK_PARENT/dxvk-format69-log-$RUN_TIMESTAMP"
mkdir "$RUN_LOG_DIR"
sha256sum "$NANASHI_SYSTEM32/d3d11.dll" "$NANASHI_SYSTEM32/dxgi.dll" "$NANASHI_SYSTEM32/d3d10core.dll"
printf '%s\n' "$RUN_TIMESTAMP" "$NANASHI_LAUNCH_WRAPPER" "$NANASHI_PREFIX" "$NANASHI_GE" "$RUN_LOG_DIR"
```

```fish
"$NANASHI_LAUNCH_WRAPPER"
```

終了後、実際に得られた log を指定して読む。marker だけから format 69 成功を判断しない。patch が `CheckFormatSupport format=69 hr=0 flags=0` を出力することは repository evidence では確認できないため、その trace がなければ format 69 runtime 証拠の方法は未解決として記録する。

```fish
read -P '確認対象の DXVK log: ' DXVK_LOG
grep -aF 'AviUtl2 compatibility' "$DXVK_LOG"
grep -aF 'CheckFormatSupport format=69 hr=0 flags=0' "$DXVK_LOG"
```

成功水準は独立に記録する。(1) 意図した DLL の設置、(2) 意図した DXVK の load、(3) format 69 workaround 実行、(4) main window 表示、(5) text 編集、(6) Mozc、(7) AV1 load/playback/seeking、(8) NVDEC。前の水準から後の水準を推論しない。

## 13. 問題発生時の手動復元

復元も中断してはならない。AviUtl2 を通常終了し、第 9 節と同じ wineserver を停止してから、現在の三 hash を記録する。確認済み backup の三ファイルだけを exact System32 名へ戻す。copy 後の三 hash が第 10 節の元 hash とすべて一致するまで起動しない。

```fish
sha256sum "$NANASHI_SYSTEM32/d3d11.dll" "$NANASHI_SYSTEM32/dxgi.dll" "$NANASHI_SYSTEM32/d3d10core.dll"
cp "$DLL_BACKUP/d3d11.dll" "$NANASHI_SYSTEM32/d3d11.dll"
cp "$DLL_BACKUP/dxgi.dll" "$NANASHI_SYSTEM32/dxgi.dll"
cp "$DLL_BACKUP/d3d10core.dll" "$NANASHI_SYSTEM32/d3d10core.dll"
sha256sum "$NANASHI_SYSTEM32/d3d11.dll" "$NANASHI_SYSTEM32/dxgi.dll" "$NANASHI_SYSTEM32/d3d10core.dll"
```

## 14. Nanashi実行結果

```markdown
実行日:
機械:
リポジトリ commit:
DXVK commit:
patch SHA-256:
実際に使った build コマンド:
build 結果:
生成 DLL の path と hash:
元 DLL の hash:
backup path と hash:
最終設置 hash:
wrapper path:
log path:
format-69 結果:
main-window 結果:
text 結果:
Mozc 結果:
AV1 結果:
NVDEC 結果:
rollback 実施と結果:
次の blocker:
```

## 15. この文書を確認済み状態へ更新する条件

Nanashi 固有の記載を「未確認」から「確認済み」へ変えられるのは、実行済み command、実測した path、実際に観測した output、記録済み hash、確認済み runtime behavior、実施済みまたは独立に検証済みの restoration による裏付けがある場合だけである。

失敗した推測、未使用の分岐、未実行の候補 command は確認済み手順へ入れない。Nanashi の実測値が得られたら、この同じ文書の該当節と第 14 節を更新する。
