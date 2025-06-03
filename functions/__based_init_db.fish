function __based_init_db
    set -l db_path ~/.local/share/fish/based/based.db
    if test -f $db_path
        echo "Database already exists at $db_path. If you want to reinitialize, please delete it first."
        return
    end
    mkdir -p (dirname $db_path)
    sqlite3 $db_path "CREATE TABLE IF NOT EXISTS log (
        path TEXT NOT NULL,
        cmd TEXT NOT NULL,
        counter INTEGER NOT NULL DEFAULT 1,
        ts INTEGER NOT NULL,
        PRIMARY KEY (path, cmd)
    );"

    echo "Based initialized. You can also import your fish history with 'based import'."
end
