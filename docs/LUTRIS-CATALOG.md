# Lutris / AviUtl2 Catalog

最終更新日: 2026-07-31

## 方針

Lutris の Wine Runner に Wine、Proton、DXVK の選択を任せない。
Linux Runner から固定管理スクリプトを起動する。

管理スクリプト:

```text
scripts/manage-aviutl2-catalog-lutris.sh
```

## スクリプトの既定値

```text
AVIUTL2_ROOT=$HOME/Games/aviutl2
AVIUTL2_PREFIX=$AVIUTL2_ROOT/prefix-ge-nvdec-test
GE_PROTON_ROOT=$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test
GE_WINE=$GE_PROTON_ROOT/files/lib/wine/x86_64-unix/wine
GE_WINESERVER=$GE_PROTON_ROOT/files/bin/wineserver
DXVK_CONFIG_FILE=$AVIUTL2_ROOT/nvidia-dxvk.conf
```

Wine の入口は、実際のスクリプトと同じ `files/lib/wine/x86_64-unix/wine` を使用する。

## 初回導入

```fish
scripts/manage-aviutl2-catalog-lutris.sh \
    lutris-install
```

このコマンドは、ローカル Lutris installer YAML を生成し、既存の patched prefix へ Catalog を導入する。

## Catalog の初期設定

```text
AviUtl2:
  インストール済み

AviUtl2 root:
  C:\AviUtl2

Portable mode:
  無効
```

非ポータブル構成:

```text
C:\ProgramData\aviutl2\Plugin
C:\ProgramData\aviutl2\Script
```

Portable mode を有効にしない。
有効にすると `C:\AviUtl2\data` が管理対象になり、現在の構成と分離する。

## コマンド

状態確認:

```fish
scripts/manage-aviutl2-catalog-lutris.sh status
```

起動:

```fish
scripts/manage-aviutl2-catalog-lutris.sh launch
```

更新または再インストール:

```fish
scripts/manage-aviutl2-catalog-lutris.sh update
```

バックアップ:

```fish
scripts/manage-aviutl2-catalog-lutris.sh backup
```

URL handler 再登録:

```fish
scripts/manage-aviutl2-catalog-lutris.sh \
    register-url-handler
```

## Deep Link

```text
aviutl2-catalog://
aviutl2-catalog://updates
aviutl2-catalog://package/<package-id>
aviutl2-catalog://package/<package-id>?install=true
```

## L-SMASH Works を上書きしない

現在の `lwinput.aui2` は NVDEC hardware frame transfer を追加したカスタムビルドである。
Catalog から通常版 L-SMASH Works を更新すると、カスタム版が上書きされる。

復旧:

```fish
set PLUGIN_DIR \
    "$PREFIX/drive_c/ProgramData/aviutl2/Plugin"

cp \
    "$LSW_SRC/AviUtl2/lwinput.aui2" \
    "$PLUGIN_DIR/lwinput.aui2"

cp \
    "$REPO/config/lsmash.ini" \
    "$PLUGIN_DIR/lsmash.ini"
```

復旧後に確認する。

- AV1 読み込み
- 再生
- シーク
- `av1_cuvid`

Catalog 側で停止できる場合は、L-SMASH Works の更新を停止する。

## Catalog が管理しないもの

- patched GE-Proton
- patched Wine DirectWrite
- custom DXVK
- custom L-SMASH Works build

Catalog は、通常の AviUtl2 プラグインとスクリプトの検索・導入・更新に使用する。
