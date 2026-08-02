# This file is sourced by scripts/setup-aviutl2-interactive.fish.

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
        '                           catalog is a separate docs/LUTRIS-CATALOG.md extension' \
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

    set -l stamp (date +%Y%m%d-%H%M%S-%N)
    set -l archived "$path.$reason-$stamp"

    test ! -e "$archived"
    or die "archive destination already exists: $archived"

    note "既存pathを退避する: $path"
    echo "退避先: $archived"

    mv -T -- "$path" "$archived"
    or die "failed to archive existing path: $path"

    success "archived: $archived"
end

function file_sha256 --argument-names path
    set -l output (sha256sum -- "$path")
    set -l command_status $status

    test $command_status -eq 0
    or return $command_status

    set -l fields (string split -n ' ' -- "$output")

    test (count $fields) -ge 1
    or return 1

    string match -rq '^[0-9a-fA-F]{64}$' -- "$fields[1]"
    or return 1

    printf '%s\n' "$fields[1]"
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
    set -g GUI_VERIFICATION_MARKER "$SETUP_STATE_DIR/GUI-VERIFIED"
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
        "$REPO/docs/LUTRIS-CATALOG.md" \
        "$REPO/scripts/build-dwrite-clean.fish" \
        "$REPO/scripts/install-dwrite.fish" \
        "$REPO/scripts/build-dxvk-aviutl2.sh" \
        "$REPO/scripts/prepare-aviutl2-fonts.py" \
        "$REPO/scripts/prepare-nvidia-libs.fish" \
        "$REPO/scripts/build-l-smash-works-nvdec.fish" \
        "$REPO/scripts/install-l-smash-works-nvdec.fish" \
        "$REPO/scripts/preflight-aviutl2-installation.fish" \
        "$REPO/scripts/bootstrap-aviutl2-prefix.fish" \
        "$REPO/scripts/configure-aviutl2-prefix.fish" \
        "$REPO/scripts/diagnose-aviutl2-launch.fish" \
        "$REPO/scripts/launch-aviutl2.fish" \
        "$REPO/scripts/manage-aviutl2-catalog-lutris.sh"

        require_path "$path"
    end

    fish -n "$REPO/scripts/build-dwrite-clean.fish"
    and fish -n "$REPO/scripts/install-dwrite.fish"
    and fish -n "$REPO/scripts/prepare-nvidia-libs.fish"
    and fish -n "$REPO/scripts/build-l-smash-works-nvdec.fish"
    and fish -n "$REPO/scripts/install-l-smash-works-nvdec.fish"
    and fish -n "$REPO/scripts/preflight-aviutl2-installation.fish"
    and fish -n "$REPO/scripts/bootstrap-aviutl2-prefix.fish"
    and fish -n "$REPO/scripts/configure-aviutl2-prefix.fish"
    and fish -n "$REPO/scripts/diagnose-aviutl2-launch.fish"
    and fish -n "$REPO/scripts/launch-aviutl2.fish"
    or die 'repository Fish syntax validation failed'

    bash -n "$REPO/scripts/build-dxvk-aviutl2.sh"
    and bash -n "$REPO/scripts/manage-aviutl2-catalog-lutris.sh"
    or die 'repository Bash syntax validation failed'

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
        bash \
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
        chmod \
        stat \
        cp \
        mv \
        rm \
        ln \
        mkdir \
        cat \
        head \
        sort \
        tail \
        touch \
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
