#!/usr/bin/env fish
#
# Interactive AviUtl2 2.1.3 setup for CachyOS / Arch Linux.
#
# Source of truth:
#   docs/INSTALLATION.md
#
# This script orchestrates the repository's existing validated builders and
# launchers. It does not replace their implementation or silently invent a
# different installation path.
#

set -g SCRIPT_NAME (basename (status filename))
set -g SCRIPT_PATH (realpath (status filename))
set -g SCRIPT_DIR (dirname "$SCRIPT_PATH")
set -g REPO (realpath "$SCRIPT_DIR/..")

set -g ASSUME_YES 0
set -g SKIP_DEPENDENCIES 0
set -g REQUESTED_MODE ''
set -g REQUESTED_ROOT ''
set -g REQUESTED_PREFIX ''
set -g REQUESTED_GE_ROOT ''
set -g JOBS ''

set -g DLL_OVERRIDES \
    'nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

set -g STOCK_DWRITE_SHA256 \
    '6d92b541c36f2157be264e5803497ab8f17777c1f575e6704fe3450d00f00e32'

function usage
    printf '%s\n' \
        "Usage: $SCRIPT_NAME [options]" \
        '' \
        'Options:' \
        '  --root PATH             Work root (default: $HOME/Games/aviutl2)' \
        '  --prefix PATH           Wine prefix (default: <root>/prefix)' \
        '  --ge-proton-root PATH   Runtime GE-Proton root' \
        '                           (default: GE-Proton11-1-aviutl2)' \
        '  --jobs N                Parallel build jobs (default: nproc)' \
        '  --mode MODE             full|artifacts|deploy|validate|diagnose|launch|catalog' \
        '  --assume-yes             Accept safe default answers' \
        '  --skip-dependencies      Do not offer pacman dependency installation' \
        '  -h, --help               Show this help' \
        '' \
        'The default interactive mode displays a menu.'
end

function die
    printf 'ERROR: %s\n' "$argv" >&2
    exit 1
end

function warn
    printf 'WARNING: %s\n' "$argv" >&2
end

function note
    echo
    printf '==> %s\n' "$argv"
end

function success
    printf 'OK: %s\n' "$argv"
end

function require_command --argument-names command_name
    command -q "$command_name"
    or die "required command not found: $command_name"
end

function require_path --argument-names path
    test -e "$path"
    or die "required path not found: $path"
end

function normalize_absolute --argument-names label input
    set input (string trim -- "$input")

    test -n "$input"
    or die "$label must not be empty"

    string match -q '/*' -- "$input"
    or die "$label must be an absolute path: $input"

    set input (string replace -r '/+$' '' -- "$input")

    test -n "$input"
    or set input '/'

    printf '%s\n' "$input"
end

function ensure_safe_target --argument-names label path
    switch "$path"
        case '/' "$HOME" "$REPO"
            die "unsafe $label path: $path"
    end

    string match -q '*\$*' -- "$path"
    and die "unresolved variable in $label path: $path"

    test ! -L "$path"
    or die "$label path must not be a symbolic link: $path"
end

function ask_yes_no --argument-names prompt default_answer
    if test "$ASSUME_YES" -eq 1
        if test "$default_answer" = yes
            printf '%s [Y/n] y\n' "$prompt"
            return 0
        end

        printf '%s [y/N] n\n' "$prompt"
        return 1
    end

    while true
        if test "$default_answer" = yes
            read -P "$prompt [Y/n] " answer
            set answer (string lower -- (string trim -- "$answer"))
            switch "$answer"
                case '' y yes
                    return 0
                case n no
                    return 1
            end
        else
            read -P "$prompt [y/N] " answer
            set answer (string lower -- (string trim -- "$answer"))
            switch "$answer"
                case y yes
                    return 0
                case '' n no
                    return 1
            end
        end

        echo 'y または n を入力してください。'
    end
end

function ask_path_into --argument-names variable_name label default_value
    set -l answer "$default_value"

    if test "$ASSUME_YES" -eq 1
        printf '%s: %s\n' "$label" "$default_value"
    else
        read -P "$label [$default_value]: " answer
        set answer (string trim -- "$answer")

        if test -z "$answer"
            set answer "$default_value"
        end
    end

    if string match -q '~/*' -- "$answer"
        set answer "$HOME/"(string replace -r '^~/' '' -- "$answer")
    else if test "$answer" = '~'
        set answer "$HOME"
    end

    set -g "$variable_name" "$answer"
