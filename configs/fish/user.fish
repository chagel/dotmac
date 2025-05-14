# Central environment configuration for macOS
# This file centralizes environment variables and paths specific to this machine

# Path to dotfiles repository - use this variable instead of hardcoding paths
set -gx DOTFILES_DIR $HOME/Dotmac

# Scripts path - reference DOTFILES_DIR instead of hardcoding
fish_add_path $DOTFILES_DIR/scripts
fish_add_path $HOME/.local/bin
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/Caskroom/miniconda/base/bin

# Golang path
set -gx GOPATH $HOME/Develop/go
fish_add_path $HOME/.lmstudio/bin

# API Keys
function load_api_keys --description "Load API keys from password store(1Password)"
    if type -q pass
        set -gx OPENAI_API_KEY (op item get cfx7ecmfy3pc7a3zcc7vr2fmhe --reveal --fields "api key" || echo "")
        set -gx ANTHROPIC_API_KEY (op item get kyapm6qumqcvjzzmtqvvypxmi4 --reveal --fields "api key" || echo "")
    end
end

# OrbStack integration
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# macOS specific abbreviations
abbr install brew install
abbr uninstall brew remove
abbr upgrade-system brew upgrade

# AWS tools abbreviations
abbr awse aws-tools ec2
abbr awsu aws-tools users
abbr awsi aws-tools info
abbr awsr aws-tools regions

abbr be bundle exec

# Initialize rbenv
status --is-interactive; and rbenv init - --no-rehash fish | source
