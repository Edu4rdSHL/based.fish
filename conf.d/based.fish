# Load the based logger (for fish_preexec event)
source (status dirname)/../functions/__based_log.fish
# Load the inline mode state reset (for its event and PWD handlers)
source (status dirname)/../functions/__based_inline_reset.fish
# Load keybindings (arrow up and down for smart history)
source (status dirname)/../functions/based_user_key_bindings.fish
