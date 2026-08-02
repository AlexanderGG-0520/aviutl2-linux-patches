# This file is sourced by scripts/setup-aviutl2-interactive.fish.

function catalog_env_command --argument-names manager_command
    set -l ge_wine (ge_wine_path "$GE_PROTON_ROOT")
    set -l ge_wineserver "$GE_PROTON_ROOT/files/bin/wineserver"
    set -l ge_libs \
        "$GE_PROTON_ROOT/files/lib/x86_64-linux-gnu:$GE_PROTON_ROOT/files/lib/i386-linux-gnu"
    set -l manager "$REPO/scripts/manage-aviutl2-catalog-lutris.sh"

    require_path "$manager"

    env \
        AVIUTL2_ROOT="$ROOT" \
        AVIUTL2_PREFIX="$PREFIX" \
        GE_PROTON_ROOT="$GE_PROTON_ROOT" \
        GE_WINE="$ge_wine" \
        GE_WINESERVER="$ge_wineserver" \
        GE_LIBS="$ge_libs" \
        DXVK_CONFIG_FILE="$DXVK_CONFIG_FILE" \
        WINEDLLOVERRIDES_VALUE="$DLL_OVERRIDES" \
        bash \
        "$manager" \
        "$manager_command"
end

function setup_catalog
    note 'AviUtl2 Catalog / Lutris integration'
    note 'docs/LUTRIS-CATALOG.mdの検証済み工程を使用する'

    validate_runtime

    validate_gui_verification_marker
    or die 'Catalog setup requires current Section 13 GUI / text / Mozc verification evidence'

    if test "$SKIP_DEPENDENCIES" -eq 1
        note 'Catalog/Lutris dependency installation is disabled by --skip-dependencies'
    else if ask_yes_no 'Catalog/Lutris用packageを導入しますか？' yes
        sudo pacman -S --needed \
            lutris \
            github-cli \
            python \
            xdg-utils \
            desktop-file-utils
        or die 'Catalog/Lutris dependency installation failed'
    end

    require_command gh
    require_command lutris
    require_command xdg-mime

    note 'Catalog status'
    catalog_env_command status
    or true

    if ask_yes_no '既存patched prefixへAviUtl2 CatalogをLutris経由で導入しますか？' yes
        catalog_env_command lutris-install
        or die 'AviUtl2 Catalog Lutris installation failed'

        echo
        echo 'Catalog初期設定で次を指定する:'
        echo '  AviUtl2: インストール済み'
        echo '  AviUtl2 root: C:\AviUtl2'
        echo '  Portable mode: 無効'
        echo
        echo '初期設定を完了し、AviUtl2とCatalogを閉じてから続行する。'

        ask_yes_no 'Catalog初期設定を完了し、両方のprocessを閉じましたか？' no
        or die 'Catalog initial setup is not complete'

        fish \
            "$REPO/scripts/install-l-smash-works-nvdec.fish" \
            --prefix "$PREFIX" \
            --artifact-dir "$LSMASH_ARTIFACT_DIR"
        or die 'failed to restore and protect custom L-SMASH Works'

        success 'Catalog installed; custom L-SMASH Works restored and update-paused'
    else
        warn 'Catalog installation skipped'
    end
end
