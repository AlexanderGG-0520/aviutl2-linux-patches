#!/usr/bin/env fish

set -g SCRIPT_NAME (basename (status filename))
set -g SCRIPT_DIR (dirname (status filename))

function usage
    echo "Usage: $SCRIPT_NAME --root PATH --prefix PATH --ge-proton-root PATH --dxvk-config PATH"
end

function die
    echo "ERROR: $argv" >&2
    exit 1
end

function normalize_absolute --argument-names label input
    set input (string trim -- "$input")

    test -n "$input"
    or die "$label must not be empty"

    string match -q '/*' -- "$input"
    or die "$label must be an absolute path: $input"

    string replace -r '/+$' '' -- "$input"
end

function require_path --argument-names path
    test -e "$path"
    or die "missing launch prerequisite: $path"

    echo "OK: $path"
end

argparse \
    'h/help' \
    'r/root=' \
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

set -q _flag_root
or die "--root is required"

set -q _flag_prefix
or die "--prefix is required"

set -q _flag_ge_proton_root
or die "--ge-proton-root is required"

set -q _flag_dxvk_config
or die "--dxvk-config is required"

set -l root \
    (normalize_absolute --root "$_flag_root")

set -l prefix \
    (normalize_absolute --prefix "$_flag_prefix")

set -l ge_proton_root \
    (normalize_absolute --ge-proton-root "$_flag_ge_proton_root")

set -l dxvk_config \
    (normalize_absolute --dxvk-config "$_flag_dxvk_config")

set -l wine \
    "$ge_proton_root/files/bin/wine"

if not test -x "$wine"
    set wine \
        "$ge_proton_root/files/lib/wine/x86_64-unix/wine"
end

set -l wineserver \
    "$ge_proton_root/files/bin/wineserver"

set -l dwrite \
    "$ge_proton_root/files/lib/wine/x86_64-windows/dwrite.dll"

set -l ge_libs \
    "$ge_proton_root/files/lib/x86_64-linux-gnu:$ge_proton_root/files/lib/i386-linux-gnu"

set -l ge_vkd3d_dir \
    "$ge_proton_root/files/lib/vkd3d"

set -l ge_wine_dll_dir \
    "$ge_proton_root/files/lib/wine"

set -l ge_winedllpath \
    "$ge_vkd3d_dir:$ge_wine_dll_dir"

set -l dll_overrides \
    'nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

set -l aviutl2_dir \
    "$prefix/drive_c/AviUtl2"

set -l aviutl2_exe \
    "$aviutl2_dir/aviutl2.exe"

set -l configure_script \
    "$SCRIPT_DIR/configure-aviutl2-prefix.fish"

set -l log_dir \
    "$root/logs"

set -l launch_log \
    "$log_dir/aviutl2-section13-"(date +%Y%m%d-%H%M%S)".log"

set -l dwrite_stub_pattern \
    'fixme:dwrite:dwritetextlayout_HitTest(Point|TextPosition|TextRange).*stub'

for path in \
    "$configure_script" \
    "$ge_proton_root" \
    "$wine" \
    "$wineserver" \
    "$dwrite" \
    "$ge_proton_root/files/lib/x86_64-linux-gnu" \
    "$ge_proton_root/files/lib/i386-linux-gnu" \
    "$ge_vkd3d_dir" \
    "$ge_wine_dll_dir" \
    "$prefix/user.reg" \
    "$prefix/system.reg" \
    "$prefix/userdef.reg" \
    "$prefix/drive_c/windows/system32" \
    "$prefix/drive_c/windows/system32/d3d11.dll" \
    "$prefix/drive_c/windows/system32/dxgi.dll" \
    "$prefix/drive_c/windows/system32/d3d10core.dll" \
    "$aviutl2_dir" \
    "$aviutl2_exe" \
    "$dxvk_config"

    require_path "$path"
end

test -x "$wine"
or die "Wine is not executable: $wine"

test -x "$wineserver"
or die "wineserver is not executable: $wineserver"

set -l dwrite_hash_line \
    (sha256sum "$dwrite")

set -l dwrite_hash_status $status

test $dwrite_hash_status -eq 0
or die "failed to calculate dwrite.dll SHA-256: $dwrite"

set -l dwrite_sha256 \
    (string split -f1 ' ' -- "$dwrite_hash_line")

test -n "$dwrite_sha256"
or die "empty dwrite.dll SHA-256: $dwrite"

printf '%s\n' \
    "GE_PROTON_ROOT=$ge_proton_root" \
    "GE_WINE=$wine" \
    "GE_WINESERVER=$wineserver" \
    "GE_DWRITE=$dwrite" \
    "GE_DWRITE_SHA256=$dwrite_sha256" \
    "GE_LD_LIBRARY_PATH=$ge_libs" \
    "GE_WINEDLLPATH=$ge_winedllpath" \
    "AVIUTL2_EXE=$aviutl2_exe"

