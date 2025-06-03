function __based
    set -l db ~/.local/share/fish/based/based.db
    if not test -f $db
        return
    end

    set -l path (realpath (pwd))
    set -l prefix ""

    # Extract commandline prefix up to cursor safely
    set -l buffer (commandline --current-buffer)
    set -l cursor_pos (commandline -C)
    set -l prefix (string sub -l $cursor_pos -- "$buffer")

    set path (string replace -a "'" "''" -- $path)
    set prefix (string replace -a "'" "''" -- $prefix)

    set -l cmd_expr "%$prefix%"

    # If the user has disabled fuzzy matching
    if set -q BASED_NO_FUZZY
        set cmd_expr "$prefix%"
    end

    if test -n "$prefix"
        sqlite3 $db "
            SELECT cmd FROM log
            WHERE path = '$path'
              AND cmd LIKE '$cmd_expr'
            ORDER BY counter DESC, ts DESC;" | string collect
    else
        sqlite3 $db "
            SELECT cmd
            FROM (
              SELECT cmd, MAX(ts) as max_ts
                FROM log
              GROUP BY cmd
            )
            ORDER BY max_ts DESC;" | string collect
    end
end
