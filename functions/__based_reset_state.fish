function __based_reset_state
    echo "Resetting Based state..."
    # Unset all variables related to Based state
    set -e BASED_NO_CONFIRMATION
    set -e BASED_NO_FUZZY
    echo "Based state has been reset."
end
