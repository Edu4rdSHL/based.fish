# A context-based autocompletion plugin for the Fish shell

based.fish is a lightweight Fish plugin that provides context-based autocompletion for commands, options, and arguments. It enhances the default Fish shell completion system by offering more intelligent and context-aware suggestions. For example, it suggests commands based on the frequency of use, date of use, and the context of the current command line such as the path where you are, the command you are typing, etc.

## Features

- Context-aware autocompletion for commands, options, and arguments.
- Integration with fzf for a better selection experience.
- Easy installation and setup with Fisher.
- Support for importing existing Fish history.
- Customizable configuration options to tailor the behavior of the plugin.
- Directory-aware completions that take into account the current working directory.

## Installation

You can install based.fish using Fisher, a plugin manager for Fish shell. Run the following command:

```fish
$ fisher install Edu4rdSHL/based.fish
```

## Requirements

- fzf: for selection of completions.
- sqlite3: for storing and querying command history.

## Usage

Make sure to initialize the plugin once installed:

```fish
$ based init
```
This will set up the necessary database and configuration files.

You can also import your existing Fish history into the based.fish database:

```fish
$ based import
```
This will read your existing Fish history and populate the based.fish database with it.

## Configuration

You can customize the behavior of based.fish by setting environment variables in your Fish shell:

- `BASED_NO_CONFIRMATION`: If set to `1`, automatically executes the selected suggestion without confirmation, otherwise, it requires another Enter key press to execute the suggestion.
- `BASED_NO_FUZZY`: If set to `1`, disables fuzzy matching for completions and only commands that start with the typed prefix will be suggested.

E.g. to disable fuzzy behavior when searching for completions

```fish
$ set -Ux BASED_NO_FUZZY 1
```

## Contributing

If you want to contribute to based.fish, feel free to open issues or pull requests on the GitHub repository. Contributions are welcome!
