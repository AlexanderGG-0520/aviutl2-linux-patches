#!/usr/bin/env fish

# Build the validated AviUtl2 L-SMASH Works r1284/NVDEC artifact from
# pinned source commits. This script builds into a fresh directory only.
# It never modifies a Wine prefix, AviUtl2 installation, or Catalog state.

set -g SCRIPT_NAME (basename (status filename))

function usage
    echo "Usage: $SCRIPT_NAME [--work-dir PATH] [--output-dir PATH] [--jobs N]"
    echo
    echo "Defaults:"
    echo "  --work-dir   \$HOME/Games/aviutl2/build/l-smash-works-nvdec-repro"
    echo "  --output-dir <work-dir>/output"
    echo "  --jobs       nproc"
end

function die
    echo "ERROR: $argv" >&2
    exit 1
end

function note
    echo
    echo "==> $argv"
end

function require_command
    set -l command_name $argv[1]
    command -q "$command_name"
    or die "required command not found: $command_name"
end

function clone_commit
    set -l name $argv[1]
    set -l url $argv[2]
    set -l destination $argv[3]
    set -l commit $argv[4]

    note "Fetching $name at $commit"

    test ! -e "$destination"
    or die "destination already exists: $destination"

    git init -q "$destination"
    or die "git init failed: $destination"

    git -C "$destination" remote add origin "$url"
    or die "git remote add failed: $name"

    git -C "$destination" fetch --depth 1 origin "$commit"
    or die "git fetch failed: $name ($commit)"

    git -C "$destination" checkout --detach -q FETCH_HEAD
    or die "git checkout failed: $name"

    set -l actual (git -C "$destination" rev-parse HEAD)
    test "$actual" = "$commit"
    or die "$name commit mismatch: expected $commit, got $actual"
end

argparse \
    'h/help' \
    'w/work-dir=' \
    'o/output-dir=' \
    'j/jobs=' \
    -- $argv
or begin
    usage >&2
    exit 2
end

if set -q _flag_help
    usage
    exit 0
end

set -l script_path (status filename)
set -l script_dir (cd (dirname "$script_path"); and pwd -P)
set -l repo_root (cd "$script_dir/../.."; and pwd -P)

set -l work_dir "$HOME/Games/aviutl2/build/l-smash-works-nvdec-repro"
if set -q _flag_work_dir
    set work_dir (string trim -- "$_flag_work_dir")
end

test -n "$work_dir"
or die "--work-dir must not be empty"

set work_dir (string replace -r '/+$' '' -- "$work_dir")
set -l output_dir "$work_dir/output"
if set -q _flag_output_dir
    set output_dir (string trim -- "$_flag_output_dir")
end

test -n "$output_dir"
or die "--output-dir must not be empty"
set output_dir (string replace -r '/+$' '' -- "$output_dir")

set -l jobs
if set -q _flag_jobs
    set jobs "$_flag_jobs"
else
    set jobs (nproc 2>/dev/null)
    if test -z "$jobs"
        set jobs 1
    end
end

string match -rq '^[1-9][0-9]*$' -- "$jobs"
or die "--jobs must be a positive integer: $jobs"

set -l patch_file "$repo_root/patches/l-smash-works/0001-transfer-hardware-frames-before-output.patch"
set -l lsmash_ini "$repo_root/config/lsmash.ini"

test -f "$patch_file"
or die "patch not found: $patch_file"

test -f "$lsmash_ini"
or die "configuration not found: $lsmash_ini"

set -l expected_patch_sha256 7c4b410fa4ffa5223b63522f27e9e2534bac550d2fa038c1aee94ed6de5ae0d2
set -l actual_patch_sha256 (sha256sum "$patch_file" | string split ' ')[1]
test "$actual_patch_sha256" = "$expected_patch_sha256"
or die "patch SHA-256 mismatch: expected $expected_patch_sha256, got $actual_patch_sha256"

