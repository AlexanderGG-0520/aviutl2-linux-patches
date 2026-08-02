#!/usr/bin/env fish

function fail
    echo "ERROR: $argv" >&2
    return 1
end

function main
    if test (count $argv) -ne 2
        echo "Usage: install-dwrite.fish WINE_BUILD GE_PROTON_ROOT" >&2
        return 64
    end

    set -l WINE_BUILD "$argv[1]"
    set -l GE_ROOT "$argv[2]"

    set -l DLL_SRC \
        "$WINE_BUILD/dlls/dwrite/x86_64-windows/dwrite.dll"

    set -l DLL_DST \
        "$GE_ROOT/files/lib/wine/x86_64-windows/dwrite.dll"

    if not test -s "$DLL_SRC"
        fail "missing or empty source DLL: $DLL_SRC"
        return 66
    end

    if not test -f "$DLL_DST"
        fail "missing destination DLL: $DLL_DST"
        return 66
    end

    set -l TS (date +%Y%m%d-%H%M%S)
    set -l BACKUP "$DLL_DST.backup-$TS"

    cp -a -- "$DLL_DST" "$BACKUP"
    or begin
        fail "failed to back up destination DLL: $DLL_DST"
        return 1
    end

    cp -f -- "$DLL_SRC" "$DLL_DST"
    or begin
        fail "failed to install DWrite DLL: $DLL_DST"
        return 1
    end

    cmp --silent -- "$DLL_SRC" "$DLL_DST"
    or begin
        cp -f -- "$BACKUP" "$DLL_DST"
        fail "installed DLL differs from build output; restored backup: $BACKUP"
        return 1
    end

    echo "Backup:"
    echo "$BACKUP"

    echo
    echo "SHA-256:"
    sha256sum -- "$DLL_SRC" "$DLL_DST"
    or return 1

    return 0
end

main $argv
exit $status
