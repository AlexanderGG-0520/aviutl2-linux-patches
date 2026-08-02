# This file is sourced by scripts/setup-aviutl2-interactive.fish.

function latest_diagnostic_log
    test -d "$ROOT/logs"
    or return 1

    if test (count $argv) -gt 1
        return 64
    end

    set -l reference_path ''
    if test (count $argv) -eq 1
        set reference_path "$argv[1]"

        test -f "$reference_path"
        or return 1
    end

    set -l latest_path \
        (python3 -c '
import pathlib
import sys

logs = pathlib.Path(sys.argv[1])
reference = pathlib.Path(sys.argv[2]) if sys.argv[2] else None

if not logs.is_dir():
    raise SystemExit(1)

minimum_mtime = reference.stat().st_mtime_ns if reference else -1
candidates = [
    path
    for path in logs.glob("aviutl2-section13-*.log")
    if path.is_file()
    and path.stat().st_size > 0
    and path.stat().st_mtime_ns > minimum_mtime
]

if not candidates:
    raise SystemExit(1)

latest = max(candidates, key=lambda path: (path.stat().st_mtime_ns, path.name))
print(latest.resolve(strict=True))
' "$ROOT/logs" "$reference_path")
    set -l selection_status $status

    test $selection_status -eq 0
    and test -n "$latest_path"
    and test -s "$latest_path"
    or return 1

    printf '%s\n' "$latest_path"
end

function write_gui_verification_marker --argument-names latest_log
    set -l dwrite_path \
        "$GE_PROTON_ROOT/files/lib/wine/x86_64-windows/dwrite.dll"
    set -l dwrite_sha (file_sha256 "$dwrite_path")
    set -l dwrite_status $status
    set -l log_sha (file_sha256 "$latest_log")
    set -l log_status $status

    test $dwrite_status -eq 0
    and test $log_status -eq 0
    or die 'failed to calculate GUI verification evidence hashes'

    set -l temporary_marker \
        "$GUI_VERIFICATION_MARKER.tmp-"(date +%Y%m%d-%H%M%S-%N)

    test ! -e "$temporary_marker"
    or die "temporary GUI marker already exists: $temporary_marker"

    set -l previous_umask (umask)
    umask 077

    printf '%s\n' \
        'verification_version=1' \
        "verified_at="(date --iso-8601=seconds) \
        "root=$ROOT" \
        "prefix=$PREFIX" \
        "ge_proton_root=$GE_PROTON_ROOT" \
        "dwrite_sha256=$dwrite_sha" \
        "latest_log=$latest_log" \
        "latest_log_sha256=$log_sha" \
        'diagnostic_status=0' \
        > "$temporary_marker"
    set -l write_status $status

    umask "$previous_umask"

    test $write_status -eq 0
    or begin
        rm -f -- "$temporary_marker"
        die 'failed to write GUI verification marker'
    end

    chmod 0600 "$temporary_marker"
    or begin
        rm -f -- "$temporary_marker"
        die 'failed to protect GUI verification marker'
    end

    mv -fT -- "$temporary_marker" "$GUI_VERIFICATION_MARKER"
    or begin
        rm -f -- "$temporary_marker"
        die 'failed to atomically publish GUI verification marker'
    end

    test (stat -c '%a' "$GUI_VERIFICATION_MARKER") = 600
    or die 'GUI verification marker mode is not 0600'

    success "GUI verification marker written: $GUI_VERIFICATION_MARKER"
end

function validate_gui_verification_marker
    test -f "$GUI_VERIFICATION_MARKER"
    and test ! -L "$GUI_VERIFICATION_MARKER"
    or return 1

    test (stat -c '%a' "$GUI_VERIFICATION_MARKER") = 600
    or return 1

    test (stat -c '%u' "$GUI_VERIFICATION_MARKER") = (id -u)
    or return 1

    set -l dwrite_path \
        "$GE_PROTON_ROOT/files/lib/wine/x86_64-windows/dwrite.dll"
    set -l current_dwrite_sha (file_sha256 "$dwrite_path")
    set -l dwrite_status $status

    test $dwrite_status -eq 0
    or return $dwrite_status

    set -l verified_log \
        (python3 -c '
import hashlib
import pathlib
import sys

marker_path = pathlib.Path(sys.argv[1])
root = pathlib.Path(sys.argv[2])
expected_prefix = sys.argv[3]
expected_ge = sys.argv[4]
expected_dwrite_sha = sys.argv[5]

data = {}
for line in marker_path.read_text(encoding="utf-8").splitlines():
    key, separator, value = line.partition("=")
    if not separator or not key or key in data:
        raise SystemExit("invalid or duplicate GUI verification marker field")
    data[key] = value

required = {
    "verification_version",
    "verified_at",
    "root",
    "prefix",
    "ge_proton_root",
    "dwrite_sha256",
    "latest_log",
    "latest_log_sha256",
    "diagnostic_status",
}
missing = sorted(required - data.keys())
if missing:
    raise SystemExit("missing GUI verification marker fields: " + ", ".join(missing))

if data["verification_version"] != "1":
    raise SystemExit("unsupported GUI verification marker version")
if data["root"] != str(root):
    raise SystemExit("GUI marker root mismatch")
if data["prefix"] != expected_prefix:
    raise SystemExit("GUI marker prefix mismatch")
if data["ge_proton_root"] != expected_ge:
    raise SystemExit("GUI marker GE-Proton mismatch")
if data["dwrite_sha256"] != expected_dwrite_sha:
    raise SystemExit("GUI marker DWrite hash mismatch")
if data["diagnostic_status"] != "0":
    raise SystemExit("GUI marker diagnostic status is not zero")

log_path = pathlib.Path(data["latest_log"])
if not log_path.is_absolute() or not log_path.is_file():
    raise SystemExit("GUI marker diagnostic log is missing")

resolved_log = log_path.resolve(strict=True)
resolved_logs_root = (root / "logs").resolve(strict=True)
if resolved_log.parent != resolved_logs_root:
    raise SystemExit("GUI marker diagnostic log is outside the configured logs directory")
if not resolved_log.name.startswith("aviutl2-section13-") or resolved_log.suffix != ".log":
    raise SystemExit("GUI marker diagnostic log name is invalid")

digest = hashlib.sha256()
with resolved_log.open("rb") as handle:
    for chunk in iter(lambda: handle.read(1024 * 1024), b""):
        digest.update(chunk)

if digest.hexdigest() != data["latest_log_sha256"]:
    raise SystemExit("GUI marker diagnostic log hash mismatch")

print(resolved_log)
' \
            "$GUI_VERIFICATION_MARKER" \
            "$ROOT" \
            "$PREFIX" \
            "$GE_PROTON_ROOT" \
            "$current_dwrite_sha")
    set -l marker_status $status

    test $marker_status -eq 0
    or return $marker_status

    success "GUI verification evidence validated: $verified_log"
end

function diagnostic_launch
    note 'Section 13 診断起動'

    validate_runtime

    fish -n "$REPO/scripts/diagnose-aviutl2-launch.fish"
    or die 'diagnostic launcher syntax validation failed'

    echo
    echo 'AviUtl2を起動する。GUI確認後、AviUtl2を閉じると対話setupへ戻る。'
    echo

    rm -f -- "$GUI_VERIFICATION_MARKER"
    or die 'failed to invalidate the previous GUI verification marker'

    set -l diagnostic_start_marker \
        "$SETUP_STATE_DIR/diagnostic-start-"(date +%Y%m%d-%H%M%S-%N)

    test ! -e "$diagnostic_start_marker"
    or die "diagnostic start marker already exists: $diagnostic_start_marker"

    touch "$diagnostic_start_marker"
    or die 'failed to create diagnostic start marker'

    fish \
        "$REPO/scripts/diagnose-aviutl2-launch.fish" \
        --root "$ROOT" \
        --prefix "$PREFIX" \
        --ge-proton-root "$GE_PROTON_ROOT" \
        --dxvk-config "$DXVK_CONFIG_FILE"
    set -l launch_status $status

    set -l latest_log (latest_diagnostic_log "$diagnostic_start_marker")
    set -l latest_log_status $status

    rm -f -- "$diagnostic_start_marker"
    or die 'failed to remove diagnostic start marker'

    test $launch_status -eq 0
    or die "diagnostic launcher exited with status $launch_status"

    test $latest_log_status -eq 0
    and test -n "$latest_log"
    and test -s "$latest_log"
    or die 'diagnostic launcher succeeded but no non-empty Section 13 log was found'

    echo "LATEST_LOG=$latest_log"

    set -l caught_cpp_matches \
        (grep -nEi \
            'EXCEPTION_WINE_CXX_EXCEPTION' \
            "$latest_log")
    set -l caught_cpp_scan_status $status

    switch $caught_cpp_scan_status
        case 0
            echo
            echo 'Caught C++ exception records (informational):'
            printf '%s\n' $caught_cpp_matches | tail -n 200
            set -l display_statuses $pipestatus

            for display_status in $display_statuses
                test $display_status -eq 0
                or die 'failed to display caught C++ exception records'
            end
        case 1
        case '*'
            die "failed to scan caught C++ exception records; grep status: $caught_cpp_scan_status"
    end

    set -l fatal_matches \
        (grep -nEi \
            'dwrite:.*stub|Unhandled exception|unhandled page fault|c0000135|Application could not be started|ShellExecuteEx failed|File not found|failed to load|could not load' \
            "$latest_log")
    set -l fatal_scan_status $status

    switch $fatal_scan_status
        case 0
            echo
            echo 'Fatal marker scan:'

            printf '%s\n' $fatal_matches \
                | tail -n 200
            set -l display_statuses $pipestatus

            for display_status in $display_statuses
                test $display_status -eq 0
                or die 'failed to display diagnostic fatal markers'
            end

            die "fatal marker found in diagnostic log: $latest_log"
        case 1
            success 'no fatal marker found in the diagnostic log'
        case '*'
            die "failed to scan diagnostic log; grep status: $fatal_scan_status"
    end

    if test "$ASSUME_YES" -eq 1
        warn '--assume-yes cannot certify GUI behavior; GUI verification is left unconfirmed'
        return 0
    end

    note 'GUI回帰確認'

    set -l failed_checks 0

    for check in \
        'AviUtl2メインウィンドウが表示された' \
        '日本語UIを正常に読めた' \
        'format 69 / D3D RDMs error dialogが出なかった' \
        'text objectの追加・選択・caret移動・再編集ができた' \
        'Mozcで日本語入力・変換・Enter確定ができた' \
        '「プラグインを信頼する」を押してもクラッシュしなかった'

        if ask_yes_no "$check" yes
            success "$check"
        else
            warn "未確認または失敗: $check"
            set failed_checks (math "$failed_checks + 1")
        end
    end

    if test "$failed_checks" -ne 0
        die "$failed_checks GUI checks were not confirmed; inspect: $latest_log"
    end

    write_gui_verification_marker "$latest_log"
    validate_gui_verification_marker
    or die 'new GUI verification evidence could not be validated'

    success 'Section 13 GUI / text / Mozc verification passed'
end

function normal_launch
    note '通常起動'

    validate_runtime

    fish \
        "$REPO/scripts/launch-aviutl2.fish" \
        --prefix "$PREFIX" \
        --ge-proton-root "$GE_PROTON_ROOT" \
        --dxvk-config "$DXVK_CONFIG_FILE"
end
