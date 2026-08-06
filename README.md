# starter-pack

A template repository for new [shinobi-dosho](https://github.com/shinobi-dosho)
projects. It carries the organisation's conventions already wired up, so a new
repo starts green rather than accumulating them one PR at a time.

> **This README describes the template.** `bootstrap.sh` replaces it with a
> project README — write that one for users of your project, not for people
> setting it up.

## Using it

Click **Use this template** on GitHub, then in the fresh clone:

```bash
./bootstrap.sh my-project     # replaces placeholders, renames the package, self-deletes
uv sync --group dev
uv lock                       # CI runs --locked; the lock must be committed
git config core.hooksPath .githooks
uv run pytest
```

`bootstrap.sh` rewrites `PROJECT_NAME` to your distribution name (`my-project`)
and `project_name` to the importable package name (`my_project`). It only
touches tracked files.

Then edit the three places that cannot be generated:

| File | What to write |
| --- | --- |
| `AGENTS.md` | What the project is for, its architecture, and what is deliberately left out |
| `CONTRIBUTING.md` | *Scope and philosophy* — what this project does **not** do |
| `SECURITY.md` | *Security posture* — the threat model that is actually true here |

The rest (code of conduct, reporting address, PR rules, release process) is
organisation-wide and correct as shipped.

## What you get

**Community files**, matching the org standard and the section order every other
repo uses — `AGENTS.md`, `CONTRIBUTING.md`, `SECURITY.md`, `CODE_OF_CONDUCT.md`
(Contributor Covenant 2.1, byte-identical across the org).

**Packaging** — `pyproject.toml` on hatchling with a `src/` layout, Python
3.11–3.13, dependency groups (`ruff`, `tests`, `docs`, `audit`, `dev`), and a
ruff config that states its whole ruleset via `select` rather than inheriting
ruff's default, so a ruff release cannot turn an untouched `main` red.

**CI** (`.github/workflows/ci.yml`) — lint, format check and tests across the
matrix with `--locked` throughout; a `docs` job building Sphinx with `-W`; and a
`pip-audit` job over the locked runtime dependencies.

**Releases** (`.github/workflows/publish.yml`) — triggered by publishing a GitHub
Release, runs CI first, and uploads via PyPI trusted publishing (no stored
token; configure the publisher once on PyPI).

**The pre-commit hook** (`.githooks/pre-commit`) — a tracked shell script, not
the `pre-commit` framework. Lints staged Python on every commit; runs
`uv lock --check` and `pip-audit` only when `pyproject.toml` or `uv.lock` moves.
Enabled per clone with `git config core.hooksPath .githooks`, because git will
not let a repository install an executable hook by itself.

**Docs** — a Sphinx/Furo/MyST skeleton plus `.readthedocs.yaml`, with
`fail_on_warning` on to match CI.

**MIT, settled.** New shinobi-dosho projects are MIT: the `LICENSE` file, the
`license` field in `pyproject.toml` and the *License* section of
`CONTRIBUTING.md` all say so already, and they agree. Nothing to choose at
bootstrap time — and if you ever do change it, change all three together, since
a `LICENSE` that disagrees with the packaging metadata is what a downstream
consumer actually trips over.

## Two conventions worth knowing before you start

**Attribution.** Commits made with an assistant's help carry that agent's
default trailer — Claude Code's is `Co-Authored-By: Claude
<noreply@anthropic.com>` — and an agent without one uses the same
`<AGENT> <MODEL> <EMAIL>` shape. Pull request descriptions carry **no** trailer.
The `<email>` is required: GitHub only renders a trailer as co-authorship when
one is present. See `AGENTS.md`.

**Links in files Sphinx renders.** `CONTRIBUTING.md` is included in the docs
build, so relative links to repo-root files (`AGENTS.md`, `CODE_OF_CONDUCT.md`)
fail the `-W` build — the targets are not in the docs tree. Use absolute GitHub
URLs there. The template already does; keep it that way when you edit.

## Deliberately not included

- **`uv.lock`.** It cannot be generated meaningfully until you have declared real
  dependencies. Run `uv lock` as part of bootstrapping; CI is `--locked` and will
  fail without it.
- **Branch protection.** Set on the repo, not in the tree. Most org repos require
  a green CI run and a review on `main`.
