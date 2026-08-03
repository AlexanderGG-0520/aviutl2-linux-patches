# This file replaces the earlier generic DXVK marker check. The current
# diagnostic build must retain both the format-69 compatibility path and the
# AviUtl2-scoped CreateTexture2D descriptor logger.

functions --erase dxvk_artifact_valid

function dxvk_artifact_valid
    for dll in d3d11 dxgi d3d10core
        test -s "$DXVK_ARTIFACT_DIR/$dll.dll"
        or return 1
    end

    checksum_directory "$DXVK_ARTIFACT_DIR" SHA256SUMS
    or return 1

    grep -aFq \
        'AviUtl2 compatibility: unsupported' \
        "$DXVK_ARTIFACT_DIR/d3d11.dll"
    or return 1

    grep -aFq \
        'AviUtl2 diagnostic: CreateTexture2D failed during' \
        "$DXVK_ARTIFACT_DIR/d3d11.dll"
end
