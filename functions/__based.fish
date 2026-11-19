function __based
    # The inline mode matches the whole buffer and keeps only the top rows.
    argparse prefix= limit= -- $argv
    or return
    set -q _flag_limit; or set _flag_limit -1

    set -l db ~/.local/share/fish/based/based.db
    if not test -f $db
        return
    end

    set -l path (pwd -P)

    set -l prefix $_flag_prefix
    if not set -q _flag_prefix
        set -l buffer (commandline --current-buffer)
        set prefix (string sub -l (commandline -C) -- "$buffer")
    end

    set path (string replace -a "'" "''" -- $path)
    # % and _ are LIKE wildcards, the typed text has to match literally
    set -l pattern (string replace -ra -- '[\\\\%_]' '\\\\$0' "$prefix" | string replace -a "'" "''")

    set -l match "cmd LIKE '%$pattern%' ESCAPE '\\'"
    if set -q BASED_NO_FUZZY
        set match "cmd LIKE '$pattern%' ESCAPE '\\'"
    end

    # (path, cmd) is the primary key, so every row is already a distinct command and the
    # branches never overlap. cmd breaks ties so the order is stable.
    if test -n "$prefix"
        sqlite3 -batch $db "
        SELECT cmd FROM (
            SELECT cmd, counter, ts, 0 AS priority FROM log
            WHERE path = '$path' AND $match
            UNION ALL
            SELECT cmd, counter, ts, 1 FROM log AS h
            WHERE path = 'fish_history' AND $match
              AND NOT EXISTS (SELECT 1 FROM log WHERE path = '$path' AND cmd = h.cmd)
        )
        ORDER BY priority, counter DESC, ts DESC, cmd LIMIT $_flag_limit;"
    else
        # The most recent command of this directory goes first, like plain history
        sqlite3 -batch $db "
        SELECT cmd FROM (
            SELECT cmd, counter, ts,
                   cmd IS NOT (SELECT cmd FROM log WHERE path = '$path' ORDER BY ts DESC, cmd LIMIT 1) AS priority
            FROM log
            WHERE path = '$path'
            UNION ALL
            SELECT cmd, counter, ts, 2 FROM log AS h
            WHERE path = 'fish_history'
              AND NOT EXISTS (SELECT 1 FROM log WHERE path = '$path' AND cmd = h.cmd)
        )
        ORDER BY priority, counter DESC, ts DESC, cmd LIMIT $_flag_limit;"
    end
end
