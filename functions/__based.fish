function __based
    set -l db ~/.local/share/fish/based/based.db
    if not test -f $db
        return
    end

    set -l path (realpath (pwd))
    set -l buffer (commandline --current-buffer)
    set -l cursor_pos (commandline -C)
    set -l prefix (string sub -l $cursor_pos -- "$buffer")

    set path (string replace -a "'" "''" -- $path)
    set prefix (string replace -a "'" "''" -- $prefix)

    set -l cmd_expr "%$prefix%"
    if set -q BASED_NO_FUZZY
        set cmd_expr "$prefix%"
    end

    # Build combined result set in SQL
    if test -n "$prefix"
        set -f results (sqlite3 -batch $db "
        SELECT DISTINCT cmd FROM (
            -- Prioritize commands in the current path, matching the prefix
            SELECT cmd, MAX(ts) as max_ts, MAX(counter) as counter, 0 as priority
            FROM log
            WHERE path = '$path' AND cmd LIKE '$cmd_expr'
            GROUP BY cmd

            UNION

            -- Append the commands from the imported fish history that match the prefix
            SELECT cmd, MAX(ts) as max_ts, MAX(counter) as counter, 1 as priority
            FROM log
            WHERE path = 'fish_history' AND cmd LIKE '$cmd_expr'
              AND cmd NOT IN (
                  SELECT cmd
                  FROM log
                  WHERE path = '$path' AND cmd LIKE '$cmd_expr'
              )
            GROUP BY cmd
        )
        ORDER BY priority ASC, counter DESC, max_ts DESC;")
    else
        set -f results (sqlite3 -batch $db "
        SELECT DISTINCT cmd FROM (
            -- Get the most recent command across the current path to emulate the normal history behavior
            -- This ensures that the most recent command is always at the top
            SELECT cmd, max_ts, counter, priority FROM (
                SELECT cmd, MAX(ts) as max_ts, MAX(counter) as counter, 0 as priority
                FROM log
                WHERE path = '$path'
                GROUP BY cmd
                ORDER BY max_ts DESC
                LIMIT 1
            )

            UNION

            -- Commands in the current context
            SELECT cmd, MAX(ts) as max_ts, MAX(counter) as counter, 1 as priority
            FROM log
            WHERE path = '$path'
            GROUP BY cmd

            UNION

            -- Commands in the imported fish history
            SELECT cmd, MAX(ts) as max_ts, MAX(counter) as counter, 2 as priority
            FROM log
            WHERE path = 'fish_history'
              AND cmd NOT IN (
                  SELECT cmd
                  FROM log
                  WHERE path = '$path'
              )
            GROUP BY cmd
        )
        ORDER BY priority ASC, counter DESC, max_ts DESC;")
    end

    printf "%s\n" $results
end
