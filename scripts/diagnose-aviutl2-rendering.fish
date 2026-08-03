#!/usr/bin/env fish

set -g SCRIPT_NAME (basename (status filename))
set -g SCRIPT_DIR (dirname (realpath (status filename)))

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
or die '--root is required'
set -q _flag_prefix
or die '--prefix is required'
set -q _flag_ge_proton_root
or die '--ge-proton-root is required'
set -q _flag_dxvk_config
or die '--dxvk-config is required'

set -l root (normalize_absolute --root "$_flag_root")
set -l prefix (normalize_absolute --prefix "$_flag_prefix")
set -l ge_root (normalize_absolute --ge-proton-root "$_flag_ge_proton_root")
set -l dxvk_config (normalize_absolute --dxvk-config "$_flag_dxvk_config")
set -l launcher "$SCRIPT_DIR/diagnose-aviutl2-launch.fish"
set -l stamp (date +%Y%m%d-%H%M%S)
set -l capture_dir "$root/logs/dxvk-rendering-$stamp"
set -l start_marker "$root/logs/.rendering-start-$stamp-"(random)

for command_name in fish find grep sort head tail cut date touch rm mkdir
    command -q "$command_name"
    or die "required command not found: $command_name"
end

for path in "$launcher" "$prefix" "$ge_root" "$dxvk_config"
    test -e "$path"
    or die "required path not found: $path"
end

fish -n "$launcher"
or die 'base diagnostic launcher has invalid Fish syntax'

mkdir -p "$capture_dir"
or die "failed to create DXVK capture directory: $capture_dir"

touch "$start_marker"
or die "failed to create rendering diagnostic start marker: $start_marker"

printf '%s\n' \
    '' \
    'AviUtl2で次の順に再現する:' \
    '  1. 図形objectを配置し、previewに表示されるか確認' \
    '  2. 問題の動画fileを読み込む' \
    '  3. CreateTexture2D dialogが出た場合はOKを押す' \
    '  4. AviUtl2を正常終了する' \
    '' \
    "DXVK_CAPTURE_DIR=$capture_dir"

env \
    DXVK_LOG_PATH="$capture_dir" \
    fish \
    "$launcher" \
    --root "$root" \
    --prefix "$prefix" \
    --ge-proton-root "$ge_root" \
    --dxvk-config "$dxvk_config"
set -l launch_status $status

set -l section_log \
    (find "$root/logs" \
        -maxdepth 1 \
        -type f \
        -name 'aviutl2-section13-*.log' \
        -newer "$start_marker" \
        -printf '%T@ %p\n' \
        | sort -nr \
        | head -n 1 \
        | cut -d' ' -f2-)

rm -f -- "$start_marker"
or die 'failed to remove rendering diagnostic start marker'

echo
echo '=== DXVK logs ==='
find "$capture_dir" -maxdepth 1 -type f -print | sort

set -l dxvk_logs (find "$capture_dir" -maxdepth 1 -type f -name '*.log' -print | sort)
if test (count $dxvk_logs) -gt 0
    echo
echo '=== DXVK texture and format failures ==='
    grep -nEi \
        'Cannot create texture|CreateTexture2D|Format:|Extent:|Samples:|Layers:|Levels:|Usage:|Flags:|unsupported|E_INVALIDARG' \
        $dxvk_logs \
        | tail -n 500
    or true
else
    echo 'WARNING: no DXVK log files were created' >&2
end

if test -n "$section_log"; and test -s "$section_log"
    echo
echo "SECTION_LOG=$section_log"
    echo '=== Wine D3D/D2D rendering records ==='
    grep -nEi \
        'CreateTexture2D|0x80070057|E_INVALIDARG|d2d:.*DrawGeometry|d2d:.*DrawBitmap|d2d:.*Create|err:d3d|err:dxgi|Unhandled exception|page fault' \
        "$section_log" \
        | tail -n 500
    or true
else
    echo 'WARNING: no new Section 13 log was found' >&2
end

echo
echo "RENDERING_DIAGNOSTIC_EXIT_STATUS=$launch_status"
echo "DXVK_CAPTURE_DIR=$capture_dir"

exit $launch_status
