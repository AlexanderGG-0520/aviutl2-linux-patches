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

function require_command --argument-names command_name
    command -q "$command_name"
    or die "required command not found: $command_name"
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

for command_name in strings grep sha256sum
    require_command "$command_name"
end

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
set -l ge_lib64 "$ge_proton_root/files/lib/x86_64-linux-gnu"
set -l ge_lib32 "$ge_proton_root/files/lib/i386-linux-gnu"
set -l ge_vkd3d_dir "$ge_proton_root/files/lib/vkd3d"
set -l ge_wine_dll_dir "$ge_proton_root/files/lib/wine"
set -l ge_winedllpath "$ge_vkd3d_dir:$ge_wine_dll_dir"
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
printf '  ld_library_path=%s:%s\n' "$ge_lib64" "$ge_lib32"
printf '  winedllpath=%s\n' "$ge_winedllpath"
printf '  aviutl2_source_dir=%s\n' "$aviutl2_source_dir"
printf '  lsmash_artifact_dir=%s\n' "$lsmash_artifact_dir"

for path in \
    "$wine" \
    "$wineserver" \
    "$dwrite" \
    "$ge_lib64" \
    "$ge_lib32" \
    "$ge_vkd3d_dir" \
    "$ge_wine_dll_dir" \
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
    "$lsmash_artifact_dir/SHA256SUMS" \
    "$dxvk_config_file"

    require_path "$path"
end

pushd "$lsmash_artifact_dir" >/dev/null
sha256sum -c SHA256SUMS >/dev/null
set -l lsmash_checksum_status $status
popd >/dev/null

test $lsmash_checksum_status -eq 0
or die "L-SMASH Works artifact checksum verification failed"

set -l lsmash_binary "$lsmash_artifact_dir/lwinput.aui2"
set -l lsmash_config "$lsmash_artifact_dir/lsmash.ini"

begin
    strings -a -n 5 "$lsmash_binary"
    strings -a --encoding=l -n 5 "$lsmash_binary"
end | grep -q 'L-SMASH Works File Reader for AviUtl2 r1284 by Mr-Ojii'
or die "L-SMASH Works artifact does not identify itself as r1284"

strings -a -n 5 "$lsmash_binary" | grep -q -- '--enable-cuvid'
or die "L-SMASH Works artifact lacks --enable-cuvid"

for decoder in av1_cuvid hevc_cuvid
    strings -a -n 5 "$lsmash_binary" \
        | grep -q -- "--enable-decoder=$decoder"
    or die "L-SMASH Works artifact lacks $decoder"
end

grep -qx 'libavsmash_disabled=1' "$lsmash_config"
or die "L-SMASH Works config must disable libavsmash"

grep -qx 'libav_disabled=0' "$lsmash_config"
or die "L-SMASH Works config must enable libav"

grep -qx \
    'preferred_decoders=av1_cuvid,hevc_cuvid' \
    "$lsmash_config"
or die "L-SMASH Works config must branch between AV1 and HEVC CUVID"

echo "OK: L-SMASH Works AV1/HEVC CUVID artifact"
echo "Installation artifact preflight completed successfully."
