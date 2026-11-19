function __based_log --on-event fish_preexec
    # The same rules fish applies to its own history
    test -n "$fish_private_mode"; and return
    if functions -q fish_should_add_to_history
        fish_should_add_to_history $argv; or return
    else if string match -q ' *' -- "$argv"
        return
    end

    set -l db ~/.local/share/fish/based/based.db
    if not test -f $db
        # Runs before every command, so warn once per session instead of on each one.
        if not set -q __based_db_missing_warned
            set -g __based_db_missing_warned 1
            echo "Database for the Based plugin not found. Please run based init to initialize it."
        end
        return
    end

    # Suggestions are read back one per line, so a multi-line command cannot round-trip
    string match -qr '\n' -- "$argv"; and return

    set -l path (pwd -P)
    set -l cmd (string trim -- (string join " " $argv))

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

    # Detached through sh: the commit waits for an fsync that would delay every command,
    # and a fish background job would take over the user's $last_pid.
    sh -c 'sqlite3 -batch -cmd ".timeout 30000" "$1" "$2" </dev/null >/dev/null 2>&1 &' sh $db "
        INSERT INTO log (path, cmd, counter, ts)
        VALUES ('$path', '$cmd', 1, strftime('%s', 'now'))
        ON CONFLICT(path, cmd) DO UPDATE SET
            counter = counter + 1,
            ts = excluded.ts;
    "
end
