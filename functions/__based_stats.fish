function __based_stats
    set -l db ~/.local/share/fish/based/based.db
    if not test -f $db
        echo "Database not found. Run 'based init' first."
        return
    end

    echo "== Based Stats =="
    sqlite3 $db "
        SELECT 'Total unique commands:', COUNT(DISTINCT cmd) FROM log;
        SELECT 'Total executions:', SUM(counter) FROM log;
    "

    echo
    echo "== Top 10 Commands =="
    sqlite3 $db "
        SELECT printf('%4d ×  %s', SUM(counter), cmd)
        FROM log
        GROUP BY cmd
        ORDER BY SUM(counter) DESC, MAX(ts) DESC
        LIMIT 10;
    "

    echo
    echo "== Top 5 Paths =="
    sqlite3 $db "
        SELECT printf('%4d ×  %s', SUM(counter), path)
        FROM log
        WHERE path != 'fish_history'
        GROUP BY path
        ORDER BY SUM(counter) DESC
        LIMIT 5;
    "
end