for command_name in \
    git \
    cmake \
    meson \
    ninja \
    nasm \
    make \
    pkg-config \
    nproc \
    file \
    strings \
    sha256sum \
    grep \
    sed \
    x86_64-w64-mingw32-gcc \
    x86_64-w64-mingw32-g++ \
    x86_64-w64-mingw32-ar \
    x86_64-w64-mingw32-ranlib \
    x86_64-w64-mingw32-strip \
    x86_64-w64-mingw32-windres \
    x86_64-w64-mingw32-objdump \
    stat \
    head

    require_command "$command_name"
end

# Refuse to reuse a prior tree. This avoids silently combining stale build
# outputs with the pinned sources below.
test ! -e "$work_dir"
or die "work directory already exists; choose a new path or remove it manually: $work_dir"

test ! -e "$output_dir"
or die "output directory already exists: $output_dir"

set -l deps_dir "$work_dir/deps"
set -l prefix "$work_dir/prefix"
set -l tool_bin "$work_dir/bin"
set -l source_dir "$work_dir/src"
set -l lsw_source "$source_dir/L-SMASH-Works"
set -l toolchain "$work_dir/x86_64-w64-mingw32.cmake"

mkdir -p \
    "$deps_dir" \
    "$prefix/include" \
    "$prefix/lib/pkgconfig" \
    "$tool_bin" \
    "$source_dir" \
    "$output_dir"
or die "failed to create build directories"

set -l pkg_config_path (command -s pkg-config)
ln -s "$pkg_config_path" "$tool_bin/x86_64-w64-mingw32-pkg-config"
or die "failed to create the MinGW pkg-config wrapper"

set -gx PATH "$tool_bin" $PATH
set -gx PKG_CONFIG_PATH "$prefix/lib/pkgconfig"
set -gx PKG_CONFIG_LIBDIR "$prefix/lib/pkgconfig"

printf '%s\n' \
    'set(CMAKE_SYSTEM_NAME Windows)' \
    'set(CMAKE_SYSTEM_PROCESSOR x86_64)' \
    'set(CMAKE_C_COMPILER x86_64-w64-mingw32-gcc)' \
    'set(CMAKE_CXX_COMPILER x86_64-w64-mingw32-g++)' \
    'set(CMAKE_RC_COMPILER x86_64-w64-mingw32-windres)' \
    "set(CMAKE_FIND_ROOT_PATH \"$prefix\" \"/usr/x86_64-w64-mingw32\")" \
    "set(CMAKE_PREFIX_PATH \"$prefix\")" \
    'set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)' \
    'set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)' \
    'set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)' \
    'set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)' \
    > "$toolchain"
or die "failed to write CMake toolchain file"

# Pinned source identities recovered from the validated 2026-07-31 build.
set -l lsw_base_commit a47764915f06fcd472e26ba2fbf25aff4b9d252e
set -l lsw_patched_commit 393df5ef669707f776261e4ac1bcc7e9a9a227ab
set -l zlib_commit da607da739fa6047df13e66a2af6b8bec7c2a498
set -l gme_commit fe8da4b6d3876d7542c2fb69d94487e19836d678
set -l dav1d_commit 54706fc6bc0cdecab7e9593974a4039cc038fca7
set -l libvpx_commit ade52487a37ef76a0f209bd39bea9fe67d6db4c4
set -l nvcodec_commit eddcea9e27f6b772057c9b3f87de2cc1737faffc
set -l libvpl_commit 674d015bcb294bc39fa276e99a652ea045423e82
set -l ffmpeg_commit cfa62de001af8ffeb7e22561f246469c7b809951
set -l obuparse_commit c2156b4a133714d0a9c04a7cd341efb1af415a33
set -l lsmash_commit 04315d02fef15a75f747493920724c91a62b8538

clone_commit \
    "L-SMASH Works" \
    "https://github.com/Mr-Ojii/L-SMASH-Works.git" \
    "$lsw_source" \
    "$lsw_base_commit"

