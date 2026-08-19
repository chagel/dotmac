include dotbase/base.mk

# herdr keeps runtime files (sockets, logs, session.json) in ~/.config/herdr,
# so only the config file is linked -- a whole-directory link would pull those
# into the repo.
CONFIGS := $(filter-out herdr,$(shell ls configs))

setup::
	@ln -vsfn ${BASE}/configs/qutebrowser ${HOME}/.qutebrowser
	@mkdir -pv ${HOME}/.config/herdr
	@ln -vsf ${BASE}/configs/herdr/config.toml ${HOME}/.config/herdr/config.toml
