#!/usr/bin/env bash
set -Eeuo pipefail

WINE_COMMIT="31af7f983b2e345d11340b120ae3a39d88c9338a"
JOBS="$(nproc)"
WORK_DIR=""
OUTPUT_DIR=""
RUNNER_ROOT=""
REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"

usage() {
    cat <<'EOF'
Usage:
  build-dwrite-clean-room.sh --work-dir DIR --output-dir DIR [options]

Required:
  --work-dir DIR      Disposable clean-room workspace. It is deleted first.
  --output-dir DIR    Destination for dwrite.dll and SHA256SUMS.

Optional:
  --runner-root DIR   Install the built PE dwrite.dll into this GE-Proton runner.
  --jobs N            Parallel build jobs. Default: nproc.
  --wine-commit SHA   Wine commit. Default is the verified Wine 11.0 commit.
  --repo-root DIR     Repository root containing patches/ and scripts/.
  -h, --help          Show this help.
EOF
}

fail() {
    printf 'ERROR: %s\n' "$*" >&2
    exit 1
}

while (($#)); do
    case "$1" in
        --work-dir)
            (($# >= 2)) || fail "--work-dir requires a value"
            WORK_DIR="$2"
            shift 2
            ;;
        --output-dir)
            (($# >= 2)) || fail "--output-dir requires a value"
            OUTPUT_DIR="$2"
            shift 2
            ;;
        --runner-root)
            (($# >= 2)) || fail "--runner-root requires a value"
            RUNNER_ROOT="$2"
            shift 2
            ;;
        --jobs)
            (($# >= 2)) || fail "--jobs requires a value"
            JOBS="$2"
            shift 2
            ;;
        --wine-commit)
            (($# >= 2)) || fail "--wine-commit requires a value"
            WINE_COMMIT="$2"
            shift 2
            ;;
        --repo-root)
            (($# >= 2)) || fail "--repo-root requires a value"
            REPO_ROOT="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            fail "unknown argument: $1"
            ;;
    esac
done

[[ -n "$WORK_DIR" ]] || fail "--work-dir is required"
[[ -n "$OUTPUT_DIR" ]] || fail "--output-dir is required"
[[ "$WORK_DIR" != "/" ]] || fail "refusing to use / as work directory"
[[ "$OUTPUT_DIR" != "/" ]] || fail "refusing to use / as output directory"
[[ "$JOBS" =~ ^[1-9][0-9]*$ ]] || fail "--jobs must be a positive integer"

for command in git patch autoconf make sha256sum file; do
    command -v "$command" >/dev/null 2>&1 || fail "missing command: $command"
done

PATCH_1="$REPO_ROOT/patches/wine/0001-implement-dwrite-hit-testing.patch"
PATCH_2="$REPO_ROOT/patches/wine/0002-harden-dwrite-hittestpoint.patch"
INSTALL_SCRIPT="$REPO_ROOT/scripts/install-dwrite.fish"

[[ -f "$PATCH_1" ]] || fail "missing patch: $PATCH_1"
[[ -f "$PATCH_2" ]] || fail "missing patch: $PATCH_2"

SOURCE_DIR="$WORK_DIR/source"
BUILD_DIR="$WORK_DIR/build"
LOG_DIR="$WORK_DIR/logs"
CONFIGURE_LOG="$LOG_DIR/configure.log"
BUILD_LOG="$LOG_DIR/build.log"
BUILT_DWRITE="$BUILD_DIR/dlls/dwrite/x86_64-windows/dwrite.dll"

rm -rf -- "$WORK_DIR"
mkdir -p -- "$SOURCE_DIR" "$BUILD_DIR" "$LOG_DIR" "$OUTPUT_DIR"

printf '==> Fetching Wine commit %s into a clean source tree\n' "$WINE_COMMIT"
git -C "$SOURCE_DIR" init --quiet
git -C "$SOURCE_DIR" remote add origin https://github.com/ValveSoftware/wine.git
git -C "$SOURCE_DIR" fetch --quiet --depth=1 origin "$WINE_COMMIT"
git -C "$SOURCE_DIR" checkout --quiet --detach FETCH_HEAD

ACTUAL_COMMIT="$(git -C "$SOURCE_DIR" rev-parse HEAD)"
[[ "$ACTUAL_COMMIT" == "$WINE_COMMIT" ]] || fail "Wine commit mismatch: $ACTUAL_COMMIT"
grep -Fq 'stable release Wine 11.0' "$SOURCE_DIR/ANNOUNCE.md" \
    || fail "source tree is not the expected Wine 11.0 tree"

printf '==> Validating and applying repository patches\n'
for patch_file in "$PATCH_1" "$PATCH_2"; do
    patch --directory="$SOURCE_DIR" --strip=1 --dry-run < "$patch_file"
    patch --directory="$SOURCE_DIR" --strip=1 < "$patch_file"
done

if find "$SOURCE_DIR" -type f \( -name '*.rej' -o -name '*.orig' \) -print -quit | grep -q .; then
    find "$SOURCE_DIR" -type f \( -name '*.rej' -o -name '*.orig' \) -print >&2
    fail "patch reject or backup file exists"
fi

grep -Fq 'layout_get_erun_for_position' "$SOURCE_DIR/dlls/dwrite/layout.c" \
    || fail "HitTestTextPosition implementation marker is missing"
if grep -A6 -F 'dwritetextlayout_HitTestTextPosition' "$SOURCE_DIR/dlls/dwrite/layout.c" \
    | grep -Fq 'return E_NOTIMPL'; then
    fail "HitTestTextPosition is still a stub after patching"
fi

printf '==> Generating configure script\n'
(
    cd "$SOURCE_DIR"
    ./autogen.sh
)

printf '==> Configuring an out-of-tree x86_64 Wine build\n'
(
    cd "$BUILD_DIR"
    "$SOURCE_DIR/configure" --enable-archs=x86_64
) 2>&1 | tee "$CONFIGURE_LOG"

printf '==> Building only the PE dwrite.dll target\n'
make -C "$BUILD_DIR" -j"$JOBS" \
    dlls/dwrite/x86_64-windows/dwrite.dll \
    2>&1 | tee "$BUILD_LOG"

[[ -f "$BUILT_DWRITE" ]] || fail "dwrite.dll was not generated: $BUILT_DWRITE"
file "$BUILT_DWRITE"

install -m 0644 "$BUILT_DWRITE" "$OUTPUT_DIR/dwrite.dll"
(
    cd "$OUTPUT_DIR"
    sha256sum dwrite.dll > SHA256SUMS
    sha256sum -c SHA256SUMS
)

cat > "$OUTPUT_DIR/BUILD-METADATA.txt" <<EOF
WINE_COMMIT=$WINE_COMMIT
SOURCE_DIR=$SOURCE_DIR
BUILD_DIR=$BUILD_DIR
BUILT_DWRITE=$BUILT_DWRITE
PATCH_1_SHA256=$(sha256sum "$PATCH_1" | awk '{print $1}')
PATCH_2_SHA256=$(sha256sum "$PATCH_2" | awk '{print $1}')
DWRITE_SHA256=$(sha256sum "$OUTPUT_DIR/dwrite.dll" | awk '{print $1}')
EOF

if [[ -n "$RUNNER_ROOT" ]]; then
    command -v fish >/dev/null 2>&1 || fail "fish is required with --runner-root"
    [[ -d "$RUNNER_ROOT" ]] || fail "runner root does not exist: $RUNNER_ROOT"
    [[ -f "$INSTALL_SCRIPT" ]] || fail "missing installer: $INSTALL_SCRIPT"

    printf '==> Installing dwrite.dll into runner: %s\n' "$RUNNER_ROOT"
    fish "$INSTALL_SCRIPT" "$BUILD_DIR" "$RUNNER_ROOT"

    RUNNER_DWRITE="$RUNNER_ROOT/files/lib/wine/x86_64-windows/dwrite.dll"
    [[ -f "$RUNNER_DWRITE" ]] || fail "runner dwrite.dll is missing after install"
    cmp --silent "$BUILT_DWRITE" "$RUNNER_DWRITE" \
        || fail "runner dwrite.dll differs from build output"
    sha256sum "$BUILT_DWRITE" "$RUNNER_DWRITE"
fi

printf 'CLEAN_ROOM_DWRITE_BUILD_OK=1\n'
printf 'OUTPUT_DWRITE=%s\n' "$OUTPUT_DIR/dwrite.dll"
printf 'OUTPUT_SHA256=%s\n' "$(sha256sum "$OUTPUT_DIR/dwrite.dll" | awk '{print $1}')"
