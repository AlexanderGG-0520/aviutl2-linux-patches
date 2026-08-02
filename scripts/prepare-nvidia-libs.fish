#!/usr/bin/env fish

set -g SCRIPT_NAME (basename (status filename))

function usage
    echo "Usage: $SCRIPT_NAME [--output-dir PATH]"
    echo
    echo "Downloads SveSop/nvidia-libs v1.0.2 from the GitHub release API,"
    echo "extracts the regular 64-bit archive, and verifies the three DLLs"
    echo "used by the validated AviUtl2 environment."
end

function die
    echo "ERROR: $argv" >&2
    exit 1
end

function require_command
    command -q "$argv[1]"
    or die "required command not found: $argv[1]"
end

argparse \
    'h/help' \
    'o/output-dir=' \
    -- $argv
or begin
    usage >&2
    exit 2
end

if set -q _flag_help
    usage
    exit 0
end

for command_name in curl python3 tar find cp mkdir rmdir rm sha256sum file basename dirname
    require_command "$command_name"
end

# `version` is a read-only special Fish variable containing the Fish version.
# Do not reuse it for release tags.
set -l release_tag v1.0.2
set -l release_version (string replace -r '^v' '' -- "$release_tag")
set -l root "$HOME/Games/aviutl2"
set -l download_dir "$root/downloads/nvidia-libs-$release_tag"
set -l extract_dir "$root/build/nvidia-libs-$release_tag-extract"
set -l output_dir "$root/artifacts/nvidia-libs-$release_tag/x64"

if set -q _flag_output_dir
    set output_dir (string trim -- "$_flag_output_dir")
end

test -n "$output_dir"
or die "--output-dir must not be empty"

set output_dir (string replace -r '/+$' '' -- "$output_dir")
set -l output_parent (dirname "$output_dir")
set -l release_json "$download_dir/release.json"
set -l asset_url_file "$download_dir/asset-url.txt"

mkdir -p "$download_dir" "$root/build" "$output_parent"
or die "failed to create working directories"

if test -e "$output_dir"
    rmdir "$output_dir" 2>/dev/null
    or die "output directory already exists and is not empty: $output_dir"
end

rm -rf "$extract_dir"
mkdir -p "$extract_dir" "$output_dir"
or die "failed to create extraction/output directories"

set -l api_url "https://api.github.com/repos/SveSop/nvidia-libs/releases/tags/$release_tag"

echo "Downloading release metadata: $api_url"
curl \
    --fail \
    --location \
    --retry 3 \
    --header 'Accept: application/vnd.github+json' \
    --output "$release_json" \
    "$api_url"
or die "failed to download release metadata"

python3 -c '
import json
import sys
from pathlib import Path

release_path = Path(sys.argv[1])
release_version = sys.argv[2]
data = json.loads(release_path.read_text(encoding="utf-8"))

candidates = []
for asset in data.get("assets", []):
    name = asset.get("name", "")
    lower = name.lower()
    if not name.startswith(f"nvidia-libs-v{release_version}"):
        continue
    if "fakedll" in lower:
        continue
    if not lower.endswith((".tar.xz", ".tar.gz", ".tgz", ".tar.bz2")):
        continue
    candidates.append((name, asset.get("browser_download_url", "")))

if len(candidates) != 1:
    rendered = ", ".join(name for name, _ in candidates) or "none"
    raise SystemExit(
        f"expected exactly one regular nvidia-libs archive; found: {rendered}"
    )

name, url = candidates[0]
if not url:
    raise SystemExit(f"selected asset has no browser_download_url: {name}")
print(url)
' "$release_json" "$release_version" > "$asset_url_file"
or die "failed to select the regular release archive"

set -l asset_url (string trim < "$asset_url_file")
test -n "$asset_url"
or die "release asset URL is empty"

set -l archive "$download_dir/"(basename "$asset_url")
echo "Downloading archive: $asset_url"
curl \
    --fail \
    --location \
    --retry 3 \
    --output "$archive" \
    "$asset_url"
or die "failed to download nvidia-libs archive"

sha256sum "$archive"

tar -xf "$archive" -C "$extract_dir"
or die "failed to extract nvidia-libs archive"

set -l nvcuda_path (find "$extract_dir" -type f -path '*/x64/nvcuda.dll' -print -quit)
test -n "$nvcuda_path"
or die "x64/nvcuda.dll was not found after extraction"

set -l source_x64 (dirname "$nvcuda_path")
for dll in nvcuda.dll nvcuvid.dll nvencodeapi64.dll
    test -s "$source_x64/$dll"
    or die "missing required DLL in release archive: $source_x64/$dll"

    cp -a "$source_x64/$dll" "$output_dir/$dll"
    or die "failed to copy $dll"
end

pushd "$output_dir" >/dev/null
or die "failed to enter output directory"

begin
    echo '86a7db21366704af4e0e61884aaaafb80b2e87d427c4214dcb775d17b37fd7cc  nvcuda.dll'
    echo 'fd51c2f98f8006f097240a1d2cf53d72a6d1b741618fb679226ec563d2ad0944  nvcuvid.dll'
    echo '6f28193dd276c257d3e80ee03627f2cb0bb94dec6582cf9c04c32744d088b75a  nvencodeapi64.dll'
end > SHA256SUMS.expected

sha256sum -c SHA256SUMS.expected
or begin
    popd >/dev/null
    die "nvidia-libs DLL hash verification failed"
end

sha256sum nvcuda.dll nvcuvid.dll nvencodeapi64.dll > SHA256SUMS
file nvcuda.dll nvcuvid.dll nvencodeapi64.dll

popd >/dev/null

echo
echo "NVIDIA Wine wrapper artifact prepared: $output_dir"
echo "The DLLs have not been installed into a Wine prefix yet."
