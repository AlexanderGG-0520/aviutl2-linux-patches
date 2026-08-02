# Lutris / AviUtl2 / AviUtl2 Catalog

最終更新: 2026-08-02

## 目的

Section 13で動作確認したAviUtl2環境を、そのままLutrisへ登録する。
LutrisにはWine、GE-Proton、DXVK、prefixの選択を任せない。

```text
Lutris Linux Runner
  -> ローカル固定wrapper
    -> scripts/launch-aviutl2.fish
      -> 検証済みprefix
      -> patched GE-Proton 11-1
      -> custom DXVK設定
```

AviUtl2 Catalogも固定wrapperから
`scripts/manage-aviutl2-catalog-lutris.sh`を起動する。

検証状態:

- Nanashi環境でSection 13診断起動、日本語入力、変換、確定まで成功済み
- `$ROOT/prefix`を推測して固定した旧wrapperは`prefix not found`で失敗
- 本文では成功した診断ログの`AVIUTL2_EXE`から実際のprefixを復元する
- Lutris登録後はwrapper単体とLutris経由の両方で同じGUI検証を行う

## 前提

先にSection 13を完了し、次を確認していること。

- clean buildしたpatched `dwrite.dll`をrunnerへ導入した
- 診断起動でAviUtl2が表示された
- text objectを編集できた
- Mozcで日本語入力・変換・確定できた
- `HitTestTextPosition()`の`HRESULT 0x80004005`でクラッシュしない

Lutris登録は、動作済み環境への入口を追加する作業である。
未検証のprefixやrunnerをLutris側で新規作成しない。

## 1. 必要パッケージ

CachyOS / Arch Linux:

```fish
sudo pacman -S --needed \
    lutris \
    fish \
    python \
    xdg-utils \
    desktop-file-utils
```

Catalogのrelease取得も行う場合:

```fish
sudo pacman -S --needed \
    github-cli
```

## 2. 基本pathとpatched DWriteの検証

```fish
set ROOT \
    "$HOME/Games/aviutl2"

set REPO \
    "$HOME/projects/aviutl2-linux-patches"

set GE_PROTON_ROOT \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

set DXVK_CONFIG_FILE \
    "$ROOT/nvidia-dxvk.conf"

set DWRITE_CLEAN_WORK \
    "$ROOT/build/dwrite-clean"

set BUILT_DWRITE \
    "$DWRITE_CLEAN_WORK/build/dlls/dwrite/x86_64-windows/dwrite.dll"

set GE_DWRITE \
    "$GE_PROTON_ROOT/files/lib/wine/x86_64-windows/dwrite.dll"

set LUTRIS_WRAPPER_DIR \
    "$ROOT/lutris"

mkdir -p \
    "$LUTRIS_WRAPPER_DIR"
```

runnerのdirectory名だけではpatched DWriteの導入済み判定を行わない。

```fish
for path in \
    "$REPO/scripts/launch-aviutl2.fish" \
    "$REPO/scripts/manage-aviutl2-catalog-lutris.sh" \
    "$GE_PROTON_ROOT" \
    "$DXVK_CONFIG_FILE" \
    "$BUILT_DWRITE" \
    "$GE_DWRITE"

    test -e "$path"
    or begin
        echo "ERROR: missing prerequisite: $path" >&2
        return 1
    end
end

cmp \
    --silent \
    "$BUILT_DWRITE" \
    "$GE_DWRITE"

or begin
    echo "ERROR: runner does not contain the verified patched dwrite.dll" >&2

    sha256sum \
        "$BUILT_DWRITE" \
        "$GE_DWRITE"

    return 1
end

sha256sum \
    "$BUILT_DWRITE" \
    "$GE_DWRITE"
```

## 3. 実際に成功したprefixを特定する

prefix名を推測しない。
Section 13の診断ログには、実行に使用したAviUtl2 executableの絶対pathが
`AVIUTL2_EXE=`として記録されている。

```fish
set LATEST_LOG \
    (find "$ROOT/logs" \
        -maxdepth 1 \
        -type f \
        -name 'aviutl2-section13-*.log' \
        -printf '%T@ %p\n' \
        | sort -nr \
        | head -n 1 \
        | cut -d' ' -f2-)

if test -z "$LATEST_LOG"; or not test -s "$LATEST_LOG"
    echo "ERROR: Section 13 diagnostic log was not found" >&2
    return 1
end

set AVIUTL2_EXE \
    (grep -m1 '^AVIUTL2_EXE=' "$LATEST_LOG" \
        | string replace 'AVIUTL2_EXE=' '')

set PREFIX \
    (string replace \
        -r '/drive_c/AviUtl2/aviutl2\.exe$' \
        '' \
        "$AVIUTL2_EXE")

printf '%s\n' \
    "LATEST_LOG=$LATEST_LOG" \
    "PREFIX=$PREFIX" \
    "AVIUTL2_EXE=$AVIUTL2_EXE"
```