note "Expanding L-SMASH Works to full history for revision generation"

git -C "$lsw_source" fetch --unshallow origin
or die "failed to fetch the complete L-SMASH Works history"

set -l lsw_is_shallow (git -C "$lsw_source" rev-parse --is-shallow-repository)
test "$lsw_is_shallow" = false
or die "L-SMASH Works repository is still shallow after --unshallow"

set -l lsw_base_revision (git -C "$lsw_source" rev-list --count HEAD)
test "$lsw_base_revision" = 1283
or die "unexpected L-SMASH Works base revision: expected 1283, got $lsw_base_revision"

note "Applying the hardware-frame-transfer patch"

env \
    GIT_COMMITTER_NAME='alexandergg-0520' \
    GIT_COMMITTER_EMAIL='uket.panda.1st@gmail.com' \
    GIT_COMMITTER_DATE='2026-07-31T03:58:59+09:00' \
    git \
    -C "$lsw_source" \
    -c commit.gpgSign=false \
    am \
    --committer-date-is-author-date \
    "$patch_file"
or die "failed to apply the L-SMASH Works patch"

set -l actual_lsw_commit (git -C "$lsw_source" rev-parse HEAD)
test "$actual_lsw_commit" = "$lsw_patched_commit"
or die "patched L-SMASH Works commit mismatch: expected $lsw_patched_commit, got $actual_lsw_commit"

set -l lsw_patched_revision (git -C "$lsw_source" rev-list --count HEAD)
test "$lsw_patched_revision" = 1284
or die "unexpected patched L-SMASH Works revision: expected 1284, got $lsw_patched_revision"

git -C "$lsw_source" diff --quiet
or die "L-SMASH Works has an unexpected unstaged diff after git am"

git -C "$lsw_source" diff --cached --quiet
or die "L-SMASH Works has an unexpected staged diff after git am"

clone_commit \
    zlib \
    "https://github.com/madler/zlib.git" \
    "$deps_dir/zlib" \
    "$zlib_commit"

clone_commit \
    game-music-emu \
    "https://github.com/libgme/game-music-emu.git" \
    "$deps_dir/game-music-emu" \
    "$gme_commit"

clone_commit \
    dav1d \
    "https://code.videolan.org/videolan/dav1d.git" \
    "$deps_dir/dav1d" \
    "$dav1d_commit"

clone_commit \
    libvpx \
    "https://github.com/webmproject/libvpx.git" \
    "$deps_dir/libvpx" \
    "$libvpx_commit"

clone_commit \
    nv-codec-headers \
    "https://github.com/FFmpeg/nv-codec-headers.git" \
    "$deps_dir/nv-codec-headers" \
    "$nvcodec_commit"

clone_commit \
    libvpl \
    "https://github.com/intel/libvpl.git" \
    "$deps_dir/libvpl" \
    "$libvpl_commit"

clone_commit \
    FFmpeg \
    "https://github.com/FFmpeg/FFmpeg.git" \
    "$deps_dir/FFmpeg" \
    "$ffmpeg_commit"

clone_commit \
    obuparse \
    "https://github.com/dwbuiten/obuparse.git" \
    "$deps_dir/obuparse" \
    "$obuparse_commit"

clone_commit \
    l-smash \
    "https://github.com/Mr-Ojii/l-smash.git" \
    "$deps_dir/l-smash" \
    "$lsmash_commit"

note "Building zlib"
cd "$deps_dir/zlib"
or die "cannot enter zlib source"

env CROSS_PREFIX=x86_64-w64-mingw32- \
    ./configure \
    --static \
    --prefix="$prefix"
or die "zlib configure failed"

make -j "$jobs"
or die "zlib build failed"

make install
or die "zlib install failed"

note "Building game-music-emu (static)"
cd "$deps_dir/game-music-emu"
or die "cannot enter game-music-emu source"

