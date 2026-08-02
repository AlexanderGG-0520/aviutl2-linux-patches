# This file is sourced by scripts/setup-aviutl2-interactive.fish.

function prepare_ge_proton_stock
    note 'GE-Proton 11-1を取得・検証する'

    if ge_runner_complete "$GE_STOCK"
        success "stock GE-Proton already exists: $GE_STOCK"
        return 0
    end

    if test -e "$GE_STOCK"
        die "stock GE-Proton path exists but is incomplete: $GE_STOCK"
    end

    set -l download_dir "$ROOT/downloads/ge-proton11-1"
    set -l archive "$download_dir/GE-Proton11-1.tar.gz"
    set -l sums "$download_dir/GE-Proton11-1.sha512sum"

    mkdir -p "$download_dir" "$GE_BASE"
    or die 'failed to create GE-Proton directories'

    if not test -s "$archive"
        curl \
            --fail \
            --location \
            --retry 3 \
            --output "$archive.part" \
            'https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton11-1/GE-Proton11-1.tar.gz'
        or begin
            rm -f "$archive.part"
            die 'failed to download GE-Proton archive'
        end

        mv "$archive.part" "$archive"
        or die 'failed to finalize GE-Proton archive'
    end

    if not test -s "$sums"
        curl \
            --fail \
            --location \
            --retry 3 \
            --output "$sums.part" \
            'https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton11-1/GE-Proton11-1.sha512sum'
        or begin
            rm -f "$sums.part"
            die 'failed to download GE-Proton checksum'
        end

        mv "$sums.part" "$sums"
        or die 'failed to finalize GE-Proton checksum'
    end

    pushd "$download_dir" >/dev/null
    sha512sum -c (basename "$sums")
    set -l verify_status $status
    popd >/dev/null

    test $verify_status -eq 0
    or die 'GE-Proton SHA-512 verification failed'

    tar -xzf "$archive" -C "$GE_BASE"
    or die 'GE-Proton extraction failed'

    ge_runner_complete "$GE_STOCK"
    or die "extracted GE-Proton is incomplete: $GE_STOCK"

    success "GE-Proton ready: $GE_STOCK"
end

function build_dwrite
    note 'patched DWriteをclean buildする'

    if dwrite_artifact_valid
        success "verified DWrite artifact already exists: $BUILT_DWRITE"
        return 0
    end

    if test -e "$DWRITE_CLEAN_WORK"
        warn "existing DWrite work is not valid: $DWRITE_CLEAN_WORK"

        ask_yes_no '既存DWrite workを退避してclean buildしますか？' yes
        or die 'invalid DWrite work was not replaced'

        archive_existing "$DWRITE_CLEAN_WORK" invalid
    end

    fish \
        "$REPO/scripts/build-dwrite-clean.fish" \
        "$DWRITE_CLEAN_WORK" \
        "$JOBS"
    or die 'DWrite clean build failed'

    dwrite_artifact_valid
    or die 'DWrite artifact validation failed after build'

    success "DWrite built: $BUILT_DWRITE"
end

function prepare_runtime_runner
    note 'patched GE-Proton runnerを作成・内容検証する'

    dwrite_artifact_valid
    or die 'DWrite artifact must be built first'

    if runtime_runner_valid
        success "runtime runner already contains the verified DWrite: $GE_PROTON_ROOT"
        return 0
    end

    if test "$GE_PROTON_ROOT" = "$GE_PATCHED"
        prepare_ge_proton_stock

        if test -e "$GE_PATCHED"
            warn "existing patched runner does not match the verified DWrite: $GE_PATCHED"

            ask_yes_no '既存patched runnerを退避し、stock runnerから作り直しますか？' yes
            or die 'runtime runner mismatch was not resolved'

            archive_existing "$GE_PATCHED" before-dwrite
        end

        cp -a --reflink=auto "$GE_STOCK" "$GE_PATCHED"
        or die 'failed to copy stock GE-Proton runner'

        fish \
            "$REPO/scripts/install-dwrite.fish" \
            "$DWRITE_CLEAN_WORK/build" \
            "$GE_PATCHED"
        or die 'failed to install DWrite into patched runner'
    else
        ge_runner_complete "$GE_PROTON_ROOT"
        or die "custom GE-Proton root is incomplete: $GE_PROTON_ROOT"

        warn "custom runnerへpatched dwrite.dllを導入します: $GE_PROTON_ROOT"
        ask_yes_no 'install-dwrite.fishでbackupを作成して導入しますか？' no
        or die 'custom runner was not modified'

        fish \
            "$REPO/scripts/install-dwrite.fish" \
            "$DWRITE_CLEAN_WORK/build" \
            "$GE_PROTON_ROOT"
        or die 'failed to install DWrite into custom runner'
    end

    runtime_runner_valid
    or die 'runtime runner does not contain the verified DWrite artifact'

    sha256sum \
        "$BUILT_DWRITE" \
        "$GE_PROTON_ROOT/files/lib/wine/x86_64-windows/dwrite.dll"

    success "verified runtime runner: $GE_PROTON_ROOT"
