OH_MY_ZSH_DIR := $(HOME)/.oh-my-zsh
ZSH_CONFIG := $(HOME)/.zshrc
ZSH_CONFIG_LOCAL := $(HOME)/.zshrc_local_conf

TMUX_CONFIG := $(HOME)/.tmux.conf

GIT_CONFIG := $(HOME)/.gitconfig
GIT_FLOW_PATH := /usr/local/bin/git-flow

install: prepare_git prepare_zsh prepare_tmux

# link current dot file to the home dir
$(HOME)/%: %
	ln -fs $(PWD)/$< $@

# check specific comand
check_cmd_%:
	@if ! which $* &>/dev/null; then \
		echo "!! Missing $*"; \
		exit 1; \
	fi

# for git
prepare_git: check_git_deps $(GIT_FLOW_PATH) $(GIT_CONFIG)

check_git_deps: check_cmd_git check_cmd_curl check_cmd_sudo

$(GIT_FLOW_PATH):
	@echo "*** Installing git flow ***"
	@curl -fsS https://raw.githubusercontent.com/petervanderdoes/gitflow-avh/develop/contrib/gitflow-installer.sh | sudo bash -s - install stable
	@rm -rf ./gitflow


# for zsh
prepare_zsh: check_zsh_deps $(ZSH_CONFIG) $(ZSH_CONFIG_LOCAL) $(OH_MY_ZSH_DIR)

check_zsh_deps: check_cmd_zsh

$(ZSH_CONFIG_LOCAL):
	mkdir $(ZSH_CONFIG_LOCAL)

$(OH_MY_ZSH_DIR):
	@echo "*** Downloading oh-my-zsh ***"
	@git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

# for tmux
prepare_tmux: check_tmux_deps tmuxinator $(TMUX_CONFIG)

check_tmux_deps: check_cmd_tmux check_cmd_gem

tmuxinator: 
	@which tmuxinator &>/dev/null || gem install -N tmuxinator

.PHONY: install prepare_git check_git_deps prepare_zsh prepare_tmux check_tmux_deps tmuxinator