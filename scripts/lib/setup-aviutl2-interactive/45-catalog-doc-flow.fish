# This file is sourced after 40-catalog.fish and replaces its setup_catalog
# implementation with the fixed-wrapper flow documented in
# docs/LUTRIS-CATALOG.md.

function write_aviutl2_lutris_wrapper
    set -l wrapper_dir "$ROOT/lutris"
    set -g AVIUTL2_LUTRIS_WRAPPER "$wrapper_dir/launch-aviutl2.fish"
    set -l temporary "$AVIUTL2_LUTRIS_WRAPPER.tmp-"(date +%Y%m%d-%H%M%S-%N)

    mkdir -p "$wrapper_dir"
    or die 'failed to create Lutris wrapper directory'

    test ! -e "$temporary"
    or die "temporary AviUtl2 wrapper already exists: $temporary"

    set -l launch_script_q \
        (string escape -- "$REPO/scripts/launch-aviutl2.fish")
    set -l prefix_q \
        (string escape -- "$PREFIX")
    set -l ge_root_q \
        (string escape -- "$GE_PROTON_ROOT")
    set -l dxvk_config_q \
        (string escape -- "$DXVK_CONFIG_FILE")

    printf '%s\n' \
        '#!/usr/bin/env fish' \
        '' \
        "exec fish $launch_script_q --prefix $prefix_q --ge-proton-root $ge_root_q --dxvk-config $dxvk_config_q" \
        > "$temporary"
    or die 'failed to write temporary AviUtl2 wrapper'

    chmod 0755 "$temporary"
    or die 'failed to chmod temporary AviUtl2 wrapper'

    fish -n "$temporary"
    or die 'generated AviUtl2 wrapper has invalid Fish syntax'

    mv -fT -- "$temporary" "$AVIUTL2_LUTRIS_WRAPPER"
    or die 'failed to publish AviUtl2 wrapper'

    success "AviUtl2 Lutris wrapper: $AVIUTL2_LUTRIS_WRAPPER"
end

function write_catalog_lutris_wrapper
    set -l wrapper_dir "$ROOT/lutris"
    set -g CATALOG_LUTRIS_WRAPPER "$wrapper_dir/manage-catalog.sh"
    set -l temporary "$CATALOG_LUTRIS_WRAPPER.tmp-"(date +%Y%m%d-%H%M%S-%N)
    set -l ge_wine (ge_wine_path "$GE_PROTON_ROOT")
    set -l ge_wineserver "$GE_PROTON_ROOT/files/bin/wineserver"
    set -l ge_libs \
        "$GE_PROTON_ROOT/files/lib/x86_64-linux-gnu:$GE_PROTON_ROOT/files/lib/i386-linux-gnu"
    set -l manager "$REPO/scripts/manage-aviutl2-catalog-lutris.sh"

    require_path "$manager"
    require_path "$ge_wine"
    require_path "$ge_wineserver"

    mkdir -p "$wrapper_dir"
    or die 'failed to create Lutris wrapper directory'

    test ! -e "$temporary"
    or die "temporary Catalog wrapper already exists: $temporary"

    python3 -c '
from pathlib import Path
import os
import shlex
import sys

(
    temporary,
    root,
    prefix,
    ge_root,
    ge_wine,
    ge_wineserver,
    ge_libs,
    dxvk_config,
    overrides,
    manager,
) = sys.argv[1:]

exports = {
    "AVIUTL2_ROOT": root,
    "AVIUTL2_PREFIX": prefix,
    "GE_PROTON_ROOT": ge_root,
    "GE_WINE": ge_wine,
    "GE_WINESERVER": ge_wineserver,
    "GE_LIBS": ge_libs,
    "DXVK_CONFIG_FILE": dxvk_config,
    "WINEDLLOVERRIDES_VALUE": overrides,
}

lines = ["#!/usr/bin/env bash", "set -Eeuo pipefail", ""]
for key, value in exports.items():
    lines.append(f"export {key}={shlex.quote(value)}")
lines.extend(["", f"exec {shlex.quote(manager)} \"$@\"", ""])

