# Keeps a new prompt or another directory from resuming an old cycle.
# Autoloaded functions do not register events, so conf.d/based.fish sources this file.
function __based_inline_reset --on-event fish_postexec --on-event fish_cancel --on-variable PWD
    set -e __based_inline_list
    set -e __based_inline_index
end
