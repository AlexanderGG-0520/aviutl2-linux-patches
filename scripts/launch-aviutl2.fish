#!/usr/bin/env fish

set -g SCRIPT_NAME (basename (status filename))

function usage
    echo "Usage: $SCRIPT_NAME --prefix PATH --ge-proton-root PATH --dxvk-config PATH"
end

function die
    echo "ERROR: $argv" >&2
    exit 1
end

argparse \
    'h/help' \
    'p/prefix=' \
    'g/ge-proton-root=' \
    'd/dxvk-config=' \
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

set -q _flag_dxvk_config
or die "--dxvk-config is required"

set -l prefix \
    (string replace -r '/+$' '' -- \
        (string trim -- "$_flag_prefix"))

set -l ge_proton_root \
    (string replace -r '/+$' '' -- \
        (string trim -- "$_flag_ge_proton_root"))

set -l dxvk_config \
    (string trim -- "$_flag_dxvk_config")

test -n "$prefix"
or die "--prefix must not be empty"

test -n "$ge_proton_root"
or die "--ge-proton-root must not be empty"

test -n "$dxvk_config"
or die "--dxvk-config must not be empty"

set -l wine \
    "$ge_proton_root/files/bin/wine"

if not test -x "$wine"
    set wine \
        "$ge_proton_root/files/lib/wine/x86_64-unix/wine"
end

set -l ge_libs \
    "$ge_proton_root/files/lib64:$ge_proton_root/files/lib:$ge_proton_root/files/lib/wine/x86_64-unix:$ge_proton_root/files/lib/wine/i386-unix"

set -l aviutl2_dir \
    "$prefix/drive_c/AviUtl2"

set -l aviutl2_exe \
    "$aviutl2_dir/aviutl2.exe"

set -l dll_overrides \
    'nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

for path in \
    "$wine" \
    "$prefix/user.reg" \
    "$aviutl2_exe" \
    "$dxvk_config"

    test -e "$path"
    or die "missing path: $path"
end

cd "$aviutl2_dir"
or die "failed to enter AviUtl2 directory: $aviutl2_dir"

env \
    XMODIFIERS='@im=fcitx' \
    WINEPREFIX="$prefix" \
    LD_LIBRARY_PATH="$ge_libs" \
    WINEDLLOVERRIDES="$dll_overrides" \
    DXVK_CONFIG_FILE="$dxvk_config" \
    DXVK_LOG_LEVEL=warn \
    WINEDEBUG=-all \
    "$wine" \
    "$aviutl2_exe"
