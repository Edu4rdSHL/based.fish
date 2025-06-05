function __based_fzf_popup
    set -l chosen (printf "%s\n" (__based) | fzf --height 50% --reverse --prompt='Command > ' --no-sort --exact --border)

    if test -n "$chosen"
        if test -n "$chosen"
            commandline -r -- "$chosen"
            commandline -f repaint
            # If BASED_NO_CONFIRMATION is set to a non-zero value, execute the command immediately
            if set -q BASED_NO_CONFIRMATION; and test "$BASED_NO_CONFIRMATION" != 0
                commandline -f execute
            end
        end
    else
        commandline -f repaint
        return
    end

end
