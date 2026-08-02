# This file is sourced by scripts/setup-aviutl2-interactive.fish.

function bootstrap_prefix
    note 'Wine prefixを初期化する'

    if prefix_complete "$PREFIX"
        success "prefix is already complete: $PREFIX"
        return 0
    end

    if test -e "$PREFIX"
        test -d "$PREFIX"
        or die "prefix path exists and is not a directory: $PREFIX"

        if directory_nonempty "$PREFIX"
            die "prefix is non-empty but incomplete; refusing to delete it: $PREFIX"
        end
    end

    fish \
        "$REPO/scripts/bootstrap-aviutl2-prefix.fish" \
        --prefix "$PREFIX" \
        --ge-proton-root "$GE_PROTON_ROOT"
    or die 'Wine prefix bootstrap failed'

    prefix_complete "$PREFIX"
    or die 'prefix is incomplete after bootstrap'

    success "prefix initialized: $PREFIX"
end

function stop_prefix
    set -l wine_server "$GE_PROTON_ROOT/files/bin/wineserver"
    set -l ge_libs \
        "$GE_PROTON_ROOT/files/lib/x86_64-linux-gnu:$GE_PROTON_ROOT/files/lib/i386-linux-gnu"

    env \
        WINEPREFIX="$PREFIX" \
        LD_LIBRARY_PATH="$ge_libs" \
        "$wine_server" \
        -k \
        2>/dev/null
    or true
end

function deploy_payload
    note 'AviUtl2本体、DXVK、font、NVIDIA wrapper、L-SMASH Worksを配置する'

    prefix_complete "$PREFIX"
    or die 'prefix must be initialized before payload deployment'

    artifact_preflight

    stop_prefix

    set -l aviutl2_dir "$PREFIX/drive_c/AviUtl2"
    set -l plugin_dir "$PREFIX/drive_c/ProgramData/aviutl2/Plugin"
    set -l system32 "$PREFIX/drive_c/windows/system32"
    set -l dest_fonts "$PREFIX/drive_c/windows/Fonts"

    mkdir -p \
        "$aviutl2_dir" \
        "$plugin_dir" \
        "$system32" \
        "$dest_fonts"
    or die 'failed to create prefix destination directories'

    if test -s "$aviutl2_dir/aviutl2.exe"
        if cmp -s \
            "$AVIUTL2_SOURCE_DIR/aviutl2.exe" \
            "$aviutl2_dir/aviutl2.exe"

            success 'AviUtl2 2.1.3 executable is already deployed'
        else
            ask_yes_no '既存AviUtl2本体へ2.1.3 artifactをoverlayしますか？' yes
            or die 'existing AviUtl2 differs and overlay was declined'

            cp -a "$AVIUTL2_SOURCE_DIR/." "$aviutl2_dir/"
            or die 'failed to deploy AviUtl2'
        end
    else
        cp -a "$AVIUTL2_SOURCE_DIR/." "$aviutl2_dir/"
        or die 'failed to deploy AviUtl2'
    end

    cmp -s \
        "$AVIUTL2_SOURCE_DIR/aviutl2.exe" \
        "$aviutl2_dir/aviutl2.exe"
    or die 'deployed AviUtl2 executable differs from the 2.1.3 artifact'

    for dll in d3d11 dxgi d3d10core
        install \
            -m 0644 \
            "$DXVK_ARTIFACT_DIR/$dll.dll" \
            "$system32/$dll.dll"
        or die "failed to install DXVK DLL: $dll.dll"

        cmp -s \
            "$DXVK_ARTIFACT_DIR/$dll.dll" \
            "$system32/$dll.dll"
        or die "installed DXVK DLL differs: $dll.dll"
    end

    for font_file in \
        NotoSansCJK-Regular.ttc \
        NotoSansCJK-Bold.ttc \
        Tahoma-Noto-Regular.otf \
        Tahoma-Noto-Bold.otf

        install \
            -m 0644 \
            "$FONT_SOURCE_DIR/$font_file" \
            "$dest_fonts/$font_file"
        or die "failed to install font: $font_file"

        cmp -s \
            "$FONT_SOURCE_DIR/$font_file" \
            "$dest_fonts/$font_file"
        or die "installed font differs: $font_file"
    end

    for dll in nvcuda nvcuvid nvencodeapi64
        rm -f "$system32/$dll.dll"
        or die "failed to remove old NVIDIA DLL: $dll.dll"

        ln -s \
            "$NVIDIA_WRAPPER_DIR/$dll.dll" \
            "$system32/$dll.dll"
        or die "failed to link NVIDIA wrapper: $dll.dll"

        test (readlink -f "$system32/$dll.dll") = (readlink -f "$NVIDIA_WRAPPER_DIR/$dll.dll")
        or die "NVIDIA wrapper symlink verification failed: $dll.dll"
    end

    install \
        -m 0644 \
        "$LSMASH_ARTIFACT_DIR/lwinput.aui2" \
        "$plugin_dir/lwinput.aui2"
    or die 'failed to install lwinput.aui2'

    install \
        -m 0644 \
        "$LSMASH_ARTIFACT_DIR/lsmash.ini" \
        "$plugin_dir/lsmash.ini"
    or die 'failed to install lsmash.ini'

    cmp -s \
        "$LSMASH_ARTIFACT_DIR/lwinput.aui2" \
        "$plugin_dir/lwinput.aui2"
    and cmp -s \
        "$LSMASH_ARTIFACT_DIR/lsmash.ini" \
        "$plugin_dir/lsmash.ini"
    or die 'installed L-SMASH Works differs from the artifact'

    grep -nE \
        '^(libavsmash_disabled|libav_disabled|preferred_decoders)=' \
        "$plugin_dir/lsmash.ini"
    or die 'L-SMASH Works configuration verification failed'

    test -s "$aviutl2_dir/aviutl2.exe"
    or die 'AviUtl2 executable is missing after deployment'

    success 'prefix payload deployed and verified'
end

function configure_prefix
    note 'registry、font substitute、DLL override、IME InputStyleを設定する'

    fish \
        "$REPO/scripts/configure-aviutl2-prefix.fish" \
        --prefix "$PREFIX" \
        --ge-proton-root "$GE_PROTON_ROOT"
    or die 'prefix registry configuration failed'

    success 'prefix registry configuration completed'
end

function validate_runtime
    note 'runtime全体を検証する'

    runtime_runner_valid
    or die 'runtime runner validation failed'

    artifact_preflight

    prefix_complete "$PREFIX"
    or die "prefix is incomplete: $PREFIX"

    for path in \
        "$PREFIX/drive_c/AviUtl2/aviutl2.exe" \
        "$PREFIX/drive_c/windows/system32/d3d11.dll" \
        "$PREFIX/drive_c/windows/system32/dxgi.dll" \
        "$PREFIX/drive_c/windows/system32/d3d10core.dll" \
        "$PREFIX/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2" \
        "$PREFIX/drive_c/ProgramData/aviutl2/Plugin/lsmash.ini" \
        "$DXVK_CONFIG_FILE"

        require_path "$path"
    end

    grep -aFq \
        'AviUtl2 compatibility' \
        "$PREFIX/drive_c/windows/system32/d3d11.dll"
    or die 'installed d3d11.dll lacks the AviUtl2 compatibility marker'

    success 'runtime validation passed'
end
