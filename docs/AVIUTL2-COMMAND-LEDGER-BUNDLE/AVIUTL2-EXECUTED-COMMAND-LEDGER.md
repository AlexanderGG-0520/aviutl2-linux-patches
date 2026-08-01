# AviUtl2 on Linux 実行済みコマンド台帳

生成日: 2026-08-01

## 監査方針

- この台帳は、会話内に保存されたFish history、端末transcript、生成物audit、ユーザーの明示的な実操作報告を基礎にしている。
- コマンド本文は、保存された履歴または端末transcriptの文字列を原文のまま収録した。説明文内で誤りを指摘しても、コマンド本文は修正していない。
- 端末prompt、出力、ANSI由来の表示崩れはコマンド本文から分離した。
- 同一の読み取り専用監査ブロックが複数ファイルに重複していた場合、完全一致する先頭部分は一度だけ収録した。
- 生成されたREADMEやscript本文の中に「例」として埋め込まれただけのコマンドは、個別の実行コマンドには昇格していない。
- `成功`は後続のGUI動作、artifact、SHA、registry、load log、または明示出力で裏づけられたものに限定した。
- `実行確認不能`は記載またはFish historyがあっても、終了状態を断定できないもの。
- `失敗・旧手順`はエラー、誤path、診断実験、または後続で置換された構成。

## 最終成功環境の固定値

```text
ROOT=/home/alex/Games/aviutl2
REPO=/home/alex/projects/aviutl2-linux-patches
FINAL_PREFIX=/home/alex/Games/aviutl2/prefix-ge-nvdec-test
BASE_PREFIX=/home/alex/Games/aviutl2/prefix-ge
PATCHED_RUNNER=/home/alex/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test.backup-20260731-135348
KNOWN_GOOD_PREFIX=/home/alex/Games/aviutl2/prefix-ge-nvdec-test.backup-20260731-135410
L-SMASH_ARTIFACT=/home/alex/Games/aviutl2/build/l-smash-works-nvdec-repro-03/output/lwinput.aui2
L-SMASH_SHA256=db465570a4c049624f369086232cf47c387975d54fa615d895d090fe1a17bbe0
LSMASH_INI_SHA256=10620155d1470ea270121f67357f3da89cb8151ffac651c049e98238253a9a9f
CATALOG_VERSION=0.3.3
CATALOG_INSTALLER_SHA256=5591a5baa931f94322aff13096c63147126ca90d3844610ce7827b2f9b44d84e
```

# Part I — 最終成功環境へ直接つながるコマンド

### コマンド 001 — `S239-01`

#### 目的

full L-SMASH Works history取得patchを適用し、最終build scriptの構文を確認する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
cd ~/projects/aviutl2-linux-patches

  git apply --check \
          ~/Downloads/0003-fetch-full-l-smash-works-history.patch

  git apply \
          ~/Downloads/0003-fetch-full-l-smash-works-history.patch

  fish -n \
          scripts/build-l-smash-works-nvdec.fish

  git diff --check
```

#### 実行結果

patch適用と`fish -n`、`git diff --check`が完了し、repro-03 buildへ進んだ。

#### 生成・変更されたもの

repository内のL-SMASH Works build script。

#### 関連する固定値

- path: `~/projects/aviutl2-linux-patches`
- path: `~/Downloads/0003-fetch-full-l-smash-works-history.patch`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(239).txt lines 2-13`

---
### コマンド 002 — `S239-02`

#### 目的

最終採用されたrepro-03 work directoryでcustom L-SMASH Works r1284を完全ビルドする。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
cd ~/projects/aviutl2-linux-patches

  scripts/build-l-smash-works-nvdec.fish \
          --work-dir \
          "$HOME/Games/aviutl2/build/l-smash-works-nvdec-repro-03" \
          --jobs (nproc)
```

#### 実行結果

全依存関係、FFmpeg CUVID設定、L-SMASH Worksを構築し、`output/lwinput.aui2`、`lsmash.ini`、`PROVENANCE.txt`、`SHA256SUMS`を生成。plugin SHA-256は`db465570...17bbe0`。

#### 生成・変更されたもの

`$HOME/Games/aviutl2/build/l-smash-works-nvdec-repro-03`。

#### 関連する固定値

- path: `~/projects/aviutl2-linux-patches`
- path: `$HOME/Games/aviutl2/build/l-smash-works-nvdec-repro-03`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(239).txt lines 16-21`

---
### コマンド 003 — `S241-01`

#### 目的

最終再構築で使用するroot、prefix、runner、override変数を設定する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

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

#### 実行コマンド

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

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(241).txt:2-32`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(241).txt lines 2-32`

---
### コマンド 004 — `V241-03`

#### 目的

GE Wine binary形式とWine versionを確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
LD_LIBRARY_PATH="$GE_LIBS"
```

#### 実行コマンド

```fish
file \
                                                                                             "$GE_WINE"

                                                                         env \
          LD_LIBRARY_PATH="$GE_LIBS" \
                                                               "$GE_WINE" \
                                                                               --version
```

#### 実行結果

Wine 11.0 Stagingが表示された。

#### 生成・変更されたもの

検証専用または変数設定のみ。変更対象はコマンド本文と出力証拠から断定しない。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(241).txt lines 53-59`

---
### コマンド 005 — `S241-04`

#### 目的

旧base prefixのWineプロセスを停止する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
WINEPREFIX="$BASE_PREFIX"
```

#### 実行コマンド

```fish
env \
                                                                                              WINEPREFIX="$BASE_PREFIX" \
          wineserver -k \
                                                                            2>/dev/null

                                                                        sleep 1
```

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(241).txt:63-68`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(241).txt lines 63-68`

---
### コマンド 006 — `S241-05`

#### 目的

既存`prefix-ge`をtimestamp付きbackupへ退避する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
                                                                        set STAMP \
                  (date +%Y%m%d-%H%M%S)
```

#### 実行コマンド

```fish
if test -e "$GE_PREFIX"
                                                                        set STAMP \
                  (date +%Y%m%d-%H%M%S)

                                                          mv \
                                                                                                   "$GE_PREFIX" \
                  "$GE_PREFIX.before-recreate-$STAMP"
                                        end
```

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(241).txt:71-78`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。

#### 採用可否

```text
内容を修正してからREPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(241).txt lines 71-78`

---
### コマンド 007 — `V241-07`

#### 目的

作成されたprefix基本ファイルの存在を確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
for path in \
          "$GE_PREFIX/user.reg" \
                                                                    "$GE_PREFIX/system.reg" \
                                                                  "$GE_PREFIX/userdef.reg" \
                                                                 "$GE_PREFIX/drive_c/windows/system32"

                                                  test -e "$path"
                                                                        end
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(241).txt:106-113` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(241).txt lines 106-113`

---
### コマンド 008 — `S241-08`

#### 目的

AviUtl2本体ディレクトリをbase prefixから`prefix-ge`へコピーする。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
rm -rf \
                                                                                           "$GE_PREFIX/drive_c/AviUtl2"

  cp -a \
                                                                                            "$BASE_PREFIX/drive_c/AviUtl2" \
                                                           "$GE_PREFIX/drive_c/AviUtl2"
```

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(241).txt:116-121`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(241).txt lines 116-121`

---
### コマンド 009 — `S241-09`

#### 目的

ProgramDataのAviUtl2データをbase prefixから`prefix-ge`へコピーする。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
mkdir -p \
                                                                                         "$GE_PREFIX/drive_c/ProgramData"

                                                   rm -rf \
          "$GE_PREFIX/drive_c/ProgramData/aviutl2"

                                           cp -a \
                                                                                            "$BASE_PREFIX/drive_c/ProgramData/aviutl2" \
          "$GE_PREFIX/drive_c/ProgramData/aviutl2"
```

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(241).txt:124-132`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(241).txt lines 124-132`

---
### コマンド 010 — `S241-10`

#### 目的

base prefixのD3D/DXVK関連DLLを`prefix-ge/system32`へ配置する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
                                                                         set src \
                                                                                              "$BASE_PREFIX/drive_c/windows/system32/$dll.dll"

      set dst \
                                                                                              "$GE_PREFIX/drive_c/windows/system32/$dll.dll"
```

#### 実行コマンド

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

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(241).txt:135-153`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(241).txt lines 135-153`

---
### コマンド 011 — `V241-11`

#### 目的

配置済みD3D DLLのSHA-256を確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
sha256sum \
                                                                                        "$GE_PREFIX/drive_c/windows/system32/d3d11.dll" \
                                          "$GE_PREFIX/drive_c/windows/system32/dxgi.dll" \
                                           "$GE_PREFIX/drive_c/windows/system32/d3d10core.dll" \
          "$GE_PREFIX/drive_c/windows/system32/d3dcompiler_47.dll"
```

#### 実行結果

dxgi、d3d10core、d3dcompiler_47の固定SHAと当時のd3d11 SHAが出力された。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、DXVK DLL。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(241).txt lines 156-160`

---
### コマンド 012 — `S241-12`

#### 目的

DXVK source/output変数を設定する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
set DXVK_SRC \
          "$ROOT/src/dxvk-2.7.1-aviutl2"

                                                     set DXVK_OUT \
                                                                                     "$ROOT/runtime/dxvk-2.7.1-aviutl2"
```

#### 実行コマンド

```fish
set DXVK_SRC \
          "$ROOT/src/dxvk-2.7.1-aviutl2"

                                                     set DXVK_OUT \
                                                                                     "$ROOT/runtime/dxvk-2.7.1-aviutl2"
```

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(241).txt:163-167`。

#### 生成・変更されたもの

コマンド本文に記載された対象。詳細は実行コマンドを参照。

#### 関連する固定値

- version: `2.7.1`

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(241).txt lines 163-167`

---
### コマンド 013 — `S241-13`

#### 目的

既存DXVK build.w64を再コンパイルしruntime出力へインストールする。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
meson compile \
                                                                                    -C "$DXVK_SRC/build.w64" \
          -j (nproc)

                                                                         and meson install \
                                                                                -C "$DXVK_SRC/build.w64"
```

#### 実行結果

Ninjaが完了し、DXVK DLL群がruntime出力へインストールされた。

#### 生成・変更されたもの

コマンド本文に記載された対象。詳細は実行コマンドを参照。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(241).txt lines 170-175`

---
### コマンド 014 — `V241-14`

#### 目的

生成されたpatched d3d11.dllのmarkerを確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
set PATCHED_D3D11 \
                                                                                "$DXVK_OUT/bin/d3d11.dll"
```

#### 実行コマンド

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

#### 実行結果

`AviUtl2 compatibility: format 69 unsupported; returning S_OK`が確認された。

#### 生成・変更されたもの

DXVK DLL。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(241).txt lines 183-192`

---
### コマンド 015 — `S241-15`

#### 目的

旧d3d11.dllをbackupし、patched d3d11.dllを`prefix-ge`へ配置する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
                                                                                    set STAMP \
                                                                                        (date +%Y%m%d-%H%M%S)

WINEPREFIX="$GE_PREFIX"
```

#### 実行コマンド

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

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(241).txt:196-214`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、DXVK DLL。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。

#### 採用可否

```text
内容を修正してからREPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(241).txt lines 196-214`

---
### コマンド 016 — `V241-16`

#### 目的

patched d3d11.dllとactive DLLのSHA・byte一致を確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

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

#### 実行結果

両方が`1c706356...25364`で一致し`OK`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、DXVK DLL。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(241).txt lines 217-227`

---
### コマンド 017 — `S241-17`

#### 目的

DXVK config path変数を設定する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
set DXVK_CONFIG_FILE \
                                                                             "$ROOT/nvidia-dxvk.conf"
```

#### 実行コマンド

```fish
set DXVK_CONFIG_FILE \
                                                                             "$ROOT/nvidia-dxvk.conf"
```

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(241).txt:231-232`。

#### 生成・変更されたもの

コマンド本文に記載された対象。詳細は実行コマンドを参照。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(241).txt lines 231-232`

---
### コマンド 018 — `V241-18`

#### 目的

`prefix-ge`でAviUtl2を起動しformat 69 workaround到達を確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
WINEPREFIX="$GE_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$DXVK_CONFIG_FILE"

DXVK_LOG_LEVEL=warn

WINEDEBUG=-all
```

#### 実行コマンド

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

#### 実行結果

ログにformat 69 workaroundが出た。画面表示結果はこのログ単独では断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(241).txt lines 235-254`

---
### コマンド 019 — `V242-01`

#### 目的

歴史的な最初の成功環境のlauncher、prefix、vkd3d DLLの存在を確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
set OLD_ROOT \
          "$HOME/projects/aviutl2-linux"

  set OLD_PREFIX \
          "$OLD_ROOT/pfx-ge/pfx"
```

#### 実行コマンド

```fish
set OLD_ROOT \
          "$HOME/projects/aviutl2-linux"

  set OLD_PREFIX \
          "$OLD_ROOT/pfx-ge/pfx"

  for path in \
          "$OLD_ROOT/launch-ge.sh" \
          "$OLD_ROOT/aviutl2.exe" \
          "$OLD_PREFIX/user.reg" \
          "$OLD_PREFIX/system.reg" \
          "$OLD_PREFIX/drive_c/windows/system32/libvkd3d-1.dll" \
          "$OLD_PREFIX/drive_c/windows/system32/libvkd3d-shader-1.dll" \
          "$OLD_PREFIX/drive_c/windows/system32/libvkd3d-utils-1.dll"

      test -e "$path"

      or begin
          echo "ERROR: original first-success path is missing: $path" >&2
          return 1
      end

      echo "OK: $path"
  end
```

#### 実行結果

列挙した7パスすべてが`OK`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

- path: `$HOME/projects/aviutl2-linux`

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。
- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(242).txt lines 2-25`

---
### コマンド 020 — `V242-02`

#### 目的

旧`~/projects/aviutl2-linux`の最初の成功launcherを再実行し、原初成功ログを保存する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
AVIUTL2_AUTO_DISMISS=0
```

#### 実行コマンド

```fish
cd \
          "$OLD_ROOT"

  env \
          AVIUTL2_AUTO_DISMISS=0 \
          ./launch-ge.sh \
          2>&1 \
          | tee \
              "$HOME/Games/aviutl2/logs/original-first-success-launch.log"
```

#### 実行結果

launcherはpatched d3d11を適用しAviUtl2を起動、DXVK/GPU情報を出力して終了status 0。歴史的検証であり現行最終手順には採用しない。

#### 生成・変更されたもの

ログファイル。

#### 関連する固定値

- path: `$HOME/Games/aviutl2/logs/original-first-success-launch.log`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(242).txt lines 35-43`

---
### コマンド 021 — `S242-03`

#### 目的

正規repositoryへカレントディレクトリを戻す。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
cd ~/projects/aviutl2-linux-patches
```

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(242).txt:823-823`。

#### 生成・変更されたもの

コマンド本文に記載された対象。詳細は実行コマンドを参照。

#### 関連する固定値

- path: `~/projects/aviutl2-linux-patches`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(242).txt lines 823-823`

---
### コマンド 022 — `S242-04`

#### 目的

`prefix-ge`へD3D DLL overrideを登録する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
WINEPREFIX="$GE_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"
```

#### 実行コマンド

```fish
for dll in \
          d3d11 \
          dxgi \
          d3d10core

      env \
                  WINEPREFIX="$GE_PREFIX" \
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
          WINEPREFIX="$GE_PREFIX" \
          LD_LIBRARY_PATH="$GE_LIBS" \
          "$GE_WINE" \
          reg add \
          'HKEY_CURRENT_USER\Software\Wine\DllOverrides' \
          /v d3dcompiler_47 \
          /d native,builtin \
          /f

  or return 1
```

#### 実行結果

4回の`reg: The operation completed successfully`が出力された。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(242).txt lines 826-854`

---
### コマンド 023 — `V242-05`

#### 目的

`prefix-ge`のDllOverridesを確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
WINEPREFIX="$GE_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"
```

#### 実行コマンド

```fish
env \
          WINEPREFIX="$GE_PREFIX" \
          LD_LIBRARY_PATH="$GE_LIBS" \
          "$GE_WINE" \
          reg query \
          'HKEY_CURRENT_USER\Software\Wine\DllOverrides'

  or return 1
```

#### 実行結果

d3d11/dxgi/d3d10core/d3dcompiler_47がnative,builtinで登録されていることを確認。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(242).txt lines 889-896`

---
### コマンド 024 — `V242-06`

#### 目的

`prefix-ge`で最終再現起動ログを取得し、Wine/tee statusを記録する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
  set PIPE_RESULT \
          $pipestatus

WINEPREFIX="$GE_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=info

DXVK_LOG_PATH="$ROOT/logs"
```

#### 実行コマンド

```fish
mkdir -p \
          "$ROOT/logs"

  rm -f \
          "$ROOT/logs/aviutl2-final-test-reproduction.log"

  env \
          WINEPREFIX="$GE_PREFIX" \
          LD_LIBRARY_PATH="$GE_LIBS" \
          "$GE_WINESERVER" \
          -k \
          2>/dev/null

  sleep 1

  cd \
          "$GE_PREFIX/drive_c/AviUtl2"

  env \
          WINEPREFIX="$GE_PREFIX" \
          LD_LIBRARY_PATH="$GE_LIBS" \
          WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b' \
          DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
          DXVK_LOG_LEVEL=info \
          DXVK_LOG_PATH="$ROOT/logs" \
          "$GE_WINE" \
          ./aviutl2.exe \
          2>&1 \
          | tee \
              "$ROOT/logs/aviutl2-final-test-reproduction.log"

  set PIPE_RESULT \
          $pipestatus

  echo "wine status: $PIPE_RESULT[1]"
  echo "tee status:  $PIPE_RESULT[2]"
```

#### 実行結果

DXVK 2.7.1、config読込、起動ログを記録。wine/tee statusはログ末尾で0。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(242).txt lines 962-997`

---
### コマンド 025 — `S243-01`

#### 目的

current prefix clone用のroot/runner変数を設定する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
set ROOT \
          "$HOME/Games/aviutl2"

  set GE_PREFIX \
          "$ROOT/prefix-ge"

  set NV_PREFIX \
          "$ROOT/prefix-ge-nvdec-test"

  set GE_OK \
          "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test.backup-20260731-135348"

  set GE_OK_WINESERVER \
          "$GE_OK/files/bin/wineserver"

  set GE_OK_LIBS \
          "$GE_OK/files/lib64:$GE_OK/files/lib:$GE_OK/files/lib/wine/x86_64-unix:$GE_OK/files/lib/wine/i386-unix"
```

#### 実行コマンド

```fish
set ROOT \
          "$HOME/Games/aviutl2"

  set GE_PREFIX \
          "$ROOT/prefix-ge"

  set NV_PREFIX \
          "$ROOT/prefix-ge-nvdec-test"

  set GE_OK \
          "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test.backup-20260731-135348"

  set GE_OK_WINESERVER \
          "$GE_OK/files/bin/wineserver"

  set GE_OK_LIBS \
          "$GE_OK/files/lib64:$GE_OK/files/lib:$GE_OK/files/lib/wine/x86_64-unix:$GE_OK/files/lib/wine/i386-unix"
```

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(243).txt:6978-6994`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

- 短縮commit: `20260731`
- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test.backup-20260731-135348`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。

#### 採用可否

```text
内容を修正してからREPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(243).txt lines 6978-6994`

---
### コマンド 026 — `S243-02`

#### 目的

base `prefix-ge`のWineプロセスを停止・待機する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
WINEPREFIX="$GE_PREFIX"

LD_LIBRARY_PATH="$GE_OK_LIBS"
```

#### 実行コマンド

```fish
env \
          WINEPREFIX="$GE_PREFIX" \
          LD_LIBRARY_PATH="$GE_OK_LIBS" \
          "$GE_OK_WINESERVER" \
          -k

  and env \
          WINEPREFIX="$GE_PREFIX" \
          LD_LIBRARY_PATH="$GE_OK_LIBS" \
          "$GE_OK_WINESERVER" \
          -w

  or return 1
```

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(243).txt:6997-7009`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(243).txt lines 6997-7009`

---
### コマンド 027 — `S243-03`

#### 目的

既存NV prefixをtimestamp付きbackupへ退避する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
set STAMP \
          (date +%Y%m%d-%H%M%S)
```

#### 実行コマンド

```fish
set STAMP \
          (date +%Y%m%d-%H%M%S)

  if test -e "$NV_PREFIX"
      mv \
                  "$NV_PREFIX" \
                  "$NV_PREFIX.before-confirmed-dwrite-clone-$STAMP"

      or return 1
  end
```

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(243).txt:7012-7021`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。
- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。

#### 採用可否

```text
内容を修正してからREPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(243).txt lines 7012-7021`

---
### コマンド 028 — `S243-04`

#### 目的

確認済み`prefix-ge`を`prefix-ge-nvdec-test`へreflink cloneする。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
cp -a \
          --reflink=auto \
          "$GE_PREFIX" \
          "$NV_PREFIX"

  or return 1
```

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(243).txt:7024-7029`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(243).txt lines 7024-7029`

---
### コマンド 029 — `V243-05`

#### 目的

clone後のregistry、AviUtl2本体、D3D DLLをbyte比較する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

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

#### 実行結果

全8対象で`MATCH`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、DXVK DLL。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(243).txt lines 7032-7053`

---
### コマンド 030 — `V243-06`

#### 目的

clone直後のNV prefixでAviUtl2を起動しformat 69到達を確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
set GE_OK_WINE \
          "$GE_OK/files/lib/wine/x86_64-unix/wine"

WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_OK_LIBS"

WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG=-all
```

#### 実行コマンド

```fish
set GE_OK_WINE \
          "$GE_OK/files/lib/wine/x86_64-unix/wine"

  cd \
          "$NV_PREFIX/drive_c/AviUtl2"

  env \
          WINEPREFIX="$NV_PREFIX" \
          LD_LIBRARY_PATH="$GE_OK_LIBS" \
          WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
          DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
          DXVK_LOG_LEVEL=warn \
          WINEDEBUG=-all \
          "$GE_OK_WINE" \
          ./aviutl2.exe
```

#### 実行結果

起動ログにformat 69 workaround。GUIの完全成功は後段で確認。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(243).txt lines 7064-7078`

---
### コマンド 031 — `S243-07`

#### 目的

NV prefixとknown-good runner変数を再設定する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
set ROOT \
          "$HOME/Games/aviutl2"

  set NV_PREFIX \
          "$ROOT/prefix-ge-nvdec-test"

  set GE_OK \
          "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test.backup-20260731-135348"

  set GE_OK_WINE \
          "$GE_OK/files/lib/wine/x86_64-unix/wine"

  set GE_OK_WINESERVER \
          "$GE_OK/files/bin/wineserver"

  set GE_OK_LIBS \
          "$GE_OK/files/lib64:$GE_OK/files/lib:$GE_OK/files/lib/wine/x86_64-unix:$GE_OK/files/lib/wine/i386-unix"
```

#### 実行コマンド

```fish
set ROOT \
          "$HOME/Games/aviutl2"

  set NV_PREFIX \
          "$ROOT/prefix-ge-nvdec-test"

  set GE_OK \
          "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test.backup-20260731-135348"

  set GE_OK_WINE \
          "$GE_OK/files/lib/wine/x86_64-unix/wine"

  set GE_OK_WINESERVER \
          "$GE_OK/files/bin/wineserver"

  set GE_OK_LIBS \
          "$GE_OK/files/lib64:$GE_OK/files/lib:$GE_OK/files/lib/wine/x86_64-unix:$GE_OK/files/lib/wine/i386-unix"
```

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(243).txt:7087-7103`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

- 短縮commit: `20260731`
- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test.backup-20260731-135348`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。

#### 採用可否

```text
内容を修正してからREPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(243).txt lines 7087-7103`

---
### コマンド 032 — `S243-08`

#### 目的

NV prefixのWineプロセスを停止・待機する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_OK_LIBS"
```

#### 実行コマンド

```fish
env \
          WINEPREFIX="$NV_PREFIX" \
          LD_LIBRARY_PATH="$GE_OK_LIBS" \
          "$GE_OK_WINESERVER" \
          -k

  and env \
          WINEPREFIX="$NV_PREFIX" \
          LD_LIBRARY_PATH="$GE_OK_LIBS" \
          "$GE_OK_WINESERVER" \
          -w

  or return 1
```

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(243).txt:7106-7118`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(243).txt lines 7106-7118`

---
### コマンド 033 — `S243-09`

#### 目的

NVIDIA DLL overrideをnativeへ登録する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_OK_LIBS"
```

#### 実行コマンド

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

#### 実行結果

nvcuda/nvcuvid/nvencodeapi64の3件で成功。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(243).txt lines 7121-7137`

---
### コマンド 034 — `V243-10`

#### 目的

NVIDIA DLL override値を確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_OK_LIBS"
```

#### 実行コマンド

```fish
env \
          WINEPREFIX="$NV_PREFIX" \
          LD_LIBRARY_PATH="$GE_OK_LIBS" \
          "$GE_OK_WINE" \
          reg query \
          'HKEY_CURRENT_USER\Software\Wine\DllOverrides' \
          /v nvcuda

  and env \
          WINEPREFIX="$NV_PREFIX" \
          LD_LIBRARY_PATH="$GE_OK_LIBS" \
          "$GE_OK_WINE" \
          reg query \
          'HKEY_CURRENT_USER\Software\Wine\DllOverrides' \
          /v nvcuvid

  and env \
          WINEPREFIX="$NV_PREFIX" \
          LD_LIBRARY_PATH="$GE_OK_LIBS" \
          "$GE_OK_WINE" \
          reg query \
          'HKEY_CURRENT_USER\Software\Wine\DllOverrides' \
          /v nvencodeapi64

  or return 1
```

#### 実行結果

3件すべて`REG_SZ native`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(243).txt lines 7169-7193`

---
### コマンド 035 — `V243-11`

#### 目的

NVIDIA overrideを含む構成でAviUtl2を短時間起動する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_OK_LIBS"

WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG=-all
```

#### 実行コマンド

```fish
cd \
          "$NV_PREFIX/drive_c/AviUtl2"

  env \
          WINEPREFIX="$NV_PREFIX" \
          LD_LIBRARY_PATH="$GE_OK_LIBS" \
          WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
          DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
          DXVK_LOG_LEVEL=warn \
          WINEDEBUG=-all \
          "$GE_OK_WINE" \
          ./aviutl2.exe
```

#### 実行結果

format 69 workaroundへ到達。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(243).txt lines 7234-7245`

---
### コマンド 036 — `S243-12`

#### 目的

known-good backupのフォントを復旧するための変数を設定する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
set ROOT \
          "$HOME/Games/aviutl2"

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

#### 実行コマンド

```fish
set ROOT \
          "$HOME/Games/aviutl2"

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

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(243).txt:7254-7279`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、WineフォントファイルまたはFont registry。

#### 関連する固定値

- 短縮commit: `20260731`
- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test.backup-20260731-135348`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。

#### 採用可否

```text
内容を修正してからREPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(243).txt lines 7254-7279`

---
### コマンド 037 — `V243-13`

#### 目的

4つのknown-good fontファイルの存在を確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

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

#### 実行結果

4ファイルすべて`OK`。

#### 生成・変更されたもの

WineフォントファイルまたはFont registry。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(243).txt lines 7282-7296`

---
### コマンド 038 — `S243-14`

#### 目的

base/NV prefix双方のWineプロセスを停止する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
WINEPREFIX="$PREFIX"

LD_LIBRARY_PATH="$GE_OK_LIBS"
```

#### 実行コマンド

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

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(243).txt:7303-7326`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(243).txt lines 7303-7326`

---
### コマンド 039 — `S243-15`

#### 目的

Noto CJK TTCとTahoma-compatible OTFをbase/NV prefix双方へ配置する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
      set DEST_FONTS \
                  "$PREFIX/drive_c/windows/Fonts"
```

#### 実行コマンド

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

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(243).txt:7329-7367`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、WineフォントファイルまたはFont registry。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(243).txt lines 7329-7367`

---
### コマンド 040 — `S243-16`

#### 目的

Fonts/FontSubstitutes registry key変数を設定する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
set REG_FONTS \
          'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Fonts'

  set REG_SUBS \
          'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\FontSubstitutes'
```

#### 実行コマンド

```fish
set REG_FONTS \
          'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Fonts'

  set REG_SUBS \
          'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\FontSubstitutes'
```

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(243).txt:7370-7374`。

#### 生成・変更されたもの

WineフォントファイルまたはFont registry。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(243).txt lines 7370-7374`

---
### コマンド 041 — `S243-17`

#### 目的

Noto Sans CJK JPとTahoma-compatible fontのFonts registry entriesを登録する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
WINEPREFIX="$PREFIX"

LD_LIBRARY_PATH="$GE_OK_LIBS"
```

#### 実行コマンド

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

#### 実行結果

両prefixで各4項目が成功。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、WineフォントファイルまたはFont registry。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(243).txt lines 7377-7418`

---
### コマンド 042 — `S243-18`

#### 目的

旧Tahoma FontSubstituteを削除する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
WINEPREFIX="$PREFIX"

LD_LIBRARY_PATH="$GE_OK_LIBS"
```

#### 実行コマンド

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

#### 実行結果

一方では値なしが出たが`or true`で継続。最終状態では不要なmappingが除去された。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、WineフォントファイルまたはFont registry。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(243).txt lines 7482-7495`

---
### コマンド 043 — `S243-19`

#### 目的

MS Shell Dlg系をTahomaへ、日本語font aliasesをNoto Sans CJK JPへ登録する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
WINEPREFIX="$PREFIX"

LD_LIBRARY_PATH="$GE_OK_LIBS"
```

#### 実行コマンド

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

#### 実行結果

両prefixで全registry addが成功。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、WineフォントファイルまたはFont registry。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(243).txt lines 7541-7584`

---
### コマンド 044 — `S243-20`

#### 目的

フォント設定反映のため両prefixで`wineboot -u`し終了待ちする。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
WINEPREFIX="$PREFIX"

LD_LIBRARY_PATH="$GE_OK_LIBS"
```

#### 実行コマンド

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

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(243).txt:7696-7713`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(243).txt lines 7696-7713`

---
### コマンド 045 — `S243-21`

#### 目的

フォント反映確認のため両prefixで`wineboot -u`を再実行する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
WINEPREFIX="$PREFIX"

LD_LIBRARY_PATH="$GE_OK_LIBS"
```

#### 実行コマンド

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

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(243).txt:7766-7783`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(243).txt lines 7766-7783`

---
### コマンド 046 — `V243-22`

#### 目的

Tahoma/Noto font登録とFontSubstitutesをqueryする。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_OK_LIBS"
```

#### 実行コマンド

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

#### 実行結果

Tahoma OTF、Noto TTC、MS Shell Dlg→Tahoma、Yu Gothic UI→Notoを確認。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、WineフォントファイルまたはFont registry。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(243).txt lines 7836-7864`

---
### コマンド 047 — `S243-23`

#### 目的

フォント復旧後のNV prefixでAviUtl2を起動する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_OK_LIBS"

WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG=-all
```

#### 実行コマンド

```fish
cd \
          "$NV_PREFIX/drive_c/AviUtl2"

  env \
          WINEPREFIX="$NV_PREFIX" \
          LD_LIBRARY_PATH="$GE_OK_LIBS" \
          WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
          DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
          DXVK_LOG_LEVEL=warn \
          WINEDEBUG=-all \
          "$GE_OK_WINE" \
          ./aviutl2.exe
```

#### 実行結果

ユーザーがメインウィンドウ表示と文字化けなしを確認。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(243).txt lines 7911-7922`

---
### コマンド 048 — `S243-24`

#### 目的

L-SMASH導入前にWineプロセスを完全停止する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_OK_LIBS"
```

#### 実行コマンド

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

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(243).txt:7931-7945`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(243).txt lines 7931-7945`

---
### コマンド 049 — `S243-25`

#### 目的

L-SMASH導入前のprefix checkpointを作成する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
set STAMP \
          (date +%Y%m%d-%H%M%S)

  set PRE_LSMASH_BACKUP \
          "$NV_PREFIX.before-lsmash-$STAMP"
```

#### 実行コマンド

```fish
set STAMP \
          (date +%Y%m%d-%H%M%S)

  set PRE_LSMASH_BACKUP \
          "$NV_PREFIX.before-lsmash-$STAMP"

  cp -a \
          --reflink=auto \
          "$NV_PREFIX" \
          "$PRE_LSMASH_BACKUP"

  or return 1

  echo "Saved checkpoint:"
  echo "$PRE_LSMASH_BACKUP"
```

#### 実行結果

`prefix-ge-nvdec-test.before-lsmash-20260801-202533`を作成。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。
- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。

#### 採用可否

```text
内容を修正してからREPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(243).txt lines 7948-7962`

---
### コマンド 050 — `V243-26`

#### 目的

repro-03 artifactとINIの存在、plugin SHAを確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
set ARTIFACT_DIR \
          "$ROOT/build/l-smash-works-nvdec-repro-03/output"

  set BUILT_LWINPUT \
          "$ARTIFACT_DIR/lwinput.aui2"

  set BUILT_INI \
          "$ARTIFACT_DIR/lsmash.ini"
```

#### 実行コマンド

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

#### 実行結果

plugin SHAは`db465570...17bbe0`。

#### 生成・変更されたもの

L-SMASH Works plugin/config。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(243).txt lines 7967-7984`

---
### コマンド 051 — `V243-27`

#### 目的

r1284、av1_cuvid、FFmpeg configure markerを確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

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

#### 実行結果

必須markerがすべて出力。

#### 生成・変更されたもの

検証専用または変数設定のみ。変更対象はコマンド本文と出力証拠から断定しない。

#### 関連する固定値

- version: `r1284`

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(243).txt lines 7988-8003`

---
### コマンド 052 — `S243-28`

#### 目的

active Plugin directoryとファイル変数を設定しdirectoryを確保する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
set PLUGIN_DIR \
          "$NV_PREFIX/drive_c/ProgramData/aviutl2/Plugin"

  set ACTIVE_LWINPUT \
          "$PLUGIN_DIR/lwinput.aui2"

  set ACTIVE_INI \
          "$PLUGIN_DIR/lsmash.ini"
```

#### 実行コマンド

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

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(243).txt:8010-8022`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、L-SMASH Works plugin/config。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(243).txt lines 8010-8022`

---
### コマンド 053 — `S243-29`

#### 目的

既存lwinput.aui2/lsmash.iniをtimestamp付きbackupする。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
set STAMP \
          (date +%Y%m%d-%H%M%S)
```

#### 実行コマンド

```fish
set STAMP \
          (date +%Y%m%d-%H%M%S)

  if test -f "$ACTIVE_LWINPUT"
      cp -a \
                  "$ACTIVE_LWINPUT" \
                  "$ACTIVE_LWINPUT.before-r1284-$STAMP"

      or return 1
  end

  if test -f "$ACTIVE_INI"
      cp -a \
                  "$ACTIVE_INI" \
                  "$ACTIVE_INI.before-r1284-$STAMP"

      or return 1
  end
```

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(243).txt:8025-8042`。

#### 生成・変更されたもの

コマンド本文に記載された対象。詳細は実行コマンドを参照。

#### 関連する固定値

- version: `r1284`

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。
- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。

#### 採用可否

```text
内容を修正してからREPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(243).txt lines 8025-8042`

---
### コマンド 054 — `S243-30`

#### 目的

repro-03 lwinput.aui2をactive pluginへ配置しbyte一致を確認する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

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

  or begin
      echo "ERROR: lwinput.aui2 copy mismatch" >&2
      return 1
  end
```

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(243).txt:8045-8060`。

#### 生成・変更されたもの

L-SMASH Works plugin/config。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(243).txt lines 8045-8060`

---
### コマンド 055 — `S243-31`

#### 目的

repro-03 lsmash.iniをactive pluginへ配置する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
if test -f "$BUILT_INI"
      install \
                  -m 0644 \
                  "$BUILT_INI" \
                  "$ACTIVE_INI"

      or return 1
  end
```

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(243).txt:8063-8070`。

#### 生成・変更されたもの

コマンド本文に記載された対象。詳細は実行コマンドを参照。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(243).txt lines 8063-8070`

---
### コマンド 056 — `S243-32`

#### 目的

active lsmash.iniをNVDEC設定へ書き換える。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
test -f "$ACTIVE_INI"

  or begin
      echo "ERROR: lsmash.ini is missing" >&2
      return 1
  end

  sed -i \
          -e 's/^libavsmash_disabled=.*/libavsmash_disabled=1/' \
          -e 's/^libav_disabled=.*/libav_disabled=0/' \
          -e 's/^preferred_decoders=.*/preferred_decoders=av1_cuvid/' \
          "$ACTIVE_INI"

  or return 1
```

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(243).txt:8073-8086`。

#### 生成・変更されたもの

L-SMASH Works plugin/config。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(243).txt lines 8073-8086`

---
### コマンド 057 — `V243-33`

#### 目的

active plugin SHAとlsmash.iniの必須3値を確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
sha256sum \
          "$ACTIVE_LWINPUT"

  grep -nE \
          '^(libavsmash_disabled|libav_disabled|preferred_decoders)=' \
          "$ACTIVE_INI"
```

#### 実行結果

SHA`db465...`、`libavsmash_disabled=1`、`libav_disabled=0`、`preferred_decoders=av1_cuvid`。

#### 生成・変更されたもの

検証専用または変数設定のみ。変更対象はコマンド本文と出力証拠から断定しない。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(243).txt lines 8089-8094`

---
### コマンド 058 — `S243-34`

#### 目的

custom r1284導入後のAviUtl2を起動する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_OK_LIBS"

WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG=-all
```

#### 実行コマンド

```fish
cd \
          "$NV_PREFIX/drive_c/AviUtl2"

  env \
          WINEPREFIX="$NV_PREFIX" \
          LD_LIBRARY_PATH="$GE_OK_LIBS" \
          WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
          DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
          DXVK_LOG_LEVEL=warn \
          WINEDEBUG=-all \
          "$GE_OK_WINE" \
          ./aviutl2.exe
```

#### 実行結果

ユーザーがメインウィンドウ、文字化けなし、L-SMASH Works r1284認識を確認。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(243).txt lines 8101-8112`

---
### コマンド 059 — `S244-01`

#### 目的

Mozc/DWrite検証用のroot、prefix、runner変数を設定する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
set ROOT \
          "$HOME/Games/aviutl2"

  set NV_PREFIX \
          "$ROOT/prefix-ge-nvdec-test"

  set GE_OK \
          "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test.backup-20260731-135348"

  set GE_OK_WINE \
          "$GE_OK/files/lib/wine/x86_64-unix/wine"

  set GE_OK_WINESERVER \
          "$GE_OK/files/bin/wineserver"

  set GE_OK_LIBS \
          "$GE_OK/files/lib64:$GE_OK/files/lib:$GE_OK/files/lib/wine/x86_64-unix:$GE_OK/files/lib/wine/i386-unix"
```

#### 実行コマンド

```fish
set ROOT \
          "$HOME/Games/aviutl2"

  set NV_PREFIX \
          "$ROOT/prefix-ge-nvdec-test"

  set GE_OK \
          "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test.backup-20260731-135348"

  set GE_OK_WINE \
          "$GE_OK/files/lib/wine/x86_64-unix/wine"

  set GE_OK_WINESERVER \
          "$GE_OK/files/bin/wineserver"

  set GE_OK_LIBS \
          "$GE_OK/files/lib64:$GE_OK/files/lib:$GE_OK/files/lib/wine/x86_64-unix:$GE_OK/files/lib/wine/i386-unix"
```

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(244).txt:2-19`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

- 短縮commit: `20260731`
- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test.backup-20260731-135348`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。

#### 採用可否

```text
内容を修正してからREPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(244).txt lines 2-19`

---
### コマンド 060 — `V244-02`

#### 目的

ホストのXMODIFIERSとFcitx5/Mozcプロセスを確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
XMODIFIERS=%s

XMODIFIERS=@im=fcitx
```

#### 実行コマンド

```fish
printf 'XMODIFIERS=%s\n' \
          (printenv XMODIFIERS)

  pgrep -a -f \
          'fcitx5|mozc'
XMODIFIERS=@im=fcitx
8304 /usr/bin/fcitx5
9022 /usr/lib/mozc/mozc_server
```

#### 実行結果

`XMODIFIERS=@im=fcitx`、fcitx5、mozc_server稼働を確認。

#### 生成・変更されたもの

検証専用または変数設定のみ。変更対象はコマンド本文と出力証拠から断定しない。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(244).txt lines 21-29`

---
### コマンド 061 — `S244-03`

#### 目的

AviUtl2専用`InputStyle=overthespot`を登録する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_OK_LIBS"
```

#### 実行コマンド

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

#### 実行結果

レジストリ操作成功。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(244).txt lines 31-42`

---
### コマンド 062 — `V244-04`

#### 目的

InputStyle値をqueryする。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_OK_LIBS"
```

#### 実行コマンド

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

#### 実行結果

`REG_SZ overthespot`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(244).txt lines 68-76`

---
### コマンド 063 — `S244-05`

#### 目的

テキスト検証前にWineプロセスを停止・待機する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_OK_LIBS"
```

#### 実行コマンド

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

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(244).txt:90-104`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(244).txt lines 90-104`

---
### コマンド 064 — `S244-06`

#### 目的

テキスト検証ログを初期化しAviUtl2ディレクトリへ移動する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
set TEXT_LOG \
          "$ROOT/logs/aviutl2-text-mozc-reproduction.log"
```

#### 実行コマンド

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

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(244).txt:107-117`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(244).txt lines 107-117`

---
### コマンド 065 — `V244-07`

#### 目的

Fcitx XIMとDWrite traceを有効にしてAviUtl2を起動し実操作する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
XMODIFIERS='@im=fcitx'

WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_OK_LIBS"

WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG='-all,+timestamp,+dwrite,+xim,+imm,+seh'
```

#### 実行コマンド

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

#### 実行結果

ユーザーが日本語変換とEnter確定を確認。ログ生成。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(244).txt lines 120-130`

---
### コマンド 066 — `V244-08`

#### 目的

DWrite HitTestPoint/HitTestTextRange呼び出しを抽出する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
echo "=== DWrite hit tests ==="

  grep -nE \
          'dwritetextlayout_HitTest(Point|TextRange)' \
          "$TEXT_LOG" \
          | tail -n 100
```

#### 実行結果

両関数のtraceを確認。

#### 生成・変更されたもの

Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(244).txt lines 133-138`

---
### コマンド 067 — `V244-09`

#### 目的

stub、E_NOTIMPL、未処理例外を検出する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
echo "=== Fatal text-editing errors ==="

  grep -nEi \
          'HitTest(Point|TextRange).*stub|E_NOTIMPL|80004001|Unhandled exception|unhandled page fault|C\+\+ exception' \
          "$TEXT_LOG"

  or echo "No fatal text-editing errors found."
```

#### 実行結果

`No fatal text-editing errors found.`

#### 生成・変更されたもの

ログファイル。

#### 関連する固定値

- 短縮commit: `80004001`

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(244).txt lines 150-156`

---
### コマンド 068 — `V244-10`

#### 目的

XIM style選択を確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
echo "=== XIM style ==="

  grep -nEi \
                                                                                        'requesting|selected style' \
                                                              "$TEXT_LOG" \
          | head -n 30

                                                                       or echo "No XIM style line found."
```

#### 実行結果

AviUtl2 processで`overthespot` style `0x404`選択。

#### 生成・変更されたもの

ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(244).txt lines 161-168`

---
### コマンド 069 — `S245-01`

#### 目的

Catalog 0.3.3導入用のroot、prefix、runner、repository、cache、log変数を設定する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
set ROOT \
          "$HOME/Games/aviutl2"

  set REPO \
          "$HOME/projects/aviutl2-linux-patches"

  set NV_PREFIX \
          "$ROOT/prefix-ge-nvdec-test"

  set GE_OK \
          "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test.backup-20260731-135348"

  set GE_OK_WINE \
          "$GE_OK/files/lib/wine/x86_64-unix/wine"

  set GE_OK_WINESERVER \
          "$GE_OK/files/bin/wineserver"

  set GE_OK_LIBS \
          "$GE_OK/files/lib64:$GE_OK/files/lib:$GE_OK/files/lib/wine/x86_64-unix:$GE_OK/files/lib/wine/i386-unix"

  set CATALOG_VERSION \
          "0.3.3"

  set CATALOG_REPO \
          "Neosku/aviutl2-catalog"

  set CATALOG_CACHE \
          "$ROOT/downloads/aviutl2-catalog-$CATALOG_VERSION"

  set CATALOG_LOG_DIR \
          "$ROOT/logs/catalog-reproduction-"(date +%Y%m%d-%H%M%S)
```

#### 実行コマンド

```fish
set ROOT \
          "$HOME/Games/aviutl2"

  set REPO \
          "$HOME/projects/aviutl2-linux-patches"

  set NV_PREFIX \
          "$ROOT/prefix-ge-nvdec-test"

  set GE_OK \
          "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test.backup-20260731-135348"

  set GE_OK_WINE \
          "$GE_OK/files/lib/wine/x86_64-unix/wine"

  set GE_OK_WINESERVER \
          "$GE_OK/files/bin/wineserver"

  set GE_OK_LIBS \
          "$GE_OK/files/lib64:$GE_OK/files/lib:$GE_OK/files/lib/wine/x86_64-unix:$GE_OK/files/lib/wine/i386-unix"

  set CATALOG_VERSION \
          "0.3.3"

  set CATALOG_REPO \
          "Neosku/aviutl2-catalog"

  set CATALOG_CACHE \
          "$ROOT/downloads/aviutl2-catalog-$CATALOG_VERSION"

  set CATALOG_LOG_DIR \
          "$ROOT/logs/catalog-reproduction-"(date +%Y%m%d-%H%M%S)
```

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(245).txt:2-33`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Catalog application/config/state、ログファイル。

#### 関連する固定値

- 短縮commit: `20260731`
- version: `GE-Proton11-1`
- version: `0.3.3`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/projects/aviutl2-linux-patches`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test.backup-20260731-135348`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。

#### 採用可否

```text
内容を修正してからREPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(245).txt lines 2-33`

---
### コマンド 070 — `V245-02`

#### 目的

必要コマンドの存在を確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

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

#### 実行結果

欠落エラーなし。

#### 生成・変更されたもの

Git working tree、commit、remoteまたはGitHub repository。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(245).txt lines 36-50`

---
### コマンド 071 — `V245-03`

#### 目的

AviUtl2、Wine、wineserver、patched dwriteの必要pathを確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

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

#### 実行結果

欠落エラーなし。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(245).txt lines 52-65`

---
### コマンド 072 — `S245-04`

#### 目的

Catalog導入前にWineプロセスを停止・待機する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_OK_LIBS"
```

#### 実行コマンド

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

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(245).txt:67-81`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(245).txt lines 67-81`

---
### コマンド 073 — `S245-05`

#### 目的

Catalog導入前checkpointを作成する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
set CATALOG_PRE_BACKUP \
                                                                           "$NV_PREFIX.before-catalog-"(date +%Y%m%d-%H%M%S)
```

#### 実行コマンド

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

#### 実行結果

`prefix-ge-nvdec-test.before-catalog-20260801-205941`を作成。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Catalog application/config/state、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。
- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。

#### 採用可否

```text
内容を修正してからREPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(245).txt lines 84-95`

---
### コマンド 074 — `S245-06`

#### 目的

Catalog cache/log directoryを作成する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
mkdir -p \
                                                                                         "$CATALOG_CACHE" \
                                                                         "$CATALOG_LOG_DIR"

                                                                 or return 1
```

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(245).txt:99-103`。

#### 生成・変更されたもの

Catalog application/config/state、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(245).txt lines 99-103`

---
### コマンド 075 — `S245-07`

#### 目的

Catalog 0.3.3 release metadataを取得しtagを解決する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
set RELEASE_JSON \
                                                                                 "$CATALOG_CACHE/release.json"

          set CATALOG_TAG \
                          "$tag"
```

#### 実行コマンド

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

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(245).txt:106-136`。

#### 生成・変更されたもの

Catalog application/config/state、Git working tree、commit、remoteまたはGitHub repository、ログファイル。

#### 関連する固定値

- version: `0.3.3`

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(245).txt lines 106-136`

---
### コマンド 076 — `S245-08`

#### 目的

release JSONから唯一のx64 setup asset名を解決する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
set CATALOG_ASSET (
```

#### 実行コマンド

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

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(245).txt:138-163`。

#### 生成・変更されたもの

Catalog application/config/state、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(245).txt lines 138-163`

---
### コマンド 077 — `S245-09`

#### 目的

Catalog installerをdownloadし形式とSHAを確認する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
  set CATALOG_INSTALLER \
                                                                            "$CATALOG_CACHE/$CATALOG_ASSET"
```

#### 実行コマンド

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

#### 実行結果

`AviUtl2_Catalog_0.3.3_x64-setup.exe`、SHA`5591a5...44d84e`。

#### 生成・変更されたもの

Catalog application/config/state、Git working tree、commit、remoteまたはGitHub repository、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(245).txt lines 166-189`

---
### コマンド 078 — `S245-10`

#### 目的

既存prefix内でCatalog installerを実行する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
                                        set INSTALL_STATUS \
                                                                               $status

WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_OK_LIBS"

WINEDLLOVERRIDES='dwrite=b'

WINEDEBUG=-all
```

#### 実行コマンド

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

#### 実行結果

Installer status 0。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、Catalog application/config/state、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(245).txt lines 194-211`

---
### コマンド 079 — `V245-11`

#### 目的

インストールされたCatalog executableを検索・一意確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
set CATALOG_EXES (

  set CATALOG_EXE \
                                                                                  "$CATALOG_EXES[1]"
```

#### 実行コマンド

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

#### 実行結果

AppData/Local/AviUtl2 カタログ/AviUtl2_Catalog.exeを検出。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Catalog application/config/state、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(245).txt lines 215-239`

---
### コマンド 080 — `S245-12`

#### 目的

Catalogを初回起動しUIでAviUtl2 root/portable mode/プラグイン導入を行う。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_OK_LIBS"

WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG=-all
```

#### 実行コマンド

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

#### 実行結果

ユーザーがセットアップ、プラグイン導入、通常起動成功後にSUPER+Qで終了。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、Catalog application/config/state、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(245).txt lines 244-253`

---
### コマンド 081 — `S245-13`

#### 目的

Catalog終了後にWineプロセスを完全停止する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_OK_LIBS"
```

#### 実行コマンド

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

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(245).txt:256-270`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(245).txt lines 256-270`

---
### コマンド 082 — `V245-14`

#### 目的

overlay用repro-03 artifact pathとactive plugin pathを設定・存在確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
set ARTIFACT_DIR \
          "$ROOT/build/l-smash-works-nvdec-repro-03/output"

  set BUILT_LWINPUT \
          "$ARTIFACT_DIR/lwinput.aui2"

  set ACTIVE_LWINPUT \
          "$NV_PREFIX/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2"
```

#### 実行コマンド

```fish
set ARTIFACT_DIR \
          "$ROOT/build/l-smash-works-nvdec-repro-03/output"

  set BUILT_LWINPUT \
          "$ARTIFACT_DIR/lwinput.aui2"

  set ACTIVE_LWINPUT \
          "$NV_PREFIX/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2"

  test -f "$BUILT_LWINPUT"

  or begin
      echo "ERROR: missing r1284 artifact: $BUILT_LWINPUT" >&2
      return 1
  end
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(245).txt:273-287` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、L-SMASH Works plugin/config。

#### 関連する固定値

- version: `r1284`

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(245).txt lines 273-287`

---
### コマンド 083 — `V245-15`

#### 目的

overlay前artifact SHAを確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
sha256sum \
          "$BUILT_LWINPUT"
```

#### 実行結果

`db465570...17bbe0`。

#### 生成・変更されたもの

検証専用または変数設定のみ。変更対象はコマンド本文と出力証拠から断定しない。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(245).txt lines 290-291`

---
### コマンド 084 — `S245-16`

#### 目的

install helperでCatalog packageをpauseしcustom r1284を最後にoverlayする。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
"$REPO/scripts/install-l-smash-works-nvdec.fish" \
          --prefix \
          "$NV_PREFIX" \
          --artifact-dir \
          "$ARTIFACT_DIR"

  or return 1
```

#### 実行結果

helper完了。active SHA一致、pause ID設定、installed.json/hash-cache.json unchanged。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(245).txt lines 295-301`

---
### コマンド 085 — `V245-17`

#### 目的

artifactとactive pluginのSHA・byte一致を確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

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

#### 実行結果

両SHA一致、`MATCH`。

#### 生成・変更されたもの

L-SMASH Works plugin/config。

#### 関連する固定値

- version: `r1284`

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(245).txt lines 321-335`

---
### コマンド 086 — `V245-18`

#### 目的

active pluginのr1284/CUVID markerを確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

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
              'L-SMASH Works File Reader for AviUtl2 r1284 by Mr-Ojii|av1_cuvid|--enable-cuvid' \
          | sort \
              -u
```

#### 実行結果

r1284、av1_cuvid、--enable-cuvidを確認。

#### 生成・変更されたもの

検証専用または変数設定のみ。変更対象はコマンド本文と出力証拠から断定しない。

#### 関連する固定値

- version: `r1284`

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(245).txt lines 340-355`

---
### コマンド 087 — `V245-19`

#### 目的

active lsmash.iniの必須3値を確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
set ACTIVE_INI \
          "$NV_PREFIX/drive_c/ProgramData/aviutl2/Plugin/lsmash.ini"
```

#### 実行コマンド

```fish
set ACTIVE_INI \
          "$NV_PREFIX/drive_c/ProgramData/aviutl2/Plugin/lsmash.ini"

  grep -nE \
          '^(libavsmash_disabled|libav_disabled|preferred_decoders)=' \
          "$ACTIVE_INI"

  or return 1
```

#### 実行結果

期待値3件一致。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、L-SMASH Works plugin/config。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(245).txt lines 361-368`

---
### コマンド 088 — `V245-20`

#### 目的

Catalog settings.jsonを一意に検索する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
set CATALOG_SETTINGS_LIST (

  set CATALOG_SETTINGS \
          "$CATALOG_SETTINGS_LIST[1]"
```

#### 実行コマンド

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

#### 実行結果

Roaming/aviutl2-catalog/settings.jsonを検出。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Catalog application/config/state、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(245).txt lines 374-395`

---
### コマンド 089 — `V245-21`

#### 目的

settings.jsonのJSON妥当性を確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
python3 \
          -m json.tool \
          "$CATALOG_SETTINGS" \
          >/dev/null

  or return 1

  echo "settings.json: valid JSON"
```

#### 実行結果

valid JSON。

#### 生成・変更されたもの

Catalog application/config/state、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(245).txt lines 400-407`

---
### コマンド 090 — `V245-22`

#### 目的

`Mr-Ojii.L-SMASH-Works`がpause listに含まれるか確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

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

#### 実行結果

pause IDを確認。

#### 生成・変更されたもの

Catalog application/config/state、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(245).txt lines 411-436`

---
### コマンド 091 — `V245-23`

#### 目的

Catalog再起動前のactive r1284 SHAを保存する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
set R1284_SHA_BEFORE_CATALOG (
```

#### 実行コマンド

```fish
set R1284_SHA_BEFORE_CATALOG (
      sha256sum "$ACTIVE_LWINPUT" \
              | string split ' '
  )[1]

  echo "Before Catalog: $R1284_SHA_BEFORE_CATALOG"
```

#### 実行結果

`db465570...17bbe0`。

#### 生成・変更されたもの

Catalog application/config/state、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(245).txt lines 442-447`

---
### コマンド 092 — `S245-24`

#### 目的

overlay後にCatalogを再起動して通常表示を確認する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_OK_LIBS"

WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG=-all
```

#### 実行コマンド

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

#### 実行結果

Catalogは起動・終了。L-SMASH Worksへの手動更新操作なし。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、Catalog application/config/state、ログファイル。

#### 関連する固定値

- version: `r1284`

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(245).txt lines 451-460`

---
### コマンド 093 — `V245-25`

#### 目的

Catalog再起動前後のplugin SHAを比較する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
  set R1284_SHA_AFTER_CATALOG (

WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_OK_LIBS"
```

#### 実行コマンド

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

#### 実行結果

before/afterとも`db465...`で一致し、Catalogはr1284を置換しなかった。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Catalog application/config/state、ログファイル。

#### 関連する固定値

- version: `r1284`

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(245).txt lines 463-487`

---
### コマンド 094 — `S-E01`

#### 目的

known-good prefix内のNVIDIA wrapper symlinkとtargetを検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
set GOOD_PREFIX \
    "$ROOT/prefix-ge-nvdec-test.backup-20260731-135410"

set GOOD_SYSTEM32 \
    "$GOOD_PREFIX/drive_c/windows/system32"

set NV_SYSTEM32 \
    "$NV_PREFIX/drive_c/windows/system32"

    set source \
        "$GOOD_SYSTEM32/$dll.dll"

    set target \
        (readlink -f "$source")
```

#### 実行コマンド

```fish
set GOOD_PREFIX \
    "$ROOT/prefix-ge-nvdec-test.backup-20260731-135410"

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

#### 実行結果

後続の復元とNVDEC成功ログからsource symlinkが利用可能だったことを確認。

#### 生成・変更されたもの

変更なし。

#### 関連する固定値

- 短縮commit: `20260731`

#### 問題点・注意事項

- 正確な端末出力ファイルは残っていないが、直後の復元・ロード成功が実行証拠。
- `return 1`は対話Fish直下では注意。

#### 採用可否

```text
内容を修正してから検証手順として採用
```

#### 証拠位置

`current conversation command block + subsequent user output`

---
### コマンド 095 — `S-E02`

#### 目的

NVIDIA wrapper復元前backup directoryを作成する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
set STAMP \
    (date +%Y%m%d-%H%M%S)

set NV_DLL_BACKUP \
    "$ROOT/backups/nvidia-dlls-before-restore-$STAMP"
```

#### 実行コマンド

```fish
set STAMP \
    (date +%Y%m%d-%H%M%S)

set NV_DLL_BACKUP \
    "$ROOT/backups/nvidia-dlls-before-restore-$STAMP"

mkdir -p \
    "$NV_DLL_BACKUP"

or return 1
```

#### 実行結果

後続復元コマンドが実行され、NVDECが成功した。

#### 生成・変更されたもの

NVIDIA DLL backup directory。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
内容を修正してからREPRODUCTION.mdへ採用
```

#### 証拠位置

`current conversation command block + subsequent user output`

---
### コマンド 096 — `S-E03`

#### 目的

known-good prefixのNVIDIA Wine wrapper symlinkをcurrent NV prefixへ復元する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
    set current \
        "$NV_SYSTEM32/$dll.dll"

    set source \
        "$GOOD_SYSTEM32/$dll.dll"
```

#### 実行コマンド

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

#### 実行結果

直後の再試験でnvcuda.dll/nvcuvid.dllがロードされ、複数av1_cuvid contextが生成された。

#### 生成・変更されたもの

system32/nvcuda.dll、nvcuvid.dll、nvencodeapi64.dll。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`current conversation command block + subsequent user output`

---
### コマンド 097 — `V-E04`

#### 目的

復元されたNVIDIA wrapper symlinkとtargetを確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
    set current \
        "$NV_SYSTEM32/$dll.dll"

    set target \
        (readlink -f "$current")
```

#### 実行コマンド

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

#### 実行結果

後続NVDEC successにより有効なwrapper配置を確認。

#### 生成・変更されたもの

変更なし。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`current conversation command block + subsequent user output`

---
### コマンド 098 — `S-E05`

#### 目的

NVIDIA wrapper DLLのnative overrideを再登録する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_OK_LIBS"
```

#### 実行コマンド

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

#### 実行結果

後続のload logとav1_cuvid成功で有効性を確認。

#### 生成・変更されたもの

HKCU\Software\Wine\DllOverrides。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`current conversation command block + subsequent user output`

---
### コマンド 099 — `V-E06`

#### 目的

NVIDIA wrapper override値をqueryする。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_OK_LIBS"
```

#### 実行コマンド

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

#### 実行結果

3件のnative登録が後続ログでも確認された。

#### 生成・変更されたもの

変更なし。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`current conversation command block + subsequent user output`

---
### コマンド 100 — `S-E07`

#### 目的

NVIDIA wrapper復元後のNVDEC再試験ログを初期化する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
set NVDEC_LOG \
    "$ROOT/logs/aviutl2-nvdec-native-libs-retest.log"
```

#### 実行コマンド

```fish
set NVDEC_LOG \
    "$ROOT/logs/aviutl2-nvdec-native-libs-retest.log"

rm -f \
    "$NVDEC_LOG"
```

#### 実行結果

再試験ログが生成された。

#### 生成・変更されたもの

NVDEC log。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`current conversation command block + subsequent user output`

---
### コマンド 101 — `V-E08`

#### 目的

wrapper復元後にAV1素材を読み込み、NVDEC DLL/load traceを採取する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_OK_LIBS"

WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG='-all,+timestamp,+loaddll,+nvcuda,+nvcuvid'
```

#### 実行コマンド

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

#### 実行結果

ユーザーがAV1読込・再生・複数seek・正常終了を実施。ログにbuiltin nvcuda/nvcuvid loadと複数av1_cuvid context。

#### 生成・変更されたもの

NVDEC log。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`current conversation command block + subsequent user output`

---
### コマンド 102 — `V-E09`

#### 目的

NVDEC成功・失敗markerを最終ログから抽出する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
grep -nEi \
    'nvcuda\.dll|nvcuvid\.dll|\[av1_cuvid|Cannot load nvcuvid|Failed loading nvcuvid|CUDA_ERROR|av_hwframe_transfer_data.*fail|hardware frame.*fail|hwframe.*fail' \
    "$NVDEC_LOG" \
    | tail -n 250
```

#### 実行結果

nvcuda/nvcuvid builtin load、複数av1_cuvid contextあり。Cannot load/Failed loading/CUDA/hwframe failureなし。

#### 生成・変更されたもの

変更なし。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`current conversation command block + subsequent user output`

---
### コマンド 103 — `V-E11`

#### 目的

初回NVDECログからCUVID contextと致命的エラーを抽出する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
grep -nE \
    '\[av1_cuvid|Cannot load nvcuvid|Failed loading nvcuvid|hwframe|hardware frame|av_hwframe_transfer_data|CUDA_ERROR|cuvidCreateDecoder' \
    "$NVDEC_LOG" \
    | tail -n 200
```

#### 実行結果

`Cannot load nvcuvid.dll`、`Failed loading nvcuvid.`を複数contextで確認。

#### 生成・変更されたもの

変更なし。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`current conversation command block + subsequent user output`

---
### コマンド 104 — `V-E12`

#### 目的

初回NVDECログのcontext行とfatal errorを分けて確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
echo "=== AV1 CUVID contexts ==="

grep -n \
    '\[av1_cuvid' \
    "$NVDEC_LOG" \
    | tail -n 100

echo
echo "=== Fatal NVDEC errors ==="

grep -nEi \
    'Cannot load nvcuvid|Failed loading nvcuvid|CUDA_ERROR|av_hwframe_transfer_data.*fail|hardware frame.*fail|hwframe.*fail' \
    "$NVDEC_LOG"

or echo "No fatal NVDEC errors found."
```

#### 実行結果

fatal sectionにnvcuvid load failureが出た。

#### 生成・変更されたもの

変更なし。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`current conversation command block + subsequent user output`

---
# Part II — Fish history全件（2026-07-30〜2026-08-01）

### コマンド 105 — `H001`

#### 目的

バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set PREFIX "$ROOT/prefix"

set SRC "$ROOT/src/dxvk-2.7.1-aviutl2"

set OUT "$ROOT/runtime/dxvk-2.7.1-aviutl2"

set FILE "$SRC/src/d3d11/d3d11_device.cpp"
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set PREFIX "$ROOT/prefix"
set SRC "$ROOT/src/dxvk-2.7.1-aviutl2"
set OUT "$ROOT/runtime/dxvk-2.7.1-aviutl2"
set FILE "$SRC/src/d3d11/d3d11_device.cpp"
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-30 21:17:55 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

- version: `2.7.1`
- path: `$HOME/Games/aviutl2`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:17:55 +0900`

---
### コマンド 106 — `H002`

#### 目的

AviUtl2 on Linux環境の構築・調査・検証に関係する処理を実行する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
env FILE="$FILE" /usr/bin/python -c '
from pathlib import Path
import os

path = Path(os.environ["FILE"])
text = path.read_text(encoding="utf-8")

marker = "AviUtl2 compatibility: format 69 probe"

if marker in text:
    print("Compatibility patch is already present")
    raise SystemExit(0)

signature = "  HRESULT D3D11Device::GetFormatSupportFlags("

start = text.find(signature)
if start < 0:
    raise SystemExit("GetFormatSupportFlags was not found")

brace = text.find("{", start)
if brace < 0:
    raise SystemExit("Opening brace was not found")

insert_at = text.find("\n", brace)
if insert_at < 0:
    raise SystemExit("Function body could not be located")

insert_at += 1

patch = """    // AviUtl2 compatibility: format 69 probe
    //
    // DXGI_FORMAT_G8R8_G8B8_UNORM is a valid packed 4:2:2
    // format, but the Vulkan driver may not expose the corresponding
    // VkFormat. Report a successful query with no supported usages so
    // that AviUtl2 can select another media format.
    if (Format == DXGI_FORMAT_G8R8_G8B8_UNORM) {
      if (pFlags1 != nullptr)
        *pFlags1 = 0;

      if (pFlags2 != nullptr)
        *pFlags2 = 0;

      Logger::warn(
        "AviUtl2 compatibility: format 69 unsupported; returning S_OK");

      return S_OK;
    }

"""

text = text[:insert_at] + patch + text[insert_at:]
path.write_text(text, encoding="utf-8")

print(f"Patched: {path}")
'
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 21:18:20 +0900`。

#### 生成・変更されたもの

ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:18:20 +0900`

---
### コマンド 107 — `H003`

#### 目的

ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
grep -n -A25 -B3 \
    'AviUtl2 compatibility: format 69 probe' \
    "$FILE"
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-30 21:18:37 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

検証専用または変数設定のみ。変更対象はコマンド本文と出力証拠から断定しない。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:18:37 +0900`

---
### コマンド 108 — `H004`

#### 目的

バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set PATCHED_D3D11 \
    (find "$OUT" -type f -iname 'd3d11.dll' -print -quit)
```

#### 実行コマンド

```fish
set PATCHED_D3D11 \
    (find "$OUT" -type f -iname 'd3d11.dll' -print -quit)

if test -z "$PATCHED_D3D11"
echo "ERROR: rebuilt d3d11.dll was not found"
return 1
end

file "$PATCHED_D3D11"
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-30 21:19:20 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

DXVK DLL。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:19:20 +0900`

---
### コマンド 109 — `H005`

#### 目的

バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
sha256sum \
    "$PATCHED_D3D11" \
    "$PREFIX/drive_c/windows/system32/d3d11.dll"
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-30 21:19:28 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、DXVK DLL。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:19:28 +0900`

---
### コマンド 110 — `H006`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$PREFIX"
```

#### 実行コマンド

```fish
env WINEPREFIX="$PREFIX" wineserver -k 2>/dev/null
sleep 1

install -m 0644 \
    "$PATCHED_D3D11" \
    "$PREFIX/drive_c/windows/system32/d3d11.dll"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 21:19:33 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、DXVK DLL。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:19:33 +0900`

---
### コマンド 111 — `H007`

#### 目的

AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$PREFIX"

WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=debug

DXVK_LOG_PATH="$ROOT/logs"
```

#### 実行コマンド

```fish
rm -f "$ROOT/logs/"*.log

cd "$PREFIX/drive_c/AviUtl2"

env \
    WINEPREFIX="$PREFIX" \
    WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=debug \
    DXVK_LOG_PATH="$ROOT/logs" \
    wine ./aviutl2.exe \
    2>&1 | tee "$ROOT/logs/direct-test-format69-workaround.log"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 21:19:43 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:19:43 +0900`

---
### コマンド 112 — `H008`

#### 目的

ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
grep -RniE \
    'AviUtl2 compatibility|AviUtl2 trace: CheckFormatSupport' \
    "$ROOT/logs"
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-30 21:20:29 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:20:29 +0900`

---
### コマンド 113 — `H009`

#### 目的

ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
tail -n 120 \
    "$ROOT/logs/direct-test-format69-workaround.log"
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-30 21:22:27 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:22:27 +0900`

---
### コマンド 114 — `H010`

#### 目的

ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
grep -RniE \
    'err:|error|fail|failed|stub|unimplemented|exception|HRESULT|E_NOTIMPL' \
    "$ROOT/logs" \
    | tail -n 200
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-30 21:22:39 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:22:39 +0900`

---
### コマンド 115 — `H011`

#### 目的

ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
grep -RniE \
    'dwrite|HitTest|DirectWrite|textlayout' \
    "$ROOT/logs" \
    | tail -n 200
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-30 21:22:43 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:22:43 +0900`

---
### コマンド 116 — `H012`

#### 目的

必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。

#### 分類

```text
実行確認不能
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set PREFIX "$ROOT/prefix"

set GE_PREFIX "$ROOT/prefix-ge"

set GE_BASE "$HOME/.local/share/Steam/compatibilitytools.d"

set GE_DIR "$GE_BASE/GE-Proton11-1"

set GE_ARCHIVE "/tmp/GE-Proton11-1.tar.gz"
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set PREFIX "$ROOT/prefix"
set GE_PREFIX "$ROOT/prefix-ge"

set GE_BASE "$HOME/.local/share/Steam/compatibilitytools.d"
set GE_DIR "$GE_BASE/GE-Proton11-1"
set GE_ARCHIVE "/tmp/GE-Proton11-1.tar.gz"

if not test -x "$GE_DIR/files/lib/wine/x86_64-unix/wine"
mkdir -p "$GE_BASE"

curl --fail --location \
        --retry 3 \
        --output "$GE_ARCHIVE" \
        https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton11-1/GE-Proton11-1.tar.gz

and tar -xzf "$GE_ARCHIVE" \
        -C "$GE_BASE"
end
```

#### 実行結果

コマンド記載またはFish履歴は確認できるが、この履歴だけでは終了状態・生成物を断定できない。出典: `(223).txt timestamp 2026-07-30 21:29:14 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d`
- path: `/tmp/GE-Proton11-1.tar.gz`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。

#### 採用可否

```text
要追加確認
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:29:14 +0900`

---
### コマンド 117 — `H013`

#### 目的

バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set GE_WINE "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER "$GE_DIR/files/bin/wineserver"
```

#### 実行コマンド

```fish
set GE_WINE "$GE_DIR/files/lib/wine/x86_64-unix/wine"
set GE_WINESERVER "$GE_DIR/files/bin/wineserver"

file "$GE_WINE"
"$GE_WINE" --version
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-30 21:33:28 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

検証専用または変数設定のみ。変更対象はコマンド本文と出力証拠から断定しない。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:33:28 +0900`

---
### コマンド 118 — `H014`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
実行確認不能
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$PREFIX"
```

#### 実行コマンド

```fish
env WINEPREFIX="$PREFIX" wineserver -k 2>/dev/null
sleep 1
```

#### 実行結果

コマンド記載またはFish履歴は確認できるが、この履歴だけでは終了状態・生成物を断定できない。出典: `(223).txt timestamp 2026-07-30 21:33:33 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
要追加確認
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:33:33 +0900`

---
### コマンド 119 — `H015`

#### 目的

後続コマンドで使用するシェル変数を設定する。

#### 分類

```text
実行確認不能
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"
```

#### 実行コマンド

```fish
set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"
```

#### 実行結果

コマンド記載またはFish履歴は確認できるが、この履歴だけでは終了状態・生成物を断定できない。出典: `(223).txt timestamp 2026-07-30 21:33:38 +0900`。

#### 生成・変更されたもの

検証専用または変数設定のみ。変更対象はコマンド本文と出力証拠から断定しない。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
要追加確認
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:33:38 +0900`

---
### コマンド 120 — `H016`

#### 目的

Wine prefixを作成または更新し、レジストリとランタイム状態を反映する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$GE_PREFIX"

WINEARCH=win64

LD_LIBRARY_PATH="$GE_LIBS"
```

#### 実行コマンド

```fish
rm -rf "$GE_PREFIX"

env \
    WINEPREFIX="$GE_PREFIX" \
    WINEARCH=win64 \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" wineboot -u

env \
    WINEPREFIX="$GE_PREFIX" \
    "$GE_WINESERVER" -w
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 21:33:42 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:33:42 +0900`

---
### コマンド 121 — `H017`

#### 目的

必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
rm -rf "$GE_PREFIX/drive_c/AviUtl2"

cp -a \
    "$PREFIX/drive_c/AviUtl2" \
    "$GE_PREFIX/drive_c/AviUtl2"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 21:33:52 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:33:52 +0900`

---
### コマンド 122 — `H018`

#### 目的

必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
mkdir -p "$GE_PREFIX/drive_c/ProgramData"

rm -rf "$GE_PREFIX/drive_c/ProgramData/aviutl2"

cp -a \
    "$PREFIX/drive_c/ProgramData/aviutl2" \
    "$GE_PREFIX/drive_c/ProgramData/aviutl2"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 21:34:10 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:34:10 +0900`

---
### コマンド 123 — `H019`

#### 目的

必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set src "$PREFIX/drive_c/windows/system32/$dll.dll"

set dst "$GE_PREFIX/drive_c/windows/system32/$dll.dll"
```

#### 実行コマンド

```fish
for dll in d3d11 dxgi d3d10core d3dcompiler_47
set src "$PREFIX/drive_c/windows/system32/$dll.dll"
set dst "$GE_PREFIX/drive_c/windows/system32/$dll.dll"

if test -f "$src"
install -m 0644 "$src" "$dst"
end
end
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 21:34:14 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:34:14 +0900`

---
### コマンド 124 — `H020`

#### 目的

バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
sha256sum \
    "$PREFIX/drive_c/windows/system32/d3d11.dll" \
    "$GE_PREFIX/drive_c/windows/system32/d3d11.dll"
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-30 21:37:47 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、DXVK DLL。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:37:47 +0900`

---
### コマンド 125 — `H021`

#### 目的

WineレジストリへDLL override、フォント、IMEなどの設定を登録する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$GE_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"
```

#### 実行コマンド

```fish
for dll in d3d11 dxgi d3d10core
env \
        WINEPREFIX="$GE_PREFIX" \
        LD_LIBRARY_PATH="$GE_LIBS" \
        "$GE_WINE" reg add \
        'HKEY_CURRENT_USER\Software\Wine\DllOverrides' \
        /v "$dll" \
        /d native,builtin \
        /f
end

env \
    WINEPREFIX="$GE_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" reg add \
    'HKEY_CURRENT_USER\Software\Wine\DllOverrides' \
    /v d3dcompiler_47 \
    /d native,builtin \
    /f
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 21:38:02 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:38:02 +0900`

---
### コマンド 126 — `H022`

#### 目的

Wineレジストリの設定値を確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$GE_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"
```

#### 実行コマンド

```fish
env \
    WINEPREFIX="$GE_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" reg query \
    'HKEY_CURRENT_USER\Software\Wine\DllOverrides'
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-30 21:48:18 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:48:18 +0900`

---
### コマンド 127 — `H023`

#### 目的

AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$GE_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=debug

DXVK_LOG_PATH="$ROOT/logs"
```

#### 実行コマンド

```fish
rm -f "$ROOT/logs/"*.log

cd "$GE_PREFIX/drive_c/AviUtl2"

env \
    WINEPREFIX="$GE_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=debug \
    DXVK_LOG_PATH="$ROOT/logs" \
    "$GE_WINE" ./aviutl2.exe \
    2>&1 | tee "$ROOT/logs/ge-proton11-test.log"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 21:48:23 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:48:23 +0900`

---
### コマンド 128 — `H024`

#### 目的

ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
grep -nE \
    'AviUtl2 compatibility|CheckFormatSupport|Presenter:|Unhandled page fault|Unhandled exception' \
    "$ROOT/logs/ge-proton11-test.log"
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-30 21:48:31 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:48:31 +0900`

---
### コマンド 129 — `H025`

#### 目的

バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set SRC "$ROOT/src/dxvk-2.7.1-aviutl2"

set FILE "$SRC/src/d3d11/d3d11_device.cpp"
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set SRC "$ROOT/src/dxvk-2.7.1-aviutl2"
set FILE "$SRC/src/d3d11/d3d11_device.cpp"
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-30 21:50:40 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

検証専用または変数設定のみ。変更対象はコマンド本文と出力証拠から断定しない。

#### 関連する固定値

- version: `2.7.1`
- path: `$HOME/Games/aviutl2`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:50:40 +0900`

---
### コマンド 130 — `H026`

#### 目的

AviUtl2 on Linux環境の構築・調査・検証に関係する処理を実行する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
env FILE="$FILE" /usr/bin/python -c '
from pathlib import Path
import os

path = Path(os.environ["FILE"])
text = path.read_text(encoding="utf-8")

old = """  HRESULT STDMETHODCALLTYPE D3D11Device::CheckFormatSupport(
          DXGI_FORMAT Format,
          UINT*       pFormatSupport) {
    HRESULT hr = GetFormatSupportFlags(Format, pFormatSupport, nullptr);

    Logger::info(str::format(
      "AviUtl2 trace: CheckFormatSupport format=",
      uint32_t(Format),
      " hr=",
      uint32_t(hr),
      " flags=",
      pFormatSupport ? *pFormatSupport : 0u));

    return hr;
  }
"""

new = """  HRESULT STDMETHODCALLTYPE D3D11Device::CheckFormatSupport(
          DXGI_FORMAT Format,
          UINT*       pFormatSupport) {
    return GetFormatSupportFlags(Format, pFormatSupport, nullptr);
  }
"""

if old not in text:
    raise SystemExit("Trace block was not found")

path.write_text(text.replace(old, new, 1), encoding="utf-8")
print(f"Removed trace logging: {path}")
'
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 21:50:58 +0900`。

#### 生成・変更されたもの

ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:50:58 +0900`

---
### コマンド 131 — `H027`

#### 目的

ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set GE_PREFIX "$ROOT/prefix-ge"

set OUT "$ROOT/runtime/dxvk-2.7.1-aviutl2"

set FINAL_D3D11 \
    (find "$OUT" -type f -iname d3d11.dll -print -quit)

WINEPREFIX="$GE_PREFIX"
```

#### 実行コマンド

```fish
set GE_PREFIX "$ROOT/prefix-ge"
set OUT "$ROOT/runtime/dxvk-2.7.1-aviutl2"

set FINAL_D3D11 \
    (find "$OUT" -type f -iname d3d11.dll -print -quit)

env WINEPREFIX="$GE_PREFIX" \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1/files/bin/wineserver" \
    -k 2>/dev/null

sleep 1

install -m 0644 \
    "$FINAL_D3D11" \
    "$GE_PREFIX/drive_c/windows/system32/d3d11.dll"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 21:51:14 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、DXVK DLL。

#### 関連する固定値

- version: `2.7.1`
- version: `GE-Proton11-1`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1/files/bin/wineserver`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:51:14 +0900`

---
### コマンド 132 — `H028`

#### 目的

バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set SRC "$ROOT/src/dxvk-2.7.1-aviutl2"

set OUT "$ROOT/runtime/dxvk-2.7.1-aviutl2"

set GE_PREFIX "$ROOT/prefix-ge"

set FILE "$SRC/src/d3d11/d3d11_device.cpp"
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set SRC "$ROOT/src/dxvk-2.7.1-aviutl2"
set OUT "$ROOT/runtime/dxvk-2.7.1-aviutl2"
set GE_PREFIX "$ROOT/prefix-ge"
set FILE "$SRC/src/d3d11/d3d11_device.cpp"

grep -RFn \
    --exclude-dir=build.w64 \
    'AviUtl2 trace:' \
    "$SRC"
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-30 21:52:10 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

- version: `2.7.1`
- path: `$HOME/Games/aviutl2`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:52:10 +0900`

---
### コマンド 133 — `H029`

#### 目的

AviUtl2 on Linux環境の構築・調査・検証に関係する処理を実行する。

#### 分類

```text
実行確認不能
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
sed -n \
    '/HRESULT STDMETHODCALLTYPE D3D11Device::CheckFormatSupport/,/^  }/p' \
    "$FILE"
```

#### 実行結果

コマンド記載またはFish履歴は確認できるが、この履歴だけでは終了状態・生成物を断定できない。出典: `(223).txt timestamp 2026-07-30 21:52:18 +0900`。

#### 生成・変更されたもの

検証専用または変数設定のみ。変更対象はコマンド本文と出力証拠から断定しない。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
要追加確認
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:52:18 +0900`

---
### コマンド 134 — `H030`

#### 目的

AviUtl2 on Linux環境の構築・調査・検証に関係する処理を実行する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
HRESULT STDMETHODCALLTYPE D3D11Device::CheckFormatSupport(
DXGI_FORMAT Format,
UINT*       pFormatSupport) {
return GetFormatSupportFlags(Format, pFormatSupport, nullptr);
}
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 21:52:25 +0900`。

#### 生成・変更されたもの

コマンド本文に記載された対象。詳細は実行コマンドを参照。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:52:25 +0900`

---
### コマンド 135 — `H031`

#### 目的

ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
grep -n -A20 \
    'AviUtl2 compatibility: format 69 probe' \
    "$FILE"
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-30 21:52:30 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

検証専用または変数設定のみ。変更対象はコマンド本文と出力証拠から断定しない。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:52:30 +0900`

---
### コマンド 136 — `H032`

#### 目的

AviUtl2 on Linux環境の構築・調査・検証に関係する処理を実行する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
rm -rf \
    "$SRC/build.w64" \
    "$OUT"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 21:52:35 +0900`。

#### 生成・変更されたもの

コマンド本文に記載された対象。詳細は実行コマンドを参照。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:52:35 +0900`

---
### コマンド 137 — `H033`

#### 目的

DXVKのMesonビルドディレクトリを構成する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
meson setup \
    "$SRC/build.w64" \
    "$SRC" \
    --cross-file "$SRC/build-win64.txt" \
    --buildtype release \
    --prefix "$OUT"
```

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(223).txt timestamp 2026-07-30 21:52:40 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:52:40 +0900`

---
### コマンド 138 — `H034`

#### 目的

ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set FINAL_D3D11 "$OUT/bin/d3d11.dll"
```

#### 実行コマンド

```fish
set FINAL_D3D11 "$OUT/bin/d3d11.dll"

if not test -f "$FINAL_D3D11"
echo "ERROR: $FINAL_D3D11 が生成されていない"
find "$OUT" -type f -iname d3d11.dll -print
return 1
end
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-30 21:55:48 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

DXVK DLL。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:55:48 +0900`

---
### コマンド 139 — `H035`

#### 目的

バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
strings "$FINAL_D3D11" \
    | grep -E 'AviUtl2 compatibility|AviUtl2 trace'
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-30 21:55:53 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

検証専用または変数設定のみ。変更対象はコマンド本文と出力証拠から断定しない。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:55:53 +0900`

---
### コマンド 140 — `H036`

#### 目的

ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
grep -RFn \
    --exclude-dir=.git \
    'AviUtl2 trace: CheckFormatSupport' \
    "$SRC"
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-30 21:56:01 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Git working tree、commit、remoteまたはGitHub repository。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:56:01 +0900`

---
### コマンド 141 — `H037`

#### 目的

バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
sha256sum \
    "$FINAL_D3D11" \
    "$GE_PREFIX/drive_c/windows/system32/d3d11.dll"
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-30 21:56:20 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、DXVK DLL。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:56:20 +0900`

---
### コマンド 142 — `H038`

#### 目的

バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
strings "$GE_PREFIX/drive_c/windows/system32/d3d11.dll" \
    | grep -E 'AviUtl2 compatibility|AviUtl2 trace'
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-30 21:56:25 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、DXVK DLL。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:56:25 +0900`

---
### コマンド 143 — `H039`

#### 目的

バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set SRC "$ROOT/src/dxvk-2.7.1-aviutl2"

set OUT "$ROOT/runtime/dxvk-2.7.1-aviutl2"

set GE_PREFIX "$ROOT/prefix-ge"

set FILE "$SRC/src/d3d11/d3d11_device.cpp"
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set SRC "$ROOT/src/dxvk-2.7.1-aviutl2"
set OUT "$ROOT/runtime/dxvk-2.7.1-aviutl2"
set GE_PREFIX "$ROOT/prefix-ge"
set FILE "$SRC/src/d3d11/d3d11_device.cpp"
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-30 21:57:24 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

- version: `2.7.1`
- path: `$HOME/Games/aviutl2`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:57:24 +0900`

---
### コマンド 144 — `H040`

#### 目的

AviUtl2 on Linux環境の構築・調査・検証に関係する処理を実行する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
env FILE="$FILE" /usr/bin/python -c '
from pathlib import Path
import os

path = Path(os.environ["FILE"])
text = path.read_text(encoding="utf-8")

start_marker = (
    "  HRESULT STDMETHODCALLTYPE D3D11Device::CheckFormatSupport("
)

next_marker = (
    "\n\n  HRESULT STDMETHODCALLTYPE "
    "D3D11Device::CheckMultisampleQualityLevels("
)

start = text.find(start_marker)

if start < 0:
    raise SystemExit("CheckFormatSupport() が見つかりません")

end = text.find(next_marker, start)

if end < 0:
    raise SystemExit(
        "次の CheckMultisampleQualityLevels() が見つかりません"
    )

replacement = """  HRESULT STDMETHODCALLTYPE D3D11Device::CheckFormatSupport(
          DXGI_FORMAT Format,
          UINT*       pFormatSupport) {
    return GetFormatSupportFlags(Format, pFormatSupport, nullptr);
  }"""

text = text[:start] + replacement + text[end:]
path.write_text(text, encoding="utf-8")

print(f"Replaced CheckFormatSupport(): {path}")
'
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 21:57:28 +0900`。

#### 生成・変更されたもの

コマンド本文に記載された対象。詳細は実行コマンドを参照。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:57:28 +0900`

---
### コマンド 145 — `H041`

#### 目的

ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
grep -n -A18 \
    'AviUtl2 compatibility: format 69 probe' \
    "$FILE"

=== RELATED COMMANDS: 2026-07-25–2026-08-01 JST ===
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-30 21:57:45 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

検証専用または変数設定のみ。変更対象はコマンド本文と出力証拠から断定しない。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:57:45 +0900`

---
### コマンド 146 — `H042`

#### 目的

Wine prefixを作成または更新し、レジストリとランタイム状態を反映する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$PREFIX"

WINEARCH=win64
```

#### 実行コマンド

```fish
if not test -f "$PREFIX/system.reg"
rm -rf "$PREFIX"
env WINEPREFIX="$PREFIX" WINEARCH=win64 wineboot -u
end
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 20:15:05 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 20:15:05 +0900`

---
### コマンド 147 — `H043`

#### 目的

必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set EXTRACTED_DIR (dirname "$EXE")
```

#### 実行コマンド

```fish
set EXTRACTED_DIR (dirname "$EXE")

mkdir -p "$APPDIR"
cp -a "$EXTRACTED_DIR/." "$APPDIR/"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 20:15:26 +0900`。

#### 生成・変更されたもの

コマンド本文に記載された対象。詳細は実行コマンドを参照。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 20:15:26 +0900`

---
### コマンド 148 — `H044`

#### 目的

AviUtl2 on Linux環境の構築・調査・検証に関係する処理を実行する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$PREFIX"
```

#### 実行コマンド

```fish
env WINEPREFIX="$PREFIX" \
    winetricks -q win10 d3dcompiler_47
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 20:15:44 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 20:15:44 +0900`

---
### コマンド 149 — `H045`

#### 目的

必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set WINE_CFG "$HOME/.local/share/lutris/runners/wine.yml"
```

#### 実行コマンド

```fish
set WINE_CFG "$HOME/.local/share/lutris/runners/wine.yml"

mkdir -p (dirname "$WINE_CFG")

if test -f "$WINE_CFG"
cp -a "$WINE_CFG" "$WINE_CFG.bak-"(date +%Y%m%d-%H%M%S)
end
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 20:20:00 +0900`。

#### 生成・変更されたもの

コマンド本文に記載された対象。詳細は実行コマンドを参照。

#### 関連する固定値

- path: `$HOME/.local/share/lutris/runners/wine.yml`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 20:20:00 +0900`

---
### コマンド 150 — `H046`

#### 目的

WineレジストリへDLL override、フォント、IMEなどの設定を登録する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$PREFIX"
```

#### 実行コマンド

```fish
for dll in d3d11 dxgi d3d10core
env WINEPREFIX="$PREFIX" \
        wine reg add \
        'HKEY_CURRENT_USER\Software\Wine\DllOverrides' \
        /v "$dll" \
        /d native,builtin \
        /f
end

env WINEPREFIX="$PREFIX" \
    wine reg add \
    'HKEY_CURRENT_USER\Software\Wine\DllOverrides' \
    /v d3dcompiler_47 \
    /d native,builtin \
    /f
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 20:27:35 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 20:27:35 +0900`

---
### コマンド 151 — `H047`

#### 目的

Wineレジストリの設定値を確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$PREFIX"
```

#### 実行コマンド

```fish
env WINEPREFIX="$PREFIX" \
    wine reg query \
    'HKEY_CURRENT_USER\Software\Wine\DllOverrides'
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-30 20:27:39 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 20:27:39 +0900`

---
### コマンド 152 — `H048`

#### 目的

AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$PREFIX"

WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b'

DXVK_LOG_LEVEL=debug

DXVK_LOG_PATH="$ROOT/logs"
```

#### 実行コマンド

```fish
rm -f "$ROOT/logs/"*.log

env \
    WINEPREFIX="$PREFIX" \
    WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b' \
    DXVK_HUD='version,api,devinfo' \
    DXVK_LOG_LEVEL=debug \
    DXVK_LOG_PATH="$ROOT/logs" \
    wine "$PREFIX/drive_c/AviUtl2/aviutl2.exe" \
    2>&1 | tee "$ROOT/logs/direct-test.log"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 20:27:45 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 20:27:45 +0900`

---
### コマンド 153 — `H049`

#### 目的

必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set D3D11_DEST \
    "$PREFIX/drive_c/windows/system32/d3d11.dll"
```

#### 実行コマンド

```fish
set D3D11_DEST \
    "$PREFIX/drive_c/windows/system32/d3d11.dll"

cp -a \
    "$D3D11_DEST" \
    "$ROOT/runtime/d3d11.dxvk-2.7.1-stock.dll"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 20:38:00 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、DXVK DLL。

#### 関連する固定値

- version: `2.7.1`

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 20:38:00 +0900`

---
### コマンド 154 — `H050`

#### 目的

AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$PREFIX"

WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b'

DXVK_LOG_LEVEL=debug

DXVK_LOG_PATH="$ROOT/logs"
```

#### 実行コマンド

```fish
rm -f "$ROOT/logs/"*.log

env \
    WINEPREFIX="$PREFIX" \
    WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b' \
    DXVK_HUD='version,api,devinfo' \
    DXVK_LOG_LEVEL=debug \
    DXVK_LOG_PATH="$ROOT/logs" \
    wine "$PREFIX/drive_c/AviUtl2/aviutl2.exe" \
    2>&1 | tee "$ROOT/logs/direct-test-patched.log"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 20:38:30 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 20:38:30 +0900`

---
### コマンド 155 — `H051`

#### 目的

AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set PREFIX "$ROOT/prefix"

set EMPTY_CONF "$ROOT/empty-dxvk.conf"

WINEPREFIX="$PREFIX"

WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b'

DXVK_CONFIG_FILE="$EMPTY_CONF"

DXVK_LOG_LEVEL=debug

DXVK_LOG_PATH="$ROOT/logs"
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set PREFIX "$ROOT/prefix"
set EMPTY_CONF "$ROOT/empty-dxvk.conf"

printf '# intentionally empty\n' > "$EMPTY_CONF"

rm -f "$ROOT/logs/"*.log

cd "$PREFIX/drive_c/AviUtl2"

env \
    WINEPREFIX="$PREFIX" \
    WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b' \
    DXVK_CONFIG_FILE="$EMPTY_CONF" \
    DXVK_HUD='version,api,devinfo' \
    DXVK_LOG_LEVEL=debug \
    DXVK_LOG_PATH="$ROOT/logs" \
    wine ./aviutl2.exe \
    2>&1 | tee "$ROOT/logs/direct-test-no-config.log"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 20:44:05 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、ログファイル。

#### 関連する固定値

- path: `$HOME/Games/aviutl2`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 20:44:05 +0900`

---
### コマンド 156 — `H052`

#### 目的

AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set PREFIX "$ROOT/prefix"

set NVIDIA_CONF "$ROOT/nvidia-dxvk.conf"

WINEPREFIX="$PREFIX"

WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b'

DXVK_CONFIG_FILE="$NVIDIA_CONF"

DXVK_LOG_LEVEL=debug

DXVK_LOG_PATH="$ROOT/logs"
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set PREFIX "$ROOT/prefix"
set NVIDIA_CONF "$ROOT/nvidia-dxvk.conf"

printf '%s\n' \
    'dxgi.hideNvidiaGpu = False' \
    > "$NVIDIA_CONF"

rm -f "$ROOT/logs/"*.log

cd "$PREFIX/drive_c/AviUtl2"

env \
    WINEPREFIX="$PREFIX" \
    WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b' \
    DXVK_CONFIG_FILE="$NVIDIA_CONF" \
    DXVK_HUD='version,api,devinfo' \
    DXVK_LOG_LEVEL=debug \
    DXVK_LOG_PATH="$ROOT/logs" \
    wine ./aviutl2.exe \
    2>&1 | tee "$ROOT/logs/direct-test-nvidia.log"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 20:51:36 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、ログファイル。

#### 関連する固定値

- path: `$HOME/Games/aviutl2`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 20:51:36 +0900`

---
### コマンド 157 — `H053`

#### 目的

AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$PREFIX"

WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=debug

DXVK_LOG_PATH="$ROOT/logs"
```

#### 実行コマンド

```fish
rm -f "$ROOT/logs/"*.log

cd "$PREFIX/drive_c/AviUtl2"

env \
    WINEPREFIX="$PREFIX" \
    WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=debug \
    DXVK_LOG_PATH="$ROOT/logs" \
    wine ./aviutl2.exe \
    2>&1 | tee "$ROOT/logs/direct-test-format-trace.log"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 21:07:05 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 21:07:05 +0900`

---
### コマンド 158 — `H054`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set GE_DIR \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINESERVER \
    "$GE_DIR/files/bin/wineserver"

WINEPREFIX="$GE_PREFIX"
```

#### 実行コマンド

```fish
set GE_DIR \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINESERVER \
    "$GE_DIR/files/bin/wineserver"

env WINEPREFIX="$GE_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1

install -m 0644 \
    "$FINAL_D3D11" \
    "$GE_PREFIX/drive_c/windows/system32/d3d11.dll"
```

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(223).txt timestamp 2026-07-30 22:01:54 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、DXVK DLL。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 22:01:54 +0900`

---
### コマンド 159 — `H055`

#### 目的

バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
sha256sum \
    "$FINAL_D3D11" \
    "$GE_PREFIX/drive_c/windows/system32/d3d11.dll"

strings "$GE_PREFIX/drive_c/windows/system32/d3d11.dll" \
    | grep -E 'AviUtl2 compatibility|AviUtl2 trace'
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-30 22:02:03 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、DXVK DLL。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 22:02:03 +0900`

---
### コマンド 160 — `H056`

#### 目的

AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set GE_PREFIX "$ROOT/prefix-ge"

set GE_DIR "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINE "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

WINEPREFIX="$GE_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=info

DXVK_LOG_PATH="$ROOT/logs"
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set GE_PREFIX "$ROOT/prefix-ge"
set GE_DIR "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"
set GE_WINE "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

rm -f "$ROOT/logs/"*.log

cd "$GE_PREFIX/drive_c/AviUtl2"

env \
    WINEPREFIX="$GE_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=info \
    DXVK_LOG_PATH="$ROOT/logs" \
    "$GE_WINE" ./aviutl2.exe \
    2>&1 | tee "$ROOT/logs/aviutl2-final-test.log"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 22:03:19 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、ログファイル。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 22:03:19 +0900`

---
### コマンド 161 — `H057`

#### 目的

AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set -euo pipefail

WINEPREFIX="$GE_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES="d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b"

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

WINEDEBUG="-all"
```

#### 実行コマンド

```fish
mkdir -p "$ROOT/bin"

env ROOT="$ROOT" /usr/bin/python -c '
from pathlib import Path
import os

root = Path(os.environ["ROOT"])
path = root / "bin" / "aviutl2-ge.sh"

script = f"""#!/usr/bin/env bash
set -euo pipefail

ROOT="{root}"
GE_PREFIX="$ROOT/prefix-ge"
GE_DIR="$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"
GE_WINE="$GE_DIR/files/lib/wine/x86_64-unix/wine"

GE_LIBS="$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

cd "$GE_PREFIX/drive_c/AviUtl2"

exec env \\
    WINEPREFIX="$GE_PREFIX" \\
    LD_LIBRARY_PATH="$GE_LIBS" \\
    WINEDLLOVERRIDES="d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b" \\
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \\
    WINEDEBUG="-all" \\
    "$GE_WINE" ./aviutl2.exe "$@"
"""

path.write_text(script, encoding="utf-8")
path.chmod(0o755)

print(path)
'
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 22:08:30 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 22:08:30 +0900`

---
### コマンド 162 — `H058`

#### 目的

AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set GE_PREFIX "$ROOT/prefix-ge"

set GE_DIR "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINE "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

set PIPE_RESULT $pipestatus

WINEPREFIX="$GE_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=info

DXVK_LOG_PATH="$ROOT/logs"

WINEDEBUG='+timestamp,+seh,+unwind,+process,+thread'
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set GE_PREFIX "$ROOT/prefix-ge"
set GE_DIR "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"
set GE_WINE "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

cd "$GE_PREFIX/drive_c/AviUtl2"

env \
    WINEPREFIX="$GE_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=info \
    DXVK_LOG_PATH="$ROOT/logs" \
    WINEDEBUG='+timestamp,+seh,+unwind,+process,+thread' \
    "$GE_WINE" ./aviutl2.exe \
    2>&1 | tee "$ROOT/logs/aviutl2-seh.log"

set PIPE_RESULT $pipestatus
echo "wine exit status: $PIPE_RESULT[1]"
echo "tee exit status:  $PIPE_RESULT[2]"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 22:15:26 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、ログファイル。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 22:15:26 +0900`

---
### コマンド 163 — `H059`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set GE_PREFIX "$ROOT/prefix-ge"

set GE_DIR "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINE "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

set RESULT $pipestatus

WINEPREFIX="$GE_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG='-all,+timestamp,+dwrite,+seh,+loaddll'
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set GE_PREFIX "$ROOT/prefix-ge"
set GE_DIR "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"
set GE_WINE "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

env WINEPREFIX="$GE_PREFIX" \
    "$GE_DIR/files/bin/wineserver" -k 2>/dev/null

sleep 1

rm -f "$ROOT/logs/dwrite-probe.log"

cd "$GE_PREFIX/drive_c/AviUtl2"

env \
    WINEPREFIX="$GE_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG='-all,+timestamp,+dwrite,+seh,+loaddll' \
    "$GE_WINE" ./aviutl2.exe \
    2>&1 | tee "$ROOT/logs/dwrite-probe.log"

set RESULT $pipestatus
echo "wine exit status: $RESULT[1]"
echo "tee exit status:  $RESULT[2]"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 22:25:40 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 22:25:40 +0900`

---
### コマンド 164 — `H060`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set GE_PREFIX "$ROOT/prefix-ge"

set GE_DIR "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINE "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER "$GE_DIR/files/bin/wineserver"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

set NOTO_DIR "/usr/share/fonts/noto-cjk"

set FONTS_DIR "$GE_PREFIX/drive_c/windows/Fonts"
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set GE_PREFIX "$ROOT/prefix-ge"
set GE_DIR "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"
set GE_WINE "$GE_DIR/files/lib/wine/x86_64-unix/wine"
set GE_WINESERVER "$GE_DIR/files/bin/wineserver"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

set NOTO_DIR "/usr/share/fonts/noto-cjk"
set FONTS_DIR "$GE_PREFIX/drive_c/windows/Fonts"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 22:30:00 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、WineフォントファイルまたはFont registry。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 22:30:00 +0900`

---
### コマンド 165 — `H061`

#### 目的

ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$GE_PREFIX"
```

#### 実行コマンド

```fish
env WINEPREFIX="$GE_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1

mkdir -p "$FONTS_DIR"

for font in (find "$NOTO_DIR" \
        -maxdepth 1 \
        -type f \
        -name 'NotoSansCJK-*.ttc' \
        -print)
install -m 0644 "$font" "$FONTS_DIR/"
end
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 22:32:07 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、WineフォントファイルまたはFont registry。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 22:32:07 +0900`

---
### コマンド 166 — `H062`

#### 目的

WineレジストリへDLL override、フォント、IMEなどの設定を登録する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$GE_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"
```

#### 実行コマンド

```fish
env \
    WINEPREFIX="$GE_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" reg add "$REG_FONTS" \
    /v 'Noto Sans CJK JP (TrueType)' \
    /d 'NotoSansCJK-Regular.ttc' \
    /f

env \
    WINEPREFIX="$GE_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" reg add "$REG_FONTS" \
    /v 'Noto Sans CJK JP Bold (TrueType)' \
    /d 'NotoSansCJK-Bold.ttc' \
    /f
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 22:36:25 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、WineフォントファイルまたはFont registry。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 22:36:25 +0900`

---
### コマンド 167 — `H063`

#### 目的

WineレジストリへDLL override、フォント、IMEなどの設定を登録する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$GE_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"
```

#### 実行コマンド

```fish
for name in \
        "Tahoma" \
        "MS Shell Dlg" \
        "MS Shell Dlg 2" \
        "MS Gothic" \
        "MS UI Gothic" \
        "MS PGothic" \
        "MS Mincho" \
        "MS PMincho" \
        "Meiryo" \
        "Meiryo UI" \
        "Yu Gothic" \
        "Yu Gothic UI" \
        "Yu Mincho"

env \
        WINEPREFIX="$GE_PREFIX" \
        LD_LIBRARY_PATH="$GE_LIBS" \
        "$GE_WINE" reg add "$REG_SUBS" \
        /v "$name" \
        /d 'Noto Sans CJK JP' \
        /f
end
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 22:36:35 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、WineフォントファイルまたはFont registry。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 22:36:35 +0900`

---
### コマンド 168 — `H064`

#### 目的

Wineレジストリの設定値を確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$GE_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"
```

#### 実行コマンド

```fish
env \
    WINEPREFIX="$GE_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" reg query "$REG_FONTS" \
    /v 'Noto Sans CJK JP (TrueType)'

env \
    WINEPREFIX="$GE_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" reg query "$REG_SUBS" \
    /v Tahoma

env \
    WINEPREFIX="$GE_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" reg query "$REG_SUBS" \
    /v 'Yu Gothic UI'
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-30 22:36:54 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、WineフォントファイルまたはFont registry。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 22:36:54 +0900`

---
### コマンド 169 — `H065`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$GE_PREFIX"
```

#### 実行コマンド

```fish
env WINEPREFIX="$GE_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1

"$ROOT/bin/aviutl2-ge.sh"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 22:38:53 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 22:38:53 +0900`

---
### コマンド 170 — `H066`

#### 目的

AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$GE_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG='-all,+timestamp,+dwrite,+seh'
```

#### 実行コマンド

```fish
rm -f "$ROOT/logs/font-fix-test.log"

cd "$GE_PREFIX/drive_c/AviUtl2"

env \
    WINEPREFIX="$GE_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG='-all,+timestamp,+dwrite,+seh' \
    "$GE_WINE" ./aviutl2.exe \
    2>&1 | tee "$ROOT/logs/font-fix-test.log"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 22:39:03 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、WineフォントファイルまたはFont registry、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 22:39:03 +0900`

---
### コマンド 171 — `H067`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set GE_PREFIX "$ROOT/prefix-ge"

set GE_DIR "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINE "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER "$GE_DIR/files/bin/wineserver"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

set NOTO_DIR "/usr/share/fonts/noto-cjk"

set FONTS_DIR "$GE_PREFIX/drive_c/windows/Fonts"
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set GE_PREFIX "$ROOT/prefix-ge"
set GE_DIR "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINE "$GE_DIR/files/lib/wine/x86_64-unix/wine"
set GE_WINESERVER "$GE_DIR/files/bin/wineserver"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

set NOTO_DIR "/usr/share/fonts/noto-cjk"
set FONTS_DIR "$GE_PREFIX/drive_c/windows/Fonts"

mkdir -p "$FONTS_DIR"
```

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(223).txt timestamp 2026-07-30 22:45:13 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、WineフォントファイルまたはFont registry。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 22:45:13 +0900`

---
### コマンド 172 — `H068`

#### 目的

Wineレジストリの旧設定を削除する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set REG_SUBS \
    'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\FontSubstitutes'

WINEPREFIX="$GE_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"
```

#### 実行コマンド

```fish
set REG_SUBS \
    'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\FontSubstitutes'

env \
    WINEPREFIX="$GE_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" reg delete "$REG_SUBS" \
    /v Tahoma \
    /f

or true
```

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(223).txt timestamp 2026-07-30 22:46:24 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、WineフォントファイルまたはFont registry。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 22:46:24 +0900`

---
### コマンド 173 — `H069`

#### 目的

WineレジストリへDLL override、フォント、IMEなどの設定を登録する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set REG_FONTS \
    'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Fonts'

WINEPREFIX="$GE_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"
```

#### 実行コマンド

```fish
set REG_FONTS \
    'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Fonts'

env \
    WINEPREFIX="$GE_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" reg add "$REG_FONTS" \
    /v 'Tahoma (OpenType)' \
    /d 'Tahoma-Noto-Regular.otf' \
    /f

env \
    WINEPREFIX="$GE_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" reg add "$REG_FONTS" \
    /v 'Tahoma Bold (OpenType)' \
    /d 'Tahoma-Noto-Bold.otf' \
    /f
```

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(223).txt timestamp 2026-07-30 22:46:32 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、WineフォントファイルまたはFont registry。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 22:46:32 +0900`

---
### コマンド 174 — `H070`

#### 目的

Wine prefixを作成または更新し、レジストリとランタイム状態を反映する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$GE_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"
```

#### 実行コマンド

```fish
env \
    WINEPREFIX="$GE_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" wineboot -u

env WINEPREFIX="$GE_PREFIX" \
    "$GE_WINESERVER" -w
```

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(223).txt timestamp 2026-07-30 22:46:40 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 22:46:40 +0900`

---
### コマンド 175 — `H071`

#### 目的

AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$GE_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG='-all,+timestamp,+dwrite,+seh'
```

#### 実行コマンド

```fish
rm -f "$ROOT/logs/tahoma-fix-test.log"

cd "$GE_PREFIX/drive_c/AviUtl2"

env \
    WINEPREFIX="$GE_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG='-all,+timestamp,+dwrite,+seh' \
    "$GE_WINE" ./aviutl2.exe \
    2>&1 | tee "$ROOT/logs/tahoma-fix-test.log"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 22:46:50 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、WineフォントファイルまたはFont registry、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 22:46:50 +0900`

---
### コマンド 176 — `H072`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set GE_PREFIX "$ROOT/prefix-ge"

set GE_DIR "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINE "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER "$GE_DIR/files/bin/wineserver"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

set WINE_COMMIT \
    "31af7f983b2e345d11340b120ae3a39d88c9338a"

set WINE_SRC \
    "$ROOT/src/wine-ge11-1-dwrite"

set WINE_BUILD \
    "$ROOT/build/wine-ge11-1-dwrite"

set WINE_ARCHIVE \
    "$ROOT/src/wine-$WINE_COMMIT.tar.gz"

set DWRITE_PATCH \
    "$ROOT/src/dwrite-hittest.patch"
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"

set GE_PREFIX "$ROOT/prefix-ge"
set GE_DIR "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"
set GE_WINE "$GE_DIR/files/lib/wine/x86_64-unix/wine"
set GE_WINESERVER "$GE_DIR/files/bin/wineserver"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

set WINE_COMMIT \
    "31af7f983b2e345d11340b120ae3a39d88c9338a"

set WINE_SRC \
    "$ROOT/src/wine-ge11-1-dwrite"

set WINE_BUILD \
    "$ROOT/build/wine-ge11-1-dwrite"

set WINE_ARCHIVE \
    "$ROOT/src/wine-$WINE_COMMIT.tar.gz"

set DWRITE_PATCH \
    "$ROOT/src/dwrite-hittest.patch"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 22:56:12 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner。

#### 関連する固定値

- commit: `31af7f983b2e345d11340b120ae3a39d88c9338a`
- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 22:56:12 +0900`

---
### コマンド 177 — `H073`

#### 目的

バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set LAYOUT_FILE "$WINE_SRC/dlls/dwrite/layout.c"
```

#### 実行コマンド

```fish
set LAYOUT_FILE "$WINE_SRC/dlls/dwrite/layout.c"

if not test -f "$LAYOUT_FILE.before-aviutl2-hittest"
cp -a \
        "$LAYOUT_FILE" \
        "$LAYOUT_FILE.before-aviutl2-hittest"
end
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 23:10:09 +0900`。

#### 生成・変更されたもの

Wine DirectWriteまたはpatched runner。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 23:10:09 +0900`

---
### コマンド 178 — `H074`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set GE_PREFIX "$ROOT/prefix-ge"

set GE_DIR "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINE "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER "$GE_DIR/files/bin/wineserver"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

set PATCHED_DWRITE \
    "$ROOT/build/wine-ge11-1-dwrite/dlls/dwrite/x86_64-windows/dwrite.dll"

set GE_DWRITE \
    "$GE_DIR/files/lib/wine/x86_64-windows/dwrite.dll"

set DWRITE_BACKUP \
    "$ROOT/backups/GE-Proton11-1-dwrite-original.dll"
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set GE_PREFIX "$ROOT/prefix-ge"
set GE_DIR "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINE "$GE_DIR/files/lib/wine/x86_64-unix/wine"
set GE_WINESERVER "$GE_DIR/files/bin/wineserver"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

set PATCHED_DWRITE \
    "$ROOT/build/wine-ge11-1-dwrite/dlls/dwrite/x86_64-windows/dwrite.dll"

set GE_DWRITE \
    "$GE_DIR/files/lib/wine/x86_64-windows/dwrite.dll"

set DWRITE_BACKUP \
    "$ROOT/backups/GE-Proton11-1-dwrite-original.dll"

mkdir -p "$ROOT/backups"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 23:23:54 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 23:23:54 +0900`

---
### コマンド 179 — `H075`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$GE_PREFIX"
```

#### 実行コマンド

```fish
env WINEPREFIX="$GE_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 23:24:00 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 23:24:00 +0900`

---
### コマンド 180 — `H076`

#### 目的

必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
if not test -f "$DWRITE_BACKUP"
cp -a "$GE_DWRITE" "$DWRITE_BACKUP"
end
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 23:24:09 +0900`。

#### 生成・変更されたもの

Wine DirectWriteまたはpatched runner。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 23:24:09 +0900`

---
### コマンド 181 — `H077`

#### 目的

AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$GE_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG='-all,+timestamp,+loaddll,+dwrite,+seh'
```

#### 実行コマンド

```fish
rm -f "$ROOT/logs/dwrite-empty-fix-test.log"

cd "$GE_PREFIX/drive_c/AviUtl2"

env \
    WINEPREFIX="$GE_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG='-all,+timestamp,+loaddll,+dwrite,+seh' \
    "$GE_WINE" ./aviutl2.exe \
    2>&1 | tee "$ROOT/logs/dwrite-empty-fix-test.log"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 23:24:32 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 23:24:32 +0900`

---
### コマンド 182 — `H078`

#### 目的

バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set WINE_SRC \
    "$ROOT/src/wine-ge11-1-dwrite"

set WINE_BUILD \
    "$ROOT/build/wine-ge11-1-dwrite"

set LAYOUT_FILE \
    "$WINE_SRC/dlls/dwrite/layout.c"
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"

set WINE_SRC \
    "$ROOT/src/wine-ge11-1-dwrite"

set WINE_BUILD \
    "$ROOT/build/wine-ge11-1-dwrite"

set LAYOUT_FILE \
    "$WINE_SRC/dlls/dwrite/layout.c"

cp -a \
    "$LAYOUT_FILE" \
    "$LAYOUT_FILE.before-full-hittest"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 23:50:02 +0900`。

#### 生成・変更されたもの

Wine DirectWriteまたはpatched runner。

#### 関連する固定値

- path: `$HOME/Games/aviutl2`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 23:50:02 +0900`

---
### コマンド 183 — `H079`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set GE_PREFIX "$ROOT/prefix-ge"

set GE_DIR \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINE \
    "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_DIR/files/bin/wineserver"

set GE_DWRITE \
    "$GE_DIR/files/lib/wine/x86_64-windows/dwrite.dll"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"
```

#### 実行コマンド

```fish
set GE_PREFIX "$ROOT/prefix-ge"

set GE_DIR \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINE \
    "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_DIR/files/bin/wineserver"

set GE_DWRITE \
    "$GE_DIR/files/lib/wine/x86_64-windows/dwrite.dll"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-30 23:54:55 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-30 23:54:55 +0900`

---
### コマンド 184 — `H080`

#### 目的

バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$GE_PREFIX"
```

#### 実行コマンド

```fish
env WINEPREFIX="$GE_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1

install -m 0644 \
    "$PATCHED_DWRITE" \
    "$GE_DWRITE"

sha256sum \
    "$PATCHED_DWRITE" \
    "$GE_DWRITE"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 00:03:43 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 00:03:43 +0900`

---
### コマンド 185 — `H081`

#### 目的

AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$GE_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG='-all,+timestamp,+dwrite,+seh'
```

#### 実行コマンド

```fish
rm -f \
    "$ROOT/logs/dwrite-regular-fix-test.log"

cd "$GE_PREFIX/drive_c/AviUtl2"

env \
    WINEPREFIX="$GE_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG='-all,+timestamp,+dwrite,+seh' \
    "$GE_WINE" ./aviutl2.exe \
    2>&1 | tee \
    "$ROOT/logs/dwrite-regular-fix-test.log"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 00:06:38 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 00:06:38 +0900`

---
### コマンド 186 — `H082`

#### 目的

バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set LWINPUT (

set PLUGIN_DIR \
    "$GE_PREFIX/drive_c/ProgramData/aviutl2/Plugin/L-SMASH-Works"
```

#### 実行コマンド

```fish
set LWINPUT (
find "$LSW_EXTRACT" \
        -type f \
        -iname 'lwinput.aui2' \
        -path '*/AviUtl2/*' \
        -print \
        | head -n 1
)

if test -z "$LWINPUT"
echo "ERROR: AviUtl2/lwinput.aui2 が見つかりません"
find "$LSW_EXTRACT" -type f -iname 'lwinput*' -print
return 1
end

set PLUGIN_DIR \
    "$GE_PREFIX/drive_c/ProgramData/aviutl2/Plugin/L-SMASH-Works"

mkdir -p "$PLUGIN_DIR"

install -m 0644 \
    "$LWINPUT" \
    "$PLUGIN_DIR/lwinput.aui2"

file "$PLUGIN_DIR/lwinput.aui2"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 01:02:11 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、L-SMASH Works plugin/config。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 01:02:11 +0900`

---
### コマンド 187 — `H083`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set GE_PREFIX "$ROOT/prefix-ge"

set GE_DIR "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINESERVER "$GE_DIR/files/bin/wineserver"

set LSW_DIR "$ROOT/downloads/l-smash-works"

set LSW_JSON "$LSW_DIR/latest.json"

set LSW_ZIP "$LSW_DIR/latest.zip"

set LSW_EXTRACT "$LSW_DIR/extracted"

WINEPREFIX="$GE_PREFIX"
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set GE_PREFIX "$ROOT/prefix-ge"
set GE_DIR "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"
set GE_WINESERVER "$GE_DIR/files/bin/wineserver"

set LSW_DIR "$ROOT/downloads/l-smash-works"
set LSW_JSON "$LSW_DIR/latest.json"
set LSW_ZIP "$LSW_DIR/latest.zip"
set LSW_EXTRACT "$LSW_DIR/extracted"

mkdir -p "$LSW_DIR"

env WINEPREFIX="$GE_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 01:28:29 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 01:28:29 +0900`

---
### コマンド 188 — `H084`

#### 目的

バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set PLUGIN_DIR \
    "$GE_PREFIX/drive_c/ProgramData/aviutl2/Plugin/L-SMASH-Works"
```

#### 実行コマンド

```fish
set PLUGIN_DIR \
    "$GE_PREFIX/drive_c/ProgramData/aviutl2/Plugin/L-SMASH-Works"

mkdir -p "$PLUGIN_DIR"

install \
    -m 0644 \
    "$LWINPUT" \
    "$PLUGIN_DIR/lwinput.aui2"

sha256sum \
    "$LWINPUT" \
    "$PLUGIN_DIR/lwinput.aui2"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 01:28:59 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、L-SMASH Works plugin/config。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 01:28:59 +0900`

---
### コマンド 189 — `H085`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set GE_PREFIX "$ROOT/prefix-ge"

set GE_DIR "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINE "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER "$GE_DIR/files/bin/wineserver"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

set CATALOG_DIR "$ROOT/tools/aviutl2-catalog"

set CATALOG_JSON "$CATALOG_DIR/latest.json"

WINEPREFIX="$GE_PREFIX"
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"

set GE_PREFIX "$ROOT/prefix-ge"
set GE_DIR "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"
set GE_WINE "$GE_DIR/files/lib/wine/x86_64-unix/wine"
set GE_WINESERVER "$GE_DIR/files/bin/wineserver"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

set CATALOG_DIR "$ROOT/tools/aviutl2-catalog"
set CATALOG_JSON "$CATALOG_DIR/latest.json"

mkdir -p "$CATALOG_DIR"

env WINEPREFIX="$GE_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 01:35:17 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Catalog application/config/state、ログファイル。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 01:35:17 +0900`

---
### コマンド 190 — `H086`

#### 目的

AviUtl2 on Linux環境の構築・調査・検証に関係する処理を実行する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$GE_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='dwrite=b'

WINEDEBUG='-all'
```

#### 実行コマンド

```fish
env \
    WINEPREFIX="$GE_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='dwrite=b' \
    WINEDEBUG='-all' \
    "$GE_WINE" "$CATALOG_INSTALLER"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 01:36:32 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、Catalog application/config/state、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 01:36:32 +0900`

---
### コマンド 191 — `H087`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set GE_PREFIX "$ROOT/prefix-ge"

set GE_DIR "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINE "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER "$GE_DIR/files/bin/wineserver"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

WINEPREFIX="$GE_PREFIX"
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set GE_PREFIX "$ROOT/prefix-ge"
set GE_DIR "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"
set GE_WINE "$GE_DIR/files/lib/wine/x86_64-unix/wine"
set GE_WINESERVER "$GE_DIR/files/bin/wineserver"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

env WINEPREFIX="$GE_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 01:57:27 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 01:57:27 +0900`

---
### コマンド 192 — `H088`

#### 目的

ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set CATALOG_CONFIG (
```

#### 実行コマンド

```fish
set CATALOG_CONFIG (
find "$GE_PREFIX/drive_c/users" \
        -type d \
        -ipath '*/AppData/Roaming/aviutl2-catalog' \
        -print \
        | head -n 1
)
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-31 01:57:33 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Catalog application/config/state、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 01:57:33 +0900`

---
### コマンド 193 — `H089`

#### 目的

バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set WINE_PROFILE (

set CATALOG_CONFIG \
        "$WINE_PROFILE/AppData/Roaming/aviutl2-catalog"
```

#### 実行コマンド

```fish
if test -z "$CATALOG_CONFIG"
set WINE_PROFILE (
find "$GE_PREFIX/drive_c/users" \
            -mindepth 1 \
            -maxdepth 1 \
            -type d \
            ! -iname 'Public' \
            ! -iname 'Default*' \
            -print \
            | head -n 1
)

if test -z "$WINE_PROFILE"
echo "ERROR: Wineユーザープロファイルが見つかりません"
return 1
end

set CATALOG_CONFIG \
        "$WINE_PROFILE/AppData/Roaming/aviutl2-catalog"
end

mkdir -p "$CATALOG_CONFIG"

echo "Catalog config: $CATALOG_CONFIG"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 01:57:39 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Catalog application/config/state、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 01:57:39 +0900`

---
### コマンド 194 — `H090`

#### 目的

必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
if test -f "$CATALOG_CONFIG/settings.json"
cp -a \
        "$CATALOG_CONFIG/settings.json" \
        "$CATALOG_CONFIG/settings.json.before-existing-aviutl2"
end
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 01:57:45 +0900`。

#### 生成・変更されたもの

Catalog application/config/state、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 01:57:45 +0900`

---
### コマンド 195 — `H091`

#### 目的

AviUtl2 Catalogの取得、導入、起動、設定または更新停止状態を処理する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set CATALOG_EXE (
```

#### 実行コマンド

```fish
set CATALOG_EXE (
find "$GE_PREFIX/drive_c" \
        -type f \
        \( \
            -iname 'AviUtl2_Catalog.exe' \
            -o -iname 'aviutl2-catalog.exe' \
        \) \
        -print \
        | head -n 1
)

if test -z "$CATALOG_EXE"
echo "ERROR: AviUtl2カタログ本体が見つかりません"
find "$GE_PREFIX/drive_c" \
        -type f \
        -iname '*catalog*.exe' \
        -print
return 1
end

echo "Catalog: $CATALOG_EXE"
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-31 01:57:53 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Catalog application/config/state、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 01:57:53 +0900`

---
### コマンド 196 — `H092`

#### 目的

AviUtl2 Catalogの取得、導入、起動、設定または更新停止状態を処理する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$GE_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='dwrite=b'

WINEDEBUG='-all'
```

#### 実行コマンド

```fish
env \
    WINEPREFIX="$GE_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='dwrite=b' \
    WINEDEBUG='-all' \
    "$GE_WINE" "$CATALOG_EXE"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 01:57:59 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、Catalog application/config/state、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 01:57:59 +0900`

---
### コマンド 197 — `H093`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set GE_PREFIX "$ROOT/prefix-ge"

set GE_DIR "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINE "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER "$GE_DIR/files/bin/wineserver"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

WINEPREFIX="$GE_PREFIX"
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"

set GE_PREFIX "$ROOT/prefix-ge"
set GE_DIR "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"
set GE_WINE "$GE_DIR/files/lib/wine/x86_64-unix/wine"
set GE_WINESERVER "$GE_DIR/files/bin/wineserver"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

env WINEPREFIX="$GE_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 02:06:30 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 02:06:30 +0900`

---
### コマンド 198 — `H094`

#### 目的

AviUtl2 Catalogの取得、導入、起動、設定または更新停止状態を処理する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set CATALOG_EXE (
```

#### 実行コマンド

```fish
set CATALOG_EXE (
find "$GE_PREFIX/drive_c" \
        -type f \
        \( \
            -iname 'AviUtl2_Catalog.exe' \
            -o -iname 'aviutl2-catalog.exe' \
        \) \
        -print \
        | head -n 1
)

echo "$CATALOG_EXE"
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-31 02:06:34 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Catalog application/config/state、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 02:06:34 +0900`

---
### コマンド 199 — `H095`

#### 目的

ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set CATALOG_SETTINGS (
```

#### 実行コマンド

```fish
set CATALOG_SETTINGS (
find "$GE_PREFIX/drive_c/users" \
        -type f \
        -ipath '*/aviutl2-catalog/settings.json' \
        -print \
        | head -n 1
)

echo "Settings: $CATALOG_SETTINGS"

if test -n "$CATALOG_SETTINGS"
cat "$CATALOG_SETTINGS"
end
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-31 02:07:39 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Catalog application/config/state、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 02:07:39 +0900`

---
### コマンド 200 — `H096`

#### 目的

AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
test -f "$GE_PREFIX/drive_c/AviUtl2/aviutl2.exe"
and echo "aviutl2.exe: OK"
or echo "aviutl2.exe: NOT FOUND"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 02:07:52 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 02:07:52 +0900`

---
### コマンド 201 — `H097`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set GE_PREFIX "$ROOT/prefix-ge"

set GE_DIR "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINESERVER "$GE_DIR/files/bin/wineserver"

WINEPREFIX="$GE_PREFIX"
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set GE_PREFIX "$ROOT/prefix-ge"
set GE_DIR "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"
set GE_WINESERVER "$GE_DIR/files/bin/wineserver"

env WINEPREFIX="$GE_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 02:11:07 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 02:11:07 +0900`

---
### コマンド 202 — `H098`

#### 目的

ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
find "$GE_PREFIX/drive_c" \
    -type f \
    \( \
        -iname 'lwinput.aui2' \
        -o -iname 'lwinput.aui' \
    \) \
    -print \
    | sort
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-31 02:11:14 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、L-SMASH Works plugin/config。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 02:11:14 +0900`

---
### コマンド 203 — `H099`

#### 目的

バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
find "$GE_PREFIX/drive_c" \
    -type f \
    \( \
        -iname 'lwinput.aui2' \
        -o -iname 'lwinput.aui' \
    \) \
    -print \
    | sort \
    | while read -l FILE
echo
echo "=== $FILE ==="
file "$FILE"
sha256sum "$FILE"
end
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-31 02:11:19 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、L-SMASH Works plugin/config。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 02:11:19 +0900`

---
### コマンド 204 — `H100`

#### 目的

ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set SAFE_NAME (
```

#### 実行コマンド

```fish
find "$GE_PREFIX/drive_c" \
    -type f \
    \( \
        -iname 'lwinput.aui2' \
        -o -iname 'lwinput.aui' \
    \) \
    -print \
    | while read -l FILE
set SAFE_NAME (
string replace -a '/' '__' "$FILE"
)

mv \
            "$FILE" \
            "$LSW_QUARANTINE/$SAFE_NAME"
end
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 02:11:30 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、L-SMASH Works plugin/config。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 02:11:30 +0900`

---
### コマンド 205 — `H101`

#### 目的

ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
find "$GE_PREFIX/drive_c" \
    -type f \
    \( \
        -iname 'lwinput.aui2' \
        -o -iname 'lwinput.aui' \
    \) \
    -print
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-31 02:11:34 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、L-SMASH Works plugin/config。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 02:11:34 +0900`

---
### コマンド 206 — `H102`

#### 目的

ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
find "$GE_PREFIX/drive_c" \
    -type f \
    -iname 'lwinput.aui2' \
    -print
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-31 02:11:38 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、L-SMASH Works plugin/config。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 02:11:38 +0900`

---
### コマンド 207 — `H103`

#### 目的

バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set GE_PREFIX "$ROOT/prefix-ge"

set LWINPUT (
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set GE_PREFIX "$ROOT/prefix-ge"

set LWINPUT (
find "$GE_PREFIX/drive_c" \
        -type f \
        -iname 'lwinput.aui2' \
        -print \
        | head -n 1
)

echo "L-SMASH Works: $LWINPUT"

strings "$LWINPUT" \
    | grep -Ei \
        'av1_cuvid|nvcuvid|nvcuda|libdav1d' \
    | sort -u
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-31 02:34:13 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、L-SMASH Works plugin/config。

#### 関連する固定値

- path: `$HOME/Games/aviutl2`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 02:34:13 +0900`

---
### コマンド 208 — `H104`

#### 目的

ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set GE_DIR \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"
```

#### 実行コマンド

```fish
set GE_DIR \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

find \
    "$GE_DIR/files" \
    "$GE_PREFIX/drive_c/windows" \
    -type f \
    \( \
        -iname 'nvcuda*' \
        -o -iname 'nvcuvid*' \
        -o -iname 'nvencodeapi*' \
    \) \
    -print \
    | sort
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-31 02:34:28 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 02:34:28 +0900`

---
### コマンド 209 — `H105`

#### 目的

AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set GE_WINE \
    "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

set NVDEC_LOG \
    "$ROOT/logs/aviutl2-nvdec.log"

WINEPREFIX="$GE_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

WINEDEBUG='-all,+loaddll,+nvcuda,+nvcuvid'
```

#### 実行コマンド

```fish
set GE_WINE \
    "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

set NVDEC_LOG \
    "$ROOT/logs/aviutl2-nvdec.log"

mkdir -p "$ROOT/logs"

cd "$GE_PREFIX/drive_c/AviUtl2"

env \
    WINEPREFIX="$GE_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    WINEDEBUG='-all,+loaddll,+nvcuda,+nvcuvid' \
    "$GE_WINE" ./aviutl2.exe \
    &> "$NVDEC_LOG"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 02:34:45 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 02:34:45 +0900`

---
### コマンド 210 — `H106`

#### 目的

必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set NV_PREFIX \
    "$ROOT/prefix-ge-nvdec-test"
```

#### 実行コマンド

```fish
set NV_PREFIX \
    "$ROOT/prefix-ge-nvdec-test"

rm -rf "$NV_PREFIX"

cp -a \
    --reflink=auto \
    "$GE_PREFIX" \
    "$NV_PREFIX"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 02:36:11 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 02:36:11 +0900`

---
### コマンド 211 — `H107`

#### 目的

AviUtl2 Catalogの取得、導入、起動、設定または更新停止状態を処理する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$GE_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG='-all'
```

#### 実行コマンド

```fish
env \
    WINEPREFIX="$GE_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG='-all' \
    "$GE_WINE" "$CATALOG_EXE"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 02:39:13 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、Catalog application/config/state、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 02:39:13 +0900`

---
### コマンド 212 — `H108`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set GE_PREFIX "$ROOT/prefix-ge"

set GE_DIR \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINE \
    "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_DIR/files/bin/wineserver"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

WINEPREFIX="$GE_PREFIX"
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set GE_PREFIX "$ROOT/prefix-ge"

set GE_DIR \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINE \
    "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_DIR/files/bin/wineserver"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

env WINEPREFIX="$GE_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 02:44:00 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 02:44:00 +0900`

---
### コマンド 213 — `H109`

#### 目的

AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set NVDEC_LOG \
    "$ROOT/logs/aviutl2-nvdec-builtin.log"

WINEPREFIX="$GE_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='nvcuda,nvcuvid=b;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG='-all,+loaddll,+nvcuda,+nvcuvid'
```

#### 実行コマンド

```fish
set NVDEC_LOG \
    "$ROOT/logs/aviutl2-nvdec-builtin.log"

cd "$GE_PREFIX/drive_c/AviUtl2"

env \
    WINEPREFIX="$GE_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='nvcuda,nvcuvid=b;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG='-all,+loaddll,+nvcuda,+nvcuvid' \
    "$GE_WINE" ./aviutl2.exe \
    &> "$NVDEC_LOG"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 02:44:14 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 02:44:14 +0900`

---
### コマンド 214 — `H110`

#### 目的

AviUtl2 on Linux環境の構築・調査・検証に関係する処理を実行する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
env GE_PREFIX="$GE_PREFIX" \
    /usr/bin/python -c '
from pathlib import Path
import os

prefix = Path(os.environ["GE_PREFIX"])

roots = [
    prefix / "drive_c" / "ProgramData" / "aviutl2",
    prefix / "drive_c" / "users",
    prefix / "drive_c" / "AviUtl2",
]

files = [
    prefix / "user.reg",
    prefix / "system.reg",
    prefix / "userdef.reg",
]

needle_ascii = b"av1_cuvid"
needle_utf16 = "av1_cuvid".encode("utf-16le")

found = []

for root in roots:
    if not root.exists():
        continue

    for path in root.rglob("*"):
        try:
            if not path.is_file():
                continue
            if path.stat().st_size > 64 * 1024 * 1024:
                continue

            data = path.read_bytes()

            if needle_ascii in data or needle_utf16 in data:
                found.append(path)
        except OSError:
            pass

for path in files:
    try:
        data = path.read_bytes()

        if needle_ascii in data or needle_utf16 in data:
            found.append(path)
    except OSError:
        pass

if found:
    print("av1_cuvid found in:")
    for path in sorted(set(found)):
        print(path)
else:
    print("av1_cuvid was not found in this prefix")
'
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 02:48:02 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 02:48:02 +0900`

---
### コマンド 215 — `H111`

#### 目的

バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set LSMASH_INI \
    "$GE_PREFIX/drive_c/ProgramData/aviutl2/Plugin/lsmash.ini"
```

#### 実行コマンド

```fish
set LSMASH_INI \
    "$GE_PREFIX/drive_c/ProgramData/aviutl2/Plugin/lsmash.ini"

file "$LSMASH_INI"

echo
grep -nEi \
    'libav|l-smash|preferred|decoder|cuvid' \
    "$LSMASH_INI"

echo
sed -n '1,240p' "$LSMASH_INI"
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-31 02:52:43 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、L-SMASH Works plugin/config。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 02:52:43 +0900`

---
### コマンド 216 — `H112`

#### 目的

AV1検証素材を作成またはメディア属性を確認する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set VIDEO \
    "/run/media/alex/6A0CF5D10CF59871/編集/録画データ/2026-07-15 15-32-57.mp4"

set CUVID_TEST \
    "$GE_PREFIX/drive_c/AviUtl2/av1-cuvid-test.mp4"
```

#### 実行コマンド

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

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(223).txt timestamp 2026-07-31 02:52:56 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

- path: `/run/media/alex/6A0CF5D10CF59871/編集/録画データ/2026-07-15`

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 02:52:56 +0900`

---
### コマンド 217 — `H113`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set NVDEC_LOG \
    "$ROOT/logs/aviutl2-nvdec-real-import.log"

WINEPREFIX="$GE_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='nvcuda,nvcuvid=b;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG='-all,+timestamp,+loaddll,+nvcuda,+nvcuvid'
```

#### 実行コマンド

```fish
set NVDEC_LOG \
    "$ROOT/logs/aviutl2-nvdec-real-import.log"

env WINEPREFIX="$GE_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1

cd "$GE_PREFIX/drive_c/AviUtl2"

env \
    WINEPREFIX="$GE_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='nvcuda,nvcuvid=b;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG='-all,+timestamp,+loaddll,+nvcuda,+nvcuvid' \
    "$GE_WINE" ./aviutl2.exe \
    &> "$NVDEC_LOG"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 02:53:05 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 02:53:05 +0900`

---
### コマンド 218 — `H114`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set GE_PREFIX "$ROOT/prefix-ge"

set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_DIR \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINE \
    "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_DIR/files/bin/wineserver"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

WINEPREFIX="$GE_PREFIX"
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set GE_PREFIX "$ROOT/prefix-ge"
set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_DIR \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINE \
    "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_DIR/files/bin/wineserver"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

env WINEPREFIX="$GE_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1

rm -rf "$NV_PREFIX"

cp -a \
    --reflink=auto \
    "$GE_PREFIX" \
    "$NV_PREFIX"

echo "Created: $NV_PREFIX"
```

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(223).txt timestamp 2026-07-31 02:57:14 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 02:57:14 +0900`

---
### コマンド 219 — `H115`

#### 目的

必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set NV_SYSTEM32 \
    "$NV_PREFIX/drive_c/windows/system32"

set NV_BACKUP \
    "$ROOT/backups/prefix-ge-nvdec-test-system32"
```

#### 実行コマンド

```fish
set NV_SYSTEM32 \
    "$NV_PREFIX/drive_c/windows/system32"

set NV_BACKUP \
    "$ROOT/backups/prefix-ge-nvdec-test-system32"

mkdir -p "$NV_BACKUP"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 02:57:37 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 02:57:37 +0900`

---
### コマンド 220 — `H116`

#### 目的

必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
for DLL in nvcuda nvcuvid
if test -e "$NV_SYSTEM32/$DLL.dll"
cp -a \
            "$NV_SYSTEM32/$DLL.dll" \
            "$NV_BACKUP/$DLL.dll.before-nvidia-libs"
end
end
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 02:58:37 +0900`。

#### 生成・変更されたもの

コマンド本文に記載された対象。詳細は実行コマンドを参照。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 02:58:37 +0900`

---
### コマンド 221 — `H117`

#### 目的

WineレジストリへDLL override、フォント、IMEなどの設定を登録する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$NV_PREFIX"
```

#### 実行コマンド

```fish
for DLL in nvcuda nvcuvid
env WINEPREFIX="$NV_PREFIX" \
        "$GE_WINE" reg add \
        'HKEY_CURRENT_USER\Software\Wine\DllOverrides' \
        /v "$DLL" \
        /d native \
        /f
end
```

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(223).txt timestamp 2026-07-31 02:58:47 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 02:58:47 +0900`

---
### コマンド 222 — `H118`

#### 目的

Wineレジストリの設定値を確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$NV_PREFIX"
```

#### 実行コマンド

```fish
ls -l \
    "$NV_SYSTEM32/nvcuda.dll" \
    "$NV_SYSTEM32/nvcuvid.dll"

env WINEPREFIX="$NV_PREFIX" \
    "$GE_WINE" reg query \
    'HKEY_CURRENT_USER\Software\Wine\DllOverrides'
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-31 02:58:55 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 02:58:55 +0900`

---
### コマンド 223 — `H119`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set NVDEC_LOG \
    "$ROOT/logs/aviutl2-nvidia-libs-nvdec.log"

WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='nvcuda,nvcuvid=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG='-all,+timestamp,+loaddll,+nvcuda,+nvcuvid'
```

#### 実行コマンド

```fish
env WINEPREFIX="$NV_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1

set NVDEC_LOG \
    "$ROOT/logs/aviutl2-nvidia-libs-nvdec.log"

cd "$NV_PREFIX/drive_c/AviUtl2"

env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='nvcuda,nvcuvid=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG='-all,+timestamp,+loaddll,+nvcuda,+nvcuvid' \
    "$GE_WINE" ./aviutl2.exe \
    &> "$NVDEC_LOG"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 02:59:01 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 02:59:01 +0900`

---
### コマンド 224 — `H120`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_DIR \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINE \
    "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_DIR/files/bin/wineserver"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

set NVLIBS_SRC \
    "$ROOT/tools/nvidia-libs/nvidia-libs-v1.0.2"

set CUDATEST \
    "$NVLIBS_SRC/bin/cudatest.exe"

set CUDA_LOG \
    "$ROOT/logs/nvidia-libs-cudatest.log"

set CUDA_STATUS $status

WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='nvcuda=n'

WINEDEBUG='-all,+loaddll,+nvcuda'
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_DIR \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINE \
    "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_DIR/files/bin/wineserver"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

set NVLIBS_SRC \
    "$ROOT/tools/nvidia-libs/nvidia-libs-v1.0.2"

set CUDATEST \
    "$NVLIBS_SRC/bin/cudatest.exe"

set CUDA_LOG \
    "$ROOT/logs/nvidia-libs-cudatest.log"

env WINEPREFIX="$NV_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1

env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='nvcuda=n' \
    WINEDEBUG='-all,+loaddll,+nvcuda' \
    "$GE_WINE" "$CUDATEST" \
    &> "$CUDA_LOG"

set CUDA_STATUS $status

echo "cudatest status: $CUDA_STATUS"
cat "$CUDA_LOG"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 03:19:07 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、ログファイル。

#### 関連する固定値

- version: `GE-Proton11-1`
- version: `v1.0.2`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 03:19:07 +0900`

---
### コマンド 225 — `H121`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set CUVID_OUTPUT \
    "$NV_PREFIX/drive_c/AviUtl2/cuvid-decoded-5frames.yuv"

set NVENCC_LOG \
    "$ROOT/logs/nvencc-av1-cuvid-decode.log"

set NVENCC_STATUS $status

WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='nvcuda,nvcuvid=n'

WINEDEBUG='-all,+loaddll,+nvcuda,+nvcuvid'
```

#### 実行コマンド

```fish
set CUVID_OUTPUT \
    "$NV_PREFIX/drive_c/AviUtl2/cuvid-decoded-5frames.yuv"

set NVENCC_LOG \
    "$ROOT/logs/nvencc-av1-cuvid-decode.log"

rm -f "$CUVID_OUTPUT"

env WINEPREFIX="$NV_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1

cd (dirname "$NVENCC")

env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='nvcuda,nvcuvid=n' \
    WINEDEBUG='-all,+loaddll,+nvcuda,+nvcuvid' \
    "$GE_WINE" "$NVENCC" \
    --avhw \
    --codec raw \
    --frames 5 \
    --input 'C:\AviUtl2\av1-cuvid-test.mp4' \
    --output 'C:\AviUtl2\cuvid-decoded-5frames.yuv' \
    &> "$NVENCC_LOG"

set NVENCC_STATUS $status

echo "NVEncC status: $NVENCC_STATUS"
echo
cat "$NVENCC_LOG"

echo
ls -lh "$CUVID_OUTPUT" 2>/dev/null
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 03:19:21 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 03:19:21 +0900`

---
### コマンド 226 — `H122`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_DIR \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINE \
    "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_DIR/files/bin/wineserver"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

set NVLIBS_SRC \
    "$ROOT/tools/nvidia-libs/nvidia-libs-v1.0.2"

set NV_SYSTEM32 \
    "$NV_PREFIX/drive_c/windows/system32"
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_DIR \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINE \
    "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_DIR/files/bin/wineserver"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

set NVLIBS_SRC \
    "$ROOT/tools/nvidia-libs/nvidia-libs-v1.0.2"

set NV_SYSTEM32 \
    "$NV_PREFIX/drive_c/windows/system32"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 03:21:37 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

- version: `GE-Proton11-1`
- version: `v1.0.2`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 03:21:37 +0900`

---
### コマンド 227 — `H123`

#### 目的

WineレジストリへDLL override、フォント、IMEなどの設定を登録する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$NV_PREFIX"
```

#### 実行コマンド

```fish
env WINEPREFIX="$NV_PREFIX" \
    "$GE_WINE" reg add \
    'HKEY_CURRENT_USER\Software\Wine\DllOverrides' \
    /v nvencodeapi64 \
    /d native \
    /f
```

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(223).txt timestamp 2026-07-31 03:21:47 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 03:21:47 +0900`

---
### コマンド 228 — `H124`

#### 目的

Wineレジストリの設定値を確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$NV_PREFIX"
```

#### 実行コマンド

```fish
ls -l \
    "$NV_SYSTEM32/nvcuda.dll" \
    "$NV_SYSTEM32/nvcuvid.dll" \
    "$NV_SYSTEM32/nvencodeapi64.dll"

env WINEPREFIX="$NV_PREFIX" \
    "$GE_WINE" reg query \
    'HKEY_CURRENT_USER\Software\Wine\DllOverrides' \
    /v nvencodeapi64
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-31 03:21:53 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 03:21:53 +0900`

---
### コマンド 229 — `H125`

#### 目的

ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set NVENCC (

set CUVID_OUTPUT \
    "$NV_PREFIX/drive_c/AviUtl2/cuvid-decoded-5frames.yuv"

set NVENCC_LOG \
    "$ROOT/logs/nvencc-av1-cuvid-decode-2.log"

set NVENCC_STATUS $status

WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG='-all,+loaddll,+nvcuda,+nvcuvid,+nvencodeapi'
```

#### 実行コマンド

```fish
set NVENCC (
find \
        "$NV_PREFIX/drive_c/ProgramData/aviutl2/Plugin/exe_files/NVEncC" \
        -type f \
        -iname 'NVEncC64.exe' \
        -print \
        | head -n 1
)

set CUVID_OUTPUT \
    "$NV_PREFIX/drive_c/AviUtl2/cuvid-decoded-5frames.yuv"

set NVENCC_LOG \
    "$ROOT/logs/nvencc-av1-cuvid-decode-2.log"

rm -f "$CUVID_OUTPUT"

env WINEPREFIX="$NV_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1

cd (dirname "$NVENCC")

env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG='-all,+loaddll,+nvcuda,+nvcuvid,+nvencodeapi' \
    "$GE_WINE" "$NVENCC" \
    --avhw \
    --codec raw \
    --frames 5 \
    --input 'C:\AviUtl2\av1-cuvid-test.mp4' \
    --output 'C:\AviUtl2\cuvid-decoded-5frames.yuv' \
    &> "$NVENCC_LOG"

set NVENCC_STATUS $status

echo "NVEncC status: $NVENCC_STATUS"

grep -Ei \
    'Input Info|av1|cuvid|nvencode|decoder|failed|error|NVIDIA GeForce' \
    "$NVENCC_LOG" \
    | tail -n 200

ls -lh "$CUVID_OUTPUT" 2>/dev/null
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 03:21:58 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 03:21:58 +0900`

---
### コマンド 230 — `H126`

#### 目的

ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_DIR \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINE \
    "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_DIR/files/bin/wineserver"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

set NV_LSMASH_INI \
    "$NV_PREFIX/drive_c/ProgramData/aviutl2/Plugin/lsmash.ini"
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_DIR \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINE \
    "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_DIR/files/bin/wineserver"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

set NV_LSMASH_INI \
    "$NV_PREFIX/drive_c/ProgramData/aviutl2/Plugin/lsmash.ini"

grep -nE \
    'libavsmash_disabled|libav_disabled|preferred_decoders' \
    "$NV_LSMASH_INI"
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-31 03:25:05 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、L-SMASH Works plugin/config。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 03:25:05 +0900`

---
### コマンド 231 — `H127`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set AVI_NVDEC_LOG \
    "$ROOT/logs/aviutl2-nvidia-libs-final-test.log"

WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG='-all,+loaddll,+nvcuda,+nvcuvid'
```

#### 実行コマンド

```fish
set AVI_NVDEC_LOG \
    "$ROOT/logs/aviutl2-nvidia-libs-final-test.log"

env WINEPREFIX="$NV_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1

cd "$NV_PREFIX/drive_c/AviUtl2"

env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG='-all,+loaddll,+nvcuda,+nvcuvid' \
    "$GE_WINE" ./aviutl2.exe \
    &> "$AVI_NVDEC_LOG"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 03:25:14 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 03:25:14 +0900`

---
### コマンド 232 — `H128`

#### 目的

バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set BUILT "$ROOT/src/L-SMASH-Works-nvdec/AviUtl2/lwinput.aui2"

set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set PLUGIN_DIR "$NV_PREFIX/drive_c/ProgramData/aviutl2/Plugin"

set ACTIVE "$PLUGIN_DIR/lwinput.aui2"

set STAMP (date +%Y%m%d-%H%M%S)
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set BUILT "$ROOT/src/L-SMASH-Works-nvdec/AviUtl2/lwinput.aui2"
set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"
set PLUGIN_DIR "$NV_PREFIX/drive_c/ProgramData/aviutl2/Plugin"
set ACTIVE "$PLUGIN_DIR/lwinput.aui2"
set STAMP (date +%Y%m%d-%H%M%S)

mkdir -p "$PLUGIN_DIR"

cp -a \
    "$ACTIVE" \
    "$ACTIVE.before-hwframe-transfer-$STAMP"

cp -f \
    "$BUILT" \
    "$ACTIVE"

sha256sum \
    "$BUILT" \
    "$ACTIVE"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 04:27:46 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、L-SMASH Works plugin/config。

#### 関連する固定値

- path: `$HOME/Games/aviutl2`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 04:27:46 +0900`

---
### コマンド 233 — `H129`

#### 目的

ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set PLUGIN_DIR "$NV_PREFIX/drive_c/ProgramData/aviutl2/Plugin"
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"
set PLUGIN_DIR "$NV_PREFIX/drive_c/ProgramData/aviutl2/Plugin"

cp -a \
    "$PLUGIN_DIR/lsmash.ini" \
    "$PLUGIN_DIR/lsmash.ini.before-libdav1d-test"

sed -i \
    's/^preferred_decoders=.*/preferred_decoders=libdav1d/' \
    "$PLUGIN_DIR/lsmash.ini"

grep -nE \
    'libavsmash_disabled|libav_disabled|preferred_decoders' \
    "$PLUGIN_DIR/lsmash.ini"

find "$NV_PREFIX/drive_c/AviUtl2" \
    -type f \
    \( -iname '*.lwi' -o -iname '*.lwi2' \) \
    -delete
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 04:30:05 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、L-SMASH Works plugin/config。

#### 関連する固定値

- path: `$HOME/Games/aviutl2`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 04:30:05 +0900`

---
### コマンド 234 — `H130`

#### 目的

ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set PLUGIN_DIR "$NV_PREFIX/drive_c/ProgramData/aviutl2/Plugin"

set BACKUP_DIR "$ROOT/backups/lsmash-ini-"(date +%Y%m%d-%H%M%S)
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"
set PLUGIN_DIR "$NV_PREFIX/drive_c/ProgramData/aviutl2/Plugin"
set BACKUP_DIR "$ROOT/backups/lsmash-ini-"(date +%Y%m%d-%H%M%S)

mkdir -p "$BACKUP_DIR"

for INI in (find "$PLUGIN_DIR" -maxdepth 2 -type f -iname 'lsmash.ini')
mv -v "$INI" "$BACKUP_DIR/"
end

find "$NV_PREFIX/drive_c/AviUtl2" \
    -type f \
    \( -iname '*.lwi' -o -iname '*.lwi2' \) \
    -delete
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 04:32:35 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、L-SMASH Works plugin/config。

#### 関連する固定値

- path: `$HOME/Games/aviutl2`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 04:32:35 +0900`

---
### コマンド 235 — `H131`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set GE_DIR \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINE \
    "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_DIR/files/bin/wineserver"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

set LOG \
    "$ROOT/logs/aviutl2-nvdec-hwframe-patched.log"

WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG='-all,+loaddll,+nvcuda,+nvcuvid'
```

#### 実行コマンド

```fish
set GE_DIR \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINE \
    "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_DIR/files/bin/wineserver"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

set LOG \
    "$ROOT/logs/aviutl2-nvdec-hwframe-patched.log"

env WINEPREFIX="$NV_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1

cd "$NV_PREFIX/drive_c/AviUtl2"

env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG='-all,+loaddll,+nvcuda,+nvcuvid' \
    "$GE_WINE" ./aviutl2.exe \
    &> "$LOG"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 04:32:40 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 04:32:40 +0900`

---
### コマンド 236 — `H132`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_DIR \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINE \
    "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_DIR/files/bin/wineserver"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

set LOG \
    "$ROOT/logs/aviutl2-text-crash-no-ime.log"

WINEPREFIX="$NV_PREFIX"

XMODIFIERS='@im=none'

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG='-all,+seh,+tid,+imm,+dwrite'
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_DIR \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINE \
    "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_DIR/files/bin/wineserver"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

set LOG \
    "$ROOT/logs/aviutl2-text-crash-no-ime.log"

env WINEPREFIX="$NV_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1

cd "$NV_PREFIX/drive_c/AviUtl2"

env \
    XMODIFIERS='@im=none' \
    GTK_IM_MODULE= \
    QT_IM_MODULE= \
    SDL_IM_MODULE= \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG='-all,+seh,+tid,+imm,+dwrite' \
    "$GE_WINE" ./aviutl2.exe \
    &> "$LOG"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 04:35:40 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 04:35:40 +0900`

---
### コマンド 237 — `H133`

#### 目的

必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set WINE_DST "$HOME/Games/aviutl2/src/wine-ge11-1-dwrite"

set WINE_SRC "$HOME/projects/aviutl2-linux/proton-ge-src/wine"

set DST "$WINE_DST/dlls/dwrite/layout.c"

set SRC "$WINE_SRC/dlls/dwrite/layout.c"

set BACKUP "$DST.before-hittest-range-"(date +%Y%m%d-%H%M%S)
```

#### 実行コマンド

```fish
set WINE_DST "$HOME/Games/aviutl2/src/wine-ge11-1-dwrite"
set WINE_SRC "$HOME/projects/aviutl2-linux/proton-ge-src/wine"

set DST "$WINE_DST/dlls/dwrite/layout.c"
set SRC "$WINE_SRC/dlls/dwrite/layout.c"
set BACKUP "$DST.before-hittest-range-"(date +%Y%m%d-%H%M%S)

cp -a "$DST" "$BACKUP"

env SRC="$SRC" DST="$DST" /usr/bin/python -c '
from pathlib import Path
import os
import re

src_path = Path(os.environ["SRC"])
dst_path = Path(os.environ["DST"])

pattern = re.compile(
    r"static HRESULT WINAPI dwritetextlayout_HitTestTextRange\(.*?\n\}\n"
    r"(?=\nstatic HRESULT WINAPI dwritetextlayout1_SetPairKerning)",
    re.DOTALL,
)

src_text = src_path.read_text(encoding="utf-8")
dst_text = dst_path.read_text(encoding="utf-8")

src_match = pattern.search(src_text)
dst_match = pattern.search(dst_text)

if src_match is None:
    raise SystemExit("source HitTestTextRange implementation not found")

if dst_match is None:
    raise SystemExit("destination HitTestTextRange stub not found")

patched = (
    dst_text[:dst_match.start()]
    + src_match.group(0)
    + dst_text[dst_match.end():]
)

dst_path.write_text(patched, encoding="utf-8")
print("HitTestTextRange transplanted successfully")
'
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 04:41:34 +0900`。

#### 生成・変更されたもの

Wine DirectWriteまたはpatched runner。

#### 関連する固定値

- path: `$HOME/Games/aviutl2/src/wine-ge11-1-dwrite`
- path: `$HOME/projects/aviutl2-linux/proton-ge-src/wine`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 04:41:34 +0900`

---
### コマンド 238 — `H134`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_DIR \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINE \
    "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_DIR/files/bin/wineserver"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

set LOG \
    "$ROOT/logs/aviutl2-hittest-range.log"

WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG='-all,+loaddll,+dwrite'
```

#### 実行コマンド

```fish
set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_DIR \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_WINE \
    "$GE_DIR/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_DIR/files/bin/wineserver"

set GE_LIBS \
    "$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix"

set LOG \
    "$ROOT/logs/aviutl2-hittest-range.log"

env WINEPREFIX="$NV_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1

cd "$NV_PREFIX/drive_c/AviUtl2"

env \
    WINEDLLPATH="$WINE_BUILD/dlls/dwrite:$WINE_BUILD/dlls/dwrite/x86_64-windows" \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG='-all,+loaddll,+dwrite' \
    "$GE_WINE" ./aviutl2.exe \
    &> "$LOG"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 04:45:10 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 04:45:10 +0900`

---
### コマンド 239 — `H135`

#### 目的

必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set GE_ORIG \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set WINE_BUILD \
    "$ROOT/build/wine-ge11-1-dwrite"
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"

set GE_ORIG \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set WINE_BUILD \
    "$ROOT/build/wine-ge11-1-dwrite"

if not test -d "$GE_TEST"
cp -a --reflink=auto \
        "$GE_ORIG" \
        "$GE_TEST"
end
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 04:48:30 +0900`。

#### 生成・変更されたもの

Wine DirectWriteまたはpatched runner。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 04:48:30 +0900`

---
### コマンド 240 — `H136`

#### 目的

ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set DWRITE_PE \
    "$WINE_BUILD/dlls/dwrite/x86_64-windows/dwrite.dll"

set DWRITE_SO \
    "$WINE_BUILD/dlls/dwrite/dwrite.so"

set STAMP (date +%Y%m%d-%H%M%S)
```

#### 実行コマンド

```fish
set DWRITE_PE \
    "$WINE_BUILD/dlls/dwrite/x86_64-windows/dwrite.dll"

set DWRITE_SO \
    "$WINE_BUILD/dlls/dwrite/dwrite.so"

set STAMP (date +%Y%m%d-%H%M%S)

for TARGET in (find "$GE_TEST/files" -type f \
        \( \
            -path '*/x86_64-windows/dwrite.dll' \
            -o -path '*/x86_64-unix/dwrite.so' \
        \))

echo "Replacing: $TARGET"

cp -a \
        "$TARGET" \
        "$TARGET.before-hittest-range-$STAMP"

switch (basename "$TARGET")
case dwrite.dll
cp -f "$DWRITE_PE" "$TARGET"

case dwrite.so
cp -f "$DWRITE_SO" "$TARGET"
end
end
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 04:48:35 +0900`。

#### 生成・変更されたもの

Wine DirectWriteまたはpatched runner。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 04:48:35 +0900`

---
### コマンド 241 — `H137`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_WINE \
    "$GE_TEST/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_TEST/files/bin/wineserver"

set GE_LIBS \
    "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"

set LOG \
    "$ROOT/logs/aviutl2-hittest-range-direct.log"

WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG='-all,+loaddll,+dwrite'
```

#### 実行コマンド

```fish
set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_WINE \
    "$GE_TEST/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_TEST/files/bin/wineserver"

set GE_LIBS \
    "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"

set LOG \
    "$ROOT/logs/aviutl2-hittest-range-direct.log"

env WINEPREFIX="$NV_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1

cd "$NV_PREFIX/drive_c/AviUtl2"

env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG='-all,+loaddll,+dwrite' \
    "$GE_WINE" ./aviutl2.exe \
    &> "$LOG"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 04:48:45 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 04:48:45 +0900`

---
### コマンド 242 — `H138`

#### 目的

ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set PLUGIN_DIR "$NV_PREFIX/drive_c/ProgramData/aviutl2/Plugin"
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"
set PLUGIN_DIR "$NV_PREFIX/drive_c/ProgramData/aviutl2/Plugin"

find "$PLUGIN_DIR" \
    -maxdepth 2 \
    -type f \
    -iname 'lsmash.ini' \
    -print
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-31 04:50:57 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、L-SMASH Works plugin/config。

#### 関連する固定値

- path: `$HOME/Games/aviutl2`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 04:50:57 +0900`

---
### コマンド 243 — `H139`

#### 目的

ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set INI "$NV_PREFIX/drive_c/ProgramData/aviutl2/Plugin/lsmash.ini"
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"
set INI "$NV_PREFIX/drive_c/ProgramData/aviutl2/Plugin/lsmash.ini"

sed -i \
    -e 's/^libavsmash_disabled=.*/libavsmash_disabled=1/' \
    -e 's/^libav_disabled=.*/libav_disabled=0/' \
    -e 's/^preferred_decoders=.*/preferred_decoders=av1_cuvid/' \
    "$INI"

grep -nE \
    'libavsmash_disabled|libav_disabled|preferred_decoders' \
    "$INI"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 04:51:50 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、L-SMASH Works plugin/config。

#### 関連する固定値

- path: `$HOME/Games/aviutl2`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 04:51:50 +0900`

---
### コマンド 244 — `H140`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set GE_WINE \
    "$GE_TEST/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_TEST/files/bin/wineserver"

set GE_LIBS \
    "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"

WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG=-all
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set GE_WINE \
    "$GE_TEST/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_TEST/files/bin/wineserver"

set GE_LIBS \
    "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"

env WINEPREFIX="$NV_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1

cd "$NV_PREFIX/drive_c/AviUtl2"

env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG=-all \
    "$GE_WINE" ./aviutl2.exe
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 04:52:33 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 04:52:33 +0900`

---
### コマンド 245 — `H141`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set GE_WINE \
    "$GE_TEST/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_TEST/files/bin/wineserver"

set GE_LIBS \
    "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"

set LOG \
    "$ROOT/logs/aviutl2-text-retest.log"

WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG='-all,+seh,+loaddll,+dwrite'
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set GE_WINE \
    "$GE_TEST/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_TEST/files/bin/wineserver"

set GE_LIBS \
    "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"

set LOG \
    "$ROOT/logs/aviutl2-text-retest.log"

env WINEPREFIX="$NV_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1

cd "$NV_PREFIX/drive_c/AviUtl2"

env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG='-all,+seh,+loaddll,+dwrite' \
    "$GE_WINE" ./aviutl2.exe \
    &> "$LOG"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 04:55:02 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 04:55:02 +0900`

---
### コマンド 246 — `H142`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set GE_WINE \
    "$GE_TEST/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_TEST/files/bin/wineserver"

set GE_LIBS \
    "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"

set LOG \
    "$ROOT/logs/aviutl2-text-no-ime-patched.log"

WINEPREFIX="$NV_PREFIX"

XMODIFIERS='@im=none'

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG='-all,+seh,+imm,+msctf'
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set GE_WINE \
    "$GE_TEST/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_TEST/files/bin/wineserver"

set GE_LIBS \
    "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"

set LOG \
    "$ROOT/logs/aviutl2-text-no-ime-patched.log"

env WINEPREFIX="$NV_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1

cd "$NV_PREFIX/drive_c/AviUtl2"

env \
    XMODIFIERS='@im=none' \
    GTK_IM_MODULE= \
    QT_IM_MODULE= \
    SDL_IM_MODULE= \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG='-all,+seh,+imm,+msctf' \
    "$GE_WINE" ./aviutl2.exe \
    &> "$LOG"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 04:59:04 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 04:59:04 +0900`

---
### コマンド 247 — `H143`

#### 目的

AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
XMODIFIERS='@im=none'

WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG=-all
```

#### 実行コマンド

```fish
env \
    XMODIFIERS='@im=none' \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG=-all \
    "$GE_WINE" ./aviutl2.exe
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 05:00:36 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 05:00:36 +0900`

---
### コマンド 248 — `H144`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set GE_WINE \
    "$GE_TEST/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_TEST/files/bin/wineserver"

set GE_LIBS \
    "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"

set LOG "$ROOT/logs/notepad-ime-test.log"

XMODIFIERS=%s

WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDEBUG='-all,+xim,+imm,+msctf,+seh'
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set GE_WINE \
    "$GE_TEST/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_TEST/files/bin/wineserver"

set GE_LIBS \
    "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"

set LOG "$ROOT/logs/notepad-ime-test.log"

printf 'XMODIFIERS=%s\n' (printenv XMODIFIERS)

env WINEPREFIX="$NV_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1

env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDEBUG='-all,+xim,+imm,+msctf,+seh' \
    "$GE_WINE" notepad.exe \
    &> "$LOG"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 05:04:21 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、ログファイル。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 05:04:21 +0900`

---
### コマンド 249 — `H145`

#### 目的

WineレジストリへDLL override、フォント、IMEなどの設定を登録する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set JP_FONT 'Noto Sans CJK JP'

WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"
```

#### 実行コマンド

```fish
set JP_FONT 'Noto Sans CJK JP'

env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" reg add \
    'HKCU\Software\Wine\Fonts\Replacements' \
    /v 'MS UI Gothic' /t REG_SZ /d "$JP_FONT" /f

env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" reg add \
    'HKCU\Software\Wine\Fonts\Replacements' \
    /v 'MS Gothic' /t REG_SZ /d "$JP_FONT" /f

env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" reg add \
    'HKCU\Software\Wine\Fonts\Replacements' \
    /v 'Segoe UI' /t REG_SZ /d "$JP_FONT" /f

env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" reg add \
    'HKCU\Software\Wine\Fonts\Replacements' \
    /v 'Tahoma' /t REG_SZ /d "$JP_FONT" /f
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 05:05:53 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、WineフォントファイルまたはFont registry。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 05:05:53 +0900`

---
### コマンド 250 — `H146`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$NV_PREFIX"
```

#### 実行コマンド

```fish
env WINEPREFIX="$NV_PREFIX" "$GE_WINESERVER" -k
sleep 1
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 05:06:01 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 05:06:01 +0900`

---
### コマンド 251 — `H147`

#### 目的

ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set GE_WINE \
    "$GE_TEST/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_TEST/files/bin/wineserver"

set GE_LIBS \
    "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"

set LOG \
    "$ROOT/logs/aviutl2-ime-crash.log"

XMODIFIERS=%s

WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG='-all,+timestamp,+pid,+tid,+xim,+imm,+msctf,+seh'
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set GE_WINE \
    "$GE_TEST/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_TEST/files/bin/wineserver"

set GE_LIBS \
    "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"

set LOG \
    "$ROOT/logs/aviutl2-ime-crash.log"

printf 'XMODIFIERS=%s\n' (printenv XMODIFIERS)
pgrep -a -f 'fcitx5|mozc'

env WINEPREFIX="$NV_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1

cd "$NV_PREFIX/drive_c/AviUtl2"

env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG='-all,+timestamp,+pid,+tid,+xim,+imm,+msctf,+seh' \
    "$GE_WINE" ./aviutl2.exe \
    &> "$LOG"
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-31 05:06:53 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 05:06:53 +0900`

---
### コマンド 252 — `H148`

#### 目的

WineレジストリへDLL override、フォント、IMEなどの設定を登録する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set GE_WINE \
    "$GE_TEST/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_TEST/files/bin/wineserver"

set GE_LIBS \
    "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"

WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set GE_WINE \
    "$GE_TEST/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_TEST/files/bin/wineserver"

set GE_LIBS \
    "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"

env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" reg add \
    'HKCU\Software\Wine\AppDefaults\aviutl2.exe\X11 Driver' \
    /v InputStyle \
    /t REG_SZ \
    /d overthespot \
    /f
```

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(223).txt timestamp 2026-07-31 05:10:46 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 05:10:46 +0900`

---
### コマンド 253 — `H149`

#### 目的

Wineレジストリの設定値を確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"
```

#### 実行コマンド

```fish
env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" reg query \
    'HKCU\Software\Wine\AppDefaults\aviutl2.exe\X11 Driver' \
    /v InputStyle
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-31 05:11:00 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 05:11:00 +0900`

---
### コマンド 254 — `H150`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG='-all,+xim,+imm'
```

#### 実行コマンド

```fish
env WINEPREFIX="$NV_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1

cd "$NV_PREFIX/drive_c/AviUtl2"

env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG='-all,+xim,+imm' \
    "$GE_WINE" ./aviutl2.exe \
    &> "$ROOT/logs/aviutl2-ime-overthespot.log"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 05:11:04 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 05:11:04 +0900`

---
### コマンド 255 — `H151`

#### 目的

ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set GE_WINE \
    "$GE_TEST/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_TEST/files/bin/wineserver"

set GE_LIBS \
    "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set GE_WINE \
    "$GE_TEST/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_TEST/files/bin/wineserver"

set GE_LIBS \
    "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"

find "$GE_TEST/files" \
    -type f \
    \( \
        -iname 'winewayland.drv' \
        -o -iname 'winewayland.so' \
    \) \
    -print
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-31 05:16:51 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 05:16:51 +0900`

---
### コマンド 256 — `H152`

#### 目的

WineレジストリへDLL override、フォント、IMEなどの設定を登録する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"
```

#### 実行コマンド

```fish
env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" reg add \
    'HKCU\Software\Wine\Drivers' \
    /v Graphics \
    /t REG_SZ \
    /d 'x11,wayland' \
    /f
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 05:17:02 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 05:17:02 +0900`

---
### コマンド 257 — `H153`

#### 目的

Wineレジストリの設定値を確認する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"
```

#### 実行コマンド

```fish
env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" reg query \
    'HKCU\Software\Wine\Drivers' \
    /v Graphics
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-31 05:17:07 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 05:17:07 +0900`

---
### コマンド 258 — `H154`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set LOG \
    "$ROOT/logs/aviutl2-native-wayland-ime.log"

WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG='-all,+loaddll,+imm,+seh'
```

#### 実行コマンド

```fish
set LOG \
    "$ROOT/logs/aviutl2-native-wayland-ime.log"

env WINEPREFIX="$NV_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1

cd "$NV_PREFIX/drive_c/AviUtl2"

env -u DISPLAY \
    WAYLAND_DISPLAY="$WAYLAND_DISPLAY" \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG='-all,+loaddll,+imm,+seh' \
    "$GE_WINE" ./aviutl2.exe \
    &> "$LOG"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 05:20:07 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 05:20:07 +0900`

---
### コマンド 259 — `H155`

#### 目的

バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set DLL_SRC \
    "$BUILD/dlls/dwrite/x86_64-windows/dwrite.dll"

set SO_SRC \
    "$BUILD/dlls/dwrite/dwrite.so"

set DLL_DST \
    "$GE_TEST/files/lib/wine/x86_64-windows/dwrite.dll"

set SO_DST \
    "$GE_TEST/files/lib/wine/x86_64-unix/dwrite.so"
```

#### 実行コマンド

```fish
set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set DLL_SRC \
    "$BUILD/dlls/dwrite/x86_64-windows/dwrite.dll"

set SO_SRC \
    "$BUILD/dlls/dwrite/dwrite.so"

set DLL_DST \
    "$GE_TEST/files/lib/wine/x86_64-windows/dwrite.dll"

set SO_DST \
    "$GE_TEST/files/lib/wine/x86_64-unix/dwrite.so"

cp "$DLL_DST" "$DLL_DST.before-hittest-point-$TS"
cp "$SO_DST" "$SO_DST.before-hittest-point-$TS"

cp "$DLL_SRC" "$DLL_DST"
cp "$SO_SRC" "$SO_DST"

sha256sum \
    "$DLL_SRC" "$DLL_DST" \
    "$SO_SRC" "$SO_DST"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 05:23:27 +0900`。

#### 生成・変更されたもの

Wine DirectWriteまたはpatched runner。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 05:23:27 +0900`

---
### コマンド 260 — `H156`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_WINE "$GE_TEST/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER "$GE_TEST/files/bin/wineserver"

set GE_LIBS \
    "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"

set LOG "$ROOT/logs/aviutl2-hittest-point-test.log"

WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG='-all,+dwrite,+seh'
```

#### 実行コマンド

```fish
set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"
set GE_WINE "$GE_TEST/files/lib/wine/x86_64-unix/wine"
set GE_WINESERVER "$GE_TEST/files/bin/wineserver"

set GE_LIBS \
    "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"

set LOG "$ROOT/logs/aviutl2-hittest-point-test.log"

env WINEPREFIX="$NV_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1
cd "$NV_PREFIX/drive_c/AviUtl2"

env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG='-all,+dwrite,+seh' \
    "$GE_WINE" ./aviutl2.exe \
    &> "$LOG"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 05:23:32 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 05:23:32 +0900`

---
### コマンド 261 — `H157`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_TEST "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set GE_WINE "$GE_TEST/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER "$GE_TEST/files/bin/wineserver"

set GE_LIBS "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"

set LOG "$ROOT/logs/aviutl2-hittest-point-retest.log"

WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG='-all,+loaddll,+dwrite,+seh'
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"
set GE_TEST "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"
set GE_WINE "$GE_TEST/files/lib/wine/x86_64-unix/wine"
set GE_WINESERVER "$GE_TEST/files/bin/wineserver"
set GE_LIBS "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"
set LOG "$ROOT/logs/aviutl2-hittest-point-retest.log"

env WINEPREFIX="$NV_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1

cd "$NV_PREFIX/drive_c/AviUtl2"

env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG='-all,+loaddll,+dwrite,+seh' \
    "$GE_WINE" ./aviutl2.exe \
    &> "$LOG"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 05:31:43 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 05:31:43 +0900`

---
### コマンド 262 — `H158`

#### 目的

バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set DLL_SRC \
    "$BUILD/dlls/dwrite/x86_64-windows/dwrite.dll"

set SO_SRC \
    "$BUILD/dlls/dwrite/dwrite.so"

set DLL_DST \
    "$GE_TEST/files/lib/wine/x86_64-windows/dwrite.dll"

set SO_DST \
    "$GE_TEST/files/lib/wine/x86_64-unix/dwrite.so"

set TS (date +%Y%m%d-%H%M%S)
```

#### 実行コマンド

```fish
set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set DLL_SRC \
    "$BUILD/dlls/dwrite/x86_64-windows/dwrite.dll"

set SO_SRC \
    "$BUILD/dlls/dwrite/dwrite.so"

set DLL_DST \
    "$GE_TEST/files/lib/wine/x86_64-windows/dwrite.dll"

set SO_DST \
    "$GE_TEST/files/lib/wine/x86_64-unix/dwrite.so"

set TS (date +%Y%m%d-%H%M%S)

cp "$DLL_DST" "$DLL_DST.before-real-hittest-point-$TS"
cp "$SO_DST" "$SO_DST.before-real-hittest-point-$TS"

cp "$DLL_SRC" "$DLL_DST"
cp "$SO_SRC" "$SO_DST"

sha256sum \
    "$DLL_SRC" "$DLL_DST" \
    "$SO_SRC" "$SO_DST"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 05:34:22 +0900`。

#### 生成・変更されたもの

Wine DirectWriteまたはpatched runner。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 05:34:22 +0900`

---
### コマンド 263 — `H159`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_WINE "$GE_TEST/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER "$GE_TEST/files/bin/wineserver"

set GE_LIBS \
    "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"

set LOG "$ROOT/logs/aviutl2-hittest-point-real-build.log"

WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG='-all,+dwrite,+seh'
```

#### 実行コマンド

```fish
set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"
set GE_WINE "$GE_TEST/files/lib/wine/x86_64-unix/wine"
set GE_WINESERVER "$GE_TEST/files/bin/wineserver"

set GE_LIBS \
    "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"

set LOG "$ROOT/logs/aviutl2-hittest-point-real-build.log"

env WINEPREFIX="$NV_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1
cd "$NV_PREFIX/drive_c/AviUtl2"

env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG='-all,+dwrite,+seh' \
    "$GE_WINE" ./aviutl2.exe \
    &> "$LOG"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 05:34:25 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 05:34:25 +0900`

---
### コマンド 264 — `H160`

#### 目的

バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set DLL_SRC \
    "$BUILD/dlls/dwrite/x86_64-windows/dwrite.dll"

set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set DLL_DST \
    "$GE_TEST/files/lib/wine/x86_64-windows/dwrite.dll"

set TS (date +%Y%m%d-%H%M%S)
```

#### 実行コマンド

```fish
set DLL_SRC \
    "$BUILD/dlls/dwrite/x86_64-windows/dwrite.dll"

set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set DLL_DST \
    "$GE_TEST/files/lib/wine/x86_64-windows/dwrite.dll"

stat "$DLL_SRC"

set TS (date +%Y%m%d-%H%M%S)
cp "$DLL_DST" "$DLL_DST.before-hittest-point-$TS"
cp "$DLL_SRC" "$DLL_DST"

sha256sum "$DLL_SRC" "$DLL_DST"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 05:36:21 +0900`。

#### 生成・変更されたもの

Wine DirectWriteまたはpatched runner。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 05:36:21 +0900`

---
### コマンド 265 — `H161`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_WINE "$GE_TEST/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER "$GE_TEST/files/bin/wineserver"

set GE_LIBS \
    "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"

set LOG "$ROOT/logs/aviutl2-hittest-point-forced.log"

WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG='-all,+dwrite,+seh'
```

#### 実行コマンド

```fish
set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"
set GE_WINE "$GE_TEST/files/lib/wine/x86_64-unix/wine"
set GE_WINESERVER "$GE_TEST/files/bin/wineserver"

set GE_LIBS \
    "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"

set LOG "$ROOT/logs/aviutl2-hittest-point-forced.log"

env WINEPREFIX="$NV_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1
cd "$NV_PREFIX/drive_c/AviUtl2"

env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG='-all,+dwrite,+seh' \
    "$GE_WINE" ./aviutl2.exe \
    &> "$LOG"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 05:36:25 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 05:36:25 +0900`

---
### コマンド 266 — `H162`

#### 目的

バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set DLL_DST \
    "$GE_TEST/files/lib/wine/x86_64-windows/dwrite.dll"

set TS (date +%Y%m%d-%H%M%S)
```

#### 実行コマンド

```fish
set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set DLL_DST \
    "$GE_TEST/files/lib/wine/x86_64-windows/dwrite.dll"

set TS (date +%Y%m%d-%H%M%S)

cp "$DLL_DST" "$DLL_DST.before-portable-hittest-point-$TS"
cp "$DLL_SRC" "$DLL_DST"

sha256sum "$DLL_SRC" "$DLL_DST"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 05:42:50 +0900`。

#### 生成・変更されたもの

Wine DirectWriteまたはpatched runner。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 05:42:50 +0900`

---
### コマンド 267 — `H163`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"

set GE_WINE "$GE_TEST/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER "$GE_TEST/files/bin/wineserver"

set GE_LIBS \
    "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"

set LOG "$ROOT/logs/aviutl2-hittest-point-portable.log"

WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG='-all,+dwrite,+seh'
```

#### 実行コマンド

```fish
set NV_PREFIX "$ROOT/prefix-ge-nvdec-test"
set GE_WINE "$GE_TEST/files/lib/wine/x86_64-unix/wine"
set GE_WINESERVER "$GE_TEST/files/bin/wineserver"

set GE_LIBS \
    "$GE_TEST/files/lib64:$GE_TEST/files/lib:$GE_TEST/files/lib/wine/x86_64-unix:$GE_TEST/files/lib/wine/i386-unix"

set LOG "$ROOT/logs/aviutl2-hittest-point-portable.log"

env WINEPREFIX="$NV_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1
cd "$NV_PREFIX/drive_c/AviUtl2"

env \
    WINEPREFIX="$NV_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG='-all,+dwrite,+seh' \
    "$GE_WINE" ./aviutl2.exe \
    &> "$LOG"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 05:42:54 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 05:42:54 +0900`

---
### コマンド 268 — `H164`

#### 目的

バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set REPOS

set repo (dirname "$gitdir")

set -a REPOS "$repo"
```

#### 実行コマンド

```fish
set REPOS

for root in \
    "$HOME/Games/aviutl2/src" \
    "$HOME/projects/aviutl2-linux/proton-ge-src"

if not test -d "$root"
continue
end

for gitdir in (find "$root" -type d -name .git -prune 2>/dev/null)
set repo (dirname "$gitdir")

if not contains -- "$repo" $REPOS
set -a REPOS "$repo"
end
end
end

for repo in $REPOS
echo
echo "============================================================"
echo "$repo"
echo "============================================================"

git -C "$repo" remote -v | head -n 4
git -C "$repo" status --short --branch

echo
echo "-- latest commit --"
git -C "$repo" log -1 --oneline

echo
echo "-- unstaged diff stat --"
git -C "$repo" diff --stat

echo
echo "-- staged diff stat --"
git -C "$repo" diff --cached --stat
end

echo
echo "============================================================"
echo "Standalone files"
echo "============================================================"

for file in \
    "$HOME/Games/aviutl2/nvidia-dxvk.conf" \
    "$HOME/Games/aviutl2/prefix-ge-nvdec-test/drive_c/ProgramData/aviutl2/Plugin/lsmash.ini"

if test -f "$file"
stat -c '%y  %s bytes  %n' "$file"
end
end
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(223).txt timestamp 2026-07-31 05:48:01 +0900` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、L-SMASH Works plugin/config、Git working tree、commit、remoteまたはGitHub repository、ログファイル。

#### 関連する固定値

- path: `$HOME/Games/aviutl2/src`
- path: `$HOME/projects/aviutl2-linux/proton-ge-src`
- path: `$HOME/Games/aviutl2/nvidia-dxvk.conf`
- path: `$HOME/Games/aviutl2/prefix-ge-nvdec-test/drive_c/ProgramData/aviutl2/Plugin/lsmash.ini`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 05:48:01 +0900`

---
### コマンド 269 — `H165`

#### 目的

必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set OUT "$HOME/projects/aviutl2-linux-patches"

set DXVK "$ROOT/src/dxvk-2.7.1-aviutl2"

set LSMASH "$ROOT/src/L-SMASH-Works-nvdec"

set WINE "$ROOT/src/wine-ge11-1-dwrite"
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set OUT "$HOME/projects/aviutl2-linux-patches"

set DXVK "$ROOT/src/dxvk-2.7.1-aviutl2"
set LSMASH "$ROOT/src/L-SMASH-Works-nvdec"
set WINE "$ROOT/src/wine-ge11-1-dwrite"

rm -rf "$OUT"

mkdir -p \
    "$OUT/patches/dxvk" \
    "$OUT/patches/l-smash-works" \
    "$OUT/patches/wine" \
    "$OUT/config" \
    "$OUT/scripts" \
    "$OUT/docs" \
    "$OUT/LICENSES"

git -C "$DXVK" diff \
    --binary \
    -- src/d3d11/d3d11_device.cpp \
    > "$OUT/patches/dxvk/0001-aviutl2-format-support.patch"

git -C "$LSMASH" format-patch \
    -1 \
    --stdout \
    393df5e \
    > "$OUT/patches/l-smash-works/0001-transfer-hardware-frames-before-output.patch"

git -C "$WINE" diff \
    --binary \
    -- dlls/dwrite/layout.c \
    > "$OUT/patches/wine/0001-implement-dwrite-hit-testing.patch"

cp \
    "$ROOT/nvidia-dxvk.conf" \
    "$OUT/config/nvidia-dxvk.conf"

cp \
    "$ROOT/prefix-ge-nvdec-test/drive_c/ProgramData/aviutl2/Plugin/lsmash.ini" \
    "$OUT/config/lsmash.ini"

for patch in \
    "$OUT/patches/dxvk/0001-aviutl2-format-support.patch" \
    "$OUT/patches/l-smash-works/0001-transfer-hardware-frames-before-output.patch" \
    "$OUT/patches/wine/0001-implement-dwrite-hit-testing.patch"

if test -s "$patch"
echo "OK: "(wc -c < "$patch")" bytes  $patch"
else
echo "ERROR: empty patch  $patch"
end
end
```

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(223).txt timestamp 2026-07-31 05:51:14 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、L-SMASH Works plugin/config、Git working tree、commit、remoteまたはGitHub repository。

#### 関連する固定値

- 短縮commit: `393df5e`
- version: `2.7.1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/projects/aviutl2-linux-patches`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。

#### 採用可否

```text
内容を修正してからREPRODUCTION.mdへ採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 05:51:14 +0900`

---
### コマンド 270 — `H166`

#### 目的

対象ソースまたは依存ライブラリをビルド・インストールする。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set OUT "$HOME/projects/aviutl2-linux-patches"

set DXVK "$ROOT/src/dxvk-2.7.1-aviutl2"

set LSMASH "$ROOT/src/L-SMASH-Works-nvdec"

set WINE "$ROOT/src/wine-ge11-1-dwrite"

set WINE_BASE (find \
    "$WINE/dlls/dwrite" \
    -maxdepth 1 \
    -type f \
    -name "layout.c.before-hittest-range-*" \
    | sort \
    | head -n 1)

set WINE_BUILD "/path/to/wine-build"

    set WINE_BUILD "$argv[1]"

    set GE_ROOT "$argv[2]"

    set DLL_SRC \
        "$WINE_BUILD/dlls/dwrite/x86_64-windows/dwrite.dll"

    set DLL_DST \
        "$GE_ROOT/files/lib/wine/x86_64-windows/dwrite.dll"

        set TS (date +%Y%m%d-%H%M%S)

        set BACKUP "$DLL_DST.backup-$TS"

    set AVIUTL2_ROOT "$HOME/Games/aviutl2"

    set AVIUTL2_PREFIX "$AVIUTL2_ROOT/prefix-ge-nvdec-test"

    set GE_PROTON_ROOT \
        "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set GE_WINE \
    "$GE_PROTON_ROOT/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_PROTON_ROOT/files/bin/wineserver"

set GE_LIBS \
    "$GE_PROTON_ROOT/files/lib64:$GE_PROTON_ROOT/files/lib:$GE_PROTON_ROOT/files/lib/wine/x86_64-unix:$GE_PROTON_ROOT/files/lib/wine/i386-unix"

set AVIUTL2_DIR \
    "$AVIUTL2_PREFIX/drive_c/AviUtl2"

WINEDEBUG="-all,+dwrite,+seh"

WINEPREFIX="$AVIUTL2_PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES="nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b"

DXVK_CONFIG_FILE="$AVIUTL2_ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG=-all
```

#### 実行コマンド

```fish
set ROOT "$HOME/Games/aviutl2"
set OUT "$HOME/projects/aviutl2-linux-patches"

set DXVK "$ROOT/src/dxvk-2.7.1-aviutl2"
set LSMASH "$ROOT/src/L-SMASH-Works-nvdec"
set WINE "$ROOT/src/wine-ge11-1-dwrite"

set WINE_BASE (find \
    "$WINE/dlls/dwrite" \
    -maxdepth 1 \
    -type f \
    -name "layout.c.before-hittest-range-*" \
    | sort \
    | head -n 1)

python -c '
from pathlib import Path
import hashlib
import shutil
import subprocess

home = Path.home()
root = home / "Games/aviutl2"
out = home / "projects/aviutl2-linux-patches"

dxvk = root / "src/dxvk-2.7.1-aviutl2"
lsmash = root / "src/L-SMASH-Works-nvdec"
wine = root / "src/wine-ge11-1-dwrite"

wine_bases = sorted(
    (wine / "dlls/dwrite").glob("layout.c.before-hittest-range-*")
)

if not wine_bases:
    raise RuntimeError("Wine baseline backup was not found")

wine_base = wine_bases[0]
wine_current = wine / "dlls/dwrite/layout.c"

def git(repo, *args):
    return subprocess.check_output(
        ["git", "-C", str(repo), *args],
        text=True,
    ).strip()

def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

dxvk_base = git(dxvk, "rev-parse", "HEAD")
lsmash_base = git(lsmash, "rev-parse", "HEAD^")
lsmash_commit = git(lsmash, "rev-parse", "HEAD")

wine_base_sha = sha256(wine_base)
wine_patched_sha = sha256(wine_current)

readme = f"""# AviUtl2 Linux Compatibility Patches

Compatibility patches and configuration examples for running AviUtl2 under
Wine or GE-Proton on Linux.

This repository contains patches, documentation, configuration examples, and
helper scripts. It does not distribute AviUtl2, Wine, GE-Proton, DXVK,
L-SMASH Works, FFmpeg, or NVIDIA binaries.

## Included work

### Wine DirectWrite

File:

```text
patches/wine/0001-implement-dwrite-hit-testing.patch
```

Implements DirectWrite hit-testing functions required by the AviUtl2 text
editor:

- `IDWriteTextLayout::HitTestTextRange()`
- `IDWriteTextLayout::HitTestPoint()`

The original Wine implementation returned `E_NOTIMPL`. AviUtl2 treats these
failures as fatal errors when drawing a selection or entering text-editing
mode.

### DXVK

File:

```text
patches/dxvk/0001-aviutl2-format-support.patch
```

Adjusts the D3D11 format-support path used by AviUtl2. This prevents the
application from failing while checking support for DXGI format ID 69.

### L-SMASH Works

File:

```text
patches/l-smash-works/0001-transfer-hardware-frames-before-output.patch
```

Transfers FFmpeg hardware frames through `av_hwframe_transfer_data()` before
passing them to the existing video-output path.

This enabled the tested AV1 NVDEC import, playback, and seeking workflow.

## Verified environment

- CachyOS
- NVIDIA GeForce RTX 4060 Ti 8 GB
- NVIDIA driver 610.43.3
- GE-Proton 11-1
- Wine-staging 11.0
- DXVK 2.7.1
- AviUtl2
- L-SMASH Works with FFmpeg NVDEC
- Fcitx5 and Mozc
- X11 Wine driver
- Native Wine Wayland driver used during diagnosis

## Verified results

- AviUtl2 starts under the patched GE-Proton installation
- AV1 files import successfully
- AV1 playback works
- Seeking works
- NVIDIA NVDEC hardware frames reach the AviUtl2 video-output path
- DirectWrite text-range hit testing no longer returns `E_NOTIMPL`
- DirectWrite point hit testing no longer returns `E_NOTIMPL`
- AviUtl2 can enter its text-editing state with the host IME enabled

Full behavior should be tested again when changing Wine, GE-Proton, DXVK,
GPU driver, desktop environment, or input method.

## Patch bases

| Component | Base |
| --- | --- |
| DXVK | `{dxvk_base}` |
| L-SMASH Works base | `{lsmash_base}` |
| L-SMASH Works patched commit | `{lsmash_commit}` |
| Wine baseline file | `{wine_base.name}` |
| Wine baseline SHA-256 | `{wine_base_sha}` |
| Wine patched SHA-256 | `{wine_patched_sha}` |

## Applying the patches

### DXVK

```fish
git -C /path/to/dxvk apply \
    patches/dxvk/0001-aviutl2-format-support.patch
```

### L-SMASH Works

```fish
git -C /path/to/L-SMASH-Works am \
    patches/l-smash-works/0001-transfer-hardware-frames-before-output.patch
```

### Wine

The Wine source tree does not need to be a Git repository.

```fish
cd /path/to/wine-source

patch -p1 < \
    /path/to/aviutl2-linux-patches/patches/wine/0001-implement-dwrite-hit-testing.patch
```

## Rebuilding DirectWrite

For the tested Wine build tree:

```fish
set WINE_BUILD "/path/to/wine-build"

rm -f \
    "$WINE_BUILD/dlls/dwrite/x86_64-windows/layout.o" \
    "$WINE_BUILD/dlls/dwrite/x86_64-windows/dwrite.dll"

make -C "$WINE_BUILD" \
    -j(nproc) \
    dlls/dwrite/x86_64-windows/dwrite.dll
```

Do not use `make -B` unless the entire Wine configure environment is complete.
It can force `configure` to run again and fail on unrelated dependencies.

## Installing the patched DWrite DLL

```fish
scripts/install-dwrite.fish \
    /path/to/wine-build \
    /path/to/GE-Proton11-1
```

The script modifies only the selected GE-Proton installation and creates a
timestamped backup first.

## Configuration examples

- `config/nvidia-dxvk.conf`
- `config/lsmash.ini`
- `scripts/launch-aviutl2.example.fish`

## Documentation

- `docs/STATUS.md`
- `docs/TECHNICAL-NOTES.md`
- `docs/TROUBLESHOOTING.md`

## Licensing

Patch files are derivative works of their respective upstream projects and
remain subject to the corresponding upstream licenses.

Original helper scripts and documentation in this repository are available
under the MIT License.

See `NOTICE.md` and `LICENSES/`.
"""

status = """# Current Status

Validated on 2026-07-31.

## Working

- AviUtl2 startup under GE-Proton
- Patched DXVK D3D11 format probing
- AV1 import
- AV1 playback
- Seeking
- NVIDIA NVDEC hardware-frame transfer
- DirectWrite `HitTestTextRange()`
- DirectWrite `HitTestPoint()`
- Entry into the AviUtl2 text-editing state with IME enabled

## Not yet generalized

- AMD GPU decoding
- Intel GPU decoding
- Other Wine and GE-Proton releases
- Other DXVK versions
- Every video codec and pixel format
- Every desktop environment
- Every input method
- Complete native Windows behavior parity

## Important distinction

Disabling XIM prevented the original crash, but XIM itself was not the root
cause.

Both X11 and native Wayland reached the same AviUtl2 failure. The actual cause
was AviUtl2 receiving `E_NOTIMPL` from Wine DirectWrite hit-testing methods.
"""

technical_notes = """# Technical Notes

## Problem sequence

### D3D11 startup failure

AviUtl2 queried D3D11 format support for DXGI format ID 69. The original DXVK
behavior caused AviUtl2 to terminate during startup.

The DXVK patch adjusts this format-support path.

### Hardware-decoded AV1 frames

FFmpeg returned hardware-backed frames from the NVDEC decoder. The existing
L-SMASH Works output path expected software-accessible frame data.

The patch calls `av_hwframe_transfer_data()` before the output path consumes
the frame.

### Text selection failure

AviUtl2 called:

```text
IDWriteTextLayout::HitTestTextRange()
```

Wine returned:

```text
HRESULT 0x80004001
E_NOTIMPL
```

AviUtl2 reported the failure from its selection drawing path.

### Text-editing failure

After implementing `HitTestTextRange()`, AviUtl2 still failed when entering
text-editing mode.

The next missing call was:

```text
IDWriteTextLayout::HitTestPoint()
```

Wine again returned `E_NOTIMPL`, and AviUtl2 threw a C++ exception.

The final implementation uses the working `HitTestTextPosition()` path to
inspect text metrics and select the nearest cluster.

## IME investigation

The issue was tested with:

- Fcitx5 and Mozc through Wine XIM
- XIM disabled
- XIM `overthespot`
- Wine native Wayland text input

Disabling XIM hid the error because AviUtl2 did not execute the same editing
path. Native Wayland still produced the same DirectWrite failure, proving that
XIM was not the root cause.

## Build investigation

Several stale-build traps were identified:

1. `make dlls/dwrite` treated the existing directory as an already satisfied
   target.
2. `make -B` forced Wine configure to run again.
3. Configure then failed on an unrelated FreeType dependency.
4. An old `dwrite.dll` was copied after the failed build.
5. Runtime logging still showed `HitTestPoint(): stub`.

The reliable rebuild procedure removes the specific PE object and DLL, then
builds the exact DLL target.
"""

troubleshooting = """# Troubleshooting

## Runtime still reports `HitTestPoint(): stub`

The new source was not included in the DLL.

Check:

```fish
grep -n "dwritetextlayout_HitTestPoint" \
    /path/to/wine-source/dlls/dwrite/layout.c
```

Remove the old object and DLL:

```fish
rm -f \
    /path/to/wine-build/dlls/dwrite/x86_64-windows/layout.o \
    /path/to/wine-build/dlls/dwrite/x86_64-windows/dwrite.dll
```

Build the exact target:

```fish
make -C /path/to/wine-build \
    -j(nproc) \
    dlls/dwrite/x86_64-windows/dwrite.dll
```

## `make dlls/dwrite` does nothing

`dlls/dwrite` is also an existing directory, so Make may consider that target
complete. Use the full DLL target instead.

## Configure runs unexpectedly

Avoid `make -B`. It may force Wine configure to run again.

## Patch file is empty

The tested Wine source directory was not itself a Git repository. Generate the
patch with `diff -u` against a known baseline file, or place the source under
version control first.

## Confirming the loaded implementation

Launch with:

```fish
WINEDEBUG="-all,+dwrite,+seh"
```

A working implementation logs:

```text
trace:dwrite:dwritetextlayout_HitTestPoint
```

A stale DLL logs:

```text
fixme:dwrite:dwritetextlayout_HitTestPoint ... stub
```
"""

notice = """# Notices

The files under `patches/` modify code from upstream open-source projects and
remain governed by the corresponding upstream licenses.

- Wine patch: Wine upstream license
- DXVK patch: DXVK upstream license
- L-SMASH Works patch: L-SMASH Works upstream license

The MIT License at the repository root covers original documentation and
helper scripts authored for this repository.

AviUtl2 itself is not included.
"""

mit = """MIT License

Copyright (c) 2026 AlexanderGG

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files, to deal in the Software
without restriction, including without limitation the rights to use, copy,
modify, merge, publish, distribute, sublicense, and sell copies of the
Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT, OR OTHERWISE, ARISING FROM,
OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
"""

install_dwrite = """#!/usr/bin/env fish

if test (count $argv) -ne 2
    echo "Usage: install-dwrite.fish WINE_BUILD GE_PROTON_ROOT"
else
    set WINE_BUILD "$argv[1]"
    set GE_ROOT "$argv[2]"

    set DLL_SRC \
        "$WINE_BUILD/dlls/dwrite/x86_64-windows/dwrite.dll"

    set DLL_DST \
        "$GE_ROOT/files/lib/wine/x86_64-windows/dwrite.dll"

    if not test -f "$DLL_SRC"
        echo "Missing source DLL: $DLL_SRC"
    else if not test -f "$DLL_DST"
        echo "Missing destination DLL: $DLL_DST"
    else
        set TS (date +%Y%m%d-%H%M%S)
        set BACKUP "$DLL_DST.backup-$TS"

        cp "$DLL_DST" "$BACKUP"
        cp "$DLL_SRC" "$DLL_DST"

        echo "Backup:"
        echo "$BACKUP"

        echo
        echo "SHA-256:"
        sha256sum "$DLL_SRC" "$DLL_DST"
    end
end
"""

launcher = """#!/usr/bin/env fish

if not set -q AVIUTL2_ROOT
    set AVIUTL2_ROOT "$HOME/Games/aviutl2"
end

if not set -q AVIUTL2_PREFIX
    set AVIUTL2_PREFIX "$AVIUTL2_ROOT/prefix-ge-nvdec-test"
end

if not set -q GE_PROTON_ROOT
    set GE_PROTON_ROOT \
        "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"
end

set GE_WINE \
    "$GE_PROTON_ROOT/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER \
    "$GE_PROTON_ROOT/files/bin/wineserver"

set GE_LIBS \
    "$GE_PROTON_ROOT/files/lib64:$GE_PROTON_ROOT/files/lib:$GE_PROTON_ROOT/files/lib/wine/x86_64-unix:$GE_PROTON_ROOT/files/lib/wine/i386-unix"

set AVIUTL2_DIR \
    "$AVIUTL2_PREFIX/drive_c/AviUtl2"

env \
    WINEPREFIX="$AVIUTL2_PREFIX" \
    "$GE_WINESERVER" -k 2>/dev/null

sleep 1

cd "$AVIUTL2_DIR"

env \
    WINEPREFIX="$AVIUTL2_PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES="nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b" \
    DXVK_CONFIG_FILE="$AVIUTL2_ROOT/nvidia-dxvk.conf" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG=-all \
    "$GE_WINE" ./aviutl2.exe
"""

gitignore = """*.dll
*.so
*.exe
*.log
*.zip
*.tar
*.tar.gz
build/
dist/
prefix*/
.cache/
__pycache__/
"""

files = {
    "README.md": readme,
    "docs/STATUS.md": status,
    "docs/TECHNICAL-NOTES.md": technical_notes,
    "docs/TROUBLESHOOTING.md": troubleshooting,
    "NOTICE.md": notice,
    "LICENSE": mit,
    ".gitignore": gitignore,
    "scripts/install-dwrite.fish": install_dwrite,
    "scripts/launch-aviutl2.example.fish": launcher,
}

for relative, content in files.items():
    target = out / relative
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(
        content.strip() + "\n",
        encoding="utf-8",
    )

for script in (out / "scripts").glob("*.fish"):
    script.chmod(0o755)

license_sources = [
    (dxvk / "LICENSE", out / "LICENSES/DXVK.txt"),
    (wine / "COPYING.LIB", out / "LICENSES/Wine-LGPL.txt"),
]

for source, destination in license_sources:
    if source.is_file():
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, destination)

lsmash_candidates = [
    lsmash / "LICENSE",
    lsmash / "LICENSE.txt",
    lsmash / "COPYING",
    lsmash / "COPYING.txt",
]

for source in lsmash_candidates:
    if source.is_file():
        destination = out / "LICENSES/L-SMASH-Works.txt"
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, destination)
        break

print("Generated repository metadata in:", out)
'
```

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(223).txt timestamp 2026-07-31 05:57:47 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、L-SMASH Works plugin/config、Git working tree、commit、remoteまたはGitHub repository、ログファイル。

#### 関連する固定値

- version: `2.7.1`
- version: `610.43.3`
- version: `11.0`
- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/projects/aviutl2-linux-patches`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。

#### 採用可否

```text
内容を修正してからREPRODUCTION.mdへ採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 05:57:47 +0900`

---
### コマンド 271 — `H167`

#### 目的

対象ソースまたは依存ライブラリをビルド・インストールする。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT "$HOME/Games/aviutl2"

set REPO "$HOME/projects/aviutl2-linux-patches"

set WINE_SRC "$ROOT/src/wine-ge11-1-dwrite"

set WINE_BUILD "$ROOT/build/wine-ge11-1-dwrite"

set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

set PATCH \
    "$ROOT/0002-harden-dwrite-hittestpoint.patch"
```

#### 実行コマンド

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

#### 実行結果

後続の正常起動、生成物、ハッシュ、ログまたは明示出力により採用された。出典: `(223).txt timestamp 2026-07-31 06:41:29 +0900`。

#### 生成・変更されたもの

Wine DirectWriteまたはpatched runner、Git working tree、commit、remoteまたはGitHub repository。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/projects/aviutl2-linux-patches`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 06:41:29 +0900`

---
### コマンド 272 — `H168`

#### 目的

DXVKをコンパイルする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
meson compile \
    -C "$DXVK_SRC/build.w64" \
    -j(nproc)

and cp -a \
    "$DXVK_SRC/build.w64/src/d3d11/d3d11.dll" \
    "$PREFIX_D3D11"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 11:42:20 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、DXVK DLL。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 11:42:20 +0900`

---
### コマンド 273 — `H169`

#### 目的

DXVKをコンパイルする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set PREFIX_D3D11 \
    "$WINEPREFIX_TEST/drive_c/windows/system32/d3d11.dll"
```

#### 実行コマンド

```fish
set PREFIX_D3D11 \
    "$WINEPREFIX_TEST/drive_c/windows/system32/d3d11.dll"

meson compile \
    -C "$DXVK_SRC/build.w64" \
    -j(nproc)

and cp -a \
    "$DXVK_SRC/build.w64/src/d3d11/d3d11.dll" \
    "$PREFIX_D3D11"

and strings "$PREFIX_D3D11" \
    | grep -F \
        'AviUtl2 compatibility'
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 11:45:29 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、DXVK DLL。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 11:45:29 +0900`

---
### コマンド 274 — `H170`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$WINEPREFIX_TEST"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$DXVK_CONFIG_FILE"

DXVK_LOG_LEVEL=warn

DXVK_LOG_PATH="$DXVK_LOG_DIR"

WINEDEBUG=-all
```

#### 実行コマンド

```fish
rm -rf "$DXVK_LOG_DIR"
mkdir -p "$DXVK_LOG_DIR"

env \
    WINEPREFIX="$WINEPREFIX_TEST" \
    "$GE_WINESERVER" -k \
    2>/dev/null

sleep 1

cd (dirname "$AVIUTL2_EXE")

env \
    WINEPREFIX="$WINEPREFIX_TEST" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$DXVK_CONFIG_FILE" \
    DXVK_LOG_LEVEL=warn \
    DXVK_LOG_PATH="$DXVK_LOG_DIR" \
    WINEDEBUG=-all \
    "$GE_WINE" \
    "$AVIUTL2_EXE"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 11:47:03 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 11:47:03 +0900`

---
### コマンド 275 — `H171`

#### 目的

ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set WINE_LAUNCH_PID $last_pid

WINEPREFIX="$WINEPREFIX_TEST"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$DXVK_CONFIG_FILE"

DXVK_LOG_LEVEL=warn

WINEDEBUG='+loaddll,+module'
```

#### 実行コマンド

```fish
env \
    WINEPREFIX="$WINEPREFIX_TEST" \
    "$GE_WINESERVER" -k \
    2>/dev/null

sleep 1

rm -f "$LOAD_LOG"

cd (dirname "$AVIUTL2_EXE")

env \
    WINEPREFIX="$WINEPREFIX_TEST" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b' \
    DXVK_CONFIG_FILE="$DXVK_CONFIG_FILE" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG='+loaddll,+module' \
    "$GE_WINE" \
    "$AVIUTL2_EXE" \
    >"$LOAD_LOG" \
    2>&1 &

set WINE_LAUNCH_PID $last_pid

sleep 5

echo "=== Launcher ==="
ps -p "$WINE_LAUNCH_PID" \
    -o pid,stat,cmd

echo
echo "=== AviUtl2 processes ==="
pgrep -a -f \
    'aviutl2\.exe|wine.*AviUtl2'

echo
echo "=== Relevant log ==="
grep -inE \
    'lwinput|lsmash|\.aui2|exception|unhandled|fault|import_dll.*failed|loader_init.*failed' \
    "$LOAD_LOG" \
    | tail -n 200

echo
echo "=== Log tail ==="
tail -n 100 "$LOAD_LOG"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 11:52:42 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 11:52:42 +0900`

---
### コマンド 276 — `H172`

#### 目的

必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT \
    "$HOME/Games/aviutl2"

set REPO \
    "$HOME/projects/aviutl2-linux-patches"

set PREFIX \
    "$ROOT/prefix-ge-nvdec-test"

set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"
```

#### 実行コマンド

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

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 14:00:03 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、ログファイル。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/projects/aviutl2-linux-patches`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 14:00:03 +0900`

---
### コマンド 277 — `H173`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

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

#### 実行コマンド

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

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 14:00:22 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 14:00:22 +0900`

---
### コマンド 278 — `H174`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT \
    "$HOME/Games/aviutl2"

set PREFIX \
    "$ROOT/prefix-ge-nvdec-test"

set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

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

#### 実行コマンド

```fish
set ROOT \
    "$HOME/Games/aviutl2"

set PREFIX \
    "$ROOT/prefix-ge-nvdec-test"

set GE_TEST \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

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

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 14:00:53 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 14:00:53 +0900`

---
### コマンド 279 — `H175`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$PREFIX"
```

#### 実行コマンド

```fish
env \
    WINEPREFIX="$PREFIX" \
    "$GE_WINESERVER" -k \
    2>/dev/null

sleep 1
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 14:01:13 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 14:01:13 +0900`

---
### コマンド 280 — `H176`

#### 目的

必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
cp -a \
    "$GE_TEST" \
    "$EXPORT/ge/"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 14:01:23 +0900`。

#### 生成・変更されたもの

コマンド本文に記載された対象。詳細は実行コマンドを参照。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 14:01:23 +0900`

---
### コマンド 281 — `H177`

#### 目的

必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

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

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 14:01:28 +0900`。

#### 生成・変更されたもの

DXVK DLL。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 14:01:28 +0900`

---
### コマンド 282 — `H178`

#### 目的

必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
cp -a \
    "$PLUGIN_DIR/lwinput.aui2" \
    "$EXPORT/plugin/lwinput.aui2"

cp -a \
    "$PLUGIN_DIR/lsmash.ini" \
    "$EXPORT/plugin/lsmash.ini"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 14:01:40 +0900`。

#### 生成・変更されたもの

L-SMASH Works plugin/config。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 14:01:40 +0900`

---
### コマンド 283 — `H179`

#### 目的

必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
cp -a \
    "$ROOT/nvidia-dxvk.conf" \
    "$EXPORT/config/nvidia-dxvk.conf"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 14:01:43 +0900`。

#### 生成・変更されたもの

コマンド本文に記載された対象。詳細は実行コマンドを参照。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 14:01:43 +0900`

---
### コマンド 284 — `H180`

#### 目的

必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

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
```

#### 実行コマンド

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

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 14:02:06 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、ログファイル。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test`
- path: `$HOME/.local/share/Steam/compatibilitytools.d`
- path: `$HOME/Downloads/aviutl2-known-good.tar.zst`
- path: `$HOME/Downloads/aviutl2-known-good.tar.zst.sha256`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 14:02:06 +0900`

---
### コマンド 285 — `H181`

#### 目的

必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
cp -a \
    "$IMPORT_GE" \
    "$GE_TEST"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 14:03:06 +0900`。

#### 生成・変更されたもの

コマンド本文に記載された対象。詳細は実行コマンドを参照。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 14:03:06 +0900`

---
### コマンド 286 — `H182`

#### 目的

対象Wine prefixのプロセスを停止または終了待ちする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set TS \
    (date +%Y%m%d-%H%M%S)

WINEPREFIX="$PREFIX"
```

#### 実行コマンド

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

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 14:03:20 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 14:03:20 +0900`

---
### コマンド 287 — `H183`

#### 目的

Wine prefixを作成または更新し、レジストリとランタイム状態を反映する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
WINEPREFIX="$PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"
```

#### 実行コマンド

```fish
mkdir -p "$PREFIX"

env \
    WINEPREFIX="$PREFIX" \
    LD_LIBRARY_PATH="$GE_LIBS" \
    "$GE_WINE" wineboot -u
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 14:03:25 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 14:03:25 +0900`

---
### コマンド 288 — `H184`

#### 目的

必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set AVIUTL2_SOURCE_DIR \
    (dirname "$AVIUTL2_SOURCE_EXE")

set AVIUTL2_DIR \
    "$PREFIX/drive_c/AviUtl2"
```

#### 実行コマンド

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

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 14:03:44 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 14:03:44 +0900`

---
### コマンド 289 — `H185`

#### 目的

必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
cp -a \
    "$IMPORT/config/nvidia-dxvk.conf" \
    "$ROOT/nvidia-dxvk.conf"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 14:03:54 +0900`。

#### 生成・変更されたもの

コマンド本文に記載された対象。詳細は実行コマンドを参照。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 14:03:54 +0900`

---
### コマンド 290 — `H186`

#### 目的

必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set SYSTEM32 \
    "$PREFIX/drive_c/windows/system32"

set TS \
    (date +%Y%m%d-%H%M%S)
```

#### 実行コマンド

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

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 14:04:02 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、DXVK DLL。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 14:04:02 +0900`

---
### コマンド 291 — `H187`

#### 目的

必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
cp -a \
    "$IMPORT/plugin/lwinput.aui2" \
    "$PLUGIN_DIR/lwinput.aui2"

cp -a \
    "$IMPORT/plugin/lsmash.ini" \
    "$PLUGIN_DIR/lsmash.ini"
```

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 14:04:17 +0900`。

#### 生成・変更されたもの

L-SMASH Works plugin/config。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 14:04:17 +0900`

---
### コマンド 292 — `H188`

#### 目的

AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
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

WINEPREFIX="$PREFIX"

LD_LIBRARY_PATH="$GE_LIBS"

WINEDLLOVERRIDES="$DLL_OVERRIDES"

DXVK_CONFIG_FILE="$DXVK_CONFIG"

DXVK_LOG_LEVEL=warn

WINEDEBUG=-all
```

#### 実行コマンド

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

#### 実行結果

実行履歴は存在するが、後続で修正・置換・再実行されたか、エラーが確認されたため最終成功経路には採用しない。出典: `(223).txt timestamp 2026-07-31 14:04:32 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、Wine DirectWriteまたはpatched runner、ログファイル。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-07-31 14:04:32 +0900`

---
### コマンド 293 — `H189`

#### 目的

AviUtl2 Catalogの取得、導入、起動、設定または更新停止状態を処理する。

#### 分類

```text
実行確認不能
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set -euo pipefail

    export WINEPREFIX="${WINEPREFIX:-$PROJECT_DIR/pfx-ge/pfx}"

    export AVIUTL2_ROOT="$PROJECT_DIR"

    export STEAM_COMPAT_CLIENT_INSTALL_PATH="$HOME/.local/share/Steam"

    export STEAM_COMPAT_DATA_PATH="$PFX_DIR"

    export STEAM_COMPAT_APP_ID="0"

    export UMU_ID="aviutl2"

export WINEPREFIX="$PFX"

export WINEDLLOVERRIDES="dwrite=b;d3d11,dxgi,d3d10core=n;d3dcompiler_47=n"

export DXVK_D3D11_DISABLE_YCBCR=1

export DXVK_VIDEO_USE_VK_FORMAT=0

export DISPLAY="${DISPLAY:-:1}"

export LD_LIBRARY_PATH="$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix:${LD_LIBRARY_PATH:-}"

export AVIUTL2_ROOT="$PROJECT_DIR"

set +e

set -e

AVIUTL2_AUTO_DISMISS=1

WINEARCH=win64

WINEDLLOVERRIDES="d3d11,dxgi,d3d10core=n;d3dcompiler_47=n"
```

#### 実行コマンド

```fish
cd ~/projects/aviutl2-linux-patches

grep -nE \
    '^## |^### |default_pfx|libvkd3d|WINEDLLPATH|wineboot|GE_DEFAULT_PFX|c0000135|read -P' \
    docs/REPRODUCTION.md

git diff --check -- docs/REPRODUCTION.md
git diff --stat -- docs/REPRODUCTION.md

============================================================
PRIMARY PATH METADATA
============================================================

=== /home/alex/projects/aviutl2-linux/launch-ge.sh ===
type=regular file
birth=2026-07-12 16:49:10.499859021 +0900
mtime=2026-07-12 19:13:52.681486576 +0900
ctime=2026-07-12 19:13:52.681486576 +0900
size=8233
inode=1342317427

=== /home/alex/projects/aviutl2-linux/pfx-ge/pfx ===
type=directory
birth=2026-07-12 16:49:58.430510991 +0900
mtime=2026-07-12 19:14:01.980826847 +0900
ctime=2026-07-12 19:14:01.980826847 +0900
size=187
inode=2148434090

=== /home/alex/Games/aviutl2/prefix-ge ===
type=directory
birth=2026-07-30 21:33:42.453585105 +0900
mtime=2026-07-31 02:55:15.057778193 +0900
ctime=2026-07-31 02:55:15.057778193 +0900
size=117
inode=540020250

=== /home/alex/.local/share/Steam/compatibilitytools.d/GE-Proton11-1/files/share/default_pfx ===
type=directory
birth=2026-07-12 16:19:04.567562255 +0900
mtime=2026-06-24 11:01:00.000000000 +0900
ctime=2026-07-12 16:19:06.860409375 +0900
size=117
inode=5427250

============================================================
CURRENT launch-ge.sh
============================================================
fb72fe3da5a2e03665eca298257c18e2d3b98c594b5a5bfd47ee2d5de82bc760  /home/alex/projects/aviutl2-linux/launch-ge.sh
#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# AviUtl2 + Proton GE + DXVK standalone launcher
# No Steam required. Uses GE's wine + DXVK v2.7.1 (Vulkan).
#
# Catalog integration:
#   --catalog <command> [args]  — Run catalog CLI tool instead of launching
#   CATALOG_AUTO_CHECK=1       — Check for package updates after launch
#
#
# Prerequisite: Proton GE must be installed first.
#   mkdir -p ~/.local/share/Steam/compatibilitytools.d
#   curl -L -o GE-Proton11-1.tar.gz https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton11-1/GE-Proton11-1.tar.gz
#   tar -xzf GE-Proton11-1.tar.gz -C ~/.local/share/Steam/compatibilitytools.d/
# ============================================================

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_DIR"

# --- Catalog integration ---
CATALOG_CLI="$PROJECT_DIR/tools/catalog/catalog-cli.py"

# If --catalog is passed, run catalog command instead of launching AviUtl2
if [[ "${1:-}" == "--catalog" ]]; then
    shift
    export WINEPREFIX="${WINEPREFIX:-$PROJECT_DIR/pfx-ge/pfx}"
    export AVIUTL2_ROOT="$PROJECT_DIR"
    exec python3 "$CATALOG_CLI" "$@"
fi

# --- Proton GE path ---
GE_DIR="${GE_DIR:-$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1}"

if [[ ! -d "$GE_DIR/files/lib/wine" ]]; then
    echo "[launch-ge] Proton GE not found at: $GE_DIR" >&2
    echo "[launch-ge] Download: https://github.com/GloriousEggroll/proton-ge-custom/releases" >&2
    echo "[launch-ge] Extract to: ~/.local/share/Steam/compatibilitytools.d/" >&2
    exit 1
fi

if [[ ! -f "aviutl2.exe" ]]; then
    echo "[launch-ge] aviutl2.exe not found. Please run ./setup.sh first." >&2
    exit 1
fi

GE_WINE="$GE_DIR/files/lib/wine/x86_64-unix/wine"
GE_WINESERVER="$GE_DIR/files/bin/wineserver"
GE_DXVK="$GE_DIR/files/lib/wine/dxvk"

# --- Prefix ---
PFX_DIR="${PFX_DIR:-$PROJECT_DIR/pfx-ge}"
PFX="$PFX_DIR/pfx"

# --- First-time prefix setup ---
if [[ ! -d "$PFX" ]]; then
    echo "[launch-ge] Initializing Proton GE prefix..."
    export STEAM_COMPAT_CLIENT_INSTALL_PATH="$HOME/.local/share/Steam"
    export STEAM_COMPAT_DATA_PATH="$PFX_DIR"
    export STEAM_COMPAT_APP_ID="0"
    export UMU_ID="aviutl2"
    timeout 30 "$GE_DIR/proton" run "$PROJECT_DIR/aviutl2.exe" 2>/dev/null || true
    echo "[launch-ge] Prefix initialized."
fi

# --- Install DXVK DLLs into prefix ---
copy_dxvk() {
    local arch="$1"      # x86_64-windows or i386-windows
    local dest="$2"      # system32 or syswow64
    mkdir -p "$PFX/drive_c/windows/$dest"
    for dll in d3d11 dxgi d3d10core; do
        if [[ -f "$GE_DXVK/$arch/$dll.dll" ]]; then
            cp "$GE_DXVK/$arch/$dll.dll" "$PFX/drive_c/windows/$dest/" 2>/dev/null || true
        fi
    done
}

# Only copy if the DXVK version changed or files are missing
DXVK_VER=$(cat "$GE_DXVK/version" 2>/dev/null || echo "unknown")
DXVK_STAMP="$PFX/.dxvk-version"
if [[ "$(cat "$DXVK_STAMP" 2>/dev/null)" != "$DXVK_VER" ]]; then
    echo "[launch-ge] Installing DXVK $DXVK_VER..."
    copy_dxvk "x86_64-windows" "system32"
    copy_dxvk "i386-windows" "syswow64"
    echo "$DXVK_VER" > "$DXVK_STAMP"
fi

# --- Apply custom patched D3D11 after the stock DXVK installation ---
CUSTOM_D3D11="${CUSTOM_D3D11:-$PROJECT_DIR/dxvk-src/out/bin/d3d11.dll}"

if [[ -f "$CUSTOM_D3D11" ]]; then
    echo "[launch-ge] Applying custom d3d11.dll: $CUSTOM_D3D11"
    cp -f "$CUSTOM_D3D11" "$PFX/drive_c/windows/system32/d3d11.dll"
else
    echo "[launch-ge] Warning: custom d3d11.dll not found: $CUSTOM_D3D11" >&2
fi

# --- Install native d3dcompiler_47 (if not already present, e.g. from setup.sh) ---
mkdir -p "$PFX/drive_c/windows/system32" "$PFX/drive_c/windows/syswow64"
D3D_DEST64="$PFX/drive_c/windows/system32/d3dcompiler_47.dll"
D3D_DEST32="$PFX/drive_c/windows/syswow64/d3dcompiler_47.dll"
if [[ ! -f "$D3D_DEST64" ]]; then
    CACHE_DIR="$PROJECT_DIR/.cache/d3dcompiler_47"
    mkdir -p "$CACHE_DIR" "$(dirname "$D3D_DEST64")" "$(dirname "$D3D_DEST32")"
    CAB64_URL="https://download.microsoft.com/download/B/0/C/B0C80BA3-8AD6-4958-810B-6882485230B5/standalonesdk/Installers/61d57a7a82309cd161a854a6f4619e52.cab"
    CAB32_URL="https://download.microsoft.com/download/B/0/C/B0C80BA3-8AD6-4958-810B-6882485230B5/standalonesdk/Installers/2630bae9681db6a9f6722366f47d055c.cab"
    CAB64="$CACHE_DIR/61d57a7a82309cd161a854a6f4619e52.cab"
    CAB32="$CACHE_DIR/2630bae9681db6a9f6722366f47d055c.cab"
    if command -v bsdtar >/dev/null 2>&1; then
        echo "[launch-ge] Downloading native d3dcompiler_47..."
        curl -fL -o "$CAB64" "$CAB64_URL" 2>/dev/null || true
        curl -fL -o "$CAB32" "$CAB32_URL" 2>/dev/null || true
        if [[ -f "$CAB64" ]]; then
            bsdtar -C "$CACHE_DIR" -xf "$CAB64" 2>/dev/null || true
            cp "$CACHE_DIR/fil3585cb2ea5db13cc0838f8d06b5c9679" "$D3D_DEST64" 2>/dev/null || true
        fi
        if [[ -f "$CAB32" ]]; then
            bsdtar -C "$CACHE_DIR" -xf "$CAB32" 2>/dev/null || true
            cp "$CACHE_DIR/fila319f706acfa16d6707473ebf29bdc7f" "$D3D_DEST32" 2>/dev/null || true
        fi
    fi
fi

# --- Set up DXVK DLL overrides in registry ---
setup_overrides() {
    local wine="$1"
    local pfx="$2"
    for dll in d3d11 d3d10core dxgi; do
        "$wine" reg add 'HKEY_CURRENT_USER\Software\Wine\DllOverrides' \
            /v "$dll" /d native,builtin /f 2>/dev/null || true
    done
    "$wine" reg add 'HKEY_CURRENT_USER\Software\Wine\DllOverrides' \
        /v d3dcompiler_47 /d native /f 2>/dev/null || true
}

# --- Configure encoder paths for x264guiEx/x265guiEx ---
setup_encoders() {
    local plugin_dir="$PFX/drive_c/ProgramData/aviutl2/Plugin"
    local exe_dir="$plugin_dir/exe_files"

    # x264 path
    if [[ -f "$plugin_dir/x264guiEx.conf" ]]; then
        if ! grep -q "x264_path" "$plugin_dir/x264guiEx.conf" 2>/dev/null; then
            echo "x264_path=C:\\ProgramData\\aviutl2\\Plugin\\exe_files\\x264_3223_x64.exe" >> "$plugin_dir/x264guiEx.conf"
        fi
    fi

    # x265 path
    if [[ -f "$plugin_dir/x265guiEx.conf" ]]; then
        if ! grep -q "x265_path" "$plugin_dir/x265guiEx.conf" 2>/dev/null; then
            echo "x265_path=C:\\ProgramData\\aviutl2\\Plugin\\exe_files\\x265_4.1+190_x64.exe" >> "$plugin_dir/x265guiEx.conf"
        fi
    fi
}

# --- Environment ---
export WINEPREFIX="$PFX"
export WINEDLLOVERRIDES="dwrite=b;d3d11,dxgi,d3d10core=n;d3dcompiler_47=n"
# Disable DXVK hardware YCbCr sampler (Intel GPU U/V swap workaround)
# Forces software YUV→RGB conversion for NV12/YUY2 shader resource views
export DXVK_D3D11_DISABLE_YCBCR=1
export DXVK_VIDEO_USE_VK_FORMAT=0
export DISPLAY="${DISPLAY:-:1}"

# Library path for GE's wine-staging
export LD_LIBRARY_PATH="$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix:${LD_LIBRARY_PATH:-}"

# --- Apply registry overrides ---
setup_overrides "$GE_WINE" "$PFX"
setup_encoders
# Export AVIUTL2_ROOT for catalog integration
export AVIUTL2_ROOT="$PROJECT_DIR"

echo "[launch-ge] Wine:  wine-staging (Proton GE)"
echo "[launch-ge] DXVK:  $(cat "$GE_DXVK/version" 2>/dev/null || echo 'v2.7.1')"
echo "[launch-ge] Prefix: $PFX"
echo "[launch-ge] Starting AviUtl2..."
echo "[launch-ge] Note: 'D3D RDMs not supported' dialog may appear — press Enter 2x or use dismiss-dialogs.py"
# Start AviUtl2 in background
"$GE_WINE" "$PROJECT_DIR/aviutl2.exe" "$@" &

# Optional: check for catalog updates after launch (non-blocking)
if [[ -n "${CATALOG_AUTO_CHECK:-}" ]] && [[ -f "$CATALOG_CLI" ]]; then
    echo "[launch-ge] Checking for package updates..."
    python3 "$CATALOG_CLI" update 2>&1 | sed 's/^/[catalog] /' &
fi
AVIUTL2_PID=$!

# Auto-dismiss disabled by default.
# Enable explicitly with AVIUTL2_AUTO_DISMISS=1 only when needed.
if [[ "${AVIUTL2_AUTO_DISMISS:-0}" == "1" ]]; then
    sleep 3
    for i in $(seq 1 5); do
        python3 "$PROJECT_DIR/tools/dismiss-dialogs.py" --display "${DISPLAY:-:1}" --count 1 --delay 0.3 2>/dev/null || true
        sleep 0.5
    done
fi

# Wait for AviUtl2 to exit
set +e
wait "$AVIUTL2_PID"
AVIUTL2_STATUS=$?
set -e

echo "[launch-ge] AviUtl2 exited with status $AVIUTL2_STATUS"
exit "$AVIUTL2_STATUS"


============================================================
launch-ge.sh GIT HISTORY
============================================================
commit=5ea4cc690545c6eae692f7d893b3d759a2b61ef0
author-date=2026-07-10T06:14:04+09:00
commit-date=2026-07-10T06:14:04+09:00
subject=naosi+catalog
commit=228645035128f09451089834916b039208f5f656
author-date=2026-07-09T06:00:15+09:00
commit-date=2026-07-09T06:00:15+09:00
subject=AviUtl2 on Linux via Proton GE + DXVK

============================================================
launch-ge.sh GIT PATCH HISTORY
============================================================
commit=5ea4cc690545c6eae692f7d893b3d759a2b61ef0
author-date=2026-07-10T06:14:04+09:00
commit-date=2026-07-10T06:14:04+09:00
subject=naosi+catalog

diff --git a/launch-ge.sh b/launch-ge.sh
index 3eee10a3..e83658f7 100755
--- a/launch-ge.sh
+++ b/launch-ge.sh
@@ -5,6 +5,11 @@ set -euo pipefail
 # AviUtl2 + Proton GE + DXVK standalone launcher
 # No Steam required. Uses GE's wine + DXVK v2.7.1 (Vulkan).
 #
+# Catalog integration:
+#   --catalog <command> [args]  — Run catalog CLI tool instead of launching
+#   CATALOG_AUTO_CHECK=1       — Check for package updates after launch
+#
+#
 # Prerequisite: Proton GE must be installed first.
 #   mkdir -p ~/.local/share/Steam/compatibilitytools.d
 #   curl -L -o GE-Proton11-1.tar.gz https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton11-1/GE-Proton11-1.tar.gz
@@ -14,6 +19,17 @@ set -euo pipefail
 PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
 cd "$PROJECT_DIR"

+# --- Catalog integration ---
+CATALOG_CLI="$PROJECT_DIR/tools/catalog/catalog-cli.py"
+
+# If --catalog is passed, run catalog command instead of launching AviUtl2
+if [[ "${1:-}" == "--catalog" ]]; then
+    shift
+    export WINEPREFIX="${WINEPREFIX:-$PROJECT_DIR/pfx-ge/pfx}"
+    export AVIUTL2_ROOT="$PROJECT_DIR"
+    exec python3 "$CATALOG_CLI" "$@"
+fi
+
 # --- Proton GE path ---
 GE_DIR="${GE_DIR:-$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1}"

@@ -70,14 +86,29 @@ if [[ "$(cat "$DXVK_STAMP" 2>/dev/null)" != "$DXVK_VER" ]]; then
     echo "$DXVK_VER" > "$DXVK_STAMP"
 fi

-# --- Install native d3dcompiler_47 ---
+# --- Install native d3dcompiler_47 (if not already present, e.g. from setup.sh) ---
 mkdir -p "$PFX/drive_c/windows/system32" "$PFX/drive_c/windows/syswow64"
-if [[ ! -f "$PFX/drive_c/windows/system32/d3dcompiler_47.dll" ]]; then
...skipping...
+    if [[ -f "$plugin_dir/x265guiEx.conf" ]]; then
+        if ! grep -q "x265_path" "$plugin_dir/x265guiEx.conf" 2>/dev/null; then
+            echo "x265_path=C:\\ProgramData\\aviutl2\\Plugin\\exe_files\\x265_4.1+190_x64.exe" >> "$plugin_dir/x265guiEx.conf"
+        fi
+    fi
+}
+
+# --- Environment ---
+export WINEARCH=win64
+export WINEPREFIX="$PFX"
+export WINEDLLOVERRIDES="d3d11,dxgi,d3d10core=n;d3dcompiler_47=n"
+# Disable DXVK hardware YCbCr sampler (Intel GPU U/V swap workaround)
+# Forces software YUV→RGB conversion for NV12/YUY2 shader resource views
+export DXVK_D3D11_DISABLE_YCBCR=1
+export DXVK_VIDEO_USE_VK_FORMAT=0
+export DISPLAY="${DISPLAY:-:1}"
+
+# Library path for GE's wine-staging
+export LD_LIBRARY_PATH="$GE_DIR/files/lib64:$GE_DIR/files/lib:$GE_DIR/files/lib/wine/x86_64-unix:$GE_DIR/files/lib/wine/i386-unix:${LD_LIBRARY_PATH:-}"
+
+# --- Apply registry overrides ---
+setup_overrides "$GE_WINE" "$PFX"
+setup_encoders
+
+# --- Launch AviUtl2 ---
+echo "[launch-ge] Wine:  wine-staging (Proton GE)"
+echo "[launch-ge] DXVK:  $(cat "$GE_DXVK/version" 2>/dev/null || echo 'v2.7.1')"
+echo "[launch-ge] Prefix: $PFX"
+echo "[launch-ge] Starting AviUtl2..."
+echo "[launch-ge] Note: 'D3D RDMs not supported' dialog may appear — press Enter 2x or use dismiss-dialogs.py"
+
+# Start AviUtl2 in background and dismiss dialogs
+"$GE_WINE" "$PROJECT_DIR/aviutl2.exe" "$@" &
+AVIUTL2_PID=$!
+
+# Auto-dismiss startup dialogs
+sleep 3
+for i in $(seq 1 5); do
+    python3 "$PROJECT_DIR/tools/dismiss-dialogs.py" --display "${DISPLAY:-:1}" --count 1 --delay 0.3 2>/dev/null || true
+    sleep 0.5
+done
+
+# Wait for AviUtl2 to exit
+wait $AVIUTL2_PID 2>/dev/null || true

============================================================
PREFIX STRUCTURE METADATA
============================================================

############################################################
ROOT: /home/alex/projects/aviutl2-linux/pfx-ge/pfx
############################################################
path=/home/alex/projects/aviutl2-linux/pfx-ge/pfx/user.reg|type=regular file|birth=2026-07-12 19:14:01.980728191 +0900|mtime=2026-07-12 19:14:01.980826847 +0900|ctime=2026-07-12 19:14:01.980826847 +0900|size=141614|inode=2150531303
path=/home/alex/projects/aviutl2-linux/pfx-ge/pfx/system.reg|type=regular file|birth=2026-07-12 19:14:01.953963481 +0900|mtime=2026-07-12 19:14:01.978963618 +0900|ctime=2026-07-12 19:14:01.979893307 +0900|size=4303702|inode=2149825898
path=/home/alex/projects/aviutl2-linux/pfx-ge/pfx/userdef.reg|type=regular file|birth=2026-07-12 19:14:01.979963624 +0900|mtime=2026-07-12 19:14:01.980728191 +0900|ctime=2026-07-12 19:14:01.980728191 +0900|size=4190|inode=2150531301
path=/home/alex/projects/aviutl2-linux/pfx-ge/pfx/drive_c|type=directory|birth=2026-07-12 16:49:58.431420777 +0900|mtime=2026-07-12 16:49:58.654374726 +0900|ctime=2026-07-12 16:49:58.654374726 +0900|size=131|inode=2416253877
path=/home/alex/projects/aviutl2-linux/pfx-ge/pfx/drive_c/windows|type=directory|birth=2026-07-12 16:49:58.431688950 +0900|mtime=2026-07-12 16:49:58.499835187 +0900|ctime=2026-07-12 16:49:58.499835187 +0900|size=4096|inode=2684795620
path=/home/alex/projects/aviutl2-linux/pfx-ge/pfx/drive_c/windows/system32|type=directory|birth=2026-07-12 16:49:58.433511017 +0900|mtime=2026-07-12 19:01:46.055602018 +0900|ctime=2026-07-12 19:01:46.055602018 +0900|size=24576|inode=809441754
path=/home/alex/projects/aviutl2-linux/pfx-ge/pfx/drive_c/windows/syswow64|type=directory|birth=2026-07-12 16:49:58.455511206 +0900|mtime=2026-07-12 17:07:40.137553380 +0900|ctime=2026-07-12 17:07:40.137553380 +0900|size=24576|inode=809636803
MISSING: /home/alex/projects/aviutl2-linux/pfx-ge/pfx/drive_c/AviUtl2
MISSING: /home/alex/projects/aviutl2-linux/pfx-ge/pfx/drive_c/AviUtl2/aviutl2.exe

############################################################
ROOT: /home/alex/Games/aviutl2/prefix-ge
############################################################
path=/home/alex/Games/aviutl2/prefix-ge/user.reg|type=regular file|birth=2026-07-31 02:55:15.057712378 +0900|mtime=2026-07-31 02:55:15.057778193 +0900|ctime=2026-07-31 02:55:15.057778193 +0900|size=150240|inode=540212484
path=/home/alex/Games/aviutl2/prefix-ge/system.reg|type=regular file|birth=2026-07-31 02:55:15.030734191 +0900|mtime=2026-07-31 02:55:15.055734386 +0900|ctime=2026-07-31 02:55:15.055734386 +0900|size=4400209|inode=540132582
path=/home/alex/Games/aviutl2/prefix-ge/userdef.reg|type=regular file|birth=2026-07-31 02:55:15.056734393 +0900|mtime=2026-07-31 02:55:15.057712378 +0900|ctime=2026-07-31 02:55:15.057712378 +0900|size=4190|inode=539837636
path=/home/alex/Games/aviutl2/prefix-ge/drive_c|type=directory|birth=2026-07-30 21:33:42.455084198 +0900|mtime=2026-07-31 01:37:44.424561514 +0900|ctime=2026-07-31 01:37:44.424561514 +0900|size=140|inode=1075831166
path=/home/alex/Games/aviutl2/prefix-ge/drive_c/windows|type=directory|birth=2026-07-30 21:33:42.455579780 +0900|mtime=2026-07-30 21:33:44.924600897 +0900|ctime=2026-07-30 21:33:44.924600897 +0900|size=4096|inode=1342782190
path=/home/alex/Games/aviutl2/prefix-ge/drive_c/windows/system32|type=directory|birth=2026-07-30 21:33:42.455579780 +0900|mtime=2026-07-30 22:46:41.698116544 +0900|ctime=2026-07-30 22:46:41.698116544 +0900|size=24576|inode=1612710315
path=/home/alex/Games/aviutl2/prefix-ge/drive_c/windows/syswow64|type=directory|birth=2026-07-30 21:33:42.455579780 +0900|mtime=2026-07-30 22:46:42.608124380 +0900|ctime=2026-07-30 22:46:42.608124380 +0900|size=24576|inode=1880240766
path=/home/alex/Games/aviutl2/prefix-ge/drive_c/AviUtl2|type=directory|birth=2026-07-30 21:33:52.124646929 +0900|mtime=2026-07-31 02:52:56.138651377 +0900|ctime=2026-07-31 02:52:56.138651377 +0900|size=4096|inode=540021512
path=/home/alex/Games/aviutl2/prefix-ge/drive_c/AviUtl2/aviutl2.exe|type=regular file|birth=2026-07-30 21:33:52.124646929 +0900|mtime=2026-07-25 15:01:12.000000000 +0900|ctime=2026-07-30 21:33:52.126094532 +0900|size=5086208|inode=540021513

############################################################
ROOT: /home/alex/.local/share/Steam/compatibilitytools.d/GE-Proton11-1/files/share/default_pfx
############################################################
path=/home/alex/.local/share/Steam/compatibilitytools.d/GE-Proton11-1/files/share/default_pfx/user.reg|type=regular file|birth=2026-07-12 16:19:04.680816935 +0900|mtime=2026-06-24 11:01:00.000000000 +0900|ctime=2026-07-12 16:19:04.680816935 +0900|size=30352|inode=6274583
path=/home/alex/.local/share/Steam/compatibilitytools.d/GE-Proton11-1/files/share/default_pfx/system.reg|type=regular file|birth=2026-07-12 16:19:04.680816935 +0900|mtime=2026-06-24 11:01:00.000000000 +0900|ctime=2026-07-12 16:19:04.686563242 +0900|size=3926681|inode=6274584
path=/home/alex/.local/share/Steam/compatibilitytools.d/GE-Proton11-1/files/share/default_pfx/userdef.reg|type=regular file|birth=2026-07-12 16:19:04.567562255 +0900|mtime=2026-06-24 11:01:00.000000000 +0900|ctime=2026-07-12 16:19:04.567562255 +0900|size=4190|inode=5427251
path=/home/alex/.local/share/Steam/compatibilitytools.d/GE-Proton11-1/files/share/default_pfx/drive_c|type=directory|birth=2026-07-12 16:19:04.567562255 +0900|mtime=2026-06-24 11:00:58.000000000 +0900|ctime=2026-07-12 16:19:06.860409375 +0900|size=101|inode=277787446
path=/home/alex/.local/share/Steam/compatibilitytools.d/GE-Proton11-1/files/share/default_pfx/drive_c/windows|type=directory|birth=2026-07-12 16:19:04.567562255 +0900|mtime=2026-06-24 11:01:00.000000000 +0900|ctime=2026-07-12 16:19:06.860409375 +0900|size=4096|inode=543923495
path=/home/alex/.local/share/Steam/compatibilitytools.d/GE-Proton11-1/files/share/default_pfx/drive_c/windows/system32|type=directory|birth=2026-07-12 16:19:04.568152656 +0900|mtime=2026-06-24 11:01:00.000000000 +0900|ctime=2026-07-12 16:19:06.860409375 +0900|size=24576|inode=1879706624
path=/home/alex/.local/share/Steam/compatibilitytools.d/GE-Proton11-1/files/share/default_pfx/drive_c/windows/syswow64|type=directory|birth=2026-07-12 16:19:04.602562545 +0900|mtime=2026-06-24 11:01:00.000000000 +0900|ctime=2026-07-12 16:19:06.860409375 +0900|size=24576|inode=1881022309
MISSING: /home/alex/.local/share/Steam/compatibilitytools.d/GE-Proton11-1/files/share/default_pfx/drive_c/AviUtl2
MISSING: /home/alex/.local/share/Steam/compatibilitytools.d/GE-Proton11-1/files/share/default_pfx/drive_c/AviUtl2/aviutl2.exe

============================================================
PREFIX RUNTIME DLL HASHES
============================================================

############################################################
ROOT: /home/alex/projects/aviutl2-linux/pfx-ge/pfx
############################################################
551bc022962d011737ed6c5be56ffb1afca8a303681c97a23b16f609664bfde3  /home/alex/projects/aviutl2-linux/pfx-ge/pfx/drive_c/windows/system32/libvkd3d-1.dll
902b2e9f16e3d1f27f4d7dbafd8cb201548f4800752760922450c0beceb7c24e  /home/alex/projects/aviutl2-linux/pfx-ge/pfx/drive_c/windows/system32/libvkd3d-shader-1.dll
27b85a8e3162bb502a6fac29e2d433848a08b09b052c8df9ba20e4b48969fe47  /home/alex/projects/aviutl2-linux/pfx-ge/pfx/drive_c/windows/system32/libvkd3d-utils-1.dll
ae2fb437e8b5a3a2f6ab9a7fec3dbfd0a7680f30b930843556f736bf1fde5455  /home/alex/projects/aviutl2-linux/pfx-ge/pfx/drive_c/windows/system32/wined3d.dll
e994847e01a6f1e4cbdc5a864616ac262f67ee4f14db194984661a8d927ab7f4  /home/alex/projects/aviutl2-linux/pfx-ge/pfx/drive_c/windows/system32/d3dcompiler_47.dll
0360a7880b2d7db7720d7520420f7b9bdaa66431629bf2f2e577432c8cb01d73  /home/alex/projects/aviutl2-linux/pfx-ge/pfx/drive_c/windows/system32/d2d1.dll
6d92b541c36f2157be264e5803497ab8f17777c1f575e6704fe3450d00f00e32  /home/alex/projects/aviutl2-linux/pfx-ge/pfx/drive_c/windows/system32/dwrite.dll
4fa0d4e39005c83b5d8b6e2cfe1041eb2a8c74f9b15eaa51a368c32371139525  /home/alex/projects/aviutl2-linux/pfx-ge/pfx/drive_c/windows/syswow64/libvkd3d-1.dll
26ed2e8f6bb3db41e859f70846f9e36ac9fcccd2b8a1d94e7d4bdd66c7a6afa0  /home/alex/projects/aviutl2-linux/pfx-ge/pfx/drive_c/windows/syswow64/libvkd3d-shader-1.dll
17ec738ba3e73295b8e13c2f5cb10d274b85342f292c0b8914cf51dc851590c6  /home/alex/projects/aviutl2-linux/pfx-ge/pfx/drive_c/windows/syswow64/libvkd3d-utils-1.dll
29a585ee446115ef18c16ed4c147179ef2cd50ff06bf3d690527eaf872fcccfe  /home/alex/projects/aviutl2-linux/pfx-ge/pfx/drive_c/windows/syswow64/wined3d.dll
efbdbbcd0d954f8fdc53467de5d89ad525e4e4a9cfff8a15d07c6fdb350c407f  /home/alex/projects/aviutl2-linux/pfx-ge/pfx/drive_c/windows/syswow64/d3dcompiler_47.dll
364dccc92b4b4a22b2741e1a17daa5b04a4603a7fb63366ff1759db2b914c9f6  /home/alex/projects/aviutl2-linux/pfx-ge/pfx/drive_c/windows/syswow64/d2d1.dll
f786228384f82c686988bbf93a7f13d81c73de204988a1105735ac20591a3999  /home/alex/projects/aviutl2-linux/pfx-ge/pfx/drive_c/windows/syswow64/dwrite.dll

############################################################
ROOT: /home/alex/Games/aviutl2/prefix-ge
############################################################
MISSING: /home/alex/Games/aviutl2/prefix-ge/drive_c/windows/system32/libvkd3d-1.dll
MISSING: /home/alex/Games/aviutl2/prefix-ge/drive_c/windows/system32/libvkd3d-shader-1.dll
MISSING: /home/alex/Games/aviutl2/prefix-ge/drive_c/windows/system32/libvkd3d-utils-1.dll
ae2fb437e8b5a3a2f6ab9a7fec3dbfd0a7680f30b930843556f736bf1fde5455  /home/alex/Games/aviutl2/prefix-ge/drive_c/windows/system32/wined3d.dll
4432bbd1a390874f3f0a503d45cc48d346abc3a8c0213c289f4b615bf0ee84f3  /home/alex/Games/aviutl2/prefix-ge/drive_c/windows/system32/d3dcompiler_47.dll
0360a7880b2d7db7720d7520420f7b9bdaa66431629bf2f2e577432c8cb01d73  /home/alex/Games/aviutl2/prefix-ge/drive_c/windows/system32/d2d1.dll
465d5cd4d987fe655252895f195e5bbcb3e5fe4c605da0c37b8b7cc4917d64a6  /home/alex/Games/aviutl2/prefix-ge/drive_c/windows/system32/dwrite.dll
MISSING: /home/alex/Games/aviutl2/prefix-ge/drive_c/windows/syswow64/libvkd3d-1.dll
MISSING: /home/alex/Games/aviutl2/prefix-ge/drive_c/windows/syswow64/libvkd3d-shader-1.dll
MISSING: /home/alex/Games/aviutl2/prefix-ge/drive_c/windows/syswow64/libvkd3d-utils-1.dll
29a585ee446115ef18c16ed4c147179ef2cd50ff06bf3d690527eaf872fcccfe  /home/alex/Games/aviutl2/prefix-ge/drive_c/windows/syswow64/wined3d.dll
2e4d86ccba449a146714bfa7541eb6d04382d6478e4fad3991711f625dc1b005  /home/alex/Games/aviutl2/prefix-ge/drive_c/windows/syswow64/d3dcompiler_47.dll
364dccc92b4b4a22b2741e1a17daa5b04a4603a7fb63366ff1759db2b914c9f6  /home/alex/Games/aviutl2/prefix-ge/drive_c/windows/syswow64/d2d1.dll
f786228384f82c686988bbf93a7f13d81c73de204988a1105735ac20591a3999  /home/alex/Games/aviutl2/prefix-ge/drive_c/windows/syswow64/dwrite.dll

############################################################
ROOT: /home/alex/.local/share/Steam/compatibilitytools.d/GE-Proton11-1/files/share/default_pfx
############################################################
551bc022962d011737ed6c5be56ffb1afca8a303681c97a23b16f609664bfde3  /home/alex/.local/share/Steam/compatibilitytools.d/GE-Proton11-1/files/share/default_pfx/drive_c/windows/system32/libvkd3d-1.dll
902b2e9f16e3d1f27f4d7dbafd8cb201548f4800752760922450c0beceb7c24e  /home/alex/.local/share/Steam/compatibilitytools.d/GE-Proton11-1/files/share/default_pfx/drive_c/windows/system32/libvkd3d-shader-1.dll
27b85a8e3162bb502a6fac29e2d433848a08b09b052c8df9ba20e4b48969fe47  /home/alex/.local/share/Steam/compatibilitytools.d/GE-Proton11-1/files/share/default_pfx/drive_c/windows/system32/libvkd3d-utils-1.dll
ae2fb437e8b5a3a2f6ab9a7fec3dbfd0a7680f30b930843556f736bf1fde5455  /home/alex/.local/share/Steam/compatibilitytools.d/GE-Proton11-1/files/share/default_pfx/drive_c/windows/system32/wined3d.dll
3dc7f397651f14ca82bd2eba29f4de6a7e8be229296744f2e4de6fe4ba3aab56  /home/alex/.local/share/Steam/compatibilitytools.d/GE-Proton11-1/files/share/default_pfx/drive_c/windows/system32/d3dcompiler_47.dll
0360a7880b2d7db7720d7520420f7b9bdaa66431629bf2f2e577432c8cb01d73  /home/alex/.local/share/Steam/compatibilitytools.d/GE-Proton11-1/files/share/default_pfx/drive_c/windows/system32/d2d1.dll
0b5954a5bd355cf1975fdbe433829cdd51522e9b6d5b5b3f6ff11c44d7e9ba74  /home/alex/.local/share/Steam/compatibilitytools.d/GE-Proton11-1/files/share/default_pfx/drive_c/windows/system32/dwrite.dll
4fa0d4e39005c83b5d8b6e2cfe1041eb2a8c74f9b15eaa51a368c32371139525  /home/alex/.local/share/Steam/compatibilitytools.d/GE-Proton11-1/files/share/default_pfx/drive_c/windows/syswow64/libvkd3d-1.dll
26ed2e8f6bb3db41e859f70846f9e36ac9fcccd2b8a1d94e7d4bdd66c7a6afa0  /home/alex/.local/share/Steam/compatibilitytools.d/GE-Proton11-1/files/share/default_pfx/drive_c/windows/syswow64/libvkd3d-shader-1.dll
17ec738ba3e73295b8e13c2f5cb10d274b85342f292c0b8914cf51dc851590c6  /home/alex/.local/share/Steam/compatibilitytools.d/GE-Proton11-1/files/share/default_pfx/drive_c/windows/syswow64/libvkd3d-utils-1.dll
29a585ee446115ef18c16ed4c147179ef2cd50ff06bf3d690527eaf872fcccfe  /home/alex/.local/share/Steam/compatibilitytools.d/GE-Proton11-1/files/share/default_pfx/drive_c/windows/syswow64/wined3d.dll
2e4d86ccba449a146714bfa7541eb6d04382d6478e4fad3991711f625dc1b005  /home/alex/.local/share/Steam/compatibilitytools.d/GE-Proton11-1/files/share/default_pfx/drive_c/windows/syswow64/d3dcompiler_47.dll
364dccc92b4b4a22b2741e1a17daa5b04a4603a7fb63366ff1759db2b914c9f6  /home/alex/.local/share/Steam/compatibilitytools.d/GE-Proton11-1/files/share/default_pfx/drive_c/windows/syswow64/d2d1.dll
f786228384f82c686988bbf93a7f13d81c73de204988a1105735ac20591a3999  /home/alex/.local/share/Steam/compatibilitytools.d/GE-Proton11-1/files/share/default_pfx/drive_c/windows/syswow64/dwrite.dll

============================================================
DOSDEVICES
============================================================

=== /home/alex/projects/aviutl2-linux/pfx-ge/pfx/dosdevices ===
c: -> ../drive_c
d:: -> /dev/sdb
e:: -> /dev/sdb1
e: -> /run/media/alex/0C75-3BFD
x: -> /home/alex
z: -> /

=== /home/alex/Games/aviutl2/prefix-ge/dosdevices ===
c: -> ../drive_c
d:: -> /dev/sdb
e:: -> /dev/sdb1
e: -> /run/media/alex/0C75-3BFD
z: -> /

~/projects/aviutl2-linux-patches main*
```

#### 実行結果

コマンド記載またはFish履歴は確認できるが、この履歴だけでは終了状態・生成物を断定できない。出典: `(223).txt timestamp 2026-08-01 00:31:50 +0900`。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、DXVK DLL、Wine DirectWriteまたはpatched runner、Catalog application/config/state、Git working tree、commit、remoteまたはGitHub repository、ログファイル。

#### 関連する固定値

- SHA-256: `fb72fe3da5a2e03665eca298257c18e2d3b98c594b5a5bfd47ee2d5de82bc760`
- SHA-256: `551bc022962d011737ed6c5be56ffb1afca8a303681c97a23b16f609664bfde3`
- SHA-256: `902b2e9f16e3d1f27f4d7dbafd8cb201548f4800752760922450c0beceb7c24e`
- SHA-256: `27b85a8e3162bb502a6fac29e2d433848a08b09b052c8df9ba20e4b48969fe47`
- SHA-256: `ae2fb437e8b5a3a2f6ab9a7fec3dbfd0a7680f30b930843556f736bf1fde5455`
- SHA-256: `e994847e01a6f1e4cbdc5a864616ac262f67ee4f14db194984661a8d927ab7f4`
- SHA-256: `0360a7880b2d7db7720d7520420f7b9bdaa66431629bf2f2e577432c8cb01d73`
- SHA-256: `6d92b541c36f2157be264e5803497ab8f17777c1f575e6704fe3450d00f00e32`
- SHA-256: `4fa0d4e39005c83b5d8b6e2cfe1041eb2a8c74f9b15eaa51a368c32371139525`
- SHA-256: `26ed2e8f6bb3db41e859f70846f9e36ac9fcccd2b8a1d94e7d4bdd66c7a6afa0`
- SHA-256: `17ec738ba3e73295b8e13c2f5cb10d274b85342f292c0b8914cf51dc851590c6`
- SHA-256: `29a585ee446115ef18c16ed4c147179ef2cd50ff06bf3d690527eaf872fcccfe`
- SHA-256: `efbdbbcd0d954f8fdc53467de5d89ad525e4e4a9cfff8a15d07c6fdb350c407f`
- SHA-256: `364dccc92b4b4a22b2741e1a17daa5b04a4603a7fb63366ff1759db2b914c9f6`
- SHA-256: `f786228384f82c686988bbf93a7f13d81c73de204988a1105735ac20591a3999`
- SHA-256: `4432bbd1a390874f3f0a503d45cc48d346abc3a8c0213c289f4b615bf0ee84f3`
- SHA-256: `465d5cd4d987fe655252895f195e5bbcb3e5fe4c605da0c37b8b7cc4917d64a6`
- SHA-256: `2e4d86ccba449a146714bfa7541eb6d04382d6478e4fad3991711f625dc1b005`
- SHA-256: `3dc7f397651f14ca82bd2eba29f4de6a7e8be229296744f2e4de6fe4ba3aab56`
- SHA-256: `0b5954a5bd355cf1975fdbe433829cdd51522e9b6d5b5b3f6ff11c44d7e9ba74`
- commit: `5ea4cc690545c6eae692f7d893b3d759a2b61ef0`
- commit: `228645035128f09451089834916b039208f5f656`
- 短縮commit: `c0000135`
- 短縮commit: `499859021`
- 短縮commit: `681486576`
- 短縮commit: `1342317427`
- 短縮commit: `430510991`
- 短縮commit: `980826847`
- 短縮commit: `2148434090`
- 短縮commit: `453585105`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。

#### 採用可否

```text
要追加確認
```

#### 証拠位置

`Fish history reconstructed in (223).txt; timestamp 2026-08-01 00:31:50 +0900`

---
# Part III — 読み取り専用監査・再現ビルド失敗・補助script

### コマンド 294 — `V224-01`

#### 目的

保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
  set ROOT \
          "$HOME/Games/aviutl2"

  set PREFIX \
          "$ROOT/prefix"

  set GE_PREFIX \
          "$ROOT/prefix-ge"

  set DXVK_SRC \
          "$ROOT/src/dxvk-2.7.1-aviutl2"

  set DXVK_OUT \
          "$ROOT/runtime/dxvk-2.7.1-aviutl2"

  set LUTRIS_WINE_CFG \
          "$HOME/.local/share/lutris/runners/wine.yml"

  set LUTRIS_GAMES \
          "$HOME/.config/lutris/games"

      set resolved \
                                                                                         (command -s "$command" 2>/dev/null)

      set path \
                                                                                             "$PREFIX/$relative"

  set TRANSFERRED_DLLS \
          d3d11.dll \
          dxgi.dll \
          d3d10core.dll \
          d3dcompiler_47.dll

  set LUTRIS_CFG_FILES

      set LUTRIS_CFG_FILES \
                  (find \
                          (dirname "$LUTRIS_WINE_CFG") \
                          -maxdepth 1 \
                          -type f \
                          -name 'wine.yml*' \
                          -print \
                          | sort)

      set GAME_CONFIGS \
                  (grep \
                          -RIlE \
                          'aviutl2|Games/aviutl2|prefix-ge|/prefix($|/)' \
                          "$LUTRIS_GAMES" \
                          2>/dev/null)

GIT_OPTIONAL_LOCKS=0
```

#### 実行コマンド

```fish
# ============================================================
  # AviUtl2 system-Wine prefix forensic collection
  # READ-ONLY: Wine / wineserver / winebootは実行しない
  # ============================================================

  set ROOT \
          "$HOME/Games/aviutl2"

  set PREFIX \
          "$ROOT/prefix"

  set GE_PREFIX \
          "$ROOT/prefix-ge"

  set DXVK_SRC \
          "$ROOT/src/dxvk-2.7.1-aviutl2"

  set DXVK_OUT \
          "$ROOT/runtime/dxvk-2.7.1-aviutl2"

  set LUTRIS_WINE_CFG \
          "$HOME/.local/share/lutris/runners/wine.yml"

  set LUTRIS_GAMES \
          "$HOME/.config/lutris/games"

  echo
  echo "============================================================"
  echo "1. COMPLETE FISH HISTORY: 2026-07-30 19:45–21:15 JST"
  echo "============================================================"

  history search \
              --show-time="%s|" \
              --null \
              --reverse \
              --max=200000 \
          | python3 -c '
  import sys
  from datetime import datetime
  from zoneinfo import ZoneInfo

  tz = ZoneInfo("Asia/Tokyo")

  start = datetime(
      2026, 7, 30, 19, 45, 0, tzinfo=tz
  ).timestamp()

  end = datetime(
      2026, 7, 30, 21, 15, 59, tzinfo=tz
  ).timestamp()

                                                                              records = []

                                                                               for raw in sys.stdin.buffer.read().split(b"\0"):
                                               if not raw:
          continue

                                                                               try:
          raw_timestamp, raw_command = raw.split(b"|", 1)
                                            timestamp = int(raw_timestamp)
                                                         except (ValueError, TypeError):
          continue

                                                                               if not start <= timestamp <= end:
          continue

                                                                               command = raw_command.decode(
          "utf-8",
                                                                                   errors="replace",
                                                                      )

      records.append((timestamp, command))

  for timestamp, command in records:
      stamp = datetime.fromtimestamp(
          timestamp,
          tz,
                                                                                    ).strftime("%Y-%m-%d %H:%M:%S %z")

      print(f"\n--- {stamp} ---")
                                                                print(command)
                                                                         '

                                                                                          echo
                                                                                       echo "============================================================"
  echo "2. SYSTEM WINE RESOLUTION"
                                                           echo "============================================================"

  for command in \
                                                                                       wine \
                                                                                     wineserver \
              wineboot \
                                                                                 winetricks

      echo
                                                                                       echo "=== $command ==="

      set resolved \
                                                                                         (command -s "$command" 2>/dev/null)

      if test -n "$resolved"
                                                                         echo "command=$resolved"
                                                                   realpath "$resolved" 2>/dev/null
          or true

          pacman -Qo "$resolved" 2>/dev/null
                                                         or true

          stat \
                                                                                                     --printf='type=%F\nbirth=%w\nmtime=%y\nctime=%z\nsize=%s\ninode=%i\n' \
                          "$resolved" \
                                                                              2>/dev/null
                                                                or true
                                                                                else
          echo "NOT FOUND"
                                                                       end
                                                                                    end

                                                                                        echo
                                                                                       echo "=== INSTALLED WINE PACKAGES ==="

                                                     pacman -Q \
                                                                                        | grep -Ei \
                                                                                   '^(wine|wine-staging|wine-mono|wine-gecko|winetricks)( |$)'
  or true

                                                                                    echo
                                                                                       echo "=== PACMAN HISTORY AROUND WINE ==="

                                                  grep -Ei \
                                                                                         'wine|winetricks|dxvk' \
                                                                   /var/log/pacman.log \
          2>/dev/null \
                                                                              | grep -E \
              '2026-07-(29|30|31)'
                                                           or true

  echo
  echo "============================================================"
  echo "3. SYSTEM PREFIX METADATA"
  echo "============================================================"

  for relative in \
              . \
              user.reg \
                                                                                 system.reg \
              userdef.reg \
                                                                              drive_c \
              drive_c/windows \
                                                                          drive_c/windows/system32 \
              drive_c/windows/syswow64 \
                                                                 drive_c/AviUtl2 \
              drive_c/AviUtl2/aviutl2.exe \
                                                              drive_c/ProgramData \
              drive_c/ProgramData/aviutl2

      set path \
                                                                                             "$PREFIX/$relative"

                                                            if test -e "$path"
          stat \
                                                                                                     --printf='path=%n|type=%F|birth=%w|mtime=%y|ctime=%z|size=%s|inode=%i\n' \                                                                                                            "$path"
      else
                                                                                           echo "MISSING: $path"
      end
                                                                                    end

                                                                                        echo
  echo "============================================================"
                        echo "4. AVIUTL2 FILE PROVENANCE"
  echo "============================================================"

  if test -d "$PREFIX/drive_c/AviUtl2"
      find \
                  "$PREFIX/drive_c/AviUtl2" \
                  -maxdepth 2 \
                  -type f \
                  -printf '%TY-%Tm-%Td %TH:%TM:%TS|%s|%p\n' \
                                                | sort \
                  | head -n 200
                                                              else
      echo "MISSING: $PREFIX/drive_c/AviUtl2"
                                                end

                                                                                        echo
  echo "=== AVIUTL2 EXECUTABLE ==="

  if test -f "$PREFIX/drive_c/AviUtl2/aviutl2.exe"
      file \
                                                                                                 "$PREFIX/drive_c/AviUtl2/aviutl2.exe"

                                          sha256sum \
                  "$PREFIX/drive_c/AviUtl2/aviutl2.exe"
                                      end

                                                                                        echo
  echo "=== OTHER AVIUTL2.EXE COPIES ==="

  find \
                                                                                             "$HOME/Downloads" \
          "$HOME/Games" \
          "$HOME/projects" \
                                                                         -type f \
                                                                                  -iname aviutl2.exe \
          -printf '%TY-%Tm-%Td %TH:%TM:%TS|%s|%p\n' \
                                                2>/dev/null \
                                                                              | sort
  or true

                                                                                    echo
  echo "=== LIKELY ARCHIVES OR INSTALLERS ==="

                                               find \
          "$HOME/Downloads" \
                                                                        "$HOME/Games/aviutl2" \
                                                                    -maxdepth 5 \
          -type f \
          \( \
              -iname '*aviutl2*.zip' \
              -o -iname '*aviutl2*.7z' \
              -o -iname '*aviutl2*.rar' \
              -o -iname '*aviutl2*.exe' \
          \) \
          -printf '%TY-%Tm-%Td %TH:%TM:%TS|%s|%p\n' \
          2>/dev/null \
          | sort
  or true

  echo
  echo "============================================================"
  echo "5. DXVK SOURCE AND BUILD METADATA"
  echo "============================================================"

  for path in \
              "$DXVK_SRC" \
              "$DXVK_SRC/.git" \
              "$DXVK_SRC/build.w64" \
              "$DXVK_SRC/build-win64.txt" \
              "$DXVK_OUT" \
              "$DXVK_OUT/bin/d3d11.dll" \
              "$DXVK_OUT/bin/dxgi.dll" \
              "$DXVK_OUT/bin/d3d10core.dll"

      echo
                                                                                       echo "=== $path ==="

      if test -e "$path"
          stat \
                          --printf='type=%F\nbirth=%w\nmtime=%y\nctime=%z\nsize=%s\ninode=%i\n' \
                          "$path"
      else
          echo "MISSING"
      end
                                                                                    end

  if test -d "$DXVK_SRC/.git"
      echo
      echo "=== DXVK GIT STATE ==="

      env GIT_OPTIONAL_LOCKS=0 \
                  git -C "$DXVK_SRC" \
                  status \
                  --short \
                  --branch

      env GIT_OPTIONAL_LOCKS=0 \
                  git -C "$DXVK_SRC" \
                  log \
                  -n 10 \
                  --date=iso-strict \
                  --format='commit=%H%ndate=%cI%nsubject=%s'
  end

  echo
  echo "============================================================"
  echo "6. TRANSFERRED DLL COMPARISON"
  echo "============================================================"

  set TRANSFERRED_DLLS \
          d3d11.dll \
          dxgi.dll \
          d3d10core.dll \
          d3dcompiler_47.dll

  for dll in $TRANSFERRED_DLLS
      echo
      echo "############################################################"
      echo "DLL: $dll"
      echo "############################################################"

      for path in \
                      "$PREFIX/drive_c/windows/system32/$dll" \
                      "$GE_PREFIX/drive_c/windows/system32/$dll" \
                      "$DXVK_OUT/bin/$dll"

          if test -f "$path"
              stat \
                                  --printf='path=%n|birth=%w|mtime=%y|ctime=%z|size=%s|inode=%i\n' \
                                  "$path"

              sha256sum \
                                  "$path"
          else
              echo "MISSING: $path"
          end
      end
  end

  echo
  echo "============================================================"
  echo "7. SYSTEM PREFIX DOSDEVICES"
  echo "============================================================"

  if test -d "$PREFIX/dosdevices"
      find \
                  "$PREFIX/dosdevices" \
                  -maxdepth 1 \
                  -type l \
                  -printf '%f -> %l\n' \
                  | sort
  else
      echo "MISSING: $PREFIX/dosdevices"
  end

  echo
  echo "============================================================"
  echo "8. LUTRIS GLOBAL WINE CONFIG"
  echo "============================================================"

  set LUTRIS_CFG_FILES

  if test -d (dirname "$LUTRIS_WINE_CFG")
      set LUTRIS_CFG_FILES \
                  (find \
                          (dirname "$LUTRIS_WINE_CFG") \
                          -maxdepth 1 \
                          -type f \
                          -name 'wine.yml*' \
                          -print \
                          | sort)
  end

  if test (count $LUTRIS_CFG_FILES) -eq 0
      echo "NO wine.yml FILES"
  else
      for path in $LUTRIS_CFG_FILES
          echo
          echo "=== $path ==="

          stat \
                          --printf='birth=%w\nmtime=%y\nctime=%z\nsize=%s\ninode=%i\n' \
                          "$path"

          sha256sum \
                          "$path"

          sed -n \
                          '1,300p' \
                          "$path"
      end
  end

  echo
  echo "============================================================"
  echo "9. LUTRIS GAME CONFIGS REFERENCING AVIUTL2"
  echo "============================================================"

  if test -d "$LUTRIS_GAMES"
      set GAME_CONFIGS \
                  (grep \
                          -RIlE \
                          'aviutl2|Games/aviutl2|prefix-ge|/prefix($|/)' \
                          "$LUTRIS_GAMES" \
                          2>/dev/null)

      if test (count $GAME_CONFIGS) -eq 0
          echo "NO MATCHING LUTRIS GAME CONFIG"
      else
          for path in $GAME_CONFIGS
              echo
              echo "=== $path ==="

              stat \
                                  --printf='birth=%w\nmtime=%y\nctime=%z\nsize=%s\ninode=%i\n' \
                                  "$path"

              sha256sum \
                                  "$path"

              sed -n \
                                  '1,360p' \
                                  "$path"
          end
      end
  else
      echo "MISSING: $LUTRIS_GAMES"
  end

  echo
  echo "============================================================"
  echo "END OF READ-ONLY COLLECTION"
  echo "============================================================"
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(224).txt:2-403` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

読み取り専用監査。ファイル変更なしとコマンド内で明示されているものを含む。

#### 関連する固定値

- version: `2.7.1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/lutris/runners/wine.yml`
- path: `$HOME/.config/lutris/games`
- path: `$HOME/Downloads`
- path: `$HOME/Games`
- path: `$HOME/projects`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(224).txt lines 2-403`

---
### コマンド 295 — `V225-01`

#### 目的

保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
  set ROOT \
          "$HOME/Games/aviutl2"

  set REPO \
          "$HOME/projects/aviutl2-linux-patches"

  set BASE_PREFIX \
          "$ROOT/prefix-ge"

  set TEST_PREFIX \
          "$ROOT/prefix-ge-nvdec-test"

  set GE_ORIG \
          "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

  set GE_TEST \
          "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

  set WINE_SRC \
          "$ROOT/src/wine-ge11-1-dwrite"

  set WINE_BUILD \
          "$ROOT/build/wine-ge11-1-dwrite"

  set DXVK_SRC \
          "$ROOT/src/dxvk-2.7.1-aviutl2"

  set DXVK_RUNTIME \
          "$ROOT/runtime/dxvk-2.7.1-aviutl2"

  set LSW_SRC \
          "$ROOT/src/L-SMASH-Works-nvdec"

  set EXPORT \
          "$ROOT/export/aviutl2-known-good"

  set IMPORT \
          "$ROOT/import/aviutl2-known-good"

  set ARCHIVE \
          "$HOME/Downloads/aviutl2-known-good.tar.zst"

      set -l path "$argv[1]"

      set -l path "$argv[1]"

      set -l left "$argv[1]"

      set -l right "$argv[2]"

  set ORIG_DWRITE_DLL \
          "$GE_ORIG/files/lib/wine/x86_64-windows/dwrite.dll"

  set ORIG_DWRITE_SO \
          "$GE_ORIG/files/lib/wine/x86_64-unix/dwrite.so"

  set TEST_DWRITE_DLL \
          "$GE_TEST/files/lib/wine/x86_64-windows/dwrite.dll"

  set TEST_DWRITE_SO \
          "$GE_TEST/files/lib/wine/x86_64-unix/dwrite.so"

  set BUILD_DWRITE_DLL \
          "$WINE_BUILD/dlls/dwrite/x86_64-windows/dwrite.dll"

  set BUILD_DWRITE_SO \
          "$WINE_BUILD/dlls/dwrite/dwrite.so"

  set DWRITE_SEARCH_ROOTS

                                                                             set -a DWRITE_SEARCH_ROOTS "$root"

                        set WINE_LAYOUT \
          "$WINE_SRC/dlls/dwrite/layout.c"

  set WINE_BASELINES

      set WINE_BASELINES \
                  (find \
                          "$WINE_SRC/dlls/dwrite" \
                          -maxdepth 1 \
                          -type f \
                          -name 'layout.c.before-hittest-range-*' \
                          -print \
                          | sort)

      set WINE_BASELINE \
                  "$WINE_BASELINES[1]"

  set LSW_SEARCH_ROOTS

          set -a LSW_SEARCH_ROOTS "$root"

  set DXVK_SEARCH_ROOTS

          set -a DXVK_SEARCH_ROOTS "$root"

      set plugin_dir \
                  "$prefix/drive_c/ProgramData/aviutl2/Plugin"

  set CATALOG_SEARCH_ROOTS

          set -a CATALOG_SEARCH_ROOTS "$root"

GIT_OPTIONAL_LOCKS=0
```

#### 実行コマンド

```fish
# ============================================================
  # AviUtl2 final known-good environment forensic collection
  # STRICTLY READ-ONLY
  #
  # 実行しないもの:
  #   wine / wineserver / wineboot / winetricks
  #   AviUtl2 / Catalog
  #   cp / mv / rm / install / sed -i / git checkout
  # ============================================================

  set ROOT \
          "$HOME/Games/aviutl2"

  set REPO \
          "$HOME/projects/aviutl2-linux-patches"

  set BASE_PREFIX \
          "$ROOT/prefix-ge"

  set TEST_PREFIX \
          "$ROOT/prefix-ge-nvdec-test"

  set GE_ORIG \
          "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

  set GE_TEST \
          "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

  set WINE_SRC \
          "$ROOT/src/wine-ge11-1-dwrite"

  set WINE_BUILD \
          "$ROOT/build/wine-ge11-1-dwrite"

  set DXVK_SRC \
          "$ROOT/src/dxvk-2.7.1-aviutl2"

  set DXVK_RUNTIME \
          "$ROOT/runtime/dxvk-2.7.1-aviutl2"

  set LSW_SRC \
          "$ROOT/src/L-SMASH-Works-nvdec"

  set EXPORT \
          "$ROOT/export/aviutl2-known-good"

  set IMPORT \
          "$ROOT/import/aviutl2-known-good"

  set ARCHIVE \
          "$HOME/Downloads/aviutl2-known-good.tar.zst"

  function show_path
      set -l path "$argv[1]"

      echo
      echo "=== $path ==="

      if test -e "$path"
          stat \
                          --printf='type=%F\nbirth=%w\nmtime=%y\nctime=%z\nsize=%s\ninode=%i\n' \
                          "$path"

          readlink -f \
                          "$path" \
                          2>/dev/null
          or true
      else
          echo "MISSING"
      end
  end

  function show_file
      set -l path "$argv[1]"

      echo
      echo "=== $path ==="

      if test -f "$path"
          stat \
                          --printf='birth=%w\nmtime=%y\nctime=%z\nsize=%s\ninode=%i\n' \
                          "$path"

          file \
                          -- "$path"

          sha256sum \
                          -- "$path"
      else
          echo "MISSING"
      end
  end

  function compare_files
      set -l left "$argv[1]"
      set -l right "$argv[2]"

      echo
      echo "COMPARE:"
      echo "  LEFT:  $left"
      echo "  RIGHT: $right"

      if not test -f "$left"
          echo "RESULT: LEFT MISSING"
      else if not test -f "$right"
          echo "RESULT: RIGHT MISSING"
      else if cmp -s -- "$left" "$right"
          echo "RESULT: IDENTICAL"
      else
          echo "RESULT: DIFFERENT"
      end
  end

  echo
  echo "============================================================"
  echo "1. PRIMARY ROOT METADATA"
  echo "============================================================"

  for path in \
              "$BASE_PREFIX" \
              "$TEST_PREFIX" \
              "$GE_ORIG" \
              "$GE_TEST" \
              "$WINE_SRC" \
              "$WINE_BUILD" \
              "$DXVK_SRC" \
              "$DXVK_RUNTIME" \
              "$LSW_SRC" \
              "$EXPORT" \
              "$IMPORT"

      show_path "$path"
  end

  echo
  echo "=== TEST PREFIX AND BACKUPS ==="

  find \
          "$ROOT" \
          -maxdepth 1 \
          -type d \
          -name 'prefix-ge-nvdec-test*' \
          -printf '%T@|%TY-%Tm-%Td %TH:%TM:%TS|%p\n' \
          2>/dev/null \
          | sort -n
  or true

  echo
  echo "============================================================"
  echo "2. DWRITE CURRENT FILE MATRIX"
  echo "============================================================"

  set ORIG_DWRITE_DLL \
          "$GE_ORIG/files/lib/wine/x86_64-windows/dwrite.dll"

  set ORIG_DWRITE_SO \
          "$GE_ORIG/files/lib/wine/x86_64-unix/dwrite.so"

  set TEST_DWRITE_DLL \
          "$GE_TEST/files/lib/wine/x86_64-windows/dwrite.dll"

  set TEST_DWRITE_SO \
          "$GE_TEST/files/lib/wine/x86_64-unix/dwrite.so"

  set BUILD_DWRITE_DLL \
          "$WINE_BUILD/dlls/dwrite/x86_64-windows/dwrite.dll"

  set BUILD_DWRITE_SO \
          "$WINE_BUILD/dlls/dwrite/dwrite.so"

  for path in \
              "$ORIG_DWRITE_DLL" \
                                                                       "$ORIG_DWRITE_SO" \
                                                                        "$TEST_DWRITE_DLL" \
                                                                       "$TEST_DWRITE_SO" \
              "$BUILD_DWRITE_DLL" \
              "$BUILD_DWRITE_SO" \
              "$ROOT/backups/GE-Proton11-1-dwrite-original.dll"

      show_file "$path"
                                                                      end

  compare_files \
                                                                                    "$ORIG_DWRITE_DLL" \
                                                                       "$TEST_DWRITE_DLL"

                                                                 compare_files \
                                                                                    "$ORIG_DWRITE_SO" \
          "$TEST_DWRITE_SO"

                                                                  compare_files \
          "$TEST_DWRITE_DLL" \
                                                                       "$BUILD_DWRITE_DLL"

  compare_files \
                                                                                    "$TEST_DWRITE_SO" \
                                                                        "$BUILD_DWRITE_SO"

                                                                 echo
                                                                                       echo "============================================================"
  echo "3. ALL DWRITE COPIES AND BACKUPS"
                                                    echo "============================================================"

  set DWRITE_SEARCH_ROOTS

                                                                    for root in \
              "$GE_ORIG" \
                                                                               "$GE_TEST" \
                                                                               "$WINE_BUILD" \
              "$ROOT/backups" \
                                                                          "$EXPORT" \
                                                                                "$IMPORT"

                                                                          if test -e "$root"
                                                                             set -a DWRITE_SEARCH_ROOTS "$root"
      end
  end

  if test (count $DWRITE_SEARCH_ROOTS) -gt 0
      find \
                                                                                                 $DWRITE_SEARCH_ROOTS \
                  -type f \
                                                                                  \( \
                      -name 'dwrite.dll' \
                                                                       -o -name 'dwrite.so' \
                      -o -name 'dwrite.dll.before-*' \
                                                           -o -name 'dwrite.so.before-*' \
                      -o -name 'dwrite.dll.backup-*' \
                                                           -o -name 'dwrite.so.backup-*' \
                      -o -name '*dwrite-original*.dll' \
                                                     \) \
                  -print0 \
                                                                                  2>/dev/null \
                  | sort -z \
                                                                                | while read -z path
          show_file "$path"
                                                                      end
  end

  echo
                                                                                       echo "============================================================"
  echo "4. DWRITE SOURCE AND PATCH STATE"
                                                    echo "============================================================"

                        set WINE_LAYOUT \
          "$WINE_SRC/dlls/dwrite/layout.c"

  show_file "$WINE_LAYOUT"

  echo
                                                                                       echo "=== WINE SOURCE BACKUPS ==="

                                                         if test -d "$WINE_SRC/dlls/dwrite"
      find \
                  "$WINE_SRC/dlls/dwrite" \
                  -maxdepth 1 \
                                                                              -type f \
                  -name 'layout.c.before-*' \
                                                                -printf '%T@|%TY-%Tm-%Td %TH:%TM:%TS|%s|%p\n' \
                  | sort -n
  end

  echo
  echo "=== CURRENT HitTestTextRange() ==="

  if test -f "$WINE_LAYOUT"
                                                                      grep \
                  -n \
                                                                                       -A140 \
                  'static HRESULT WINAPI dwritetextlayout_HitTestTextRange' \
                                "$WINE_LAYOUT" \
                  | sed -n '1,180p'
                                                              or true
  end

  echo
  echo "=== CURRENT HitTestPoint() ==="

  if test -f "$WINE_LAYOUT"
                                                                      grep \
                  -n \
                                                                                       -A180 \
                  'static HRESULT WINAPI dwritetextlayout_HitTestPoint' \
                                    "$WINE_LAYOUT" \
                  | sed -n '1,220p'
                                                              or true
  end

  echo
                                                                                       echo "=== WINE PATCH FILES ==="

                                                            if test -d "$REPO/patches/wine"
      find \
                                                                                                 "$REPO/patches/wine" \
                  -maxdepth 1 \
                  -type f \
                  -name '*.patch' \
                  -print0 \
                  | sort -z \
                  | while read -z patch
          show_file "$patch"

          grep \
                              -nE \
                              'HitTestTextRange|HitTestPoint|HitTestTextPosition|E_NOTIMPL|E_FAIL|isTrailingHit' \
                              "$patch" \
                              | head -n 240
          or true
      end
  end

  set WINE_BASELINES

  if test -d "$WINE_SRC/dlls/dwrite"
      set WINE_BASELINES \
                  (find \
                          "$WINE_SRC/dlls/dwrite" \
                          -maxdepth 1 \
                          -type f \
                          -name 'layout.c.before-hittest-range-*' \
                          -print \
                          | sort)
  end

  if test (count $WINE_BASELINES) -gt 0
      set WINE_BASELINE \
                  "$WINE_BASELINES[1]"

      echo
      echo "=== BASELINE VS CURRENT LAYOUT DIFF ==="
      echo "BASELINE: $WINE_BASELINE"

      diff \
                  -u \
                  -- "$WINE_BASELINE" "$WINE_LAYOUT" \
                  | sed -n '1,700p'
      or true
  else
      echo "NO Hittest-range baseline found"
  end

  echo
  echo "============================================================"
  echo "5. SOURCE REPOSITORY STATES"
  echo "============================================================"

  for repo in \
              "$REPO" \
              "$DXVK_SRC" \
              "$LSW_SRC"

      echo
      echo "############################################################"
      echo "REPOSITORY: $repo"
      echo "############################################################"

      if test -d "$repo/.git"
          env GIT_OPTIONAL_LOCKS=0 \
                          git -C "$repo" \
                          status \
                          --short \
                          --branch

          echo
          echo "HEAD:"

          env GIT_OPTIONAL_LOCKS=0 \
                          git -C "$repo" \
                          log \
                          -n 8 \
                          --date=iso-strict \
                          --format='commit=%H%ndate=%cI%nsubject=%s'

          echo
          echo "DIFF STAT:"

          env GIT_OPTIONAL_LOCKS=0 \
                          git -C "$repo" \
                                                                           diff \
                                                                                     --stat

                                                                     echo
          echo "STAGED DIFF STAT:"

                                                                   env GIT_OPTIONAL_LOCKS=0 \
                          git -C "$repo" \
                                                                           diff \
                          --cached \
                                                                                 --stat
                                                                 else
          echo "NOT A GIT REPOSITORY"
                                                            end
  end

  echo
  echo "=== L-SMASH PATCHED COMMIT ==="

                                                      if test -d "$LSW_SRC/.git"
                                                                     env GIT_OPTIONAL_LOCKS=0 \
                  git -C "$LSW_SRC" \
                                                                        show \
                  --stat \
                                                                                   --oneline \
                                                                                --decorate \
                  393df5e \
                                                                                  2>/dev/null
      or true
                                                                                end

  echo
                                                                                       echo "============================================================"
  echo "6. L-SMASH WORKS FILE PROVENANCE"
  echo "============================================================"

  set LSW_SEARCH_ROOTS

                                                                       for root in \
                                                                                          "$BASE_PREFIX" \
              "$TEST_PREFIX" \
                                                                           "$ROOT/backups" \
              "$ROOT/export" \
                                                                           "$ROOT/import" \
                                                                           "$LSW_SRC"

                                                                         if test -e "$root"
          set -a LSW_SEARCH_ROOTS "$root"
                                                        end
                                                                                    end

                                                                                        if test (count $LSW_SEARCH_ROOTS) -gt 0
      find \
                  $LSW_SEARCH_ROOTS \
                  -type f \
                  \( \
                      -iname 'lwinput.aui2' \
                                                                    -o -iname 'lwinput.aui' \
                                                                  -o -iname 'lwinput.aui2.before-*' \
                      -o -iname 'lsmash.ini' \
                                                                   -o -iname 'lsmash.ini.before-*' \
                  \) \
                                                                                       -print0 \
                                                                                  2>/dev/null \
                  | sort -z \
                                                                                | while read -z path
          show_file "$path"

          switch (string lower -- (basename "$path"))
              case 'lwinput.aui2' 'lwinput.aui' 'lwinput.aui2.before-*'
                  echo "-- binary markers --"

                  strings \
                                              "$path" \
                                              | grep -Ei \
                                                  'av1_cuvid|nvcuvid|nvcuda|libdav1d|av_hwframe_transfer_data|L-SMASH' \
                                              | sort -u \
                                              | head -n 120
                  or true

              case 'lsmash.ini' 'lsmash.ini.before-*'
                  echo "-- ini contents --"

                  sed \
                                              -n \
                                              '1,260p' \
                                              "$path"
          end
      end
  end

  echo
  echo "=== EXPECTED ACTIVE L-SMASH FILES ==="

  for path in \
              "$TEST_PREFIX/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2" \
              "$TEST_PREFIX/drive_c/ProgramData/aviutl2/Plugin/lsmash.ini" \
              "$TEST_PREFIX/drive_c/ProgramData/aviutl2/Plugin/L-SMASH-Works/lwinput.aui2" \
              "$TEST_PREFIX/drive_c/ProgramData/aviutl2/Plugin/L-SMASH-Works/lsmash.ini" \
              "$LSW_SRC/AviUtl2/lwinput.aui2" \
              "$EXPORT/plugin/lwinput.aui2" \
              "$EXPORT/plugin/lsmash.ini" \
              "$IMPORT/plugin/lwinput.aui2" \
              "$IMPORT/plugin/lsmash.ini"

      show_file "$path"
  end

  compare_files \
          "$TEST_PREFIX/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2" \
          "$LSW_SRC/AviUtl2/lwinput.aui2"

  compare_files \
          "$TEST_PREFIX/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2" \
          "$EXPORT/plugin/lwinput.aui2"

  compare_files \
          "$TEST_PREFIX/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2" \
          "$IMPORT/plugin/lwinput.aui2"

  echo
  echo "============================================================"
  echo "7. DXVK DLL PROVENANCE"
  echo "============================================================"

  set DXVK_SEARCH_ROOTS

  for root in \
              "$BASE_PREFIX" \
              "$TEST_PREFIX" \
              "$ROOT"/prefix-ge-nvdec-test.backup-* \
              "$ROOT/export" \
              "$ROOT/import" \
              "$DXVK_SRC" \
              "$DXVK_RUNTIME"

      if test -e "$root"
          set -a DXVK_SEARCH_ROOTS "$root"
      end
  end

  if test (count $DXVK_SEARCH_ROOTS) -gt 0
      find \
                  $DXVK_SEARCH_ROOTS \
                  -type f \
                  \( \
                      -iname 'd3d11.dll' \
                      -o -iname 'dxgi.dll' \
                      -o -iname 'd3d10core.dll' \
                  \) \
                  -print0 \
                  2>/dev/null \
                  | sort -z \
                  | while read -z path
          show_file "$path"

          if test (string lower -- (basename "$path")) = d3d11.dll
              echo "-- AviUtl2 marker strings --"

              strings \
                                      "$path" \
                                      | grep -E \
                                          'AviUtl2 compatibility|AviUtl2 trace|format 69' \

                                      | head -n 80
              or true
          end
      end
  end

  echo
  echo "=== CURRENT SYSTEM32 DLLS ==="

  for prefix in \
              "$BASE_PREFIX" \
              "$TEST_PREFIX"

      echo
      echo "PREFIX: $prefix"

      for dll in \
                      d3d11.dll \
                      dxgi.dll \
                      d3d10core.dll \
                      d3dcompiler_47.dll

          show_file \
                          "$prefix/drive_c/windows/system32/$dll"
      end
  end

  echo
  echo "=== TEST PREFIX VS EXPORT ==="

  for dll in \
              d3d11.dll \
              dxgi.dll \
              d3d10core.dll

      compare_files \
                  "$TEST_PREFIX/drive_c/windows/system32/$dll" \
                  "$EXPORT/dxvk/$dll"
  end

  echo
  echo "=== TEST PREFIX VS IMPORT ==="

  for dll in \
              d3d11.dll \
              dxgi.dll \
              d3d10core.dll

      compare_files \
                  "$TEST_PREFIX/drive_c/windows/system32/$dll" \
                  "$IMPORT/dxvk/$dll"
  end

  echo
  echo "=== NVIDIA DXVK CONFIG ==="

  for path in \
              "$ROOT/nvidia-dxvk.conf" \
              "$EXPORT/config/nvidia-dxvk.conf" \
              "$IMPORT/config/nvidia-dxvk.conf"

      show_file "$path"

      if test -f "$path"
          sed \
                          -n \
                          '1,220p' \
                          "$path"
      end
  end

  echo
  echo "============================================================"
  echo "8. PREFIX REGISTRY STATE WITHOUT WINE"
  echo "============================================================"

  for prefix in \
              "$BASE_PREFIX" \
              "$TEST_PREFIX"

      echo
      echo "############################################################"
      echo "PREFIX: $prefix"
      echo "############################################################"

      for reg in \
                      "$prefix/user.reg" \
                      "$prefix/system.reg"

          echo
          echo "=== $reg ==="

          if test -f "$reg"
              grep \
                                  -n \
                                  -A24 \
                                  -B3 \
                                  -E \
                                  'DllOverrides|nvcuda|nvcuvid|nvencodeapi64|InputStyle|Software\\\\Wine\\\\Drivers|Fonts\\\\Replacements|Tahoma|MS UI Gothic|Segoe UI' \
                                  "$reg" \
                                  | head -n 700
              or true
          else
              echo "MISSING"
          end
      end
  end

  echo
  echo "============================================================"
  echo "9. PLUGIN DIRECTORY CURRENT STATE"
  echo "============================================================"

  for prefix in \
              "$BASE_PREFIX" \
              "$TEST_PREFIX"

      set plugin_dir \
                  "$prefix/drive_c/ProgramData/aviutl2/Plugin"

      echo
      echo "############################################################"
      echo "PLUGIN ROOT: $plugin_dir"
      echo "############################################################"

      if test -d "$plugin_dir"
          find \
                          "$plugin_dir" \
                          -maxdepth 3 \
                          -type f \
                          -printf '%TY-%Tm-%Td %TH:%TM:%TS|%s|%p\n' \
                          | sort \
                          | sed -n '1,600p'
      else
          echo "MISSING"
      end
  end

  echo
  echo "============================================================"
  echo "10. AVIUTL2 CATALOG STATE"
  echo "============================================================"

  set CATALOG_SEARCH_ROOTS

  for root in \
              "$BASE_PREFIX" \
              "$TEST_PREFIX" \
              "$ROOT"/prefix-ge-nvdec-test.backup-* \
              "$ROOT/tools/aviutl2-catalog"

      if test -e "$root"
          set -a CATALOG_SEARCH_ROOTS "$root"
      end
  end

  if test (count $CATALOG_SEARCH_ROOTS) -gt 0
      find \
                  $CATALOG_SEARCH_ROOTS \
                  -type f \
                  \( \
                      -iname 'AviUtl2_Catalog.exe' \
                      -o -iname 'aviutl2-catalog.exe' \
                      -o -iname 'settings.json' \
                      -o -iname '*catalog*setup*.exe' \
                  \) \
                  -print0 \
                  2>/dev/null \
                  | sort -z \
                  | while read -z path
          show_file "$path"

          if test (string lower -- (basename "$path")) = settings.json
              echo "-- settings.json --"

              sed \
                                      -n \
                                      '1,320p' \
                                      "$path"
          end
      end
  end

  echo
  echo "============================================================"
  echo "11. EXPORT AND IMPORT STRUCTURE"
  echo "============================================================"

  for root in \
              "$EXPORT" \
              "$IMPORT"

      echo
      echo "############################################################"
      echo "ROOT: $root"
      echo "############################################################"

      if test -d "$root"
          find \
                          "$root" \
                          -maxdepth 4 \
                          -printf '%y|%TY-%Tm-%Td %TH:%TM:%TS|%s|%p\n' \
                          | sort \
                          | sed -n '1,700p'
      else
          echo "MISSING"
      end
  end

  echo
  echo "=== GE ROOTS INSIDE EXPORT/IMPORT ==="

  for root in \
              "$EXPORT/ge" \
              "$IMPORT/ge"

      if test -d "$root"
          find \
                          "$root" \
                          -mindepth 1 \
                          -maxdepth 2 \
                          -type d \
                          -printf '%TY-%Tm-%Td %TH:%TM:%TS|%p\n' \
                          | sort
      else
          echo "MISSING: $root"
      end
  end

  echo
  echo "=== EXPORTED/IMPORTED GE DWRITE FILES ==="

  for root in \
              "$EXPORT/ge" \
              "$IMPORT/ge"

      if test -d "$root"
          find \
                          "$root" \
                          -type f \
                          \( \
                              -path '*/files/lib/wine/x86_64-windows/dwrite.dll' \
                              -o -path '*/files/lib/wine/x86_64-unix/dwrite.so' \
                          \) \
                          -print0 \
                          | sort -z \
                          | while read -z path
              show_file "$path"
          end
      end
  end

  echo
  echo "============================================================"
  echo "12. KNOWN-GOOD ARCHIVE"
  echo "============================================================"

  show_file "$ARCHIVE"
  show_file "$ARCHIVE.sha256"

  if test -f "$ARCHIVE.sha256"
      echo
      echo "=== STORED ARCHIVE HASH ==="
      cat "$ARCHIVE.sha256"
  end

  if test -f "$ARCHIVE"
      echo
      echo "=== ARCHIVE CONTENTS ==="

      tar \
                  --zstd \
                  -tf "$ARCHIVE" \
                  2>/dev/null \
                  | sed -n '1,500p'
      or bsdtar \
                  -tf "$ARCHIVE" \
                  2>/dev/null \
                  | sed -n '1,500p'
      or echo "Archive listing failed"
  end

  echo
  echo "============================================================"
  echo "13. DIRECT FINAL COMPARISONS"
  echo "============================================================"

  compare_files \
          "$TEST_DWRITE_DLL" \
          "$ORIG_DWRITE_DLL"

  compare_files \
          "$TEST_DWRITE_SO" \
          "$ORIG_DWRITE_SO"

  compare_files \
          "$TEST_PREFIX/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2" \
          "$EXPORT/plugin/lwinput.aui2"

  compare_files \
          "$TEST_PREFIX/drive_c/ProgramData/aviutl2/Plugin/lsmash.ini" \
          "$EXPORT/plugin/lsmash.ini"

  for dll in \
              d3d11.dll \
              dxgi.dll \
              d3d10core.dll

      compare_files \
                  "$TEST_PREFIX/drive_c/windows/system32/$dll" \
                  "$EXPORT/dxvk/$dll"
  end

  echo
  echo "============================================================"
  echo "END OF STRICTLY READ-ONLY FINAL-ENV COLLECTION"
  echo "============================================================"
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(225).txt:2-860` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

読み取り専用監査。ファイル変更なしとコマンド内で明示されているものを含む。

#### 関連する固定値

- 短縮commit: `393df5e`
- version: `GE-Proton11-1`
- version: `2.7.1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/projects/aviutl2-linux-patches`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test`
- path: `$HOME/Downloads/aviutl2-known-good.tar.zst`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(225).txt lines 2-860`

---
### コマンド 296 — `V226-01`

#### 目的

保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
  set ROOT \
          "$HOME/Games/aviutl2"

  set GOOD \
          "$ROOT/prefix-ge-nvdec-test.backup-20260731-135410"

  set FAILED \
          "$ROOT/prefix-ge-nvdec-test.backup-20260731-140320"

  set CURRENT \
          "$ROOT/prefix-ge-nvdec-test"

  set BASE \
          "$ROOT/prefix-ge"

  set GE_ORIG \
          "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

  set GE_TEST \
          "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

  set WINE_BUILD \
          "$ROOT/build/wine-ge11-1-dwrite"

  set LSW_BUILD \
          "$ROOT/src/L-SMASH-Works-nvdec/AviUtl2/lwinput.aui2"

  set EXPORT \
          "$ROOT/export/aviutl2-known-good"

  set REPO \
          "$HOME/projects/aviutl2-linux-patches"

      set -l path "$argv[1]"

                                                                              set -l path "$argv[1]"

      set -l left "$argv[1]"

      set -l right "$argv[2]"

                        set plugin \
                  "$prefix/drive_c/ProgramData/aviutl2/Plugin"

      set catalog_settings (

  set SEARCH_ROOTS \
          "$HOME/.local/share/Steam/compatibilitytools.d" \
          "$ROOT"

      set -a SEARCH_ROOTS \
                  "$HOME/.local/share/Trash/files"
```

#### 実行コマンド

```fish
# ============================================================
  # AviUtl2 original working backup forensic collection
  # STRICTLY READ-ONLY
  #
  # 実行しないもの:
  #   wine / wineserver / wineboot / winetricks
  #   cp / mv / rm / install / sed -i
  #   AviUtl2 / Catalog
  # ============================================================

  set ROOT \
          "$HOME/Games/aviutl2"

  set GOOD \
          "$ROOT/prefix-ge-nvdec-test.backup-20260731-135410"

  set FAILED \
          "$ROOT/prefix-ge-nvdec-test.backup-20260731-140320"

  set CURRENT \
          "$ROOT/prefix-ge-nvdec-test"

  set BASE \
          "$ROOT/prefix-ge"

  set GE_ORIG \
          "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

  set GE_TEST \
          "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"

  set WINE_BUILD \
          "$ROOT/build/wine-ge11-1-dwrite"

  set LSW_BUILD \
          "$ROOT/src/L-SMASH-Works-nvdec/AviUtl2/lwinput.aui2"

  set EXPORT \
          "$ROOT/export/aviutl2-known-good"

  set REPO \
          "$HOME/projects/aviutl2-linux-patches"

  function show_file
      set -l path "$argv[1]"

      echo
                                                                                       echo "=== $path ==="

                                                                       if test -f "$path"
          stat \
                                                                                                     --printf='birth=%w\nmtime=%y\nctime=%z\nsize=%s\ninode=%i\n' \
                          "$path"

          file \
                                                                                                     -- "$path"

                                                                 sha256sum \
                          -- "$path"
                                                             else
          echo "MISSING"
                                                                         end
  end

  function show_dir
                                                                              set -l path "$argv[1]"

                                                                     echo
      echo "=== $path ==="

      if test -d "$path"
                                                                             stat \
                          --printf='birth=%w\nmtime=%y\nctime=%z\nsize=%s\ninode=%i\n' \
                             "$path"
      else
                                                                                           echo "MISSING"
      end
                                                                                    end

                                                                                        function compare_files
      set -l left "$argv[1]"
      set -l right "$argv[2]"

      echo
      echo "COMPARE:"
      echo "  LEFT:  $left"
      echo "  RIGHT: $right"

                                                                     if not test -f "$left"
          echo "RESULT: LEFT MISSING"
                                                            else if not test -f "$right"
          echo "RESULT: RIGHT MISSING"
                                                           else if cmp -s -- "$left" "$right"
          echo "RESULT: IDENTICAL"
                                                               else
          echo "RESULT: DIFFERENT"
      end
  end

  echo
                                                                                       echo "============================================================"
  echo "1. PREFIX GENERATIONS"
  echo "============================================================"

  for prefix in \
              "$GOOD" \
              "$FAILED" \
                                                                                "$CURRENT" \
                                                                               "$BASE"

                                                                            show_dir "$prefix"

      for path in \
                                                                                              "$prefix/user.reg" \
                      "$prefix/system.reg" \
                      "$prefix/userdef.reg" \
                      "$prefix/drive_c/AviUtl2/aviutl2.exe"

          show_file "$path"
      end
                                                                                    end

                                                                                        echo
  echo "============================================================"
  echo "2. CRITICAL DLL MATRIX"
  echo "============================================================"

  for prefix in \
              "$GOOD" \
              "$FAILED" \
              "$CURRENT" \
              "$BASE"

      echo
      echo "############################################################"
      echo "PREFIX: $prefix"
      echo "############################################################"

                        for arch in \
                      system32 \
                                                                                 syswow64

                                                                       for dll in \
                              d3d11.dll \
                                                                                dxgi.dll \
                              d3d10core.dll \
                                                                            d3dcompiler_47.dll \
                              nvcuda.dll \
                                                                               nvcuvid.dll \
                              nvencodeapi64.dll

                                                          show_file \
                                  "$prefix/drive_c/windows/$arch/$dll"
          end
                                                                                    end
  end

  echo
  echo "============================================================"
                        echo "3. L-SMASH WORKS IN EACH PREFIX"
  echo "============================================================"

  for prefix in \
                                                                                        "$GOOD" \
              "$FAILED" \
                                                                                "$CURRENT" \
              "$BASE"

      echo
                                                                                       echo "############################################################"
      echo "PREFIX: $prefix"
                                                                     echo "############################################################"

                        set plugin \
                  "$prefix/drive_c/ProgramData/aviutl2/Plugin"

      if test -d "$plugin"
                                                                           find \
                          "$plugin" \
                                                                                -maxdepth 3 \
                          -type f \
                                                                                  \( \
                              -iname 'lwinput.aui2' \
                                                                    -o -iname 'lwinput.aui' \
                              -o -iname 'lwinput.aui2.before-*' \
                                                        -o -iname 'lsmash.ini' \
                              -o -iname 'lsmash.ini.before-*' \
                          \) \
                          -print0 \
                          | sort -z \
                          | while read -z path
              show_file "$path"

              switch (string lower -- (basename "$path"))
                  case 'lwinput.aui2' 'lwinput.aui' 'lwinput.aui2.before-*'
                      echo "-- binary markers --"

                      strings \
                                                      "$path" \
                                                      | grep -Ei \
                                                          'av1_cuvid|nvcuvid|nvcuda|libdav1d|av_hwframe_transfer_data|L-SMASH' \
                                                      | sort -u \
                                                      | head -n 160
                      or true

                  case 'lsmash.ini' 'lsmash.ini.before-*'
                      echo "-- ini contents --"

                      sed \
                                                      -n \
                                                      '1,260p' \
                                                      "$path"
              end
          end
      else
          echo "PLUGIN DIRECTORY MISSING"
      end
  end

  echo
  echo "=== GOOD PREFIX VS L-SMASH BUILD ==="

  for candidate in \
              "$GOOD/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2" \
              "$GOOD/drive_c/ProgramData/aviutl2/Plugin/L-SMASH-Works/lwinput.aui2"

      compare_files \
                  "$candidate" \
                  "$LSW_BUILD"
  end

  echo
  echo "============================================================"
  echo "4. REGISTRY STATE OF EACH GENERATION"
  echo "============================================================"

  for prefix in \
              "$GOOD" \
              "$FAILED" \
              "$CURRENT" \
              "$BASE"

      echo
      echo "############################################################"
      echo "PREFIX: $prefix"
      echo "############################################################"

      for reg in \
                      "$prefix/user.reg" \
                      "$prefix/system.reg"

          echo
          echo "=== $reg ==="

          if test -f "$reg"
              grep \
                                  -n \
                                  -A28 \
                                  -B4 \
                                  -E \
                                  'DllOverrides|nvcuda|nvcuvid|nvencodeapi64|d3d11|d3d10core|dxgi|d3dcompiler_47|dwrite|InputStyle|Software\\\\Wine\\\\Drivers|Fonts\\\\Replacements|Tahoma|Noto Sans CJK JP' \
                                  "$reg" \
                                  | head -n 1000
              or true
          else
              echo "MISSING"
          end
      end
  end

  echo
  echo "============================================================"
  echo "5. CATALOG AND PROGRAMDATA"
  echo "============================================================"

  for prefix in \
              "$GOOD" \
              "$FAILED" \
              "$CURRENT" \
              "$BASE"

      echo
      echo "############################################################"
      echo "PREFIX: $prefix"
      echo "############################################################"

      if test -d "$prefix/drive_c/ProgramData/aviutl2"
          find \
                          "$prefix/drive_c/ProgramData/aviutl2" \
                          -maxdepth 3 \
                          -type f \
                          -printf '%TY-%Tm-%Td %TH:%TM:%TS|%s|%p\n' \
                          | sort \
                          | sed -n '1,800p'
      else
          echo "PROGRAMDATA AVIUTL2 MISSING"
      end

      set catalog_settings (
          find \
                          "$prefix/drive_c/users" \
                          -type f \
                          -ipath '*/aviutl2-catalog/settings.json' \
                          -print \
                          2>/dev/null
      )

      for path in $catalog_settings
          show_file "$path"

          sed \
                          -n \
                          '1,300p' \
                          "$path"
      end
  end

  echo
  echo "============================================================"
  echo "6. DIRECT GOOD/FAILED/BASE COMPARISONS"
  echo "============================================================"

  for relative in \
              drive_c/windows/system32/d3d11.dll \
              drive_c/windows/system32/dxgi.dll \
              drive_c/windows/system32/d3d10core.dll \
              drive_c/windows/system32/d3dcompiler_47.dll \
              drive_c/windows/system32/nvcuda.dll \
              drive_c/windows/system32/nvcuvid.dll \
              drive_c/windows/system32/nvencodeapi64.dll \
              drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2 \
              drive_c/ProgramData/aviutl2/Plugin/lsmash.ini

      echo
      echo "RELATIVE PATH: $relative"

      compare_files \
                  "$GOOD/$relative" \
                  "$FAILED/$relative"

      compare_files \
                  "$GOOD/$relative" \
                  "$BASE/$relative"
  end

  echo
  echo "============================================================"
  echo "7. SEARCH FOR LOST GE TEST RUNNER"
  echo "============================================================"

  set SEARCH_ROOTS \
          "$HOME/.local/share/Steam/compatibilitytools.d" \
          "$ROOT"

  if test -d "$HOME/.local/share/Trash/files"
      set -a SEARCH_ROOTS \
                  "$HOME/.local/share/Trash/files"
  end

  echo
  echo "=== GE TEST DIRECTORY CANDIDATES ==="

  find \
          $SEARCH_ROOTS \
          -type d \
          \( \
              -name 'GE-Proton11-1-aviutl2-test' \
              -o -name 'GE-Proton11-1-aviutl2-test*' \
          \) \
          -printf '%T@|%TY-%Tm-%Td %TH:%TM:%TS|%p\n' \
          2>/dev/null \
          | sort -n
  or true

  echo
  echo "=== ALL RELEVANT DWRITE COPIES ==="

  find \
          $SEARCH_ROOTS \
          -type f \
          \( \
              -path '*/x86_64-windows/dwrite.dll' \
              -o -path '*/x86_64-unix/dwrite.so' \
              -o -name 'dwrite.dll.backup-*' \
              -o -name 'dwrite.dll.before-*' \
              -o -name 'dwrite.so.before-*' \
          \) \
          -print0 \
          2>/dev/null \
          | sort -z \
          | while read -z path
      show_file "$path"
  end

  echo
  echo "=== FINAL BUILD REFERENCE ==="

  show_file \
          "$WINE_BUILD/dlls/dwrite/x86_64-windows/dwrite.dll"

  show_file \
          "$WINE_BUILD/dlls/dwrite/dwrite.so"

  echo
  echo "============================================================"
  echo "8. EXPORT AUDIT"
  echo "============================================================"

  for file in \
              "$EXPORT/metadata/BUILD-INFO.txt" \
              "$EXPORT/SHA256SUMS"

      show_file "$file"

      if test -f "$file"
          echo "-- contents/excerpts --"

          switch (basename "$file")
              case BUILD-INFO.txt
                  cat "$file"

              case SHA256SUMS
                  echo "entry count:"
                  wc -l "$file"

                  echo
                  echo "critical entries:"

                  grep \
                                          -Ei \
                                          '(^|/)(dxvk|plugin)/|dwrite\.(dll|so)$|lwinput|lsmash\.ini' \
                                          "$file" \
                                          | sed -n '1,500p'
                  or true
          end
      end
  end

  echo
  echo "=== EXPORT DXVK/PLUGIN CONTENTS ==="

  for dir in \
              "$EXPORT/dxvk" \
              "$EXPORT/plugin"

      show_dir "$dir"

      if test -d "$dir"
          find \
                          "$dir" \
                          -maxdepth 3 \
                          -printf '%y|%TY-%Tm-%Td %TH:%TM:%TS|%s|%p\n' \
                          | sort
      end
  end

  echo
  echo "============================================================"
  echo "9. REPRODUCTION SCRIPT AND HISTORY"
  echo "============================================================"

  for script in \
              "$REPO/scripts/reproduce-aviutl2.sh" \
              "$REPO/scripts/reproduce-aviutl2.fish"

      echo
      echo "=== $script ==="

      if test -f "$script"
          stat \
                          --printf='birth=%w\nmtime=%y\nctime=%z\nsize=%s\n' \
                          "$script"

          sha256sum "$script"

          sed \
                          -n \
                          '1,1200p' \
                          "$script"
      else
          echo "MISSING"
      end
  end

  echo
  echo "=== FISH HISTORY 2026-07-31 13:40–14:15 JST ==="

  history search \
          --show-time="%s|" \
          --null \
          --reverse \
          --max=200000 \
          | python3 -c '
  import sys
  from datetime import datetime, timezone, timedelta

  start = datetime(2026, 7, 31, 13, 40, 0, tzinfo=timezone(timedelta(hours=9)))
  end   = datetime(2026, 7, 31, 14, 15, 0, tzinfo=timezone(timedelta(hours=9)))

  for raw in sys.stdin.buffer.read().split(b"\0"):
      if not raw:
          continue

      first, sep, command = raw.partition(b"|")

      if not sep:
          continue

      try:
          timestamp = int(first)
      except ValueError:
          continue

      moment = datetime.fromtimestamp(timestamp, timezone(timedelta(hours=9)))

      if start <= moment <= end:
          print(f"--- {moment.isoformat(sep=\" \")} ---")
          print(command.decode(\"utf-8\", \"replace\"))
          print()
  '

  echo
  echo "=== FILES MODIFIED DURING REBUILD WINDOW ==="

  find \
          "$ROOT" \
          "$REPO" \
          -xdev \
          -newermt '2026-07-31 13:40:00' \
          ! -newermt '2026-07-31 14:15:01' \
          -printf '%T@|%TY-%Tm-%Td %TH:%TM:%TS|%y|%s|%p\n' \
          2>/dev/null \
          | sort -n \
          | sed -n '1,1200p'

  echo
  echo "============================================================"
  echo "END OF STRICTLY READ-ONLY BACKUP FORENSICS"
  echo "============================================================"
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(226).txt:2-540` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

読み取り専用監査。ファイル変更なしとコマンド内で明示されているものを含む。

#### 関連する固定値

- 短縮commit: `20260731`
- version: `GE-Proton11-1`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1`
- path: `$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test`
- path: `$HOME/projects/aviutl2-linux-patches`
- path: `$HOME/.local/share/Steam/compatibilitytools.d`
- path: `$HOME/.local/share/Trash/files`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(226).txt lines 2-540`

---
### コマンド 297 — `V228-01`

#### 目的

保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
  set ROOT "$HOME/Games/aviutl2"

  set GOOD \
          "$ROOT/prefix-ge-nvdec-test.backup-20260731-135410"

  set ACTIVE \
          "$GOOD/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2"

  set OFFICIAL \
          "$GOOD/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2.before-hwframe-transfer-20260731-042746"

  set CUSTOM \
          "$ROOT/src/L-SMASH-Works-nvdec/AviUtl2/lwinput.aui2"

      set -l path "$argv[1]"

      set parts (string split -m1 '|' "$pair")

      set left "$parts[1]"

      set right "$parts[2]"

  set SEARCH_ROOTS "$ROOT"

      set -a SEARCH_ROOTS "$HOME/.local/share/Trash/files"

  set ACTIVE_HASH \
          (sha256sum -- "$ACTIVE" | awk '{print $1}')

          set hash \
                              (sha256sum -- "$path" | awk '{print $1}')
```

#### 実行コマンド

```fish
# ============================================================
  # Final lwinput.aui2 provenance investigation
  # Fish-compatible / STRICTLY READ-ONLY
  # ============================================================

  set ROOT "$HOME/Games/aviutl2"

  set GOOD \
          "$ROOT/prefix-ge-nvdec-test.backup-20260731-135410"

  set ACTIVE \
          "$GOOD/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2"

  set OFFICIAL \
          "$GOOD/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2.before-hwframe-transfer-20260731-042746"

  set CUSTOM \
          "$ROOT/src/L-SMASH-Works-nvdec/AviUtl2/lwinput.aui2"

  function show_file
      set -l path "$argv[1]"

      echo
      echo "=== $path ==="

      if test -f "$path"
          stat \
                          --printf='birth=%w\nmtime=%y\nctime=%z\nsize=%s\ninode=%i\n' \
                          "$path"

          file -- "$path"
          sha256sum -- "$path"
      else
          echo "MISSING"
      end
  end

  echo
  echo "============================================================"
  echo "1. PRIMARY THREE-WAY MATRIX"
  echo "============================================================"

  for path in \
          "$ACTIVE" \
          "$OFFICIAL" \
          "$CUSTOM"

      show_file "$path"
  end

  echo
  echo "=== BYTEWISE IDENTITY ==="

  for pair in \
          "$ACTIVE|$OFFICIAL" \
          "$ACTIVE|$CUSTOM" \
          "$OFFICIAL|$CUSTOM"

      set parts (string split -m1 '|' "$pair")
      set left "$parts[1]"
      set right "$parts[2]"

      echo
      echo "LEFT:  $left"
      echo "RIGHT: $right"

      if not test -f "$left"
          echo "RESULT: LEFT MISSING"
      else if not test -f "$right"
          echo "RESULT: RIGHT MISSING"
      else if cmp -s -- "$left" "$right"
          echo "RESULT: IDENTICAL"
      else
          echo "RESULT: DIFFERENT"
      end
  end

  echo
  echo "============================================================"
  echo "2. LOCATE EVERY LWINPUT COPY"
  echo "============================================================"

  set SEARCH_ROOTS "$ROOT"

  if test -d "$HOME/.local/share/Trash/files"
      set -a SEARCH_ROOTS "$HOME/.local/share/Trash/files"
  end

  for search_root in $SEARCH_ROOTS
      find \
                  "$search_root" \
                  -type f \
                  \( \
                      -iname 'lwinput.aui2' \
                      -o -iname 'lwinput.aui2.*' \
                      -o -iname '*lwinput*.aui2' \
                  \) \
                  -print0 \
                  2>/dev/null \
                  | sort -z \
                  | while read -z path
          echo
          stat \
                              --printf='%y|%s|%n\n' \
                              "$path"

          sha256sum -- "$path"
      end
  end

  echo
  echo "============================================================"
  echo "3. FIND EXACT ACTIVE-HASH COPIES"
  echo "============================================================"

  if not test -f "$ACTIVE"
      echo "ERROR: active known-good lwinput.aui2 is missing:"
      echo "$ACTIVE"
      return 1
  end

  set ACTIVE_HASH \
          (sha256sum -- "$ACTIVE" | awk '{print $1}')

  echo "TARGET HASH: $ACTIVE_HASH"

  for search_root in $SEARCH_ROOTS
      find \
                  "$search_root" \
                  -type f \
                  \( \
                      -iname 'lwinput.aui2' \
                      -o -iname 'lwinput.aui2.*' \
                      -o -iname '*lwinput*.aui2' \
                  \) \
                  -print0 \
                  2>/dev/null \
                  | while read -z path
          set hash \
                              (sha256sum -- "$path" | awk '{print $1}')

          if test "$hash" = "$ACTIVE_HASH"
              echo "$path"
          end
      end
  end

  echo
  echo "============================================================"
  echo "4. PE HEADER AND BYTE DIFFERENCES"
  echo "============================================================"

  env \
          ACTIVE="$ACTIVE" \
          OFFICIAL="$OFFICIAL" \
          CUSTOM="$CUSTOM" \
          python3 -c '
  from __future__ import annotations

  import hashlib
  import os
  import struct
  from pathlib import Path

  paths = {
      "ACTIVE": Path(os.environ["ACTIVE"]),
      "OFFICIAL": Path(os.environ["OFFICIAL"]),
      "CUSTOM": Path(os.environ["CUSTOM"]),
  }


  def sha256(data: bytes) -> str:
      return hashlib.sha256(data).hexdigest()


  def pe_metadata(data: bytes) -> dict[str, object]:
      result: dict[str, object] = {}

      if len(data) < 0x40 or data[:2] != b"MZ":
          result["error"] = "not an MZ executable"
          return result

      pe_offset = struct.unpack_from("<I", data, 0x3C)[0]

      if pe_offset + 24 > len(data):
          result["error"] = "invalid PE offset"
          return result

      if data[pe_offset:pe_offset + 4] != b"PE\0\0":
          result["error"] = "missing PE signature"
          return result

      optional = pe_offset + 24

      result["pe_offset"] = pe_offset
      result["machine"] = hex(
          struct.unpack_from("<H", data, pe_offset + 4)[0]
      )
      result["sections"] = struct.unpack_from(
          "<H", data, pe_offset + 6
      )[0]
      result["timestamp"] = struct.unpack_from(
          "<I", data, pe_offset + 8
      )[0]

      if optional + 68 <= len(data):
          result["checksum"] = struct.unpack_from(
              "<I", data, optional + 64
          )[0]

      return result


  def differing_ranges(
      left: bytes,
      right: bytes,
  ) -> list[tuple[int, int]]:
      limit = min(len(left), len(right))
      ranges: list[tuple[int, int]] = []
      start: int | None = None

      for index in range(limit):
          differs = left[index] != right[index]

          if differs and start is None:
              start = index
          elif not differs and start is not None:
              ranges.append((start, index - 1))
              start = None

      if start is not None:
          ranges.append((start, limit - 1))

      if len(left) != len(right):
          ranges.append(
              (limit, max(len(left), len(right)) - 1)
          )

      return ranges


  loaded: dict[str, bytes] = {}

  for name, path in paths.items():
      print()
      print("=== " + name + " ===")
      print("path=" + str(path))

      if not path.is_file():
          print("MISSING")
          continue

      data = path.read_bytes()
      loaded[name] = data

      print("size=" + str(len(data)))
      print("sha256=" + sha256(data))

      for key, value in pe_metadata(data).items():
          print(str(key) + "=" + str(value))


  for left_name, right_name in (
      ("ACTIVE", "OFFICIAL"),
      ("ACTIVE", "CUSTOM"),
      ("OFFICIAL", "CUSTOM"),
  ):
      print()
      print("=== " + left_name + " VS " + right_name + " ===")

      if left_name not in loaded or right_name not in loaded:
          print("comparison unavailable: missing file")
          continue

      left = loaded[left_name]
      right = loaded[right_name]
      ranges = differing_ranges(left, right)

      differing_bytes = sum(
          end - start + 1
          for start, end in ranges
      )

      print("same_size=" + str(len(left) == len(right)))
      print("differing_ranges=" + str(len(ranges)))
      print("differing_bytes=" + str(differing_bytes))

      for start, end in ranges[:80]:
          print(
              "0x"
              + format(start, "08x")
              + "-0x"
              + format(end, "08x")
              + " ("
              + str(end - start + 1)
              + " bytes)"
          )

      if len(ranges) > 80:
          print(
              "additional_ranges="
              + str(len(ranges) - 80)
          )

      if len(left) == len(right):
          normalized_left = bytearray(left)
          normalized_right = bytearray(right)

          for normalized, original in (
              (normalized_left, left),
              (normalized_right, right),
          ):
              pe_offset = struct.unpack_from(
                  "<I", original, 0x3C
              )[0]

              normalized[
                  pe_offset + 8:pe_offset + 12
              ] = b"\0" * 4

              optional = pe_offset + 24

              normalized[
                  optional + 64:optional + 68
              ] = b"\0" * 4

          print(
              "identical_after_normalizing_"
              "timestamp_and_checksum="
              + str(normalized_left == normalized_right)
          )
  '

  echo
  echo "============================================================"
  echo "5. FISH HISTORY 06:00–07:05"
  echo "============================================================"

  history search \
          --show-time="%s|" \
          --null \
          --reverse \
          --max=200000 \
          | python3 -c '
  import re
  import sys
  from datetime import datetime, timedelta, timezone

  jst = timezone(timedelta(hours=9))

  start = datetime(
      2026, 7, 31, 6, 0, 0,
      tzinfo=jst,
  )

  end = datetime(
      2026, 7, 31, 7, 5, 0,
      tzinfo=jst,
  )

  pattern = re.compile(
      r"lwinput|lsmash|aui2|L-SMASH|"
      r"\bcp\b|\binstall\b|\bmv\b|"
      r"\bobjcopy\b|\bstrip\b|\btouch\b|"
      r"\bpython\b|\bsha256sum\b",
      re.IGNORECASE,
  )

  for raw in sys.stdin.buffer.read().split(b"\0"):
      if not raw:
          continue

      first, separator, command = raw.partition(b"|")

      if not separator:
          continue

      try:
          timestamp = int(first)
      except ValueError:
          continue

      moment = datetime.fromtimestamp(timestamp, jst)
      text = command.decode("utf-8", "replace")

      if start <= moment <= end and pattern.search(text):
          print("--- " + moment.isoformat(" ") + " ---")
          print(text)
          print()
  '

  echo
  echo "============================================================"
  echo "6. FILES TOUCHED 06:00–07:05"
  echo "============================================================"

  find \
          "$ROOT" \
          -xdev \
          -newermt '2026-07-31 06:00:00' \
          ! -newermt '2026-07-31 07:05:01' \
          -printf '%T@|%TY-%Tm-%Td %TH:%TM:%TS|%y|%s|%p\n' \
          2>/dev/null \
          | sort -n \
          | sed -n '1,1500p'

  echo
  echo "============================================================"
  echo "END OF READ-ONLY INVESTIGATION"
  echo "============================================================"
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(228).txt:715-1124` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

読み取り専用監査。ファイル変更なしとコマンド内で明示されているものを含む。

#### 関連する固定値

- 短縮commit: `20260731`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Trash/files`

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。
- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(228).txt lines 715-1124`

---
### コマンド 298 — `V229-01`

#### 目的

保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
  set ROOT "$HOME/Games/aviutl2"

  set GOOD \
          "$ROOT/prefix-ge-nvdec-test.backup-20260731-135410"

  set PDATA \
          "$GOOD/drive_c/ProgramData/aviutl2"

  set USER_LOCAL \
          "$GOOD/drive_c/users/steamuser/AppData/Local"

  set TARGET \
          "$PDATA/Plugin/lwinput.aui2"

  set SEARCH_DIRS

          set -a SEARCH_DIRS "$candidate"

      set matches (
```

#### 実行コマンド

```fish
# ============================================================
  # AviUtl2 Catalog package provenance
  # Fish / STRICTLY READ-ONLY
  # ============================================================

  set ROOT "$HOME/Games/aviutl2"

  set GOOD \
          "$ROOT/prefix-ge-nvdec-test.backup-20260731-135410"

  set PDATA \
          "$GOOD/drive_c/ProgramData/aviutl2"

  set USER_LOCAL \
          "$GOOD/drive_c/users/steamuser/AppData/Local"

  set TARGET \
          "$PDATA/Plugin/lwinput.aui2"

  set SEARCH_DIRS

  for candidate in \
          "$PDATA" \
          "$USER_LOCAL/aviutl2-catalog" \
          "$USER_LOCAL/AviUtl2 カタログ" \
          "$ROOT/downloads" \
          "$ROOT/backups" \
          "$ROOT/tools"

      if test -d "$candidate"
          set -a SEARCH_DIRS "$candidate"
      end
  end

  echo
  echo "============================================================"
  echo "1. SEARCH ROOTS"
  echo "============================================================"

  printf '%s\n' $SEARCH_DIRS

  echo
  echo "============================================================"
  echo "2. TARGET FILE"
  echo "============================================================"

  stat \
          --printf='birth=%w\nmtime=%y\nctime=%z\nsize=%s\ninode=%i\n' \
          "$TARGET"

  file -- "$TARGET"
  sha256sum -- "$TARGET"

  echo
  echo "============================================================"
  echo "3. EVERY FILE WITH THE SAME SIZE"
  echo "============================================================"

  find \
          $SEARCH_DIRS \
          -type f \
          -size 25893376c \
          -print0 \
          2>/dev/null \
          | sort -z \
          | while read -z path
      echo
      stat \
                      --printf='%w|%y|%s|%n\n' \
                      "$path"

      sha256sum -- "$path"
  end

  echo
  echo "============================================================"
  echo "4. CATALOG AND PACKAGE METADATA FILES"
  echo "============================================================"

  find \
          $SEARCH_DIRS \
          -type f \
          \( \
              -iname '*package*' \
              -o -iname '*manifest*' \
              -o -iname '*module*' \
              -o -iname '*catalog*' \
              -o -iname '*state*' \
              -o -iname '*install*' \
              -o -iname '*update*' \
              -o -iname 'settings.json' \
              -o -iname '*.db' \
              -o -iname '*.sqlite' \
              -o -iname '*.sqlite3' \
              -o -iname '*.ldb' \
              -o -iname 'MANIFEST-*' \
              -o -iname 'LOG' \
              -o -iname 'LOG.old' \
          \) \
          -print0 \
          2>/dev/null \
          | sort -z \
          | while read -z path
      echo
      echo "=== $path ==="

      stat \
                      --printf='birth=%w\nmtime=%y\nsize=%s\n' \
                      "$path"

      file -- "$path"
      sha256sum -- "$path"

      strings \
                      -a \
                      -n 6 \
                      "$path" \
                      2>/dev/null \
                      | grep \
                          -iE \
                          'L-SMASH|lwinput|aui2|av1_cuvid|package|install|update|github|download|release|version' \
                      | head -n 300 \
                      or true
  end

  echo
  echo "============================================================"
  echo "5. FILES WRITTEN DURING CATALOG SESSION"
  echo "============================================================"

  find \
          $SEARCH_DIRS \
          -type f \
          -newermt '2026-07-31 06:10:00' \
          ! -newermt '2026-07-31 07:05:01' \
          -printf '%T@|%w|%y|%s|%p\n' \
          2>/dev/null \
          | sort -n \
          | sed -n '1,2000p'

  echo
  echo "============================================================"
  echo "6. RELEVANT STRINGS IN SESSION FILES"
  echo "============================================================"

  find \
          $SEARCH_DIRS \
          -type f \
          -newermt '2026-07-31 06:10:00' \
          ! -newermt '2026-07-31 07:05:01' \
          -size -100M \
          -print0 \
          2>/dev/null \
          | sort -z \
          | while read -z path
      set matches (
                                                                                  strings \
                              -a \
                              -n 7 \
                              "$path" \
                              2>/dev/null \
                              | grep \
                                  -iE \
                                  'L-SMASH|lwinput\.aui2|av1_cuvid|github\.com|releases/download|package[_ -]?id|install|update' \
                              | head -n 120
      )

      if test (count $matches) -gt 0
          echo
          echo "=== $path ==="
          printf '%s\n' $matches
      end
  end

  echo
  echo "============================================================"
  echo "7. OBVIOUS TEXT CONFIGURATION"
  echo "============================================================"

  find \
          "$PDATA" \
                                                                                 "$USER_LOCAL/aviutl2-catalog" \
                                                            -type f \
          \( \
                                                                                           -iname '*.json' \
                                                                          -o -iname '*.ini' \
              -o -iname '*.toml' \
                                                                       -o -iname '*.yaml' \
              -o -iname '*.yml' \
                                                                        -o -iname '*.txt' \
          \) \
                                                                                       -print0 \
                                                                                  2>/dev/null \
          | sort -z \
                                                                                | while read -z path
                                                                   echo
      echo "=== $path ==="

                                                                       grep \
                      -aHniE \
                                                                                   'L-SMASH|lwinput|aui2|package|install|update|version|source|url' \
                         "$path" \
                      | head -n 300 \
                                                                            or true
                                                                end

                                                                                        echo
                                                                                       echo "============================================================"
  echo "8. SQLITE DATABASES"
                                                                 echo "============================================================"

  if command -q sqlite3
                                                                          find \
                                                                                                 $SEARCH_DIRS \
                  -type f \
                                                                                  \( \
                                                                                           -iname '*.db' \
                      -o -iname '*.sqlite' \
                                                                     -o -iname '*.sqlite3' \
                                                                \) \
                  -print0 \
                                                                                  2>/dev/null \
                                                                              | sort -z \
                  | while read -z database
                                                           echo
                                                                                       echo "=== $database ==="

                                                                   sqlite3 \
                                                                                                      -readonly \
                              "$database" \
                                                                              '.tables' \
                                                                                2>/dev/null \
                              or true

          sqlite3 \
                              -readonly \
                              "$database" \
                              '.dump' \
                              2>/dev/null \
                              | grep \
                                  -iE \
                                  'L-SMASH|lwinput|aui2|package|install|update|github|version' \
                              | head -n 500 \
                              or true
      end
  else
      echo "sqlite3 is not installed; skipped"
  end

  echo
  echo "============================================================"
  echo "END OF READ-ONLY CATALOG PROVENANCE"
  echo "============================================================"
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(229).txt:2-254` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

読み取り専用監査。ファイル変更なしとコマンド内で明示されているものを含む。

#### 関連する固定値

- 短縮commit: `20260731`
- 短縮commit: `25893376c`
- path: `$HOME/Games/aviutl2`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(229).txt lines 2-254`

---
### コマンド 299 — `V230-01`

#### 目的

保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
  set ROOT "$HOME/Games/aviutl2"

  set GOOD \
          "$ROOT/prefix-ge-nvdec-test.backup-20260731-135410"

  set APPDATA \
          "$GOOD/drive_c/users/steamuser/AppData"

  set LOCAL \
          "$APPDATA/Local"

  set ROAMING \
          "$APPDATA/Roaming"

  set PDATA \
          "$GOOD/drive_c/ProgramData/aviutl2"

  set CATALOG_APP \
          "$LOCAL/AviUtl2 カタログ"

  set CATALOG_DATA \
          "$LOCAL/aviutl2-catalog"

  set CATALOG_ROAMING \
          "$ROAMING/aviutl2-catalog"

  set WEBVIEW \
          "$CATALOG_DATA/EBWebView"

  set TARGET \
          "$PDATA/Plugin/lwinput.aui2"

  set INSTALLED_CHECKER \
          "$PDATA/Plugin/UpdateChecker.aui2"

  set BUNDLED_CHECKER \
          "$CATALOG_APP/resources/UpdateChecker.aui2"

      set -l path "$argv[1]"

      set -l path "$argv[1]"

  set SCAN_ROOTS

          set -a SCAN_ROOTS "$candidate"

      set -l parts \
                  (string split '|' -- "$spec")

      set -l label \
                  "$parts[1]"

      set -l start \
                  "$parts[2]"

      set -l finish \
                  "$parts[3]"

  set STORAGE_ROOTS

          set -a STORAGE_ROOTS "$candidate"

      set -l matches \
                      (relevant_strings "$path")
```

#### 実行コマンド

```fish
# ============================================================
  # Catalog / UpdateChecker final provenance
  # Fish-compatible / STRICTLY READ-ONLY
  # ============================================================

  set ROOT "$HOME/Games/aviutl2"

  set GOOD \
          "$ROOT/prefix-ge-nvdec-test.backup-20260731-135410"

  set APPDATA \
          "$GOOD/drive_c/users/steamuser/AppData"

  set LOCAL \
          "$APPDATA/Local"

  set ROAMING \
          "$APPDATA/Roaming"

  set PDATA \
          "$GOOD/drive_c/ProgramData/aviutl2"

  set CATALOG_APP \
          "$LOCAL/AviUtl2 カタログ"

  set CATALOG_DATA \
          "$LOCAL/aviutl2-catalog"

  set CATALOG_ROAMING \
          "$ROAMING/aviutl2-catalog"

  set WEBVIEW \
          "$CATALOG_DATA/EBWebView"

  set TARGET \
          "$PDATA/Plugin/lwinput.aui2"

  set INSTALLED_CHECKER \
          "$PDATA/Plugin/UpdateChecker.aui2"

  set BUNDLED_CHECKER \
          "$CATALOG_APP/resources/UpdateChecker.aui2"

  function show_file
      set -l path "$argv[1]"

      echo
      echo "=== $path ==="

      if test -f "$path"
          stat \
                          --printf='birth=%w\nmtime=%y\nctime=%z\nsize=%s\ninode=%i\n' \
                          "$path"

          file -- "$path"
          sha256sum -- "$path"
      else
          echo "MISSING"
      end
  end

  function relevant_strings
      set -l path "$argv[1]"

      begin
          strings \
                          -a \
                          -n 6 \
                          -- \
                          "$path" \
                          2>/dev/null

          strings \
                          -a \
                          --encoding=l \
                          -n 6 \
                          -- \
                          "$path" \
                          2>/dev/null
      end \
                  | grep \
                      -iE \
                      'L-SMASH|L-SMASH-Works|lwinput|lsmash|av1_cuvid|Mr-Ojii|build-20[0-9]{2}|r[0-9]{3,5}|package_state|package_updates|package[_ -]?id|releases/download|github\.com|browser_download_url|download_url|UpdatesPage|installer-|install_package|update_package' \

                  | sort -u \
                  | sed -n '1,500p'
  end

  echo
  echo "============================================================"
  echo "1. EXACT CORE FILES"
  echo "============================================================"

  for path in \
          "$TARGET" \
          "$INSTALLED_CHECKER" \
          "$BUNDLED_CHECKER" \
          "$CATALOG_APP/AviUtl2_Catalog.exe" \
          "$CATALOG_ROAMING/settings.json" \
          "$PDATA/module.ini" \
          "$PDATA/history.ini" \
          "$PDATA/Plugin/lsmash.ini"

      show_file "$path"
  end

  echo
  echo "============================================================"
  echo "2. UPDATECHECKER IDENTITY"
  echo "============================================================"

  if test -f "$INSTALLED_CHECKER"; and test -f "$BUNDLED_CHECKER"
      if cmp -s \
                      -- \
                      "$INSTALLED_CHECKER" \
                      "$BUNDLED_CHECKER"

          echo "INSTALLED UPDATECHECKER = CATALOG-BUNDLED UPDATECHECKER"
      else
          echo "INSTALLED UPDATECHECKER != CATALOG-BUNDLED UPDATECHECKER"
      end
  else
      echo "UPDATECHECKER COMPARISON UNAVAILABLE"
  end

  echo
  echo "============================================================"
  echo "3. EXACT TEXT CONFIGURATION"
  echo "============================================================"

  for path in \
          "$CATALOG_ROAMING/settings.json" \
          "$PDATA/module.ini" \
          "$PDATA/history.ini" \
          "$PDATA/Plugin/lsmash.ini"

      echo
      echo "=== $path ==="

      if test -f "$path"
          sed -n \
                          '1,500p' \
                          "$path"
      else
          echo "MISSING"
      end
  end

  echo
  echo "============================================================"
  echo "4. TARGET BINARY VERSION AND BUILD STRINGS"
  echo "============================================================"

  if test -f "$TARGET"
      relevant_strings "$TARGET"
  end

  echo
  echo "============================================================"
  echo "5. CATALOG AND UPDATECHECKER STRINGS"
  echo "============================================================"

  for path in \
          "$CATALOG_APP/AviUtl2_Catalog.exe" \
          "$INSTALLED_CHECKER" \
          "$BUNDLED_CHECKER"

      echo
      echo "=== $path ==="

      if test -f "$path"
          relevant_strings "$path"
      else
          echo "MISSING"
      end
  end

  echo
  echo "============================================================"
  echo "6. COMPLETE FISH HISTORY 06:10–07:03"
  echo "============================================================"

  history search \
          --show-time="%s|" \
          --null \
          --reverse \
          --max=200000 \
          | python3 -c '
  import sys
  from datetime import datetime, timedelta, timezone

  jst = timezone(timedelta(hours=9))

  start = datetime(
      2026, 7, 31, 6, 10, 0,
      tzinfo=jst,
  )

  end = datetime(
      2026, 7, 31, 7, 3, 0,
      tzinfo=jst,
  )

  for raw in sys.stdin.buffer.read().split(b"\0"):
      if not raw:
          continue

      first, separator, command = raw.partition(b"|")

      if not separator:
          continue

      try:
          timestamp = int(first)
      except ValueError:
          continue

      moment = datetime.fromtimestamp(timestamp, jst)

      if start <= moment <= end:
          print("--- " + moment.isoformat(" ") + " ---")
          print(command.decode("utf-8", "replace"))
          print()
  '

  echo
  echo "============================================================"
  echo "7. FILES WRITTEN NEAR INITIAL INSTALL AND FINAL UPDATE"
  echo "============================================================"

  set SCAN_ROOTS

  for candidate in \
          "$PDATA" \
          "$CATALOG_APP" \
          "$CATALOG_DATA" \
          "$CATALOG_ROAMING"

      if test -d "$candidate"
          set -a SCAN_ROOTS "$candidate"
      end
  end

  for spec in \
          "INITIAL INSTALL|2026-07-31 06:14:00|2026-07-31 06:21:00" \
          "FINAL UPDATE|2026-07-31 06:57:30|2026-07-31 07:01:30"

      set -l parts \
                  (string split '|' -- "$spec")

      set -l label \
                  "$parts[1]"

      set -l start \
                  "$parts[2]"

      set -l finish \
                  "$parts[3]"

      echo
      echo "### $label"
      echo "$start -> $finish"

      find \
                  $SCAN_ROOTS \
                  -type f \
                  -newermt "$start" \
                  ! -newermt "$finish" \
                  -print0 \
                  2>/dev/null \
                  | sort -z \
                  | while read -z path
          stat \
                              --printf='birth=%w|mtime=%y|size=%s|%n\n' \
                              "$path"
      end
  end

  echo
  echo "============================================================"
  echo "8. CATALOG STORAGE AND CACHE STRINGS"
  echo "============================================================"

  set STORAGE_ROOTS

  for candidate in \
          "$CATALOG_ROAMING" \
          "$WEBVIEW/Default/Cache/Cache_Data" \
          "$WEBVIEW/Default/Code Cache/js" \
          "$WEBVIEW/Default/Local Storage/leveldb" \
          "$WEBVIEW/Default/Session Storage" \
          "$WEBVIEW/Default/IndexedDB"

      if test -d "$candidate"
          set -a STORAGE_ROOTS "$candidate"
      end
  end

  find \
          $STORAGE_ROOTS \
          -type f \
          -size -100M \
          -print0 \
          2>/dev/null \
          | sort -z \
          | while read -z path
      set -l matches \
                      (relevant_strings "$path")

      if test (count $matches) -gt 0
          echo
          echo "=== $path ==="

          stat \
                              --printf='birth=%w\nmtime=%y\nsize=%s\n' \
                              "$path"

          printf '%s\n' \
                              $matches
      end
  end

  echo
  echo "============================================================"
  echo "9. TARGET PE METADATA"
  echo "============================================================"

  if command -q llvm-readobj
      llvm-readobj \
                  --file-headers \
                  --sections \
                  --coff-imports \
                  "$TARGET" \
                  | sed -n '1,1200p'
  else if command -q objdump
      objdump \
                  -x \
                  "$TARGET" \
                  | sed -n '1,1200p'
  else
      echo "llvm-readobj and objdump are unavailable"
  end

  functions -e show_file
  functions -e relevant_strings

  echo
  echo "============================================================"
  echo "END OF STRICTLY READ-ONLY FINAL PROVENANCE"
  echo "============================================================"
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(230).txt:2-351` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

読み取り専用監査。ファイル変更なしとコマンド内で明示されているものを含む。

#### 関連する固定値

- 短縮commit: `20260731`
- path: `$HOME/Games/aviutl2`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(230).txt lines 2-351`

---
### コマンド 300 — `V231-01`

#### 目的

保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
  set ROOT \
          "$HOME/Games/aviutl2"

  set SRC \
          "$ROOT/src/L-SMASH-Works-nvdec"

  set CUSTOM_BIN \
          "$SRC/AviUtl2/lwinput.aui2"

  set GOOD \
          "$ROOT/prefix-ge-nvdec-test.backup-20260731-135410"

  set OFFICIAL_BIN \
          "$GOOD/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2"

  set OLD_BIN \
          "$GOOD/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2.before-hwframe-transfer-20260731-042746"

  set PATCH_FILE \
          "$HOME/projects/aviutl2-linux-patches/patches/l-smash-works/0001-transfer-hardware-frames-before-output.patch"

      set -l path "$argv[1]"

  set CHANGED_FILES \
          (

  set TRANSFER_MATCHES \
          (

      set TRANSFER_FILES

          set -l without_revision \
                          (string replace -r '^HEAD:' '' -- "$match")

          set -l path \
                          (string split -m1 ':' -- "$without_revision")[1]

              set -a TRANSFER_FILES "$path"

GIT_OPTIONAL_LOCKS=0
```

#### 実行コマンド

```fish
# ============================================================
  # L-SMASH Works r1283 vs local NVDEC patch provenance
  # Fish-compatible / STRICTLY READ-ONLY
  # ============================================================

  set ROOT \
          "$HOME/Games/aviutl2"

  set SRC \
          "$ROOT/src/L-SMASH-Works-nvdec"

  set CUSTOM_BIN \
          "$SRC/AviUtl2/lwinput.aui2"

  set GOOD \
          "$ROOT/prefix-ge-nvdec-test.backup-20260731-135410"

  set OFFICIAL_BIN \
          "$GOOD/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2"

  set OLD_BIN \
          "$GOOD/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2.before-hwframe-transfer-20260731-042746"

  set PATCH_FILE \
          "$HOME/projects/aviutl2-linux-patches/patches/l-smash-works/0001-transfer-hardware-frames-before-output.patch"

  if not test -d "$SRC/.git"
      echo "ERROR: Git repository not found:"
      echo "$SRC"
      exit 1
  end

  function section
      echo
      echo "============================================================"
      echo "$argv"
      echo "============================================================"
  end

  function show_binary
      set -l path "$argv[1]"

      echo
      echo "=== $path ==="

      if test -f "$path"
          stat \
                          --printf='birth=%w\nmtime=%y\nctime=%z\nsize=%s\ninode=%i\n' \
                          "$path"

          file -- "$path"
          sha256sum -- "$path"

          echo
          echo "-- version/build markers --"

          begin
              strings \
                                  -a \
                                  -n 6 \
                                  -- \
                                  "$path" \
                                  2>/dev/null

              strings \
                                  -a \
                                  --encoding=l \
                                  -n 6 \
                                  -- \
                                  "$path" \
                                  2>/dev/null
          end \
                          | grep \
                              -iE \
                              'L-SMASH Works File Reader|r12[0-9]{2}|Mr-Ojii|av_hwframe_transfer_data|av1_cuvid|hw_frames_ctx|AV_PIX_FMT_CUDA|L-SMASH-Works-Auto-Builds' \
                          | sort -u \
                          | sed -n '1,300p'
      else
          echo "MISSING"
      end
  end

  section "1. REPOSITORY IDENTITY"

  GIT_OPTIONAL_LOCKS=0 \
      git \
          -C "$SRC" \
          status \
          --short \
          --branch

  echo
  echo "-- remotes --"

  GIT_OPTIONAL_LOCKS=0 \
      git \
          -C "$SRC" \
          remote \
          -v

  echo
  echo "-- current branch --"

  GIT_OPTIONAL_LOCKS=0 \
      git \
          -C "$SRC" \
          branch \
          --show-current

  echo
  echo "-- exact commits --"

  for revision in \
          HEAD \
          HEAD^ \
          HEAD^^

      echo
      echo "### $revision"

      GIT_OPTIONAL_LOCKS=0 \
              git \
                  -C "$SRC" \
                  show \
                  -s \
                  --format='commit=%H%nparents=%P%nauthor=%an <%ae>%nauthor_date=%aI%ncommitter=%cn <%ce>%ncommit_date=%cI%nsubject=%s' \
                  "$revision"
  end

  section "2. BRANCHES, TAGS, AND DESCRIPTIONS"

  for revision in \
          HEAD \
          HEAD^ \
          HEAD^^

      echo
      echo "### $revision"

      echo "-- describe --"

      GIT_OPTIONAL_LOCKS=0 \
              git \
                  -C "$SRC" \
                  describe \
                  --always \
                  --tags \
                  "$revision"

      echo "-- branches containing commit --"

      GIT_OPTIONAL_LOCKS=0 \
              git \
                  -C "$SRC" \
                  branch \
                  --all \
                  --contains \
                  "$revision"

      echo "-- tags containing commit --"

      GIT_OPTIONAL_LOCKS=0 \
              git \
                  -C "$SRC" \
                  tag \
                  --contains \
                  "$revision"
  end

  echo
  echo "-- recent decorated history --"

  GIT_OPTIONAL_LOCKS=0 \
      git \
          -C "$SRC" \
          log \
          --all \
          --decorate \
          --date=iso-strict \
          --format='%H|%P|%ad|%D|%s' \
          -n 80

  echo
  echo "-- commits mentioning r1282/r1283 or hardware frames --"

  GIT_OPTIONAL_LOCKS=0 \
      git \
          -C "$SRC" \
          log \
          --all \
          --regexp-ignore-case \
          --extended-regexp \
          --grep='r1282|r1283|hardware frame|hwframe|NVDEC|CUDA' \
          --date=iso-strict \
          --format='%H|%P|%ad|%D|%s' \
          -n 100

  section "3. LOCAL PATCH COMMIT"

  GIT_OPTIONAL_LOCKS=0 \
      git \
          -C "$SRC" \
          show \
          --format=fuller \
          --stat \
          --summary \
          HEAD

  echo
  echo "-- exact HEAD diff --"

  GIT_OPTIONAL_LOCKS=0 \
      git \
          -C "$SRC" \
          diff \
          --no-ext-diff \
          --no-renames \
          --find-copies-harder \
          HEAD^ \
          HEAD \
          -- \
          | sed -n '1,1600p'

  section "4. TRANSFER-RELATED SOURCE AT PARENT"

  echo "-- git grep HEAD^ --"

  GIT_OPTIONAL_LOCKS=0 \
      git \
          -C "$SRC" \
          grep \
          -n \
          -I \
          -E \
          'av_hwframe_transfer_data|av_hwframe_get_buffer|hw_frames_ctx|hw_device_ctx|AV_PIX_FMT_CUDA|AV_HWDEVICE_TYPE_CUDA|av1_cuvid' \
          HEAD^ \
          -- \
          2>/dev/null \
          | sed -n '1,1000p'

  section "5. TRANSFER-RELATED SOURCE AT PATCHED HEAD"

  echo "-- git grep HEAD --"

  GIT_OPTIONAL_LOCKS=0 \
      git \
          -C "$SRC" \
          grep \
          -n \
          -I \
          -E \
          'av_hwframe_transfer_data|av_hwframe_get_buffer|hw_frames_ctx|hw_device_ctx|AV_PIX_FMT_CUDA|AV_HWDEVICE_TYPE_CUDA|av1_cuvid' \
          HEAD \
          -- \
          2>/dev/null \
          | sed -n '1,1000p'

  section "6. EXACT FILES CHANGED BY PATCH"

  set CHANGED_FILES \
          (
      GIT_OPTIONAL_LOCKS=0 \
                  git \
                      -C "$SRC" \
                      diff \
                      --name-only \
                      HEAD^ \
                      HEAD
  )

  printf '%s\n' \
          $CHANGED_FILES

  for path in $CHANGED_FILES
      echo
      echo "############################################################"
      echo "FILE: $path"
      echo "############################################################"

      echo
      echo "-- parent version --"

      GIT_OPTIONAL_LOCKS=0 \
              git \
                  -C "$SRC" \
                  show \
                  "HEAD^:$path" \
                  2>/dev/null \
                  | nl -ba \
                  | sed -n '1,1600p'

      echo
      echo "-- patched version --"

      GIT_OPTIONAL_LOCKS=0 \
              git \
                  -C "$SRC" \
                  show \
                  "HEAD:$path" \
                  2>/dev/null \
                  | nl -ba \
                  | sed -n '1,1600p'
  end

  section "7. REVISION AND VERSION DEFINITIONS"

  for revision in \
          HEAD^ \
          HEAD

      echo
      echo "### $revision"

      GIT_OPTIONAL_LOCKS=0 \
              git \
                  -C "$SRC" \
                  grep \
                  -n \
                  -I \
                  -E \
                  'r1282|r1283|REVISION|Revision|revision|VERSION|Version|version|L-SMASH Works File Reader' \
                  "$revision" \
                  -- \
                  2>/dev/null \
                  | grep \
                      -iE \
                      'r1282|r1283|revision|version|L-SMASH Works File Reader' \
                  | sed -n '1,1000p'
  end

  section "8. SOURCE CONTEXT AROUND TRANSFER CALL"

  set TRANSFER_MATCHES \
          (
      GIT_OPTIONAL_LOCKS=0 \
                  git \
                      -C "$SRC" \
                      grep \
                      -n \
                      -I \
                      'av_hwframe_transfer_data' \
                      HEAD \
                      -- \
                      2>/dev/null
  )

  if test (count $TRANSFER_MATCHES) -eq 0
      echo "NO av_hwframe_transfer_data CALL FOUND AT HEAD"
  else
      printf '%s\n' \
                  $TRANSFER_MATCHES

      set TRANSFER_FILES

      for match in $TRANSFER_MATCHES
          set -l without_revision \
                          (string replace -r '^HEAD:' '' -- "$match")

          set -l path \
                          (string split -m1 ':' -- "$without_revision")[1]

          if not contains -- "$path" $TRANSFER_FILES
              set -a TRANSFER_FILES "$path"
          end
      end

      for path in $TRANSFER_FILES
          echo
          echo "############################################################"
          echo "PATCHED FILE: $path"
          echo "############################################################"

          GIT_OPTIONAL_LOCKS=0 \
                      git \
                          -C "$SRC" \
                          show \
                          "HEAD:$path" \
                          | nl -ba \
                          | sed -n '1,1800p'
      end
  end

  section "9. PATCH FILE STORED IN PROJECT"

  if test -f "$PATCH_FILE"
      stat \
                  --printf='birth=%w\nmtime=%y\nctime=%z\nsize=%s\ninode=%i\n' \
                  "$PATCH_FILE"

      sha256sum -- \
                  "$PATCH_FILE"

      sed -n \
                  '1,1600p' \
                  "$PATCH_FILE"
  else
      echo "MISSING:"
      echo "$PATCH_FILE"
  end

  section "10. THREE BINARY IDENTITIES"

  show_binary "$OLD_BIN"
  show_binary "$OFFICIAL_BIN"
  show_binary "$CUSTOM_BIN"

  section "11. CUSTOM BINARY VS SOURCE REVISION"

  echo "-- custom binary exact r-number strings --"

  if test -f "$CUSTOM_BIN"
      begin
          strings \
                          -a \
                          -n 5 \
                          -- \
                          "$CUSTOM_BIN" \
                          2>/dev/null

          strings \
                          -a \
                          --encoding=l \
                          -n 5 \
                          -- \
                          "$CUSTOM_BIN" \
                          2>/dev/null
      end \
                  | grep \
                      -E \
                      'L-SMASH Works File Reader for AviUtl2 r[0-9]+' \
                  | sort -u
  else
      echo "CUSTOM BINARY MISSING"
  end

  echo
  echo "-- official binary exact r-number strings --"

  if test -f "$OFFICIAL_BIN"
      begin
          strings \
                          -a \
                          -n 5 \
                          -- \
                          "$OFFICIAL_BIN" \
                          2>/dev/null

          strings \
                          -a \
                          --encoding=l \
                          -n 5 \
                          -- \
                          "$OFFICIAL_BIN" \
                          2>/dev/null
      end \
                  | grep \
                      -E \
                      'L-SMASH Works File Reader for AviUtl2 r[0-9]+' \
                  | sort -u
  else
      echo "OFFICIAL BINARY MISSING"
  end

  section "12. OBJECT-LEVEL CALL AND SYMBOL CLUES"

  for path in \
          "$OFFICIAL_BIN" \
          "$CUSTOM_BIN"

      echo
      echo "############################################################"
      echo "$path"
      echo "############################################################"

      if not test -f "$path"
          echo "MISSING"
          continue
      end

      if command -q llvm-readobj
          llvm-readobj \
                          --file-headers \
                          --sections \
                          --coff-imports \
                          --coff-exports \
                          "$path" \
                          | sed -n '1,1600p'
      else if command -q objdump
          objdump \
                          -x \
                          "$path" \
                          | sed -n '1,1600p'
      else
          echo "llvm-readobj and objdump unavailable"
      end

      echo
      echo "-- symbol/string references --"

      if command -q objdump
          objdump \
                          -t \
                          "$path" \
                          2>/dev/null \
                          | grep \
                              -iE \
                              'hwframe|hw_frame|transfer|video_output|output_video|lwlibav' \
                          | sed -n '1,500p'
      end
  end

  functions -e section
  functions -e show_binary

  echo
  echo "============================================================"
  echo "END OF STRICTLY READ-ONLY R1283/PATCH INVESTIGATION"
  echo "============================================================"
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(231).txt:2-519` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

読み取り専用監査。ファイル変更なしとコマンド内で明示されているものを含む。

#### 関連する固定値

- 短縮commit: `20260731`
- version: `r1283`
- version: `r1282`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/projects/aviutl2-linux-patches/patches/l-smash-works/0001-transfer-hardware-frames-before-output.patch`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(231).txt lines 2-519`

---
### コマンド 301 — `V233-01`

#### 目的

保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
  set ROOT \
          "$HOME/Games/aviutl2"

  set BUILD_ROOT \
          "$ROOT/build/l-smash-works-nvdec"

  set DEPS \
          "$BUILD_ROOT/deps"

  set PREFIX \
          "$BUILD_ROOT/prefix"

  set TOOLBIN \
          "$BUILD_ROOT/bin"

  set LSW_SRC \
          "$ROOT/src/L-SMASH-Works-nvdec"

  set AUTO_BUILD \
          "$BUILD_ROOT/auto-build"

  set PATCH_REPO \
          "$HOME/projects/aviutl2-linux-patches"

      set -l label "$argv[1]"

      set -l repo "$argv[2]"

                                                                             set -l path "$argv[1]"

                                                                set -l parts \
                                                                                         (string split -m1 '|' -- "$spec")

                                                                           set -l tool_path \
                  (command -s "$tool")

      set -l resolved \
                  (readlink -f -- "$tool_path")

      set -l file_size \
                  (stat -c '%s' -- "$path")

  set CUSTOM_LWINPUT \
          "$LSW_SRC/AviUtl2/lwinput.aui2"

GIT_OPTIONAL_LOCKS=0
```

#### 実行コマンド

```fish
# ============================================================
  # L-SMASH Works NVDEC dependency and toolchain provenance
  # Fish-compatible / STRICTLY READ-ONLY
  # ============================================================

  set ROOT \
          "$HOME/Games/aviutl2"

  set BUILD_ROOT \
          "$ROOT/build/l-smash-works-nvdec"

  set DEPS \
          "$BUILD_ROOT/deps"

  set PREFIX \
          "$BUILD_ROOT/prefix"

  set TOOLBIN \
          "$BUILD_ROOT/bin"

  set LSW_SRC \
          "$ROOT/src/L-SMASH-Works-nvdec"

  set AUTO_BUILD \
          "$BUILD_ROOT/auto-build"

  set PATCH_REPO \
          "$HOME/projects/aviutl2-linux-patches"

  function section
      echo
      echo "============================================================"
      echo "$argv"
      echo "============================================================"
  end

  function show_repo
      set -l label "$argv[1]"
      set -l repo "$argv[2]"

      echo
      echo "############################################################"
      echo "REPOSITORY: $label"
      echo "PATH: $repo"
      echo "############################################################"

      if not test -e "$repo/.git"
          echo "NOT A GIT WORKTREE"
                                                                  return
                                                                                 end

                                                                                        echo
      echo "-- repository identity --"

                                                           env GIT_OPTIONAL_LOCKS=0 \
                  git \
                                                                                      -C "$repo" \
                  rev-parse \
                                                                                --is-inside-work-tree

                                                          env GIT_OPTIONAL_LOCKS=0 \
                  git \
                                                                                      -C "$repo" \
                  rev-parse \
                                                                                --is-shallow-repository

                                                        echo
      echo "-- HEAD --"

      env GIT_OPTIONAL_LOCKS=0 \
                                                                             git \
                  -C "$repo" \
                                                                               show \
                                                                                     -s \
                  --format='commit=%H%nparents=%P%nauthor=%an <%ae>%nauthor_date=%aI%ncommitter=%cn <%ce>%ncommit_date=%cI%nsubject=%s' \
                  HEAD

      echo
                                                                                       echo "-- describe --"

                                                                      env GIT_OPTIONAL_LOCKS=0 \
                  git \
                                                                                      -C "$repo" \
                                                                               describe \
                  --always \
                                                                                 --tags \
                  --dirty \
                                                                                  HEAD

                                                                           echo
      echo "-- current branch --"

      env GIT_OPTIONAL_LOCKS=0 \
                                                                             git \
                                                                                      -C "$repo" \
                  branch \
                                                                                   --show-current

                                                                 echo
      echo "-- tags pointing at HEAD --"

      env GIT_OPTIONAL_LOCKS=0 \
                                                                             git \
                  -C "$repo" \
                                                                               tag \
                                                                                      --points-at \
                  HEAD

      echo
                                                                                       echo "-- remotes --"

                                                                       env GIT_OPTIONAL_LOCKS=0 \
                  git \
                                                                                      -C "$repo" \
                  remote \
                                                                                   -v

      echo
                                                                                       echo "-- tracked worktree status --"

                                                       env GIT_OPTIONAL_LOCKS=0 \
                  git \
                                                                                      -C "$repo" \
                  status \
                                                                                   --short \
                  --branch \
                                                                                 --untracked-files=no

      echo
                                                                                       echo "-- unstaged tracked diff --"

                                                         if env GIT_OPTIONAL_LOCKS=0 \
                      git \
                                                                                      -C "$repo" \
                      diff \
                                                                                     --quiet \
                      --ignore-submodules \
                                                                      --
                                                                             echo "NONE"
      else
                                                                                           env GIT_OPTIONAL_LOCKS=0 \
                          git \
                                                                                      -C "$repo" \
                          diff \
                                                                                     --stat \
                          --ignore-submodules \
                                                                      --
      end

                                                                                        echo
      echo "-- staged diff --"

      if env GIT_OPTIONAL_LOCKS=0 \
                                                                              git \
                      -C "$repo" \
                                                                               diff \
                      --cached \
                                                                                 --quiet \
                      --ignore-submodules \
                                                                      --
          echo "NONE"
                                                                            else
                                                                                           env GIT_OPTIONAL_LOCKS=0 \
                          git \
                                                                                      -C "$repo" \
                          diff \
                                                                                     --cached \
                          --stat \
                                                                                   --ignore-submodules \
                                                                      --
      end

                                                                                        echo
      echo "-- reflog --"

                                                                        env GIT_OPTIONAL_LOCKS=0 \
                                                                             git \
                  -C "$repo" \
                                                                               reflog \
                  show \
                                                                                     --date=iso-strict \
                  --format='%H|%gD|%cd|%gs' \
                                                                -n 20
  end

  function show_file
                                                                             set -l path "$argv[1]"

      echo
                                                                                       echo "=== $path ==="

                                                                       if not test -e "$path"
          echo "MISSING"
                                                                             return
      end

      stat \
                                                                                                 --printf='birth=%w\nmtime=%y\nctime=%z\nsize=%s\ninode=%i\n' \
                             "$path"

                                                                        file -- \
                  "$path"

      if test -f "$path"
                                                                             sha256sum -- \
                                                                                             "$path"
      end
                                                                                    end

  section "1. EXACT SOURCE REPOSITORY COMMITS"

  for spec in \
                                                                                      "aviutl2-linux-patches|$PATCH_REPO" \
                                                      "L-SMASH-Works patched|$LSW_SRC" \
          "L-SMASH-Works-Auto-Builds|$AUTO_BUILD" \
                                                  "zlib|$DEPS/zlib" \
                                                                        "game-music-emu|$DEPS/game-music-emu" \
          "dav1d|$DEPS/dav1d" \
                                                                      "libvpx|$DEPS/libvpx" \
          "nv-codec-headers|$DEPS/nv-codec-headers" \
                                                "libvpl|$DEPS/libvpl" \
          "FFmpeg|$DEPS/FFmpeg" \
                                                                    "obuparse|$DEPS/obuparse" \
                                                                "l-smash|$DEPS/l-smash"

                                                                set -l parts \
                                                                                         (string split -m1 '|' -- "$spec")

                                              show_repo \
                                                                                            "$parts[1]" \
                  "$parts[2]"
                                                                end

                                                                                        section "2. BUILD TOOL LOCATIONS AND VERSIONS"

                                             for tool in \
                                                                                      git \
          python3 \
                                                                                  make \
                                                                                     cmake \
          meson \
                                                                                    ninja \
                                                                                    nasm \
          pkg-config \
                                                                               x86_64-w64-mingw32-pkg-config \
                                                            x86_64-w64-mingw32-gcc \
          x86_64-w64-mingw32-g++ \
                                                                   x86_64-w64-mingw32-ar \
          x86_64-w64-mingw32-ranlib \
                                                                x86_64-w64-mingw32-strip \
          x86_64-w64-mingw32-windres

                                                             echo
      echo "### $tool"

                                                                           set -l tool_path \
                  (command -s "$tool")

                                                           if test -z "$tool_path"
          echo "NOT FOUND"
          continue
      end

      echo "path=$tool_path"

      set -l resolved \
                  (readlink -f -- "$tool_path")

      echo "resolved=$resolved"

      show_file "$resolved"

      switch "$tool"
          case nasm
              "$tool_path" -v 2>&1 \
                                  | sed -n '1,20p'

          case ninja
              "$tool_path" --version 2>&1 \
                                  | sed -n '1,20p'

          case pkg-config x86_64-w64-mingw32-pkg-config
              "$tool_path" --version 2>&1 \
                                  | sed -n '1,20p'

          case '*'
              "$tool_path" --version 2>&1 \
                                  | sed -n '1,20p'
      end

      if test -f "$resolved"
          if grep -Iq . "$resolved"
              echo
              echo "-- textual tool contents --"

              sed -n \
                                  '1,300p' \
                                  "$resolved"
          end
      end
  end

  section "3. RELEVANT PACMAN PACKAGE VERSIONS"

  for package in \
          git \
          python \
          make \
          cmake \
          meson \
          ninja \
          nasm \
          autoconf \
          automake \
          libtool \
          pkgconf \
          mingw-w64-binutils \
          mingw-w64-crt \
          mingw-w64-gcc \
          mingw-w64-headers \
          mingw-w64-winpthreads \
          nvidia-utils

      if not pacman -Q "$package" 2>/dev/null
          echo "$package: NOT INSTALLED"
      end
  end

  echo
  echo "-- kernel and system --"

  uname -a

  echo
  echo "-- GPU and driver --"

  if command -q nvidia-smi
      nvidia-smi \
                  --query-gpu=name,driver_version \
                  --format=csv,noheader \
                  2>/dev/null
  else
      echo "nvidia-smi unavailable"
  end

  section "4. CUSTOM TOOLBIN CONTENTS"

  if test -d "$TOOLBIN"
      find \
                  "$TOOLBIN" \
                  -maxdepth 1 \
                  \( \
                      -type f \
                      -o -type l \
                  \) \
                  -print0 \
                  2>/dev/null \
                  | sort -z \
                  | while read -z path
          show_file "$path"

          if test -L "$path"
              echo "symlink_target="(readlink -- "$path")
              echo "resolved_target="(readlink -f -- "$path")
          end

          if test -f "$path"
              if grep -Iq . "$path"
                  echo
                  sed -n \
                                              '1,300p' \
                                              "$path"
              end
          end
      end
  else
      echo "MISSING:"
      echo "$TOOLBIN"
  end

  section "5. EXACT BUILD CONFIGURATION FILES"

  for path in \
          "$BUILD_ROOT/x86_64-w64-mingw32.cmake" \
          "$DEPS/FFmpeg/config.h" \
          "$DEPS/FFmpeg/ffbuild/config.mak" \
          "$DEPS/FFmpeg/ffbuild/config.log" \
          "$DEPS/l-smash/config.h" \
          "$DEPS/l-smash/config.mak" \
          "$LSW_SRC/AviUtl2/config.h" \
          "$LSW_SRC/AviUtl2/config.mak" \
          "$LSW_SRC/AviUtl2/config.log"

      show_file "$path"

      if not test -f "$path"
          continue
      end

      echo
      echo "-- relevant configuration --"

      grep \
                  -inE \
                  'CONFIG_(CUVID|AV1_CUVID_DECODER|FFNVCODEC|LIBDAV1D|LIBVPX|LIBVPL)|FFMPEG_CONFIGURATION|^CC=|^CXX=|^LD=|^AR=|^RANLIB=|^STRIP=|^WINDRES=|^CFLAGS=|^CXXFLAGS=|^LDFLAGS=|^EXTRALIBS=|^prefix=|cross-prefix|target-os|mingw|gcc version|g\+\+ version|nv-codec|av1_cuvid|pkg-config' \
                  "$path" \
                  2>/dev/null \
                  | sed -n '1,1000p'

      set -l file_size \
                  (stat -c '%s' -- "$path")

      if test "$file_size" -le 20000
          echo
          echo "-- complete small configuration file --"

          sed -n \
                          '1,1500p' \
                          "$path"
      end
  end

  section "6. INSTALLED PKG-CONFIG METADATA"

  if test -d "$PREFIX/lib/pkgconfig"
      find \
                  "$PREFIX/lib/pkgconfig" \
                  -maxdepth 1 \
                  -type f \
                  -name '*.pc' \
                  -print0 \
                  2>/dev/null \
                  | sort -z \
                  | while read -z path
          show_file "$path"

          echo
          sed -n \
                              '1,300p' \
                              "$path"
      end
  else
      echo "MISSING:"
      echo "$PREFIX/lib/pkgconfig"
  end

  section "7. STATIC LIBRARY ARTIFACT HASHES"

  if test -d "$PREFIX/lib"
      find \
                  "$PREFIX/lib" \
                  -maxdepth 3 \
                  -type f \
                  \( \
                      -name '*.a' \
                      -o -name '*.dll.a' \
                  \) \
                  -print0 \
                  2>/dev/null \
                  | sort -z \
                  | while read -z path
          echo
          stat \
                              --printf='mtime=%y|size=%s|%n\n' \
                              "$path"

          sha256sum -- \
                              "$path"

          file -- \
                              "$path"
      end
  else
      echo "MISSING:"
      echo "$PREFIX/lib"
  end

  section "8. FINAL PATCHED LWINPUT IDENTITY"

  set CUSTOM_LWINPUT \
          "$LSW_SRC/AviUtl2/lwinput.aui2"

  show_file "$CUSTOM_LWINPUT"

  if test -f "$CUSTOM_LWINPUT"
      echo
      echo "-- embedded build and version markers --"

      begin
          strings \
                          -a \
                          -n 5 \
                          -- \
                          "$CUSTOM_LWINPUT" \
                          2>/dev/null

          strings \
                          -a \
                          --encoding=l \
                          -n 5 \
                          -- \
                          "$CUSTOM_LWINPUT" \
                          2>/dev/null
      end \
                  | grep \
                      -E \
                      'L-SMASH Works File Reader for AviUtl2 r[0-9]+|av1_cuvid|enable-cuvid|enable-decoder=av1_cuvid|cross-prefix|target-os|extra-cflags|extra-ldflags' \
                  | sort -u \
                  | sed -n '1,500p'
  end

  functions -e section
  functions -e show_repo
  functions -e show_file

  echo
  echo "============================================================"
  echo "END OF STRICTLY READ-ONLY DEPENDENCY PROVENANCE"
  echo "============================================================"
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(233).txt:2-520` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

読み取り専用監査。ファイル変更なしとコマンド内で明示されているものを含む。

#### 関連する固定値

- path: `$HOME/Games/aviutl2`
- path: `$HOME/projects/aviutl2-linux-patches`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(233).txt lines 2-520`

---
### コマンド 302 — `V234-01`

#### 目的

保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
  set ROOT \
          "$HOME/Games/aviutl2"

  set GOOD \
          "$ROOT/prefix-ge-nvdec-test.backup-20260731-135410"

  set ROAMING \
          "$GOOD/drive_c/users/steamuser/AppData/Roaming/aviutl2-catalog"

  set LOCAL \
          "$GOOD/drive_c/users/steamuser/AppData/Local"

  set SETTINGS \
          "$ROAMING/settings.json"

  set PACKAGE_ID \
          "Mr-Ojii.L-SMASH-Works"

          set -l matches \
                              (

      set -l matches \
                                                                                           (
```

#### 実行コマンド

```fish
# ============================================================
  # AviUtl2 Catalog package-update pause investigation
  # Fish-compatible / STRICTLY READ-ONLY
  # ============================================================

  set ROOT \
          "$HOME/Games/aviutl2"

  set GOOD \
          "$ROOT/prefix-ge-nvdec-test.backup-20260731-135410"

  set ROAMING \
          "$GOOD/drive_c/users/steamuser/AppData/Roaming/aviutl2-catalog"

  set LOCAL \
          "$GOOD/drive_c/users/steamuser/AppData/Local"

  set SETTINGS \
          "$ROAMING/settings.json"

  set PACKAGE_ID \
          "Mr-Ojii.L-SMASH-Works"

  function section
      echo
      echo "============================================================"
      echo "$argv"
      echo "============================================================"
  end

  section "1. CURRENT CATALOG SETTINGS"

  if test -f "$SETTINGS"
      stat \
                  --printf='birth=%w\nmtime=%y\nsize=%s\n' \
                  "$SETTINGS"

      sha256sum -- \
                  "$SETTINGS"

      cat -- \
                  "$SETTINGS"
  else
      echo "MISSING:"
      echo "$SETTINGS"
  end

  section "2. PACKAGE ID AND PAUSE-SETTING REFERENCES"

                                       for root in \
          "$ROAMING" \
                                                                               "$LOCAL"

                                                                               if not test -d "$root"
          continue
      end

      echo
                                                                                       echo "### ROOT: $root"

                                                                     find \
                  "$root" \
                  -type f \
                                                                                  -size -30M \
                  -print0 \
                                                                                  2>/dev/null \
                  | sort -z \
                                                                                | while read -z path
          set -l matches \
                              (
                                                                          grep \
                                          -ainI \
                                                                                    -E \
                                          'package_updates_paused_ids|Mr-Ojii\.L-SMASH-Works|pause.*update|update.*pause|paused.*package|package.*paused' \
                                          "$path" \
                                                                                  2>/dev/null \
                                          | sed -n '1,300p'
                                          )

                                                                                          if test (count $matches) -gt 0
              echo
              echo "=== $path ==="

              stat \
                                                                                                             --printf='birth=%w\nmtime=%y\nsize=%s\n' \
                                      "$path"

              printf '%s\n' \
                                      $matches
                                                       end
      end
                                                                                    end

                                                                                        section "3. CATALOG EXECUTABLE AND RESOURCE LOCATIONS"

  find \
                                                                                             "$LOCAL" \
          -maxdepth 5 \
                                                                              \( \
              -type f \
                                                                                  -o -type d \
          \) \
          \( \
                                                                                           -iname '*catalog*' \
              -o -iname '*.exe' \
                                                                        -o -iname '*.json' \
              -o -iname '*.js' \
                                                                         -o -iname '*.html' \
          \) \
          -printf '%y|%s|%p\n' \
                                                                     2>/dev/null \
          | sort \
                                                                                   | sed -n '1,1500p'

  section "4. INSTALLED EXECUTABLE STRING REFERENCES"

                                        find \
          "$LOCAL" \
                                                                                 -type f \
          \( \
              -iname 'AviUtl2_Catalog.exe' \
              -o -iname '*catalog*.exe' \
          \) \
          -print0 \
          2>/dev/null \
          | sort -z \
          | while read -z exe
      echo
      echo "=== $exe ==="

      stat \
                      --printf='birth=%w\nmtime=%y\nsize=%s\n' \
                      "$exe"

      sha256sum -- \
                      "$exe"

                                                                     strings \
                      -a \
                      -n 6 \
                      -- \
                      "$exe" \
                      2>/dev/null \
                      | grep \
                          -iE \
                          'package_updates_paused_ids|paused_ids|pause.*update|update.*pause|package.*install|automatic.*update|check.*update|github\.com/.*/AviUtl2' \
                      | sort -u \
                      | sed -n '1,1000p'
  end

  section "5. CATALOG LOGS FOR L-SMASH OPERATIONS"

  find \
          "$ROAMING" \
          "$LOCAL" \
          -type f \
          -size -30M \
          \( \
                                                                                           -iname '*.log' \
              -o -iname '*.txt' \
                                                                        -o -iname '*.json' \
          \) \
                                                                                       -print0 \
          2>/dev/null \
          | sort -z \
                                                                                | while read -z path
      set -l matches \
                                                                                           (
          grep \
                                                                                                             -ainI \
                                  -E \
                                  'Mr-Ojii\.L-SMASH-Works|package_updates_paused_ids|start version=r128|type=(install|update)|uninstall.*lwinput|lwinput\.aui2' \
                                  "$path" \
                                  2>/dev/null \
                                  | sed -n '1,500p'
      )

      if test (count $matches) -gt 0
          echo
          echo "=== $path ==="

          stat \
                              --printf='birth=%w\nmtime=%y\nsize=%s\n' \
                              "$path"

          printf '%s\n' \
                              $matches
      end
  end

  section "6. READ-ONLY GITHUB CODE SEARCH"

  if command -q gh
      echo
      echo "-- search exact setting name --"

      gh search code \
                  '"package_updates_paused_ids"' \
                  --limit 30 \
                  --json repository,path,url \
                  2>&1

      echo
      echo "-- search package identifier --"

      gh search code \
                  '"Mr-Ojii.L-SMASH-Works"' \
                  --limit 30 \
                  --json repository,path,url \
                  2>&1
  else
      echo "gh unavailable"
  end

  functions -e section

  echo
  echo "============================================================"
  echo "END OF STRICTLY READ-ONLY CATALOG UPDATE INVESTIGATION"
  echo "============================================================"
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(234).txt:2-221` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

読み取り専用監査。ファイル変更なしとコマンド内で明示されているものを含む。

#### 関連する固定値

- 短縮commit: `20260731`
- version: `r128`
- path: `$HOME/Games/aviutl2`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(234).txt lines 2-221`

---
### コマンド 303 — `V235-01`

#### 目的

保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
  set ROOT \
          "$HOME/Games/aviutl2"

  set GOOD \
          "$ROOT/prefix-ge-nvdec-test.backup-20260731-135410"

  set ROAMING \
          "$GOOD/drive_c/users/steamuser/AppData/Roaming/aviutl2-catalog"

  set INDEX \
          "$ROAMING/catalog/index.json"

  set HASH_CACHE \
          "$ROAMING/hash-cache.json"

  set INSTALLED \
          "$ROAMING/installed.json"

  set ACTIVE \
          "$GOOD/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2"

  set CUSTOM \
          "$ROOT/src/L-SMASH-Works-nvdec/AviUtl2/lwinput.aui2"

  set PACKAGE_ID \
          "Mr-Ojii.L-SMASH-Works"
```

#### 実行コマンド

```fish
# ============================================================
  # Catalog L-SMASH Works hash-classification proof
  # Fish-compatible / STRICTLY READ-ONLY
  # ============================================================

  set ROOT \
          "$HOME/Games/aviutl2"

  set GOOD \
          "$ROOT/prefix-ge-nvdec-test.backup-20260731-135410"

  set ROAMING \
          "$GOOD/drive_c/users/steamuser/AppData/Roaming/aviutl2-catalog"

  set INDEX \
          "$ROAMING/catalog/index.json"

  set HASH_CACHE \
          "$ROAMING/hash-cache.json"

  set INSTALLED \
          "$ROAMING/installed.json"

  set ACTIVE \
          "$GOOD/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2"

  set CUSTOM \
          "$ROOT/src/L-SMASH-Works-nvdec/AviUtl2/lwinput.aui2"

  set PACKAGE_ID \
          "Mr-Ojii.L-SMASH-Works"

  python3 -c '
  import ctypes
  import ctypes.util
  import hashlib
  import json
  import pathlib
  import sys

  index_path = pathlib.Path(sys.argv[1])
  cache_path = pathlib.Path(sys.argv[2])
  installed_path = pathlib.Path(sys.argv[3])
  active_path = pathlib.Path(sys.argv[4])
  custom_path = pathlib.Path(sys.argv[5])
  package_id = sys.argv[6]

  def heading(title):
      print()
      print("=" * 60)
      print(title)
      print("=" * 60)

  def load_json(path):
      if not path.is_file():
          print(f"MISSING: {path}")
          return None

      return json.loads(
                                                                             path.read_text(
              encoding="utf-8-sig",
          )
      )

  def find_package(value):
      found = []

      def walk(node):
          if isinstance(node, dict):
              if str(node.get("id", "")) == package_id:
                                                      found.append(node)

                                                                     for child in node.values():
                                                                    walk(child)

                                                                        elif isinstance(node, list):
              for child in node:
                                                                             walk(child)

                                                                    walk(value)
                                                                                return found

  class XXH128(ctypes.Structure):
                                                                _fields_ = [
                                                                                   ("low64", ctypes.c_uint64),
                                                                ("high64", ctypes.c_uint64),
      ]

                                                                                      def load_xxhash():
                                                                             candidates = [
          ctypes.util.find_library("xxhash"),
          "libxxhash.so.0",
                                                                          "libxxhash.so",
      ]

      for candidate in candidates:
          if not candidate:
              continue

          try:
              library = ctypes.CDLL(candidate)
              function = library.XXH3_128bits

              function.argtypes = [
                  ctypes.c_void_p,
                  ctypes.c_size_t,
              ]

              function.restype = XXH128

              return candidate, function

          except (OSError, AttributeError):
              continue

      return None, None

  def file_identity(path, xxh_function):
      print()
      print(f"path={path}")

      if not path.is_file():
          print("MISSING")
          return None

      data = path.read_bytes()

      print(f"size={len(data)}")
      print(
          "sha256="
          + hashlib.sha256(data).hexdigest()
      )

      if xxh_function is None:
          print("xxh3_128=UNAVAILABLE")
          return None

      buffer = ctypes.create_string_buffer(data)
      result = xxh_function(buffer, len(data))

      digest = (
          f"{result.high64:016x}"
          f"{result.low64:016x}"
      )

      print(f"xxh3_128={digest}")

      return digest

  heading("1. CURRENT SETTINGS AND INSTALLED MAP")

  settings_path = (
      index_path.parent.parent
      / "settings.json"
  )

  for path in [
      settings_path,
      installed_path,
  ]:
      print()
      print(f"--- {path} ---")

      value = load_json(path)

      if value is not None:
          print(
              json.dumps(
                  value,
                  ensure_ascii=False,
                  indent=2,
              )
          )

  heading("2. EXACT CATALOG PACKAGE ENTRY")

  index = load_json(index_path)

  packages = (
      find_package(index)
      if index is not None
      else []
  )

  print(f"matches={len(packages)}")

  for number, package in enumerate(
      packages,
      1,
  ):
      print()
      print(f"--- MATCH {number} ---")

      print(
          json.dumps(
              package,
              ensure_ascii=False,
              indent=2,
          )
      )

  heading("3. REGISTERED VERSION HASHES")

  expected_hashes = set()

  for package in packages:
      versions = package.get(
          "version",
          package.get("versions", []),
      )

      if not isinstance(versions, list):
          continue

      for version in versions:
          if not isinstance(version, dict):
              continue

          version_name = str(
              version.get("version", "")
          )

          files = version.get("file", [])

          if not isinstance(files, list):
              continue

          for entry in files:
              if not isinstance(entry, dict):
                  continue

              path = str(
                  entry.get("path", "")
              )

              digest = str(
                  entry.get(
                      "XXH3_128",
                      entry.get(
                          "xxh3_128",
                          entry.get("hash", ""),
                      ),
                  )
              ).lower()

              if digest:
                  expected_hashes.add(digest)

              print(
                  f"version={version_name}"
                  f"|path={path}"
                  f"|xxh3_128={digest}"
              )

  heading("4. HASH CACHE ENTRY")

  cache = load_json(cache_path)

  if cache is not None:
      data = cache.get("data", cache)

      if isinstance(data, dict):
          for key, value in data.items():
              normalized = (
                  str(key)
                  .replace(chr(92), "/")
                  .lower()
              )

              if normalized.endswith(
                  "/programdata/aviutl2/plugin/lwinput.aui2"
              ):
                  print(f"path={key}")

                  print(
                      json.dumps(
                          value,
                          ensure_ascii=False,
                          indent=2,
                      )
                  )

  heading("5. ACTUAL FILE HASHES")

  library_name, xxh_function = load_xxhash()

  print(
      "xxhash_library="
      + (
          library_name
          if library_name
          else "UNAVAILABLE"
      )
  )

  active_hash = file_identity(
      active_path,
      xxh_function,
  )

  custom_hash = file_identity(
      custom_path,
      xxh_function,
  )

  heading("6. CLASSIFICATION")

  for label, digest in [
      ("active", active_hash),
      ("custom", custom_hash),
  ]:
      if not digest:
          print(f"{label}=UNDETERMINED")

      elif digest in expected_hashes:
          print(
              f"{label}=KNOWN_CATALOG_VERSION"
          )

      else:
          print(
              f"{label}=PRESENT_BUT_UNKNOWN"
          )
  ' \
          "$INDEX" \
          "$HASH_CACHE" \
          "$INSTALLED" \
          "$ACTIVE" \
          "$CUSTOM" \
          "$PACKAGE_ID"

  echo
  echo "============================================================"
  echo "END OF STRICTLY READ-ONLY HASH CLASSIFICATION"
  echo "============================================================"
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(235).txt:2-336` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

読み取り専用監査。ファイル変更なしとコマンド内で明示されているものを含む。

#### 関連する固定値

- 短縮commit: `20260731`
- path: `$HOME/Games/aviutl2`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(235).txt lines 2-336`

---
### コマンド 304 — `V238-01`

#### 目的

保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
  set ROOT \
          "$HOME/Games/aviutl2"

  set REPRO \
          "$ROOT/build/l-smash-works-nvdec-repro-02/src/L-SMASH-Works"

  set ORIGINAL \
          "$ROOT/src/L-SMASH-Works-nvdec"

  set BUILT \
          "$REPRO/AviUtl2/lwinput.aui2"

      set git_dir \
                  (env GIT_OPTIONAL_LOCKS=0 \
                          git -C "$tree" \
                          rev-parse \
                          --git-dir)

          set git_dir \
                          "$tree/$git_dir"

          set matches \
                              (grep \
                                      -nE \
                                      'git[[:space:]]+(rev-list|describe)|REVISION|VERSION|r%s|File Reader for AviUtl2|Mr-Ojii' \
                                      "$path" \
                                      2>/dev/null)
```

#### 実行コマンド

```fish
# ============================================================
  # L-SMASH Works revision-generation investigation
  # Fish-compatible / STRICTLY READ-ONLY
  # ============================================================

  set ROOT \
          "$HOME/Games/aviutl2"

  set REPRO \
          "$ROOT/build/l-smash-works-nvdec-repro-02/src/L-SMASH-Works"

  set ORIGINAL \
          "$ROOT/src/L-SMASH-Works-nvdec"

  set BUILT \
          "$REPRO/AviUtl2/lwinput.aui2"

  echo
  echo "============================================================"
  echo "1. REPOSITORY HISTORY"
  echo "============================================================"

  for tree in \
          "$REPRO" \
          "$ORIGINAL"

      echo
      echo "############################################################"
      echo "TREE: $tree"
      echo "############################################################"

      if not test -d "$tree/.git"
          echo "MISSING GIT REPOSITORY"
          continue
      end

      echo
      echo "-- identity --"

      env GIT_OPTIONAL_LOCKS=0 \
                  git -C "$tree" \
                  rev-parse \
                  --is-shallow-repository

      env GIT_OPTIONAL_LOCKS=0 \
                  git -C "$tree" \
                  rev-parse \
                                                                                HEAD

      env GIT_OPTIONAL_LOCKS=0 \
                                                                             git -C "$tree" \
                  show \
                                                                                     -s \
                  --format='parents=%P%nsubject=%s%nauthor_date=%aI%ncommit_date=%cI' \
                  HEAD

      echo
                                                                                       echo "-- history counts --"

      printf 'all_commits='

      env GIT_OPTIONAL_LOCKS=0 \
                                                                             git -C "$tree" \
                  rev-list \
                  --count \
                  HEAD

      printf 'first_parent_commits='

      env GIT_OPTIONAL_LOCKS=0 \
                  git -C "$tree" \
                  rev-list \
                  --first-parent \
                  --count \
                  HEAD

      echo
      echo "-- shallow boundary --"

      set git_dir \
                  (env GIT_OPTIONAL_LOCKS=0 \
                          git -C "$tree" \
                          rev-parse \
                          --git-dir)

      if not string match -q '/*' "$git_dir"
          set git_dir \
                          "$tree/$git_dir"
      end

      if test -f "$git_dir/shallow"
          cat "$git_dir/shallow"
      else
          echo "NONE"
      end
  end

  echo
  echo "============================================================"
  echo "2. BUILT BINARY IDENTITY"
  echo "============================================================"

  if test -f "$BUILT"
      stat \
                  --printf='birth=%w\nmtime=%y\nctime=%z\nsize=%s\ninode=%i\n' \
                  "$BUILT"

      file "$BUILT"
      sha256sum "$BUILT"

      echo
      echo "-- ASCII and UTF-16LE version strings --"

      begin
          strings \
                          -a \
                          -n 4 \
                          "$BUILT"

          strings \
                          -a \
                          -e l \
                          -n 4 \
                          "$BUILT"
      end \
                  | grep \
                      -E \
                      'L-SMASH Works|File Reader|Mr-Ojii|r[0-9]{1,6}' \
                  | sort \
                  -u
  else
      echo "MISSING: $BUILT"
  end

  echo
  echo "============================================================"
  echo "3. REVISION-GENERATION SOURCE"
  echo "============================================================"

  for tree in \
          "$REPRO" \
          "$ORIGINAL"

      echo
      echo "############################################################"
      echo "TREE: $tree"
      echo "############################################################"

      if not test -d "$tree"
          echo "MISSING"
          continue
      end

      find \
                  "$tree" \
                  -path "$tree/.git" \
                  -prune \
                  -o \
                  -type f \
                  \( \
                      -name 'Makefile' \
                      -o -name '*.mk' \
                      -o -name 'configure' \
                      -o -name '*.sh' \
                      -o -name '*.c' \
                      -o -name '*.h' \
                      -o -name '*.rc' \
                      -o -name '*.in' \
                  \) \
                  -print0 \
                  | sort -z \
                  | while read -z path

          set matches \
                              (grep \
                                      -nE \
                                      'git[[:space:]]+(rev-list|describe)|REVISION|VERSION|r%s|File Reader for AviUtl2|Mr-Ojii' \
                                      "$path" \
                                      2>/dev/null)

          if test (count $matches) -gt 0
              echo
              echo "=== $path ==="
              printf '%s\n' $matches
          end
      end
  end

  echo
  echo "============================================================"
  echo "4. GENERATED AVIUTL2 BUILD FILES"
  echo "============================================================"

  for tree in \
          "$REPRO" \
          "$ORIGINAL"

      echo
      echo "############################################################"
      echo "TREE: $tree/AviUtl2"
      echo "############################################################"

      for path in \
                  "$tree/AviUtl2/config.mak" \
                  "$tree/AviUtl2/lwinput.rc" \
                  "$tree/AviUtl2/lwinput.c"

          echo
          echo "=== $path ==="

          if test -f "$path"
              grep \
                                  -nE \
                                  'REVISION|VERSION|File Reader|Mr-Ojii|r[0-9]+|git' \
                                  "$path" \
                                  2>/dev/null
              or true
          else
              echo "MISSING"
          end
      end
  end

  echo
  echo "============================================================"
  echo "END OF STRICTLY READ-ONLY REVISION INVESTIGATION"
  echo "============================================================"
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(238).txt:2-228` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

読み取り専用監査。ファイル変更なしとコマンド内で明示されているものを含む。

#### 関連する固定値

- path: `$HOME/Games/aviutl2`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(238).txt lines 2-228`

---
### コマンド 305 — `V240-01`

#### 目的

保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
  set ROOT \
          "$HOME/Games/aviutl2"

  set WORK \
          "$ROOT/build/l-smash-works-nvdec-repro-03"

  set OUTPUT \
          "$WORK/output"

  set BUILT \
          "$OUTPUT/lwinput.aui2"

  set SOURCE_BUILT \
          "$WORK/src/L-SMASH-Works/AviUtl2/lwinput.aui2"

  set ORIGINAL \
          "$ROOT/src/L-SMASH-Works-nvdec/AviUtl2/lwinput.aui2"

  set LSW_SOURCE \
          "$WORK/src/L-SMASH-Works"

  set FFMPEG_SOURCE \
          "$WORK/deps/FFmpeg"

GIT_OPTIONAL_LOCKS=0
```

#### 実行コマンド

```fish
# ============================================================
  # repro-03 final artifact audit
  # Fish-compatible / STRICTLY READ-ONLY
  # ============================================================

  set ROOT \
          "$HOME/Games/aviutl2"

  set WORK \
          "$ROOT/build/l-smash-works-nvdec-repro-03"

  set OUTPUT \
          "$WORK/output"

  set BUILT \
          "$OUTPUT/lwinput.aui2"

  set SOURCE_BUILT \
          "$WORK/src/L-SMASH-Works/AviUtl2/lwinput.aui2"

  set ORIGINAL \
          "$ROOT/src/L-SMASH-Works-nvdec/AviUtl2/lwinput.aui2"

  set LSW_SOURCE \
          "$WORK/src/L-SMASH-Works"

  set FFMPEG_SOURCE \
          "$WORK/deps/FFmpeg"

  function section
      echo
      echo "============================================================"
      echo "$argv"
      echo "============================================================"
  end

  section "1. OUTPUT DIRECTORY"

  if not test -d "$OUTPUT"
      echo "ERROR: output directory is missing:"
      echo "$OUTPUT"
      return 1
  end

  find \
          "$OUTPUT" \
          -maxdepth 1 \
                                                                              -type f \
          -printf '%f|size=%s|mtime=%TY-%Tm-%TdT%TH:%TM:%TS%Tz\n' \
          | sort

  section "2. OUTPUT CHECKSUMS"

  for path in \
          "$OUTPUT/lwinput.aui2" \
                                                                   "$OUTPUT/lsmash.ini" \
          "$OUTPUT/PROVENANCE.txt" \
                                                                 "$OUTPUT/SHA256SUMS"

      echo
      echo "=== $path ==="

      if test -f "$path"
          file "$path"
          sha256sum "$path"
                                                                      else
          echo "MISSING"
      end
  end

                                                                                        echo
  echo "-- SHA256SUMS contents --"

                                                           if test -f "$OUTPUT/SHA256SUMS"
      cat "$OUTPUT/SHA256SUMS"
  end

                                                                                        section "3. PROVENANCE"

  if test -f "$OUTPUT/PROVENANCE.txt"
      cat "$OUTPUT/PROVENANCE.txt"
                                                           else
      echo "MISSING: $OUTPUT/PROVENANCE.txt"
  end

  section "4. L-SMASH.INI"

  if test -f "$OUTPUT/lsmash.ini"
      cat "$OUTPUT/lsmash.ini"

      echo
      echo "-- required settings --"

      grep \
                  -nE \
                  '^(libavsmash_disabled=1|libav_disabled=0|preferred_decoders=av1_cuvid)$' \
                  "$OUTPUT/lsmash.ini"
  else
      echo "MISSING: $OUTPUT/lsmash.ini"
  end

  section "5. SOURCE IDENTITY"

  env GIT_OPTIONAL_LOCKS=0 \
          git -C "$LSW_SOURCE" \
          rev-parse \
          --is-shallow-repository

  env GIT_OPTIONAL_LOCKS=0 \
          git -C "$LSW_SOURCE" \
          rev-parse \
          HEAD

  env GIT_OPTIONAL_LOCKS=0 \
          git -C "$LSW_SOURCE" \
          rev-list \
          --count \
          HEAD

  env GIT_OPTIONAL_LOCKS=0 \
          git -C "$LSW_SOURCE" \
          show \
          -s \
          --format='commit=%H%nparent=%P%nsubject=%s%nauthor_date=%aI%ncommit_date=%cI' \
          HEAD

  echo
  echo "-- tracked worktree status --"

  env GIT_OPTIONAL_LOCKS=0 \
          git -C "$LSW_SOURCE" \
          status \
          --short \
          --untracked-files=no

  section "6. FFMPEG CONFIGURATION"

  grep \
          -nE \
          '^(CONFIG_CUVID|CONFIG_FFNVCODEC|CONFIG_AV1_CUVID_DECODER|CONFIG_LIBDAV1D|CONFIG_LIBVPX|CONFIG_LIBVPL)=yes$' \
          "$FFMPEG_SOURCE/ffbuild/config.mak"

  grep \
          -n \
          -- \
          '--enable-decoder=av1_cuvid' \
          "$FFMPEG_SOURCE/ffbuild/config.mak"

  section "7. PE AND EMBEDDED MARKERS"

  if not test -f "$BUILT"
      echo "ERROR: generated lwinput.aui2 is missing:"
      echo "$BUILT"
      return 1
  end

  file "$BUILT"

  objdump \
          -f \
          "$BUILT"

  echo
  echo "-- version and decoder markers --"

  begin
      strings \
                  -a \
                  -n 6 \
                  "$BUILT"

      strings \
                  -a \
                  -e l \
                  -n 6 \
                  "$BUILT"
  end \
          | grep \
              -E \
              'L-SMASH Works File Reader for AviUtl2 r1284 by Mr-Ojii|av1_cuvid|--enable-decoder=av1_cuvid' \
          | sort \
          -u

  section "8. BUILD-COPY IDENTITY"

  for path in \
          "$BUILT" \
          "$SOURCE_BUILT" \
          "$ORIGINAL"

      echo
      echo "=== $path ==="

      if test -f "$path"
          stat \
                          --printf='size=%s\nmtime=%y\n' \
                          "$path"

          sha256sum "$path"
      else
          echo "MISSING"
      end
  end

  echo
  echo "-- output versus source build --"

  if cmp \
              --silent \
              "$BUILT" \
              "$SOURCE_BUILT"

      echo "IDENTICAL"
  else
      echo "DIFFERENT"
  end

  echo
  echo "-- repro-03 versus original successful artifact --"

  if cmp \
              --silent \
              "$BUILT" \
              "$ORIGINAL"

      echo "IDENTICAL"
  else
      echo "DIFFERENT_EXPECTED"
  end

  section "9. XXH3-128 AND CATALOG CLASSIFICATION"

  env BUILT="$BUILT" \
          ORIGINAL="$ORIGINAL" \
          python3 -c '
  import ctypes
  import ctypes.util
  import hashlib
  import os
  from pathlib import Path

  class XXH128(ctypes.Structure):
      _fields_ = [
          ("low64", ctypes.c_uint64),
          ("high64", ctypes.c_uint64),
      ]

  library_name = (
      ctypes.util.find_library("xxhash")
      or "libxxhash.so.0"
  )

  library = ctypes.CDLL(library_name)
  xxh3 = library.XXH3_128bits
  xxh3.argtypes = [ctypes.c_void_p, ctypes.c_size_t]
  xxh3.restype = XXH128

  catalog_hashes = {
      "33d694f6c3f12a3beed73d83644627da",
  }

  for label in ("BUILT", "ORIGINAL"):
      path = Path(os.environ[label])
      data = path.read_bytes()

      buffer = ctypes.create_string_buffer(data)
      result = xxh3(buffer, len(data))

      digest = (
          f"{result.high64:016x}"
          f"{result.low64:016x}"
      )

      classification = (
          "KNOWN_CATALOG_VERSION"
          if digest in catalog_hashes
          else "PRESENT_BUT_UNKNOWN"
      )

      print()
      print(f"label={label.lower()}")
      print(f"path={path}")
      print(f"size={len(data)}")
      print(f"sha256={hashlib.sha256(data).hexdigest()}")
      print(f"xxh3_128={digest}")
      print(f"classification={classification}")
  '

  section "10. FINAL RESULT"

  echo "Expected:"
  echo "  shallow=false"
  echo "  commit count=1284"
  echo "  HEAD=393df5ef669707f776261e4ac1bcc7e9a9a227ab"
  echo "  r1284 marker present"
  echo "  av1_cuvid marker present"
  echo "  output/source-build=IDENTICAL"
  echo "  repro/original=DIFFERENT_EXPECTED"
  echo "  built Catalog classification=PRESENT_BUT_UNKNOWN"
  echo
  echo "No Wine prefix or Catalog setting was modified."
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(240).txt:2-302` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

読み取り専用監査。ファイル変更なしとコマンド内で明示されているものを含む。

#### 関連する固定値

- commit: `393df5ef669707f776261e4ac1bcc7e9a9a227ab`
- version: `r1284`
- path: `$HOME/Games/aviutl2`

#### 問題点・注意事項

- 対話Fish直下では `return 1` が関数外エラーになり得る。原文は維持するが、REPRODUCTION.md化時は関数化または別の停止方法が必要。
- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(240).txt lines 2-302`

---
### コマンド 306 — `D227-01`

#### 目的

AviUtl2環境を監査するFishスクリプト本文。

#### 分類

```text
実行確認不能
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
不明
```

#### 事前設定された変数

```fish
set ROOT \
    "$HOME/Games/aviutl2"

set GOOD \
    "$ROOT/prefix-ge-nvdec-test.backup-20260731-135410"

set ACTIVE \
    "$GOOD/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2"

set OFFICIAL \
    "$GOOD/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2.before-hwframe-transfer-20260731-042746"

set CUSTOM \
    "$ROOT/src/L-SMASH-Works-nvdec/AviUtl2/lwinput.aui2"

    set -l path "$argv[1]"

    set left \
        (string split -m1 '|' "$pair")[1]

    set right \
        (string split -m1 '|' "$pair")[2]

set SEARCH_ROOTS \
    "$ROOT"

    set -a SEARCH_ROOTS \
        "$HOME/.local/share/Trash/files"

set ACTIVE_HASH \
    (sha256sum "$ACTIVE" | string split ' ')[1]

        set hash \
            (sha256sum "$path" | string split ' ')[1]
```

#### 実行コマンド

```fish
# ============================================================
# Final lwinput.aui2 provenance investigation
# STRICTLY READ-ONLY
# ============================================================

set ROOT \
    "$HOME/Games/aviutl2"

set GOOD \
    "$ROOT/prefix-ge-nvdec-test.backup-20260731-135410"

set ACTIVE \
    "$GOOD/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2"

set OFFICIAL \
    "$GOOD/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2.before-hwframe-transfer-20260731-042746"

set CUSTOM \
    "$ROOT/src/L-SMASH-Works-nvdec/AviUtl2/lwinput.aui2"

function show_file
    set -l path "$argv[1]"

    echo
    echo "=== $path ==="

    if test -f "$path"
        stat \
            --printf='birth=%w\nmtime=%y\nctime=%z\nsize=%s\ninode=%i\n' \
            "$path"

        file -- "$path"
        sha256sum -- "$path"
    else
        echo "MISSING"
    end
end

echo
echo "============================================================"
echo "1. PRIMARY THREE-WAY MATRIX"
echo "============================================================"

for path in \
        "$ACTIVE" \
        "$OFFICIAL" \
        "$CUSTOM"

    show_file "$path"
end

echo
echo "=== BYTEWISE IDENTITY ==="

for pair in \
        "$ACTIVE|$OFFICIAL" \
        "$ACTIVE|$CUSTOM" \
        "$OFFICIAL|$CUSTOM"

    set left \
        (string split -m1 '|' "$pair")[1]

    set right \
        (string split -m1 '|' "$pair")[2]

    echo
    echo "$left"
    echo "$right"

    if cmp -s -- "$left" "$right"
        echo "IDENTICAL"
    else
        echo "DIFFERENT"
    end
end

echo
echo "============================================================"
echo "2. LOCATE EVERY LWINPUT COPY"
echo "============================================================"

set SEARCH_ROOTS \
    "$ROOT"

if test -d "$HOME/.local/share/Trash/files"
    set -a SEARCH_ROOTS \
        "$HOME/.local/share/Trash/files"
end

find \
    $SEARCH_ROOTS \
    -type f \
    \( \
        -iname 'lwinput.aui2' \
        -o -iname 'lwinput.aui2.*' \
        -o -iname '*lwinput*.aui2' \
    \) \
    -print0 \
    2>/dev/null \
    | sort -z \
    | while read -z path
        show_file "$path"
    end

echo
echo "============================================================"
echo "3. FIND EXACT ACTIVE-HASH COPIES"
echo "============================================================"

set ACTIVE_HASH \
    (sha256sum "$ACTIVE" | string split ' ')[1]

echo "TARGET HASH: $ACTIVE_HASH"

find \
    $SEARCH_ROOTS \
    -type f \
    \( \
        -iname 'lwinput.aui2' \
        -o -iname 'lwinput.aui2.*' \
        -o -iname '*lwinput*.aui2' \
    \) \
    -print0 \
    2>/dev/null \
    | while read -z path
        set hash \
            (sha256sum "$path" | string split ' ')[1]

        if test "$hash" = "$ACTIVE_HASH"
            echo "$path"
        end
    end

echo
echo "============================================================"
echo "4. PE HEADER AND BYTE-DIFFERENCE ANALYSIS"
echo "============================================================"

env \
    ACTIVE="$ACTIVE" \
    OFFICIAL="$OFFICIAL" \
    CUSTOM="$CUSTOM" \
    python3 - <<'PY'
from __future__ import annotations

import hashlib
import os
import struct
from pathlib import Path

paths = {
    "ACTIVE": Path(os.environ["ACTIVE"]),
    "OFFICIAL": Path(os.environ["OFFICIAL"]),
    "CUSTOM": Path(os.environ["CUSTOM"]),
}


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def pe_metadata(data: bytes) -> dict[str, int | str]:
    result: dict[str, int | str] = {}

    if len(data) < 0x40 or data[:2] != b"MZ":
        result["error"] = "not an MZ executable"
        return result

    pe_offset = struct.unpack_from("<I", data, 0x3C)[0]

    if pe_offset + 24 > len(data):
        result["error"] = "invalid PE offset"
        return result

    if data[pe_offset:pe_offset + 4] != b"PE\0\0":
        result["error"] = "missing PE signature"
        return result

    result["pe_offset"] = pe_offset
    result["machine"] = hex(struct.unpack_from("<H", data, pe_offset + 4)[0])
    result["sections"] = struct.unpack_from("<H", data, pe_offset + 6)[0]
    result["timestamp"] = struct.unpack_from("<I", data, pe_offset + 8)[0]

    optional = pe_offset + 24

    if optional + 68 <= len(data):
        result["checksum"] = struct.unpack_from("<I", data, optional + 64)[0]

    return result


def differing_ranges(left: bytes, right: bytes) -> list[tuple[int, int]]:
    limit = min(len(left), len(right))
    ranges: list[tuple[int, int]] = []
    start: int | None = None

    for index in range(limit):
        differs = left[index] != right[index]

        if differs and start is None:
            start = index
        elif not differs and start is not None:
            ranges.append((start, index - 1))
            start = None

    if start is not None:
        ranges.append((start, limit - 1))

    if len(left) != len(right):
        ranges.append((limit, max(len(left), len(right)) - 1))

    return ranges


loaded: dict[str, bytes] = {}

for name, path in paths.items():
    data = path.read_bytes()
    loaded[name] = data

    print(f"\n=== {name} ===")
    print(f"path={path}")
    print(f"size={len(data)}")
    print(f"sha256={sha256(data)}")

    for key, value in pe_metadata(data).items():
        print(f"{key}={value}")


for left_name, right_name in (
    ("ACTIVE", "OFFICIAL"),
    ("ACTIVE", "CUSTOM"),
    ("OFFICIAL", "CUSTOM"),
):
    left = loaded[left_name]
    right = loaded[right_name]
    ranges = differing_ranges(left, right)
    differing_bytes = sum(end - start + 1 for start, end in ranges)

    print(f"\n=== {left_name} VS {right_name} ===")
    print(f"same_size={len(left) == len(right)}")
    print(f"differing_ranges={len(ranges)}")
    print(f"differing_bytes={differing_bytes}")

    for start, end in ranges[:80]:
        print(f"0x{start:08x}-0x{end:08x} ({end - start + 1} bytes)")

    if len(ranges) > 80:
        print(f"... {len(ranges) - 80} additional ranges omitted")

    # Test whether the difference is limited to normal PE metadata fields.
    if len(left) == len(right):
        normalized_left = bytearray(left)
        normalized_right = bytearray(right)

        for normalized, original in (
            (normalized_left, left),
            (normalized_right, right),
        ):
            pe_offset = struct.unpack_from("<I", original, 0x3C)[0]

            # COFF TimeDateStamp
            normalized[pe_offset + 8:pe_offset + 12] = b"\0" * 4

            # Optional-header checksum
            optional = pe_offset + 24
            normalized[optional + 64:optional + 68] = b"\0" * 4

        print(
            "identical_after_normalizing_timestamp_and_checksum="
            + str(normalized_left == normalized_right)
        )
PY

echo
echo "============================================================"
echo "5. OBJECT/SECTION METADATA"
echo "============================================================"

for path in \
        "$ACTIVE" \
        "$OFFICIAL" \
        "$CUSTOM"

    echo
    echo "############################################################"
    echo "$path"
    echo "############################################################"

    if command -q llvm-readobj
        llvm-readobj \
            --file-headers \
            --sections \
            --coff-imports \
            "$path" \
            | sed -n '1,700p'
    else if command -q objdump
        objdump \
            -x \
            "$path" \
            | sed -n '1,700p'
    else
        echo "llvm-readobj/objdump not installed"
    end
end

echo
echo "============================================================"
echo "6. FISH HISTORY 06:00–07:05"
echo "============================================================"

history search \
    --show-time="%s|" \
    --null \
    --reverse \
    --max=200000 \
    | python3 -c '
import re
import sys
from datetime import datetime, timedelta, timezone

jst = timezone(timedelta(hours=9))
start = datetime(2026, 7, 31, 6, 0, 0, tzinfo=jst)
end = datetime(2026, 7, 31, 7, 5, 0, tzinfo=jst)

pattern = re.compile(
    r"lwinput|lsmash|aui2|L-SMASH|"
    r"\bcp\b|\binstall\b|\bmv\b|\bobjcopy\b|"
    r"\bstrip\b|\btouch\b|\bpython\b|\bsha256sum\b",
    re.IGNORECASE,
)

for raw in sys.stdin.buffer.read().split(b"\0"):
    if not raw:
        continue

    first, separator, command = raw.partition(b"|")

    if not separator:
        continue

    try:
        timestamp = int(first)
    except ValueError:
        continue

    moment = datetime.fromtimestamp(timestamp, jst)
    text = command.decode("utf-8", "replace")

    if start <= moment <= end and pattern.search(text):
        print("--- " + moment.isoformat(" ") + " ---")
        print(text)
        print()
'

echo
echo "============================================================"
echo "7. FILES TOUCHED 06:00–07:05"
echo "============================================================"

find \
    "$ROOT" \
    -xdev \
    -newermt '2026-07-31 06:00:00' \
    ! -newermt '2026-07-31 07:05:01' \
    -printf '%T@|%TY-%Tm-%Td %TH:%TM:%TS|%y|%s|%p\n' \
    2>/dev/null \
    | sort -n \
    | sed -n '1,1500p'

echo
echo "============================================================"
echo "8. RELEVANT LOGS 06:00–07:05"
echo "============================================================"

find \
    "$ROOT/logs" \
    -type f \
    -newermt '2026-07-31 06:00:00' \
    ! -newermt '2026-07-31 07:05:01' \
    -print0 \
    2>/dev/null \
    | sort -z \
    | while read -z log
        echo
        echo "=== $log ==="

        stat \
            --printf='mtime=%y\nsize=%s\n' \
            "$log"

        grep \
            -inE \
            'lwinput|lsmash|aui2|av1|cuvid|nvcuvid|nvcuda|dav1d|hardware frame|exception|fault|crash' \
            "$log" \
            | tail -n 300
        or true
    end

echo
echo "============================================================"
echo "END OF STRICTLY READ-ONLY LWINPUT PROVENANCE INVESTIGATION"
echo "============================================================"
```

#### 実行結果

スクリプト本文は保存されているが、このファイル単独には実行プロンプトと終了出力がない。

#### 生成・変更されたもの

スクリプト本文上は主に読み取り専用。

#### 関連する固定値

- 短縮commit: `20260731`
- path: `$HOME/Games/aviutl2`
- path: `$HOME/.local/share/Trash/files`

#### 問題点・注意事項

- 実行証拠がないため成功扱いしない。

#### 採用可否

```text
要追加確認
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(227).txt full file`

---
### コマンド 307 — `V237-01`

#### 目的

Catalogとcustom L-SMASH Worksのhash分類を読み取り専用で検証する。

#### 分類

```text
検証専用
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
  set ROOT \
          "$HOME/Games/aviutl2"

  set GOOD \
          "$ROOT/prefix-ge-nvdec-test.backup-20260731-135410"

  set ROAMING \
          "$GOOD/drive_c/users/steamuser/AppData/Roaming/aviutl2-catalog"

  set INDEX \
          "$ROAMING/catalog/index.json"

  set HASH_CACHE \
          "$ROAMING/hash-cache.json"

  set INSTALLED \
          "$ROAMING/installed.json"

  set ACTIVE \
          "$GOOD/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2"

  set CUSTOM \
          "$ROOT/src/L-SMASH-Works-nvdec/AviUtl2/lwinput.aui2"

  set PACKAGE_ID \
          "Mr-Ojii.L-SMASH-Works"
```

#### 実行コマンド

```fish
# ============================================================
  # Catalog L-SMASH Works hash-classification proof
  # Fish-compatible / STRICTLY READ-ONLY
  # ============================================================

  set ROOT \
          "$HOME/Games/aviutl2"

  set GOOD \
          "$ROOT/prefix-ge-nvdec-test.backup-20260731-135410"

  set ROAMING \
          "$GOOD/drive_c/users/steamuser/AppData/Roaming/aviutl2-catalog"

  set INDEX \
          "$ROAMING/catalog/index.json"

  set HASH_CACHE \
          "$ROAMING/hash-cache.json"

  set INSTALLED \
          "$ROAMING/installed.json"

  set ACTIVE \
          "$GOOD/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2"

  set CUSTOM \
          "$ROOT/src/L-SMASH-Works-nvdec/AviUtl2/lwinput.aui2"

  set PACKAGE_ID \
          "Mr-Ojii.L-SMASH-Works"

  python3 -c '
  import ctypes
  import ctypes.util
  import hashlib
  import json
  import pathlib
  import sys

  index_path = pathlib.Path(sys.argv[1])
  cache_path = pathlib.Path(sys.argv[2])
  installed_path = pathlib.Path(sys.argv[3])
  active_path = pathlib.Path(sys.argv[4])
  custom_path = pathlib.Path(sys.argv[5])
  package_id = sys.argv[6]

  def heading(title):
      print()
      print("=" * 60)
      print(title)
      print("=" * 60)

  def load_json(path):
      if not path.is_file():
          print(f"MISSING: {path}")
          return None

      return json.loads(
                                                                             path.read_text(
              encoding="utf-8-sig",
          )
      )

  def find_package(value):
      found = []

      def walk(node):
          if isinstance(node, dict):
              if str(node.get("id", "")) == package_id:
                                                      found.append(node)

                                                                     for child in node.values():
                                                                    walk(child)

                                                                        elif isinstance(node, list):
              for child in node:
                                                                             walk(child)

                                                                    walk(value)
                                                                                return found

  class XXH128(ctypes.Structure):
                                                                _fields_ = [
                                                                                   ("low64", ctypes.c_uint64),
                                                                ("high64", ctypes.c_uint64),
      ]

                                                                                      def load_xxhash():
                                                                             candidates = [
          ctypes.util.find_library("xxhash"),
          "libxxhash.so.0",
                                                                          "libxxhash.so",
      ]

      for candidate in candidates:
          if not candidate:
              continue

          try:
              library = ctypes.CDLL(candidate)
              function = library.XXH3_128bits

              function.argtypes = [
                  ctypes.c_void_p,
                  ctypes.c_size_t,
              ]

              function.restype = XXH128

              return candidate, function

          except (OSError, AttributeError):
              continue

      return None, None

  def file_identity(path, xxh_function):
      print()
      print(f"path={path}")

      if not path.is_file():
          print("MISSING")
          return None

      data = path.read_bytes()

      print(f"size={len(data)}")
      print(
          "sha256="
          + hashlib.sha256(data).hexdigest()
      )

      if xxh_function is None:
          print("xxh3_128=UNAVAILABLE")
          return None

      buffer = ctypes.create_string_buffer(data)
      result = xxh_function(buffer, len(data))

      digest = (
          f"{result.high64:016x}"
          f"{result.low64:016x}"
      )

      print(f"xxh3_128={digest}")

      return digest

  heading("1. CURRENT SETTINGS AND INSTALLED MAP")

  settings_path = (
      index_path.parent.parent
      / "settings.json"
  )

  for path in [
      settings_path,
      installed_path,
  ]:
      print()
      print(f"--- {path} ---")

      value = load_json(path)

      if value is not None:
          print(
              json.dumps(
                  value,
                  ensure_ascii=False,
                  indent=2,
              )
          )

  heading("2. EXACT CATALOG PACKAGE ENTRY")

  index = load_json(index_path)

  packages = (
      find_package(index)
      if index is not None
      else []
  )

  print(f"matches={len(packages)}")

  for number, package in enumerate(
      packages,
      1,
  ):
      print()
      print(f"--- MATCH {number} ---")

      print(
          json.dumps(
              package,
              ensure_ascii=False,
              indent=2,
          )
      )

  heading("3. REGISTERED VERSION HASHES")

  expected_hashes = set()

  for package in packages:
      versions = package.get(
          "version",
          package.get("versions", []),
      )

      if not isinstance(versions, list):
          continue

      for version in versions:
          if not isinstance(version, dict):
              continue

          version_name = str(
              version.get("version", "")
          )

          files = version.get("file", [])

          if not isinstance(files, list):
              continue

          for entry in files:
              if not isinstance(entry, dict):
                  continue

              path = str(
                  entry.get("path", "")
              )

              digest = str(
                  entry.get(
                      "XXH3_128",
                      entry.get(
                          "xxh3_128",
                          entry.get("hash", ""),
                      ),
                  )
              ).lower()

              if digest:
                  expected_hashes.add(digest)

              print(
                  f"version={version_name}"
                  f"|path={path}"
                  f"|xxh3_128={digest}"
              )

  heading("4. HASH CACHE ENTRY")

  cache = load_json(cache_path)

  if cache is not None:
      data = cache.get("data", cache)

      if isinstance(data, dict):
          for key, value in data.items():
              normalized = (
                  str(key)
                  .replace(chr(92), "/")
                  .lower()
              )

              if normalized.endswith(
                  "/programdata/aviutl2/plugin/lwinput.aui2"
              ):
                  print(f"path={key}")

                  print(
                      json.dumps(
                          value,
                          ensure_ascii=False,
                          indent=2,
                      )
                  )

  heading("5. ACTUAL FILE HASHES")

  library_name, xxh_function = load_xxhash()

  print(
      "xxhash_library="
      + (
          library_name
          if library_name
          else "UNAVAILABLE"
      )
  )

  active_hash = file_identity(
      active_path,
      xxh_function,
  )

  custom_hash = file_identity(
      custom_path,
      xxh_function,
  )

  heading("6. CLASSIFICATION")

  for label, digest in [
      ("active", active_hash),
      ("custom", custom_hash),
  ]:
      if not digest:
          print(f"{label}=UNDETERMINED")

      elif digest in expected_hashes:
          print(
              f"{label}=KNOWN_CATALOG_VERSION"
          )

      else:
          print(
              f"{label}=PRESENT_BUT_UNKNOWN"
          )
  ' \
          "$INDEX" \
          "$HASH_CACHE" \
          "$INSTALLED" \
          "$ACTIVE" \
          "$CUSTOM" \
          "$PACKAGE_ID"

  echo
  echo "============================================================"
  echo "END OF STRICTLY READ-ONLY HASH CLASSIFICATION"
  echo "============================================================"
```

#### 実行結果

履歴上で実行されたことは確認できる。主要出力は `(237).txt:2-336` を参照。出力が同じブロックに保存されていない場合、検証結果自体は断定しない。

#### 生成・変更されたもの

Wine prefixまたはその内部状態、L-SMASH Works plugin/config、Catalog application/config/state、ログファイル。

#### 関連する固定値

- 短縮commit: `20260731`
- path: `$HOME/Games/aviutl2`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 日時・backup名が固定または実行時依存であり、そのまま他環境へ転用できない。

#### 採用可否

```text
検証手順として採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(237).txt lines 2-336`

---
### コマンド 308 — `S237-02`

#### 目的

L-SMASH Works再現用パッチをrepositoryへ適用し、Fish構文とdiffを確認する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
cd ~/projects/aviutl2-linux-patches

  git apply --check \
          ~/Downloads/0001-add-l-smash-works-nvdec-reproduction.patch

  git apply \
          ~/Downloads/0001-add-l-smash-works-nvdec-reproduction.patch

  fish -n \
          scripts/build-l-smash-works-nvdec.fish

  fish -n \
          scripts/install-l-smash-works-nvdec.fish

  git diff --check
  git status --short
```

#### 実行結果

`git apply --check`、`git apply`、2つの`fish -n`、`git diff --check`が通り、変更ファイル一覧が表示された。

#### 生成・変更されたもの

repositoryのdocs、lutris、scripts、tests。

#### 関連する固定値

- path: `~/projects/aviutl2-linux-patches`
- path: `~/Downloads/0001-add-l-smash-works-nvdec-reproduction.patch`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(237).txt lines 1351-1366`

---
### コマンド 309 — `C237-03`

#### 目的

最初のrepro-01 work directoryでL-SMASH Worksを再現ビルドする。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
cd ~/projects/aviutl2-linux-patches

  scripts/build-l-smash-works-nvdec.fish \
          --work-dir \
          "$HOME/Games/aviutl2/build/l-smash-works-nvdec-repro-01" \
          --jobs (nproc)
```

#### 実行結果

依存関係のビルドは進んだが、`ERROR: FFmpeg CONFIG_AV1_CUVID_DECODER is not enabled`で失敗した。

#### 生成・変更されたもの

`$HOME/Games/aviutl2/build/l-smash-works-nvdec-repro-01`。

#### 関連する固定値

- path: `~/projects/aviutl2-linux-patches`
- path: `$HOME/Games/aviutl2/build/l-smash-works-nvdec-repro-01`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(237).txt lines 1377-1382`

---
### コマンド 310 — `C237-04`

#### 目的

FFmpeg validation修正patchを適用する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
cd ~/projects/aviutl2-linux-patches

  git apply --check \
          ~/Downloads/0002-fix-ffmpeg-component-validation.patch

  git apply \
          ~/Downloads/0002-fix-ffmpeg-component-validation.patch

  fish -n \
          scripts/build-l-smash-works-nvdec.fish
```

#### 実行結果

Downloads上のpatchが存在せず、`No such file or directory`で失敗した。

#### 生成・変更されたもの

変更なし。

#### 関連する固定値

- path: `~/projects/aviutl2-linux-patches`
- path: `~/Downloads/0002-fix-ffmpeg-component-validation.patch`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(237).txt lines 2817-2827`

---
### コマンド 311 — `S237-05`

#### 目的

入手できたFFmpeg component validation patchを適用し構文・diffを確認する。

#### 分類

```text
成功
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
cd ~/projects/aviutl2-linux-patches

  git apply --check \
          ~/Downloads/0002-fix-ffmpeg-component-validation.patch

  git apply \
          ~/Downloads/0002-fix-ffmpeg-component-validation.patch

  fish -n \
          scripts/build-l-smash-works-nvdec.fish

  git diff --check
```

#### 実行結果

後続で再ビルドへ進んだためpatch適用は成立した。

#### 生成・変更されたもの

Git working tree、commit、remoteまたはGitHub repository。

#### 関連する固定値

- path: `~/projects/aviutl2-linux-patches`
- path: `~/Downloads/0002-fix-ffmpeg-component-validation.patch`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。

#### 採用可否

```text
REPRODUCTION.mdへ採用
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(237).txt lines 2833-2844`

---
### コマンド 312 — `C237-06`

#### 目的

repository直下の`ffbuild/config.mak`を検証する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
grep -q '^CONFIG_CUVID=yes$' ffbuild/config.mak
  grep -q '^CONFIG_FFNVCODEC=yes$' ffbuild/config.mak
  grep -q '^CONFIG_AV1_CUVID_DECODER=yes$' ffbuild/config.mak
grep: ffbuild/config.mak: No such file or directory
grep: ffbuild/config.mak: No such file or directory
grep: ffbuild/config.mak: No such file or directory
```

#### 実行結果

カレントディレクトリが誤っており、`ffbuild/config.mak: No such file or directory`となった。

#### 生成・変更されたもの

変更なし。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(237).txt lines 2847-2852`

---
### コマンド 313 — `C237-07`

#### 目的

修正後のrepro-02 buildを実行する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
このコマンドブロック内では確認できない。前段のシェル状態に依存する可能性がある。
```

#### 実行コマンド

```fish
cd ~/projects/aviutl2-linux-patches

  scripts/build-l-smash-works-nvdec.fish \
          --work-dir \
          "$HOME/Games/aviutl2/build/l-smash-works-nvdec-repro-02" \
          --jobs (nproc)
```

#### 実行結果

後続ログでは別のrevision生成問題が残り、最終的にrepro-03へ置換された。

#### 生成・変更されたもの

`$HOME/Games/aviutl2/build/l-smash-works-nvdec-repro-02`。

#### 関連する固定値

- path: `~/projects/aviutl2-linux-patches`
- path: `$HOME/Games/aviutl2/build/l-smash-works-nvdec-repro-02`

#### 問題点・注意事項

- Alex環境の個人パスを含む。一般化は別工程で行い、この台帳では原文を保持する。
- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(237).txt lines 2855-2861`

---
### コマンド 314 — `D241-02`

#### 目的

GE-Proton11-1がない場合だけrelease archiveを取得・展開する。

#### 分類

```text
実行確認不能
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
set GE_ARCHIVE \
          "/tmp/GE-Proton11-1.tar.gz"
```

#### 実行コマンド

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

#### 実行結果

条件分岐のbodyが実行された証拠はない。

#### 生成・変更されたもの

検証専用または変数設定のみ。変更対象はコマンド本文と出力証拠から断定しない。

#### 関連する固定値

- version: `GE-Proton11-1`
- path: `/tmp/GE-Proton11-1.tar.gz`

#### 問題点・注意事項

特記なし。

#### 採用可否

```text
要追加確認
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(241).txt lines 34-50`

---
### コマンド 315 — `C241-06`

#### 目的

raw GE Wineで新しい64-bit `prefix-ge`を作成する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/projects/aviutl2-linux-patches
```

#### 事前設定された変数

```fish
WINEPREFIX="$GE_PREFIX"

WINEARCH=win64

LD_LIBRARY_PATH="$GE_LIBS"
```

#### 実行コマンド

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

#### 実行結果

prefix自体は作成されたが、libvkd3d/wined3d/dxgi不足エラーが発生したため単独では最終手順へ採用不可。

#### 生成・変更されたもの

Wine prefixまたはその内部状態。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 最終成功環境を構築する手順には混入させない。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`貼り付けられたテキスト（1 点）(241).txt lines 81-91`

---
### コマンド 316 — `C-E10`

#### 目的

NVIDIA wrapper復元前のprefixでAV1/NVDEC traceを採取する。

#### 分類

```text
失敗・旧手順
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
set NVDEC_LOG \
    "$ROOT/logs/aviutl2-nvdec-reproduction.log"

WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_OK_LIBS"

WINEDLLOVERRIDES='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

DXVK_CONFIG_FILE="$ROOT/nvidia-dxvk.conf"

DXVK_LOG_LEVEL=warn

WINEDEBUG='-all,+timestamp,+loaddll,+nvcuda,+nvcuvid'
```

#### 実行コマンド

```fish
set NVDEC_LOG \
    "$ROOT/logs/aviutl2-nvdec-reproduction.log"

mkdir -p \
    "$ROOT/logs"

rm -f \
    "$NVDEC_LOG"

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

#### 実行結果

AV1のGUI再生自体は成功したが、ログに`Cannot load nvcuvid.dll`と`Failed loading nvcuvid.`が出てNVDECは失敗。libdav1d fallbackだった。

#### 生成・変更されたもの

初回NVDEC検証ログ。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- AV1再生成功だけではNVDEC成功ではないことを示した失敗例。

#### 採用可否

```text
失敗例として掲載
```

#### 証拠位置

`current conversation command block + subsequent user output`

---
### コマンド 317 — `D-E13`

#### 目的

Catalog統合後の完全成功prefixを最終checkpointとして複製する。

#### 分類

```text
実行確認不能
```

#### 使用シェル

```text
fish
```

#### カレントディレクトリ

```text
~/Games/aviutl2/prefix-ge-nvdec-test/drive_c/AviUtl2
```

#### 事前設定された変数

```fish
set FINAL_STAMP \
    (date +%Y%m%d-%H%M%S)

set FINAL_PREFIX_BACKUP \
    "$NV_PREFIX.complete-reproduction-$FINAL_STAMP"

WINEPREFIX="$NV_PREFIX"

LD_LIBRARY_PATH="$GE_OK_LIBS"
```

#### 実行コマンド

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

set FINAL_STAMP \
    (date +%Y%m%d-%H%M%S)

set FINAL_PREFIX_BACKUP \
    "$NV_PREFIX.complete-reproduction-$FINAL_STAMP"

cp -a \
    --reflink=auto \
    "$NV_PREFIX" \
    "$FINAL_PREFIX_BACKUP"

or return 1

echo "Complete reproduction checkpoint:"
echo "$FINAL_PREFIX_BACKUP"
```

#### 実行結果

会話内で提示されたが、ユーザーから実行出力は提示されていない。

#### 生成・変更されたもの

実行されていれば`prefix-ge-nvdec-test.complete-reproduction-*`。

#### 関連する固定値

特記なし。

#### 問題点・注意事項

- 実行証拠がないため成功扱いしない。
- `return 1`の対話Fish問題とtimestamp pathの一般化が必要。

#### 採用可否

```text
要追加確認
```

#### 証拠位置

`current conversation command block + subsequent user output`

---
# 実行順の復元

以下は成功・検証証拠があるIDのみを、端末transcriptの時系列と依存関係に従って並べたもの。コマンド本文は上の台帳項目を参照する。

## Phase 0: 変数とディレクトリ

- `S241-01` — 最終再構築で使用するroot、prefix、runner、override変数を設定する。（分類: 成功）
- `S243-01` — current prefix clone用のroot/runner変数を設定する。（分類: 成功）
- `S243-07` — NV prefixとknown-good runner変数を再設定する。（分類: 成功）
- `S243-12` — known-good backupのフォントを復旧するための変数を設定する。（分類: 成功）
- `S245-01` — Catalog 0.3.3導入用のroot、prefix、runner、repository、cache、log変数を設定する。（分類: 成功）

## Phase 1: ソース・依存関係

- `S237-02` — L-SMASH Works再現用パッチをrepositoryへ適用し、Fish構文とdiffを確認する。（分類: 成功）
- `S237-05` — 入手できたFFmpeg component validation patchを適用し構文・diffを確認する。（分類: 成功）
- `S239-01` — full L-SMASH Works history取得patchを適用し、最終build scriptの構文を確認する。（分類: 成功）
- `S239-02` — 最終採用されたrepro-03 work directoryでcustom L-SMASH Works r1284を完全ビルドする。（分類: 成功）

## Phase 2: DXVK

- `S241-12` — DXVK source/output変数を設定する。（分類: 成功）
- `S241-13` — 既存DXVK build.w64を再コンパイルしruntime出力へインストールする。（分類: 成功）
- `V241-14` — 生成されたpatched d3d11.dllのmarkerを確認する。（分類: 検証専用）
- `S241-15` — 旧d3d11.dllをbackupし、patched d3d11.dllを`prefix-ge`へ配置する。（分類: 成功）
- `V241-16` — patched d3d11.dllとactive DLLのSHA・byte一致を確認する。（分類: 検証専用）

## Phase 3: Wine / DWrite

- `H167` — 対象ソースまたは依存ライブラリをビルド・インストールする。（分類: 成功）

## Phase 4: patched runner

- `H167` — 対象ソースまたは依存ライブラリをビルド・インストールする。（分類: 成功）

## Phase 5: ベースprefix

- `C241-06` — raw GE Wineで新しい64-bit `prefix-ge`を作成する。（分類: 失敗・旧手順）
- `S241-08` — AviUtl2本体ディレクトリをbase prefixから`prefix-ge`へコピーする。（分類: 成功）
- `S241-09` — ProgramDataのAviUtl2データをbase prefixから`prefix-ge`へコピーする。（分類: 成功）
- `S241-10` — base prefixのD3D/DXVK関連DLLを`prefix-ge/system32`へ配置する。（分類: 成功）
- `S242-04` — `prefix-ge`へD3D DLL overrideを登録する。（分類: 成功）
- `V242-05` — `prefix-ge`のDllOverridesを確認する。（分類: 検証専用）

`C241-06`はprefix作成自体は行ったがvkd3d系エラーを含む。したがって、クリーンなREPRODUCTION.mdではこのコマンドをそのまま成功手順へ採用できない。後続のDLLコピー・known-good状態の利用まで含めて再設計が必要。

## Phase 6: フォント

- `S243-12` — known-good backupのフォントを復旧するための変数を設定する。（分類: 成功）
- `V243-13` — 4つのknown-good fontファイルの存在を確認する。（分類: 検証専用）
- `S243-14` — base/NV prefix双方のWineプロセスを停止する。（分類: 成功）
- `S243-15` — Noto CJK TTCとTahoma-compatible OTFをbase/NV prefix双方へ配置する。（分類: 成功）
- `S243-16` — Fonts/FontSubstitutes registry key変数を設定する。（分類: 成功）
- `S243-17` — Noto Sans CJK JPとTahoma-compatible fontのFonts registry entriesを登録する。（分類: 成功）
- `S243-18` — 旧Tahoma FontSubstituteを削除する。（分類: 成功）
- `S243-19` — MS Shell Dlg系をTahomaへ、日本語font aliasesをNoto Sans CJK JPへ登録する。（分類: 成功）
- `S243-20` — フォント設定反映のため両prefixで`wineboot -u`し終了待ちする。（分類: 成功）
- `V243-22` — Tahoma/Noto font登録とFontSubstitutesをqueryする。（分類: 検証専用）

## Phase 7: NVDEC wrapper

- `S-E01` — known-good prefix内のNVIDIA wrapper symlinkとtargetを検証する。（分類: 検証専用）
- `S-E02` — NVIDIA wrapper復元前backup directoryを作成する。（分類: 成功）
- `S-E03` — known-good prefixのNVIDIA Wine wrapper symlinkをcurrent NV prefixへ復元する。（分類: 成功）
- `V-E04` — 復元されたNVIDIA wrapper symlinkとtargetを確認する。（分類: 検証専用）
- `S-E05` — NVIDIA wrapper DLLのnative overrideを再登録する。（分類: 成功）
- `V-E06` — NVIDIA wrapper override値をqueryする。（分類: 検証専用）

## Phase 8: L-SMASH Works

- `S239-02` — 最終採用されたrepro-03 work directoryでcustom L-SMASH Works r1284を完全ビルドする。（分類: 成功）
- `S243-25` — L-SMASH導入前のprefix checkpointを作成する。（分類: 成功）
- `V243-26` — repro-03 artifactとINIの存在、plugin SHAを確認する。（分類: 検証専用）
- `V243-27` — r1284、av1_cuvid、FFmpeg configure markerを確認する。（分類: 検証専用）
- `S243-28` — active Plugin directoryとファイル変数を設定しdirectoryを確保する。（分類: 成功）
- `S243-29` — 既存lwinput.aui2/lsmash.iniをtimestamp付きbackupする。（分類: 成功）
- `S243-30` — repro-03 lwinput.aui2をactive pluginへ配置しbyte一致を確認する。（分類: 成功）
- `S243-31` — repro-03 lsmash.iniをactive pluginへ配置する。（分類: 成功）
- `S243-32` — active lsmash.iniをNVDEC設定へ書き換える。（分類: 成功）
- `V243-33` — active plugin SHAとlsmash.iniの必須3値を確認する。（分類: 検証専用）

## Phase 9: Fcitx5/Mozc

- `V244-02` — ホストのXMODIFIERSとFcitx5/Mozcプロセスを確認する。（分類: 検証専用）
- `S244-03` — AviUtl2専用`InputStyle=overthespot`を登録する。（分類: 成功）
- `V244-04` — InputStyle値をqueryする。（分類: 検証専用）

## Phase 10: AviUtl2起動

- `S243-23` — フォント復旧後のNV prefixでAviUtl2を起動する。（分類: 成功）
- `S243-34` — custom r1284導入後のAviUtl2を起動する。（分類: 成功）

## Phase 11: NVDEC検証

- `S-E07` — NVIDIA wrapper復元後のNVDEC再試験ログを初期化する。（分類: 成功）
- `V-E08` — wrapper復元後にAV1素材を読み込み、NVDEC DLL/load traceを採取する。（分類: 検証専用）
- `V-E09` — NVDEC成功・失敗markerを最終ログから抽出する。（分類: 検証専用）

## Phase 12: DWrite/Mozc検証

- `S244-05` — テキスト検証前にWineプロセスを停止・待機する。（分類: 成功）
- `S244-06` — テキスト検証ログを初期化しAviUtl2ディレクトリへ移動する。（分類: 成功）
- `V244-07` — Fcitx XIMとDWrite traceを有効にしてAviUtl2を起動し実操作する。（分類: 検証専用）
- `V244-08` — DWrite HitTestPoint/HitTestTextRange呼び出しを抽出する。（分類: 検証専用）
- `V244-09` — stub、E_NOTIMPL、未処理例外を検出する。（分類: 検証専用）
- `V244-10` — XIM style選択を確認する。（分類: 検証専用）

## Phase 13: Catalog

- `S245-01` — Catalog 0.3.3導入用のroot、prefix、runner、repository、cache、log変数を設定する。（分類: 成功）
- `V245-02` — 必要コマンドの存在を確認する。（分類: 検証専用）
- `V245-03` — AviUtl2、Wine、wineserver、patched dwriteの必要pathを確認する。（分類: 検証専用）
- `S245-04` — Catalog導入前にWineプロセスを停止・待機する。（分類: 成功）
- `S245-05` — Catalog導入前checkpointを作成する。（分類: 成功）
- `S245-06` — Catalog cache/log directoryを作成する。（分類: 成功）
- `S245-07` — Catalog 0.3.3 release metadataを取得しtagを解決する。（分類: 成功）
- `S245-08` — release JSONから唯一のx64 setup asset名を解決する。（分類: 成功）
- `S245-09` — Catalog installerをdownloadし形式とSHAを確認する。（分類: 成功）
- `S245-10` — 既存prefix内でCatalog installerを実行する。（分類: 成功）
- `V245-11` — インストールされたCatalog executableを検索・一意確認する。（分類: 検証専用）
- `S245-12` — Catalogを初回起動しUIでAviUtl2 root/portable mode/プラグイン導入を行う。（分類: 成功）
- `S245-13` — Catalog終了後にWineプロセスを完全停止する。（分類: 成功）

## Phase 14: Catalog後overlay

- `V245-14` — overlay用repro-03 artifact pathとactive plugin pathを設定・存在確認する。（分類: 検証専用）
- `V245-15` — overlay前artifact SHAを確認する。（分類: 検証専用）
- `S245-16` — install helperでCatalog packageをpauseしcustom r1284を最後にoverlayする。（分類: 成功）
- `V245-17` — artifactとactive pluginのSHA・byte一致を確認する。（分類: 検証専用）
- `V245-18` — active pluginのr1284/CUVID markerを確認する。（分類: 検証専用）
- `V245-19` — active lsmash.iniの必須3値を確認する。（分類: 検証専用）
- `V245-20` — Catalog settings.jsonを一意に検索する。（分類: 検証専用）
- `V245-21` — settings.jsonのJSON妥当性を確認する。（分類: 検証専用）
- `V245-22` — `Mr-Ojii.L-SMASH-Works`がpause listに含まれるか確認する。（分類: 検証専用）

## Phase 15: 最終検証

- `V245-23` — Catalog再起動前のactive r1284 SHAを保存する。（分類: 検証専用）
- `S245-24` — overlay後にCatalogを再起動して通常表示を確認する。（分類: 成功）
- `V245-25` — Catalog再起動前後のplugin SHAを比較する。（分類: 検証専用）

## Phase 16: checkpoint・backup

- `S243-03` — 既存NV prefixをtimestamp付きbackupへ退避する。（分類: 成功）
- `S243-25` — L-SMASH導入前のprefix checkpointを作成する。（分類: 成功）
- `S245-05` — Catalog導入前checkpointを作成する。（分類: 成功）

## Phase 17: Git反映

- `H165` — 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。（分類: 成功）
- `H166` — 対象ソースまたは依存ライブラリをビルド・インストールする。（分類: 成功）
- `S237-02` — L-SMASH Works再現用パッチをrepositoryへ適用し、Fish構文とdiffを確認する。（分類: 成功）
- `S237-05` — 入手できたFFmpeg component validation patchを適用し構文・diffを確認する。（分類: 成功）
- `S239-01` — full L-SMASH Works history取得patchを適用し、最終build scriptの構文を確認する。（分類: 成功）

## 前後関係を断定できない箇所

- 初期のDXVK source編集の細かな試行と、最終採用patchのどの編集が直接現在のsource treeへ残ったかは、Fish historyだけでは一意に確定できない。最終binary/hashとrepository patchを優先する。
- Tahoma-compatible OTFの**生成コマンド**はこの会話の実行ログから回収できない。今回の成功環境ではknown-good backupからコピーした。
- NVIDIA wrapper archiveの**最初の取得・展開・symlink生成コマンド**は最終再構築transcriptに完全な形で残っていない。今回の成功環境ではknown-good prefixからsymlinkを復元した。
- patched runnerの元GE-Proton複製と初期Wine configure/build全体は断片的。最終DWrite hardening command `H167`とknown-good runner hashは確認できるが、ゼロからの全runner生成手順は追加確認が必要。

# 最終一覧表

| ID | コマンド概要 | 分類 | 成功確認 | 最終手順への採用 | 追加確認 |
| -- | -- | -- | -- | -- | -- |
| H001 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H002 | AviUtl2 on Linux環境の構築・調査・検証に関係する処理を実行する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H003 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H004 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H005 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H006 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H007 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H008 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H009 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H010 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H011 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H012 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 実行確認不能 | なし | 要追加確認 | 必要 |
| H013 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H014 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 実行確認不能 | なし | 要追加確認 | 必要 |
| H015 | 後続コマンドで使用するシェル変数を設定する。 | 実行確認不能 | なし | 要追加確認 | 必要 |
| H016 | Wine prefixを作成または更新し、レジストリとランタイム状態を反映する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H017 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H018 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H019 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H020 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H021 | WineレジストリへDLL override、フォント、IMEなどの設定を登録する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H022 | Wineレジストリの設定値を確認する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H023 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H024 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H025 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H026 | AviUtl2 on Linux環境の構築・調査・検証に関係する処理を実行する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H027 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H028 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H029 | AviUtl2 on Linux環境の構築・調査・検証に関係する処理を実行する。 | 実行確認不能 | なし | 要追加確認 | 必要 |
| H030 | AviUtl2 on Linux環境の構築・調査・検証に関係する処理を実行する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H031 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H032 | AviUtl2 on Linux環境の構築・調査・検証に関係する処理を実行する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H033 | DXVKのMesonビルドディレクトリを構成する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| H034 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H035 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H036 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H037 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H038 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H039 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H040 | AviUtl2 on Linux環境の構築・調査・検証に関係する処理を実行する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H041 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H042 | Wine prefixを作成または更新し、レジストリとランタイム状態を反映する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H043 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H044 | AviUtl2 on Linux環境の構築・調査・検証に関係する処理を実行する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H045 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H046 | WineレジストリへDLL override、フォント、IMEなどの設定を登録する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H047 | Wineレジストリの設定値を確認する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H048 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H049 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H050 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H051 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H052 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H053 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H054 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| H055 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H056 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H057 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H058 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H059 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H060 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H061 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H062 | WineレジストリへDLL override、フォント、IMEなどの設定を登録する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H063 | WineレジストリへDLL override、フォント、IMEなどの設定を登録する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H064 | Wineレジストリの設定値を確認する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H065 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H066 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H067 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| H068 | Wineレジストリの旧設定を削除する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| H069 | WineレジストリへDLL override、フォント、IMEなどの設定を登録する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| H070 | Wine prefixを作成または更新し、レジストリとランタイム状態を反映する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| H071 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H072 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H073 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H074 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H075 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H076 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H077 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H078 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H079 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H080 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H081 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H082 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H083 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H084 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H085 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H086 | AviUtl2 on Linux環境の構築・調査・検証に関係する処理を実行する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H087 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H088 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H089 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H090 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H091 | AviUtl2 Catalogの取得、導入、起動、設定または更新停止状態を処理する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H092 | AviUtl2 Catalogの取得、導入、起動、設定または更新停止状態を処理する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H093 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H094 | AviUtl2 Catalogの取得、導入、起動、設定または更新停止状態を処理する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H095 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H096 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H097 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H098 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H099 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H100 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H101 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H102 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H103 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H104 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H105 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H106 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H107 | AviUtl2 Catalogの取得、導入、起動、設定または更新停止状態を処理する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H108 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H109 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H110 | AviUtl2 on Linux環境の構築・調査・検証に関係する処理を実行する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H111 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H112 | AV1検証素材を作成またはメディア属性を確認する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| H113 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H114 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| H115 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H116 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H117 | WineレジストリへDLL override、フォント、IMEなどの設定を登録する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| H118 | Wineレジストリの設定値を確認する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H119 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H120 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H121 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H122 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H123 | WineレジストリへDLL override、フォント、IMEなどの設定を登録する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| H124 | Wineレジストリの設定値を確認する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H125 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H126 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H127 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H128 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H129 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H130 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H131 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H132 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H133 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H134 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H135 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H136 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H137 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H138 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H139 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H140 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H141 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H142 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H143 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H144 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H145 | WineレジストリへDLL override、フォント、IMEなどの設定を登録する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H146 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H147 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H148 | WineレジストリへDLL override、フォント、IMEなどの設定を登録する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| H149 | Wineレジストリの設定値を確認する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H150 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H151 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H152 | WineレジストリへDLL override、フォント、IMEなどの設定を登録する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H153 | Wineレジストリの設定値を確認する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H154 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H155 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H156 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H157 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H158 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H159 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H160 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H161 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H162 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H163 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H164 | バイナリ、artifact、DLLまたは設定ファイルの同一性・形式・埋め込みmarkerを検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| H165 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 成功 | あり | 内容を修正してからREPRODUCTION.mdへ採用 | 必要 |
| H166 | 対象ソースまたは依存ライブラリをビルド・インストールする。 | 成功 | あり | 内容を修正してからREPRODUCTION.mdへ採用 | 必要 |
| H167 | 対象ソースまたは依存ライブラリをビルド・インストールする。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| H168 | DXVKをコンパイルする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H169 | DXVKをコンパイルする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H170 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H171 | ファイル、プロセス、ログ、設定またはソース状態を調査・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H172 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H173 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H174 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H175 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H176 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H177 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H178 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H179 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H180 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H181 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H182 | 対象Wine prefixのプロセスを停止または終了待ちする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H183 | Wine prefixを作成または更新し、レジストリとランタイム状態を反映する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H184 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H185 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H186 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H187 | 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H188 | AviUtl2を指定runner、prefix、DLL override、DXVK設定で起動・検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| H189 | AviUtl2 Catalogの取得、導入、起動、設定または更新停止状態を処理する。 | 実行確認不能 | なし | 要追加確認 | 必要 |
| V224-01 | 保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| V225-01 | 保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| V226-01 | 保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| V228-01 | 保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| V229-01 | 保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| V230-01 | 保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| V231-01 | 保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| V233-01 | 保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| V234-01 | 保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| V235-01 | 保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| V238-01 | 保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| V240-01 | 保存済み環境、ソース、prefix、runner、Catalog、L-SMASH Worksまたは履歴の状態を読み取り専用で監査する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| D227-01 | AviUtl2環境を監査するFishスクリプト本文。 | 実行確認不能 | なし | 要追加確認 | 必要 |
| V237-01 | Catalogとcustom L-SMASH Worksのhash分類を読み取り専用で検証する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| S237-02 | L-SMASH Works再現用パッチをrepositoryへ適用し、Fish構文とdiffを確認する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| C237-03 | 最初のrepro-01 work directoryでL-SMASH Worksを再現ビルドする。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| C237-04 | FFmpeg validation修正patchを適用する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| S237-05 | 入手できたFFmpeg component validation patchを適用し構文・diffを確認する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| C237-06 | repository直下の`ffbuild/config.mak`を検証する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| C237-07 | 修正後のrepro-02 buildを実行する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| S239-01 | full L-SMASH Works history取得patchを適用し、最終build scriptの構文を確認する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S239-02 | 最終採用されたrepro-03 work directoryでcustom L-SMASH Works r1284を完全ビルドする。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S241-01 | 最終再構築で使用するroot、prefix、runner、override変数を設定する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| D241-02 | GE-Proton11-1がない場合だけrelease archiveを取得・展開する。 | 実行確認不能 | なし | 要追加確認 | 必要 |
| V241-03 | GE Wine binary形式とWine versionを確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S241-04 | 旧base prefixのWineプロセスを停止する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S241-05 | 既存`prefix-ge`をtimestamp付きbackupへ退避する。 | 成功 | あり | 内容を修正してからREPRODUCTION.mdへ採用 | 必要 |
| C241-06 | raw GE Wineで新しい64-bit `prefix-ge`を作成する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| V241-07 | 作成されたprefix基本ファイルの存在を確認する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| S241-08 | AviUtl2本体ディレクトリをbase prefixから`prefix-ge`へコピーする。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S241-09 | ProgramDataのAviUtl2データをbase prefixから`prefix-ge`へコピーする。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S241-10 | base prefixのD3D/DXVK関連DLLを`prefix-ge/system32`へ配置する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| V241-11 | 配置済みD3D DLLのSHA-256を確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S241-12 | DXVK source/output変数を設定する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S241-13 | 既存DXVK build.w64を再コンパイルしruntime出力へインストールする。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| V241-14 | 生成されたpatched d3d11.dllのmarkerを確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S241-15 | 旧d3d11.dllをbackupし、patched d3d11.dllを`prefix-ge`へ配置する。 | 成功 | あり | 内容を修正してからREPRODUCTION.mdへ採用 | 必要 |
| V241-16 | patched d3d11.dllとactive DLLのSHA・byte一致を確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S241-17 | DXVK config path変数を設定する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| V241-18 | `prefix-ge`でAviUtl2を起動しformat 69 workaround到達を確認する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| V242-01 | 歴史的な最初の成功環境のlauncher、prefix、vkd3d DLLの存在を確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| V242-02 | 旧`~/projects/aviutl2-linux`の最初の成功launcherを再実行し、原初成功ログを保存する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S242-03 | 正規repositoryへカレントディレクトリを戻す。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S242-04 | `prefix-ge`へD3D DLL overrideを登録する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| V242-05 | `prefix-ge`のDllOverridesを確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| V242-06 | `prefix-ge`で最終再現起動ログを取得し、Wine/tee statusを記録する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S243-01 | current prefix clone用のroot/runner変数を設定する。 | 成功 | あり | 内容を修正してからREPRODUCTION.mdへ採用 | 必要 |
| S243-02 | base `prefix-ge`のWineプロセスを停止・待機する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S243-03 | 既存NV prefixをtimestamp付きbackupへ退避する。 | 成功 | あり | 内容を修正してからREPRODUCTION.mdへ採用 | 必要 |
| S243-04 | 確認済み`prefix-ge`を`prefix-ge-nvdec-test`へreflink cloneする。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| V243-05 | clone後のregistry、AviUtl2本体、D3D DLLをbyte比較する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| V243-06 | clone直後のNV prefixでAviUtl2を起動しformat 69到達を確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S243-07 | NV prefixとknown-good runner変数を再設定する。 | 成功 | あり | 内容を修正してからREPRODUCTION.mdへ採用 | 必要 |
| S243-08 | NV prefixのWineプロセスを停止・待機する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S243-09 | NVIDIA DLL overrideをnativeへ登録する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| V243-10 | NVIDIA DLL override値を確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| V243-11 | NVIDIA overrideを含む構成でAviUtl2を短時間起動する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S243-12 | known-good backupのフォントを復旧するための変数を設定する。 | 成功 | あり | 内容を修正してからREPRODUCTION.mdへ採用 | 必要 |
| V243-13 | 4つのknown-good fontファイルの存在を確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S243-14 | base/NV prefix双方のWineプロセスを停止する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S243-15 | Noto CJK TTCとTahoma-compatible OTFをbase/NV prefix双方へ配置する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S243-16 | Fonts/FontSubstitutes registry key変数を設定する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S243-17 | Noto Sans CJK JPとTahoma-compatible fontのFonts registry entriesを登録する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S243-18 | 旧Tahoma FontSubstituteを削除する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S243-19 | MS Shell Dlg系をTahomaへ、日本語font aliasesをNoto Sans CJK JPへ登録する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S243-20 | フォント設定反映のため両prefixで`wineboot -u`し終了待ちする。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S243-21 | フォント反映確認のため両prefixで`wineboot -u`を再実行する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| V243-22 | Tahoma/Noto font登録とFontSubstitutesをqueryする。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S243-23 | フォント復旧後のNV prefixでAviUtl2を起動する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S243-24 | L-SMASH導入前にWineプロセスを完全停止する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S243-25 | L-SMASH導入前のprefix checkpointを作成する。 | 成功 | あり | 内容を修正してからREPRODUCTION.mdへ採用 | 必要 |
| V243-26 | repro-03 artifactとINIの存在、plugin SHAを確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| V243-27 | r1284、av1_cuvid、FFmpeg configure markerを確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S243-28 | active Plugin directoryとファイル変数を設定しdirectoryを確保する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S243-29 | 既存lwinput.aui2/lsmash.iniをtimestamp付きbackupする。 | 成功 | あり | 内容を修正してからREPRODUCTION.mdへ採用 | 必要 |
| S243-30 | repro-03 lwinput.aui2をactive pluginへ配置しbyte一致を確認する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S243-31 | repro-03 lsmash.iniをactive pluginへ配置する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S243-32 | active lsmash.iniをNVDEC設定へ書き換える。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| V243-33 | active plugin SHAとlsmash.iniの必須3値を確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S243-34 | custom r1284導入後のAviUtl2を起動する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S244-01 | Mozc/DWrite検証用のroot、prefix、runner変数を設定する。 | 成功 | あり | 内容を修正してからREPRODUCTION.mdへ採用 | 必要 |
| V244-02 | ホストのXMODIFIERSとFcitx5/Mozcプロセスを確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S244-03 | AviUtl2専用`InputStyle=overthespot`を登録する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| V244-04 | InputStyle値をqueryする。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S244-05 | テキスト検証前にWineプロセスを停止・待機する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S244-06 | テキスト検証ログを初期化しAviUtl2ディレクトリへ移動する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| V244-07 | Fcitx XIMとDWrite traceを有効にしてAviUtl2を起動し実操作する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| V244-08 | DWrite HitTestPoint/HitTestTextRange呼び出しを抽出する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| V244-09 | stub、E_NOTIMPL、未処理例外を検出する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| V244-10 | XIM style選択を確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S245-01 | Catalog 0.3.3導入用のroot、prefix、runner、repository、cache、log変数を設定する。 | 成功 | あり | 内容を修正してからREPRODUCTION.mdへ採用 | 必要 |
| V245-02 | 必要コマンドの存在を確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| V245-03 | AviUtl2、Wine、wineserver、patched dwriteの必要pathを確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S245-04 | Catalog導入前にWineプロセスを停止・待機する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S245-05 | Catalog導入前checkpointを作成する。 | 成功 | あり | 内容を修正してからREPRODUCTION.mdへ採用 | 必要 |
| S245-06 | Catalog cache/log directoryを作成する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S245-07 | Catalog 0.3.3 release metadataを取得しtagを解決する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S245-08 | release JSONから唯一のx64 setup asset名を解決する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S245-09 | Catalog installerをdownloadし形式とSHAを確認する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S245-10 | 既存prefix内でCatalog installerを実行する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| V245-11 | インストールされたCatalog executableを検索・一意確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S245-12 | Catalogを初回起動しUIでAviUtl2 root/portable mode/プラグイン導入を行う。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| S245-13 | Catalog終了後にWineプロセスを完全停止する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| V245-14 | overlay用repro-03 artifact pathとactive plugin pathを設定・存在確認する。 | 検証専用 | なし | 検証手順として採用 | 不要 |
| V245-15 | overlay前artifact SHAを確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S245-16 | install helperでCatalog packageをpauseしcustom r1284を最後にoverlayする。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| V245-17 | artifactとactive pluginのSHA・byte一致を確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| V245-18 | active pluginのr1284/CUVID markerを確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| V245-19 | active lsmash.iniの必須3値を確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| V245-20 | Catalog settings.jsonを一意に検索する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| V245-21 | settings.jsonのJSON妥当性を確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| V245-22 | `Mr-Ojii.L-SMASH-Works`がpause listに含まれるか確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| V245-23 | Catalog再起動前のactive r1284 SHAを保存する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S245-24 | overlay後にCatalogを再起動して通常表示を確認する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| V245-25 | Catalog再起動前後のplugin SHAを比較する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S-E01 | known-good prefix内のNVIDIA wrapper symlinkとtargetを検証する。 | 検証専用 | あり | 内容を修正してから検証手順として採用 | 必要 |
| S-E02 | NVIDIA wrapper復元前backup directoryを作成する。 | 成功 | あり | 内容を修正してからREPRODUCTION.mdへ採用 | 必要 |
| S-E03 | known-good prefixのNVIDIA Wine wrapper symlinkをcurrent NV prefixへ復元する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| V-E04 | 復元されたNVIDIA wrapper symlinkとtargetを確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S-E05 | NVIDIA wrapper DLLのnative overrideを再登録する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| V-E06 | NVIDIA wrapper override値をqueryする。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| S-E07 | NVIDIA wrapper復元後のNVDEC再試験ログを初期化する。 | 成功 | あり | REPRODUCTION.mdへ採用 | 不要 |
| V-E08 | wrapper復元後にAV1素材を読み込み、NVDEC DLL/load traceを採取する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| V-E09 | NVDEC成功・失敗markerを最終ログから抽出する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| C-E10 | NVIDIA wrapper復元前のprefixでAV1/NVDEC traceを採取する。 | 失敗・旧手順 | 失敗確認 | 失敗例として掲載 | 不要 |
| V-E11 | 初回NVDECログからCUVID contextと致命的エラーを抽出する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| V-E12 | 初回NVDECログのcontext行とfatal errorを分けて確認する。 | 検証専用 | あり | 検証手順として採用 | 不要 |
| D-E13 | Catalog統合後の完全成功prefixを最終checkpointとして複製する。 | 実行確認不能 | なし | 要追加確認 | 必要 |

# REPRODUCTION.mdへそのまま採用できるコマンド

- `H033` — DXVKのMesonビルドディレクトリを構成する。
- `H054` — 対象Wine prefixのプロセスを停止または終了待ちする。
- `H067` — 対象Wine prefixのプロセスを停止または終了待ちする。
- `H068` — Wineレジストリの旧設定を削除する。
- `H069` — WineレジストリへDLL override、フォント、IMEなどの設定を登録する。
- `H070` — Wine prefixを作成または更新し、レジストリとランタイム状態を反映する。
- `H112` — AV1検証素材を作成またはメディア属性を確認する。
- `H114` — 対象Wine prefixのプロセスを停止または終了待ちする。
- `H117` — WineレジストリへDLL override、フォント、IMEなどの設定を登録する。
- `H123` — WineレジストリへDLL override、フォント、IMEなどの設定を登録する。
- `H148` — WineレジストリへDLL override、フォント、IMEなどの設定を登録する。
- `H167` — 対象ソースまたは依存ライブラリをビルド・インストールする。
- `S237-02` — L-SMASH Works再現用パッチをrepositoryへ適用し、Fish構文とdiffを確認する。
- `S237-05` — 入手できたFFmpeg component validation patchを適用し構文・diffを確認する。
- `S239-01` — full L-SMASH Works history取得patchを適用し、最終build scriptの構文を確認する。
- `S239-02` — 最終採用されたrepro-03 work directoryでcustom L-SMASH Works r1284を完全ビルドする。
- `S241-01` — 最終再構築で使用するroot、prefix、runner、override変数を設定する。
- `S241-04` — 旧base prefixのWineプロセスを停止する。
- `S241-08` — AviUtl2本体ディレクトリをbase prefixから`prefix-ge`へコピーする。
- `S241-09` — ProgramDataのAviUtl2データをbase prefixから`prefix-ge`へコピーする。
- `S241-10` — base prefixのD3D/DXVK関連DLLを`prefix-ge/system32`へ配置する。
- `S241-12` — DXVK source/output変数を設定する。
- `S241-13` — 既存DXVK build.w64を再コンパイルしruntime出力へインストールする。
- `S241-17` — DXVK config path変数を設定する。
- `S242-03` — 正規repositoryへカレントディレクトリを戻す。
- `S242-04` — `prefix-ge`へD3D DLL overrideを登録する。
- `S243-02` — base `prefix-ge`のWineプロセスを停止・待機する。
- `S243-04` — 確認済み`prefix-ge`を`prefix-ge-nvdec-test`へreflink cloneする。
- `S243-08` — NV prefixのWineプロセスを停止・待機する。
- `S243-09` — NVIDIA DLL overrideをnativeへ登録する。
- `S243-14` — base/NV prefix双方のWineプロセスを停止する。
- `S243-15` — Noto CJK TTCとTahoma-compatible OTFをbase/NV prefix双方へ配置する。
- `S243-16` — Fonts/FontSubstitutes registry key変数を設定する。
- `S243-17` — Noto Sans CJK JPとTahoma-compatible fontのFonts registry entriesを登録する。
- `S243-18` — 旧Tahoma FontSubstituteを削除する。
- `S243-19` — MS Shell Dlg系をTahomaへ、日本語font aliasesをNoto Sans CJK JPへ登録する。
- `S243-20` — フォント設定反映のため両prefixで`wineboot -u`し終了待ちする。
- `S243-21` — フォント反映確認のため両prefixで`wineboot -u`を再実行する。
- `S243-23` — フォント復旧後のNV prefixでAviUtl2を起動する。
- `S243-24` — L-SMASH導入前にWineプロセスを完全停止する。
- `S243-28` — active Plugin directoryとファイル変数を設定しdirectoryを確保する。
- `S243-30` — repro-03 lwinput.aui2をactive pluginへ配置しbyte一致を確認する。
- `S243-31` — repro-03 lsmash.iniをactive pluginへ配置する。
- `S243-32` — active lsmash.iniをNVDEC設定へ書き換える。
- `S243-34` — custom r1284導入後のAviUtl2を起動する。
- `S244-03` — AviUtl2専用`InputStyle=overthespot`を登録する。
- `S244-05` — テキスト検証前にWineプロセスを停止・待機する。
- `S244-06` — テキスト検証ログを初期化しAviUtl2ディレクトリへ移動する。
- `S245-04` — Catalog導入前にWineプロセスを停止・待機する。
- `S245-06` — Catalog cache/log directoryを作成する。
- `S245-07` — Catalog 0.3.3 release metadataを取得しtagを解決する。
- `S245-08` — release JSONから唯一のx64 setup asset名を解決する。
- `S245-09` — Catalog installerをdownloadし形式とSHAを確認する。
- `S245-10` — 既存prefix内でCatalog installerを実行する。
- `S245-12` — Catalogを初回起動しUIでAviUtl2 root/portable mode/プラグイン導入を行う。
- `S245-13` — Catalog終了後にWineプロセスを完全停止する。
- `S245-16` — install helperでCatalog packageをpauseしcustom r1284を最後にoverlayする。
- `S245-24` — overlay後にCatalogを再起動して通常表示を確認する。
- `S-E03` — known-good prefixのNVIDIA Wine wrapper symlinkをcurrent NV prefixへ復元する。
- `S-E05` — NVIDIA wrapper DLLのnative overrideを再登録する。
- `S-E07` — NVIDIA wrapper復元後のNVDEC再試験ログを初期化する。

# 内容を修正してから採用すべきコマンド

- `H165` — 必要なprefix、runner、DLL、フォント、プラグインまたはcheckpointを作成・配置する。
- `H166` — 対象ソースまたは依存ライブラリをビルド・インストールする。
- `S241-05` — 既存`prefix-ge`をtimestamp付きbackupへ退避する。
- `S241-15` — 旧d3d11.dllをbackupし、patched d3d11.dllを`prefix-ge`へ配置する。
- `S243-01` — current prefix clone用のroot/runner変数を設定する。
- `S243-03` — 既存NV prefixをtimestamp付きbackupへ退避する。
- `S243-07` — NV prefixとknown-good runner変数を再設定する。
- `S243-12` — known-good backupのフォントを復旧するための変数を設定する。
- `S243-25` — L-SMASH導入前のprefix checkpointを作成する。
- `S243-29` — 既存lwinput.aui2/lsmash.iniをtimestamp付きbackupする。
- `S244-01` — Mozc/DWrite検証用のroot、prefix、runner変数を設定する。
- `S245-01` — Catalog 0.3.3導入用のroot、prefix、runner、repository、cache、log変数を設定する。
- `S245-05` — Catalog導入前checkpointを作成する。
- `S-E01` — known-good prefix内のNVIDIA wrapper symlinkとtargetを検証する。
- `S-E02` — NVIDIA wrapper復元前backup directoryを作成する。

# 履歴だけでは不足している工程

1. Tahoma-compatible OTFをライセンス上安全かつ再現可能に生成するコマンド。
2. `nvidia-libs-v1.0.2`を最初に取得・展開し、`system32`へ3本のsymlinkを新規作成する完全なコマンド。
3. GE-Proton 11-1をゼロから複製し、Wine/DWrite build treeをconfigureする全コマンド。
4. AviUtl2本体とProgramDataの合法な入手元・展開元を含む初回配置コマンド。履歴には既存prefix間コピーしか完全には残っていない。
5. `install-dwrite.fish`内部が行うrunner内PE/Unix DWrite配置の全コマンド。helper invocationはあるが、実行時の内部command transcriptはない。
6. 最終repositoryへのcommit/pushのうち、最新repro-03/Catalog統合変更をpushした明示的な端末出力。過去のinitial pushは履歴にあるが、今回の最終差分は追加確認が必要。

# 証拠ファイルinventory

| File | Lines | SHA-256 |
| -- | --: | -- |
| `貼り付けられたテキスト（1 点）(223).txt` | 4905 | `2d131db7479bcd7040e7c5dd14b523f26ee944f0704386ae30d880ac7e215bc1` |
| `貼り付けられたテキスト（1 点）(224).txt` | 1406 | `49dbcf93301a022f94869b43f87879b9c1cb405849252c27b905c4062e01cdf8` |
| `貼り付けられたテキスト（1 点）(225).txt` | 3178 | `2e039cb0b517c469da33a479dc514eebb9f7fe5e8980388b28c63d79923fa69a` |
| `貼り付けられたテキスト（1 点）(226).txt` | 4248 | `c3373be3324dc0d313df12dcc6f6c2c5c0b880c6296242a3d7a4161280f44cc6` |
| `貼り付けられたテキスト（1 点）(227).txt` | 403 | `948e0518eee20ab778ea6bba818cec6159294a10579bd5adc1bb3f97cabbcd88` |
| `貼り付けられたテキスト（1 点）(228).txt` | 1587 | `77fbc24c1ca2a6620a9212abfa93c8536381373e094329a957e63a6f703d4f0c` |
| `貼り付けられたテキスト（1 点）(229).txt` | 1195 | `8a47b5ebb286eb6572b6be57134fa065731f4419502a25778717b7618d7b8d27` |
| `貼り付けられたテキスト（1 点）(230).txt` | 1960 | `c61b45ff2f425c99541d515a608ccc357fc94c02676365aca40ff9e20b506e61` |
| `貼り付けられたテキスト（1 点）(231).txt` | 7384 | `bc12b7fbed25586add985ff7a0098d587a30184fe4666bd05493cdf2c5a8285c` |
| `貼り付けられたテキスト（1 点）(232).txt` | 6437 | `0b272db85f70254e48285a14d652a13fdf1784338215752a06ec981c9273c19f` |
| `貼り付けられたテキスト（1 点）(233).txt` | 2593 | `ecd7d031b24653ea73c11cfa79f1891d0552b6be3d72e6507e8313ec4b2c5895` |
| `貼り付けられたテキスト（1 点）(234).txt` | 653 | `5674db11305692ae1e6e37bce446d50c6bbb1e4b2c07fb51998dfe0feeb6cb30` |
| `貼り付けられたテキスト（1 点）(235).txt` | 1351 | `cdf6a47ab8bf39eac0bb54384a33a4f42ab60724840d3088776307053bfea9ab` |
| `貼り付けられたテキスト（1 点）(236).txt` | 2817 | `3584c5ca27a840142fe7f0c2749ff5670ea7c1de0eae962be894b689e71cdde2` |
| `貼り付けられたテキスト（1 点）(237).txt` | 6864 | `b2a1b82e662fcc83447b19c0bae39da9f307d744c0c62c332e8c0482ad82fcc3` |
| `貼り付けられたテキスト（1 点）(238).txt` | 879 | `a0f4e93d5148ac6f677bf43d39eba45063b1021482df2d216a0e3474791a6113` |
| `貼り付けられたテキスト（1 点）(239).txt` | 4027 | `5e00db315508fd1450929ade1f87e0fa6bcffbebf54d570cfc85b90760c84425` |
| `貼り付けられたテキスト（1 点）(240).txt` | 515 | `6ba9609503fa777fb425746791756273656964276f790aa5071398306d15f95e` |
| `貼り付けられたテキスト（1 点）(241).txt` | 258 | `49ccbc201b4cc7067ec52b2056aa3275afd6f8b80790030c5cb89a057dfce332` |
| `貼り付けられたテキスト（1 点）(242).txt` | 1540 | `767afb4a23b9e71c731d489ba4d0b0b526ee982d1150c0c08028058cca8457af` |
| `貼り付けられたテキスト（1 点）(243).txt` | 8121 | `25bd47ba076748126cfa4d1b28376c7e554b4cd31f08afa4911a4368be76b098` |
| `貼り付けられたテキスト（1 点）(244).txt` | 188 | `25ee3e346a1f1699c9285bbf097c52178adbd439de00fb5469d0ca3ea151a2de` |
| `貼り付けられたテキスト（1 点）(245).txt` | 493 | `562a629cef6a7930b7444e7cf78e387bdea88131a9a5b06b51d04fc5ed4e08f6` |
| `build-l-smash-works-nvdec.fish` | 651 | `0ee649c38de355a5d71af50912b012506b7468cacf074d97e331a6b855fe4f86` |
| `install-l-smash-works-nvdec.fish` | 245 | `7e9714083224d9793e865660ac472bd2163f4720300d3e6eeb28afd728519650` |
| `restore-known-good-aviutl2.fish` | 513 | `96b7e46200de35de584b8a63797c3add776bcff72482c01ccc2730435e68263a` |
| `REPRODUCTION-FIRST-SUCCESS.md` | 1242 | `056a2c2cd5a74ef7c817974c90d3d310bfbad1e6438534be6f2dc9bf744614bf` |
| `REPRODUCTION.md` | 1242 | `056a2c2cd5a74ef7c817974c90d3d310bfbad1e6438534be6f2dc9bf744614bf` |
| `L-SMASH-WORKS-NVDEC.md` | 372 | `0b81aaec6c44839b78ab630f661dffb0ab680419c469ef5d57fa2db677cb8873` |

# Appendix A — 実行されたL-SMASH Works build helperの完全本文

`S239-02`で実際に起動された `scripts/build-l-smash-works-nvdec.fish` の保存済み本文。これは個別に端末入力されたコマンド群ではなく、script invocationにより内部実行された処理である。

```fish
#!/usr/bin/env fish

# Build the validated AviUtl2 L-SMASH Works r1284/NVDEC artifact from
# pinned source commits. This script builds into a fresh directory only.
# It never modifies a Wine prefix, AviUtl2 installation, or Catalog state.

set -g SCRIPT_NAME (basename (status filename))

function usage
    echo "Usage: $SCRIPT_NAME [--work-dir PATH] [--output-dir PATH] [--jobs N]"
    echo
    echo "Defaults:"
    echo "  --work-dir   \$HOME/Games/aviutl2/build/l-smash-works-nvdec-repro"
    echo "  --output-dir <work-dir>/output"
    echo "  --jobs       nproc"
end

function die
    echo "ERROR: $argv" >&2
    exit 1
end

function note
    echo
    echo "==> $argv"
end

function require_command
    set -l command_name $argv[1]
    command -q "$command_name"
    or die "required command not found: $command_name"
end

function clone_commit
    set -l name $argv[1]
    set -l url $argv[2]
    set -l destination $argv[3]
    set -l commit $argv[4]

    note "Fetching $name at $commit"

    test ! -e "$destination"
    or die "destination already exists: $destination"

    git init -q "$destination"
    or die "git init failed: $destination"

    git -C "$destination" remote add origin "$url"
    or die "git remote add failed: $name"

    git -C "$destination" fetch --depth 1 origin "$commit"
    or die "git fetch failed: $name ($commit)"

    git -C "$destination" checkout --detach -q FETCH_HEAD
    or die "git checkout failed: $name"

    set -l actual (git -C "$destination" rev-parse HEAD)
    test "$actual" = "$commit"
    or die "$name commit mismatch: expected $commit, got $actual"
end

argparse \
    'h/help' \
    'w/work-dir=' \
    'o/output-dir=' \
    'j/jobs=' \
    -- $argv
or begin
    usage >&2
    exit 2
end

if set -q _flag_help
    usage
    exit 0
end

set -l script_path (status filename)
set -l script_dir (cd (dirname "$script_path"); and pwd -P)
set -l repo_root (cd "$script_dir/.."; and pwd -P)

set -l work_dir "$HOME/Games/aviutl2/build/l-smash-works-nvdec-repro"
if set -q _flag_work_dir
    set work_dir (string trim -- "$_flag_work_dir")
end

test -n "$work_dir"
or die "--work-dir must not be empty"

set work_dir (string replace -r '/+$' '' -- "$work_dir")
set -l output_dir "$work_dir/output"
if set -q _flag_output_dir
    set output_dir (string trim -- "$_flag_output_dir")
end

test -n "$output_dir"
or die "--output-dir must not be empty"
set output_dir (string replace -r '/+$' '' -- "$output_dir")

set -l jobs
if set -q _flag_jobs
    set jobs "$_flag_jobs"
else
    set jobs (nproc 2>/dev/null)
    if test -z "$jobs"
        set jobs 1
    end
end

string match -rq '^[1-9][0-9]*$' -- "$jobs"
or die "--jobs must be a positive integer: $jobs"

set -l patch_file "$repo_root/patches/l-smash-works/0001-transfer-hardware-frames-before-output.patch"
set -l lsmash_ini "$repo_root/config/lsmash.ini"

test -f "$patch_file"
or die "patch not found: $patch_file"

test -f "$lsmash_ini"
or die "configuration not found: $lsmash_ini"

set -l expected_patch_sha256 7c4b410fa4ffa5223b63522f27e9e2534bac550d2fa038c1aee94ed6de5ae0d2
set -l actual_patch_sha256 (sha256sum "$patch_file" | string split ' ')[1]
test "$actual_patch_sha256" = "$expected_patch_sha256"
or die "patch SHA-256 mismatch: expected $expected_patch_sha256, got $actual_patch_sha256"

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
    grep \
    sed \
    x86_64-w64-mingw32-gcc \
    x86_64-w64-mingw32-g++ \
    x86_64-w64-mingw32-ar \
    x86_64-w64-mingw32-ranlib \
    x86_64-w64-mingw32-strip \
    x86_64-w64-mingw32-windres \
    x86_64-w64-mingw32-objdump \
    stat \
    head

    require_command "$command_name"
end

# Refuse to reuse a prior tree. This avoids silently combining stale build
# outputs with the pinned sources below.
test ! -e "$work_dir"
or die "work directory already exists; choose a new path or remove it manually: $work_dir"

test ! -e "$output_dir"
or die "output directory already exists: $output_dir"

set -l deps_dir "$work_dir/deps"
set -l prefix "$work_dir/prefix"
set -l tool_bin "$work_dir/bin"
set -l source_dir "$work_dir/src"
set -l lsw_source "$source_dir/L-SMASH-Works"
set -l toolchain "$work_dir/x86_64-w64-mingw32.cmake"

mkdir -p \
    "$deps_dir" \
    "$prefix/include" \
    "$prefix/lib/pkgconfig" \
    "$tool_bin" \
    "$source_dir" \
    "$output_dir"
or die "failed to create build directories"

set -l pkg_config_path (command -s pkg-config)
ln -s "$pkg_config_path" "$tool_bin/x86_64-w64-mingw32-pkg-config"
or die "failed to create the MinGW pkg-config wrapper"

set -gx PATH "$tool_bin" $PATH
set -gx PKG_CONFIG_PATH "$prefix/lib/pkgconfig"
set -gx PKG_CONFIG_LIBDIR "$prefix/lib/pkgconfig"

printf '%s\n' \
    'set(CMAKE_SYSTEM_NAME Windows)' \
    'set(CMAKE_SYSTEM_PROCESSOR x86_64)' \
    'set(CMAKE_C_COMPILER x86_64-w64-mingw32-gcc)' \
    'set(CMAKE_CXX_COMPILER x86_64-w64-mingw32-g++)' \
    'set(CMAKE_RC_COMPILER x86_64-w64-mingw32-windres)' \
    "set(CMAKE_FIND_ROOT_PATH \"$prefix\" \"/usr/x86_64-w64-mingw32\")" \
    "set(CMAKE_PREFIX_PATH \"$prefix\")" \
    'set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)' \
    'set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)' \
    'set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)' \
    'set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)' \
    > "$toolchain"
or die "failed to write CMake toolchain file"

# Pinned source identities recovered from the validated 2026-07-31 build.
set -l lsw_base_commit a47764915f06fcd472e26ba2fbf25aff4b9d252e
set -l lsw_patched_commit 393df5ef669707f776261e4ac1bcc7e9a9a227ab
set -l zlib_commit da607da739fa6047df13e66a2af6b8bec7c2a498
set -l gme_commit fe8da4b6d3876d7542c2fb69d94487e19836d678
set -l dav1d_commit 54706fc6bc0cdecab7e9593974a4039cc038fca7
set -l libvpx_commit ade52487a37ef76a0f209bd39bea9fe67d6db4c4
set -l nvcodec_commit eddcea9e27f6b772057c9b3f87de2cc1737faffc
set -l libvpl_commit 674d015bcb294bc39fa276e99a652ea045423e82
set -l ffmpeg_commit cfa62de001af8ffeb7e22561f246469c7b809951
set -l obuparse_commit c2156b4a133714d0a9c04a7cd341efb1af415a33
set -l lsmash_commit 04315d02fef15a75f747493920724c91a62b8538

clone_commit \
    "L-SMASH Works" \
    "https://github.com/Mr-Ojii/L-SMASH-Works.git" \
    "$lsw_source" \
    "$lsw_base_commit"

note "Applying the hardware-frame-transfer patch"

env \
    GIT_COMMITTER_NAME='alexandergg-0520' \
    GIT_COMMITTER_EMAIL='uket.panda.1st@gmail.com' \
    GIT_COMMITTER_DATE='2026-07-31T03:58:59+09:00' \
    git \
    -C "$lsw_source" \
    -c commit.gpgSign=false \
    am \
    --committer-date-is-author-date \
    "$patch_file"
or die "failed to apply the L-SMASH Works patch"

set -l actual_lsw_commit (git -C "$lsw_source" rev-parse HEAD)
test "$actual_lsw_commit" = "$lsw_patched_commit"
or die "patched L-SMASH Works commit mismatch: expected $lsw_patched_commit, got $actual_lsw_commit"

git -C "$lsw_source" diff --quiet
or die "L-SMASH Works has an unexpected unstaged diff after git am"

git -C "$lsw_source" diff --cached --quiet
or die "L-SMASH Works has an unexpected staged diff after git am"

clone_commit \
    zlib \
    "https://github.com/madler/zlib.git" \
    "$deps_dir/zlib" \
    "$zlib_commit"

clone_commit \
    game-music-emu \
    "https://github.com/libgme/game-music-emu.git" \
    "$deps_dir/game-music-emu" \
    "$gme_commit"

clone_commit \
    dav1d \
    "https://code.videolan.org/videolan/dav1d.git" \
    "$deps_dir/dav1d" \
    "$dav1d_commit"

clone_commit \
    libvpx \
    "https://github.com/webmproject/libvpx.git" \
    "$deps_dir/libvpx" \
    "$libvpx_commit"

clone_commit \
    nv-codec-headers \
    "https://github.com/FFmpeg/nv-codec-headers.git" \
    "$deps_dir/nv-codec-headers" \
    "$nvcodec_commit"

clone_commit \
    libvpl \
    "https://github.com/intel/libvpl.git" \
    "$deps_dir/libvpl" \
    "$libvpl_commit"

clone_commit \
    FFmpeg \
    "https://github.com/FFmpeg/FFmpeg.git" \
    "$deps_dir/FFmpeg" \
    "$ffmpeg_commit"

clone_commit \
    obuparse \
    "https://github.com/dwbuiten/obuparse.git" \
    "$deps_dir/obuparse" \
    "$obuparse_commit"

clone_commit \
    l-smash \
    "https://github.com/Mr-Ojii/l-smash.git" \
    "$deps_dir/l-smash" \
    "$lsmash_commit"

note "Building zlib"
cd "$deps_dir/zlib"
or die "cannot enter zlib source"

env CROSS_PREFIX=x86_64-w64-mingw32- \
    ./configure \
    --static \
    --prefix="$prefix"
or die "zlib configure failed"

make -j "$jobs"
or die "zlib build failed"

make install
or die "zlib install failed"

note "Building game-music-emu (static)"
cd "$deps_dir/game-music-emu"
or die "cannot enter game-music-emu source"

cmake \
    -S . \
    -B build-static \
    -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_TOOLCHAIN_FILE="$toolchain" \
    -DCMAKE_INSTALL_PREFIX="$prefix" \
    -DCMAKE_PREFIX_PATH="$prefix" \
    -DZLIB_ROOT="$prefix" \
    -DZLIB_LIBRARY="$prefix/lib/libz.a" \
    -DZLIB_INCLUDE_DIR="$prefix/include" \
    -DZLIB_USE_STATIC_LIBS=ON \
    -DBUILD_SHARED_LIBS=OFF \
    -DBUILD_TESTING=OFF \
    -DGME_BUILD_SHARED=OFF \
    -DGME_BUILD_STATIC=ON \
    -DGME_BUILD_EXAMPLES=OFF \
    -DGME_BUILD_TESTING=OFF \
    -DGME_ENABLE_UBSAN=OFF \
    -DGME_ENABLE_ASAN=OFF
or die "game-music-emu static configure failed"

cmake --build build-static -j "$jobs"
or die "game-music-emu static build failed"

cmake --install build-static
or die "game-music-emu static install failed"

note "Building game-music-emu (shared metadata/runtime build)"
cmake \
    -S . \
    -B build-shared \
    -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_TOOLCHAIN_FILE="$toolchain" \
    -DCMAKE_INSTALL_PREFIX="$prefix" \
    -DCMAKE_PREFIX_PATH="$prefix" \
    -DZLIB_LIBRARY="$prefix/lib/libz.a" \
    -DZLIB_INCLUDE_DIR="$prefix/include" \
    -DGME_BUILD_SHARED=ON \
    -DGME_BUILD_STATIC=OFF \
    -DGME_BUILD_EXAMPLES=OFF \
    -DGME_BUILD_TESTING=OFF \
    -DGME_ENABLE_UBSAN=OFF \
    -DGME_ENABLE_ASAN=OFF
or die "game-music-emu shared configure failed"

cmake --build build-shared -j "$jobs"
or die "game-music-emu shared build failed"

cmake --install build-shared
or die "game-music-emu shared install failed"

note "Building dav1d"
cd "$deps_dir/dav1d"
or die "cannot enter dav1d source"

meson setup \
    --cross-file=package/crossfiles/x86_64-w64-mingw32.meson \
    --buildtype=release \
    --default-library=static \
    -Denable_tests=false \
    --prefix="$prefix" \
    build-cross
or die "dav1d configure failed"

ninja -C build-cross
or die "dav1d build failed"

ninja -C build-cross install
or die "dav1d install failed"

note "Building libvpx"
mkdir "$deps_dir/libvpx/build-cross"
or die "failed to create libvpx build directory"

cd "$deps_dir/libvpx/build-cross"
or die "cannot enter libvpx build directory"

env CROSS=x86_64-w64-mingw32- \
    ../configure \
    --target=x86_64-win64-gcc \
    --enable-vp9-highbitdepth \
    --disable-docs \
    --disable-tools \
    --disable-examples \
    --disable-webm-io \
    --disable-vp8-encoder \
    --disable-vp9-encoder \
    --prefix="$prefix"
or die "libvpx configure failed"

make -j "$jobs"
or die "libvpx build failed"

make install
or die "libvpx install failed"

note "Installing nv-codec-headers"
cd "$deps_dir/nv-codec-headers"
or die "cannot enter nv-codec-headers source"

make PREFIX="$prefix" install
or die "nv-codec-headers install failed"

note "Building libvpl"
cd "$deps_dir/libvpl"
or die "cannot enter libvpl source"

cmake \
    -S . \
    -B build-cross \
    -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_TOOLCHAIN_FILE="$toolchain" \
    -DCMAKE_INSTALL_PREFIX="$prefix" \
    -DBUILD_EXPERIMENTAL=OFF \
    -DBUILD_SHARED_LIBS=OFF \
    -DCXX_LIB=-lstdc++
or die "libvpl configure failed"

cmake --build build-cross -j "$jobs"
or die "libvpl build failed"

cmake --install build-cross
or die "libvpl install failed"

note "Checking pkg-config dependencies"
for module_name in dav1d vpx libgme vpl
    x86_64-w64-mingw32-pkg-config --modversion "$module_name"
    or die "pkg-config module unavailable: $module_name"
end

note "Building FFmpeg with AV1 CUVID"
cd "$deps_dir/FFmpeg"
or die "cannot enter FFmpeg source"

env \
    PKG_CONFIG_PATH="$prefix/lib/pkgconfig" \
    PKG_CONFIG_LIBDIR="$prefix/lib/pkgconfig" \
    ./configure \
    --enable-version3 \
    --disable-hwaccels \
    --disable-encoders \
    --disable-avisynth \
    --disable-doc \
    --disable-network \
    --disable-programs \
    --disable-outdevs \
    --disable-indevs \
    --disable-avfilter \
    --disable-debug \
    --disable-muxers \
    --enable-avcodec \
    --enable-avformat \
    --enable-swresample \
    --enable-swscale \
    --enable-libdav1d \
    --enable-libvpx \
    --enable-libgme \
    --enable-libvpl \
    --enable-cuvid \
    --enable-decoder=av1_cuvid \
    --pkg-config=x86_64-w64-mingw32-pkg-config \
    --extra-cflags="-I$prefix/include" \
    --extra-ldflags="-L$prefix/lib" \
    --extra-libs=-lpthread \
    --cross-prefix=x86_64-w64-mingw32- \
    --target-os=mingw32 \
    --arch=x86_64 \
    --prefix="$prefix"
or die "FFmpeg configure failed"

grep -q '^#define CONFIG_CUVID 1' config.h
or die "FFmpeg CONFIG_CUVID is not enabled"

grep -q '^#define CONFIG_FFNVCODEC 1' config.h
or die "FFmpeg CONFIG_FFNVCODEC is not enabled"

grep -q '^#define CONFIG_AV1_CUVID_DECODER 1' config.h
or die "FFmpeg CONFIG_AV1_CUVID_DECODER is not enabled"

make -j "$jobs"
or die "FFmpeg build failed"

make install
or die "FFmpeg install failed"

note "Building obuparse"
cd "$deps_dir/obuparse"
or die "cannot enter obuparse source"

make \
    CROSS=x86_64-w64-mingw32- \
    -j "$jobs" \
    libobuparse.a
or die "obuparse build failed"

make \
    CROSS=x86_64-w64-mingw32- \
    PREFIX="$prefix" \
    install-static
or die "obuparse install failed"

note "Building l-smash"
cd "$deps_dir/l-smash"
or die "cannot enter l-smash source"

./configure \
    --cross-prefix=x86_64-w64-mingw32- \
    --target-os=mingw32 \
    --prefix="$prefix" \
    --extra-cflags="-I$prefix/include" \
    --extra-ldflags="-L$prefix/lib"
or die "l-smash configure failed"

make -j "$jobs" lib
or die "l-smash build failed"

make install-lib
or die "l-smash install failed"

note "Building patched L-SMASH Works r1284"
cd "$lsw_source/AviUtl2"
or die "cannot enter L-SMASH Works AviUtl2 source"

env \
    PKG_CONFIG_PATH="$prefix/lib/pkgconfig" \
    PKG_CONFIG_LIBDIR="$prefix/lib/pkgconfig" \
    ./configure \
    --cross-prefix=x86_64-w64-mingw32- \
    --prefix="$prefix" \
    --extra-cflags="-I$prefix/include" \
    --extra-ldflags="-L$prefix/lib -static-libgcc -static-libstdc++ -static" \
    --extra-libs=-lpthread
or die "L-SMASH Works configure failed"

make -j "$jobs" input
or die "L-SMASH Works build failed"

set -l built_aui2 "$lsw_source/AviUtl2/lwinput.aui2"
test -s "$built_aui2"
or die "L-SMASH Works output missing or empty: $built_aui2"

file "$built_aui2" | grep -q 'PE32+ executable'
or die "L-SMASH Works output is not the expected PE32+ binary"

begin
    strings -a -n 5 "$built_aui2"
    strings -a --encoding=l -n 5 "$built_aui2"
end | grep -q 'L-SMASH Works File Reader for AviUtl2 r1284 by Mr-Ojii'
or die "the built plugin does not identify itself as r1284"

strings -a -n 5 "$built_aui2" | grep -q -- '--enable-cuvid'
or die "the built plugin does not contain the expected FFmpeg --enable-cuvid marker"

strings -a -n 5 "$built_aui2" | grep -q -- '--enable-decoder=av1_cuvid'
or die "the built plugin does not contain the expected av1_cuvid configure marker"

cp -a "$built_aui2" "$output_dir/lwinput.aui2"
or die "failed to copy lwinput.aui2 to output"

cp -a "$lsmash_ini" "$output_dir/lsmash.ini"
or die "failed to copy lsmash.ini to output"

set -l output_sha256 (sha256sum "$output_dir/lwinput.aui2" | string split ' ')[1]
set -l output_size (stat -c '%s' "$output_dir/lwinput.aui2")
set -l reference_sha256 fce81e0257a6730ada0729ffddfdb51d1528f8b4bdfb61488a7d01b074ab0fc3
set -l reference_size 26945536
set -l reference_xxh3 87dcdf17b419392c8172b843ab26e0a9

begin
    echo "L-SMASH Works NVDEC build provenance"
    echo "generated_at="(date --iso-8601=seconds)
    echo "work_dir=$work_dir"
    echo "prefix=$prefix"
    echo "jobs=$jobs"
    echo
    echo "source_commits:"
    echo "L-SMASH-Works=$lsw_patched_commit"
    echo "zlib=$zlib_commit"
    echo "game-music-emu=$gme_commit"
    echo "dav1d=$dav1d_commit"
    echo "libvpx=$libvpx_commit"
    echo "nv-codec-headers=$nvcodec_commit"
    echo "libvpl=$libvpl_commit"
    echo "FFmpeg=$ffmpeg_commit"
    echo "obuparse=$obuparse_commit"
    echo "l-smash=$lsmash_commit"
    echo
    echo "artifact:"
    echo "size=$output_size"
    echo "sha256=$output_sha256"
    echo "reference_size=$reference_size"
    echo "reference_sha256=$reference_sha256"
    echo "reference_xxh3_128=$reference_xxh3"
    echo
    echo "tool_versions:"
    x86_64-w64-mingw32-gcc --version | head -n 1
    cmake --version | head -n 1
    meson --version
    ninja --version
    nasm -v
    make --version | head -n 1
    pkg-config --version
end > "$output_dir/PROVENANCE.txt"
or die "failed to write provenance file"

sha256sum \
    "$output_dir/lwinput.aui2" \
    "$output_dir/lsmash.ini" \
    > "$output_dir/SHA256SUMS"
or die "failed to write SHA256SUMS"

note "Build completed"
echo "Output directory: $output_dir"
echo "lwinput.aui2 size: $output_size"
echo "lwinput.aui2 SHA-256: $output_sha256"
echo "Reference size: $reference_size"
echo "Reference SHA-256: $reference_sha256"
echo

if test "$output_sha256" = "$reference_sha256"
    echo "RESULT: byte-for-byte match with the original validated artifact"
else
    echo "RESULT: not a byte-for-byte match with the original artifact"
    echo "This is expected when the absolute build prefix or toolchain version differs."
    echo "The script already verified the pinned source commit, r1284 identity,"
    echo "and embedded AV1 CUVID configuration. Runtime validation is still required."
end

echo
echo "The plugin has NOT been installed into any Wine prefix."
echo "Pause Mr-Ojii.L-SMASH-Works in AviUtl2 Catalog before installing it."

```

# Appendix B — 実行されたL-SMASH Works install helperの完全本文

`S245-16`で実際に起動された `scripts/install-l-smash-works-nvdec.fish` の保存済み本文。

```fish
#!/usr/bin/env fish

# Install a validated patched L-SMASH Works r1284 artifact into an existing
# AviUtl2 Wine prefix while protecting it from AviUtl2 Catalog bulk updates.
#
# This script intentionally does NOT modify installed.json or hash-cache.json.

set -g SCRIPT_NAME (basename (status filename))

function usage
    echo "Usage: $SCRIPT_NAME --prefix PATH --artifact-dir PATH [--windows-user NAME]"
    echo
    echo "Required:"
    echo "  --prefix       Existing Wine/Proton prefix"
    echo "  --artifact-dir Directory containing lwinput.aui2 and lsmash.ini"
    echo
    echo "Default:"
    echo "  --windows-user steamuser"
end

function die
    echo "ERROR: $argv" >&2
    exit 1
end

function note
    echo
    echo "==> $argv"
end

function file_sha_or_missing
    set -l path $argv[1]
    if test -f "$path"
        sha256sum "$path" | string split ' ' | head -n 1
    else
        echo MISSING
    end
end

argparse \
    'h/help' \
    'p/prefix=' \
    'a/artifact-dir=' \
    'u/windows-user=' \
    -- $argv
or begin
    usage >&2
    exit 2
end

if set -q _flag_help
    usage
    exit 0
end

set -q _flag_prefix
or die "--prefix is required"

set -q _flag_artifact_dir
or die "--artifact-dir is required"

set -l prefix (string replace -r '/+$' '' -- (string trim -- "$_flag_prefix"))
set -l artifact_dir (string replace -r '/+$' '' -- (string trim -- "$_flag_artifact_dir"))
set -l windows_user steamuser

if set -q _flag_windows_user
    set windows_user (string trim -- "$_flag_windows_user")
end

test -n "$prefix"
or die "--prefix must not be empty"

test -n "$artifact_dir"
or die "--artifact-dir must not be empty"

test -n "$windows_user"
or die "--windows-user must not be empty"

for command_name in \
    python3 \
    sha256sum \
    strings \
    grep \
    cp \
    mkdir \
    date \
    pgrep \
    cmp \
    head

    command -q "$command_name"
    or die "required command not found: $command_name"
end

set -l plugin_dir "$prefix/drive_c/ProgramData/aviutl2/Plugin"
set -l roaming "$prefix/drive_c/users/$windows_user/AppData/Roaming/aviutl2-catalog"
set -l settings "$roaming/settings.json"
set -l installed "$roaming/installed.json"
set -l hash_cache "$roaming/hash-cache.json"
set -l built_aui2 "$artifact_dir/lwinput.aui2"
set -l built_ini "$artifact_dir/lsmash.ini"
set -l active_aui2 "$plugin_dir/lwinput.aui2"
set -l active_ini "$plugin_dir/lsmash.ini"
set -l package_id 'Mr-Ojii.L-SMASH-Works'

for required_path in \
    "$prefix/drive_c" \
    "$plugin_dir" \
    "$settings" \
    "$built_aui2" \
    "$built_ini"

    test -e "$required_path"
    or die "required path not found: $required_path"
end

# Do not race AviUtl2 or Catalog while replacing their files/settings.
if pgrep -af 'AviUtl2_Catalog\.exe|aviutl2\.exe' >/dev/null 2>&1
    pgrep -af 'AviUtl2_Catalog\.exe|aviutl2\.exe' >&2
    die "AviUtl2 or AviUtl2 Catalog appears to be running; close it first"
end

# Artifact validation. SHA-256 is intentionally not required to equal the
# original Alex build because the absolute build prefix is embedded in FFmpeg.
begin
    strings -a -n 5 "$built_aui2"
    strings -a --encoding=l -n 5 "$built_aui2"
end | grep -q 'L-SMASH Works File Reader for AviUtl2 r1284 by Mr-Ojii'
or die "artifact does not identify itself as L-SMASH Works r1284"

strings -a -n 5 "$built_aui2" | grep -q -- '--enable-cuvid'
or die "artifact lacks the FFmpeg --enable-cuvid marker"

strings -a -n 5 "$built_aui2" | grep -q -- '--enable-decoder=av1_cuvid'
or die "artifact lacks the FFmpeg av1_cuvid marker"

grep -qx 'libavsmash_disabled=1' "$built_ini"
or die "lsmash.ini must contain libavsmash_disabled=1"

grep -qx 'libav_disabled=0' "$built_ini"
or die "lsmash.ini must contain libav_disabled=0"

grep -qx 'preferred_decoders=av1_cuvid' "$built_ini"
or die "lsmash.ini must contain preferred_decoders=av1_cuvid"

set -l installed_before (file_sha_or_missing "$installed")
set -l hash_cache_before (file_sha_or_missing "$hash_cache")
set -l stamp (date +%Y%m%d-%H%M%S)

note "Creating backups"
cp -a "$settings" "$settings.before-lsmash-nvdec-$stamp"
or die "failed to back up Catalog settings"

if test -f "$active_aui2"
    cp -a "$active_aui2" "$active_aui2.before-lsmash-nvdec-$stamp"
    or die "failed to back up the existing lwinput.aui2"
end

if test -f "$active_ini"
    cp -a "$active_ini" "$active_ini.before-lsmash-nvdec-$stamp"
    or die "failed to back up the existing lsmash.ini"
end

note "Pausing the Catalog package before replacing the plugin"
python3 -c '
import json
import os
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
package_id = sys.argv[2]

data = json.loads(path.read_text(encoding="utf-8-sig"))
raw = data.get("package_updates_paused_ids", [])
if not isinstance(raw, list):
    raise SystemExit("package_updates_paused_ids is not a JSON array")

ids = sorted({str(value).strip() for value in raw if str(value).strip()})
if package_id not in ids:
    ids.append(package_id)
    ids.sort()

data["package_updates_paused_ids"] = ids

temporary = path.with_name(path.name + ".tmp-lsmash-nvdec")
temporary.write_text(
    json.dumps(data, ensure_ascii=False, indent=2) + "\n",
    encoding="utf-8",
)
os.replace(temporary, path)
' "$settings" "$package_id"
or die "failed to update Catalog package_updates_paused_ids"

python3 -c '
import json
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
package_id = sys.argv[2]
data = json.loads(path.read_text(encoding="utf-8-sig"))
ids = data.get("package_updates_paused_ids", [])
if package_id not in ids:
    raise SystemExit(f"pause verification failed: {package_id}")
print(f"paused: {package_id}")
' "$settings" "$package_id"
or die "Catalog pause verification failed"

note "Installing patched L-SMASH Works r1284"
mkdir -p "$plugin_dir"
or die "failed to create plugin directory"

cp -f "$built_aui2" "$active_aui2"
or die "failed to install lwinput.aui2"

cp -f "$built_ini" "$active_ini"
or die "failed to install lsmash.ini"

cmp -s "$built_aui2" "$active_aui2"
or die "installed lwinput.aui2 differs from the artifact"

cmp -s "$built_ini" "$active_ini"
or die "installed lsmash.ini differs from the artifact"

set -l installed_after (file_sha_or_missing "$installed")
set -l hash_cache_after (file_sha_or_missing "$hash_cache")

test "$installed_after" = "$installed_before"
or die "installed.json changed unexpectedly"

test "$hash_cache_after" = "$hash_cache_before"
or die "hash-cache.json changed unexpectedly"

set -l active_sha256 (sha256sum "$active_aui2" | string split ' ')[1]

note "Installation completed"
echo "Active plugin: $active_aui2"
echo "SHA-256: $active_sha256"
echo "Catalog pause ID: $package_id"
echo "installed.json: unchanged ($installed_after)"
echo "hash-cache.json: unchanged ($hash_cache_after)"
echo
echo "Do not use Update, Reinstall, Remove, or initial setup for L-SMASH Works."
echo "Catalog will detect the custom file as installed version '不明'; this is expected."

```

# Appendix C — 実行確認不能のrestore helper本文

`restore-known-good-aviutl2.fish` は保存されているが、この台帳の証拠範囲ではscript自体を直接実行した終了出力を断定できない。したがって本文を保存するが成功手順へは昇格しない。

```fish
#!/usr/bin/env fish

# Restore the known-good AviUtl2 prefix and patched GE-Proton runner saved
# before the failed REPRODUCTION.md procedure replaced the active environment.
#
# Default: read-only audit
# Apply:   restore-known-good-aviutl2.fish --apply

function fail
    echo "ERROR: $argv" >&2
    exit 1
end

set MODE audit

if test (count $argv) -gt 1
    fail "usage: "(status filename)" [--apply]"
end

if test (count $argv) -eq 1
    switch "$argv[1]"
        case --apply
            set MODE apply
        case '*'
            fail "usage: "(status filename)" [--apply]"
    end
end

set ROOT \
    "$HOME/Games/aviutl2"

set ACTIVE_PREFIX \
    "$ROOT/prefix-ge-nvdec-test"

set SOURCE_PREFIX \
    "$ROOT/prefix-ge-nvdec-test.backup-20260731-135410"

set GE_PARENT \
    "$HOME/.local/share/Steam/compatibilitytools.d"

set ACTIVE_GE \
    "$GE_PARENT/GE-Proton11-1-aviutl2-test"

set SOURCE_GE \
    "$GE_PARENT/GE-Proton11-1-aviutl2-test.backup-20260731-135348"

set REPO \
    "$HOME/projects/aviutl2-linux-patches"

set EXPECTED_PLUGIN_SHA256 \
    "db465570a4c049624f369086232cf47c387975d54fa615d895d090fe1a17bbe0"

function section
    echo
    echo "============================================================"
    echo "$argv"
    echo "============================================================"
end

function find_catalog
    set prefix "$argv[1]"

    find \
        "$prefix/drive_c" \
        -type f \
        -iname 'AviUtl2_Catalog.exe' \
        -print \
        -quit \
        2>/dev/null
end

function check_prefix
    set prefix "$argv[1]"

    for path in \
        "$prefix/user.reg" \
        "$prefix/system.reg" \
        "$prefix/userdef.reg" \
        "$prefix/drive_c/windows/system32" \
        "$prefix/drive_c/AviUtl2/aviutl2.exe" \
        "$prefix/drive_c/ProgramData/aviutl2"

        if not test -e "$path"
            echo "INCOMPLETE PREFIX: missing $path" >&2
            return 1
        end
    end

    set catalog_exe \
        (find_catalog "$prefix")

    if test (count $catalog_exe) -eq 0
        echo "INCOMPLETE PREFIX: Catalog executable was not found under $prefix/drive_c" >&2
        return 1
    end

    if not test -f "$catalog_exe"
        echo "INCOMPLETE PREFIX: Catalog executable is not a regular file: $catalog_exe" >&2
        return 1
    end

    echo "Catalog executable: $catalog_exe"

    set plugin \
        "$prefix/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2"

    if not test -f "$plugin"
        echo "INCOMPLETE PREFIX: L-SMASH Works plugin is missing: $plugin" >&2
        return 1
    end

    set plugin_sha \
        (sha256sum "$plugin" | string split ' ')[1]

    echo "Plugin SHA-256: $plugin_sha"
    return 0
end

function check_ge
    set ge "$argv[1]"

    for path in \
        "$ge/files/lib/wine/x86_64-unix/wine" \
        "$ge/files/bin/wineserver" \
        "$ge/files/lib/wine/x86_64-windows/dwrite.dll" \
        "$ge/files/lib/wine/x86_64-unix/dwrite.so"

        if not test -e "$path"
            echo "INCOMPLETE GE-PROTON: missing $path" >&2
            return 1
        end
    end

    if not test -x "$ge/files/lib/wine/x86_64-unix/wine"
        echo "INCOMPLETE GE-PROTON: Wine is not executable" >&2
        return 1
    end

    if not test -x "$ge/files/bin/wineserver"
        echo "INCOMPLETE GE-PROTON: wineserver is not executable" >&2
        return 1
    end

    return 0
end

function compare_file
    set source "$argv[1]"
    set copy "$argv[2]"

    cmp \
        --silent \
        "$source" \
        "$copy"
end

section "1. KNOWN-GOOD SOURCE PREFLIGHT"

test -d "$SOURCE_PREFIX"
or fail "known-good prefix backup is missing: $SOURCE_PREFIX"

test -d "$SOURCE_GE"
or fail "known-good GE-Proton backup is missing: $SOURCE_GE"

check_prefix "$SOURCE_PREFIX"
or fail "known-good prefix backup failed preflight"

check_ge "$SOURCE_GE"
or fail "known-good GE-Proton backup failed preflight"

set source_plugin_sha \
    (sha256sum "$SOURCE_PREFIX/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2" | string split ' ')[1]

test "$source_plugin_sha" = "$EXPECTED_PLUGIN_SHA256"
or fail "known-good prefix backup does not contain the expected rebuilt r1284 plugin"

section "2. ACTIVE TARGET AUDIT"

echo "Active prefix: $ACTIVE_PREFIX"

if test -d "$ACTIVE_PREFIX"
    for path in \
        "$ACTIVE_PREFIX/user.reg" \
        "$ACTIVE_PREFIX/system.reg" \
        "$ACTIVE_PREFIX/userdef.reg" \
        "$ACTIVE_PREFIX/drive_c/windows/system32" \
        "$ACTIVE_PREFIX/drive_c/AviUtl2/aviutl2.exe"

        if test -e "$path"
            echo "PRESENT: $path"
        else
            echo "MISSING: $path"
        end
    end
else
    echo "MISSING ACTIVE PREFIX"
end

echo
echo "Active GE-Proton: $ACTIVE_GE"

if test -d "$ACTIVE_GE"
    for path in \
        "$ACTIVE_GE/files/lib/wine/x86_64-unix/wine" \
        "$ACTIVE_GE/files/bin/wineserver" \
        "$ACTIVE_GE/files/lib/wine/x86_64-windows/dwrite.dll" \
        "$ACTIVE_GE/files/lib/wine/x86_64-unix/dwrite.so"

        if test -e "$path"
            echo "PRESENT: $path"
        else
            echo "MISSING: $path"
        end
    end
else
    echo "MISSING ACTIVE GE-PROTON"
end

if test "$MODE" = audit
    section "AUDIT COMPLETE"

    echo "No files were modified."
    echo
    echo "To restore the known-good prefix and runner, run:"
    echo "  "(status filename)" --apply"
    exit 0
end

section "3. STOP PREFIX"

set SOURCE_WINESERVER \
    "$SOURCE_GE/files/bin/wineserver"

set SOURCE_GE_LIBS \
    "$SOURCE_GE/files/lib64:$SOURCE_GE/files/lib:$SOURCE_GE/files/lib/wine/x86_64-unix:$SOURCE_GE/files/lib/wine/i386-unix"

env \
    WINEPREFIX="$ACTIVE_PREFIX" \
    LD_LIBRARY_PATH="$SOURCE_GE_LIBS" \
    "$SOURCE_WINESERVER" \
    -k \
    2>/dev/null

or true

env \
    WINEPREFIX="$ACTIVE_PREFIX" \
    LD_LIBRARY_PATH="$SOURCE_GE_LIBS" \
    "$SOURCE_WINESERVER" \
    -w \
    2>/dev/null

or true

sleep 1

section "4. CREATE VERIFIED STAGING COPIES"

set STAMP \
    (date +%Y%m%d-%H%M%S)

set PREFIX_STAGE \
    "$ROOT/.prefix-ge-nvdec-test.restore-$STAMP"

set PREFIX_BROKEN \
    "$ROOT/prefix-ge-nvdec-test.broken-$STAMP"

set PREFIX_FAILED \
    "$ROOT/prefix-ge-nvdec-test.failed-restore-$STAMP"

set GE_STAGE \
    "$GE_PARENT/.GE-Proton11-1-aviutl2-test.restore-$STAMP"

set GE_BROKEN \
    "$GE_PARENT/GE-Proton11-1-aviutl2-test.broken-$STAMP"

set GE_FAILED \
    "$GE_PARENT/GE-Proton11-1-aviutl2-test.failed-restore-$STAMP"

for path in \
    "$PREFIX_STAGE" \
    "$PREFIX_BROKEN" \
    "$PREFIX_FAILED" \
    "$GE_STAGE" \
    "$GE_BROKEN" \
    "$GE_FAILED"

    test ! -e "$path"
    or fail "transaction path already exists: $path"
end

cp -a \
    --reflink=auto \
    "$SOURCE_PREFIX" \
    "$PREFIX_STAGE"

or fail "failed to create prefix staging copy"

cp -a \
    --reflink=auto \
    "$SOURCE_GE" \
    "$GE_STAGE"

or fail "failed to create GE-Proton staging copy"

check_prefix "$PREFIX_STAGE"
or fail "prefix staging copy failed verification"

check_ge "$GE_STAGE"
or fail "GE-Proton staging copy failed verification"

for registry in \
    user.reg \
    system.reg \
    userdef.reg

    compare_file \
        "$SOURCE_PREFIX/$registry" \
        "$PREFIX_STAGE/$registry"
end

compare_file \
    "$SOURCE_PREFIX/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2" \
    "$PREFIX_STAGE/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2"

for relative in \
    files/lib/wine/x86_64-unix/wine \
    files/bin/wineserver \
    files/lib/wine/x86_64-windows/dwrite.dll \
    files/lib/wine/x86_64-unix/dwrite.so

    compare_file \
        "$SOURCE_GE/$relative" \
        "$GE_STAGE/$relative"
end

section "5. SWITCH ACTIVE ENVIRONMENT"

set HAD_ACTIVE_PREFIX 0
set HAD_ACTIVE_GE 0

if test -e "$ACTIVE_GE"
    mv \
        "$ACTIVE_GE" \
        "$GE_BROKEN"

    or fail "failed to preserve the current GE-Proton tree"

    set HAD_ACTIVE_GE 1
end

mv \
    "$GE_STAGE" \
    "$ACTIVE_GE"

or begin
    if test "$HAD_ACTIVE_GE" = 1
        and not test -e "$ACTIVE_GE"

        mv \
            "$GE_BROKEN" \
            "$ACTIVE_GE"

        and echo "Rolled back the original GE-Proton tree." >&2
    end

    fail "failed to promote the restored GE-Proton tree"
end

if test -e "$ACTIVE_PREFIX"
    mv \
        "$ACTIVE_PREFIX" \
        "$PREFIX_BROKEN"

    or begin
        mv \
            "$ACTIVE_GE" \
            "$GE_FAILED"

        if test "$HAD_ACTIVE_GE" = 1
            mv \
                "$GE_BROKEN" \
                "$ACTIVE_GE"
        end

        fail "failed to preserve the current prefix; GE-Proton was rolled back"
    end

    set HAD_ACTIVE_PREFIX 1
end

mv \
    "$PREFIX_STAGE" \
    "$ACTIVE_PREFIX"

or begin
    if test "$HAD_ACTIVE_PREFIX" = 1
        and not test -e "$ACTIVE_PREFIX"

        mv \
            "$PREFIX_BROKEN" \
            "$ACTIVE_PREFIX"
    end

    mv \
        "$ACTIVE_GE" \
        "$GE_FAILED"

    if test "$HAD_ACTIVE_GE" = 1
        mv \
            "$GE_BROKEN" \
            "$ACTIVE_GE"
    end

    fail "failed to promote the restored prefix; original environment was restored"
end

section "6. VERIFY PROMOTED ENVIRONMENT"

set VERIFY_FAILED 0

check_ge "$ACTIVE_GE"
or set VERIFY_FAILED 1

check_prefix "$ACTIVE_PREFIX"
or set VERIFY_FAILED 1

if test "$VERIFY_FAILED" = 1
    echo "ERROR: promoted environment failed verification; starting rollback" >&2

    if test -e "$ACTIVE_PREFIX"
        mv \
            "$ACTIVE_PREFIX" \
            "$PREFIX_FAILED"
    end

    if test "$HAD_ACTIVE_PREFIX" = 1
        and test -e "$PREFIX_BROKEN"

        mv \
            "$PREFIX_BROKEN" \
            "$ACTIVE_PREFIX"
    end

    if test -e "$ACTIVE_GE"
        mv \
            "$ACTIVE_GE" \
            "$GE_FAILED"
    end

    if test "$HAD_ACTIVE_GE" = 1
        and test -e "$GE_BROKEN"

        mv \
            "$GE_BROKEN" \
            "$ACTIVE_GE"
    end

    fail "restored environment failed final verification and was rolled back"
end

section "7. FINAL IDENTITY"

sha256sum \
    "$ACTIVE_PREFIX/drive_c/AviUtl2/aviutl2.exe" \
    "$ACTIVE_PREFIX/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2" \
    "$ACTIVE_GE/files/lib/wine/x86_64-windows/dwrite.dll" \
    "$ACTIVE_GE/files/lib/wine/x86_64-unix/dwrite.so"

begin
    strings \
        -a \
        -n 6 \
        "$ACTIVE_PREFIX/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2"

    strings \
        -a \
        -e l \
        -n 6 \
        "$ACTIVE_PREFIX/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2"
end \
    | grep \
        -E \
        'L-SMASH Works File Reader for AviUtl2 r1284 by Mr-Ojii|av1_cuvid' \
    | sort \
        -u

section "RESTORE COMPLETE"

echo "Restored active prefix:"
echo "  $ACTIVE_PREFIX"
echo
echo "Restored active GE-Proton:"
echo "  $ACTIVE_GE"

if test "$HAD_ACTIVE_PREFIX" = 1
    echo
    echo "Preserved previous prefix:"
    echo "  $PREFIX_BROKEN"
end

if test "$HAD_ACTIVE_GE" = 1
    echo
    echo "Preserved previous GE-Proton:"
    echo "  $GE_BROKEN"
end

echo
echo "Next, inspect Catalog status:"
echo "  $REPO/scripts/manage-aviutl2-catalog-lutris.sh status"
echo
echo "Then launch Catalog:"
echo "  $REPO/scripts/manage-aviutl2-catalog-lutris.sh launch"

```

