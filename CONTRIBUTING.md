# Contributing to PROJECT_NAME

Thanks for your interest in contributing! Replace this paragraph with one or two
sentences on what PROJECT_NAME is and what kind of contribution is most useful
right now — that steers people better than a long list further down.

Everyone taking part is expected to follow the
[Code of Conduct](https://github.com/shinobi-dosho/PROJECT_NAME/blob/main/CODE_OF_CONDUCT.md).

## Scope and philosophy

Our core philosophy: **avoid unnecessary complexity like the plague**.

State what this project does and, more usefully, what it does not. A feature
that would widen the scope is out of scope however useful; the right home for it
is usually a different project. Being explicit here is what lets a reviewer say
no without relitigating the whole design.

See **[`AGENTS.md`](https://github.com/shinobi-dosho/PROJECT_NAME/blob/main/AGENTS.md)**
for the design rationale and the conventions review comments are drawn from.
Read it before changing anything structural.

## Ways to contribute

- **Report bugs** via [issues](https://github.com/shinobi-dosho/PROJECT_NAME/issues).
  A report that says what you ran, what the input looked like, and what happened
  instead is worth more than a traceback alone. Security issues go to
  `SECURITY.md`, never to a public issue.
- **Fix a bug**, with a regression test that fails without the fix.
- **Improve documentation** under `docs/`, or the docstrings that feed the API
  reference. Documentation that has gone stale against the code is a bug.
- **Sizable change or addition** — open an issue to discuss it first, especially
  for anything that adds a dependency or widens the scope above.

## Development setup

The project uses [uv](https://docs.astral.sh/uv/):

```bash
git clone https://github.com/shinobi-dosho/PROJECT_NAME.git
cd PROJECT_NAME
uv sync --group dev
uv run pytest
uv run ruff check src tests docs

# enable the repo's pre-commit hook (once per clone)
git config core.hooksPath .githooks
```

Enabling the hook is the only setup step that is not uv's job — git will not let
a repository turn on an executable hook by itself, which is why the `git config`
is manual; skip it and you simply get no hook.

### The pre-commit hook

`.githooks/pre-commit` is a tracked shell script (no `pre-commit` framework, no
separate pinned tool universe). It does two jobs with deliberately different
triggers:

- **lint** — `ruff check` and `ruff format --check` over staged Python files, on
  every commit that touches `.py`. Fast. It runs the project's own pinned ruff
  through `uv run`, so it agrees with CI's lint job by construction. A format
  failure is fixed with `uv run ruff format <file> && git add <file>`; the hook
  never rewrites files behind your back.
- **audit** — `uv lock --check` then `pip-audit` over the locked runtime
  dependencies, and **only** when the commit touches `pyproject.toml` or
  `uv.lock`. pip-audit is a network round trip per pinned package; charging that
  to a docstring fix teaches people to reach for `--no-verify`.

`git commit --no-verify` bypasses it. CI runs `uv sync --locked`, so a dependency
change means committing the updated `uv.lock`.

## Testing

```bash
uv run pytest -q
```

Assert the shape a real caller depends on, not that construction succeeded. A bug
fix comes with a regression test that fails without the fix.

## Code style

- **Lint must be clean**: `uv run ruff check src tests docs` should report no errors.
  Ruff runs at `line-length = 100` with the rule set selected in
  `pyproject.toml` — stated outright rather than inherited, so a ruff release
  cannot widen it under you.
- `ruff format` is available and uses the same line width.
- Use **type hints** and write **docstrings** on public API — they render into
  the Sphinx API reference via autodoc.
- Match the surrounding code's naming, comment density, and idiom.

## Documentation

```bash
uv sync --group docs
uv run sphinx-build -b html docs docs/_build/html -W --keep-going
```

`-W` matches CI: warnings are errors. Note that relative links to repo-root files
(`AGENTS.md`, `CODE_OF_CONDUCT.md`) will fail this build if the target is not in
the docs tree — use absolute GitHub URLs in files Sphinx renders.

## Pull requests

1. Branch off `main` and keep PRs **small and focused** — one logical change per
   PR is much easier to review.
2. Make sure `uv run pytest -q` and `uv run ruff check src tests docs` pass locally,
   and that docs build if you touched public API.
3. Push and open a PR against `main`. Reference any related issue
   (e.g. "Closes #12").
4. **CI must be green.** The `test` job runs the suite and lint across the
   supported Python versions — that's the merge gate.

### Commit messages

Write clear, descriptive commit messages explaining *why* a change is made. No
formal convention (Conventional Commits, sign-off/DCO, or CLA) is required.

Provenance for an assistant-assisted commit goes in a commit trailer and never
in the PR description — see
[*Attribution: commit trailers yes, PR trailers no*](https://github.com/shinobi-dosho/PROJECT_NAME/blob/main/AGENTS.md#attribution-commit-trailers-yes-pr-trailers-no).

## Versioning and releases

The project follows [Semantic Versioning](https://semver.org/). **Contributors
don't cut releases** — that's a maintainer task. The maintainer bumps `version`
in `pyproject.toml` and publishes a GitHub Release, which triggers the publish
workflow to build and upload to PyPI.

## License

By contributing, you agree that your contributions are licensed under the
project's [MIT License](https://github.com/shinobi-dosho/PROJECT_NAME/blob/main/LICENSE).
