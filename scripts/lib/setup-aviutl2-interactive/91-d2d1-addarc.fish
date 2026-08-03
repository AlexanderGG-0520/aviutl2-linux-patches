# Add the patched Direct2D AddArc artifact to the existing clean Wine build,
# runner installation, provenance checks, and artifact pipeline.

set -g D2D1_ADDARC_MARKER \
    'AviUtl2 AddArc compatibility: converted arc to %u cubic Bezier segments.'

functions -c configure_paths configure_paths_without_d2d1
functions --erase configure_paths

function configure_paths
    configure_paths_without_d2d1

    set -g BUILT_D2D1 \
        "$DWRITE_CLEAN_WORK/build/dlls/d2d1/x86_64-windows/d2d1.dll"
end

function d2d1_provenance_value --argument-names key
    set -l provenance "$DWRITE_CLEAN_WORK/D2D1-PROVENANCE.txt"

    test -s "$provenance"
    or return 1

    set -l matches (grep -E "^$key=" "$provenance")
    set -l grep_status $status

    test $grep_status -eq 0
    and test (count $matches) -eq 1
    or return 1

    string replace -r '^[^=]+=' '' -- "$matches[1]"
end

function d2d1_artifact_valid
    set -l expected_wine_commit \
        31af7f983b2e345d11340b120ae3a39d88c9338a
    set -l expected_geometry_blob \
        633919afa4fd73818522336f8c6e0d0fb7e77fda
    set -l patch_file \
        "$REPO/patches/wine/0003-implement-d2d-addarc.patch"

    test -s "$BUILT_D2D1"
    and test -s "$DWRITE_CLEAN_WORK/D2D1-PROVENANCE.txt"
    and test -s "$patch_file"
    or return 1

    checksum_directory "$DWRITE_CLEAN_WORK" D2D1-SHA256SUMS
    or return 1

    file "$BUILT_D2D1" | grep -q 'PE32+'
    or return 1

    grep -aFq -- "$D2D1_ADDARC_MARKER" "$BUILT_D2D1"
    or return 1

    set -l expected_patch_sha (file_sha256 "$patch_file")
    set -l patch_status $status
    set -l expected_d2d1_sha (file_sha256 "$BUILT_D2D1")
    set -l d2d1_status $status

    test $patch_status -eq 0
    and test $d2d1_status -eq 0
    or return 1

    set -l actual_wine_commit (d2d1_provenance_value WINE_COMMIT)
    set -l wine_status $status
    set -l actual_geometry_blob (d2d1_provenance_value BASELINE_GEOMETRY_BLOB)
    set -l geometry_status $status
    set -l actual_patch_sha (d2d1_provenance_value D2D1_PATCH_SHA256)
    set -l actual_patch_status $status
    set -l actual_d2d1_sha (d2d1_provenance_value D2D1_SHA256)
    set -l actual_d2d1_status $status
    set -l actual_d2d1_path (d2d1_provenance_value D2D1_PATH)
    set -l path_status $status

    test $wine_status -eq 0
    and test $geometry_status -eq 0
    and test $actual_patch_status -eq 0
    and test $actual_d2d1_status -eq 0
    and test $path_status -eq 0
    or return 1

    test "$actual_wine_commit" = "$expected_wine_commit"
    and test "$actual_geometry_blob" = "$expected_geometry_blob"
    and test "$actual_patch_sha" = "$expected_patch_sha"
    and test "$actual_d2d1_sha" = "$expected_d2d1_sha"
    and test "$actual_d2d1_path" = "$BUILT_D2D1"
end

function build_d2d1
    note 'patched D2D1 AddArcをclean Wine treeからbuildする'

    if d2d1_artifact_valid
        success "verified D2D1 artifact already exists: $BUILT_D2D1"
        return 0
    end

    dwrite_artifact_valid
    or build_dwrite

    set -l geometry_file \
        "$DWRITE_CLEAN_WORK/source/dlls/d2d1/geometry.c"

    if test -s "$geometry_file"; and grep -Fq -- "$D2D1_ADDARC_MARKER" "$geometry_file"
        warn 'existing Wine source already contains a stale or incomplete D2D1 AddArc patch'

        ask_yes_no 'DWrite clean work全体を退避してDWrite/D2D1を再buildしますか？' yes
        or die 'invalid D2D1 source tree was not replaced'

        archive_existing "$DWRITE_CLEAN_WORK" invalid-d2d1
        build_dwrite
    end

    fish \
        "$REPO/scripts/build-d2d1-addarc.fish" \
        "$DWRITE_CLEAN_WORK" \
        "$JOBS"
    or die 'D2D1 AddArc clean build failed'

    d2d1_artifact_valid
    or die 'D2D1 AddArc artifact validation failed after build'

    success "D2D1 AddArc built: $BUILT_D2D1"
end

functions -c ge_runner_complete ge_runner_complete_without_d2d1
functions --erase ge_runner_complete