end

function archive_existing --argument-names path reason
    test -e "$path"
    or return 0

    set -l stamp (date +%Y%m%d-%H%M%S)
    set -l archived "$path.$reason-$stamp"

    note "既存pathを退避する: $path"
    echo "退避先: $archived"

    mv -- "$path" "$archived"
    or die "failed to archive existing path: $path"

    success "archived: $archived"
end

function file_sha256 --argument-names path
    sha256sum -- "$path" | string split ' ' | head -n 1
end

function ge_wine_path --argument-names ge_root
    set -l candidate "$ge_root/files/bin/wine"

    if test -x "$candidate"
        printf '%s\n' "$candidate"
        return 0
    end

    set candidate "$ge_root/files/lib/wine/x86_64-unix/wine"

    test -x "$candidate"
    or return 1

    printf '%s\n' "$candidate"
end

function ge_runner_complete --argument-names ge_root
    set -l wine (ge_wine_path "$ge_root" 2>/dev/null)
    test -n "$wine"
    and test -x "$wine"
    and test -x "$ge_root/files/bin/wineserver"
    and test -f "$ge_root/files/lib/wine/x86_64-windows/dwrite.dll"
    and test -d "$ge_root/files/lib/x86_64-linux-gnu"
    and test -d "$ge_root/files/lib/i386-linux-gnu"
    and test -d "$ge_root/files/lib/vkd3d"
    and test -d "$ge_root/files/lib/wine"
end

function prefix_complete --argument-names prefix
    test -f "$prefix/user.reg"
    and test -f "$prefix/system.reg"
    and test -f "$prefix/userdef.reg"
    and test -d "$prefix/drive_c/windows/system32"
end

function directory_nonempty --argument-names path
    test -d "$path"
    or return 1

    set -l first_entry (find "$path" -mindepth 1 -maxdepth 1 -print -quit)
    test -n "$first_entry"
end

function checksum_directory --argument-names directory checksum_file
    test -d "$directory"
    and test -s "$directory/$checksum_file"
    or return 1

    pushd "$directory" >/dev/null
    sha256sum -c "$checksum_file" >/dev/null 2>&1
    set -l verify_status $status
    popd >/dev/null

    return $verify_status
end

function dwrite_artifact_valid
    test -s "$BUILT_DWRITE"
    or return 1

    checksum_directory "$DWRITE_CLEAN_WORK" SHA256SUMS
    or return 1

    file "$BUILT_DWRITE" | grep -q 'PE32+'
    or return 1

    begin
        strings -a "$BUILT_DWRITE"
        strings -a --encoding=l "$BUILT_DWRITE"
    end | grep -q 'No effective run for text position'
end

function dxvk_artifact_valid
    for dll in d3d11 dxgi d3d10core
        test -s "$DXVK_ARTIFACT_DIR/$dll.dll"
        or return 1
    end

    checksum_directory "$DXVK_ARTIFACT_DIR" SHA256SUMS
    or return 1

    grep -aFq 'AviUtl2 compatibility' "$DXVK_ARTIFACT_DIR/d3d11.dll"
end

function font_artifact_valid
    for font_file in \
        NotoSansCJK-Regular.ttc \
        NotoSansCJK-Bold.ttc \
        Tahoma-Noto-Regular.otf \
        Tahoma-Noto-Bold.otf

        test -s "$FONT_SOURCE_DIR/$font_file"
        or return 1
    end

    checksum_directory "$FONT_SOURCE_DIR" SHA256SUMS
end

function nvidia_artifact_valid
    for dll in nvcuda nvcuvid nvencodeapi64
        test -s "$NVIDIA_WRAPPER_DIR/$dll.dll"
        or return 1
    end

    checksum_directory "$NVIDIA_WRAPPER_DIR" SHA256SUMS.expected
end

