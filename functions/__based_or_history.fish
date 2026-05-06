function __based_or_history --argument-names direction
    if set -q BASED_INLINE_MODE; and test "$BASED_INLINE_MODE" != 0
        __based_inline $direction
    else
        __based_fzf_popup
    end
end
