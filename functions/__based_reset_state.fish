function __based_reset_state
    echo "Resetting Based state..."
    # Unset all variables related to Based state
    set -e BASED_NO_CONFIRMATION
    set -e BASED_NO_FUZZY
    set -e BASED_EXCLUDED_PATHS
    set -e BASED_INLINE_MODE
    set -e BASED_STATS_HIDDEN_PATHS
    echo "Based state has been reset."
end
