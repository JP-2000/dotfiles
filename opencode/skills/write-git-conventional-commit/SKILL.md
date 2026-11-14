---
name: write-git-conventional-commit
description: write git conventional commit
---

# Write a conventional commit

Create a simple Git Conventional Commits message.

Use this format:

```text
<type>(<scope>): <short summary>

- <verb-led point>
- <verb-led point>
- <verb-led point>
```

## Rules

* Use Git Conventional Commits format.
* Always include a type and scope.
* Use lower case for the whole commit message.
* Keep the summary short, clear, and accurate.
* Use a valid type such as `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, or `perf`.
* Choose a scope that matches the main area changed.
* Add a short body with bullet points.
* Start each body point with a verb.
* Keep every point simple, readable, and easy to understand.
* Do not over-explain.
* Return only the draft git conventional commit.

## Example

```text
feat(rag): add embedding update script

- add a migration for rag embedding columns
- add a standalone script to update embeddings
- update plans to keep embedding generation outside concierge
```
