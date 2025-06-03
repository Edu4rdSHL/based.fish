function __based_import_fish_history
    set -l history_file ~/.local/share/fish/fish_history
    set -l db ~/.local/share/fish/based/based.db
    set -l path fish_history

    if not test -f $history_file
        echo "No fish history file found at $history_file"
        return 1
    end

    if not test -f $db
        echo "No Based database found at $db. Run 'based init' first."
        return 1
    end

    set -l existing_count (sqlite3 $db "SELECT COUNT(*) FROM log WHERE path = '$path';")

    if test $existing_count -gt 0
        set -l existing_cmds (sqlite3 $db "SELECT cmd FROM log WHERE path = '$path';")
        echo "Fish history was already imported under context: '$path'. Total commands already imported: $existing_count"
        echo "If you want to re-import, please delete the existing entries or the database."
        return 0
    end

    echo "Importing fish history into Based, this may take a while..."

    set -l temp_sql (mktemp)

    echo "BEGIN TRANSACTION;" >$temp_sql

    set -l cmd ""
    set -l when 0

    for line in (cat $history_file)
        switch $line
            case '- cmd:*'
                set cmd (string replace -r '^- cmd: *' '' -- $line | string trim)
                set cmd (string replace -a "'" "''" -- $cmd)
            case '  when:*'
                set when (string replace -r '^  when: *' '' -- $line | string trim)

                if test -n "$cmd"
                    echo "INSERT INTO log (path, cmd, counter, ts)
                          VALUES ('$path', '$cmd', 1, $when)
                          ON CONFLICT(path, cmd) DO UPDATE SET
                              counter = counter + 1,
                              ts = MAX(ts, $when);" >>$temp_sql
                    set cmd ""
                    set when 0
                end
        end
    end

    echo "COMMIT;" >>$temp_sql
    sqlite3 $db <$temp_sql
    set -l total_inserts (sqlite3 $db "SELECT COUNT(*) FROM log WHERE path = '$path';")
    rm -f $temp_sql

    echo "Fish history imported into Based under context: '$path'. Total commands processed: $total_inserts"
end
