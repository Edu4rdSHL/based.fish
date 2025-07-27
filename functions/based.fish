function based
    switch $argv[1]
        case init
            __based_init_db
        case import
            __based_import_fish_history
        case stats
            __based_stats
        case reset
            __based_reset_state
        case maintenance vacuum
            __based_maintenance
        case help '*'
            echo "Usage: based init|import|stats|reset|maintenance|help"
            echo "Commands:"
            echo "  init        - Initialize the Based database"
            echo "  import      - Import fish history into Based"
            echo "  stats       - Show Based statistics"
            echo "  reset       - Reset Based state (clears variables)"
            echo "  maintenance - Perform database maintenance (vacuum & analyze)"
            echo "  help        - Show this help message"
            echo ""
            echo "Configuration variables:"
            echo "  BASED_NO_CONFIRMATION - Skip confirmation prompts"
            echo "  BASED_NO_FUZZY        - Disable fuzzy matching"
            echo "  BASED_EXCLUDED_PATHS  - Paths to exclude from history (glob patterns)"
        case '*'
            echo "Unknown command: $argv[1]"
            echo "Use 'based help' for usage information."
    end
end
