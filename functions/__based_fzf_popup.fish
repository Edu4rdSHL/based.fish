function __based_fzf_popup
    # TAB: Accept the current selection but do not execute it, never
    # ENTER: Accept the current selection and execute it if confirmation is set
    set -l out (__based | fzf \
        --height 50% --reverse --prompt='Command > ' \
        --no-sort --exact --border \
        --bind "tab:accept" \
        --expect tab,enter)

    set -l key (echo $out[1])
    set -l chosen (string join "\n" $out[2..-1] | string collect)

    if test -n "$chosen"
        commandline -r -- "$chosen"
        commandline -f repaint

        # Only execute if the user pressed ENTER and confirmation is set
        if test "$key" = enter; and set -q BASED_NO_CONFIRMATION; and test "$BASED_NO_CONFIRMATION" != 0
            commandline -f execute
        end
    else
        commandline -f repaint
    end
end