function lsmash_artifact_valid
    test -s "$LSMASH_ARTIFACT_DIR/lwinput.aui2"
    and test -s "$LSMASH_ARTIFACT_DIR/lsmash.ini"
    and checksum_directory "$LSMASH_ARTIFACT_DIR" SHA256SUMS
    or return 1

    begin
        strings -a -n 5 "$LSMASH_ARTIFACT_DIR/lwinput.aui2"
        strings -a --encoding=l -n 5 "$LSMASH_ARTIFACT_DIR/lwinput.aui2"
    end | grep -q 'L-SMASH Works File Reader for AviUtl2 r1284 by Mr-Ojii'
    or return 1

    strings -a -n 5 "$LSMASH_ARTIFACT_DIR/lwinput.aui2" \
        | grep -q -- '--enable-decoder=av1_cuvid'
    or return 1

    grep -qx 'libavsmash_disabled=1' "$LSMASH_ARTIFACT_DIR/lsmash.ini"
    and grep -qx 'libav_disabled=0' "$LSMASH_ARTIFACT_DIR/lsmash.ini"
    and grep -qx 'preferred_decoders=av1_cuvid' "$LSMASH_ARTIFACT_DIR/lsmash.ini"
end

function aviutl2_artifact_valid
    test -s "$AVIUTL2_SOURCE_DIR/aviutl2.exe"
end

function runtime_runner_valid
    ge_runner_complete "$GE_PROTON_ROOT"
    or return 1

    dwrite_artifact_valid
    or return 1

    set -l ge_dwrite "$GE_PROTON_ROOT/files/lib/wine/x86_64-windows/dwrite.dll"

    cmp --silent -- "$BUILT_DWRITE" "$ge_dwrite"
    or return 1

    set -l installed_sha (file_sha256 "$ge_dwrite")
    test "$installed_sha" != "$STOCK_DWRITE_SHA256"
end

function configure_paths
    set -g ROOT "$REQUESTED_ROOT"
    if test -z "$ROOT"
        ask_path_into ROOT 'AviUtl2 work root' "$HOME/Games/aviutl2"
    end
    set ROOT (normalize_absolute --root "$ROOT")
    ensure_safe_target root "$ROOT"

    set -g PREFIX "$REQUESTED_PREFIX"
    if test -z "$PREFIX"
        ask_path_into PREFIX 'Wine prefix' "$ROOT/prefix"
    end
    set PREFIX (normalize_absolute --prefix "$PREFIX")
    ensure_safe_target prefix "$PREFIX"

    set -g GE_BASE "$HOME/.local/share/Steam/compatibilitytools.d"
    set -g GE_STOCK "$GE_BASE/GE-Proton11-1"
    set -g GE_PATCHED "$GE_BASE/GE-Proton11-1-aviutl2"

    set -g GE_PROTON_ROOT "$REQUESTED_GE_ROOT"
    if test -z "$GE_PROTON_ROOT"
        ask_path_into GE_PROTON_ROOT 'Runtime GE-Proton root' "$GE_PATCHED"
    end
    set GE_PROTON_ROOT (normalize_absolute --ge-proton-root "$GE_PROTON_ROOT")
    ensure_safe_target ge-proton-root "$GE_PROTON_ROOT"

    set -g ARTIFACT_ROOT "$ROOT/artifacts"
    set -g AVIUTL2_SOURCE_DIR "$ARTIFACT_ROOT/AviUtl2-2.1.3"
    set -g DXVK_ARTIFACT_DIR "$ARTIFACT_ROOT/dxvk-2.7.1-aviutl2/x64"
    set -g FONT_SOURCE_DIR "$ARTIFACT_ROOT/fonts"
    set -g NVIDIA_WRAPPER_DIR "$ARTIFACT_ROOT/nvidia-libs-v1.0.2/x64"
    set -g LSMASH_WORK "$ROOT/build/l-smash-works-nvdec-repro-03"
    set -g LSMASH_ARTIFACT_DIR "$LSMASH_WORK/output"
    set -g DXVK_CONFIG_FILE "$ROOT/nvidia-dxvk.conf"

    set -g DWRITE_CLEAN_WORK "$ROOT/build/dwrite-clean"
    set -g BUILT_DWRITE \
        "$DWRITE_CLEAN_WORK/build/dlls/dwrite/x86_64-windows/dwrite.dll"

    set -g DXVK_WORK "$ROOT/build/dxvk-2.7.1-aviutl2-source"

    set -g SETUP_STATE_DIR "$ROOT/interactive-setup"
    set -g SETUP_LOG "$SETUP_STATE_DIR/setup-"(date +%Y%m%d-%H%M%S)".log"

    if test -z "$JOBS"
        set JOBS (nproc 2>/dev/null)
        if test -z "$JOBS"
            set JOBS 1
        end
    end

    string match -rq '^[1-9][0-9]*$' -- "$JOBS"
    or die "--jobs must be a positive integer: $JOBS"

    mkdir -p \
        "$ROOT" \
        "$ROOT/downloads" \
        "$ROOT/build" \
        "$ROOT/logs" \
        "$ROOT/src" \
        "$ARTIFACT_ROOT" \
        "$SETUP_STATE_DIR" \
        "$GE_BASE"
    or die 'failed to create base directories'

    printf '%s\n' \
        "repository=$REPO" \
        "root=$ROOT" \
        "prefix=$PREFIX" \
        "ge_proton_root=$GE_PROTON_ROOT" \
        "jobs=$JOBS" \
        "started_at="(date --iso-8601=seconds) \
        > "$SETUP_LOG"

    note '設定'
    printf '%-24s %s\n' \
        'Repository:' "$REPO" \
        'Root:' "$ROOT" \
        'Prefix:' "$PREFIX" \
        'GE-Proton:' "$GE_PROTON_ROOT" \
        'DWrite work:' "$DWRITE_CLEAN_WORK" \
        'DXVK artifact:' "$DXVK_ARTIFACT_DIR" \
        'L-SMASH artifact:' "$LSMASH_ARTIFACT_DIR" \
        'Build jobs:' "$JOBS" \
        'Setup log:' "$SETUP_LOG"

    ask_yes_no 'この設定で続行しますか？' yes
    or die 'setup cancelled by user'
