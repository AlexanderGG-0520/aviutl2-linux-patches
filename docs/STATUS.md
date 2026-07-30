# Current Status

Validated on 2026-07-31.

## Working

- AviUtl2 startup under GE-Proton
- Patched DXVK D3D11 format probing
- AV1 import
- AV1 playback
- Seeking
- NVIDIA NVDEC hardware-frame transfer
- DirectWrite `HitTestTextRange()`
- DirectWrite `HitTestPoint()`
- Entry into the AviUtl2 text-editing state with IME enabled

## Not yet generalized

- AMD GPU decoding
- Intel GPU decoding
- Other Wine and GE-Proton releases
- Other DXVK versions
- Every video codec and pixel format
- Every desktop environment
- Every input method
- Complete native Windows behavior parity

## Important distinction

Disabling XIM prevented the original crash, but XIM itself was not the root
cause.

Both X11 and native Wayland reached the same AviUtl2 failure. The actual cause
was AviUtl2 receiving `E_NOTIMPL` from Wine DirectWrite hit-testing methods.
