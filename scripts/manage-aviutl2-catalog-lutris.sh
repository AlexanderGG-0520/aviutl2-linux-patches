#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_PATH="$(readlink -f -- "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname -- "$SCRIPT_PATH")"
PROJECT_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd -P)"

AVIUTL2_ROOT="${AVIUTL2_ROOT:-$HOME/Games/aviutl2}"
AVIUTL2_PREFIX="${AVIUTL2_PREFIX:-$AVIUTL2_ROOT/prefix-ge-nvdec-test}"
GE_PROTON_ROOT="${GE_PROTON_ROOT:-$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton11-1-aviutl2-test}"

GE_WINE="${GE_WINE:-$GE_PROTON_ROOT/files/lib/wine/x86_64-unix/wine}"
GE_WINESERVER="${GE_WINESERVER:-$GE_PROTON_ROOT/files/bin/wineserver}"
GE_LIBS="${GE_LIBS:-$GE_PROTON_ROOT/files/lib64:$GE_PROTON_ROOT/files/lib:$GE_PROTON_ROOT/files/lib/wine/x86_64-unix:$GE_PROTON_ROOT/files/lib/wine/i386-unix}"

DXVK_CONFIG_FILE="${DXVK_CONFIG_FILE:-$AVIUTL2_ROOT/nvidia-dxvk.conf}"
WINEDLLOVERRIDES_VALUE="${WINEDLLOVERRIDES_VALUE:-nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b}"

CATALOG_REPOSITORY="${CATALOG_REPOSITORY:-Neosku/aviutl2-catalog}"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/aviutl2-linux-patches/aviutl2-catalog"
BACKUP_DIR="${AVIUTL2_CATALOG_BACKUP_DIR:-$HOME/Backups/aviutl2-catalog}"
LUTRIS_DIR="$PROJECT_DIR/lutris"
LUTRIS_YAML="$LUTRIS_DIR/aviutl2-catalog-local.yml"
DESKTOP_FILE="${XDG_DATA_HOME:-$HOME/.local/share}/applications/aviutl2-catalog-wine.desktop"

log() {
    printf '[aviutl2-catalog] %s\n' "$*" >&2
}

die() {
    printf '[aviutl2-catalog] ERROR: %s\n' "$*" >&2
    exit 1
}

require_command() {
    command -v "$1" >/dev/null 2>&1 || die "Required command not found: $1"
}

check_paths() {
    [[ -d "$AVIUTL2_PREFIX/drive_c" ]] || die "Wine prefix not found: $AVIUTL2_PREFIX"
    [[ -x "$GE_WINE" ]] || die "Wine binary not found: $GE_WINE"
    [[ -x "$GE_WINESERVER" ]] || die "wineserver not found: $GE_WINESERVER"
    [[ -f "$DXVK_CONFIG_FILE" ]] || die "DXVK config not found: $DXVK_CONFIG_FILE"
    [[ -f "$GE_PROTON_ROOT/files/lib/wine/x86_64-windows/dwrite.dll" ]] \
        || die "Patched dwrite.dll not found in: $GE_PROTON_ROOT"
}

run_wine() {
    env \
        WINEPREFIX="$AVIUTL2_PREFIX" \
        LD_LIBRARY_PATH="$GE_LIBS" \
        WINEDLLOVERRIDES="$WINEDLLOVERRIDES_VALUE" \
        DXVK_CONFIG_FILE="$DXVK_CONFIG_FILE" \
        DXVK_LOG_LEVEL=warn \
        WINEDEBUG="${WINEDEBUG:--all}" \
        "$GE_WINE" "$@"
}

stop_prefix() {
    log "Stopping processes in prefix: $AVIUTL2_PREFIX"
    env WINEPREFIX="$AVIUTL2_PREFIX" "$GE_WINESERVER" -k 2>/dev/null || true
    sleep 1
}