end

function validate_repository
    note 'repositoryの正本を確認する'

    for path in \
        "$REPO/docs/INSTALLATION.md" \
        "$REPO/scripts/build-dwrite-clean.fish" \
        "$REPO/scripts/install-dwrite.fish" \
        "$REPO/scripts/build-dxvk-aviutl2.sh" \
        "$REPO/scripts/prepare-aviutl2-fonts.py" \
        "$REPO/scripts/prepare-nvidia-libs.fish" \
        "$REPO/scripts/build-l-smash-works-nvdec.fish" \
        "$REPO/scripts/preflight-aviutl2-installation.fish" \
        "$REPO/scripts/bootstrap-aviutl2-prefix.fish" \
        "$REPO/scripts/configure-aviutl2-prefix.fish" \
        "$REPO/scripts/diagnose-aviutl2-launch.fish" \
        "$REPO/scripts/launch-aviutl2.fish"

        require_path "$path"
    end

    fish -n "$REPO/scripts/build-dwrite-clean.fish"
    and fish -n "$REPO/scripts/install-dwrite.fish"
    and fish -n "$REPO/scripts/prepare-nvidia-libs.fish"
    and fish -n "$REPO/scripts/build-l-smash-works-nvdec.fish"
    and fish -n "$REPO/scripts/preflight-aviutl2-installation.fish"
    and fish -n "$REPO/scripts/bootstrap-aviutl2-prefix.fish"
    and fish -n "$REPO/scripts/configure-aviutl2-prefix.fish"
    and fish -n "$REPO/scripts/diagnose-aviutl2-launch.fish"
    and fish -n "$REPO/scripts/launch-aviutl2.fish"
    or die 'repository Fish syntax validation failed'

    bash -n "$REPO/scripts/build-dxvk-aviutl2.sh"
    or die 'DXVK builder syntax validation failed'

    python3 -c '
from pathlib import Path
path = Path(__import__("sys").argv[1])
compile(path.read_text(encoding="utf-8"), str(path), "exec")
' "$REPO/scripts/prepare-aviutl2-fonts.py"
    or die 'font preparation script syntax validation failed'

    success 'repository scripts validated'
end

