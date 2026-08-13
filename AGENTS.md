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
**commit message**, naming the assistant and the model behind it:

```
Assisted-by: <LLM> <MODEL>
```

-- e.g. `Assisted-by: Claude Opus 5`, `Assisted-by: Codex GPT-5`. One
line, last in the message, after any `Co-authored-by:` for real people.

Agents default to a `Co-authored-by:` trailer with an address; replace
it. Both halves of that default are wrong here. `Co-authored-by:` claims
more than happened -- these tools assist, and the person who ran them
owns the change and answers for it. The address is what makes the claim
bite: GitHub renders a trailer as co-authorship only when one is
present, so `Co-authored-by: Claude <noreply@anthropic.com>` attaches a
vendor to the authorship of work this organisation owns. `Assisted-by:`
with no address records the same fact as plain text and attaches nobody.

This reverses the rule as it stood until August 2026, which argued that
co-authorship was the honest description of tools doing real work. The
consideration that changed it is ownership, not accuracy of credit:
these are paid services operating on our IP, and the history should not
carry anything a vendor could read as a stake in it.

**Pull request descriptions carry no trailer at all** -- no
`Assisted-by:`, no `Co-authored-by:`, no "Generated with", no tool
badge. A PR body is review material: it exists to tell a reviewer what
changed and why, and what to check. Provenance already lives on every
commit the PR contains, where it is attached to the specific change
rather than repeated once per PR, so a trailer in the description is
duplication in the one place that has no room for it. Agents default to adding one; delete it.

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
