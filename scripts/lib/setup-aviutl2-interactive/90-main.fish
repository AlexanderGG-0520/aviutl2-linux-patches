# This file is sourced by scripts/setup-aviutl2-interactive.fish.

function run_artifact_pipeline
    install_dependencies
    verify_required_commands
    validate_repository
    prepare_ge_proton_stock
    build_dwrite
    prepare_runtime_runner
    prepare_aviutl2
    build_dxvk
    prepare_fonts
    prepare_nvidia
    build_lsmash
    prepare_dxvk_config
    artifact_preflight
end

function run_deploy_pipeline
    verify_required_commands
    validate_repository
    artifact_preflight
    bootstrap_prefix
    deploy_payload
    configure_prefix
    validate_runtime
end

function run_full_pipeline
    run_artifact_pipeline
    bootstrap_prefix
    deploy_payload
    configure_prefix
    diagnostic_launch
    or die 'Section 13 diagnostic launch did not complete successfully'

    note 'セットアップ完了'
    echo 'AviUtl2 2.1.3 + patched DXVK + patched DWrite + custom L-SMASH Works'

    if validate_gui_verification_marker
        echo 'GUI、text編集、Mozcまで確認済み。'
        echo
        echo '互換レイヤーとして、ここまで通れば文句なしの勝ちです。'
    else
        echo '自動工程と診断起動までは完了。GUI回帰確認は未認証です。'
    end
end

function choose_mode
    if test -n "$REQUESTED_MODE"
        set -g SELECTED_MODE "$REQUESTED_MODE"
        return 0
    end

    echo
    echo '実行内容を選択してください:'
    echo '  1) Full setup（artifact build → prefix配置 → 診断起動）'
    echo '  2) Artifacts only（Sections 3–10）'
    echo '  3) Deploy prefix（Sections 10–13、artifact作成済み）'
    echo '  4) Validate current installation'
    echo '  5) Diagnostic launch'
    echo '  6) Normal launch'
    echo '  7) Catalog / Lutris setup'
    echo '  0) Exit'

    while true
        read -P '選択: ' selection

        switch (string trim -- "$selection")
            case 1
                set -g SELECTED_MODE full
                return 0
            case 2
                set -g SELECTED_MODE artifacts
                return 0
            case 3
                set -g SELECTED_MODE deploy
                return 0
            case 4
                set -g SELECTED_MODE validate
                return 0
            case 5
                set -g SELECTED_MODE diagnose
                return 0
            case 6
                set -g SELECTED_MODE launch
                return 0
            case 7
                set -g SELECTED_MODE catalog
                return 0
            case 0
                set -g SELECTED_MODE exit
                return 0
        end

        echo '0〜7を入力してください。'
    end
end

function parse_arguments
    argparse \
        'h/help' \
        'r/root=' \
        'p/prefix=' \
        'g/ge-proton-root=' \
        'j/jobs=' \
        'm/mode=' \
        'y/assume-yes' \
        'd/skip-dependencies' \
        -- $argv
    or begin
        usage >&2
        exit 2
    end

    if set -q _flag_help
        usage
        exit 0
    end

    if set -q _flag_root
        set -g REQUESTED_ROOT (string trim -- "$_flag_root")
    end

    if set -q _flag_prefix
        set -g REQUESTED_PREFIX (string trim -- "$_flag_prefix")
    end

    if set -q _flag_ge_proton_root
        set -g REQUESTED_GE_ROOT (string trim -- "$_flag_ge_proton_root")
    end

    if set -q _flag_jobs
        set -g JOBS (string trim -- "$_flag_jobs")
    end

    if set -q _flag_mode
        set -g REQUESTED_MODE (string lower -- (string trim -- "$_flag_mode"))

        switch "$REQUESTED_MODE"
            case full artifacts deploy validate diagnose launch catalog
            case '*'
                die "unknown mode: $REQUESTED_MODE"
        end
    end

    if set -q _flag_assume_yes
        set -g ASSUME_YES 1
    end

    if set -q _flag_skip_dependencies
        set -g SKIP_DEPENDENCIES 1
    end
end

function main
    test (id -u) -ne 0
    or die 'do not run this script as root; sudo is used only for pacman'

    parse_arguments $argv

    for command_name in realpath dirname basename date id mkdir
        require_command "$command_name"
    end

    configure_paths

    choose_mode
    set -l mode "$SELECTED_MODE"

    switch "$mode"
        case full
            run_full_pipeline
        case artifacts
            run_artifact_pipeline
        case deploy
            run_deploy_pipeline
        case validate
            verify_required_commands
            validate_repository
            validate_runtime
        case diagnose
            verify_required_commands
            validate_repository
            diagnostic_launch
        case launch
            verify_required_commands
            validate_repository
            normal_launch
        case catalog
            verify_required_commands
            validate_repository
            setup_catalog
        case exit
            echo '終了します。'
            return 0
        case '*'
            die "internal mode error: $mode"
    end

    printf 'completed_at=%s\n' (date --iso-8601=seconds) >> "$SETUP_LOG"
end