function install_dependencies
    if test "$SKIP_DEPENDENCIES" -eq 1
        note '依存関係の導入をskipする'
        return 0
    end

    note '依存関係'

    test -f /etc/arch-release
    and command -q pacman
    or die 'this installer currently supports CachyOS / Arch Linux only'

    if not ask_yes_no 'INSTALLATION.md記載のruntime/build依存関係をpacmanで導入しますか？' yes
        warn 'dependency installation skipped; missing tools will stop later stages'
        return 0
    end

    sudo pacman -S --needed \
        fish \
        git \
        curl \
        tar \
        libarchive \
        python \
        python-fonttools \
        noto-fonts-cjk \
        file \
        binutils \
        coreutils \
        findutils \
        grep \
        sed \
        fcitx5 \
        fcitx5-mozc \
        nvidia-utils \
        lib32-nvidia-utils \
        vulkan-icd-loader \
        lib32-vulkan-icd-loader \
        vulkan-tools
    or die 'runtime dependency installation failed'

    sudo pacman -S --needed \
        base-devel \
        autoconf \
        automake \
        libtool \
        flex \
        bison \
        cmake \
        meson \
        ninja \
        nasm \
        pkgconf \
        mingw-w64-binutils \
        mingw-w64-crt \
        mingw-w64-gcc \
        mingw-w64-headers \
        mingw-w64-winpthreads
    or die 'build dependency installation failed'

    success 'dependencies installed'
end

function verify_required_commands
    note '必要commandを確認する'

    for command_name in \
        fish \
        bash \
        git \
        curl \
        tar \
        bsdtar \
        python3 \
        file \
        strings \
        sha256sum \
        sha512sum \
        cmp \
        install \
        cp \
        mv \
        rm \
        ln \
        mkdir \
        cat \
        head \
        sort \
        tail \
        nproc \
        readlink \
        find \
        grep \
        sed \
        awk \
        tee \
        patch \
        make \
        cmake \
        meson \
        ninja \
        nasm \
        pkg-config \
        x86_64-w64-mingw32-gcc

        require_command "$command_name"
    end

    success 'required commands found'
end

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

function latest_diagnostic_log
    find "$ROOT/logs" \
        -maxdepth 1 \
        -type f \
        -name 'aviutl2-section13-*.log' \
        -printf '%T@ %p\n' \
        | sort -nr \
        | head -n 1 \
        | cut -d' ' -f2-
end

function diagnostic_launch
    note 'Section 13 診断起動'

    validate_runtime

    fish -n "$REPO/scripts/diagnose-aviutl2-launch.fish"
    or die 'diagnostic launcher syntax validation failed'

    echo
    echo 'AviUtl2を起動する。GUI確認後、AviUtl2を閉じると対話setupへ戻る。'
    echo

    fish \
        "$REPO/scripts/diagnose-aviutl2-launch.fish" \
        --root "$ROOT" \
        --prefix "$PREFIX" \
        --ge-proton-root "$GE_PROTON_ROOT" \
        --dxvk-config "$DXVK_CONFIG_FILE"
    set -l launch_status $status

    set -l latest_log (latest_diagnostic_log)
    echo "LATEST_LOG=$latest_log"

    if test -n "$latest_log"; and test -s "$latest_log"
        echo
        echo 'Fatal marker scan:'

        grep -nEi \
            'dwrite:.*stub|EXCEPTION_WINE_CXX_EXCEPTION|Unhandled exception|unhandled page fault|c0000135|Application could not be started|ShellExecuteEx failed|File not found|failed to load|could not load' \
            "$latest_log" \
            | tail -n 200
        or true
    else
        warn 'diagnostic log was not found'
    end

    test $launch_status -eq 0
    or warn "diagnostic launcher exited with status $launch_status"

    if test "$ASSUME_YES" -eq 1
        warn '--assume-yes cannot certify GUI behavior; GUI verification is left unconfirmed'
        return $launch_status
    end

    note 'GUI回帰確認'

    set -l failed_checks 0

    for check in \
        'AviUtl2メインウィンドウが表示された' \
        '日本語UIを正常に読めた' \
        'format 69 / D3D RDMs error dialogが出なかった' \
        'text objectの追加・選択・caret移動・再編集ができた' \
        'Mozcで日本語入力・変換・Enter確定ができた' \
        '「プラグインを信頼する」を押してもクラッシュしなかった'

        if ask_yes_no "$check" yes
            success "$check"
        else
            warn "未確認または失敗: $check"
            set failed_checks (math "$failed_checks + 1")
        end
    end

    if test "$failed_checks" -ne 0
        die "$failed_checks GUI checks were not confirmed; inspect: $latest_log"
    end

    printf '%s\n' \
        "verified_at="(date --iso-8601=seconds) \
        "latest_log=$latest_log" \
        "prefix=$PREFIX" \
        "ge_proton_root=$GE_PROTON_ROOT" \
        > "$SETUP_STATE_DIR/GUI-VERIFIED"

    success 'Section 13 GUI / text / Mozc verification passed'
