# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.2.0] - 2026-05-16

### Added

- **Agent behavior reference** (`references/agent-behavior.md`) with four principles derived from [Andrej Karpathy's observations on LLM coding pitfalls](https://x.com/karpathy/status/2015883857489522876):
  1. **Think Before Coding** — surface assumptions, present multiple interpretations, push back when warranted
  2. **Simplicity First** — minimum code that solves the problem, nothing speculative
  3. **Surgical Changes** — touch only what you must, match existing style, don't refactor adjacent code
  4. **Goal-Driven Execution** — transform imperative tasks into verifiable goals with explicit success criteria
- Updated `README.md` with agent behavior section and acknowledgments
- Created this `CHANGELOG.md`

### Changed

- `SKILL.md` §5 — added reference to `references/agent-behavior.md` for editing existing code or ambiguous requests
- `scripts/validate.sh` — expanded reference file list from 7 to 8 files

## [3.1.0] - 2026-04-27

### Added

- Validation script (`scripts/validate.sh`) for smoke-testing the skill
- `.gitignore` for `.claude/` directory
- `references/skill-development.md` — standards for creating and validating OpenClaw skills

## [3.0.0] - 2026-04-23

### Added

- Initial release of Hardshell coding standards skill
- Security rules (input validation, secrets, auth, common vulnerabilities, API security, dependencies)
- Architecture & design principles (SOLID, layered architecture, design patterns, database)
- Clean code guidelines (naming, functions, variables, error handling, comments, style)
- Review checklist (correctness, security, architecture, clean code, tests)
- Agent behavior rules (flag prefixes, skill loading contract)
- Reference files: `git-workflow.md`, `performance.md`, `testing.md`
- Language-specific references: `python.md`, `typescript.md`, `go.md`

## [1.0.0] - 2026-01-20

### Added

- Initial proof-of-concept release

[3.2.0]: https://github.com/asistent-alex/openclaw-hardshell/compare/v3.1.0...v3.2.0
[3.1.0]: https://github.com/asistent-alex/openclaw-hardshell/compare/v3.0.0...v3.1.0
[3.0.0]: https://github.com/asistent-alex/openclaw-hardshell/compare/v1.0.0...v3.0.0
[1.0.0]: https://github.com/asistent-alex/openclaw-hardshell/releases/tag/v1.0.0