latest_release_info() {
    require_command gh

    local json tag asset
    json="$(gh release view \
        --repo "$CATALOG_REPOSITORY" \
        --json tagName,assets)"

    tag="$(python3 -c '
import json, sys
data = json.load(sys.stdin)
print(data["tagName"])
' <<<"$json")"

    asset="$(python3 -c '
import json, re, sys
data = json.load(sys.stdin)
names = [a["name"] for a in data.get("assets", [])]
matches = [n for n in names if re.search(r"_x64-setup\.exe$", n, re.I)]
if not matches:
    matches = [n for n in names if n.lower().endswith(".exe") and "setup" in n.lower()]
if not matches:
    raise SystemExit("No x64 setup executable found in the latest release")
print(matches[0])
' <<<"$json")"

    printf '%s\t%s\n' "$tag" "$asset"
}

download_installer() {
    require_command gh
    require_command python3
    mkdir -p "$CACHE_DIR"

    local info tag asset destination
    info="$(latest_release_info)"
    tag="${info%%$'\t'*}"
    asset="${info#*$'\t'}"
    destination="$CACHE_DIR/$asset"

    log "Latest release: $tag"
    log "Installer asset: $asset"

    gh release download "$tag" \
        --repo "$CATALOG_REPOSITORY" \
        --pattern "$asset" \
        --dir "$CACHE_DIR" \
        --clobber

    [[ -s "$destination" ]] || die "Downloaded installer is missing or empty: $destination"
    printf '%s\n' "$destination"
}

find_catalog_exe() {
    local candidate

    for candidate in \
        "$AVIUTL2_PREFIX/drive_c/Program Files/AviUtl2 カタログ/AviUtl2_Catalog.exe" \
        "$AVIUTL2_PREFIX/drive_c/Program Files/aviutl2-catalog/AviUtl2_Catalog.exe" \
        "$AVIUTL2_PREFIX/drive_c/users/$USER/AppData/Local/Programs/AviUtl2 カタログ/AviUtl2_Catalog.exe" \
        "$AVIUTL2_PREFIX/drive_c/users/$USER/AppData/Local/AviUtl2 カタログ/AviUtl2_Catalog.exe"
    do
        if [[ -f "$candidate" ]]; then
            printf '%s\n' "$candidate"
            return 0
        fi
    done

    find "$AVIUTL2_PREFIX/drive_c" \
        -type f \
        -iname 'AviUtl2_Catalog.exe' \
        -print -quit 2>/dev/null
}

find_catalog_settings() {
    find "$AVIUTL2_PREFIX/drive_c/users" \
        -type f \
        -path '*/AppData/*/aviutl2-catalog/settings.json' \
        -print -quit 2>/dev/null
}

find_catalog_uninstaller() {
    local exe dir candidate
    exe="$(find_catalog_exe || true)"

    if [[ -n "$exe" ]]; then
        dir="$(dirname -- "$exe")"
        for candidate in "$dir/uninstall.exe" "$dir/Uninstall.exe"; do
            if [[ -f "$candidate" ]]; then
                printf '%s\n' "$candidate"
                return 0
            fi
        done
    fi

    find "$AVIUTL2_PREFIX/drive_c" \
        -type f \
        \( -iname 'uninstall.exe' -o -iname 'unins000.exe' \) \
        -path '*AviUtl2*Catalog*' \
        -print -quit 2>/dev/null
}

install_only() {
    check_paths
    require_command gh
    require_command python3

    local installer exe
    installer="$(download_installer)"

    stop_prefix
    log "Starting the official installer in the existing patched prefix."
    run_wine "$installer"

    exe="$(find_catalog_exe || true)"
    if [[ -z "$exe" ]]; then
        die "Installer finished, but AviUtl2_Catalog.exe was not found in the prefix."
    fi

    log "Installed executable: $exe"
    register_url_handler

    log "Initial Catalog setup:"
    log "  AviUtl2 is already installed"
    log "  AviUtl2 root: C:\\AviUtl2"
    log "  Portable mode: disabled"
}

