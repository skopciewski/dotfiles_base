OH_MY_ZSH_DIR := $(HOME)/.oh-my-zsh
ZSH_CONFIG := $(HOME)/.zshrc
ZSH_ALIASES := $(HOME)/.zshrc_local_aliases
ZSH_CONFIG_LOCAL := $(HOME)/.zshrc_local_conf

TMUX_CONFIG := $(HOME)/.tmux.conf

GIT_CONFIG := $(HOME)/.gitconfig
GIT_FLOW_PATH := /usr/local/bin/git-flow

install: prepare_git prepare_zsh prepare_tmux
.PHONY: install

# link current dot file to the home dir
$(HOME)/%: %
	@ln -fs $(PWD)/$< $@

# copy zsh_conf file to the conf dir
$(ZSH_CONFIG_LOCAL)/%: zsh_conf/%
	@cp $(PWD)/$< $@

# check specific comand
check_cmd_%:
	@if ! which $* &>/dev/null; then \
		echo "!! Missing $*"; \
		exit 1; \
	fi


# for git
prepare_git: check_git_deps $(GIT_FLOW_PATH) $(GIT_CONFIG)
.PHONY: prepare_git

check_git_deps: check_cmd_git check_cmd_curl check_cmd_sudo
.PHONY: check_git_deps

$(GIT_FLOW_PATH):
	@echo "*** Installing git flow ***"
	@curl -fsS https://raw.githubusercontent.com/petervanderdoes/gitflow-avh/develop/contrib/gitflow-installer.sh | sudo bash -s - install stable
	@sudo rm -rf ./gitflow


# for zsh
prepare_zsh: check_zsh_deps $(ZSH_CONFIG) set_zsh_env $(OH_MY_ZSH_DIR)
.PHONY: prepare_zsh

check_zsh_deps: check_cmd_zsh
.PHONY: check_zsh_deps

set_zsh_env: $(ZSH_CONFIG_LOCAL) $(ZSH_CONFIG_LOCAL)/local_env.zshrc $(HOME)/sbin $(ZSH_ALIASES)
.PHONY: set_zsh_env

$(ZSH_CONFIG_LOCAL):
	@mkdir $(ZSH_CONFIG_LOCAL)

$(HOME)/sbin:
	@mkdir $(HOME)/sbin

$(ZSH_ALIASES):
	@mkdir $(ZSH_ALIASES)

$(OH_MY_ZSH_DIR):
	@echo "*** Downloading oh-my-zsh ***"
	@git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh


# for tmux
prepare_tmux: check_cmd_tmux $(TMUX_CONFIG)
.PHONY: prepare_tmux

