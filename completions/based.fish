# Fish shell completion script for the Based Fish plugin
complete -c based -n __fish_use_subcommand -f -a init -d "Initialize the Based database"
complete -c based -n __fish_use_subcommand -f -a import -d "Import Fish history into Based"
complete -c based -n __fish_use_subcommand -f -a stats -d "Show Based statistics"
complete -c based -n __fish_use_subcommand -f -a reset -d "Reset Based state"
complete -c based -n __fish_use_subcommand -f -a maintenance -d "Perform database maintenance"
complete -c based -n __fish_use_subcommand -f -a help -d "Show help message"
