# mac-setup

Repository to to kickstart a Mac, according to personal preferences focused on React Native and frontend development, including:

- Installation of HomeBrew
- Installation of a variety of packages and applications via HomeBrew
- ZSH setup, including aliases, Oh My ZSH and Starship
- MacOS system settings changes
- Installation of NVM
- Scaffolding of main folders in home directory
- VSCode settings and keybindings

The script can be run multiple times, it should be idempotent.
The script will create backups before overwriting the following files:

- `~/.zshrc`
- `~/.config/starship.toml`
- VSCode `~/Library/Application Support/Code/User/settings.json`
- VSCode `~/Library/Application Support/Code/User/keybindings.json`

Backups are created in `~/.mac-setup-backup`

## How to use

- Install Apple command line tools (open terminal, try to some git commands which should prompt to install command line tools)
- Clone this repo `git clone https://github.com/Tom-Bury/mac-setup.git`
- Execute `./setup-mac.sh`, keeping an eye to provide password and input when required
  - e.g: initial HomeBrew installation will require an ENTER
  - e.g: certain applications will require changes to System Settings to access certain features or folders
- Input whether to overwrite the current VSCode settings and keybindings, or merge them with the repo ones
  - Either way, the result will be visible in `vscode-settings.json` and `vscode-keybindings.json` in the repo
