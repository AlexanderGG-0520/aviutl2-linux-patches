#!/usr/bin/env bash
# Reproducible, fail-fast AviUtl2 helper.  All mutation is an explicit *apply command.
set -Eeuo pipefail
IFS=$'\n\t'

DLLS=(d3d11.dll dxgi.dll d3d10core.dll)
REPO="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
note() { printf '%s\n' "$*"; }
need() { command -v "$1" >/dev/null 2>&1 || die "required command not found: $1"; }
hash() { sha256sum -- "$1" | awk '{print $1}'; }
abs() { realpath -m -- "$1"; }
stamp() { date -u +%Y%m%dT%H%M%SZ; }
req_file() { [[ -f "$1" ]] || die "required file does not exist: $1"; }
req_dir() { [[ -d "$1" ]] || die "required directory does not exist: $1"; }

# Destination paths must be already rooted under an existing parent.  Literal
# dollars are forbidden so a shell expression can never become a destination.
safe_destination() {
  local p="$1" root="$2" parent resolved canonical_parent
  [[ -n "$p" && "$p" != *'$'* && "$p" != *$'\n'* && "$p" != *$'\r'* ]] || die "unsafe unresolved path: ${p:-<empty>}"
  [[ "${p##*/}" != . && "${p##*/}" != .. && -n "${p##*/}" ]] || die "unsafe final target: $p"
  resolved="$(abs "$p")"; root="$(abs "$root")"; parent="$(dirname -- "$resolved")"
  [[ "$resolved" != / && "$resolved" != "$HOME" && "$resolved" != "$REPO" ]] || die "unsafe target path: $resolved"
  [[ -d "$parent" ]] || die "target parent does not exist: $parent"
  canonical_parent="$(realpath -- "$parent")"
  [[ "$canonical_parent" == "$root" || "$canonical_parent" == "$root"/* ]] || die "target parent is outside expected root ($root): $canonical_parent"
  printf '%s\n' "$resolved"
}
copy_checked() { cp -a -- "$1" "$2"; [[ "$(hash "$1")" == "$(hash "$2")" ]] || die "copy hash mismatch: $2"; }
marker_ok() { LC_ALL=C grep -aFq 'AviUtl2 compatibility' "$1"; }
ge_ok() { [[ -x "$1/files/lib/wine/x86_64-unix/wine" && -x "$1/files/bin/wineserver" && -f "$1/files/lib/wine/x86_64-windows/dwrite.dll" ]]; }
prefix_ok() { [[ -d "$1/drive_c/windows/system32" && -f "$1/user.reg" && -f "$1/system.reg" ]]; }

find_ge() {
  local root="$1" x candidates=()
  req_dir "$root"
  shopt -s nullglob
  for x in "$root"/*; do [[ -d "$x" ]] && ge_ok "$x" && candidates+=("$x"); done
  shopt -u nullglob
  ((${#candidates[@]} == 1)) || die "expected exactly one complete GE-Proton directory under $root; found ${#candidates[@]}"
  abs "${candidates[0]}"
}

verify_archive() { req_file "$1"; req_file "$2"; local expected; expected="$(awk 'NR==1 {print $1}' "$2")"; [[ "$expected" =~ ^[[:xdigit:]]{64}$ ]] || die "invalid archive SHA-256 file: $2"; [[ "$(hash "$1")" == "$expected" ]] || die "archive SHA-256 verification failed: $1"; }
inspect_archive() {
  local archive="$1" line name type roots=()
  while IFS= read -r line; do
    type="${line:0:1}"; name="${line#* }"; name="${name#* }"; name="${name#* }"; name="${name#* }"; name="${name#* }"; name="${name#* }"; name="${name#* }"; name="${name#* }"
    # GNU tar's verbose format is not a security parser; names are separately
    # read below.  Reject special file types here.
    [[ "$type" != b && "$type" != c && "$type" != p && "$type" != s ]] || die "unsafe special archive entry: $line"
  done < <(tar -tvf "$archive")
  while IFS= read -r name; do
    [[ "$name" != /* && "/$name/" != *'/../'* && "$name" != .. && "$name" != */.. ]] || die "unsafe archive path: $name"
    roots+=("${name%%/*}")
  done < <(tar -tf "$archive")
  local unique; unique="$(printf '%s\n' "${roots[@]}" | sort -u | wc -l)"
  [[ "$unique" == 1 ]] || die "archive must contain exactly one top-level root"
}
extract_and_verify() {
  local archive="$1" import="$2" top
  [[ ! -e "$import" ]] || die "dedicated import directory already exists: $import"
  inspect_archive "$archive"
  mkdir -- "$import"
  tar -xf "$archive" -C "$import" || die "archive extraction failed"
  top="$(tar -tf "$archive" | sed -n '1p' | cut -d/ -f1)"; req_dir "$import/$top"; req_file "$import/$top/SHA256SUMS"
  (cd "$import/$top" && sha256sum -c SHA256SUMS >/dev/null) || die "internal SHA-256 verification failed"
  printf '%s\n' "$(realpath -- "$import/$top")"
}

