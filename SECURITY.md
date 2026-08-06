# Security Policy

## Supported versions

Security fixes are applied to the latest release only; there are no
long-term-support branches. While the project is pre-1.0, that means the newest
`0.x`.

| Version | Supported |
| ------- | --------- |
| latest `0.x` | :white_check_mark: |
| older       | :x: |

## Reporting a vulnerability

**Please do not report security issues in public GitHub issues.**

Report vulnerabilities privately by email to **sphemakh@gmail.com** (or via
GitHub's [private vulnerability reporting][ghsa] on this repository, if
enabled). Include enough detail to reproduce — affected version, the operation
you ran, the inputs involved, and the impact you observed.

We aim to acknowledge reports within a reasonable time, work with you on a fix,
and credit you in the release notes if you'd like.

[ghsa]: https://docs.github.com/en/code-security/security-advisories/guidance-on-reporting-and-writing-information-about-vulnerabilities/privately-reporting-a-security-vulnerability

## Security posture

Replace this section with what is actually true of *this* project. It is the
part of the file worth writing: the version table and the reporting address are
the same everywhere, but the threat model is not, and a reviewer needs to know
which of the guarantees below this project actually makes.

The organisation-wide baselines, which hold unless a project says otherwise:

- **No `eval`/`exec` of content the tools read.** Config, data files and
  metadata are *data*. Anything that could arrive from elsewhere is never
  executed.
- **No shell.** Where a command is executed, it goes out as a list-form
  `subprocess` argv — never `shell=True`, never string interpolation into a
  shell.
- **Untrusted input stays untrusted.** Reading someone else's file should not be
  able to execute their code. A way around that is a security issue.
- **Writes are explicit.** Operations that would overwrite existing data require
  an explicit `overwrite`/`force` rather than clobbering by default.

If this project deliberately executes something a caller supplies — a query
language, a user-supplied expression — say so here plainly and explain the
handling, rather than leaving it to be discovered.

## Dependency discipline

Runtime dependencies are pinned in `uv.lock` and audited by `pip-audit`, run
both by `.githooks/pre-commit` (on commits touching `pyproject.toml` or
`uv.lock`) and by the `audit` CI job. Both audit the locked *runtime* set — the
versions this package inflicts on someone who installs it.

When an advisory lands, raise the floor in `pyproject.toml` as well as
regenerating the lock: the lock alone protects this repo's checkouts, but a
downstream `pip install` resolving against an old floor could still land on a
flagged release.
