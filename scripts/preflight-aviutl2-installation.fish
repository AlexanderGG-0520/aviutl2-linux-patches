#!/usr/bin/env fish

set -g SCRIPT_NAME (basename (status filename))

function usage
    echo "Usage: $SCRIPT_NAME --root PATH --ge-proton-root PATH [options]"
    echo
    echo "Options:"
    echo "  --root PATH                 AviUtl2 work root"
    echo "  --ge-proton-root PATH       Patched GE-Proton root"
    echo "  --aviutl2-source-dir PATH   Default: <root>/artifacts/AviUtl2-2.1.3"
    echo "  --lsmash-artifact-dir PATH  Default: <root>/build/l-smash-works-nvdec-repro-03/output"
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
    or die "missing path: $path"

    echo "OK: $path"
end

argparse \
    'h/help' \
    'r/root=' \
    'g/ge-proton-root=' \
    'a/aviutl2-source-dir=' \
    'l/lsmash-artifact-dir=' \
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

set -q _flag_ge_proton_root
or die "--ge-proton-root is required"

set -l root \
    (normalize_absolute --root "$_flag_root")

set -l ge_proton_root \
    (normalize_absolute --ge-proton-root "$_flag_ge_proton_root")

set -l artifact_root "$root/artifacts"
set -l aviutl2_source_dir "$artifact_root/AviUtl2-2.1.3"
set -l lsmash_artifact_dir "$root/build/l-smash-works-nvdec-repro-03/output"

if set -q _flag_aviutl2_source_dir
    set aviutl2_source_dir \
        (normalize_absolute --aviutl2-source-dir "$_flag_aviutl2_source_dir")
end

if set -q _flag_lsmash_artifact_dir
    set lsmash_artifact_dir \
        (normalize_absolute --lsmash-artifact-dir "$_flag_lsmash_artifact_dir")
end

set -l wine "$ge_proton_root/files/bin/wine"
if not test -x "$wine"
    set wine "$ge_proton_root/files/lib/wine/x86_64-unix/wine"
end

set -l wineserver "$ge_proton_root/files/bin/wineserver"
set -l dwrite "$ge_proton_root/files/lib/wine/x86_64-windows/dwrite.dll"
set -l dxvk_artifact_dir "$artifact_root/dxvk-2.7.1-aviutl2/x64"
set -l font_source_dir "$artifact_root/fonts"
set -l nvidia_wrapper_dir "$artifact_root/nvidia-libs-v1.0.2/x64"
set -l dxvk_config_file "$root/nvidia-dxvk.conf"

echo "Resolved installation paths:"
printf '  HOME=%s\n' "$HOME"
printf '  root=%s\n' "$root"
printf '  ge_proton_root=%s\n' "$ge_proton_root"
printf '  wine=%s\n' "$wine"
printf '  wineserver=%s\n' "$wineserver"
printf '  aviutl2_source_dir=%s\n' "$aviutl2_source_dir"
printf '  lsmash_artifact_dir=%s\n' "$lsmash_artifact_dir"

for path in \
    "$wine" \
    "$wineserver" \
    "$dwrite" \
    "$aviutl2_source_dir/aviutl2.exe" \
    "$dxvk_artifact_dir/d3d11.dll" \
    "$dxvk_artifact_dir/dxgi.dll" \
    "$dxvk_artifact_dir/d3d10core.dll" \
    "$font_source_dir/NotoSansCJK-Regular.ttc" \
    "$font_source_dir/NotoSansCJK-Bold.ttc" \
    "$font_source_dir/Tahoma-Noto-Regular.otf" \
    "$font_source_dir/Tahoma-Noto-Bold.otf" \
    "$nvidia_wrapper_dir/nvcuda.dll" \
    "$nvidia_wrapper_dir/nvcuvid.dll" \
    "$nvidia_wrapper_dir/nvencodeapi64.dll" \
    "$lsmash_artifact_dir/lwinput.aui2" \
    "$lsmash_artifact_dir/lsmash.ini" \
    "$dxvk_config_file"

    require_path "$path"
end

echo "Installation artifact preflight completed successfully."
