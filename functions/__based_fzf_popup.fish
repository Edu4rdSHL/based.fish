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
        # Prevent autocomplete samples from remaining before the selected command.
        # i.e: if you run `cd`, then arrow up, and select a command, the initial `cd` will be
        # visible before the selected command, like: `cd cd <path>`. It doesn't affect functionality,
        # but it can be visually confusing.
        commandline -f repaint

        # Only execute if the user pressed ENTER and confirmation is set
        if test "$key" = enter; and set -q BASED_NO_CONFIRMATION; and test "$BASED_NO_CONFIRMATION" != 0
            commandline -f execute
        end
    end

    # Update the display for commands like directory changes
    commandline -f repaint
end
