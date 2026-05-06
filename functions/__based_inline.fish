function __based_inline --argument-names direction
    set -l current (commandline --current-buffer)

    # Reset state if the buffer differs from what we last wrote.
    # This covers fresh prompts and any edits the user made between presses.
    if not set -q __based_inline_last_written
        or test "$current" != "$__based_inline_last_written"
        set -g __based_inline_prefix $current
        set -g __based_inline_results (__based)
        set -g __based_inline_index 0
        set -g __based_inline_last_written $current
    end

    set -l count (count $__based_inline_results)
    if test $count -eq 0
        return
    end

    switch $direction
        case up
            if test $__based_inline_index -ge $count
                return
            end
            set -g __based_inline_index (math $__based_inline_index + 1)
        case down
            if test $__based_inline_index -le 0
                return
            end
            set -g __based_inline_index (math $__based_inline_index - 1)
    end

    if test $__based_inline_index -eq 0
        commandline -r -- "$__based_inline_prefix"
        set -g __based_inline_last_written $__based_inline_prefix
    else
        set -l choice $__based_inline_results[$__based_inline_index]
        commandline -r -- "$choice"
        set -g __based_inline_last_written $choice
    end

    commandline -f repaint
end
