# This file replaces the generated Bash Catalog wrapper with a Fish wrapper.
# The repository manager remains Bash, but all fixed runtime paths are exported
# by Fish before invoking it. A compatibility symlink preserves old Lutris and
# desktop registrations that still reference manage-catalog.sh.

functions --erase write_catalog_lutris_wrapper

function write_catalog_lutris_wrapper
    set -l wrapper_dir "$ROOT/lutris"
    set -g CATALOG_LUTRIS_WRAPPER "$wrapper_dir/manage-catalog.fish"
    set -l legacy_wrapper "$wrapper_dir/manage-catalog.sh"
    set -l temporary "$CATALOG_LUTRIS_WRAPPER.tmp-"(date +%Y%m%d-%H%M%S-%N)
    set -l ge_wine (ge_wine_path "$GE_PROTON_ROOT")
    set -l ge_wineserver "$GE_PROTON_ROOT/files/bin/wineserver"
    set -l ge_libs \
        "$GE_PROTON_ROOT/files/lib/x86_64-linux-gnu:$GE_PROTON_ROOT/files/lib/i386-linux-gnu"
    set -l manager "$REPO/scripts/manage-aviutl2-catalog-lutris.sh"

    require_path "$manager"
    require_path "$ge_wine"
    require_path "$ge_wineserver"
    require_command bash

    mkdir -p "$wrapper_dir"
    or die 'failed to create Lutris wrapper directory'

    test ! -e "$temporary"
    or die "temporary Catalog wrapper already exists: $temporary"

    set -l root_q (string escape -- "$ROOT")
    set -l prefix_q (string escape -- "$PREFIX")
    set -l ge_root_q (string escape -- "$GE_PROTON_ROOT")
    set -l ge_wine_q (string escape -- "$ge_wine")
    set -l ge_wineserver_q (string escape -- "$ge_wineserver")
    set -l ge_libs_q (string escape -- "$ge_libs")
    set -l dxvk_config_q (string escape -- "$DXVK_CONFIG_FILE")
    set -l overrides_q (string escape -- "$DLL_OVERRIDES")
    set -l manager_q (string escape -- "$manager")

    printf '%s\n' \
        '#!/usr/bin/env fish' \
        '' \
        "set -gx AVIUTL2_ROOT $root_q" \
        "set -gx AVIUTL2_PREFIX $prefix_q" \
        "set -gx GE_PROTON_ROOT $ge_root_q" \
        "set -gx GE_WINE $ge_wine_q" \
        "set -gx GE_WINESERVER $ge_wineserver_q" \
        "set -gx GE_LIBS $ge_libs_q" \
        "set -gx DXVK_CONFIG_FILE $dxvk_config_q" \
        "set -gx WINEDLLOVERRIDES_VALUE $overrides_q" \
        '' \
        "exec bash $manager_q \$argv" \
        > "$temporary"
    or die 'failed to write temporary Catalog Fish wrapper'

    chmod 0755 "$temporary"
    or die 'failed to chmod temporary Catalog Fish wrapper'

    fish -n "$temporary"
    or die 'generated Catalog Fish wrapper has invalid syntax'

    mv -fT -- "$temporary" "$CATALOG_LUTRIS_WRAPPER"
    or die 'failed to publish Catalog Fish wrapper'

    ln -sfn \
        (basename "$CATALOG_LUTRIS_WRAPPER") \
        "$legacy_wrapper"
    or die 'failed to publish legacy Catalog wrapper compatibility symlink'

    test (readlink -f "$legacy_wrapper") = (readlink -f "$CATALOG_LUTRIS_WRAPPER")
    or die 'legacy Catalog wrapper symlink verification failed'

    success "Catalog Lutris Fish wrapper: $CATALOG_LUTRIS_WRAPPER"
end