cmake \
    -S . \
    -B build-static \
    -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_TOOLCHAIN_FILE="$toolchain" \
    -DCMAKE_INSTALL_PREFIX="$prefix" \
    -DCMAKE_PREFIX_PATH="$prefix" \
    -DZLIB_ROOT="$prefix" \
    -DZLIB_LIBRARY="$prefix/lib/libz.a" \
    -DZLIB_INCLUDE_DIR="$prefix/include" \
    -DZLIB_USE_STATIC_LIBS=ON \
    -DBUILD_SHARED_LIBS=OFF \
    -DBUILD_TESTING=OFF \
    -DGME_BUILD_SHARED=OFF \
    -DGME_BUILD_STATIC=ON \
    -DGME_BUILD_EXAMPLES=OFF \
    -DGME_BUILD_TESTING=OFF \
    -DGME_ENABLE_UBSAN=OFF \
    -DGME_ENABLE_ASAN=OFF
or die "game-music-emu static configure failed"

cmake --build build-static -j "$jobs"
or die "game-music-emu static build failed"

cmake --install build-static
or die "game-music-emu static install failed"

note "Building game-music-emu (shared metadata/runtime build)"
cmake \
    -S . \
    -B build-shared \
    -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_TOOLCHAIN_FILE="$toolchain" \
    -DCMAKE_INSTALL_PREFIX="$prefix" \
    -DCMAKE_PREFIX_PATH="$prefix" \
    -DZLIB_LIBRARY="$prefix/lib/libz.a" \
    -DZLIB_INCLUDE_DIR="$prefix/include" \
    -DGME_BUILD_SHARED=ON \
    -DGME_BUILD_STATIC=OFF \
    -DGME_BUILD_EXAMPLES=OFF \
    -DGME_BUILD_TESTING=OFF \
    -DGME_ENABLE_UBSAN=OFF \
    -DGME_ENABLE_ASAN=OFF
or die "game-music-emu shared configure failed"

cmake --build build-shared -j "$jobs"
or die "game-music-emu shared build failed"

cmake --install build-shared
or die "game-music-emu shared install failed"

note "Building dav1d"
cd "$deps_dir/dav1d"
or die "cannot enter dav1d source"

meson setup \
    --cross-file=package/crossfiles/x86_64-w64-mingw32.meson \
    --buildtype=release \
    --default-library=static \
    -Denable_tests=false \
    --prefix="$prefix" \
    build-cross
or die "dav1d configure failed"

ninja -C build-cross
or die "dav1d build failed"

ninja -C build-cross install
or die "dav1d install failed"

note "Building libvpx"
mkdir "$deps_dir/libvpx/build-cross"
or die "failed to create libvpx build directory"

cd "$deps_dir/libvpx/build-cross"
or die "cannot enter libvpx build directory"

env CROSS=x86_64-w64-mingw32- \
    ../configure \
    --target=x86_64-win64-gcc \
    --enable-vp9-highbitdepth \
    --disable-docs \
    --disable-tools \
    --disable-examples \
    --disable-webm-io \
    --disable-vp8-encoder \
    --disable-vp9-encoder \
    --prefix="$prefix"
or die "libvpx configure failed"

make -j "$jobs"
or die "libvpx build failed"

make install
or die "libvpx install failed"

note "Installing nv-codec-headers"
cd "$deps_dir/nv-codec-headers"
or die "cannot enter nv-codec-headers source"

make PREFIX="$prefix" install
or die "nv-codec-headers install failed"

note "Building libvpl"
cd "$deps_dir/libvpl"
or die "cannot enter libvpl source"

cmake \
    -S . \
    -B build-cross \
    -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_TOOLCHAIN_FILE="$toolchain" \
    -DCMAKE_INSTALL_PREFIX="$prefix" \
    -DBUILD_EXPERIMENTAL=OFF \
    -DBUILD_SHARED_LIBS=OFF \
    -DCXX_LIB=-lstdc++
or die "libvpl configure failed"

cmake --build build-cross -j "$jobs"
or die "libvpl build failed"

