---
name: hardshell
version: 3.1.0
description: Apply when writing, reviewing, refactoring, or designing any code.
tags: [security, architecture, clean-code, coding, code-review, testing, git, performance]
always: false
user-invocable: true
validation: scripts/validate.sh
---

# Hardshell — code quality standards

Apply every rule below on every coding task, without exception.
If the model supports extended thinking, activate it for architecture decisions.

## Reference files — load when relevant

- Git workflow, commits, PRs → read `references/git-workflow.md`
- Performance, complexity, caching → read `references/performance.md`
- Testing strategy and TDD → read `references/testing.md`
- Python project → read `references/languages/python.md`
- TypeScript / JavaScript project → read `references/languages/typescript.md`
- Go project → read `references/languages/go.md`
- Creating or modifying skills → read `references/skill-development.md`

Load the relevant file before responding on that topic.
Do not load files unless the task requires them.

---

## 1. Security (highest priority)

### Input & trust boundary
- Validate all external input at the entry point. Never trust it downstream.
- Use allowlists, not denylists.
- Sanitize output to prevent injection (XSS, HTML, shell, SQL).
- Validate file uploads: type, size, extension.

### Secrets & credentials
- Zero secrets in source code. No keys, tokens, or passwords — ever.
- Use environment variables or a secrets manager.
- Add secret files to `.gitignore` immediately.
- Rotate any secret that was ever committed.

### Authentication & authorization
- Never implement your own crypto. Use established libraries.
- Hash passwords with bcrypt, argon2, or scrypt. Never SHA-* alone.
- Check authorization on every action — never assume it from a prior step.
- Apply Principle of Least Privilege everywhere.

### Common vulnerabilities — always prevent
- SQL injection: parameterized queries only, never string interpolation.
- XSS: escape output, use Content-Security-Policy headers.
- CSRF: use tokens or SameSite cookies.
- SSRF: validate and allowlist URLs before server-side requests.
- Path traversal: never concatenate user input into file paths.
- Sensitive data in logs: scrub passwords, tokens, PII before logging.

### API & HTTP
- Always use HTTPS. Redirect HTTP → HTTPS.
- Set security headers: HSTS, X-Content-Type-Options, X-Frame-Options, CSP.
- Rate-limit authentication endpoints.
- Return generic error messages to clients. Never expose stack traces.
- Use 401 for unauthenticated, 403 for unauthorized — never confuse them.

### Dependencies
- Audit dependencies regularly using the tool standard for the language.
- Pin versions in production. Remove unused packages promptly.

---

## 2. Architecture & design

### Core principles (apply all)
- Single Responsibility: one module/class = one reason to change.
- Open/Closed: open for extension, closed for modification.
- Liskov Substitution: subtypes must fully replace their base types.
- Interface Segregation: prefer small focused interfaces over large general ones.
- Dependency Inversion: depend on abstractions, not concretions. Inject dependencies.
- Separation of Concerns: UI, business logic, and data access must never be mixed.
- Law of Demeter: a module should not reach into the internals of objects it uses.

### Layered architecture — always enforce
```
Entry layer (routes, controllers, CLI)  →  input handling only
Service / use-case layer                →  business logic only
Repository / data-access layer          →  persistence only
Domain / model layer                    →  data shape only
```
A controller must never contain business logic.
A repository must never call another service.

### Modules & dependencies
- Loosely coupled, highly cohesive.
- Dependency direction: outer layers depend on inner, never the reverse.
- Prefer composition over inheritance.
- Circular dependencies are a design smell — fix the design.
- Each module exposes a clean, documented public interface.

### Design patterns — when to use
- Factory: object creation is complex or type-dependent.
- Strategy: behavior varies and you need runtime swapping.
- Repository: always abstract data access behind an interface.
- Observer: decoupled side effects (notifications, audit logs).
- Adapter: wrap third-party libraries so they can be swapped later.
- Facade: simplify a complex subsystem with a clean surface.
- Do not add patterns speculatively. Add them when the problem is already present.

### Database & persistence
- Never build queries via string interpolation. Use parameterized queries or an ORM.
- Keep migrations versioned and reversible.
- Use transactions for multi-step writes.
- Avoid N+1 queries — use joins or eager loading where appropriate.

---

## 3. Clean code

### Naming
- Names must reveal intent: `getUserById` not `getData`, `isActive` not `flag`.
- Functions: verb + noun. Variables: noun. Booleans: question form.
- No unexplained abbreviations. `url`, `id`, `http` are fine. `usrCnt` is not.
- Adapt conventions to the project's language and existing style.

### Functions
- One function = one thing. If you need "and" to describe it, split it.
- Keep functions short. If it exceeds ~25 lines, extract sub-functions.
- Max 3 parameters. More than 3 → group into a config/options object.
- No hidden side effects unless the name makes it explicit.
- Return early (guard clauses) to avoid deep nesting.

### Variables & state
- Prefer immutable declarations. Avoid mutable state unless necessary.
- Declare variables close to where they are used.
- No magic numbers. Extract named constants with clear intent.

### Error handling
- Never swallow errors silently. An empty catch block is forbidden.
- Log the original error with context before re-throwing or returning.
- Use typed/custom error classes for domain-specific errors.
- User-facing messages must be helpful and must not leak internals.

### Comments & documentation
- Self-documenting code first. A comment explaining *what* means the code is unclear.
- Comments explain *why*, not what.
- Document all public functions and exported interfaces.
- Remove commented-out dead code before committing.

### Style & duplication
- No duplicate code. If you write something twice, extract it.
- DRY — but don't over-abstract. Only generalize what already repeats.
- YAGNI — don't add code for hypothetical future needs.
- Respect the project's existing style. Consistency beats preference.

---

## 4. Review checklist

Run before completing any coding task.

**Correctness**
- Does the code do exactly what was asked?
- Are edge cases handled: empty input, null, zero, max values, concurrency?
- Are errors handled and logged with context?

**Security**
- Is all input validated at the boundary?
- Are there secrets or credentials in the code or comments?
- Are all queries parameterized?
- Is authorization checked on every action?
- Can user input reach a dangerous operation (path, query, shell, deserialization)?

**Architecture**
- Does it respect the layer separation defined in section 2?
- Are dependencies pointing in the correct direction?
- Is the module's public API clean and minimal?

**Clean code**
- Are all names intention-revealing?
- Are functions small with single responsibility?
- Is there duplicated logic that should be extracted?
- Are magic numbers replaced with named constants?

**Tests**
- Is there a test for the happy path?
- Are edge cases and error paths tested?
- Do tests assert actual behavior, not just absence of exceptions?

---

## 5. Agent behavior rules

- Apply sections 1–3 on every coding task without being asked.
- Run section 4 checklist before completing any task.
- Load the relevant `references/` file when the task involves git, testing,
  performance, a specific language, or skill development.
- **When loading or using a skill:**
  - Read SKILL.md first (it's the contract)
  - If `validation:` field exists, run it before using the skill
  - If no validation script, do a basic smoke test
  - If something doesn't work as documented, fix it before proceeding
  - Never assume a skill works without verification
- Flag issues with these prefixes:
  - **🔴 SECURITY** — explain why dangerous and show the fix.
  - **🟡 ARCHITECTURE** — name the pattern that resolves it.
  - **🔵 CLEAN CODE** — show the improved version.
  - **🟠 PROCESS** — git, testing, or performance issue.
- Always show improved code, not just observations.
- Never sacrifice security for convenience. If the user insists, comply only for
  explicit local prototypes and add: `TODO: SECURITY — remove before production`.
