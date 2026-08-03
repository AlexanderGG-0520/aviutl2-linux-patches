#!/usr/bin/env fish

# Install a validated patched L-SMASH Works r1284 AV1/HEVC NVDEC artifact into
# an existing AviUtl2 Wine prefix while protecting it from AviUtl2 Catalog
# bulk updates.
#
# This script intentionally does NOT modify installed.json or hash-cache.json.

set -g SCRIPT_NAME (basename (status filename))

function usage
    echo "Usage: $SCRIPT_NAME --prefix PATH --artifact-dir PATH [--windows-user NAME]"
    echo
    echo "Required:"
    echo "  --prefix       Existing Wine/Proton prefix"
    echo "  --artifact-dir Directory containing lwinput.aui2 and lsmash.ini"
    echo
    echo "Default:"
    echo "  --windows-user steamuser"
end

function die
    echo "ERROR: $argv" >&2
    exit 1
end

function note
    echo
    echo "==> $argv"
end

function file_sha_or_missing
    set -l path $argv[1]
    if test -f "$path"
        sha256sum "$path" | string split ' ' | head -n 1
    else
        echo MISSING
    end
end

argparse \
    'h/help' \
    'p/prefix=' \
    'a/artifact-dir=' \
    'u/windows-user=' \
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

set -q _flag_artifact_dir
or die "--artifact-dir is required"

set -l prefix (string replace -r '/+$' '' -- (string trim -- "$_flag_prefix"))
set -l artifact_dir (string replace -r '/+$' '' -- (string trim -- "$_flag_artifact_dir"))
set -l windows_user steamuser

if set -q _flag_windows_user
    set windows_user (string trim -- "$_flag_windows_user")
end

test -n "$prefix"
or die "--prefix must not be empty"

test -n "$artifact_dir"
or die "--artifact-dir must not be empty"

test -n "$windows_user"
or die "--windows-user must not be empty"

for command_name in \
    python3 \
    sha256sum \
    strings \
    grep \
    cp \
    mkdir \
    date \
    pgrep \
    cmp \
    head

    command -q "$command_name"
    or die "required command not found: $command_name"
end

set -l plugin_dir "$prefix/drive_c/ProgramData/aviutl2/Plugin"
set -l roaming "$prefix/drive_c/users/$windows_user/AppData/Roaming/aviutl2-catalog"
set -l settings "$roaming/settings.json"
set -l installed "$roaming/installed.json"
set -l hash_cache "$roaming/hash-cache.json"
set -l built_aui2 "$artifact_dir/lwinput.aui2"
set -l built_ini "$artifact_dir/lsmash.ini"
set -l active_aui2 "$plugin_dir/lwinput.aui2"
set -l active_ini "$plugin_dir/lsmash.ini"
set -l package_id 'Mr-Ojii.L-SMASH-Works'

for required_path in \
    "$prefix/drive_c" \
    "$plugin_dir" \
    "$settings" \
    "$built_aui2" \
    "$built_ini"

    test -e "$required_path"
    or die "required path not found: $required_path"
end

# Do not race AviUtl2 or Catalog while replacing their files/settings.
if pgrep -af 'AviUtl2_Catalog\.exe|aviutl2\.exe' >/dev/null 2>&1
    pgrep -af 'AviUtl2_Catalog\.exe|aviutl2\.exe' >&2
    die "AviUtl2 or AviUtl2 Catalog appears to be running; close it first"
end

# Artifact validation. SHA-256 is intentionally not required to equal an
# earlier build because the absolute build prefix is embedded in FFmpeg.
begin
    strings -a -n 5 "$built_aui2"
    strings -a --encoding=l -n 5 "$built_aui2"
end | grep -q 'L-SMASH Works File Reader for AviUtl2 r1284 by Mr-Ojii'
or die "artifact does not identify itself as L-SMASH Works r1284"

strings -a -n 5 "$built_aui2" | grep -q -- '--enable-cuvid'
or die "artifact lacks the FFmpeg --enable-cuvid marker"

