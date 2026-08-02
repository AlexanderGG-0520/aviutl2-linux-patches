# Clean-room DWrite build

This procedure builds the patched PE `dwrite.dll` from an empty workspace and does not reuse an existing Wine source tree, object file, build directory, or previously generated DLL.

## Requirements

On CachyOS / Arch Linux:

```fish
sudo pacman -S --needed \
    base-devel \
    git \
    autoconf \
    automake \
    libtool \
    flex \
    bison \
    mingw-w64-binutils \
    mingw-w64-crt \
    mingw-w64-gcc \
    mingw-w64-headers \
    mingw-w64-winpthreads \
    fish
```

## Build only

```fish
set ROOT \
    "$HOME/Games/aviutl2"

set REPO \
    "$HOME/projects/aviutl2-linux-patches"

set DWRITE_WORK \
    "$ROOT/build/dwrite-clean-room"

set DWRITE_OUTPUT \
    "$ROOT/artifacts/dwrite-clean-room"

bash \
    "$REPO/scripts/build-dwrite-clean-room.sh" \
    --work-dir "$DWRITE_WORK" \
    --output-dir "$DWRITE_OUTPUT" \
    --jobs (nproc)
```

Success requires all of the following:

```text
both repository patches pass patch --dry-run
both repository patches apply without *.rej or *.orig files
HitTestTextPosition is no longer an E_NOTIMPL stub
Wine configures from an empty out-of-tree build directory
make builds dlls/dwrite/x86_64-windows/dwrite.dll
SHA256SUMS verifies the copied artifact
CLEAN_ROOM_DWRITE_BUILD_OK=1 is printed
```

Generated files:

```text
$DWRITE_OUTPUT/dwrite.dll
$DWRITE_OUTPUT/SHA256SUMS
$DWRITE_OUTPUT/BUILD-METADATA.txt
```

## Build and install into an existing GE-Proton runner

The runner directory name is not a correctness condition. The directory may be named `GE-Proton11-1`, `GE-Proton11-1-aviutl2`, or something else. The script accepts the actual runner path and validates the installed DLL with `cmp`.

Example using an existing runner that has already been selected for AviUtl2:

```fish
set GE_PROTON_ROOT \
    "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1"

bash \
    "$REPO/scripts/build-dwrite-clean-room.sh" \
    --work-dir "$DWRITE_WORK" \
    --output-dir "$DWRITE_OUTPUT" \
    --runner-root "$GE_PROTON_ROOT" \
    --jobs (nproc)
```

The install is successful only when these files are byte-identical:

```text
$DWRITE_WORK/build/dlls/dwrite/x86_64-windows/dwrite.dll
$GE_PROTON_ROOT/files/lib/wine/x86_64-windows/dwrite.dll
```

## Why this is clean-room

The script deletes `--work-dir` before every run. It then:

1. initializes a new Git repository;
2. fetches only Wine commit `31af7f983b2e345d11340b120ae3a39d88c9338a`;
3. applies the two repository patches after separate dry-runs;
4. generates `configure` with `./autogen.sh`;
5. configures into a newly created out-of-tree build directory with `--enable-archs=x86_64`;
6. builds the exact PE target `dlls/dwrite/x86_64-windows/dwrite.dll`;
7. writes and verifies SHA-256 metadata;
8. optionally installs into a caller-selected runner and verifies it with `cmp`.

It never assumes that a runner is patched because of its directory name.

## Failure handling

Do not continue to the AviUtl2 launch procedure unless the script ends with:

```text
CLEAN_ROOM_DWRITE_BUILD_OK=1
```

If patching fails, the build and runner installation are not attempted. If `--runner-root` does not exist, the script fails immediately instead of silently selecting another runner.
