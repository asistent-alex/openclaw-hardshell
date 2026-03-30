# Python standards

Load this file when the project uses Python.

---

## Style — PEP 8 (always enforced)

- Indentation: 4 spaces. Never tabs.
- Max line length: 88 characters (Black default). Configure your linter to match.
- Two blank lines between top-level definitions (functions, classes).
- One blank line between methods inside a class.
- Imports: standard library → third-party → local, separated by blank lines.
- No wildcard imports (`from module import *`).
- Snake_case for variables, functions, modules. PascalCase for classes. UPPER_CASE for constants.

Run `black` for formatting and `ruff` or `flake8` for linting.
These are non-negotiable in any Python project.

---

## Type hints (required for all new code)

Type hints are not optional. They are documentation that the interpreter can check.

```python
# Wrong
def get_user(user_id):
    ...

# Right
from typing import Optional

def get_user(user_id: int) -> Optional[User]:
    ...
```

Rules:
- Annotate all function parameters and return types.
- Use `Optional[X]` (or `X | None` in Python 3.10+) for nullable values.
- Use `list[str]`, `dict[str, int]` (lowercase, Python 3.9+) not `List`, `Dict`.
- Use `TypedDict` or dataclasses for structured dicts.
- Run `mypy` or `pyright` in CI. Type errors are bugs.

---

## Docstrings (required for public API)

Use Google-style docstrings for all public functions, classes, and modules.

```python
def calculate_discount(price: float, rate: float) -> float:
    """Calculate the discounted price.

    Args:
        price: The original price in euros.
        rate: The discount rate as a decimal (0.0 to 1.0).

    Returns:
        The final price after applying the discount.

    Raises:
        ValueError: If rate is not between 0.0 and 1.0.
    """
    if not 0.0 <= rate <= 1.0:
        raise ValueError(f"Discount rate must be 0.0–1.0, got {rate}")
    return price * (1 - rate)
```

Private methods (prefixed with `_`) do not require docstrings unless complex.
All public methods, classes, and modules do.

---

## Pythonic patterns — prefer these

```python
# Use list comprehensions instead of loops for simple transforms
squares = [x ** 2 for x in range(10)]  # not: squares = []; for x in ...: squares.append(...)

# Use enumerate instead of range(len(...))
for i, item in enumerate(items):  # not: for i in range(len(items)):

# Use dict.get() for safe access
value = config.get("timeout", 30)  # not: value = config["timeout"] if "timeout" in config else 30

# Use context managers for resource management
with open("file.txt") as f:  # not: f = open(...); try: ... finally: f.close()
    content = f.read()

# Use dataclasses for data containers
from dataclasses import dataclass

@dataclass
class Order:
    id: int
    total: float
    status: str = "pending"

# Use f-strings for formatting
message = f"User {user.name} logged in"  # not: "User %s logged in" % user.name

# Use pathlib instead of os.path
from pathlib import Path
config_path = Path("config") / "settings.json"  # not: os.path.join("config", "settings.json")
```

---

## Error handling

```python
# Use specific exceptions, never bare except
try:
    result = risky_operation()
except ValueError as e:
    logger.error("Invalid value: %s", e)
    raise

# Never do this
try:
    ...
except:  # catches SystemExit, KeyboardInterrupt — always wrong
    pass

# Custom domain exceptions
class PaymentError(Exception):
    """Base class for payment domain errors."""

class InsufficientFundsError(PaymentError):
    def __init__(self, required: float, available: float):
        self.required = required
        self.available = available
        super().__init__(f"Need {required}, only {available} available")
```

---

## Dependency & environment management

- Use `pyproject.toml` (PEP 517/518). Avoid `setup.py` for new projects.
- Pin all dependencies in `requirements.txt` or lock files (`poetry.lock`, `uv.lock`).
- Use virtual environments. Never install into the system Python.
- Preferred toolchain: `uv` (fast) or `poetry` (feature-rich). Avoid bare `pip` for projects.
- Audit dependencies: `pip-audit` or `safety check`.
- Separate dev dependencies from production dependencies.

---

## Security — Python specifics

- Never use `pickle` to deserialize untrusted data. It executes arbitrary code.
- Never use `eval()` or `exec()` on user input.
- Use `subprocess` with a list of arguments, never a shell string:
  ```python
  # Wrong — shell injection possible
  subprocess.run(f"convert {filename}", shell=True)

  # Right
  subprocess.run(["convert", filename], check=True)
  ```
- Use `secrets` module for cryptographic tokens, not `random`.
- Use `hashlib` with proper algorithms. Never `md5` or `sha1` for security.

---

## Testing (Python)

Preferred framework: `pytest`.

```python
# Test file naming: test_<module>.py or <module>_test.py
# Test function naming: test_<what>_<condition>_<expected>

def test_calculate_discount_with_fifty_percent_returns_half_price():
    result = calculate_discount(price=100.0, rate=0.5)
    assert result == 50.0

def test_calculate_discount_with_invalid_rate_raises_value_error():
    with pytest.raises(ValueError, match="Discount rate must be"):
        calculate_discount(price=100.0, rate=1.5)
```

Use `pytest-cov` for coverage. Use `pytest-mock` or `unittest.mock` for mocking.
Use `freezegun` for time-dependent tests.
Use `factory_boy` or fixtures for test data — never hardcode magic values.

---

## Toolchain summary

| Purpose | Tool |
|---------|------|
| Formatter | `black` |
| Linter | `ruff` (replaces flake8 + isort + pyupgrade) |
| Type checker | `mypy` or `pyright` |
| Test runner | `pytest` |
| Coverage | `pytest-cov` |
| Security audit | `pip-audit` |
| Package manager | `uv` or `poetry` |

Configure all tools in `pyproject.toml`. Run them all in CI before merge.
