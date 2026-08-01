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