復元結果を検証する。

```fish
for path in \
    "$PREFIX/user.reg" \
    "$PREFIX/system.reg" \
    "$PREFIX/drive_c/AviUtl2/aviutl2.exe"

    test -e "$path"
    and echo "OK: $path"
    or begin
        echo "ERROR: recovered prefix is invalid: $path" >&2
        return 1
    end
end
```

`$ROOT/prefix`や`$ROOT/prefix-ge-nvdec-test`を、実体確認なしでwrapperへ書かない。

## 4. AviUtl2用wrapperを生成する

検証した絶対pathを1行の`exec`へ固定する。

```fish
set AVIUTL2_LUTRIS_WRAPPER \
    "$LUTRIS_WRAPPER_DIR/launch-aviutl2.fish"

set LAUNCH_SCRIPT_Q \
    (string escape -- "$REPO/scripts/launch-aviutl2.fish")

set PREFIX_Q \
    (string escape -- "$PREFIX")

set GE_PROTON_ROOT_Q \
    (string escape -- "$GE_PROTON_ROOT")

set DXVK_CONFIG_FILE_Q \
    (string escape -- "$DXVK_CONFIG_FILE")

printf '%s\n' \
    '#!/usr/bin/env fish' \
    '' \
    "exec fish $LAUNCH_SCRIPT_Q --prefix $PREFIX_Q --ge-proton-root $GE_PROTON_ROOT_Q --dxvk-config $DXVK_CONFIG_FILE_Q" \
    > "$AVIUTL2_LUTRIS_WRAPPER"

chmod +x \
    "$AVIUTL2_LUTRIS_WRAPPER"

fish -n \
    "$AVIUTL2_LUTRIS_WRAPPER"

cat \
    "$AVIUTL2_LUTRIS_WRAPPER"
```

生成されるwrapper:

```fish
#!/usr/bin/env fish

exec fish /absolute/path/to/scripts/launch-aviutl2.fish --prefix /absolute/path/to/the/verified/prefix --ge-proton-root /absolute/path/to/GE-Proton11-1 --dxvk-config /absolute/path/to/nvidia-dxvk.conf
```

新しいFish wrapperの検証後、古い誤ったwrapperを削除する。

```fish
rm -f \
    "$LUTRIS_WRAPPER_DIR/launch-aviutl2.sh"
```

## 5. wrapper単体を検証する

Lutrisへ登録する前にterminalから実行する。

```fish
"$AVIUTL2_LUTRIS_WRAPPER"
```

次を確認してAviUtl2を閉じる。

- AviUtl2が起動する
- text objectを開ける
- Mozcで日本語入力・変換・確定できる
- caret移動や再編集でクラッシュしない

この検証に失敗したwrapperをLutrisへ登録しない。

## 6. AviUtl2をLutrisへ登録する

```fish
lutris
```

左上の`+`から`Add locally installed game`を選ぶ。

### Game info

```text
Name: AviUtl2
Runner: Linux
```

Wine Runnerは選択しない。

### Game options

Nanashi環境の標準例:

```text
Executable:
/home/nanashi/Games/aviutl2/lutris/launch-aviutl2.fish

Arguments:
空欄

Working directory:
/home/nanashi/Games/aviutl2
```

### System options

```text
Disable Lutris Runtime: enabled
```

保存後、Lutrisの`Play`から起動し、Section 5と同じGUI操作を確認する。

## 7. AviUtl2 Catalog用wrapperを生成する

Catalog管理scriptには旧検証環境向けの既定値が残っている。
現在のprefixとrunnerを環境変数で固定するwrapperを使用する。

