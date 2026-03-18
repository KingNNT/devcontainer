# User-Level Claude Code Instructions

These instructions apply to ALL projects on this machine.

## Git Commit Convention

Follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification strictly.

### Format

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### Rules

- **type** (required): One of the allowed types below
- **scope** (optional): A noun describing the affected codebase section (e.g., `auth`, `api`, `ui`)
- **description** (required): Short, imperative summary of the change (lowercase, no period at end)
- **body** (optional): Separated by a blank line, explains the motivation for the change
- **footer** (optional): Separated by a blank line, for metadata like `BREAKING CHANGE:` or `Refs: #123`
- **NEVER** add `Co-Authored-By` or any author attribution lines to commit messages
- Breaking changes: append `!` after type/scope (e.g., `feat!:`) or add `BREAKING CHANGE:` footer

### Allowed Types

| Type       | Description                                              |
| ---------- | -------------------------------------------------------- |
| `feat`     | A new feature                                            |
| `fix`      | A bug fix                                                |
| `docs`     | Documentation only changes                               |
| `style`    | Formatting, missing semicolons, etc. (no code change)    |
| `refactor` | Code change that neither fixes a bug nor adds a feature  |
| `perf`     | Performance improvement                                  |
| `test`     | Adding or correcting tests                               |
| `build`    | Changes to build system or external dependencies         |
| `ci`       | Changes to CI configuration files and scripts            |
| `chore`    | Other changes that don't modify src or test files        |
| `revert`   | Reverts a previous commit                                |

### Examples

```
feat(auth): add OAuth2 login flow
fix: resolve null pointer in user lookup
docs(readme): update installation instructions
refactor(api): extract validation into middleware
feat!: drop support for Node 14
```

## Coding Style

- Write clean, readable code with minimal comments (only where logic isn't self-evident)
- Prefer simple, direct solutions over clever abstractions
- Follow the existing conventions of whatever project you're working in
- For shell scripts: use `#!/usr/bin/env bash`, `set -e`, 2-space indentation, and quote variables

## Communication Style

- Be concise and direct — lead with the answer or action
- Skip preamble and unnecessary transitions
- Don't restate what was asked — just do it
- Only explain when the reasoning matters for the decision
