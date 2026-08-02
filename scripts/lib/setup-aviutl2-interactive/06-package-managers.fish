# This file is sourced after 05-repository-validation.fish.
# It replaces the Arch-only dependency installer with package-manager-specific
# mappings. GPU driver packages are intentionally not changed outside the
# validated Arch path; the existing vendor driver must provide its 64-bit and
# 32-bit userspace libraries.

functions --erase install_dependencies

function detect_dependency_manager
    for manager in pacman apt-get dnf dnf5
        if command -q "$manager"
            printf '%s\n' "$manager"
            return 0
        end
    end

    return 1
end

function require_x86_64_host
    require_command uname

    set -l machine (uname -m)
    set -l uname_status $status

    test $uname_status -eq 0
    or die 'failed to determine host architecture'

    test "$machine" = x86_64
    or die "automatic dependency installation supports x86_64 hosts only: $machine"
end

function install_pacman_dependencies
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
        gawk \
        patch \
        fcitx5 \
        fcitx5-mozc \
        nvidia-utils \
        lib32-nvidia-utils \
        vulkan-icd-loader \
        lib32-vulkan-icd-loader \
        vulkan-tools \
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
    or die 'pacman dependency installation failed'
end

function apt_enable_i386
    require_command dpkg

    set -l foreign_architectures (dpkg --print-foreign-architectures)
    set -l dpkg_status $status

    test $dpkg_status -eq 0
    or die 'failed to query dpkg foreign architectures'

    if contains -- i386 $foreign_architectures
        return 0
    end

    ask_yes_no 'Wine/DXVK用32-bit Vulkan loaderのためdpkg i386 architectureを有効化しますか？' yes
    or die 'i386 architecture is required for the Debian/Ubuntu dependency set'

    sudo dpkg --add-architecture i386
    or die 'failed to enable the dpkg i386 architecture'
end

function install_apt_dependencies
    apt_enable_i386

    sudo apt-get update
    or die 'apt package index update failed'

    sudo apt-get install -y \
        fish \
        bash \
        git \
        curl \
        tar \
        libarchive-tools \
        python3 \
        python3-fonttools \
        fonts-noto-cjk \
        file \
        binutils \
        coreutils \
        findutils \
        grep \
        sed \
        gawk \
        patch \
        make \
        fcitx5 \
        fcitx5-mozc \
        libvulkan1 \
        libvulkan1:i386 \
        vulkan-tools \
        build-essential \
        autoconf \
        automake \
        libtool \
        flex \
        bison \
        cmake \
        meson \
        ninja-build \
        nasm \
        pkg-config \
        binutils-mingw-w64-x86-64 \
        gcc-mingw-w64-x86-64 \
        g++-mingw-w64-x86-64 \
        mingw-w64-x86-64-dev
    or die 'apt dependency installation failed; confirm that the distribution repositories containing Fcitx5, Vulkan tools, and MinGW-w64 are enabled'

    warn 'Debian/Ubuntu: NVIDIA driver packages are not changed automatically.'
    warn 'The existing driver must provide working 64-bit and 32-bit NVIDIA/Vulkan userspace libraries.'
end

function install_dnf_dependencies --argument-names dnf_command
    sudo "$dnf_command" install -y \
        fish \
        bash \
        git \
        curl \
        tar \
        bsdtar \
        python3 \
        python3-fonttools \
        google-noto-sans-cjk-fonts \
        file \
        binutils \
        coreutils \
        findutils \
        grep \
        sed \
        gawk \
        patch \
        make \
        fcitx5 \
        fcitx5-mozc \
        vulkan-loader \
        vulkan-loader.i686 \
        vulkan-tools \
        gcc \
        gcc-c++ \
        autoconf \
        automake \
        libtool \
        flex \
        bison \
        cmake \
        meson \
        ninja-build \
        nasm \
        pkgconf-pkg-config \
        mingw64-binutils \
        mingw64-gcc \
        mingw64-gcc-c++ \
        mingw64-headers \
        mingw64-crt \
        mingw64-winpthreads-static
    or die 'dnf dependency installation failed; confirm that the repositories containing Fcitx5, Vulkan i686, and MinGW-w64 are enabled'

    warn 'Fedora: NVIDIA driver packages are not changed automatically.'
    warn 'The existing driver must provide working 64-bit and 32-bit NVIDIA/Vulkan userspace libraries.'
end

function install_dependencies
    if test "$SKIP_DEPENDENCIES" -eq 1
        note '依存関係の導入をskipする'
        return 0
    end

    note '依存関係'

    require_x86_64_host
    require_command sudo

    set -l manager (detect_dependency_manager)
    set -l detect_status $status

    test $detect_status -eq 0
    and test -n "$manager"
    or die 'supported package manager not found; use pacman, apt-get, dnf/dnf5, or rerun with --skip-dependencies after installing requirements manually'

    if not ask_yes_no "runtime/build依存関係を$managerで導入しますか？" yes
        warn 'dependency installation skipped; missing tools will stop at command preflight'
        return 0
    end

    switch "$manager"
        case pacman
            install_pacman_dependencies
        case apt-get
            install_apt_dependencies
        case dnf dnf5
            install_dnf_dependencies "$manager"
        case '*'
            die "internal package-manager error: $manager"
    end

    success "dependencies installed with $manager"
end

function install_catalog_dependencies
    if test "$SKIP_DEPENDENCIES" -eq 1
        note 'Catalog/Lutris dependency installation is disabled by --skip-dependencies'
        return 0
    end

    require_x86_64_host
    require_command sudo

    set -l manager (detect_dependency_manager)
    set -l detect_status $status

    test $detect_status -eq 0
    and test -n "$manager"
    or die 'supported package manager not found for Catalog/Lutris dependencies'

    if not ask_yes_no "Catalog/Lutris依存関係を$managerで導入しますか？" yes
        warn 'Catalog/Lutris dependency installation skipped; command checks will fail if packages are missing'
        return 0
    end

    switch "$manager"
        case pacman
            sudo pacman -S --needed \
                lutris \
                fish \
                python \
                xdg-utils \
                desktop-file-utils \
                github-cli
            or die 'pacman Catalog/Lutris dependency installation failed'
        case apt-get
            sudo apt-get update
            and sudo apt-get install -y \
                lutris \
                fish \
                python3 \
                xdg-utils \
                desktop-file-utils \
                gh
            or die 'apt Catalog/Lutris dependency installation failed'
        case dnf dnf5
            sudo "$manager" install -y \
                lutris \
                fish \
                python3 \
                xdg-utils \
                desktop-file-utils \
                gh
            or die 'dnf Catalog/Lutris dependency installation failed'
        case '*'
            die "internal Catalog package-manager error: $manager"
    end

    success "Catalog/Lutris dependencies installed with $manager"
end
