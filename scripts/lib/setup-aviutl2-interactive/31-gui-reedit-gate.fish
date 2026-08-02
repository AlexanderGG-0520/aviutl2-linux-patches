# This file strengthens Section 13 GUI verification. A successful first text
# edit is insufficient; the same object must survive a second edit session and
# repeated caret positioning before GUI-VERIFIED may be written.

functions -c write_gui_verification_marker write_gui_verification_marker_base
functions --erase write_gui_verification_marker

function write_gui_verification_marker --argument-names latest_log
    note 'text objectの2回目再編集を確認する'

    set -l failed_checks 0

    for check in \
        '同じtext objectで1回目の日本語入力を確定し、編集状態を一度終了した' \
        '同じtext objectを再選択して2回目の編集状態へ入れた' \
        '2回目の編集状態でcaretを異なる位置へ2回以上移動してもエラーが出なかった' \
        '2回目の編集状態でもMozcで日本語入力・変換・Enter確定ができた'

        if ask_yes_no "$check" no
            success "$check"
        else
            warn "未確認または失敗: $check"
            set failed_checks (math "$failed_checks + 1")
        end
    end

    test "$failed_checks" -eq 0
    or die "$failed_checks second-edit regression checks were not confirmed; GUI marker was not written"

    write_gui_verification_marker_base "$latest_log"
end
