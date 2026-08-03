#!/usr/bin/env fish

function usage
    echo 'Usage: build-d2d1-addarc.fish DWRITE_CLEAN_WORK [JOBS]' >&2
end

function fail
    echo "ERROR: $argv" >&2
    return 1
end

function require_command --argument-names command_name
    command -q "$command_name"
    or begin
        fail "required command is missing: $command_name"
        return 1
    end
end

function run_logged
    set -l log_file "$argv[1]"
    set -e argv[1]

    $argv 2>&1 | tee "$log_file"
    set -l command_status $pipestatus[1]

    if test $command_status -ne 0
        fail "command failed with status $command_status; see $log_file"
        return $command_status
    end
end

function provenance_value --argument-names file key
    set -l matches (grep -E "^$key=" "$file" 2>/dev/null)
    test $status -eq 0
    and test (count $matches) -eq 1
    or return 1

    string replace -r '^[^=]+=' '' -- "$matches[1]"
end

function main
    if test (count $argv) -lt 1; or test (count $argv) -gt 2
        usage
        return 64
    end

    for command_name in \
        file \
        git \
        grep \
        make \
        patch \
        realpath \
        sha256sum \
        strings \
        tee

        require_command "$command_name"
        or return 69
    end

    set -l jobs
    if test (count $argv) -eq 2
        set jobs "$argv[2]"
    else
        require_command nproc
        or return 69
        set jobs (nproc)
    end

    string match -rq '^[1-9][0-9]*$' -- "$jobs"
    or begin
        fail "JOBS must be a positive integer: $jobs"
        return 64
    end

    set -l script_path (status --current-filename)
    set -l script_dir (dirname "$script_path")
    set -l repo_root (realpath "$script_dir/..")
    set -l work_dir (realpath "$argv[1]")

    test -n "$work_dir"
    and test "$work_dir" != '/'
    and test "$work_dir" != "$HOME"
    or begin
        fail "unsafe DWrite clean work path: $work_dir"
        return 64
    end

    set -l expected_wine_commit \
        31af7f983b2e345d11340b120ae3a39d88c9338a
    set -l baseline_geometry_blob \
        633919afa4fd73818522336f8c6e0d0fb7e77fda

    set -l source_dir "$work_dir/source"
    set -l build_dir "$work_dir/build"
    set -l log_dir "$work_dir/logs"
    set -l dwrite_provenance "$work_dir/PROVENANCE.txt"
    set -l geometry_file "$source_dir/dlls/d2d1/geometry.c"
    set -l patch_file \
        "$repo_root/patches/wine/0003-implement-d2d-addarc.patch"
    set -l built_d2d1 \
        "$build_dir/dlls/d2d1/x86_64-windows/d2d1.dll"
    set -l marker \
        'AviUtl2 AddArc compatibility: converted arc to %u cubic Bezier segments.'

    for path in \
        "$source_dir" \
        "$build_dir" \
        "$geometry_file" \
        "$patch_file" \
        "$dwrite_provenance"

        test -e "$path"
        or begin
            fail "required DWrite clean-build path is missing: $path"
            return 66
        end
    end

    set -l provenance_commit \
        (provenance_value "$dwrite_provenance" WINE_COMMIT)
    test $status -eq 0
    and test "$provenance_commit" = "$expected_wine_commit"
    or begin
        fail 'DWrite clean work was not produced from the pinned Wine commit'
        return 1
    end

    mkdir -p "$log_dir"
    or return 1

    if not grep -Fq -- "$marker" "$geometry_file"
        set -l actual_geometry_blob (git hash-object -- "$geometry_file")
        test "$actual_geometry_blob" = "$baseline_geometry_blob"
        or begin
            fail "unexpected Wine D2D1 geometry baseline blob: expected $baseline_geometry_blob, got $actual_geometry_blob"
            return 1
        end

        patch \
            --directory="$source_dir" \
            --strip=1 \
            --dry-run \
            < "$patch_file"
        or begin
            fail "D2D1 AddArc patch dry-run failed: $patch_file"
            return 1
        end

        patch \
            --directory="$source_dir" \
            --strip=1 \
            < "$patch_file"
        or begin
            fail "D2D1 AddArc patch application failed: $patch_file"
            return 1
        end
    end

    test ! -e "$geometry_file.rej"
    or begin
        fail "D2D1 patch reject exists: $geometry_file.rej"
        return 1
    end

    for source_marker in \
        d2d_arc_evaluate \
        "$marker"

        grep -Fq -- "$source_marker" "$geometry_file"
        or begin
            fail "patched D2D1 source marker is missing: $source_marker"
            return 1
        end
    end

    rm -f -- \
        "$build_dir/dlls/d2d1/geometry.o" \
        "$build_dir/dlls/d2d1/x86_64-windows/geometry.o" \
        "$built_d2d1"
    or return 1

    run_logged \
        "$log_dir/build-d2d1.log" \
        make \
        -C "$build_dir" \
        -j"$jobs" \
        dlls/d2d1/x86_64-windows/d2d1.dll
    or return $status

    test -s "$built_d2d1"
    or begin
        fail "patched d2d1.dll was not generated: $built_d2d1"
        return 66
    end

    file -- "$built_d2d1" \
        | tee "$log_dir/d2d1-file.log"
    or return 1

    for file_marker in \
        'PE32+ executable' \
        '(DLL)' \
        'x86-64'

        grep -Fq -- "$file_marker" "$log_dir/d2d1-file.log"
        or begin
            fail "d2d1.dll is missing file marker: $file_marker"
            return 1
        end
    end

    strings -a -- "$built_d2d1" \
        | grep -Fq -- "$marker"
    or begin
        fail 'patched AddArc marker was not embedded in d2d1.dll'
        return 1
    end

    set -l patch_sha (sha256sum -- "$patch_file" | string split ' ')[1]
    set -l d2d1_sha (sha256sum -- "$built_d2d1" | string split ' ')[1]
    set -l repo_commit unknown

    if test -d "$repo_root/.git"
        set repo_commit (git -C "$repo_root" rev-parse HEAD 2>/dev/null)
        or set repo_commit unknown
    end

    printf '%s\n' \
        "WINE_COMMIT=$expected_wine_commit" \
        "BASELINE_GEOMETRY_BLOB=$baseline_geometry_blob" \
        "REPOSITORY_COMMIT=$repo_commit" \
        "D2D1_PATCH_SHA256=$patch_sha" \
        "D2D1_SHA256=$d2d1_sha" \
        "D2D1_PATH=$built_d2d1" \
        > "$work_dir/D2D1-PROVENANCE.txt"
    or return 1

    sha256sum -- "$built_d2d1" \
        > "$work_dir/D2D1-SHA256SUMS"
    or return 1

    echo
    echo 'Clean D2D1 AddArc build completed.'
    echo "D2D1_PATH=$built_d2d1"
    echo "D2D1_SHA256=$d2d1_sha"
    echo "PROVENANCE=$work_dir/D2D1-PROVENANCE.txt"
    echo "SHA256SUMS=$work_dir/D2D1-SHA256SUMS"
end

main $argv
exit $status
