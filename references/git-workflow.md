# Git workflow standards

Load this file when the task involves commits, branches, PRs, or code review process.

---

## Branch strategy

Use a consistent branching model. Recommended: trunk-based with short-lived feature branches.

```
main          →  always deployable, protected
develop       →  integration branch (optional, for teams with release cycles)
feature/<id>-<slug>   →  e.g. feature/142-user-auth
fix/<id>-<slug>       →  e.g. fix/198-null-pointer-login
chore/<slug>          →  e.g. chore/upgrade-dependencies
release/<version>     →  e.g. release/2.1.0
hotfix/<slug>         →  branched from main, merged back to main and develop
```

Rules:
- Feature branches live max 1–2 days. Longer → split the work.
- Never commit directly to `main` or `develop`.
- Delete branches after merging.
- One concern per branch. Mixing features and fixes makes review harder.

---

## Conventional commits

Format: `<type>(<scope>): <short description>`

Types:
- `feat`: new feature (triggers minor version bump)
- `fix`: bug fix (triggers patch version bump)
- `chore`: maintenance, deps, tooling (no version bump)
- `refactor`: code restructure without behavior change
- `test`: adding or fixing tests
- `docs`: documentation only
- `perf`: performance improvement
- `ci`: CI/CD configuration changes
- `revert`: reverting a previous commit

Rules:
- Description in imperative mood: "add user auth" not "added user auth".
- Max 72 characters in subject line.
- Body explains *why*, not what. Reference issue numbers: `Closes #142`.
- Breaking changes: add `!` after type or `BREAKING CHANGE:` in footer.

Examples:
```
feat(auth): add JWT refresh token rotation
fix(api): return 403 instead of 500 on missing permission
chore(deps): upgrade bcrypt to 5.1.1
refactor(user): extract password validation into domain service
feat!: remove legacy v1 API endpoints

BREAKING CHANGE: /api/v1/* routes no longer exist. Use /api/v2/*.
```

---

## Pull requests

### Before opening a PR
- Self-review your own diff first. Read every line.
- All tests pass locally.
- No debug code, no commented-out blocks, no TODOs without a linked issue.
- Branch is up to date with the target branch.

### PR description template
```
## What
Short description of what changed and why.

## How
Key implementation decisions or tradeoffs worth explaining.

## Testing
How was this tested? What scenarios were covered?

## Checklist
- [ ] Tests added/updated
- [ ] Docs updated if needed
- [ ] No secrets or debug code
- [ ] Self-reviewed
```

### PR size rules
- Max ~400 lines changed per PR. Larger → split by concern.
- One PR = one logical change. Reviewers lose focus on large diffs.
- Draft PRs are fine for early feedback — mark clearly.

### Review etiquette
- Reviewers: distinguish blocking issues from suggestions. Use prefixes:
  - `blocking:` — must fix before merge.
  - `nit:` — minor style/preference, non-blocking.
  - `suggestion:` — take it or leave it, explain your thinking.
- Authors: respond to every comment. "Done" or explain why you disagree.
- Approve only what you would be comfortable owning in production.

### Merge strategy
- Prefer squash merge for feature branches (clean history on main).
- Prefer merge commit for release branches (preserve history).
- Never force-push to shared branches.

---

## Approval rules

Minimum before merging:
- At least 1 approval from someone who understands the changed domain.
- CI passes: tests, linting, security scan.
- No unresolved blocking comments.

For sensitive changes (auth, payments, data migrations):
- 2 approvals minimum.
- Security review if the change touches trust boundaries.

---

## Tags & versioning

Follow Semantic Versioning: `MAJOR.MINOR.PATCH`
- MAJOR: breaking API change.
- MINOR: new backward-compatible feature.
- PATCH: backward-compatible bug fix.

Automate version bumps from conventional commit history when possible.
Tag releases on `main` with signed tags.
