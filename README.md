# Hardshell - OpenClaw Coding Standards

**Version:** 3.0.0

A comprehensive coding standards skill for OpenClaw agents. Apply every rule on every coding task, without exception.

## Installation

```bash
# Install from ClawHub (when published)
openclaw skill install hardshell

# Or install from GitHub
openclaw skill install https://github.com/assistentalex/openclaw-hardshell
```

## What It Covers

### Security (Highest Priority)
- Input validation and trust boundaries
- Secrets and credentials management
- Authentication and authorization
- Common vulnerabilities (SQLi, XSS, CSRF, SSRF, path traversal)
- API and HTTP security
- Dependency auditing

### Architecture & Design
- SOLID principles
- Separation of concerns
- Law of Demeter
- API design patterns
- Error handling strategies

### Code Quality
- Naming conventions
- Function design
- Comments and documentation
- Code smells to avoid

### Testing
- TDD (Test-Driven Development)
- Test pyramid (70% unit, 20% integration, 10% E2E)
- Coverage minimums (70% on business logic)
- Test isolation rules

### Git Workflow
- Branch strategy (trunk-based with short-lived feature branches)
- Conventional commits format
- PR process and code review

### Performance
- Complexity analysis
- Caching strategies
- Optimization guidelines

## Usage

When the agent is working on code, it automatically loads relevant reference files:

```
User: "Write a Python function to send email"
Agent: Loads references/languages/python.md for Python-specific standards
```

## Reference Files

| File | Purpose |
|------|---------|
| `references/git-workflow.md` | Branches, commits, PRs |
| `references/performance.md` | Complexity, caching |
| `references/testing.md` | TDD, test pyramid |
| `references/languages/python.md` | Python-specific |
| `references/languages/typescript.md` | TS/JS-specific |
| `references/languages/go.md` | Go-specific |

## License

MIT License - see [LICENSE](LICENSE)

## Contributing

This skill is designed to be universal. If you have improvements that apply across all OpenClaw skills:

1. Fork the repository
2. Create a feature branch
3. Submit a pull request with your improvements

## Author

OpenClaw Community

## Links

- [OpenClaw Documentation](https://docs.openclaw.ai)
- [ClawHub](https://clawhub.ai)
- [GitHub Repository](https://github.com/assistentalex/openclaw-hardshell)