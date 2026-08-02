#!/usr/bin/env fish

set -g SCRIPT_NAME (basename (status filename))

function usage
    echo "Usage: $SCRIPT_NAME --prefix PATH --ge-proton-root PATH"
    echo
    echo "Creates a new 64-bit Wine prefix with the selected GE-Proton runner."
    echo "An already complete prefix is left unchanged."
    echo "A non-empty incomplete prefix is rejected and never deleted."
end

function die
    echo "ERROR: $argv" >&2
    exit 1
end

function require_path
    set -l path $argv[1]

    test -e "$path"
    or die "missing path: $path"
end

function prefix_is_complete --argument-names target
    test -f "$target/user.reg"
    and test -f "$target/system.reg"
    and test -f "$target/userdef.reg"
    and test -d "$target/drive_c/windows/system32"
end

argparse \
    'h/help' \
    'p/prefix=' \
    'g/ge-proton-root=' \
    -- $argv
or begin
    usage >&2
    exit 2
end

if set -q _flag_help
    usage
    exit 0
end

set -q _flag_prefix
or die "--prefix is required"

set -q _flag_ge_proton_root
or die "--ge-proton-root is required"

set -l prefix (string trim -- "$_flag_prefix")
set -l ge_proton_root (string trim -- "$_flag_ge_proton_root")

test -n "$prefix"
or die "--prefix must not be empty"

test -n "$ge_proton_root"
or die "--ge-proton-root must not be empty"

set prefix (string replace -r '/+$' '' -- "$prefix")
set ge_proton_root (string replace -r '/+$' '' -- "$ge_proton_root")

string match -q '/*' -- "$prefix"
or die "--prefix must be an absolute path: $prefix"

string match -q '/*' -- "$ge_proton_root"
or die "--ge-proton-root must be an absolute path: $ge_proton_root"

test "$prefix" != '/'
or die "refusing to use / as a prefix"

not test -L "$prefix"
or die "prefix path must not be a symbolic link: $prefix"

set -l wine "$ge_proton_root/files/bin/wine"
if not test -x "$wine"
    set wine "$ge_proton_root/files/lib/wine/x86_64-unix/wine"
end

set -l wineserver "$ge_proton_root/files/bin/wineserver"
set -l ge_libs "$ge_proton_root/files/lib64:$ge_proton_root/files/lib:$ge_proton_root/files/lib/wine/x86_64-unix:$ge_proton_root/files/lib/wine/i386-unix"

require_path "$wine"
require_path "$wineserver"

if prefix_is_complete "$prefix"
    echo "Prefix is already initialized: $prefix"
    exit 0
end

if test -e "$prefix"
    test -d "$prefix"
    or die "prefix path exists and is not a directory: $prefix"

    set -l first_entry (find "$prefix" -mindepth 1 -maxdepth 1 -print -quit)

    if test -n "$first_entry"
        echo "ERROR: prefix directory is non-empty but incomplete: $prefix" >&2
        echo "First existing entry: $first_entry" >&2
        echo "The script will not delete or overwrite it." >&2
        exit 1
    end

    rmdir "$prefix"
    or die "failed to remove empty prefix directory: $prefix"
end

mkdir -p (dirname "$prefix")
or die "failed to create prefix parent directory"

echo "Bootstrapping Wine prefix: $prefix"

env \
    WINEPREFIX="$prefix" \
    WINEARCH=win64 \
    LD_LIBRARY_PATH="$ge_libs" \
    WINEDEBUG=-all \
    "$wine" \
    wineboot
or die "wineboot failed"

env \
    WINEPREFIX="$prefix" \
    LD_LIBRARY_PATH="$ge_libs" \
    "$wineserver" \
    -w
or die "wineserver wait failed"

prefix_is_complete "$prefix"
or begin
    echo "ERROR: wineboot returned successfully, but the prefix is incomplete" >&2

    for path in \
        "$prefix/user.reg" \
        "$prefix/system.reg" \
        "$prefix/userdef.reg" \
        "$prefix/drive_c/windows/system32"

        if test -e "$path"
            echo "OK: $path" >&2
        else
            echo "MISSING: $path" >&2
        end
    end

    exit 1
end

echo "Wine prefix initialized: $prefix"