full_preflight() {
  local import="$1" avi="$2" ge
  req_dir "$import"; req_file "$import/SHA256SUMS"; (cd "$import" && sha256sum -c SHA256SUMS >/dev/null) || die "imported asset SHA-256 verification failed"
  ge="$(find_ge "$import/ge")" || die "GE-Proton candidate validation failed"; req_file "$avi/aviutl2.exe"
  local f; for f in "${DLLS[@]}"; do req_file "$import/dxvk/$f"; done
  req_file "$import/plugin/lwinput.aui2"; req_file "$import/plugin/lsmash.ini"; req_file "$import/config/nvidia-dxvk.conf"
  printf '%s\n' "$ge"
}

TX_GE_OLD=0 TX_GE_NEW=0 TX_PREFIX_OLD=0 TX_PREFIX_NEW=0 TX_CONFIG_OLD=0 TX_CONFIG_NEW=0 TX_ACTIVE=0
rollback_full() {
  ((TX_ACTIVE)) || return 0
  set +e; note "ERROR: full-environment transaction failed; attempting rollback"
  [[ $TX_CONFIG_NEW == 1 && -e $TX_CONFIG_TARGET ]] && mv -- "$TX_CONFIG_TARGET" "$TX_CONFIG_STAGE"
  [[ $TX_CONFIG_OLD == 1 && -e $TX_CONFIG_BACKUP ]] && mv -- "$TX_CONFIG_BACKUP" "$TX_CONFIG_TARGET"
  [[ $TX_PREFIX_NEW == 1 && -e $TX_PREFIX_TARGET ]] && mv -- "$TX_PREFIX_TARGET" "$TX_PREFIX_STAGE"
  [[ $TX_PREFIX_OLD == 1 && -e $TX_PREFIX_BACKUP ]] && mv -- "$TX_PREFIX_BACKUP" "$TX_PREFIX_TARGET"
  [[ $TX_GE_NEW == 1 && -e $TX_GE_TARGET ]] && mv -- "$TX_GE_TARGET" "$TX_GE_STAGE"
  [[ $TX_GE_OLD == 1 && -e $TX_GE_BACKUP ]] && mv -- "$TX_GE_BACKUP" "$TX_GE_TARGET"
  local bad=0
  [[ $TX_GE_OLD == 0 || -e $TX_GE_TARGET ]] || { note "rollback failed: $TX_GE_TARGET backup=$TX_GE_BACKUP stage=$TX_GE_STAGE; recover: mv -- '$TX_GE_BACKUP' '$TX_GE_TARGET'"; bad=1; }
  [[ $TX_PREFIX_OLD == 0 || -e $TX_PREFIX_TARGET ]] || { note "rollback failed: $TX_PREFIX_TARGET backup=$TX_PREFIX_BACKUP stage=$TX_PREFIX_STAGE; recover: mv -- '$TX_PREFIX_BACKUP' '$TX_PREFIX_TARGET'"; bad=1; }
  [[ $TX_CONFIG_OLD == 0 || -e $TX_CONFIG_TARGET ]] || { note "rollback failed: $TX_CONFIG_TARGET backup=$TX_CONFIG_BACKUP stage=$TX_CONFIG_STAGE; recover: mv -- '$TX_CONFIG_BACKUP' '$TX_CONFIG_TARGET'"; bad=1; }
  TX_ACTIVE=0; ((bad == 0)) || return 1
}
trap 'rollback_full' ERR INT TERM
tx_mv() { local kind="$1" from="$2" to="$3"; [[ "${AVIUTL2_REPRO_TEST_FAIL_MV:-}" != "$kind" ]] || return 1; mv -- "$from" "$to"; }

