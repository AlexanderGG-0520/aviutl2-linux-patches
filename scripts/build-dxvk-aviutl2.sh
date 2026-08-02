#!/usr/bin/env bash
# Build a fresh, pinned DXVK tree. Existing paths are never reused or removed.
set -Eeuo pipefail

readonly BASE='c3dd74be6baec53786d4e064a572185b70347a17'
readonly DXVK_URL='https://github.com/doitsujin/dxvk.git'

REPO=''
PATCH=''
WORK_INPUT=''
OUTPUT_INPUT=''
WORK=''
OUTPUT=''

die() {
    printf 'ERROR: %s\n' "$*" >&2
    exit 1
}

usage() {
    cat <<'EOF'
使用法:
  build-dxvk-aviutl2.sh --work-dir NEW_SOURCE_DIRECTORY --output-dir NEW_OUTPUT_DIRECTORY

オプション:
  --work-dir PATH    新規 DXVK source directory
  --output-dir PATH  新規 install/output directory
  -h, --help         この説明を表示

開発者用検証:
  AVIUTL2_DXVK_BUILD_VALIDATE_ONLY=1 はpath、command、patch構文を検証し、
  network fetch前に終了する。指定した最終directoryは作成しない。
EOF
}

on_error() {
    local status=$?
    printf 'ERROR: line %s: %s\n' "$1" "$2" >&2
    printf 'Partial work may remain at: %s\n' "${WORK:-未解決}" >&2
    printf 'Partial output may remain at: %s\n' "${OUTPUT:-未解決}" >&2
    printf 'Inspect these paths; retry requires new work and output paths.\n' >&2
    exit "$status"
}

trap 'on_error "$LINENO" "$BASH_COMMAND"' ERR

require_command() {
    command -v "$1" >/dev/null 2>&1 \
        || die "required command not found: $1"
}

normalize_new_path() {
    local input=$1
    local parent
    local base
    local parent_abs

    [[ -n $input ]] || die 'path must not be empty'

    parent=$(dirname -- "$input")
    base=$(basename -- "$input")

    [[ $base != '.' && $base != '..' && -n $base ]] \
        || die "invalid final path: $input"

    [[ -d $parent ]] \
        || die "parent directory does not exist: $parent"

    parent_abs=$(cd -P -- "$parent" && pwd -P) \
        || die "cannot resolve parent directory: $parent"

    printf '%s/%s\n' "$parent_abs" "$base"
}

is_within() {
    local child=$1
    local parent=$2
    [[ $child == "$parent" || $child == "$parent/"* ]]
}

