# This file extends GUI verification beyond text editing. A runtime is not
# considered verified if basic shape rendering or media texture creation fails.

functions -c write_gui_verification_marker write_gui_verification_marker_text_verified
functions --erase write_gui_verification_marker

function add_rendering_media_marker_evidence
    test -f "$GUI_VERIFICATION_MARKER"
    and test ! -L "$GUI_VERIFICATION_MARKER"
    or die 'GUI marker was not created before rendering/media evidence update'

    set -l temporary_marker \
        "$GUI_VERIFICATION_MARKER.tmp-rendering-"(date +%Y%m%d-%H%M%S-%N)

    test ! -e "$temporary_marker"
    or die "temporary rendering/media marker already exists: $temporary_marker"

    set -l previous_umask (umask)
    umask 077

    begin
        cat "$GUI_VERIFICATION_MARKER"
        echo 'rendering_media_checks=passed'
    end > "$temporary_marker"
    set -l write_status $status

    umask "$previous_umask"

    test $write_status -eq 0
    or begin
        rm -f -- "$temporary_marker"
        die 'failed to add rendering/media evidence to GUI marker'
    end

    chmod 0600 "$temporary_marker"
    or begin
        rm -f -- "$temporary_marker"
        die 'failed to protect rendering/media GUI marker'
    end

    mv -fT -- "$temporary_marker" "$GUI_VERIFICATION_MARKER"
    or begin
        rm -f -- "$temporary_marker"
        die 'failed to atomically publish rendering/media GUI evidence'
    end
end

function write_gui_verification_marker --argument-names latest_log
    note '図形描画と動画読込を確認する'

    set -l failed_checks 0

    for check in \
        '図形objectを配置し、preview上に実際に表示された' \
        '動画fileを読み込み、CreateTexture2Dエラーなしでpreview表示できた'

        if ask_yes_no "$check" no
            success "$check"
        else
            warn "未確認または失敗: $check"
            set failed_checks (math "$failed_checks + 1")
        end
    end

    test "$failed_checks" -eq 0
    or die "$failed_checks rendering/media regression checks were not confirmed; GUI marker was not written"

    write_gui_verification_marker_text_verified "$latest_log"
    add_rendering_media_marker_evidence
end
