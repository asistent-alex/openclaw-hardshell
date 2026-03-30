# TypeScript / JavaScript standards

Load this file when the project uses TypeScript or JavaScript.
Prefer TypeScript for all new projects. JavaScript without types is legacy.

---

## TypeScript — always prefer it over plain JavaScript

New projects: TypeScript only. No exceptions.
Existing JS projects: migrate incrementally, starting with the most critical modules.

### tsconfig.json — strict mode is mandatory

```json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true
  }
}
```

`strict: true` enables: noImplicitAny, strictNullChecks, strictFunctionTypes,
and others. Every one catches real bugs. Never disable them.

---

## Types

```typescript
// ✓ explicit, narrow types
function getUser(id: string): Promise<User | null> { ... }

// ✗ any defeats the purpose of TypeScript
function process(data: any): any { ... }

// ✓ unknown is the safe alternative when type is truly unknown
function parsePayload(raw: unknown): ParsedData {
  if (!isValidPayload(raw)) throw new ValidationError("Invalid payload");
  return raw as ParsedData;
}
```

Rules:
- `any` is forbidden except in test utilities and migration shims. Use `unknown`.
- `as` type assertions require a comment explaining why it is safe.
- Prefer `interface` for object shapes that will be extended.
  Prefer `type` for unions, intersections, and computed types.
- Use `readonly` on properties that must not be mutated after construction.
- `enum` creates runtime overhead. Prefer `const` object maps or string literal unions.

---

## Null handling

- Enable `strictNullChecks`. It is part of `strict: true`.
- Treat `null` and `undefined` as different things.
  `null` = intentionally absent. `undefined` = not yet set.
- Optional chaining (?.) and nullish coalescing (??) are fine — but verify
  the fallback value is semantically correct, not just "makes the error go away."

---

## Async / await

```typescript
// ✓ always await, always handle errors
async function fetchUser(id: string): Promise<User> {
  try {
    const response = await api.get(`/users/${id}`);
    return response.data;
  } catch (error) {
    logger.error("Failed to fetch user", { id, error });
    throw new UserNotFoundError(id);
  }
}

// ✗ floating promise — error is silently swallowed
fetchUser(id);
```

- Never use floating promises. Either await or chain .catch().
- Promise.all() for concurrent independent async operations.
- Promise.allSettled() when you need all results regardless of individual failures.
- Never mix async/await and raw .then() in the same function.

---

## Tooling — standard TS/JS stack

| Purpose         | Tool                         |
|-----------------|------------------------------|
| Runtime types   | zod or valibot               |
| Linter          | ESLint with typescript-eslint|
| Formatter       | Prettier                     |
| Test runner     | Vitest (or Jest)             |
| Build           | tsc, esbuild, or tsup        |
| Security audit  | npm audit / pnpm audit       |
| Package manager | pnpm (preferred) or npm      |

Configure ESLint and Prettier in eslint.config.js and .prettierrc.
Both must run in CI. PRs with lint errors are not mergeable.

---

## Error handling

```typescript
// ✓ typed custom errors
class PaymentError extends Error {
  constructor(
    message: string,
    public readonly code: string,
    public readonly transactionId: string
  ) {
    super(message);
    this.name = "PaymentError";
  }
}

// ✓ type narrowing in catch
try {
  await processPayment(order);
} catch (error) {
  if (error instanceof PaymentError) {
    logger.warn("Payment declined", { code: error.code });
    return { success: false, reason: error.code };
  }
  throw error; // re-throw unexpected errors
}
```

- `catch (error)` gives you `unknown` in strict mode — narrow the type before using it.
- Create typed error classes for domain errors.
- Never surface error.message directly to the user — it may expose internals.
