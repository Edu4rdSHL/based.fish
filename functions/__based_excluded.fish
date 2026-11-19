# Succeeds when the directory matches one of the BASED_EXCLUDED_PATHS patterns.
function __based_excluded --argument-names path
    for pattern in $BASED_EXCLUDED_PATHS
        string match -q -- $pattern $path; and return 0
    end
    return 1
end
