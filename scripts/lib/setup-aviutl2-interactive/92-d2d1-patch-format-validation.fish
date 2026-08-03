# Reject malformed D2D1 patch files during repository validation, before the
# artifact pipeline reaches the Wine source tree.

functions -c validate_installation_repository validate_installation_repository_without_d2d1_patch_format
functions --erase validate_installation_repository

function validate_installation_repository
    validate_installation_repository_without_d2d1_patch_format

    set -l patch_file \
        "$REPO/patches/wine/0003-implement-d2d-addarc.patch"

    git apply --numstat -- "$patch_file" >/dev/null
    or die 'D2D1 AddArc patch is not a well-formed unified diff'

    success 'D2D1 AddArc patch format validated'
end
