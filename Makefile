SHELL := /usr/bin/env bash
# absolute path to this repo (Makefile location)
REPO_DIR := $(shell cd $(dir $(abspath $(lastword $(MAKEFILE_LIST)))) && pwd)

# Make "make" run the install + build by default
.DEFAULT_GOAL := all

.PHONY: all help install build start bgnd stop run add-path-bash add-path-zsh

all: install build
	@printf "\n=> Default target complete: install and build finished\n"

help:
	@echo "Usage: make <target>"
	@echo
	@echo "Targets:"
	@echo "  (default)      Run install then build (just run 'make')"
	@echo "  install        Run the repo's ./install script (makes scripts executable, auto-adds PATH)"
	@echo "  build          Run the repo's ./build script (build Docker image)"
	@echo "  start          Run the repo's ./start script (interactive shell)"
	@echo "  bgnd           Run the repo's ./bgnd script (run container in background)"
	@echo "  stop           Run the repo's ./stop script (stop/remove container)"
	@echo "  run            Run ./run with a command: make run CMD='your command here'"
	@echo "  add-path-bash  Append the repo path to ~/.bashrc"
	@echo "  add-path-zsh   Append the repo path to ~/.zshrc"

install:
	@printf "=> Ensuring scripts are executable in %s\n" "$(REPO_DIR)"
	@chmod a+x "$(REPO_DIR)/install" "$(REPO_DIR)/build" "$(REPO_DIR)/start" "$(REPO_DIR)/stop" "$(REPO_DIR)/run" "$(REPO_DIR)/bgnd" 2>/dev/null || true
	@printf "=> Running install script (non-interactive; path will be added by default)\n"
	@cd "$(REPO_DIR)" && ADD_TO_PATH=1 ./install

build:
	@printf "=> Running build script in %s\n" "$(REPO_DIR)"
	@cd "$(REPO_DIR)" && ./build

start:
	@printf "=> Running start in %s\n" "$(REPO_DIR)"
	@cd "$(REPO_DIR)" && ./start

bgnd:
	@printf "=> Running bgnd in %s\n" "$(REPO_DIR)"
	@cd "$(REPO_DIR)" && ./bgnd

stop:
	@printf "=> Running stop in %s\n" "$(REPO_DIR)"
	@cd "$(REPO_DIR)" && ./stop

run:
	@if [ -z "$(CMD)" ]; then \
		printf "Error: no CMD specified.\nUsage: make run CMD='ls -la' \n"; exit 1; \
	fi
	@printf "=> Running: %s\n" "$(CMD)"
	@cd "$(REPO_DIR)" && ./run $(CMD)

# Helpers to add repo to PATH for common shells (safest to inspect before running)
add-path-bash:
	@printf "=> Appending repo path to ~/.bashrc (you can inspect the file before sourcing)\n"
	@grep -qxF 'export PATH=$$PATH:$(REPO_DIR)' $(HOME)/.bashrc 2>/dev/null || echo 'export PATH=$$PATH:$(REPO_DIR)' >> $(HOME)/.bashrc
	@printf "Done. Run: source ~/.bashrc\n"

add-path-zsh:
	@printf "=> Appending repo path to ~/.zshrc (you can inspect the file before sourcing)\n"
	@grep -qxF 'export PATH=$$PATH:$(REPO_DIR)' $(HOME)/.zshrc 2>/dev/null || echo 'export PATH=$$PATH:$(REPO_DIR)' >> $(HOME)/.zshrc
	@printf "Done. Run: source ~/.zshrc\n"