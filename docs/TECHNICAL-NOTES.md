# Technical Notes

## Problem sequence

### D3D11 startup failure

AviUtl2 queried D3D11 format support for DXGI format ID 69. The original DXVK
behavior caused AviUtl2 to terminate during startup.

The DXVK patch adjusts this format-support path.

### Hardware-decoded AV1 frames

FFmpeg returned hardware-backed frames from the NVDEC decoder. The existing
L-SMASH Works output path expected software-accessible frame data.

The patch calls `av_hwframe_transfer_data()` before the output path consumes
the frame.

### Text selection failure

AviUtl2 called:

```text
IDWriteTextLayout::HitTestTextRange()
```

Wine returned:

```text
HRESULT 0x80004001
E_NOTIMPL
```

AviUtl2 reported the failure from its selection drawing path.

### Text-editing failure

After implementing `HitTestTextRange()`, AviUtl2 still failed when entering
text-editing mode.

The next missing call was:

```text
IDWriteTextLayout::HitTestPoint()
```

Wine again returned `E_NOTIMPL`, and AviUtl2 threw a C++ exception.

The final implementation uses the working `HitTestTextPosition()` path to
inspect text metrics and select the nearest cluster.

## IME investigation

The issue was tested with:

- Fcitx5 and Mozc through Wine XIM
- XIM disabled
- XIM `overthespot`
- Wine native Wayland text input

Disabling XIM hid the error because AviUtl2 did not execute the same editing
path. Native Wayland still produced the same DirectWrite failure, proving that
XIM was not the root cause.

## Build investigation

Several stale-build traps were identified:

1. `make dlls/dwrite` treated the existing directory as an already satisfied
   target.
2. `make -B` forced Wine configure to run again.
3. Configure then failed on an unrelated FreeType dependency.
4. An old `dwrite.dll` was copied after the failed build.
5. Runtime logging still showed `HitTestPoint(): stub`.

The reliable rebuild procedure removes the specific PE object and DLL, then
builds the exact DLL target.