end

function prepare_aviutl2
    note 'AviUtl2 2.1.3を取得する'

    if aviutl2_artifact_valid
        success "AviUtl2 artifact already exists: $AVIUTL2_SOURCE_DIR"
        return 0
    end

    if test -e "$AVIUTL2_SOURCE_DIR"
        ask_yes_no '不完全なAviUtl2 artifactを退避して再取得しますか？' yes
        or die 'invalid AviUtl2 artifact was not replaced'

        archive_existing "$AVIUTL2_SOURCE_DIR" invalid
    end

    set -l archive "$ROOT/downloads/aviutl2_v2.1.3.zip"
    set -l extract_dir "$ROOT/build/aviutl2-v2.1.3-extract"

    if not test -s "$archive"
        curl \
            --fail \
            --location \
            --retry 3 \
            --output "$archive.part" \
            'https://spring-fragrance.mints.ne.jp/aviutl/aviutl2_v2.1.3.zip'
        or begin
            rm -f "$archive.part"
            die 'failed to download AviUtl2 2.1.3'
        end

        mv "$archive.part" "$archive"
        or die 'failed to finalize AviUtl2 archive'
    end

    if test -e "$extract_dir"
        archive_existing "$extract_dir" old-extract
    end

    mkdir -p "$extract_dir" "$AVIUTL2_SOURCE_DIR"
    or die 'failed to create AviUtl2 extraction directories'

    bsdtar -xf "$archive" -C "$extract_dir"
    or die 'AviUtl2 extraction failed'

    set -l aviutl2_exe \
        (find "$extract_dir" -type f -iname 'aviutl2.exe' -print -quit)

    test -n "$aviutl2_exe"
    or die 'aviutl2.exe was not found after extraction'

    cp -a (dirname "$aviutl2_exe")/. "$AVIUTL2_SOURCE_DIR/"
    or die 'failed to prepare AviUtl2 artifact'

    aviutl2_artifact_valid
    or die 'prepared AviUtl2 artifact is incomplete'

    file "$AVIUTL2_SOURCE_DIR/aviutl2.exe"
    sha256sum "$archive"

    success "AviUtl2 artifact prepared: $AVIUTL2_SOURCE_DIR"
end

function build_dxvk
    note 'patched DXVK 2.7.1をbuildする'

    if dxvk_artifact_valid
        success "verified DXVK artifact already exists: $DXVK_ARTIFACT_DIR"
        return 0
    end

    if test -e "$DXVK_ARTIFACT_DIR"
        ask_yes_no '不完全なDXVK outputを退避して再buildしますか？' yes
        or die 'invalid DXVK output was not replaced'

        archive_existing "$DXVK_ARTIFACT_DIR" invalid
    end

    if test -e "$DXVK_WORK"
        ask_yes_no '既存DXVK workを退避して新しいsource treeを作りますか？' yes
        or die 'existing DXVK work prevents a clean build'

        archive_existing "$DXVK_WORK" stale
    end

    mkdir -p (dirname "$DXVK_WORK") (dirname "$DXVK_ARTIFACT_DIR")
    or die 'failed to create DXVK parent directories'

    bash \
        "$REPO/scripts/build-dxvk-aviutl2.sh" \
        --work-dir "$DXVK_WORK" \
        --output-dir "$DXVK_ARTIFACT_DIR"
    or die 'DXVK build failed'

    dxvk_artifact_valid
    or die 'DXVK artifact validation failed after build'

    success "DXVK artifact built: $DXVK_ARTIFACT_DIR"
end

