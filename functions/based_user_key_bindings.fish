function fish_user_key_bindings
    # Arrow up and down for smart history.
    # Terminals negotiating the kitty keyboard protocol deliver the key by name,
    # never as \e[A, so both forms are needed.
    bind up __based_or_history
    bind down __based_or_history
    bind \e\[A __based_or_history
    bind \e\[B __based_or_history
end