resolve_unique_dll() {
    local name=$1
    local flat=$OUTPUT/$name
    local -a candidates=()

    mapfile -d '' candidates < <(
        find "$OUTPUT" -type f -name "$name" ! -path "$flat" -print0
    )

    printf 'DLL candidates for %s: %s\n' "$name" "${#candidates[@]}" >&2
    printf '%s\n' "${candidates[@]}" >&2

    ((${#candidates[@]} == 1)) \
        || die "expected exactly one installed $name beneath $OUTPUT"

    [[ -f ${candidates[0]} && -s ${candidates[0]} ]] \
        || die "resolved DLL is not a nonempty regular file: ${candidates[0]}"

    printf '%s\n' "${candidates[0]}"
}

copy_flat_dll() {
    local name=$1
    local source=$2
    local flat=$OUTPUT/$name

    [[ $source != "$flat" ]] \
        || die "installed DLL is already at flat destination: $flat"

    printf 'Resolved %s: %s\n' "$name" "$source" >&2

    cp -a -- "$source" "$flat"

    [[ -f $flat && -s $flat ]] \
        || die "flat DLL is not a nonempty regular file: $flat"

    cmp -s -- "$source" "$flat" \
        || die "flat DLL differs from installed source: $flat"
}

while (($#)); do
    case $1 in
        --work-dir)
            (($# >= 2)) || die '--work-dir requires a value'
            [[ -z $WORK_INPUT ]] || die '--work-dir may be specified only once'
            [[ -n $2 ]] || die '--work-dir requires a nonempty value'
            WORK_INPUT=$2
            shift 2
            ;;
        --output-dir)
            (($# >= 2)) || die '--output-dir requires a value'
            [[ -z $OUTPUT_INPUT ]] || die '--output-dir may be specified only once'
            [[ -n $2 ]] || die '--output-dir requires a nonempty value'
            OUTPUT_INPUT=$2
            shift 2
            ;;
        -h|--help)
            (($# == 1)) || die "$1 does not accept additional arguments"
            usage
            exit 0
            ;;
        --*)
            die "unknown option: $1"
            ;;
        *)
            die "unexpected positional argument: $1"
            ;;
    esac
done

[[ -n $WORK_INPUT ]] || die '--work-dir is required'
[[ -n $OUTPUT_INPUT ]] || die '--output-dir is required'

REPO=$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P) \
    || die 'cannot resolve repository root'

PATCH=$REPO/patches/dxvk/0001-aviutl2-format-support.patch
WORK=$(normalize_new_path "$WORK_INPUT")
OUTPUT=$(normalize_new_path "$OUTPUT_INPUT")

[[ $BASE =~ ^[0-9a-f]{40}$ ]] || die 'pinned base commit is invalid'
[[ -d $REPO ]] || die "repository root does not exist: $REPO"
[[ -f $PATCH && -s $PATCH ]] || die "patch is not a nonempty regular file: $PATCH"
[[ $WORK != / && $OUTPUT != / ]] || die 'work and output paths must not be /'
[[ $WORK != "$REPO" && $OUTPUT != "$REPO" ]] || die 'work and output paths must not be the repository root'

is_within "$WORK" "$REPO" && die "work path must be outside repository: $WORK"
is_within "$OUTPUT" "$REPO" && die "output path must be outside repository: $OUTPUT"

[[ $WORK != "$OUTPUT" ]] || die 'work and output paths must differ'

is_within "$WORK" "$OUTPUT" && die 'work path must not be inside output path'
is_within "$OUTPUT" "$WORK" && die 'output path must not be inside work path'

for command_name in \
    git meson ninja sha256sum grep find cp cmp awk cat \
    x86_64-w64-mingw32-gcc dirname basename pwd nproc date
do
    require_command "$command_name"
done

printf 'Repository: %s\n' "$REPO"
printf 'Patch: %s\n' "$PATCH"
printf 'Work directory: %s\n' "$WORK"
printf 'Output directory: %s\n' "$OUTPUT"

# This catches malformed hunk headers before downloading DXVK.
git apply --numstat "$PATCH" >/dev/null \
    || die "patch syntax validation failed: $PATCH"

[[ ! -e $WORK && ! -L $WORK ]] \
    || die "work directory must be new and not a symlink: $WORK"

[[ ! -e $OUTPUT && ! -L $OUTPUT ]] \
    || die "output directory must be new and not a symlink: $OUTPUT"

if [[ ${AVIUTL2_DXVK_BUILD_VALIDATE_ONLY:-} == 1 ]]; then
    printf 'Validation-only mode completed before network fetch.\n'
    exit 0
fi

# Fetch the pinned commit directly. Do not recursively clone the current DXVK
# default branch first; doing so can leave subprojects from a newer revision.
git init -q "$WORK"
git -C "$WORK" remote add origin "$DXVK_URL"
git -C "$WORK" fetch --depth 1 origin "$BASE"
git -C "$WORK" checkout --detach -q FETCH_HEAD
git -C "$WORK" submodule update --init --recursive

[[ $(git -C "$WORK" rev-parse HEAD) == "$BASE" ]] \
    || die 'resolved DXVK commit differs from pinned base'

[[ -z $(git -C "$WORK" status --short --untracked-files=all) ]] \
    || die 'pinned DXVK tree is not clean after checkout and submodule update'

CROSS_FILE=$WORK/build-win64.txt

[[ -f $CROSS_FILE && -s $CROSS_FILE ]] \
    || die "missing or empty cross file: $CROSS_FILE"

CROSS_FILE_SHA256=$(sha256sum "$CROSS_FILE" | awk '{print $1}')

grep -Eq "^[[:space:]]*c[[:space:]]*=[[:space:]]*['\"]x86_64-w64-mingw32-gcc['\"]" "$CROSS_FILE" \
    || die "cross file does not explicitly name x86_64-w64-mingw32-gcc: $CROSS_FILE"

git -C "$WORK" apply --check "$PATCH"
git -C "$WORK" apply "$PATCH"
git -C "$WORK" diff --check

grep -Fq '#include "../util/util_env.h"' \
    "$WORK/src/d3d11/d3d11_device.cpp" \
    || die 'patched source lacks util_env include'

grep -Fq 'AviUtl2 compatibility: unsupported ' \
    "$WORK/src/d3d11/d3d11_device.cpp" \
    || die 'patched source lacks AviUtl2 compatibility marker'

meson setup \
    "$WORK/build.w64" \
    "$WORK" \
    --cross-file "$CROSS_FILE" \
    --buildtype release \
    --prefix "$OUTPUT"

meson compile \
    -C "$WORK/build.w64" \
    -j "$(nproc)"

meson install \
    -C "$WORK/build.w64"

d3d11_source=$(resolve_unique_dll d3d11.dll)
dxgi_source=$(resolve_unique_dll dxgi.dll)
d3d10core_source=$(resolve_unique_dll d3d10core.dll)

copy_flat_dll d3d11.dll "$d3d11_source"
copy_flat_dll dxgi.dll "$dxgi_source"
copy_flat_dll d3d10core.dll "$d3d10core_source"

LC_ALL=C grep -aFq 'AviUtl2 compatibility' "$OUTPUT/d3d11.dll" \
    || die 'built d3d11.dll lacks compatibility marker'

(
    cd -- "$OUTPUT"
    sha256sum d3d11.dll dxgi.dll d3d10core.dll > SHA256SUMS
    sha256sum -c SHA256SUMS
)

MINGW_COMPILER=$(x86_64-w64-mingw32-gcc --version | awk 'NR == 1 { print; exit }')
MESON_VERSION=$(meson --version)
NINJA_VERSION=$(ninja --version)
BUILD_DATE=$(date -u +%FT%TZ)
BUILD_DIRECTORY=$WORK/build.w64

{
    printf 'base_commit=%s\n' "$BASE"
    printf 'patch_sha256=%s\n' "$(sha256sum "$PATCH" | awk '{print $1}')"
    printf 'cross_file_sha256=%s\n' "$CROSS_FILE_SHA256"
    printf 'meson_version=%s\n' "$MESON_VERSION"
    printf 'ninja_version=%s\n' "$NINJA_VERSION"
    printf 'mingw_compiler=%s\n' "$MINGW_COMPILER"
    printf 'build_date=%s\n' "$BUILD_DATE"
    printf 'source_directory=%s\n' "$WORK"
    printf 'build_directory=%s\n' "$BUILD_DIRECTORY"
    printf 'output_directory=%s\n' "$OUTPUT"
} > "$OUTPUT/BUILD-METADATA"

printf 'Built and verified: %s\n' "$OUTPUT"
