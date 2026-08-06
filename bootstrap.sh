#!/usr/bin/env bash
#
# Turn this template into a real project.
#
#     ./bootstrap.sh my-project
#
# Replaces the PROJECT_NAME / project_name placeholders everywhere, renames the
# package directory, and deletes itself. Run it once, immediately after creating
# a repository from the template, before writing any code.
#
# The distribution name may contain hyphens (`my-project`); the importable
# package name is derived from it by replacing hyphens with underscores
# (`my_project`), which is the convention the rest of the organisation follows.

set -euo pipefail

if [ $# -ne 1 ]; then
    echo "usage: $0 <project-name>" >&2
    exit 2
fi

dist_name=$1
pkg_name=${dist_name//-/_}

if ! printf '%s' "$dist_name" | grep -qE '^[a-z][a-z0-9-]*$'; then
    cat >&2 <<MSG
error: '$dist_name' is not a usable distribution name.

Use lowercase letters, digits and hyphens, starting with a letter -- PyPI
normalises anything else, and a name that normalises to something you did not
choose is a bad surprise at publish time.
MSG
    exit 2
fi

if [ ! -d src/project_name ]; then
    echo "error: src/project_name not found -- has bootstrap already run?" >&2
    exit 1
fi

echo "distribution name : $dist_name"
echo "package name      : $pkg_name"

# Tracked files only: never rewrite .git internals, .venv, or build output. If
# this is not a git checkout yet, fall back to a find over the tree.
if git rev-parse --git-dir >/dev/null 2>&1; then
    mapfile -t files < <(git ls-files)
else
    mapfile -t files < <(find . -type f \
        -not -path './.git/*' -not -path './.venv/*' -not -path './docs/_build/*')
fi

for f in "${files[@]}"; do
    [ -f "$f" ] || continue
    case "$f" in
        bootstrap.sh) continue ;;
    esac
    # PROJECT_NAME -> distribution name, project_name -> package name. Order
    # matters: the uppercase form is replaced first so it cannot be clobbered by
    # a case-insensitive match on the lowercase one.
    sed -i "s/PROJECT_NAME/$dist_name/g; s/project_name/$pkg_name/g" "$f"
    # LICENSE carries COPYRIGHT_YEAR rather than a baked-in year, so a repo
    # created from this template is not stamped with the year the template was
    # written. docs/conf.py computes its year at build time instead.
    sed -i "s/COPYRIGHT_YEAR/$(date +%Y)/g" "$f"
done

git mv src/project_name "src/$pkg_name" 2>/dev/null || mv src/project_name "src/$pkg_name"

echo
echo "Done. Next:"
echo "  1. Edit AGENTS.md, CONTRIBUTING.md and SECURITY.md where they say to."
echo "  2. Set the description and dependencies in pyproject.toml."
echo "  3. uv sync --group dev && git config core.hooksPath .githooks"
echo "  4. uv lock  (CI runs --locked; the lock must be committed)"
echo

rm -- "$0"
