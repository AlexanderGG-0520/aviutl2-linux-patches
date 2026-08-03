# This file replaces the former AV1-only L-SMASH Works artifact check.
# A reusable artifact must contain both CUVID decoders and a codec-selective
# preferred_decoders list so AV1 and HEVC inputs do not share one fixed decoder.

functions --erase lsmash_artifact_valid

function lsmash_binary_has_marker --argument-names binary marker
    strings -a -n 5 "$binary" \
        | grep -q -- "$marker"
end

function lsmash_artifact_valid
    set -l binary "$LSMASH_ARTIFACT_DIR/lwinput.aui2"
    set -l config "$LSMASH_ARTIFACT_DIR/lsmash.ini"

    test -s "$binary"
    and test -s "$config"
    and checksum_directory "$LSMASH_ARTIFACT_DIR" SHA256SUMS
    or return 1

    begin
        strings -a -n 5 "$binary"
        strings -a --encoding=l -n 5 "$binary"
    end | grep -q 'L-SMASH Works File Reader for AviUtl2 r1284 by Mr-Ojii'
    or return 1

    lsmash_binary_has_marker "$binary" '--enable-cuvid'
    or return 1

    for decoder in av1_cuvid hevc_cuvid
        lsmash_binary_has_marker "$binary" "--enable-decoder=$decoder"
        or return 1
    end

    grep -qx 'libavsmash_disabled=1' "$config"
    and grep -qx 'libav_disabled=0' "$config"
    and grep -qx \
        'preferred_decoders=av1_cuvid,hevc_cuvid' \
        "$config"
end
