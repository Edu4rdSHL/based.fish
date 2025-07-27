function __based_maintenance
    set -l db ~/.local/share/fish/based/based.db
    if not test -f $db
        echo "Database not found. Run 'based init' first."
        return 1
    end

    echo "Performing database maintenance..."

    # Get database size before
    set -l size_before (du -h $db | cut -f1)

    # Vacuum the database
    sqlite3 $db "VACUUM;"

    # Update statistics
    sqlite3 $db "ANALYZE;"

    # Get database size after
    set -l size_after (du -h $db | cut -f1)

    echo "Database maintenance completed."
    echo "Size before: $size_before"
    echo "Size after: $size_after"
end
