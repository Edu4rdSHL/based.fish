function __based_stats
    set -l db ~/.local/share/fish/based/based.db
    if not test -f $db
        echo "Database not found. Run 'based init' first."
        return
    end

    echo "== Based Stats =="
    sqlite3 -batch -init /dev/null -cmd ".timeout 5000" $db "
        SELECT 'Total unique commands: ' || COUNT(DISTINCT cmd) FROM log;
        SELECT 'Total executions: ' || SUM(counter) FROM log;
    "

    echo
    echo "== Top 10 Commands =="
    sqlite3 -batch -init /dev/null -cmd ".timeout 5000" $db "
        SELECT printf('%4d x  %s', SUM(counter), cmd)
        FROM log
        GROUP BY cmd
        ORDER BY SUM(counter) DESC, MAX(ts) DESC
        LIMIT 10;
    "

    echo
    echo "== Top 5 Paths =="
    set -l shown 0
    sqlite3 -batch -init /dev/null -cmd ".timeout 5000" -separator \t $db "
        SELECT SUM(counter), path
        FROM log
        WHERE path != 'fish_history'
        GROUP BY path
        ORDER BY SUM(counter) DESC;
    " | while read -l -d \t count path
        switch $path
            case $BASED_STATS_HIDDEN_PATHS
                continue
        end
        printf '%4d x  %s\n' $count $path
        set shown (math $shown + 1)
        test $shown -lt 5; or break
    end
end
