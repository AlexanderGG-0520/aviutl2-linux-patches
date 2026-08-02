# This file is sourced after 45-catalog-doc-flow.fish.
# It replaces setup_catalog with a strict Catalog-wrapper verification gate
# before any Lutris registration is allowed.

functions --erase setup_catalog

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
    require_command xdg-mime

    write_aviutl2_lutris_wrapper
    write_catalog_lutris_wrapper
    register_fixed_catalog_url_handler

    note 'AviUtl2 wrapperを単体検証する'
    "$AVIUTL2_LUTRIS_WRAPPER"
    or die 'AviUtl2 fixed wrapper exited with a failure status'

    ask_yes_no 'wrapper経由でAviUtl2が起動し、text編集とMozc入力を確認できましたか？' no
    or die 'AviUtl2 wrapper GUI verification was not confirmed'

    note 'Catalog状態を確認する'
    "$CATALOG_LUTRIS_WRAPPER" status
    or true

    set -l catalog_wrapper_verified 0

    if ask_yes_no '固定wrapperからAviUtl2 Catalogを導入しますか？' yes
        "$CATALOG_LUTRIS_WRAPPER" install-only
        or die 'AviUtl2 Catalog installation failed'

        # install-only registers the manager path by default. Replace it with
        # the fixed wrapper before any deep link is used.
        register_fixed_catalog_url_handler

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

        set catalog_wrapper_verified 1

        fish \
            "$REPO/scripts/install-l-smash-works-nvdec.fish" \
            --prefix "$PREFIX" \
            --artifact-dir "$LSMASH_ARTIFACT_DIR"
        or die 'failed to restore and protect custom L-SMASH Works'

        success 'Catalog installed; custom L-SMASH Works restored and update-paused'
    else
        warn 'Catalog installation skipped; Catalog wrapper is not GUI-verified'
        warn 'Lutris registration is blocked until Catalog installation and wrapper GUI verification succeed'
        return 0
    end

    test "$catalog_wrapper_verified" -eq 1
    or die 'Catalog wrapper verification gate was not satisfied'

    print_lutris_registration

    if ask_yes_no 'Lutrisを開いて、表示した設定どおり2つのLinux Runner entryを登録しますか？' yes
        lutris
        or die 'Lutris exited with a failure status'

        ask_yes_no "AviUtl2 entryを Runner=Linux、Executable=$AVIUTL2_LUTRIS_WRAPPER、Arguments=空欄、Working directory=$ROOT、Disable Lutris Runtime=enabled で登録しましたか？" no
        or die 'AviUtl2 Lutris entry settings were not confirmed'

        ask_yes_no "AviUtl2 Catalog entryを Runner=Linux、Executable=$CATALOG_LUTRIS_WRAPPER、Arguments=launch、Working directory=$REPO、Disable Lutris Runtime=enabled で登録しましたか？" no
        or die 'Catalog Lutris entry settings were not confirmed'

        success 'Lutris fixed-wrapper registration confirmed'
    else
        warn 'Lutris registration was skipped; use the values printed above'
    end
end
