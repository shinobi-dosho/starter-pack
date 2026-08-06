# PROJECT_NAME -- design conventions

Read this before changing anything structural. Replace this paragraph with what
a newcomer to *this* project has to know first: what it is for, and the one
mistake it exists to make impossible.

Organisation-wide conventions live in
[`shinobi-dosho/.github`](https://github.com/shinobi-dosho/.github/blob/main/AGENTS.md) -- this file states what is
specific to `PROJECT_NAME` and wins where the two disagree.

## Core rule

Avoid unnecessary complexity like the plague.

Prefer the boring construct a reader understands on sight. A mechanism earns its
place by removing more complexity than it adds. When this file says a thing is
deliberately left out, it is left out on purpose -- do not helpfully add it back.

## Scope

State what this project does **not** do, and where that work belongs instead.
This section is load-bearing: it is what lets a reviewer reject a useful feature
without arguing about whether it is useful.

## Architecture

Replace with the shape of the code: the entry points, the module that owns each
concern, and the invariants that are easy to break by accident.

## Tests describe behaviour, not construction

A test asserting an object was built without error has tested nothing a reviewer
cares about. Assert the shape a real caller depends on -- the values a reader
returns from a real file, the argv a command builds. A bug fix comes with a
regression test that fails without the fix.

## Attribution: commit trailers yes, PR trailers no

A commit made with an assistant's help says so in a trailer on the
**commit message**. Use whatever trailer the agent emits by default --
Claude Code, for instance, ends a commit with

```
Co-Authored-By: Claude <noreply@anthropic.com>
```

An agent with no default of its own uses the same form, naming itself and
the model behind it, with an address:

```
Co-authored-by: <AGENT> <MODEL> <EMAIL>
```

-- e.g. `Co-authored-by: Codex GPT-5 <noreply@openai.com>`. One line, last
in the message, after any `Co-authored-by:` for real people. The address
is not decoration: GitHub only renders a trailer as co-authorship when it
carries an `<email>`, so without one the credit stays plain text in the
message body. Credit is the point -- these tools do real work here, and
the history should say so.

**Pull request descriptions carry no trailer at all** -- no
`Co-authored-by:`, no "Generated with", no tool badge. A PR body is
review material: it exists to tell a reviewer what changed and why, and
what to check. Provenance already lives on every commit the PR contains,
where it is attached to the specific change rather than repeated once
per PR, so a trailer in the description is duplication in the one place
that has no room for it. Agents default to adding one; delete it.

Neither form is a substitute for the message itself. A commit that
explains a decision badly does not improve by naming the model that
helped make it -- see the existing history for the standard: what
changed, what it deviates from and why, and what a reviewer should not
assume held still.

## Reviewing changes: check the tree, not just the diff

A claim that something "doesn't exist" or "is unused" should be verified against
the actual tree before acting on it -- a symbol absent from the diff is usually
present in the repo. This is not hypothetical: relative links in a
`CONTRIBUTING.md` that Sphinx also renders will fail a `-W` docs build even
though nothing in the diff looks wrong.
