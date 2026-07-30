# AviUtl2 Linux Compatibility Patches

Compatibility patches and configuration examples for running AviUtl2 under
Wine or GE-Proton on Linux.

This repository contains patches, documentation, configuration examples, and
helper scripts. It does not distribute AviUtl2, Wine, GE-Proton, DXVK,
L-SMASH Works, FFmpeg, or NVIDIA binaries.

## Included work

### Wine DirectWrite

File:

```text
patches/wine/0001-implement-dwrite-hit-testing.patch
```

Implements DirectWrite hit-testing functions required by the AviUtl2 text
editor:

- `IDWriteTextLayout::HitTestTextRange()`
- `IDWriteTextLayout::HitTestPoint()`

The original Wine implementation returned `E_NOTIMPL`. AviUtl2 treats these
failures as fatal errors when drawing a selection or entering text-editing
mode.

### DXVK

File:

```text
patches/dxvk/0001-aviutl2-format-support.patch
```

Adjusts the D3D11 format-support path used by AviUtl2. This prevents the
application from failing while checking support for DXGI format ID 69.

The workaround is limited to the `aviutl2.exe` process and only activates when
DXVK has no Vulkan mapping for `DXGI_FORMAT_G8R8_G8B8_UNORM`. Other
applications, and systems where the format has a valid mapping, retain the
upstream DXVK behavior.

### L-SMASH Works

File:

```text
patches/l-smash-works/0001-transfer-hardware-frames-before-output.patch
```

Transfers FFmpeg hardware frames through `av_hwframe_transfer_data()` before
passing them to the existing video-output path.

This enabled the tested AV1 NVDEC import, playback, and seeking workflow.

## Verified environment

- CachyOS
- NVIDIA GeForce RTX 4060 Ti 8 GB
- NVIDIA driver 610.43.3
- GE-Proton 11-1
- Wine-staging 11.0
- DXVK 2.7.1
- AviUtl2
- L-SMASH Works with FFmpeg NVDEC
- Fcitx5 and Mozc
- X11 Wine driver
- Native Wine Wayland driver used during diagnosis

## Verified results

- AviUtl2 starts under the patched GE-Proton installation
- AV1 files import successfully
- AV1 playback works
- Seeking works
- NVIDIA NVDEC hardware frames reach the AviUtl2 video-output path
- DirectWrite text-range hit testing no longer returns `E_NOTIMPL`
- DirectWrite point hit testing no longer returns `E_NOTIMPL`
- AviUtl2 can enter its text-editing state with the host IME enabled

Full behavior should be tested again when changing Wine, GE-Proton, DXVK,
GPU driver, desktop environment, or input method.

## Patch bases

| Component | Base |
| --- | --- |
| DXVK | `c3dd74be6baec53786d4e064a572185b70347a17` |
| L-SMASH Works base | `a47764915f06fcd472e26ba2fbf25aff4b9d252e` |
| L-SMASH Works patched commit | `393df5ef669707f776261e4ac1bcc7e9a9a227ab` |
| Wine baseline file | `layout.c.before-hittest-range-20260731-044134` |
| Wine baseline SHA-256 | `399e6e0597020510ff5d3d2990ec26ab5100932e0c6947559ad74b922bb1aa4e` |
| Wine patched SHA-256 | `1a30645fc65380029d0bc173768a00fab4a46f55263b4564f43a06d81134250c` |

## Applying the patches

### DXVK

```fish
git -C /path/to/dxvk apply \
  patches/dxvk/0001-aviutl2-format-support.patch
```

### L-SMASH Works

```fish
git -C /path/to/L-SMASH-Works am \
  patches/l-smash-works/0001-transfer-hardware-frames-before-output.patch
```

### Wine

The Wine source tree does not need to be a Git repository.

```fish
cd /path/to/wine-source

patch -p1 < \
  /path/to/aviutl2-linux-patches/patches/wine/0001-implement-dwrite-hit-testing.patch
```

## Rebuilding DirectWrite

For the tested Wine build tree:

```fish
set WINE_BUILD "/path/to/wine-build"

rm -f \
  "$WINE_BUILD/dlls/dwrite/x86_64-windows/layout.o" \
  "$WINE_BUILD/dlls/dwrite/x86_64-windows/dwrite.dll"

make -C "$WINE_BUILD" \
  -j(nproc) \
  dlls/dwrite/x86_64-windows/dwrite.dll
```

Do not use `make -B` unless the entire Wine configure environment is complete.
It can force `configure` to run again and fail on unrelated dependencies.

## Installing the patched DirectWrite DLL

```fish
scripts/install-dwrite.fish \
  /path/to/wine-build \
  /path/to/GE-Proton11-1
```

The script modifies only the selected GE-Proton installation and creates a
timestamped backup first.

## Configuration examples

- `config/nvidia-dxvk.conf`
- `config/lsmash.ini`
- `scripts/launch-aviutl2.example.fish`

## Documentation

- `docs/FINAL-SUMMARY.md` — completed project summary and final state
- `docs/REPRODUCTION.md` — full reproduction procedure
- `docs/STATUS.md`
- `docs/TECHNICAL-NOTES.md`
- `docs/TROUBLESHOOTING.md`

## Licensing

Patch files are derivative works of their respective upstream projects and
remain subject to the corresponding upstream licenses.

Original helper scripts and documentation in this repository are available
under the MIT License.

See `NOTICE.md` and `LICENSES/`.