```fish
set CATALOG_LUTRIS_WRAPPER \
    "$LUTRIS_WRAPPER_DIR/manage-catalog.sh"

set GE_WINE \
    "$GE_PROTON_ROOT/files/bin/wine"

if not test -x "$GE_WINE"
    set GE_WINE \
        "$GE_PROTON_ROOT/files/lib/wine/x86_64-unix/wine"
end

set GE_WINESERVER \
    "$GE_PROTON_ROOT/files/bin/wineserver"

set GE_LIBS \
    "$GE_PROTON_ROOT/files/lib/x86_64-linux-gnu:$GE_PROTON_ROOT/files/lib/i386-linux-gnu"

set ROOT_Q \
    (string escape -- "$ROOT")

set PREFIX_Q \
    (string escape -- "$PREFIX")

set GE_PROTON_ROOT_Q \
    (string escape -- "$GE_PROTON_ROOT")

set GE_WINE_Q \
    (string escape -- "$GE_WINE")

set GE_WINESERVER_Q \
    (string escape -- "$GE_WINESERVER")

set GE_LIBS_Q \
    (string escape -- "$GE_LIBS")

set DXVK_CONFIG_FILE_Q \
    (string escape -- "$DXVK_CONFIG_FILE")

set CATALOG_MANAGER_Q \
    (string escape -- "$REPO/scripts/manage-aviutl2-catalog-lutris.sh")

begin
    printf '%s\n' \
        '#!/usr/bin/env bash' \
        'set -Eeuo pipefail' \
        ''

    printf 'export AVIUTL2_ROOT=%s\n' \
        "$ROOT_Q"

    printf 'export AVIUTL2_PREFIX=%s\n' \
        "$PREFIX_Q"

    printf 'export GE_PROTON_ROOT=%s\n' \
        "$GE_PROTON_ROOT_Q"

    printf 'export GE_WINE=%s\n' \
        "$GE_WINE_Q"

    printf 'export GE_WINESERVER=%s\n' \
        "$GE_WINESERVER_Q"

    printf 'export GE_LIBS=%s\n' \
        "$GE_LIBS_Q"

    printf 'export DXVK_CONFIG_FILE=%s\n' \
        "$DXVK_CONFIG_FILE_Q"

    printf '%s\n' \
        "export WINEDLLOVERRIDES_VALUE='nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'" \
        ''

    printf 'exec %s "$@"\n' \
        "$CATALOG_MANAGER_Q"
end > "$CATALOG_LUTRIS_WRAPPER"

chmod +x \
    "$CATALOG_LUTRIS_WRAPPER"

bash -n \
    "$CATALOG_LUTRIS_WRAPPER"

cat \
    "$CATALOG_LUTRIS_WRAPPER"
```

状態確認:

```fish
"$CATALOG_LUTRIS_WRAPPER" \
    status
```

Catalog未導入の場合:

```fish
"$CATALOG_LUTRIS_WRAPPER" \
    install-only
```

Catalog起動:

```fish
"$CATALOG_LUTRIS_WRAPPER" \
    launch
```

初期設定:

```text
AviUtl2: インストール済み
AviUtl2 root: C:\AviUtl2
Portable mode: 無効
```

## 8. AviUtl2 CatalogをLutrisへ登録する

再び`Add locally installed game`を選ぶ。

### Game info

```text
Name: AviUtl2 Catalog
Runner: Linux
```

### Game options

Nanashi環境の標準例:

```text
Executable:
/home/nanashi/Games/aviutl2/lutris/manage-catalog.sh

Arguments:
launch

Working directory:
/home/nanashi/projects/aviutl2-linux-patches
```

### System options

```text
Disable Lutris Runtime: enabled
```

保存後、LutrisからCatalogを起動する。

## 9. L-SMASH WorksをCatalogで上書きしない

現在の`lwinput.aui2`はcustom buildである。
Catalogから通常版L-SMASH Worksを更新すると、custom buildが上書きされる可能性がある。

Catalogでは`Mr-Ojii.L-SMASH-Works`の更新を停止する。
誤って更新した場合はcustom artifactを最後に再導入する。

```fish
set PLUGIN_DIR \
    "$PREFIX/drive_c/ProgramData/aviutl2/Plugin"

install \
    -m 0644 \
    "$LSMASH_ARTIFACT_DIR/lwinput.aui2" \
    "$PLUGIN_DIR/lwinput.aui2"

install \
    -m 0644 \
    "$LSMASH_ARTIFACT_DIR/lsmash.ini" \
    "$PLUGIN_DIR/lsmash.ini"
```

## 10. トラブルシューティング

### `prefix not found`

wrapperへ推測したprefixを固定している。
Section 3を再実行し、成功した診断ログの`AVIUTL2_EXE`からprefixを復元して、Section 4のwrapperを再生成する。

### Lutrisからだけ起動しない

まずwrapper単体をterminalから実行する。

```fish
"$AVIUTL2_LUTRIS_WRAPPER"
```

単体では動く場合、Lutrisの設定を確認する。

```text
Runner: Linux
Executable: wrapperの絶対path
Arguments: 空欄
Disable Lutris Runtime: enabled
```

Wine Runner、Lutris管理のWine prefix、Lutris管理のDXVKを選択しない。

### patched DWriteが使われているか不明

```fish
cmp \
    --silent \
    "$BUILT_DWRITE" \
    "$GE_DWRITE"

and sha256sum \
    "$BUILT_DWRITE" \
    "$GE_DWRITE"
```

不一致ならLutrisを起動せず、`scripts/install-dwrite.fish`でrunnerへ再導入する。

## 正本

AviUtl2起動時の環境構築:

```text
scripts/launch-aviutl2.fish
```

Catalogの取得・起動・更新・backup:

```text
scripts/manage-aviutl2-catalog-lutris.sh
```

Lutrisには、これらへ検証済みの絶対pathを渡すローカルwrapperだけを登録する。
