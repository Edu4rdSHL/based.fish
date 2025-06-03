function __based_fzf_popup
    set -l suggestions (__based)
    if test (count $suggestions) -gt 0
        # Run fzf and capture exit status
        set -l chosen (printf "%s\n" $suggestions | fzf --height 40% --reverse --prompt='Context > ' --query="$prefix" --no-sort --exact)

        if test -n "$chosen"
            set -l cleaned (string trim -- $chosen)
            if test -n "$cleaned"
                commandline -r -- "$cleaned"
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
end
