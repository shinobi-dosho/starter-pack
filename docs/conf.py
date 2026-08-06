"""Sphinx configuration."""

from __future__ import annotations

from datetime import UTC, datetime

project = "PROJECT_NAME"
author = "Sphesihle Makhathini"
# Computed, not pinned: a hardcoded year is wrong every January and nobody
# notices. `tz=UTC` because ruff's DTZ rules are selected -- a naive
# datetime.now() fails lint.
copyright = f"{datetime.now(tz=UTC).year}, {author}"  # noqa: A001

extensions = [
    "sphinx.ext.autodoc",
    "sphinx.ext.napoleon",
    "sphinx.ext.intersphinx",
    "sphinx_copybutton",
    "myst_parser",
]

templates_path = ["_templates"]
exclude_patterns = ["_build"]

html_theme = "furo"
html_static_path = []

intersphinx_mapping = {"python": ("https://docs.python.org/3", None)}

# CI builds with -W, so an unresolved reference fails the build. That is the
# point: it catches a link to a repo-root file (AGENTS.md, CODE_OF_CONDUCT.md)
# that is not part of the docs tree.
nitpicky = False
