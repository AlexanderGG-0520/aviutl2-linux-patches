#!/usr/bin/env fish

function usage
    echo "Usage: build-dwrite-clean.fish WORK_DIR [JOBS]" >&2
end

function fail
    echo "ERROR: $argv" >&2
    return 1
end

function require_command
    if not type -q "$argv[1]"
        fail "required command is missing: $argv[1]"
        return 1
    end
end

function run_logged
    set -l LOG_FILE "$argv[1]"
    set -e argv[1]

    $argv 2>&1 | tee "$LOG_FILE"
    set -l COMMAND_STATUS $pipestatus[1]

    if test $COMMAND_STATUS -ne 0
        fail "command failed with status $COMMAND_STATUS; see $LOG_FILE"
        return $COMMAND_STATUS
    end
end

function main
    if test (count $argv) -lt 1; or test (count $argv) -gt 2
        usage
        return 64
    end

    for command in \
        autoreconf \
        curl \
        file \
        git \
        grep \
        make \
        patch \
        realpath \
        sha256sum \
        strings \
        tar \
        tee \
        x86_64-w64-mingw32-gcc

        require_command "$command"
        or return 69
    end

    set -l JOBS
    if test (count $argv) -eq 2
        set JOBS "$argv[2]"
    else
        require_command nproc
        or return 69
        set JOBS (nproc)
    end

    string match --quiet --regex '^[1-9][0-9]*$' "$JOBS"
    or begin
        fail "JOBS must be a positive integer: $JOBS"
        return 64
    end

    set -l SCRIPT_PATH (status --current-filename)
    set -l SCRIPT_DIR (dirname "$SCRIPT_PATH")
    set -l REPO_ROOT (realpath "$SCRIPT_DIR/..")
    set -l WORK_DIR (realpath --canonicalize-missing "$argv[1]")

    if test -z "$WORK_DIR"; or test "$WORK_DIR" = "/"; or test "$WORK_DIR" = "$HOME"
        fail "unsafe WORK_DIR: $WORK_DIR"
        return 64
    end

    set -l WINE_COMMIT \
        31af7f983b2e345d11340b120ae3a39d88c9338a

    set -l BASELINE_LAYOUT_BLOB \
        aefb49296b350c94372a3c793b1cafc7c2672e87

    set -l DOWNLOAD_DIR "$WORK_DIR/downloads"
    set -l LOG_DIR "$WORK_DIR/logs"
    set -l WINE_ARCHIVE "$DOWNLOAD_DIR/wine-$WINE_COMMIT.tar.gz"
    set -l WINE_SRC "$WORK_DIR/source"
    set -l WINE_BUILD "$WORK_DIR/build"

    set -l PATCH_1 \
        "$REPO_ROOT/patches/wine/0001-implement-dwrite-hit-testing.patch"

    set -l PATCH_2 \
        "$REPO_ROOT/patches/wine/0002-harden-dwrite-hittestpoint.patch"

    for path in "$PATCH_1" "$PATCH_2"
        if not test -s "$path"
            fail "missing or empty patch: $path"
            return 66
        end
    end

    mkdir -p "$DOWNLOAD_DIR" "$LOG_DIR"
    or return 1

    if not test -s "$WINE_ARCHIVE"
        set -l PARTIAL_ARCHIVE "$WINE_ARCHIVE.part"
        rm -f -- "$PARTIAL_ARCHIVE"

        curl \
            --fail \
            --location \
            --retry 3 \
            --output "$PARTIAL_ARCHIVE" \
            "https://github.com/ValveSoftware/wine/archive/$WINE_COMMIT.tar.gz"
        or begin
            rm -f -- "$PARTIAL_ARCHIVE"
            return 1
        end

        tar --gzip --list --file "$PARTIAL_ARCHIVE" >/dev/null
        or begin
            rm -f -- "$PARTIAL_ARCHIVE"
            fail "downloaded Wine archive is invalid"
            return 1
        end

        mv -- "$PARTIAL_ARCHIVE" "$WINE_ARCHIVE"
        or return 1
    else
        tar --gzip --list --file "$WINE_ARCHIVE" >/dev/null
        or begin
            fail "cached Wine archive is invalid: $WINE_ARCHIVE"
            return 1
        end
    end

    if test "$WINE_SRC" != "$WORK_DIR/source"; or test "$WINE_BUILD" != "$WORK_DIR/build"
        fail "internal clean-directory guard failed"
        return 1
    end

    rm -rf -- "$WINE_SRC" "$WINE_BUILD"
    or return 1

    mkdir -p "$WINE_SRC" "$WINE_BUILD"
    or return 1

    tar \
        --extract \
        --gzip \
        --file "$WINE_ARCHIVE" \
        --directory "$WINE_SRC" \
        --strip-components=1
    or return 1

    set -l LAYOUT_FILE "$WINE_SRC/dlls/dwrite/layout.c"

    if not test -s "$LAYOUT_FILE"
        fail "Wine DWrite source is missing: $LAYOUT_FILE"
        return 66
    end

    set -l ACTUAL_LAYOUT_BLOB (git hash-object -- "$LAYOUT_FILE")
    if test "$ACTUAL_LAYOUT_BLOB" != "$BASELINE_LAYOUT_BLOB"
        fail "unexpected Wine DWrite baseline blob: expected $BASELINE_LAYOUT_BLOB, got $ACTUAL_LAYOUT_BLOB"
        return 1
    end

    grep --quiet --fixed-strings \
        'stable release Wine 11.0' \
        "$WINE_SRC/ANNOUNCE.md"
    or begin
        fail "the extracted source is not the expected Wine 11.0 tree"
        return 1
    end

    for patch_file in "$PATCH_1" "$PATCH_2"
        patch \
            --directory="$WINE_SRC" \
            --strip=1 \
            --dry-run \
            < "$patch_file"
        or begin
            fail "patch dry-run failed: $patch_file"
            return 1
        end

        patch \
            --directory="$WINE_SRC" \
            --strip=1 \
            < "$patch_file"
        or begin
            fail "patch application failed: $patch_file"
            return 1
        end
    end

    set -l REJECT_FILE "$WINE_SRC/dlls/dwrite/layout.c.rej"
    if test -e "$REJECT_FILE"
        fail "DWrite patch reject exists: $REJECT_FILE"
        return 1
    end

    for marker in \
        layout_get_erun_for_position \
        'No effective run for text position' \
        dwritetextlayout_HitTestTextRange

        grep --quiet --fixed-strings "$marker" "$LAYOUT_FILE"
        or begin
            fail "patched source marker is missing: $marker"
            return 1
        end
    end

    pushd "$WINE_SRC" >/dev/null
    or return 1

    run_logged \
        "$LOG_DIR/autogen.log" \
        ./autogen.sh
    set -l AUTOGEN_STATUS $status

    popd >/dev/null

    test $AUTOGEN_STATUS -eq 0
    or return $AUTOGEN_STATUS

    pushd "$WINE_BUILD" >/dev/null
    or return 1

    run_logged \
        "$LOG_DIR/configure.log" \
        "$WINE_SRC/configure" \
        --enable-archs=x86_64
    set -l CONFIGURE_STATUS $status

    popd >/dev/null

    test $CONFIGURE_STATUS -eq 0
    or return $CONFIGURE_STATUS

    set -l BUILT_DWRITE \
        "$WINE_BUILD/dlls/dwrite/x86_64-windows/dwrite.dll"

    rm -f -- \
        "$WINE_BUILD/dlls/dwrite/x86_64-windows/layout.o" \
        "$BUILT_DWRITE"
    or return 1

    run_logged \
        "$LOG_DIR/build.log" \
        make \
        -C "$WINE_BUILD" \
        -j"$JOBS" \
        dlls/dwrite/x86_64-windows/dwrite.dll
    or return $status

    if not test -s "$BUILT_DWRITE"
        fail "patched dwrite.dll was not generated: $BUILT_DWRITE"
        return 66
    end

    file -- "$BUILT_DWRITE" \
        | tee "$LOG_DIR/file.log"
    or return 1

    for file_marker in \
        'PE32+ executable' \
        '(DLL)' \
        'x86-64'

        grep --quiet --fixed-strings \
            "$file_marker" \
            "$LOG_DIR/file.log"
        or begin
            fail "build output is missing file marker: $file_marker"
            return 1
        end
    end

    strings -a -- "$BUILT_DWRITE" \
        | grep --quiet --fixed-strings \
            'No effective run for text position'
    or begin
        fail "patched DWrite marker was not embedded in the DLL"
        return 1
    end

    set -l REPO_COMMIT unknown
    if test -d "$REPO_ROOT/.git"
        set REPO_COMMIT (git -C "$REPO_ROOT" rev-parse HEAD 2>/dev/null)
        or set REPO_COMMIT unknown
    end

    set -l PATCH_1_SHA (sha256sum -- "$PATCH_1" | string split ' ')[1]
    set -l PATCH_2_SHA (sha256sum -- "$PATCH_2" | string split ' ')[1]
    set -l DWRITE_SHA (sha256sum -- "$BUILT_DWRITE" | string split ' ')[1]

    printf '%s\n' \
        "WINE_COMMIT=$WINE_COMMIT" \
        "BASELINE_LAYOUT_BLOB=$BASELINE_LAYOUT_BLOB" \
        "REPOSITORY_COMMIT=$REPO_COMMIT" \
        "PATCH_1_SHA256=$PATCH_1_SHA" \
        "PATCH_2_SHA256=$PATCH_2_SHA" \
        "DWRITE_SHA256=$DWRITE_SHA" \
        "DWRITE_PATH=$BUILT_DWRITE" \
        > "$WORK_DIR/PROVENANCE.txt"
    or return 1

    sha256sum -- "$BUILT_DWRITE" \
        > "$WORK_DIR/SHA256SUMS"
    or return 1

    echo
    echo "Clean DWrite build completed."
    echo "DWRITE_PATH=$BUILT_DWRITE"
    echo "DWRITE_SHA256=$DWRITE_SHA"
    echo "PROVENANCE=$WORK_DIR/PROVENANCE.txt"
    echo "SHA256SUMS=$WORK_DIR/SHA256SUMS"

    return 0
end

main $argv
exit $status