function ge_runner_complete --argument-names ge_root
    ge_runner_complete_without_d2d1 "$ge_root"
    and test -f "$ge_root/files/lib/wine/x86_64-windows/d2d1.dll"
end

functions -c runtime_runner_valid runtime_runner_valid_without_d2d1
functions --erase runtime_runner_valid

function runtime_runner_valid
    runtime_runner_valid_without_d2d1
    or return 1

    d2d1_artifact_valid
    or return 1

    set -l installed_d2d1 \
        "$GE_PROTON_ROOT/files/lib/wine/x86_64-windows/d2d1.dll"

    test -s "$installed_d2d1"
    and cmp --silent -- "$BUILT_D2D1" "$installed_d2d1"
    and grep -aFq -- "$D2D1_ADDARC_MARKER" "$installed_d2d1"
end

functions --erase prepare_runtime_runner

function prepare_runtime_runner
    note 'patched DWrite / D2D1入りGE-Proton runnerを作成・検証する'

    dwrite_artifact_valid
    or die 'DWrite artifact must be built first'

    d2d1_artifact_valid
    or die 'D2D1 AddArc artifact must be built first'

    if runtime_runner_valid
        success "runtime runner already contains verified DWrite and D2D1: $GE_PROTON_ROOT"
        return 0
    end

    if test "$GE_PROTON_ROOT" = "$GE_PATCHED"
        prepare_ge_proton_stock

        if test -e "$GE_PATCHED"
            warn "existing patched runner does not match verified DWrite/D2D1: $GE_PATCHED"

            ask_yes_no '既存patched runnerを退避し、stock runnerから作り直しますか？' yes
            or die 'runtime runner mismatch was not resolved'

            archive_existing "$GE_PATCHED" before-wine-graphics
        end

        cp -a --reflink=auto "$GE_STOCK" "$GE_PATCHED"
        or die 'failed to copy stock GE-Proton runner'

        fish \
            "$REPO/scripts/install-dwrite.fish" \
            "$DWRITE_CLEAN_WORK/build" \
            "$GE_PATCHED"
        or die 'failed to install DWrite into patched runner'

        fish \
            "$REPO/scripts/install-d2d1.fish" \
            "$DWRITE_CLEAN_WORK/build" \
            "$GE_PATCHED"
        or die 'failed to install D2D1 into patched runner'
    else
        ge_runner_complete "$GE_PROTON_ROOT"
        or die "custom GE-Proton root is incomplete: $GE_PROTON_ROOT"

        warn "custom runnerへpatched dwrite.dll / d2d1.dllを導入します: $GE_PROTON_ROOT"
        ask_yes_no 'backupを作成して両DLLを導入しますか？' no
        or die 'custom runner was not modified'

        fish \
            "$REPO/scripts/install-dwrite.fish" \
            "$DWRITE_CLEAN_WORK/build" \
            "$GE_PROTON_ROOT"
        or die 'failed to install DWrite into custom runner'

        fish \
            "$REPO/scripts/install-d2d1.fish" \
            "$DWRITE_CLEAN_WORK/build" \
            "$GE_PROTON_ROOT"
        or die 'failed to install D2D1 into custom runner'
    end

    runtime_runner_valid
    or die 'runtime runner does not contain the verified DWrite/D2D1 artifacts'

    sha256sum \
        "$BUILT_DWRITE" \
        "$GE_PROTON_ROOT/files/lib/wine/x86_64-windows/dwrite.dll" \
        "$BUILT_D2D1" \
        "$GE_PROTON_ROOT/files/lib/wine/x86_64-windows/d2d1.dll"

    success "verified runtime runner: $GE_PROTON_ROOT"
end

functions -c validate_installation_repository validate_installation_repository_without_d2d1
functions --erase validate_installation_repository

function validate_installation_repository
    validate_installation_repository_without_d2d1

    for path in \
        "$REPO/patches/wine/0003-implement-d2d-addarc.patch" \
        "$REPO/scripts/build-d2d1-addarc.fish" \
        "$REPO/scripts/install-d2d1.fish"

        require_path "$path"
    end

    for script in \
        "$REPO/scripts/build-d2d1-addarc.fish" \
        "$REPO/scripts/install-d2d1.fish"

        fish -n "$script"
        or die "invalid Fish syntax: $script"
    end

    grep -Fq -- "$D2D1_ADDARC_MARKER" \
        "$REPO/patches/wine/0003-implement-d2d-addarc.patch"
    or die 'D2D1 patch is missing the AddArc compatibility marker'

    success 'D2D1 AddArc repository requirements validated'
end

functions --erase run_artifact_pipeline

function run_artifact_pipeline
    install_dependencies
    verify_required_commands
    validate_repository
    prepare_ge_proton_stock
    build_dwrite
    build_d2d1
    prepare_runtime_runner
    prepare_aviutl2
    build_dxvk
    prepare_fonts
    prepare_nvidia
    build_lsmash
    prepare_dxvk_config
    artifact_preflight
end
