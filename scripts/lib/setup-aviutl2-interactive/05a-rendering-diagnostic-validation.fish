# Require rendering diagnostics as part of repository validation so broken
# diagnostic syntax cannot reach runtime triage.

functions -c validate_installation_repository validate_installation_repository_base
functions --erase validate_installation_repository

function validate_installation_repository
    validate_installation_repository_base

    for diagnostic in \
        "$REPO/scripts/diagnose-aviutl2-rendering.fish" \
        "$REPO/scripts/diagnose-aviutl2-shapes.fish"

        require_path "$diagnostic"

        fish -n "$diagnostic"
        or die "rendering diagnostic Fish syntax validation failed: $diagnostic"
    end

    success 'rendering diagnostics validated'
end
