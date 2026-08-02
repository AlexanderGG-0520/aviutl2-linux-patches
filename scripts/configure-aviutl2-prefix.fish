#!/usr/bin/env fish

set -g SCRIPT_NAME (basename (status filename))

function usage
    echo "Usage: $SCRIPT_NAME --prefix PATH --ge-proton-root PATH"
    echo
    echo "Registers AviUtl2 fonts, Wine DLL overrides, and XIM InputStyle"
    echo "inside an already initialized Wine prefix."
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

set -l wine "$ge_proton_root/files/bin/wine"
if not test -x "$wine"
    set wine "$ge_proton_root/files/lib/wine/x86_64-unix/wine"
end

set -l wineserver "$ge_proton_root/files/bin/wineserver"
set -l ge_libs "$ge_proton_root/files/lib/x86_64-linux-gnu:$ge_proton_root/files/lib/i386-linux-gnu"
set -l ge_winedllpath "$ge_proton_root/files/lib/vkd3d"

function run_wine \
    --inherit-variable prefix \
    --inherit-variable ge_libs \
    --inherit-variable ge_winedllpath \
    --inherit-variable wine

    env \
        WINEPREFIX="$prefix" \
        LD_LIBRARY_PATH="$ge_libs" \
        WINEDLLPATH="$ge_winedllpath" \
        "$wine" \
        $argv
end

require_path "$wine"
require_path "$wineserver"
require_path "$ge_proton_root/files/lib/x86_64-linux-gnu"
require_path "$ge_proton_root/files/lib/i386-linux-gnu"
require_path "$ge_winedllpath"
require_path "$prefix/user.reg"
require_path "$prefix/system.reg"
require_path "$prefix/userdef.reg"
require_path "$prefix/drive_c/windows/system32"

for font_file in \
    NotoSansCJK-Regular.ttc \
    NotoSansCJK-Bold.ttc \
    Tahoma-Noto-Regular.otf \
    Tahoma-Noto-Bold.otf

    require_path "$prefix/drive_c/windows/Fonts/$font_file"
end

set -l reg_fonts \
    'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Fonts'

set -l reg_subs \
    'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\FontSubstitutes'

set -l reg_overrides \
    'HKEY_CURRENT_USER\Software\Wine\DllOverrides'

set -l reg_x11 \
    'HKEY_CURRENT_USER\Software\Wine\AppDefaults\aviutl2.exe\X11 Driver'

env \
    WINEPREFIX="$prefix" \
    LD_LIBRARY_PATH="$ge_libs" \
    WINEDLLPATH="$ge_winedllpath" \
    "$wineserver" \
    -k \
    2>/dev/null
or true

run_wine \
    reg add "$reg_fonts" \
    /v 'Noto Sans CJK JP (TrueType)' \
    /d 'NotoSansCJK-Regular.ttc' \
    /f
or die "failed to register Noto Sans CJK JP"

run_wine \
    reg add "$reg_fonts" \
    /v 'Noto Sans CJK JP Bold (TrueType)' \
    /d 'NotoSansCJK-Bold.ttc' \
    /f
or die "failed to register Noto Sans CJK JP Bold"

run_wine \
    reg add "$reg_fonts" \
    /v 'Tahoma (OpenType)' \
    /d 'Tahoma-Noto-Regular.otf' \
    /f
or die "failed to register Tahoma"

run_wine \
    reg add "$reg_fonts" \
    /v 'Tahoma Bold (OpenType)' \
    /d 'Tahoma-Noto-Bold.otf' \
    /f
or die "failed to register Tahoma Bold"

run_wine \
    reg delete "$reg_subs" \
    /v Tahoma \
    /f \
    >/dev/null 2>&1
or true

for name in \
    'MS Shell Dlg' \
    'MS Shell Dlg 2'

    run_wine \
        reg add "$reg_subs" \
        /v "$name" \
        /d Tahoma \
        /f
    or die "failed to register font substitute: $name"
end

for name in \
    'MS Gothic' \
    'MS UI Gothic' \
    'MS PGothic' \
    'MS Mincho' \
    'MS PMincho' \
    'Meiryo' \
    'Meiryo UI' \
    'Yu Gothic' \
    'Yu Gothic UI' \
    'Yu Mincho'

    run_wine \
        reg add "$reg_subs" \
        /v "$name" \
        /d 'Noto Sans CJK JP' \
        /f
    or die "failed to register font substitute: $name"
end

for specification in \
    'nvcuda=native' \
    'nvcuvid=native' \
    'nvencodeapi64=native' \
    'd3d11=native,builtin' \
    'dxgi=native,builtin' \
    'd3d10core=native,builtin' \
    'd3dcompiler_47=native,builtin' \
    'dwrite=builtin'

    set -l parts \
        (string split -m 1 '=' -- "$specification")

    set -l dll $parts[1]
    set -l override $parts[2]

    run_wine \
        reg add "$reg_overrides" \
        /v "$dll" \
        /t REG_SZ \
        /d "$override" \
        /f
    or die "failed to register DLL override: $dll"
end

run_wine \
    reg add "$reg_x11" \
    /v InputStyle \
    /t REG_SZ \
    /d overthespot \
    /f
or die "failed to register AviUtl2 InputStyle"

run_wine \
    wineboot -u
or die "wineboot update failed"

env \
    WINEPREFIX="$prefix" \
    LD_LIBRARY_PATH="$ge_libs" \
    WINEDLLPATH="$ge_winedllpath" \
    "$wineserver" \
    -w
or die "wineserver wait failed"

run_wine \
    reg query "$reg_fonts" \
    /v 'Tahoma (OpenType)'
or die "Tahoma registry verification failed"

run_wine \
    reg query "$reg_subs" \
    /v 'MS Shell Dlg'
or die "font substitute verification failed"

run_wine \
    reg query "$reg_overrides" \
    /v dwrite
or die "dwrite override verification failed"

run_wine \
    reg query "$reg_x11" \
    /v InputStyle
or die "InputStyle verification failed"

echo "AviUtl2 prefix registry configuration completed: $prefix"
