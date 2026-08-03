#!/usr/bin/env fish
#
# Interactive AviUtl2 2.1.3 setup for x86_64 Linux.
#
# Sources of truth:
#   docs/INSTALLATION.md
#   docs/PACKAGE-MANAGERS.md
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
    'nvcuda,nvcuvid,nvencodeapi64=n;d3d11,dxgi,d3d10core=n,b;d3dcompiler_47=n,b;dwrite,d2d1=b'

set -g STOCK_DWRITE_SHA256 \
    '6d92b541c36f2157be264e5803497ab8f17777c1f575e6704fe3450d00f00e32'

set -l MODULE_DIR "$SCRIPT_DIR/lib/setup-aviutl2-interactive"

for module in \
    00-core.fish \
    05-repository-validation.fish \
    05a-rendering-diagnostic-validation.fish \
    06-package-managers.fish \
    06a-preserve-arch-ime.fish \
    07-dwrite-provenance.fish \
    08-lsmash-codecs.fish \
    09-dxvk-texture-diagnostics.fish \
    10-artifacts.fish \
    20-deploy.fish \
    30-verify.fish \
    31-gui-reedit-gate.fish \
    32-rendering-media-gate.fish \
    33-rendering-media-marker-validation.fish \
    45-catalog-doc-flow.fish \
    46-catalog-registration-gate.fish \
    47-catalog-fish-wrapper.fish \
    90-main.fish \
    91-d2d1-addarc.fish \
    92-d2d1-patch-format-validation.fish

    set -l module_path "$MODULE_DIR/$module"

    test -f "$module_path"
    or begin
        echo "ERROR: missing setup module: $module_path" >&2
        exit 66
    end

    fish -n "$module_path"
    or begin
        echo "ERROR: invalid Fish syntax in setup module: $module_path" >&2
        exit 2
    end

    source "$module_path"
    or begin
        echo "ERROR: failed to source setup module: $module_path" >&2
        exit 1
    end
end

main $argv
exit $status
