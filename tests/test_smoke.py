"""Smoke tests.

Deliberately thin. These assert the package imports and the CLI is wired -- not
that anything works. Real tests assert the shape a caller depends on; see
AGENTS.md, "Tests describe behaviour, not construction".
"""

from click.testing import CliRunner

import project_name
from project_name.cli import cli


def test_version_is_exposed():
    assert project_name.__version__


def test_cli_runs():
    result = CliRunner().invoke(cli, ["hello"])
    assert result.exit_code == 0
    assert "PROJECT_NAME" in result.output
