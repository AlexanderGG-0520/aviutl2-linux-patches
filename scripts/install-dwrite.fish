#!/usr/bin/env fish

if test (count $argv) -ne 2
    echo "Usage: install-dwrite.fish WINE_BUILD GE_PROTON_ROOT"
else
    set WINE_BUILD "$argv[1]"
    set GE_ROOT "$argv[2]"

    set DLL_SRC         "$WINE_BUILD/dlls/dwrite/x86_64-windows/dwrite.dll"

    set DLL_DST         "$GE_ROOT/files/lib/wine/x86_64-windows/dwrite.dll"

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
