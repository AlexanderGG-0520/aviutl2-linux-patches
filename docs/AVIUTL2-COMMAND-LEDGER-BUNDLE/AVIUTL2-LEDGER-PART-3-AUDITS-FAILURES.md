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
