# Skill Development Standards

Load this file when creating, modifying, or reviewing agent skills.

---

## Core principle

A skill is code. Treat it like production code.

Before using a skill, verify it works. Before committing changes, validate everything.

---

## Skill validation checklist

### Before first use (load time)

1. **Read SKILL.md** - Understand what the skill claims to do
2. **Check validation script** - If `validation:` field exists, run it
3. **Test basic commands** - At least one smoke test per module

Example validation in SKILL.md:
```yaml
---
name: my-skill
version: 1.0.0
validation: scripts/validate.sh
---
```

### Before committing changes

1. **Run validation script** - `bash scripts/validate.sh` or equivalent
2. **Test all documented commands** - Every example in SKILL.md must work
3. **Check documentation sync** - SKILL.md examples match actual CLI

---

## Documentation accuracy

### SKILL.md must match reality

Every command example in SKILL.md must be verified to work:

```
❌ Wrong: Documentation says "imm-romania mail list" but CLI uses "mail read"
✅ Right: Documentation matches actual CLI commands
```

When you change CLI commands:
1. Update SKILL.md immediately
2. Update help text in CLI
3. Test the example commands

### Keep examples minimal and working

```bash
# Good: minimal, verifiable
imm-romania mail connect

# Bad: requires setup user doesn't have
imm-romania mail send --to "specific-user@example.com" ...
```

---

## Validation script requirements

Every skill with CLI commands should have a validation script:

```bash
#!/bin/bash
# scripts/validate.sh - Test basic functionality

set -e

echo "Testing module X..."
python3 scripts/cli.py module command --arg value

echo "Testing module Y..."
python3 scripts/cli.py module command

echo "✅ All tests passed"
```

Requirements:
- Exit code 0 on success, non-zero on failure
- Test all core commands (at least one per module)
- Be idempotent (can run multiple times safely)
- Not require user-specific data (use test fixtures)

---

## Common mistakes to avoid

### Mistake 1: Assuming without verifying

```
❌ "The skill lists files, so files list must work"
✅ Run the command. Check the output. Verify it matches expectations.
```

### Mistake 2: Documentation drift

```
❌ SKILL.md says "command X" but code has "command Y"
✅ After every code change, verify SKILL.md examples
```

### Mistake 3: No validation script

```
❌ Skill has no automated testing
✅ Add scripts/validate.sh and reference it in SKILL.md
```

### Mistake 4: Testing happy path only

```
❌ Validation only tests "it runs"
✅ Validation tests actual output (files listed, email sent, etc.)
```

---

## When reviewing a skill

Run this mental checklist:

- [ ] SKILL.md describes actual functionality
- [ ] All command examples work as documented
- [ ] Validation script exists and passes
- [ ] Error handling exists (not just happy path)
- [ ] Dependencies are documented
- [ ] Setup instructions are complete and tested

---

## Fixing a broken skill

When you find a skill that doesn't work:

1. **Document the problem** - Create VERIFICATION.md with what's broken
2. **Fix the root cause** - Don't patch symptoms
3. **Add validation** - Ensure it won't regress
4. **Update documentation** - Sync SKILL.md with reality
5. **Commit everything together** - Fix + validation + docs in one commit

---

## Agent behavior for skills

When loading or using a skill:

1. Read SKILL.md first (it's the contract)
2. If `validation:` field exists, run it before using the skill
3. If no validation script, do a basic smoke test
4. If something doesn't work as documented, fix it before proceeding
5. Never assume a skill works without verification

---

## Example: Fixing a broken command

Problem: `files list` returns data but doesn't print it

```python
# Before (broken)
if command == 'list':
    path = command_args[0] if command_args else '/'
    client.list(path)  # Returns data, doesn't print
```

```python
# After (fixed)
if command == 'list':
    path = command_args[0] if command_args else '/'
    results = client.list(path)
    if results:
        from modules.nextcloud.nextcloud import print_list
        print_list(results)
    else:
        print("(empty)")
```

Lesson: Always verify that output is displayed, not just returned.