function prepare_fonts
    note '日本語font artifactを生成する'

    if font_artifact_valid
        success "verified font artifact already exists: $FONT_SOURCE_DIR"
        return 0
    end

    if test -e "$FONT_SOURCE_DIR"
        ask_yes_no '不完全なfont artifactを退避して再生成しますか？' yes
        or die 'invalid font artifact was not replaced'

        archive_existing "$FONT_SOURCE_DIR" invalid
    end

    python3 \
        "$REPO/scripts/prepare-aviutl2-fonts.py" \
        --output-dir "$FONT_SOURCE_DIR"
    or die 'font artifact generation failed'

    font_artifact_valid
    or die 'font artifact validation failed'

    success "font artifact prepared: $FONT_SOURCE_DIR"
end

function prepare_nvidia
    note 'NVIDIA Wine wrapper artifactを取得する'

    if nvidia_artifact_valid
        success "verified NVIDIA wrapper already exists: $NVIDIA_WRAPPER_DIR"
        return 0
    end

    if test -e "$NVIDIA_WRAPPER_DIR"
        ask_yes_no '不完全なNVIDIA wrapperを退避して再取得しますか？' yes
        or die 'invalid NVIDIA wrapper was not replaced'

        archive_existing "$NVIDIA_WRAPPER_DIR" invalid
    end

    fish \
        "$REPO/scripts/prepare-nvidia-libs.fish" \
        --output-dir "$NVIDIA_WRAPPER_DIR"
    or die 'NVIDIA wrapper preparation failed'

    nvidia_artifact_valid
    or die 'NVIDIA wrapper validation failed'

    success "NVIDIA wrapper prepared: $NVIDIA_WRAPPER_DIR"
end

function build_lsmash
    note 'custom L-SMASH Works r1284をbuildする'

    if lsmash_artifact_valid
        success "verified L-SMASH Works artifact already exists: $LSMASH_ARTIFACT_DIR"
        return 0
    end

    if test -e "$LSMASH_WORK"
        warn "existing L-SMASH work is not a valid completed artifact: $LSMASH_WORK"

        ask_yes_no '既存L-SMASH workを退避してclean buildしますか？' yes
        or die 'invalid L-SMASH work was not replaced'

        archive_existing "$LSMASH_WORK" invalid
    end

    fish \
        "$REPO/scripts/build-l-smash-works-nvdec.fish" \
        --work-dir "$LSMASH_WORK" \
        --jobs "$JOBS"
    or die 'L-SMASH Works build failed'

    lsmash_artifact_valid
    or die 'L-SMASH Works artifact validation failed'

    success "L-SMASH Works artifact built: $LSMASH_ARTIFACT_DIR"
end

function prepare_dxvk_config
    note 'DXVK設定fileを作成する'

    set -l expected 'dxgi.hideNvidiaGpu = False'

    if test -f "$DXVK_CONFIG_FILE"
        set -l actual (string trim -- (cat "$DXVK_CONFIG_FILE"))

        if test "$actual" = "$expected"
            success "DXVK config already matches: $DXVK_CONFIG_FILE"
            return 0
        end

        warn "existing DXVK config differs: $DXVK_CONFIG_FILE"
        cat "$DXVK_CONFIG_FILE"

        ask_yes_no '既存設定をbackupしてINSTALLATION.mdの値へ置換しますか？' yes
        or die 'DXVK config mismatch was not resolved'

        cp -a \
            "$DXVK_CONFIG_FILE" \
            "$DXVK_CONFIG_FILE.backup-"(date +%Y%m%d-%H%M%S)
        or die 'failed to back up DXVK config'
    end

    printf '%s\n' "$expected" > "$DXVK_CONFIG_FILE"
    or die 'failed to write DXVK config'

    test (string trim -- (cat "$DXVK_CONFIG_FILE")) = "$expected"
    or die 'DXVK config verification failed'

    success "DXVK config prepared: $DXVK_CONFIG_FILE"
end

function artifact_preflight
    note 'artifact preflightを実行する'

    runtime_runner_valid
    or die 'runtime runner validation failed before artifact preflight'

    fish \
        "$REPO/scripts/preflight-aviutl2-installation.fish" \
        --root "$ROOT" \
        --ge-proton-root "$GE_PROTON_ROOT" \
        --aviutl2-source-dir "$AVIUTL2_SOURCE_DIR" \
        --lsmash-artifact-dir "$LSMASH_ARTIFACT_DIR"
    or die 'artifact preflight failed'

    success 'artifact preflight completed'
end