cmd_import() {
  local archive='' sums='' import='' root=''; while (($#)); do case "$1" in --archive) archive="$2"; shift 2;; --archive-sha256) sums="$2"; shift 2;; --import-dir) import="$2"; shift 2;; --root) root="$2"; shift 2;; *) die "unknown import option: $1";; esac; done
  local extracted
  req_dir "$root"; import="$(safe_destination "$import" "$root")"; verify_archive "$archive" "$sums"
  extracted="$(extract_and_verify "$archive" "$import")" || die 'archive extraction or internal verification failed'
  note "Imported and internally verified: $extracted"
}

cmd_apply() {
  local import='' avi='' root='' compat='' ge_target='' prefix_target='' dry=0
  while (($#)); do case "$1" in --import-root) import="$2"; shift 2;; --aviutl2-source) avi="$2"; shift 2;; --root) root="$2"; shift 2;; --compat-root) compat="$2"; shift 2;; --ge-target) ge_target="$2"; shift 2;; --prefix-target) prefix_target="$2"; shift 2;; --dry-run) dry=1; shift;; *) die "unknown apply option: $1";; esac; done
  req_dir "$root"; req_dir "$compat"; ge_target="$(safe_destination "$ge_target" "$compat")"; prefix_target="$(safe_destination "$prefix_target" "$root")"; local ge; ge="$(full_preflight "$(abs "$import")" "$avi")"
  local ts
  ts="$(stamp)"; TX_GE_TARGET="$ge_target"; TX_PREFIX_TARGET="$prefix_target"; TX_CONFIG_TARGET="$root/nvidia-dxvk.conf"; TX_GE_STAGE="$compat/.${ge_target##*/}.new-$ts"; TX_PREFIX_STAGE="$root/.${prefix_target##*/}.new-$ts"; TX_CONFIG_STAGE="$root/.nvidia-dxvk.conf.new-$ts"; TX_GE_BACKUP="$ge_target.backup-$ts"; TX_PREFIX_BACKUP="$prefix_target.backup-$ts"; TX_CONFIG_BACKUP="$TX_CONFIG_TARGET.backup-$ts"
  [[ ! -e $TX_GE_STAGE && ! -e $TX_PREFIX_STAGE && ! -e $TX_CONFIG_STAGE && ! -e $TX_GE_BACKUP && ! -e $TX_PREFIX_BACKUP && ! -e $TX_CONFIG_BACKUP ]] || die 'transaction path collision'
  note "STAGE: $TX_GE_STAGE $TX_PREFIX_STAGE $TX_CONFIG_STAGE"; note "BACKUP: $TX_GE_BACKUP $TX_PREFIX_BACKUP $TX_CONFIG_BACKUP"
  ((dry)) && { note 'DRY RUN: staging and all final replacements listed above; no mutation.'; return; }
  cp -a -- "$ge" "$TX_GE_STAGE"; ge_ok "$TX_GE_STAGE" || die "staged GE-Proton is incomplete: $TX_GE_STAGE"
  mkdir "$TX_PREFIX_STAGE"; local wine="$TX_GE_STAGE/files/lib/wine/x86_64-unix/wine" server="$TX_GE_STAGE/files/bin/wineserver" libs="$TX_GE_STAGE/files/lib64:$TX_GE_STAGE/files/lib:$TX_GE_STAGE/files/lib/wine/x86_64-unix:$TX_GE_STAGE/files/lib/wine/i386-unix"
  env WINEPREFIX="$TX_PREFIX_STAGE" LD_LIBRARY_PATH="$libs" "$wine" wineboot -u || die 'wineboot failed; official targets were not changed'
  env WINEPREFIX="$TX_PREFIX_STAGE" LD_LIBRARY_PATH="$libs" "$server" -w || env WINEPREFIX="$TX_PREFIX_STAGE" LD_LIBRARY_PATH="$libs" "$server" -k
  prefix_ok "$TX_PREFIX_STAGE" || die 'staged prefix is incomplete; official targets were not changed'
  mkdir -p "$TX_PREFIX_STAGE/drive_c/AviUtl2" "$TX_PREFIX_STAGE/drive_c/ProgramData/aviutl2/Plugin"; cp -a -- "$avi/." "$TX_PREFIX_STAGE/drive_c/AviUtl2/"
  local f; for f in "${DLLS[@]}"; do copy_checked "$import/dxvk/$f" "$TX_PREFIX_STAGE/drive_c/windows/system32/$f"; done
  copy_checked "$import/plugin/lwinput.aui2" "$TX_PREFIX_STAGE/drive_c/ProgramData/aviutl2/Plugin/lwinput.aui2"; copy_checked "$import/plugin/lsmash.ini" "$TX_PREFIX_STAGE/drive_c/ProgramData/aviutl2/Plugin/lsmash.ini"; copy_checked "$import/config/nvidia-dxvk.conf" "$TX_CONFIG_STAGE"
  TX_ACTIVE=1
  [[ ! -e $TX_GE_TARGET ]] || { tx_mv ge_backup "$TX_GE_TARGET" "$TX_GE_BACKUP"; TX_GE_OLD=1; }; tx_mv ge_promote "$TX_GE_STAGE" "$TX_GE_TARGET"; TX_GE_NEW=1
  [[ ! -e $TX_PREFIX_TARGET ]] || { tx_mv prefix_backup "$TX_PREFIX_TARGET" "$TX_PREFIX_BACKUP"; TX_PREFIX_OLD=1; }; tx_mv prefix_promote "$TX_PREFIX_STAGE" "$TX_PREFIX_TARGET"; TX_PREFIX_NEW=1
  [[ ! -e $TX_CONFIG_TARGET ]] || { tx_mv config_backup "$TX_CONFIG_TARGET" "$TX_CONFIG_BACKUP"; TX_CONFIG_OLD=1; }; tx_mv config_promote "$TX_CONFIG_STAGE" "$TX_CONFIG_TARGET"; TX_CONFIG_NEW=1
  ge_ok "$TX_GE_TARGET" && prefix_ok "$TX_PREFIX_TARGET" && [[ -f $TX_CONFIG_TARGET ]] || die 'final full-environment verification failed'
  TX_ACTIVE=0; note "Applied successfully. Backups retained: $TX_GE_BACKUP $TX_PREFIX_BACKUP $TX_CONFIG_BACKUP"
}

dxvk_paths() { DX_PREFIX="$(abs "$1")"; DX_BUILD="$(abs "$2")"; DX_SYS="$DX_PREFIX/drive_c/windows/system32"; DX_ROOT="$(dirname -- "$DX_PREFIX")"; }
dxvk_preflight() {
  dxvk_paths "$1" "$2"; req_dir "$DX_PREFIX"; [[ -n "$(find "$DX_PREFIX" -mindepth 1 -maxdepth 1 -print -quit)" ]] || die "target prefix is empty: $DX_PREFIX"; req_dir "$DX_SYS"; req_dir "$DX_BUILD"
  local f; for f in "${DLLS[@]}"; do req_file "$DX_SYS/$f"; req_file "$DX_BUILD/$f"; done
  marker_ok "$DX_BUILD/d3d11.dll" || die "replacement d3d11.dll lacks AviUtl2 compatibility marker: $DX_BUILD/d3d11.dll"
  DX_TS="$(stamp)"; DX_STAGE="$DX_ROOT/.dxvk-stage-$DX_TS"; DX_BACKUP="$DX_ROOT/dxvk-backup-$DX_TS"; [[ ! -e $DX_STAGE && ! -e $DX_BACKUP ]] || die 'DXVK staging/backup collision'
}
dxvk_print_plan() { local f; note "DXVK BUILD: $DX_BUILD"; note "STAGING: $DX_STAGE"; note "BACKUP: $DX_BACKUP"; for f in "${DLLS[@]}"; do note "SOURCE $DX_BUILD/$f $(hash "$DX_BUILD/$f")"; note "TARGET $DX_SYS/$f $(hash "$DX_SYS/$f")"; note "COPY $DX_BUILD/$f -> $DX_STAGE/$f; backup $DX_SYS/$f -> $DX_BACKUP/$f; rename $DX_STAGE/$f -> $DX_SYS/$f; rollback $DX_BACKUP/$f -> $DX_SYS/$f"; done; }
cmd_dxvk_preflight() { local p='' b=''; while (($#)); do case "$1" in --prefix) p="$2"; shift 2;; --build-dir) b="$2"; shift 2;; *) die "unknown dxvk-preflight option: $1";; esac; done; dxvk_preflight "$p" "$b"; dxvk_print_plan; }
cmd_dxvk_dry_run() { cmd_dxvk_preflight "$@"; note 'DXVK DRY RUN: no file or directory was created.'; }
dxvk_restore() { local backup="$1" diagnostic="$2"; local f; mkdir "$diagnostic"; for f in "${DLLS[@]}"; do [[ -f $DX_SYS/$f ]] && cp -a -- "$DX_SYS/$f" "$diagnostic/$f"; done; for f in "${DLLS[@]}"; do cp -a -- "$backup/$f" "$DX_SYS/$f"; [[ "$(hash "$backup/$f")" == "$(hash "$DX_SYS/$f")" ]] || return 1; done; }
cmd_dxvk_apply() {
  local p='' b=''; while (($#)); do case "$1" in --prefix) p="$2"; shift 2;; --build-dir) b="$2"; shift 2;; *) die "unknown dxvk-apply option: $1";; esac; done; dxvk_preflight "$p" "$b"; dxvk_print_plan
  mkdir "$DX_STAGE" "$DX_BACKUP"; local f; for f in "${DLLS[@]}"; do copy_checked "$DX_BUILD/$f" "$DX_STAGE/$f"; copy_checked "$DX_SYS/$f" "$DX_BACKUP/$f"; done
  local i=0; for f in "${DLLS[@]}"; do ((++i)); if [[ "${AVIUTL2_REPRO_TEST_FAIL_DXVK_AFTER:-0}" == "$i" ]]; then dxvk_restore "$DX_BACKUP" "$DX_BACKUP/failed-replacement" || die 'DXVK rollback verification failed'; die 'test-injected DXVK replacement failure; originals restored'; fi; cp -a -- "$DX_STAGE/$f" "$DX_SYS/$f" || { dxvk_restore "$DX_BACKUP" "$DX_BACKUP/failed-replacement" || die 'DXVK rollback verification failed'; die "DXVK replacement failed: $f"; }; done
  for f in "${DLLS[@]}"; do [[ "$(hash "$DX_BUILD/$f")" == "$(hash "$DX_SYS/$f")" ]] || { dxvk_restore "$DX_BACKUP" "$DX_BACKUP/failed-replacement" || die 'DXVK rollback verification failed'; die "DXVK final verification failed: $f"; }; done
  { printf 'timestamp=%s\nprefix=%s\nbuild=%s\nbackup=%s\nmarker=present\n' "$DX_TS" "$DX_PREFIX" "$DX_BUILD" "$DX_BACKUP"; for f in "${DLLS[@]}"; do printf 'source_%s=%s\nprevious_%s=%s\nfinal_%s=%s\n' "$f" "$(hash "$DX_BUILD/$f")" "$f" "$(hash "$DX_BACKUP/$f")" "$f" "$(hash "$DX_SYS/$f")"; done; } > "$DX_BACKUP/manifest.env"
  note "DXVK applied; backup retained: $DX_BACKUP"
}
cmd_dxvk_rollback() {
  local p='' backup='' manifest=''; while (($#)); do case "$1" in --prefix) p="$2"; shift 2;; --backup) backup="$2"; shift 2;; --manifest) manifest="$2"; shift 2;; *) die "unknown dxvk-rollback option: $1";; esac; done
  [[ -z $backup || -z $manifest ]] || die 'provide exactly one of --backup or --manifest'; if [[ -n $manifest ]]; then req_file "$manifest"; backup="$(awk -F= '$1=="backup" {print $2}' "$manifest")"; [[ -n $backup ]] || die "manifest has no backup path: $manifest"; fi
  dxvk_paths "$p" "$(dirname -- "$backup")"; backup="$(abs "$backup")"; req_dir "$backup"; local f count; count="$(find "$backup" -maxdepth 1 -type f -name '*.dll' | wc -l)"; [[ $count == 3 ]] || die "ambiguous or partial DXVK backup: $backup"; for f in "${DLLS[@]}"; do req_file "$backup/$f"; done
  local stage
  stage="$DX_ROOT/.dxvk-restore-stage-$(stamp)"; [[ ! -e $stage ]] || die 'DXVK restore staging collision'; mkdir "$stage"; for f in "${DLLS[@]}"; do copy_checked "$backup/$f" "$stage/$f"; done; dxvk_restore "$stage" "$backup/failed-replacement-$(stamp)" || die 'DXVK restore verification failed'; note "DXVK rollback restored: $backup"
}
cmd_dxvk_validate() { local p='' b=''; while (($#)); do case "$1" in --prefix) p="$2"; shift 2;; --build-dir) b="$2"; shift 2;; *) die "unknown dxvk-validate option: $1";; esac; done; dxvk_preflight "$p" "$b"; local f; for f in "${DLLS[@]}"; do printf 'target %s %s\n' "$DX_SYS/$f" "$(hash "$DX_SYS/$f")"; done; marker_ok "$DX_SYS/d3d11.dll" && printf 'marker: present\n' || printf 'marker: absent\n'; find "$DX_PREFIX" -maxdepth 3 -type f \( -name 'dxvk*.log' -o -name '*aviutl*log*' \) -print; printf '%s\n' 'Runtime evidence required: CheckFormatSupport format=69 hr=0 flags=0 (if trace log exists), original dialog absent, and later format/swapchain progress. Hashes alone prove installation only.'; }

case "${1:-help}" in
  import) shift; cmd_import "$@";; apply) shift; cmd_apply "$@";; dxvk-preflight) shift; cmd_dxvk_preflight "$@";; dxvk-dry-run) shift; cmd_dxvk_dry_run "$@";; dxvk-apply) shift; cmd_dxvk_apply "$@";; dxvk-rollback) shift; cmd_dxvk_rollback "$@";; dxvk-validate) shift; cmd_dxvk_validate "$@";;
  help|-h|--help) cat <<'EOF'
import --root ROOT --archive ARCHIVE --archive-sha256 SIDEcar --import-dir IMPORT
apply --dry-run|--root ROOT --compat-root COMPAT --import-root IMPORT --aviutl2-source ZIPDIR --ge-target TARGET --prefix-target TARGET
dxvk-preflight|dxvk-dry-run|dxvk-apply|dxvk-validate --prefix PREFIX --build-dir DIRECTORY
dxvk-rollback --prefix PREFIX (--backup DIRECTORY | --manifest FILE)
Only apply commands mutate. Validation and dry-run are read-only.
EOF
  ;; *) die "unknown command: $1";;
esac
