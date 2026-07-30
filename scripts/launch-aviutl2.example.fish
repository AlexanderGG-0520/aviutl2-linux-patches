#!/usr/bin/env fish

if not set -q AVIUTL2_ROOT
    set AVIUTL2_ROOT "$HOME/Games/aviutl2"
end

if not set -q AVIUTL2_PREFIX
    set AVIUTL2_PREFIX "$AVIUTL2_ROOT/prefix-ge-nvdec-test"
end

if not set -q GE_PROTON_ROOT
    set GE_PROTON_ROOT         "$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test"
end

set GE_WINE     "$GE_PROTON_ROOT/files/lib/wine/x86_64-unix/wine"

set GE_WINESERVER     "$GE_PROTON_ROOT/files/bin/wineserver"

set GE_LIBS     "$GE_PROTON_ROOT/files/lib64:$GE_PROTON_ROOT/files/lib:$GE_PROTON_ROOT/files/lib/wine/x86_64-unix:$GE_PROTON_ROOT/files/lib/wine/i386-unix"

set AVIUTL2_DIR     "$AVIUTL2_PREFIX/drive_c/AviUtl2"

env     WINEPREFIX="$AVIUTL2_PREFIX"     "$GE_WINESERVER" -k 2>/dev/null

sleep 1

cd "$AVIUTL2_DIR"

env     WINEPREFIX="$AVIUTL2_PREFIX"     LD_LIBRARY_PATH="$GE_LIBS"     WINEDLLOVERRIDES="nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b"     DXVK_CONFIG_FILE="$AVIUTL2_ROOT/nvidia-dxvk.conf"     DXVK_LOG_LEVEL=warn     WINEDEBUG=-all     "$GE_WINE" ./aviutl2.exe
