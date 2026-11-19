# Single source of truth for the index layout, so databases created by older
# versions converge on the current schema during 'based maintenance'.
function __based_ensure_indexes
    set -l db $argv[1]

    sqlite3 -batch -cmd ".timeout 5000" $db "
        -- Prefix matches with BASED_NO_FUZZY (LIKE is case-insensitive, hence NOCASE)
        CREATE INDEX IF NOT EXISTS idx_log_cmd_like ON log(cmd COLLATE NOCASE);
        -- Covers the per-directory suggestion queries, already in their final order
        CREATE INDEX IF NOT EXISTS idx_log_path_rank ON log(path, counter DESC, ts DESC, cmd);

        -- Duplicated the automatic PRIMARY KEY (path, cmd) index.
        DROP INDEX IF EXISTS idx_log_path_cmd;
        -- Unused by the suggestions and the logger, or superseded by idx_log_path_rank.
        DROP INDEX IF EXISTS idx_log_cmd;
        DROP INDEX IF EXISTS idx_log_counter_ts;
        DROP INDEX IF EXISTS idx_log_path_ts;
    "
end
