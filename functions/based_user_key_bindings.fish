function fish_user_key_bindings
    # Arrow up and down for smart history.
    # Direction is always passed; the fzf popup ignores it, the inline mode uses it.
    bind \e\[A '__based_or_history up'
    bind \e\[B '__based_or_history down'
end