launch_catalog() {
    check_paths

    local exe
    exe="$(find_catalog_exe || true)"
    [[ -n "$exe" ]] || die "AviUtl2 Catalog is not installed. Run: $SCRIPT_PATH lutris-install"

    log "Launching: $exe"
    run_wine "$exe" "$@"
}

open_url() {
    local url="${1:-aviutl2-catalog://}"
    launch_catalog "$url"
}

update_catalog() {
    log "Close AviUtl2 and AviUtl2 Catalog before continuing."
    backup_data
    install_only
}

backup_data() {
    check_paths
    require_command tar

    local stamp archive stage settings
    stamp="$(date +%Y%m%d-%H%M%S)"
    archive="$BACKUP_DIR/aviutl2-catalog-$stamp.tar.gz"
    stage="$(mktemp -d)"
    mkdir -p "$BACKUP_DIR" "$stage"

    if [[ -d "$AVIUTL2_PREFIX/drive_c/ProgramData/aviutl2" ]]; then
        mkdir -p "$stage/ProgramData"
        cp -a \
            "$AVIUTL2_PREFIX/drive_c/ProgramData/aviutl2" \
            "$stage/ProgramData/"
    fi

    settings="$(find_catalog_settings || true)"
    if [[ -n "$settings" ]]; then
        mkdir -p "$stage/catalog-config"
        cp -a "$settings" "$stage/catalog-config/settings.json"
    fi

    tar -C "$stage" -czf "$archive" .
    log "Backup created: $archive"
    rm -rf "$stage"
}

status_report() {
    check_paths
    require_command python3

    local exe settings info tag asset
    exe="$(find_catalog_exe || true)"
    settings="$(find_catalog_settings || true)"

    printf 'Prefix: %s\n' "$AVIUTL2_PREFIX"
    printf 'GE-Proton: %s\n' "$GE_PROTON_ROOT"
    printf 'Catalog executable: %s\n' "${exe:-not installed}"
    printf 'Catalog settings: %s\n' "${settings:-not found}"
    printf 'Lutris YAML: %s\n' "$LUTRIS_YAML"
    printf 'Desktop handler: %s\n' "$DESKTOP_FILE"

    if [[ -n "$settings" ]]; then
        python3 -c '
import json, sys
path = sys.argv[1]
try:
    data = json.load(open(path, encoding="utf-8"))
except Exception as exc:
    print(f"Unable to read settings.json: {exc}")
else:
    print("Configured AviUtl2 root:", data.get("aviutl2_root", ""))
    print("Portable mode:", data.get("is_portable_mode", ""))
    print("Catalog version:", data.get("app_version", ""))
' "$settings"
    fi

    if command -v gh >/dev/null 2>&1; then
        info="$(latest_release_info 2>/dev/null || true)"
        if [[ -n "$info" ]]; then
            tag="${info%%$'\t'*}"
            asset="${info#*$'\t'}"
            printf 'Latest upstream release: %s (%s)\n' "$tag" "$asset"
        fi
    fi
}

register_url_handler() {
    require_command python3
    require_command xdg-mime
    mkdir -p "$(dirname -- "$DESKTOP_FILE")"

    python3 -c '
from pathlib import Path
import sys

desktop = Path(sys.argv[1])
script = sys.argv[2].replace("\\", "\\\\").replace("\"", "\\\"")

desktop.write_text(
    "[Desktop Entry]\n"
    "Type=Application\n"
    "Name=AviUtl2 Catalog (Wine)\n"
    f"Exec=\"{script}\" open-url %u\n"
    "NoDisplay=true\n"
    "Terminal=false\n"
    "MimeType=x-scheme-handler/aviutl2-catalog;\n"
    "Categories=AudioVideo;\n",
    encoding="utf-8",
)
' "$DESKTOP_FILE" "$SCRIPT_PATH"

    chmod 0644 "$DESKTOP_FILE"
    if command -v update-desktop-database >/dev/null 2>&1; then
        update-desktop-database "$(dirname -- "$DESKTOP_FILE")"
    fi
    xdg-mime default "$(basename -- "$DESKTOP_FILE")" \
        x-scheme-handler/aviutl2-catalog

    log "Registered Linux deep-link handler: $DESKTOP_FILE"
}

