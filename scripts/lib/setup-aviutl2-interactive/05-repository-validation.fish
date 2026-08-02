# This file is sourced after 00-core.fish and replaces its broad
# validate_repository implementation with mode-specific validation.

functions --erase validate_repository

function validate_installation_repository
    note 'INSTALLATION.mdと導入用scriptを確認する'

    for path in \
        "$REPO/docs/INSTALLATION.md" \
        "$REPO/scripts/build-dwrite-clean.fish" \
        "$REPO/scripts/install-dwrite.fish" \
        "$REPO/scripts/build-dxvk-aviutl2.sh" \
        "$REPO/scripts/prepare-aviutl2-fonts.py" \
        "$REPO/scripts/prepare-nvidia-libs.fish" \
        "$REPO/scripts/build-l-smash-works-nvdec.fish" \
        "$REPO/scripts/preflight-aviutl2-installation.fish" \
        "$REPO/scripts/bootstrap-aviutl2-prefix.fish" \
        "$REPO/scripts/configure-aviutl2-prefix.fish" \
        "$REPO/scripts/diagnose-aviutl2-launch.fish" \
        "$REPO/scripts/launch-aviutl2.fish"

        require_path "$path"
    end

    for script in \
        "$REPO/scripts/build-dwrite-clean.fish" \
        "$REPO/scripts/install-dwrite.fish" \
        "$REPO/scripts/prepare-nvidia-libs.fish" \
        "$REPO/scripts/build-l-smash-works-nvdec.fish" \
        "$REPO/scripts/preflight-aviutl2-installation.fish" \
        "$REPO/scripts/bootstrap-aviutl2-prefix.fish" \
        "$REPO/scripts/configure-aviutl2-prefix.fish" \
        "$REPO/scripts/diagnose-aviutl2-launch.fish" \
        "$REPO/scripts/launch-aviutl2.fish"

        fish -n "$script"
        or die "invalid Fish syntax: $script"
    end

    bash -n "$REPO/scripts/build-dxvk-aviutl2.sh"
    or die 'DXVK builder Bash syntax validation failed'

    python3 -c '
from pathlib import Path
import sys
path = Path(sys.argv[1])
compile(path.read_text(encoding="utf-8"), str(path), "exec")
' "$REPO/scripts/prepare-aviutl2-fonts.py"
    or die 'font preparation script syntax validation failed'

    success 'INSTALLATION.md repository requirements validated'
end

function validate_catalog_repository
    note 'LUTRIS-CATALOG.mdとCatalog用scriptを確認する'

    # Catalog is a continuation of the already validated Section 13 runtime.
    validate_installation_repository

    for path in \
        "$REPO/docs/LUTRIS-CATALOG.md" \
        "$REPO/scripts/manage-aviutl2-catalog-lutris.sh" \
        "$REPO/scripts/install-l-smash-works-nvdec.fish"

        require_path "$path"
    end

    bash -n "$REPO/scripts/manage-aviutl2-catalog-lutris.sh"
    or die 'Catalog manager Bash syntax validation failed'

    fish -n "$REPO/scripts/install-l-smash-works-nvdec.fish"
    or die 'L-SMASH Works installer Fish syntax validation failed'

    success 'LUTRIS-CATALOG.md repository requirements validated'
end

function validate_repository
    switch "$SELECTED_MODE"
        case catalog
            validate_catalog_repository
        case '*'
            validate_installation_repository
    end
end
