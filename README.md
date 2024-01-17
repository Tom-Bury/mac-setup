# mac-setup

Repository to save various settings and setup scripts to kickstart a Mac

## Steps

- Install command line tools (open terminal, try to `git clone https://github.com/Tom-Bury/mac-setup.git`, which should prompt to install command line tools)
- Clone this repo
- Execute `./setup-mac.sh`, keeping an eye to provide password and input when required
  - e.g: HomeBrew installation will require an ENTER
  - e.g: certain applications will changes to System Settings to access certain features or folders
- Update VSCode settings by copying the contents of `vscode-settings.json` into the VSCode settings file
  - e.g: `cp vscode-settings.json ~/Library/Application\ Support/Code/User/settings.json`