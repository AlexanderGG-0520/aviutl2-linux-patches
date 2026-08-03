# This file extends GUI verification beyond text editing. A runtime is not
# considered verified if basic shape rendering or media texture creation fails.

functions -c write_gui_verification_marker write_gui_verification_marker_text_verified
functions --erase write_gui_verification_marker

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
end