path = Path(temporary)
path.write_text("\n".join(lines), encoding="utf-8")
os.chmod(path, 0o755)
' \
        "$temporary" \
        "$ROOT" \
        "$PREFIX" \
        "$GE_PROTON_ROOT" \
        "$ge_wine" \
        "$ge_wineserver" \
        "$ge_libs" \
        "$DXVK_CONFIG_FILE" \
        "$DLL_OVERRIDES" \
        "$manager"
    or die 'failed to generate fixed Catalog wrapper'

    bash -n "$temporary"
    or die 'generated Catalog wrapper has invalid Bash syntax'

    mv -fT -- "$temporary" "$CATALOG_LUTRIS_WRAPPER"
    or die 'failed to publish Catalog wrapper'

    success "Catalog Lutris wrapper: $CATALOG_LUTRIS_WRAPPER"
end

function print_lutris_registration
    note 'Lutrisへ固定wrapperを登録する'

    printf '%s\n' \
        '' \
        'AviUtl2:' \
        '  Name: AviUtl2' \
        '  Runner: Linux' \
        "  Executable: $AVIUTL2_LUTRIS_WRAPPER" \
        '  Arguments: 空欄' \
        "  Working directory: $ROOT" \
        '  Disable Lutris Runtime: enabled' \
        '' \
        'AviUtl2 Catalog:' \
        '  Name: AviUtl2 Catalog' \
        '  Runner: Linux' \
        "  Executable: $CATALOG_LUTRIS_WRAPPER" \
        '  Arguments: launch' \
        "  Working directory: $REPO" \
        '  Disable Lutris Runtime: enabled' \
        ''
end

function setup_catalog
    note 'AviUtl2 Catalog / Lutris integration'
    note 'docs/LUTRIS-CATALOG.mdの固定wrapper手順を使用する'

    test "$ASSUME_YES" -eq 0
    or die 'Catalog/Lutris setup requires interactive GUI confirmation; do not use --assume-yes'

    validate_runtime

    validate_gui_verification_marker
    or die 'Catalog setup requires current Section 13 GUI / text / Mozc verification evidence'

    if test "$SKIP_DEPENDENCIES" -eq 1
        note 'Catalog/Lutris dependency installation is disabled by --skip-dependencies'
    else if ask_yes_no 'LUTRIS-CATALOG.md記載のpackageを導入しますか？' yes
        sudo pacman -S --needed \
            lutris \
            fish \
            python \
            xdg-utils \
            desktop-file-utils \
            github-cli
        or die 'Catalog/Lutris dependency installation failed'
    end

    require_command gh
    require_command lutris
    require_command python3

    write_aviutl2_lutris_wrapper
    write_catalog_lutris_wrapper

    note 'AviUtl2 wrapperを単体検証する'
    "$AVIUTL2_LUTRIS_WRAPPER"
    or die 'AviUtl2 fixed wrapper exited with a failure status'

    ask_yes_no 'wrapper経由でAviUtl2が起動し、text編集とMozc入力を確認できましたか？' no
    or die 'AviUtl2 wrapper GUI verification was not confirmed'

    note 'Catalog状態を確認する'
    "$CATALOG_LUTRIS_WRAPPER" status
    or true

    if ask_yes_no '固定wrapperからAviUtl2 Catalogを導入しますか？' yes
        "$CATALOG_LUTRIS_WRAPPER" install-only
        or die 'AviUtl2 Catalog installation failed'

        echo
        echo '次の初期設定をCatalog GUIで行う:'
        echo '  AviUtl2: インストール済み'
        echo '  AviUtl2 root: C:\AviUtl2'
        echo '  Portable mode: 無効'
        echo

        "$CATALOG_LUTRIS_WRAPPER" launch
        or die 'Catalog fixed wrapper exited with a failure status'

        ask_yes_no '固定wrapper経由でCatalogが起動し、初期設定を完了して閉じましたか？' no
        or die 'Catalog wrapper GUI verification and initial setup were not confirmed'

        fish \
            "$REPO/scripts/install-l-smash-works-nvdec.fish" \
            --prefix "$PREFIX" \
            --artifact-dir "$LSMASH_ARTIFACT_DIR"
        or die 'failed to restore and protect custom L-SMASH Works'

        success 'Catalog installed; custom L-SMASH Works restored and update-paused'
    else
        warn 'Catalog installation skipped'
    end

    print_lutris_registration

    if ask_yes_no 'Lutrisを開いて2つのLinux Runner entryを登録しますか？' yes
        lutris
        or die 'Lutris exited with a failure status'

        ask_yes_no 'AviUtl2とCatalogの両entryを固定wrapperで登録しましたか？' no
        or die 'Lutris registration was not confirmed'

        success 'Lutris fixed-wrapper registration confirmed'
    else
        warn 'Lutris registration was skipped; use the values printed above'
    end
end
