MKFILE_PATH  := $(abspath $(lastword $(MAKEFILE_LIST)))
ROOT_DIR := $(dir $(MKFILE_PATH))
PYTHON := $(ROOT_DIR)/.venv/bin/python
PIP := $(ROOT_DIR)/.venv/bin/pip

.PHONY: deps
deps:
	cd $(ROOT_DIR) && $(PIP) install -e .