end

function normal_launch
    note '通常起動'

    validate_runtime

    fish \
        "$REPO/scripts/launch-aviutl2.fish" \
        --prefix "$PREFIX" \
        --ge-proton-root "$GE_PROTON_ROOT" \
        --dxvk-config "$DXVK_CONFIG_FILE"
end

function catalog_env_command --argument-names manager_command
    set -l ge_wine (ge_wine_path "$GE_PROTON_ROOT")
    set -l ge_wineserver "$GE_PROTON_ROOT/files/bin/wineserver"
    set -l ge_libs \
        "$GE_PROTON_ROOT/files/lib/x86_64-linux-gnu:$GE_PROTON_ROOT/files/lib/i386-linux-gnu"
    set -l manager "$REPO/scripts/manage-aviutl2-catalog-lutris.sh"

    require_path "$manager"

    env \
        AVIUTL2_ROOT="$ROOT" \
        AVIUTL2_PREFIX="$PREFIX" \
        GE_PROTON_ROOT="$GE_PROTON_ROOT" \
        GE_WINE="$ge_wine" \
        GE_WINESERVER="$ge_wineserver" \
        GE_LIBS="$ge_libs" \
        DXVK_CONFIG_FILE="$DXVK_CONFIG_FILE" \
        WINEDLLOVERRIDES_VALUE="$DLL_OVERRIDES" \
        bash \
        "$manager" \
        "$manager_command"
end

function setup_catalog
    note 'AviUtl2 Catalog / Lutris integration'

    test -f "$SETUP_STATE_DIR/GUI-VERIFIED"
    or begin
        warn 'Section 13 GUI verification marker is absent.'
        ask_yes_no 'それでもCatalog setupへ進みますか？' no
        or die 'Catalog setup cancelled'
    end

    validate_runtime

    if ask_yes_no 'Catalog/Lutris用packageを導入しますか？' yes
        sudo pacman -S --needed \
            lutris \
            github-cli \
            python \
            xdg-utils \
            desktop-file-utils
        or die 'Catalog/Lutris dependency installation failed'
    end

    require_command gh
    require_command lutris
    require_command xdg-mime

    note 'Catalog status'
    catalog_env_command status
    or true

    if ask_yes_no '既存patched prefixへAviUtl2 CatalogをLutris経由で導入しますか？' yes
        catalog_env_command lutris-install
        or die 'AviUtl2 Catalog Lutris installation failed'

        echo
        echo 'Catalog初期設定で次を指定する:'
        echo '  AviUtl2: インストール済み'
        echo '  AviUtl2 root: C:\AviUtl2'
        echo '  Portable mode: 無効'
        echo
        echo '初期設定を完了し、AviUtl2とCatalogを閉じてから続行する。'

        ask_yes_no 'Catalog初期設定を完了し、両方のprocessを閉じましたか？' no
        or die 'Catalog initial setup is not complete'

        fish \
            "$REPO/scripts/install-l-smash-works-nvdec.fish" \
            --prefix "$PREFIX" \
            --artifact-dir "$LSMASH_ARTIFACT_DIR"
        or die 'failed to restore and protect custom L-SMASH Works'

        success 'Catalog installed; custom L-SMASH Works restored and update-paused'
    else
        warn 'Catalog installation skipped'
    end
end

function run_artifact_pipeline
    install_dependencies
    verify_required_commands
    validate_repository
    prepare_ge_proton_stock
    build_dwrite
    prepare_runtime_runner
    prepare_aviutl2
    build_dxvk
    prepare_fonts
    prepare_nvidia
    build_lsmash
    prepare_dxvk_config
    artifact_preflight
end

function run_deploy_pipeline
    verify_required_commands
    validate_repository
    artifact_preflight
    bootstrap_prefix
    deploy_payload
    configure_prefix
    validate_runtime
end

