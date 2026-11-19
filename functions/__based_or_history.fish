function __based_or_history --argument-names direction
    # Bindings written before inline mode pass no direction and keep the popup
    if not contains -- "$direction" up down
        __based_fzf_popup
    else if commandline --paging-mode; or test -n "$fish_private_mode"; or __based_excluded (pwd -P)
        # Private mode hides the old history, so the database stays hidden too, and
        # nothing is logged in excluded directories, so based has no context there
        $direction-or-search
    else if set -q BASED_INLINE_MODE; and test "$BASED_INLINE_MODE" != 0
        # up-or-search and down-or-search are functions, commandline -f cannot run them
        __based_inline $direction; or $direction-or-search
    else
        __based_fzf_popup
    end
end
