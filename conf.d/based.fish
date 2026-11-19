# Load the based logger (for fish_preexec event)
source (status dirname)/../functions/__based_log.fish
# Load the inline mode state reset (for its event and PWD handlers)
source (status dirname)/../functions/__based_inline_reset.fish

# Bound directly instead of defining fish_user_key_bindings, which would replace the
# user's own. Insert mode is where the arrows are used with vi key bindings.
if status is-interactive
    for mode in default insert
        bind -M $mode up '__based_or_history up'
        bind -M $mode down '__based_or_history down'
    end
end