write_lutris_yaml() {
    require_command python3
    mkdir -p "$LUTRIS_DIR"

    python3 -c '
from pathlib import Path
import json
import sys

target = Path(sys.argv[1])
script = sys.argv[2]
project = sys.argv[3]

q = json.dumps
content = f"""name: "AviUtl2 Catalog"
game_slug: aviutl2-catalog
version: "Patched GE-Proton wrapper"
slug: aviutl2-catalog-patched-ge
runner: linux

script:
  game:
    exe: {q(script)}
    args: "launch"
    working_dir: {q(project)}
    launch_configs:
    - name: "Update or reinstall Catalog"
      exe: {q(script)}
      args: "update"
      working_dir: {q(project)}
    - name: "Create Catalog backup"
      exe: {q(script)}
      args: "backup"
      working_dir: {q(project)}

  installer:
  - execute:
      file: {q(script)}
      args: "install-only"
      description: "Installing AviUtl2 Catalog into the existing patched AviUtl2 prefix"
      disable_runtime: true
"""
target.write_text(content, encoding="utf-8")
' "$LUTRIS_YAML" "$SCRIPT_PATH" "$PROJECT_DIR"

    log "Generated Lutris installer: $LUTRIS_YAML"
}

lutris_install() {
    check_paths
    require_command lutris
    require_command gh
    require_command python3

    write_lutris_yaml
    register_url_handler

    log "Opening the local Lutris installer."
    lutris -i "$LUTRIS_YAML"
}

uninstall_catalog() {
    check_paths

    local uninstaller
    uninstaller="$(find_catalog_uninstaller || true)"
    [[ -n "$uninstaller" ]] || die "Catalog uninstaller was not found."

    backup_data
    stop_prefix
    log "Starting uninstaller: $uninstaller"
    run_wine "$uninstaller"
}

print_help() {
    cat <<EOF
Usage:
  $(basename -- "$0") lutris-install
  $(basename -- "$0") install-only
  $(basename -- "$0") launch [catalog arguments...]
  $(basename -- "$0") open-url [aviutl2-catalog://...]
  $(basename -- "$0") update
  $(basename -- "$0") backup
  $(basename -- "$0") status
  $(basename -- "$0") register-url-handler
  $(basename -- "$0") write-lutris-yaml
  $(basename -- "$0") uninstall

Recommended first run:
  $(basename -- "$0") lutris-install

Environment overrides:
  AVIUTL2_ROOT
  AVIUTL2_PREFIX
  GE_PROTON_ROOT
  GE_WINE
  GE_WINESERVER
  GE_LIBS
  DXVK_CONFIG_FILE
  WINEDLLOVERRIDES_VALUE
  AVIUTL2_CATALOG_BACKUP_DIR
EOF
}

main() {
    local command="${1:-help}"
    shift || true

    case "$command" in
        lutris-install)
            lutris_install "$@"
            ;;
        install-only)
            install_only "$@"
            ;;
        launch)
            launch_catalog "$@"
            ;;
        open-url)
            open_url "$@"
            ;;
        update)
            update_catalog "$@"
            ;;
        backup)
            backup_data "$@"
            ;;
        status)
            status_report "$@"
            ;;
        register-url-handler)
            register_url_handler "$@"
            ;;
        write-lutris-yaml)
            write_lutris_yaml "$@"
            ;;
        uninstall)
            uninstall_catalog "$@"
            ;;
        help|-h|--help)
            print_help
            ;;
        *)
            die "Unknown command: $command"
            ;;
    esac
}

main "$@"
