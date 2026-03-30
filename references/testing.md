# Testing standards

Load this file when the task involves writing, fixing, or reviewing tests.

---

## Core philosophy

Tests are not optional. They are the proof that code works.
A test that only checks "it ran without crashing" is worse than no test — it gives false confidence.

Test behavior, not implementation. If you can refactor the internals without touching tests, the tests are correct.

---

## TDD loop (use for new features)

```
1. Write a failing test that describes the desired behavior.
2. Write the minimum code to make it pass.
3. Refactor — clean the code without breaking the test.
4. Repeat.
```

Do not skip step 1. Writing the test first forces you to think about the interface before the implementation.

---

## Test pyramid

```
         /\
        /  \   E2E tests (few, slow, test full flows)
       /----\
      /      \  Integration tests (moderate, test component boundaries)
     /--------\
    /          \ Unit tests (many, fast, test single functions/classes)
   /------------\
```

- Unit tests: the foundation. Fast, isolated, no I/O, no network.
- Integration tests: test that layers work together (service + repo + DB).
- E2E tests: test critical user journeys only. Keep them minimal.

Aim for: ~70% unit, ~20% integration, ~10% E2E.

---

## What every test must have

Structure: Arrange → Act → Assert (AAA pattern)

```
# Arrange: set up the input and dependencies
user = User(email="test@example.com", role="admin")
repo = FakeUserRepository([user])
service = UserService(repo)

# Act: call the thing being tested
result = service.get_by_email("test@example.com")

# Assert: verify the outcome
assert result.email == "test@example.com"
assert result.role == "admin"
```

One assertion per concept (not per line — per logical idea).
Test name must describe: what is being tested, under what condition, what the expected result is.

Good: `test_login_returns_403_when_password_is_wrong`
Bad: `test_login_2` or `test_it_works`

---

## What to test

For every function/method, cover:
- Happy path: valid input, expected output.
- Edge cases: empty string, null, zero, negative, max value.
- Error paths: invalid input, missing resource, permission denied.
- Boundary conditions: off-by-one, first/last element.

For every API endpoint, cover:
- Success response (correct status code + body shape).
- Auth failure (401, 403).
- Validation failure (400 with meaningful error).
- Not found (404).

---

## Test isolation rules

- Unit tests must not touch the filesystem, network, or database.
- Use fakes/stubs/mocks for external dependencies.
- Prefer fakes (simple in-memory implementations) over mocks (behavior verification).
- Use mocks only when you need to assert that a specific call was made.
- Each test must be independent — no shared mutable state between tests.
- Tests must pass in any order.

---

## Coverage

Coverage is a floor, not a goal.
- Minimum: 70% line coverage on business logic.
- 100% coverage does not mean the code is correct. It means every line ran.
- Untested critical paths (auth, payments, data writes) are always a blocker.
- Do not write tests just to increase coverage numbers.

---

## Test code quality

Test code is production code. Apply the same standards:
- No magic numbers in assertions — use named constants.
- No copy-paste between tests — extract helpers.
- Keep setup minimal. A test that needs 50 lines of setup is testing too much.
- If a test is hard to write, the production code is probably too coupled.

---

## Regression tests

Every bug fix must include a regression test:
1. Write a test that reproduces the bug (it fails).
2. Fix the bug.
3. Confirm the test passes.
4. The test lives permanently — it documents the bug and prevents recurrence.
