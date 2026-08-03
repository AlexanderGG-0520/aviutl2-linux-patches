# Require the rendering/media diagnostic capture as part of repository
# validation so broken diagnostic syntax cannot reach runtime triage.

functions -c validate_installation_repository validate_installation_repository_base
functions --erase validate_installation_repository

function validate_installation_repository
    validate_installation_repository_base

    set -l rendering_diagnostic \
        "$REPO/scripts/diagnose-aviutl2-rendering.fish"

    require_path "$rendering_diagnostic"

    fish -n "$rendering_diagnostic"
    or die 'rendering/media diagnostic Fish syntax validation failed'

    success 'rendering/media diagnostic validated'
end
