# Agent behavior guidelines

Behavioral guidelines to reduce common LLM coding mistakes.
Derived from [Andrej Karpathy's observations](https://x.com/karpathy/status/2015883857489522876) and the community skill `andrej-karpathy-skills`.
Use these when writing, reviewing, or editing code to avoid overcomplication, make surgical changes, surface assumptions, and define verifiable success criteria.

These rules complement `SKILL.md` sections 1–4 (Security, Architecture, Clean Code).
They address *how the agent thinks and acts* while coding, not *what the code does*.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

---

## 1. Think Before Coding

🔵 **CLEAN CODE** — Don't assume. Don't hide confusion. Surface tradeoffs.

Before implementing, the agent must:
- State assumptions explicitly. If uncertain, ask.
- Present multiple interpretations — don't pick silently when ambiguity exists.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

**❌ Wrong:**
```
User: "Add caching for the user lookup."
Agent: <implements Redis cluster with 200 lines>
```

**✅ Right:**
```
User: "Add caching for the user lookup."
Agent: "Assumptions: I'll use in-memory caching since this is a single-node
  deployment. If multi-node later, we should switch to Redis.
  Alternative: memoize with a TTL decorator.
  Proceed with in-memory + TTL?"
```

---

## 2. Simplicity First

🔵 **CLEAN CODE** — Minimum code that solves the problem. Nothing speculative.

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

The test: *Would a senior engineer say this is overcomplicated?* If yes, simplify.

**❌ Wrong:**
```python
class AbstractUserCacheStrategyFactory(ABC):
    ...  # 80 lines for a dict-based cache that was asked for
```

**✅ Right:**
```python
from functools import lru_cache

@lru_cache(maxsize=128)
def get_user_by_id(user_id: int) -> User:
    return db.query(User).get(user_id)
```

---

## 3. Surgical Changes

🟠 **PROCESS** — Touch only what you must. Clean up only your own mess.

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it — don't delete it.

When your changes create orphans:
- Remove imports / variables / functions that **YOUR changes** made unused.
- Don't remove pre-existing dead code unless asked.

The test: *Every changed line should trace directly to the user's request.*

**❌ Wrong:**
```diff
- def get_user(id):
+ def get_user(user_id):          # ← requested
      # TODO: clean this up later  # ← unrelated change
-     return db.get(id)
+     return db.get(user_id)      # ← requested
+                                   # ← also reformatted entire file
```

**✅ Right:**
```diff
- def get_user(id):
+ def get_user(user_id):
-     return db.get(id)
+     return db.get(user_id)
```

---

## 4. Goal-Driven Execution

🟠 **PROCESS** — Define success criteria. Loop until verified.

Transform imperative tasks into verifiable goals:

| Instead of... | Transform to... |
|---|---|
| "Add validation" | "Write tests for invalid inputs, then make them pass" |
| "Fix the bug" | "Write a test that reproduces it, then make it pass" |
| "Refactor X" | "Ensure tests pass before and after" |
| "Add feature Y" | "Add Y with tests, verify no regressions" |

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let the agent loop independently.
Weak criteria ("make it work") require constant clarification.

---

## Cross-references to hardshell

| Agent behavior rule | Maps to hardshell SKILL.md |
|---|---|
| §1 Think Before Coding | §3 Clean Code — "Comments explain why, not what" |
| §2 Simplicity First | §3 Clean Code — "DRY / YAGNI / no duplicate code" |
| §3 Surgical Changes | §4 Review Checklist — "Does it do exactly what was asked?" |
| §4 Goal-Driven Execution | §4 Review Checklist — "Tests / happy path / edge cases" + `references/testing.md` |

---

## When these guidelines are working

You will see:
- Fewer unnecessary changes in diffs — only requested changes appear.
- Fewer rewrites due to overcomplication — code is simple the first time.
- Clarifying questions come before implementation — not after mistakes.
- Clean, minimal PRs — no drive-by refactoring or "improvements".
