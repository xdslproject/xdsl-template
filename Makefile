MAKEFLAGS += --warn-undefined-variables
SHELL := bash

.PHONY: install
install: .venv/ pre-commit

.venv/:
	uv sync

.PHONY: pre-commit
pre-commit: .venv/
	uv run pre-commit install

.PHONY: check
check: .venv/
	uv run pre-commit run --all-files

.PHONY: test
test: .venv/
	uv run coverage run -m pytest -s &&\
 		uv run coverage report -m

.PHONY: docs-serve
docs-serve: uv-installed
	uv run mkdocs serve

.PHONY: docs-build
docs-build: uv-installed
	uv run mkdocs build

.PHONY: clean
clean:
	rm -rf .mypy_cache/ .pytest_cache/ .ruff_cache/ .coverage
	find . -not -path "./.venv/*" | \
		grep -E "(/__pycache__$$|\.pyc$$|\.pyo$$)" | \
		xargs rm -rf

.PHONY: clobber
clobber: clean
	rm -rf .venv/
