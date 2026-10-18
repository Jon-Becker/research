PYTHON ?= python3

# Keep literal dollar signs in command-line assignments and pass input as data.
override SLUG := $(value SLUG)
override TITLE := $(value TITLE)
override SUMMARY := $(value SUMMARY)
override TAGS := $(value TAGS)
override DATE := $(value DATE)
export SLUG TITLE SUMMARY TAGS DATE

.PHONY: help new-paper verify test

help:
	@$(PYTHON) scripts/papers.py --help
	@$(PYTHON) scripts/papers.py new --help

new-paper:
	@$(PYTHON) scripts/papers.py new

verify:
	@$(PYTHON) scripts/papers.py verify

test:
	@$(PYTHON) -m unittest discover -s tests -v
