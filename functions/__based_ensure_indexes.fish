# Single source of truth for the index layout, so databases created by older
# versions converge on the current schema during 'based maintenance'.
function __based_ensure_indexes
    set -l db $argv[1]

    sqlite3 -batch $db "
        CREATE INDEX IF NOT EXISTS idx_log_cmd ON log(cmd);
        CREATE INDEX IF NOT EXISTS idx_log_path_ts ON log(path, ts);
        CREATE INDEX IF NOT EXISTS idx_log_counter_ts ON log(counter DESC, ts DESC);
        CREATE INDEX IF NOT EXISTS idx_log_cmd_like ON log(cmd COLLATE NOCASE);

        -- Duplicated the automatic PRIMARY KEY (path, cmd) index.
        DROP INDEX IF EXISTS idx_log_path_cmd;
    "
end
