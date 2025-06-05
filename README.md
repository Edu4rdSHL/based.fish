# A context-based autocompletion plugin for the Fish shell

based.fish is a lightweight Fish plugin that provides context-based autocompletion for commands, options, and arguments. It enhances the default Fish shell completion system by offering more intelligent and context-aware suggestions. For example, it suggests commands based on the frequency of use, date of use, and the context of the current command line such as the path where you are, the command you are typing, etc.


**Important:** this project was mainly born because I wrongly thought that [atuin](https://atuin.sh/) didn't offered per-directory completions, but it actually does. So, if you are looking for a more complete solution that also includes history management, I recommend checking out [atuin](https://atuin.sh/). However, if you are looking for a lightweight and simple solution that purely focuses on context-based autocompletion, this plugin is a great choice.

## Features

- Context-aware autocompletion for commands, options, and arguments.
- Integration with fzf for a better selection experience.
- Easy installation and setup with Fisher.
- Support for importing existing Fish history.
- Customizable configuration options to tailor the behavior of the plugin.
- Directory-aware completions that take into account the current working directory.
- Statistics about command usage, such as most frequently used commands, options, and arguments.
- Customizable keybindings for navigating and selecting completions.
- Support for disabling fuzzy matching and confirmation prompts.

## How it works

based.fish uses a SQLite database to store command history and statistics. It analyzes the command history to provide context-aware suggestions based on the current command line input or simply based on the current working directory. The logic is as follows:

- It tracks the frequency of commands, options, and arguments used in the past.
- It tracks the working directory where the commands were executed.
- Smart suggestions are created with that information.
- fzf is used for fuzzy matching and selection of completions.
- It provides a user-friendly interface for navigating and selecting completions.

### Suggestions algorithm

- It considers the date of the last use, the frequency of use, and the context of the current command line input. Suggestions are made based on this information.
- If you are in a directory where you have previously used a command multiple times, it will suggest that command first, then the second most used command, and so on.
- For convenience, during the current session, it will always suggest your previous command first and then go back to the most used commands in the current directory.


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

Additionally, you can see the stats of your command usage with:

```fish
$ based stats
```
This will display statistics about your command usage, such as the most frequently used commands, options, and arguments.

## Configuration

You can customize the behavior of based.fish by setting environment variables in your Fish shell:

- `BASED_NO_CONFIRMATION`: If set to `1`, automatically executes the selected suggestion without confirmation, otherwise, it requires another Enter key press to execute the suggestion.
- `BASED_NO_FUZZY`: If set to `1`, disables fuzzy matching for completions and only commands that start with the typed prefix will be suggested.

E.g. to disable fuzzy behavior when searching for completions

```fish
$ set -Ux BASED_NO_FUZZY 1
```

The keybindings for the completions are as follows:

- `Arrow Up` and `Arrow Down`: Navigate through the suggestions of the smart history.
- `Enter`: Accept the selected suggestion.
- `Ctrl + C`: Cancel the completion and return to the command line.

Keybinds can be customized by modifying the `$HOME/.config/fish/functions/based_user_key_bindings.fish` file.

## Demonstration

![based.fish demonstration](assets/based_fish_plugin.gif)

## Contributing

If you want to contribute to based.fish, feel free to open issues or pull requests on the GitHub repository. Contributions are welcome!
