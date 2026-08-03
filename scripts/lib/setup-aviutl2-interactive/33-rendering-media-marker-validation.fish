# Old GUI markers only covered startup, text editing, and IME behavior. Require
# explicit rendering/media evidence before allowing Catalog continuation.

functions -c validate_gui_verification_marker validate_gui_verification_marker_base
functions --erase validate_gui_verification_marker

function validate_gui_verification_marker
    test -f "$GUI_VERIFICATION_MARKER"
    and test ! -L "$GUI_VERIFICATION_MARKER"
    or return 1

    grep -qx \
        'rendering_media_checks=passed' \
        "$GUI_VERIFICATION_MARKER"
    or return 1

    validate_gui_verification_marker_base
end