cmake --install build-cross
or die "libvpl install failed"

note "Checking pkg-config dependencies"
for module_name in dav1d vpx libgme vpl
    x86_64-w64-mingw32-pkg-config --modversion "$module_name"
    or die "pkg-config module unavailable: $module_name"
end

note "Building FFmpeg with AV1 CUVID"
cd "$deps_dir/FFmpeg"
or die "cannot enter FFmpeg source"

env \
    PKG_CONFIG_PATH="$prefix/lib/pkgconfig" \
    PKG_CONFIG_LIBDIR="$prefix/lib/pkgconfig" \
    ./configure \
    --enable-version3 \
    --disable-hwaccels \
    --disable-encoders \
    --disable-avisynth \
    --disable-doc \
    --disable-network \
    --disable-programs \
    --disable-outdevs \
    --disable-indevs \
    --disable-avfilter \
    --disable-debug \
    --disable-muxers \
    --enable-avcodec \
    --enable-avformat \
    --enable-swresample \
    --enable-swscale \
    --enable-libdav1d \
    --enable-libvpx \
    --enable-libgme \
    --enable-libvpl \
    --enable-cuvid \
    --enable-decoder=av1_cuvid \
    --pkg-config=x86_64-w64-mingw32-pkg-config \
    --extra-cflags="-I$prefix/include" \
    --extra-ldflags="-L$prefix/lib" \
    --extra-libs=-lpthread \
    --cross-prefix=x86_64-w64-mingw32- \
    --target-os=mingw32 \
    --arch=x86_64 \
    --prefix="$prefix"
or die "FFmpeg configure failed"

grep -q '^CONFIG_CUVID=yes$' ffbuild/config.mak
or die "FFmpeg CONFIG_CUVID is not enabled"

grep -q '^CONFIG_FFNVCODEC=yes$' ffbuild/config.mak
or die "FFmpeg CONFIG_FFNVCODEC is not enabled"

grep -q '^CONFIG_AV1_CUVID_DECODER=yes$' ffbuild/config.mak
or die "FFmpeg CONFIG_AV1_CUVID_DECODER is not enabled"

make -j "$jobs"
or die "FFmpeg build failed"

make install
or die "FFmpeg install failed"

note "Building obuparse"
cd "$deps_dir/obuparse"
or die "cannot enter obuparse source"

make \
    CROSS=x86_64-w64-mingw32- \
    -j "$jobs" \
    libobuparse.a
or die "obuparse build failed"

make \
    CROSS=x86_64-w64-mingw32- \
    PREFIX="$prefix" \
    install-static
or die "obuparse install failed"

note "Building l-smash"
cd "$deps_dir/l-smash"
or die "cannot enter l-smash source"

./configure \
    --cross-prefix=x86_64-w64-mingw32- \
    --target-os=mingw32 \
    --prefix="$prefix" \
    --extra-cflags="-I$prefix/include" \
    --extra-ldflags="-L$prefix/lib"
or die "l-smash configure failed"

make -j "$jobs" lib
or die "l-smash build failed"

make install-lib
or die "l-smash install failed"

note "Building patched L-SMASH Works r1284"
cd "$lsw_source/AviUtl2"
or die "cannot enter L-SMASH Works AviUtl2 source"

env \
    PKG_CONFIG_PATH="$prefix/lib/pkgconfig" \
    PKG_CONFIG_LIBDIR="$prefix/lib/pkgconfig" \
    ./configure \
    --cross-prefix=x86_64-w64-mingw32- \
    --prefix="$prefix" \
    --extra-cflags="-I$prefix/include" \
    --extra-ldflags="-L$prefix/lib -static-libgcc -static-libstdc++ -static" \
    --extra-libs=-lpthread
or die "L-SMASH Works configure failed"

make -j "$jobs" input
or die "L-SMASH Works build failed"

set -l built_aui2 "$lsw_source/AviUtl2/lwinput.aui2"
test -s "$built_aui2"
or die "L-SMASH Works output missing or empty: $built_aui2"

