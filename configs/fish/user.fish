fish_add_path $HOME/Dotmac/scripts
fish_add_path $HOME/.local/bin
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/Caskroom/miniconda/base/bin

source ~/.orbstack/shell/init2.fish 2>/dev/null || :
set -gx PATH $PATH $HOME/.lmstudio/bin
