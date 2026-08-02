# This file replaces the loose DWrite marker check with provenance-bound
# validation. An artifact is reusable only when it was built from the current
# pinned Wine baseline and the current DWrite patch contents.

functions --erase dwrite_artifact_valid

function dwrite_provenance_value --argument-names key
    set -l provenance "$DWRITE_CLEAN_WORK/PROVENANCE.txt"

    test -s "$provenance"
    or return 1

    set -l matches (grep -E "^$key=" "$provenance")
    set -l grep_status $status

    test $grep_status -eq 0
    and test (count $matches) -eq 1
    or return 1

    string replace -r '^[^=]+=' '' -- "$matches[1]"
end

function dwrite_artifact_valid
    set -l expected_wine_commit \
        31af7f983b2e345d11340b120ae3a39d88c9338a
    set -l expected_layout_blob \
        aefb49296b350c94372a3c793b1cafc7c2672e87
    set -l patch_1 \
        "$REPO/patches/wine/0001-implement-dwrite-hit-testing.patch"
    set -l patch_2 \
        "$REPO/patches/wine/0002-harden-dwrite-hittestpoint.patch"

    test -s "$BUILT_DWRITE"
    and test -s "$DWRITE_CLEAN_WORK/PROVENANCE.txt"
    and test -s "$patch_1"
    and test -s "$patch_2"
    or return 1

    checksum_directory "$DWRITE_CLEAN_WORK" SHA256SUMS
    or return 1

    file "$BUILT_DWRITE" | grep -q 'PE32+'
    or return 1

    set -l expected_patch_1_sha (file_sha256 "$patch_1")
    set -l patch_1_status $status
    set -l expected_patch_2_sha (file_sha256 "$patch_2")
    set -l patch_2_status $status
    set -l expected_dwrite_sha (file_sha256 "$BUILT_DWRITE")
    set -l dwrite_status $status

    test $patch_1_status -eq 0
    and test $patch_2_status -eq 0
    and test $dwrite_status -eq 0
    or return 1

    set -l actual_wine_commit \
        (dwrite_provenance_value WINE_COMMIT)
    set -l actual_wine_status $status
    set -l actual_layout_blob \
        (dwrite_provenance_value BASELINE_LAYOUT_BLOB)
    set -l actual_layout_status $status
    set -l actual_patch_1_sha \
        (dwrite_provenance_value PATCH_1_SHA256)
    set -l actual_patch_1_status $status
    set -l actual_patch_2_sha \
        (dwrite_provenance_value PATCH_2_SHA256)
    set -l actual_patch_2_status $status
    set -l actual_dwrite_sha \
        (dwrite_provenance_value DWRITE_SHA256)
    set -l actual_dwrite_status $status
    set -l actual_dwrite_path \
        (dwrite_provenance_value DWRITE_PATH)
    set -l actual_path_status $status

    test $actual_wine_status -eq 0
    and test $actual_layout_status -eq 0
    and test $actual_patch_1_status -eq 0
    and test $actual_patch_2_status -eq 0
    and test $actual_dwrite_status -eq 0
    and test $actual_path_status -eq 0
    or return 1

    test "$actual_wine_commit" = "$expected_wine_commit"
    and test "$actual_layout_blob" = "$expected_layout_blob"
    and test "$actual_patch_1_sha" = "$expected_patch_1_sha"
    and test "$actual_patch_2_sha" = "$expected_patch_2_sha"
    and test "$actual_dwrite_sha" = "$expected_dwrite_sha"
    and test "$actual_dwrite_path" = "$BUILT_DWRITE"
    or return 1

    for marker in \
        'No effective run for text position' \
        'Using synthetic caret for text position'

        grep -aFq -- "$marker" "$BUILT_DWRITE"
        or return 1
    end

    return 0
end