file "$built_aui2" | grep -q 'PE32+ executable'
or die "L-SMASH Works output is not the expected PE32+ binary"

begin
    strings -a -n 5 "$built_aui2"
    strings -a --encoding=l -n 5 "$built_aui2"
end | grep -q 'L-SMASH Works File Reader for AviUtl2 r1284 by Mr-Ojii'
or die "the built plugin does not identify itself as r1284"

strings -a -n 5 "$built_aui2" | grep -q -- '--enable-cuvid'
or die "the built plugin does not contain the expected FFmpeg --enable-cuvid marker"

strings -a -n 5 "$built_aui2" | grep -q -- '--enable-decoder=av1_cuvid'
or die "the built plugin does not contain the expected av1_cuvid configure marker"

cp -a "$built_aui2" "$output_dir/lwinput.aui2"
or die "failed to copy lwinput.aui2 to output"

cp -a "$lsmash_ini" "$output_dir/lsmash.ini"
or die "failed to copy lsmash.ini to output"

set -l output_sha256 (sha256sum "$output_dir/lwinput.aui2" | string split ' ')[1]
set -l output_size (stat -c '%s' "$output_dir/lwinput.aui2")
set -l reference_sha256 fce81e0257a6730ada0729ffddfdb51d1528f8b4bdfb61488a7d01b074ab0fc3
set -l reference_size 26945536
set -l reference_xxh3 87dcdf17b419392c8172b843ab26e0a9

begin
    echo "L-SMASH Works NVDEC build provenance"
    echo "generated_at="(date --iso-8601=seconds)
    echo "work_dir=$work_dir"
    echo "prefix=$prefix"
    echo "jobs=$jobs"
    echo
    echo "source_commits:"
    echo "L-SMASH-Works=$lsw_patched_commit"
    echo "zlib=$zlib_commit"
    echo "game-music-emu=$gme_commit"
    echo "dav1d=$dav1d_commit"
    echo "libvpx=$libvpx_commit"
    echo "nv-codec-headers=$nvcodec_commit"
    echo "libvpl=$libvpl_commit"
    echo "FFmpeg=$ffmpeg_commit"
    echo "obuparse=$obuparse_commit"
    echo "l-smash=$lsmash_commit"
    echo
    echo "artifact:"
    echo "size=$output_size"
    echo "sha256=$output_sha256"
    echo "reference_size=$reference_size"
    echo "reference_sha256=$reference_sha256"
    echo "reference_xxh3_128=$reference_xxh3"
    echo
    echo "tool_versions:"
    x86_64-w64-mingw32-gcc --version | head -n 1
    cmake --version | head -n 1
    meson --version
    ninja --version
    nasm -v
    make --version | head -n 1
    pkg-config --version
end > "$output_dir/PROVENANCE.txt"
or die "failed to write provenance file"

sha256sum \
    "$output_dir/lwinput.aui2" \
    "$output_dir/lsmash.ini" \
    > "$output_dir/SHA256SUMS"
or die "failed to write SHA256SUMS"

note "Build completed"
echo "Output directory: $output_dir"
echo "lwinput.aui2 size: $output_size"
echo "lwinput.aui2 SHA-256: $output_sha256"
echo "Reference size: $reference_size"
echo "Reference SHA-256: $reference_sha256"
echo

if test "$output_sha256" = "$reference_sha256"
    echo "RESULT: byte-for-byte match with the original validated artifact"
else
    echo "RESULT: not a byte-for-byte match with the original artifact"
    echo "This is expected when the absolute build prefix or toolchain version differs."
    echo "The script already verified the pinned source commit, r1284 identity,"
    echo "and embedded AV1 CUVID configuration. Runtime validation is still required."
end

echo
echo "The plugin has NOT been installed into any Wine prefix."
echo "Pause Mr-Ojii.L-SMASH-Works in AviUtl2 Catalog before installing it."
