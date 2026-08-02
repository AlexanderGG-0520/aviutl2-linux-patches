#!/usr/bin/env fish
#
# Interactive AviUtl2 2.1.3 setup for CachyOS / Arch Linux.
#
# Sources of truth:
#   docs/INSTALLATION.md
#   docs/LUTRIS-CATALOG.md (separate Catalog / Lutris continuation)
#

set -g SCRIPT_NAME (basename (status filename))
set -g SCRIPT_PATH (realpath (status filename))
set -g SCRIPT_DIR (dirname "$SCRIPT_PATH")
set -g REPO (realpath "$SCRIPT_DIR/..")

set -g ASSUME_YES 0
set -g SKIP_DEPENDENCIES 0
set -g REQUESTED_MODE ''
set -g REQUESTED_ROOT ''
set -g REQUESTED_PREFIX ''
set -g REQUESTED_GE_ROOT ''
set -g JOBS ''

set -g DLL_OVERRIDES \
    'nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite=b'

set -g STOCK_DWRITE_SHA256 \
    '6d92b541c36f2157be264e5803497ab8f17777c1f575e6704fe3450d00f00e32'

set -l MODULE_DIR "$SCRIPT_DIR/lib/setup-aviutl2-interactive"

for module in \
    00-core.fish \
    10-artifacts.fish \
    20-deploy.fish \
    30-verify.fish \
    40-catalog.fish \
    90-main.fish

    set -l module_path "$MODULE_DIR/$module"

    test -f "$module_path"
    or begin
        echo "ERROR: missing setup module: $module_path" >&2
        exit 66
    end

    source "$module_path"
    or begin
        echo "ERROR: failed to source setup module: $module_path" >&2
        exit 1
    end
end

main $argv
exit $status