fish \
    "$configure_script" \
    --prefix "$prefix" \
    --ge-proton-root "$ge_proton_root"

set -l configure_status $status

echo "configure_exit_status=$configure_status"

test $configure_status -eq 0
or die "prefix registry/IME configuration failed"

file "$aviutl2_exe"
or die "file inspection failed: $aviutl2_exe"

mkdir -p "$log_dir"
or die "failed to create log directory: $log_dir"

rm -f "$launch_log"
or die "failed to reset diagnostic log: $launch_log"

env \
    WINEPREFIX="$prefix" \
    LD_LIBRARY_PATH="$ge_libs" \
    WINEDLLPATH="$ge_winedllpath" \
    "$wineserver" \
    -k \
    2>/dev/null
or true

env \
    WINEPREFIX="$prefix" \
    LD_LIBRARY_PATH="$ge_libs" \
    WINEDLLPATH="$ge_winedllpath" \
    "$wineserver" \
    -w \
    2>/dev/null
or true

cd "$aviutl2_dir"
or die "failed to enter AviUtl2 directory: $aviutl2_dir"

echo "diagnostic_log=$launch_log"
echo "diagnostic_executable=$aviutl2_exe"
echo "Wine output is being written to the diagnostic log."

begin
    printf '%s\n' \
        "GE_PROTON_ROOT=$ge_proton_root" \
        "GE_WINE=$wine" \
        "GE_WINESERVER=$wineserver" \
        "GE_DWRITE=$dwrite" \
        "GE_DWRITE_SHA256=$dwrite_sha256" \
        "GE_LD_LIBRARY_PATH=$ge_libs" \
        "GE_WINEDLLPATH=$ge_winedllpath" \
        "AVIUTL2_EXE=$aviutl2_exe" \
        "DXVK_CONFIG_FILE=$dxvk_config" \
        "DIAGNOSTIC_STARTED_AT="(date --iso-8601=seconds)

    env \
        XMODIFIERS='@im=fcitx' \
        WINEPREFIX="$prefix" \
        LD_LIBRARY_PATH="$ge_libs" \
        WINEDLLPATH="$ge_winedllpath" \
        WINEDLLOVERRIDES="$dll_overrides" \
        DXVK_CONFIG_FILE="$dxvk_config" \
        DXVK_LOG_LEVEL=warn \
        WINEDEBUG='+timestamp,+pid,+tid,+loaddll,+seh' \
        "$wine" \
        "$aviutl2_exe"
end > "$launch_log" 2>&1

set -l aviutl2_exit_status $status
set -l log_size \
    (stat -c '%s' "$launch_log" 2>/dev/null)

if test -z "$log_size"
    set log_size 0
end

echo "aviutl2_exit_status=$aviutl2_exit_status"
echo "aviutl2_log_size=$log_size"
echo "aviutl2_log_path=$launch_log"

echo
echo "=== diagnostic metadata ==="
head -n 10 "$launch_log"

echo
echo "=== log tail ==="
tail -n 100 "$launch_log"

echo
echo "=== executable load records ==="
grep -nEi \
    'trace:loaddll:build_module Loaded .*aviutl2\.exe|Loaded L".*aviutl2\.exe"' \
    "$launch_log"
or true

echo
echo "=== important launch errors ==="
grep -nEi \
    "Application could not be started|ShellExecuteEx failed|File not found|c0000135|Unhandled exception|unhandled page fault|page fault|err:module:import_dll|failed to load|could not load|$dwrite_stub_pattern|EXCEPTION_WINE_CXX_EXCEPTION" \
    "$launch_log"
or true

test $aviutl2_exit_status -eq 0
or die "AviUtl2 exited with status $aviutl2_exit_status"

test $log_size -gt 0
or die "diagnostic log is empty"

grep -qEi \
    'trace:loaddll:build_module Loaded .*aviutl2\.exe|Loaded L".*aviutl2\.exe"' \
    "$launch_log"
or die "no aviutl2.exe load record was found"

if grep -qEi \
    'Application could not be started|ShellExecuteEx failed: File not found|c0000135|Unhandled exception|unhandled page fault' \
    "$launch_log"

    die "fatal launch marker was found in the diagnostic log"
end

if grep -qEi \
    "$dwrite_stub_pattern" \
    "$launch_log"

    die "the selected runner still contains an unpatched DWrite hit-test stub"
end

echo "Diagnostic launch completed without an automatic failure marker."
echo "Confirm the GUI checks in INSTALLATION.md before using the normal launcher."
