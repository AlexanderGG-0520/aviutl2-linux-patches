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
