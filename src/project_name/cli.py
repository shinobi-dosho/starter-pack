"""Command line entry point.

Wired to the `PROJECT_NAME` console script in pyproject.toml. Delete this module
and its `[project.scripts]` entry if the project is a library only.
"""

from __future__ import annotations

import click

from . import __version__


@click.group()
@click.version_option(__version__)
def cli() -> None:
    """PROJECT_NAME command line."""


@cli.command()
def hello() -> None:
    """Placeholder subcommand -- replace with something real."""
    click.echo("hello from PROJECT_NAME")
