#!/usr/bin/env fish

function fail
    echo "ERROR: $argv" >&2
    return 1
end

function main
    if test (count $argv) -ne 2
        echo 'Usage: install-d2d1.fish WINE_BUILD GE_PROTON_ROOT' >&2
        return 64
    end

    set -l wine_build "$argv[1]"
    set -l ge_root "$argv[2]"
    set -l dll_src \
        "$wine_build/dlls/d2d1/x86_64-windows/d2d1.dll"
    set -l dll_dst \
        "$ge_root/files/lib/wine/x86_64-windows/d2d1.dll"
    set -l marker \
        'AviUtl2 AddArc compatibility: converted arc to %u cubic Bezier segments.'

    test -s "$dll_src"
    or begin
        fail "missing or empty source DLL: $dll_src"
        return 66
    end

    test -f "$dll_dst"
    or begin
        fail "missing destination DLL: $dll_dst"
        return 66
    end

    file "$dll_src" | grep -q 'PE32+'
    or begin
        fail "source is not a PE32+ DLL: $dll_src"
        return 1
    end

    strings -a "$dll_src" | grep -Fq -- "$marker"
    or begin
        fail 'source d2d1.dll does not contain the AddArc compatibility marker'
        return 1
    end

    set -l timestamp (date +%Y%m%d-%H%M%S)
    set -l backup "$dll_dst.backup-$timestamp"

    cp -a -- "$dll_dst" "$backup"
    or begin
        fail "failed to back up destination DLL: $dll_dst"
        return 1
    end

    cp -f -- "$dll_src" "$dll_dst"
    or begin
        cp -f -- "$backup" "$dll_dst" 2>/dev/null
        fail "failed to install D2D1 DLL: $dll_dst"
        return 1
    end

    cmp --silent -- "$dll_src" "$dll_dst"
    or begin
        cp -f -- "$backup" "$dll_dst"
        fail "installed DLL differs from build output; restored backup: $backup"
        return 1
    end

    strings -a "$dll_dst" | grep -Fq -- "$marker"
    or begin
        cp -f -- "$backup" "$dll_dst"
        fail "installed DLL lost the AddArc marker; restored backup: $backup"
        return 1
    end

    echo 'Backup:'
    echo "$backup"
    echo
    echo 'SHA-256:'
    sha256sum -- "$dll_src" "$dll_dst"
end

main $argv
exit $status
