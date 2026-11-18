# Returns 1 to hand the key back to fish.
function __based_inline --argument-names direction
    # Split per line: string collect would trim a trailing empty line and hide it from the check
    set -l lines (commandline --current-buffer)
    # A fish history search started by an earlier fallback and multiline buffers keep the arrows
    if commandline --search-mode; or set -q lines[2]
        return 1
    end
    set -l current "$lines"

    # Element 1 is the typed text, so what this function last wrote is always list[index]
    if not set -q __based_inline_index
        or test "$current" != "$__based_inline_list[$__based_inline_index]"
        if test "$direction" = down
            __based_inline_reset
            return 1
        end
        set -l results (__based --prefix "$current" --limit 200)
        # Like fish's own search, never offer the typed text back
        if set -l dup (contains -i -- "$current" $results)
            set -e results[$dup]
        end
        set -g __based_inline_list "$current" $results
        set -g __based_inline_index 1
    end

    switch $direction
        case up
            set -l next (math $__based_inline_index + 1)
            if not set -q __based_inline_list[$next]
                # Nothing to suggest goes to fish, the end of the list stays put
                test $__based_inline_index -gt 1
                return
            end
            set -g __based_inline_index $next
        case down
            test $__based_inline_index -gt 1; or return 1
            set -g __based_inline_index (math $__based_inline_index - 1)
    end

    commandline -r -- "$__based_inline_list[$__based_inline_index]"
    # Otherwise fish appends its own suggestion, and the line no longer shows what Enter runs
    commandline -f suppress-autosuggestion
end
