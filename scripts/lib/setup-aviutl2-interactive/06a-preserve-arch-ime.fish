# Preserve an existing Arch/AUR Mozc variant. Requesting the repository
# fcitx5-mozc package explicitly would remove fcitx5-mozc-ut and mozc-ut.

functions --erase install_pacman_dependencies

function pacman_package_installed --argument-names package_name
    pacman -Qq "$package_name" >/dev/null 2>&1
end

function install_pacman_dependencies
    set -l packages \
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

    if pacman_package_installed fcitx5-mozc-ut
        note '既存fcitx5-mozc-utを保持する（標準fcitx5-mozcへ置換しない）'
    else if pacman_package_installed mozc-ut
        warn 'mozc-utが導入済みのため、競合する標準fcitx5-mozcは自動導入しない'
        warn 'Fcitx5 integrationが必要ならfcitx5-mozc-utを利用者側で導入する'
    else if pacman_package_installed fcitx5-mozc
        note '既存fcitx5-mozcを保持する'
    else
        set -a packages fcitx5-mozc
    end

    sudo pacman -S --needed $packages
    or die 'pacman dependency installation failed'
end