for decoder in av1_cuvid hevc_cuvid
    strings -a -n 5 "$built_aui2" \
        | grep -q -- "--enable-decoder=$decoder"
    or die "artifact lacks the FFmpeg $decoder marker"
end

grep -qx 'libavsmash_disabled=1' "$built_ini"
or die "lsmash.ini must contain libavsmash_disabled=1"

grep -qx 'libav_disabled=0' "$built_ini"
or die "lsmash.ini must contain libav_disabled=0"

grep -qx 'preferred_decoders=av1_cuvid,hevc_cuvid' "$built_ini"
or die "lsmash.ini must prefer av1_cuvid and hevc_cuvid"

set -l installed_before (file_sha_or_missing "$installed")
set -l hash_cache_before (file_sha_or_missing "$hash_cache")
set -l stamp (date +%Y%m%d-%H%M%S)

note "Creating backups"
cp -a "$settings" "$settings.before-lsmash-nvdec-$stamp"
or die "failed to back up Catalog settings"

if test -f "$active_aui2"
    cp -a "$active_aui2" "$active_aui2.before-lsmash-nvdec-$stamp"
    or die "failed to back up the existing lwinput.aui2"
end

if test -f "$active_ini"
    cp -a "$active_ini" "$active_ini.before-lsmash-nvdec-$stamp"
    or die "failed to back up the existing lsmash.ini"
end

note "Pausing the Catalog package before replacing the plugin"
python3 -c '
import json
import os
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
package_id = sys.argv[2]

data = json.loads(path.read_text(encoding="utf-8-sig"))
raw = data.get("package_updates_paused_ids", [])
if not isinstance(raw, list):
    raise SystemExit("package_updates_paused_ids is not a JSON array")

ids = sorted({str(value).strip() for value in raw if str(value).strip()})
if package_id not in ids:
    ids.append(package_id)
    ids.sort()

data["package_updates_paused_ids"] = ids

temporary = path.with_name(path.name + ".tmp-lsmash-nvdec")
temporary.write_text(
    json.dumps(data, ensure_ascii=False, indent=2) + "\n",
    encoding="utf-8",
)
os.replace(temporary, path)
' "$settings" "$package_id"
or die "failed to update Catalog package_updates_paused_ids"

python3 -c '
import json
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
package_id = sys.argv[2]
data = json.loads(path.read_text(encoding="utf-8-sig"))
ids = data.get("package_updates_paused_ids", [])
if package_id not in ids:
    raise SystemExit(f"pause verification failed: {package_id}")
print(f"paused: {package_id}")
' "$settings" "$package_id"
or die "Catalog pause verification failed"

note "Installing patched L-SMASH Works r1284"
mkdir -p "$plugin_dir"
or die "failed to create plugin directory"

cp -f "$built_aui2" "$active_aui2"
or die "failed to install lwinput.aui2"

cp -f "$built_ini" "$active_ini"
or die "failed to install lsmash.ini"

cmp -s "$built_aui2" "$active_aui2"
or die "installed lwinput.aui2 differs from the artifact"

cmp -s "$built_ini" "$active_ini"
or die "installed lsmash.ini differs from the artifact"

set -l installed_after (file_sha_or_missing "$installed")
set -l hash_cache_after (file_sha_or_missing "$hash_cache")

test "$installed_after" = "$installed_before"
or die "installed.json changed unexpectedly"

test "$hash_cache_after" = "$hash_cache_before"
or die "hash-cache.json changed unexpectedly"

set -l active_sha256 (sha256sum "$active_aui2" | string split ' ')[1]

note "Installation completed"
echo "Active plugin: $active_aui2"
echo "SHA-256: $active_sha256"
echo "Preferred decoders: av1_cuvid,hevc_cuvid"
echo "Catalog pause ID: $package_id"
echo "installed.json: unchanged ($installed_after)"
echo "hash-cache.json: unchanged ($hash_cache_after)"
echo
echo "Do not use Update, Reinstall, Remove, or initial setup for L-SMASH Works."
echo "Catalog will detect the custom file as installed version '不明'; this is expected."
