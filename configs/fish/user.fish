fish_add_path $HOME/Dotmac/scripts
fish_add_path $HOME/.local/bin
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/Caskroom/miniconda/base/bin

source ~/.orbstack/shell/init2.fish 2>/dev/null || :

set -gx GOPATH $HOME/Develop/go
set -gx PATH $PATH $HOME/.lmstudio/bin
set -gx OPENAI_API_KEY (pass show keys/openai_api_key)
set -gx ANTHROPIC_API_KEY (pass show keys/anthropic_api_key)

abbr install brew install
abbr uninstall brew remove
abbr upgrade-system brew upgrade

status --is-interactive; and rbenv init - --no-rehash fish | source
function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end