function run_full_pipeline
    run_artifact_pipeline
    bootstrap_prefix
    deploy_payload
    configure_prefix
    diagnostic_launch
    or die 'Section 13 diagnostic launch did not complete successfully'

    if test -f "$SETUP_STATE_DIR/GUI-VERIFIED"
        if ask_yes_no '続けてAviUtl2 Catalog / Lutrisを設定しますか？' yes
            setup_catalog
        end
    else
        warn 'GUI verification is not certified; Catalog setup is skipped'
    end

    note 'セットアップ完了'
    echo 'AviUtl2 2.1.3 + patched DXVK + patched DWrite + custom L-SMASH Works'

    if test -f "$SETUP_STATE_DIR/GUI-VERIFIED"
        echo 'GUI、text編集、Mozcまで確認済み。'
        echo
        echo '互換レイヤーとして、ここまで通れば文句なしの勝ちです。'
    else
        echo '自動工程と診断起動までは完了。GUI回帰確認は未認証です。'
    end
end

function choose_mode
    if test -n "$REQUESTED_MODE"
        set -g SELECTED_MODE "$REQUESTED_MODE"
        return 0
    end

    echo
    echo '実行内容を選択してください:'
    echo '  1) Full setup（artifact build → prefix配置 → 診断起動）'
    echo '  2) Artifacts only（Sections 3–10）'
    echo '  3) Deploy prefix（Sections 10–13、artifact作成済み）'
    echo '  4) Validate current installation'
    echo '  5) Diagnostic launch'
    echo '  6) Normal launch'
    echo '  7) Catalog / Lutris setup'
    echo '  0) Exit'

    while true
        read -P '選択: ' selection

        switch (string trim -- "$selection")
            case 1
                set -g SELECTED_MODE full
                return 0
            case 2
                set -g SELECTED_MODE artifacts
                return 0
            case 3
                set -g SELECTED_MODE deploy
                return 0
            case 4
                set -g SELECTED_MODE validate
                return 0
            case 5
                set -g SELECTED_MODE diagnose
                return 0
            case 6
                set -g SELECTED_MODE launch
                return 0
            case 7
                set -g SELECTED_MODE catalog
                return 0
            case 0
                set -g SELECTED_MODE exit
                return 0
        end

        echo '0〜7を入力してください。'
    end
end

function parse_arguments
    argparse \
        'h/help' \
        'r/root=' \
        'p/prefix=' \
        'g/ge-proton-root=' \
        'j/jobs=' \
        'm/mode=' \
        'y/assume-yes' \
        'd/skip-dependencies' \
        -- $argv
    or begin
        usage >&2
        exit 2
    end

    if set -q _flag_help
        usage
        exit 0
    end

    if set -q _flag_root
        set -g REQUESTED_ROOT (string trim -- "$_flag_root")
    end

    if set -q _flag_prefix
        set -g REQUESTED_PREFIX (string trim -- "$_flag_prefix")
    end

    if set -q _flag_ge_proton_root
        set -g REQUESTED_GE_ROOT (string trim -- "$_flag_ge_proton_root")
    end

    if set -q _flag_jobs
        set -g JOBS (string trim -- "$_flag_jobs")
    end

    if set -q _flag_mode
        set -g REQUESTED_MODE (string lower -- (string trim -- "$_flag_mode"))

        switch "$REQUESTED_MODE"
            case full artifacts deploy validate diagnose launch catalog
            case '*'
                die "unknown mode: $REQUESTED_MODE"
        end
    end

    if set -q _flag_assume_yes
        set -g ASSUME_YES 1
    end

    if set -q _flag_skip_dependencies
        set -g SKIP_DEPENDENCIES 1
    end
end

function main
    test (id -u) -ne 0
    or die 'do not run this script as root; sudo is used only for pacman'

    parse_arguments $argv

    for command_name in realpath dirname basename date id mkdir
        require_command "$command_name"
    end

    configure_paths

    choose_mode
    set -l mode "$SELECTED_MODE"

    switch "$mode"
        case full
            run_full_pipeline
        case artifacts
            run_artifact_pipeline
        case deploy
            run_deploy_pipeline
        case validate
            verify_required_commands
            validate_repository
            validate_runtime
        case diagnose
            verify_required_commands
            validate_repository
            diagnostic_launch
        case launch
            verify_required_commands
            validate_repository
            normal_launch
        case catalog
            verify_required_commands
            validate_repository
            setup_catalog
        case exit
            echo '終了します。'
            return 0
        case '*'
            die "internal mode error: $mode"
    end

    printf 'completed_at=%s\n' (date --iso-8601=seconds) >> "$SETUP_LOG"
end

main $argv
exit $status
