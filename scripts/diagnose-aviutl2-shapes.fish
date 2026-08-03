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

function count_pattern --argument-names pattern path
    set -l result (grep -cE "$pattern" "$path" 2>/dev/null)
    set -l grep_status $status

    switch $grep_status
        case 0 1
            test -n "$result"
            and echo "$result"
            or echo 0
        case '*'
            die "failed to count pattern in log: $pattern"
    end
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
set -l start_marker "$root/logs/.shape-start-$stamp-"(random)
set -l wine_debug '-all,+timestamp,+pid,+tid,+loaddll,+seh,+d2d'

for command_name in fish find grep sort head tail cut date touch rm
    command -q "$command_name"
    or die "required command not found: $command_name"
end

for path in "$launcher" "$prefix" "$ge_root" "$dxvk_config"
    test -e "$path"
    or die "required path not found: $path"
end

fish -n "$launcher"
or die 'base diagnostic launcher has invalid Fish syntax'

touch "$start_marker"
or die "failed to create shape diagnostic start marker: $start_marker"

printf '%s\n' \
    '' \
    'AviUtl2で次の順に、短時間で再現する:' \
    '  1. 新規projectでdefaultの四角形objectを1個だけ追加する' \
    '  2. 四角形がpreviewに表示されることを確認する' \
    '  3. 同じobjectを円へ変更する' \
    '  4. 円だけpreviewに表示されないことを確認する' \
    '  5. 円のsize・塗り色・枠線幅を一度変更する' \
    '  6. 10秒以内を目安にAviUtl2を正常終了する' \
    '' \
    '動画・text・Catalogはこの診断では操作しない。' \
    "WINEDEBUG=$wine_debug"

fish \
    "$launcher" \
    --root "$root" \
    --prefix "$prefix" \
    --ge-proton-root "$ge_root" \
    --dxvk-config "$dxvk_config" \
    --wine-debug "$wine_debug"
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
or die 'failed to remove shape diagnostic start marker'

test -n "$section_log"
and test -s "$section_log"
or die 'no nonempty shape diagnostic log was found'

echo
echo "SHAPE_LOG=$section_log"
echo '=== D2D shape call counts ==='
printf '%-28s %s\n' \
    'DrawGeometry' (count_pattern 'trace:d2d:d2d_device_context_DrawGeometry' "$section_log") \
    'FillGeometry' (count_pattern 'trace:d2d:d2d_device_context_FillGeometry' "$section_log") \
    'DrawRectangle' (count_pattern 'trace:d2d:d2d_device_context_DrawRectangle' "$section_log") \
    'FillRectangle' (count_pattern 'trace:d2d:d2d_device_context_FillRectangle' "$section_log") \
    'DrawEllipse' (count_pattern 'trace:d2d:d2d_device_context_DrawEllipse' "$section_log") \
    'FillEllipse' (count_pattern 'trace:d2d:d2d_device_context_FillEllipse' "$section_log") \
    'CreateEllipseGeometry' (count_pattern 'trace:d2d:d2d_factory_CreateEllipseGeometry' "$section_log") \
    'Created ellipse geometry' (count_pattern 'trace:d2d:.*Created ellipse geometry' "$section_log") \
    'Ellipse init failures' (count_pattern '(warn|err):d2d:.*(Failed to initialise ellipse geometry|Failed to create geometry)' "$section_log") \
    'BeginDraw' (count_pattern 'trace:d2d:d2d_device_context_BeginDraw' "$section_log") \
    'EndDraw' (count_pattern 'trace:d2d:d2d_device_context_EndDraw' "$section_log")

echo
echo '=== Focused ellipse trace ==='
grep -nEi \
    'trace:d2d:(d2d_device_context_(DrawGeometry|FillGeometry|DrawRectangle|FillRectangle|DrawRoundedRectangle|FillRoundedRectangle|DrawEllipse|FillEllipse|BeginDraw|EndDraw|SetTarget|SetTransform|Clear)|d2d_factory_CreateEllipseGeometry)|Created ellipse geometry|Failed to initialise ellipse geometry|Failed to create geometry|fixme:d2d:d2d_device_context_DrawGeometry|warn:d2d|err:d2d|Failed to create (index|vertex) buffer|d2d_device_context_set_error|stroke_width|stroke_style|tessellat|outline|fill' \
    "$section_log" \
    | tail -n 2000
or true

echo
echo "SHAPE_DIAGNOSTIC_EXIT_STATUS=$launch_status"
exit $launch_status
