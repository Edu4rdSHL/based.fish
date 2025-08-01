function __based_log --on-event fish_preexec
    set -l db ~/.local/share/fish/based/based.db
    if not test -f $db
        echo "Database for the Based plugin not found. Please run based init to initialize it."
        return
    end

    set -l path (realpath (pwd))
    set -l cmd (string trim -- (string join " " $argv))
    set -l ts (date +%s)

    if test -z "$cmd"
        return
    end

    # Check if path should be excluded
    if set -q BASED_EXCLUDED_PATHS
        for excluded_pattern in $BASED_EXCLUDED_PATHS
            if string match -q $excluded_pattern $path
                return
            end
        end
    end

    set cmd (string replace -a "'" "''" -- $cmd)
    set path (string replace -a "'" "''" -- $path)

    sqlite3 -batch $db "
        INSERT INTO log (path, cmd, counter, ts)
        VALUES ('$path', '$cmd', 1, $ts)
        ON CONFLICT(path, cmd) DO UPDATE SET
            counter = counter + 1,
            ts = $ts;
    "
end
