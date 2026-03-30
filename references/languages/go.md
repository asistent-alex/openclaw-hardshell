# Go — language-specific standards

Load this file for any Go project. Apply these rules in addition to
the core hardshell standards.

---

## Code style

Go style is enforced by tooling, not convention.

- gofmt or goimports must run on every save and in CI. No exceptions.
- golangci-lint for static analysis. Configure in .golangci.yml.
- Follow standard Go project layout: cmd/, internal/, pkg/, api/.
- Use internal/ for packages that must not be imported by external code.

---

## Error handling — Go's most important convention

```go
// ✓ check every error, wrap with context
user, err := db.GetUser(ctx, userID)
if err != nil {
    return fmt.Errorf("getting user %s: %w", userID, err)
}

// ✗ ignored error
user, _ := db.GetUser(ctx, userID)

// ✗ no context — impossible to trace in production
if err != nil {
    return err
}
```

Rules:
- Never ignore errors with _. Every error must be handled.
- Wrap errors with fmt.Errorf("context: %w", err) to preserve the chain.
- Use errors.Is() and errors.As() to inspect wrapped errors.
- Define sentinel errors: var ErrNotFound = errors.New("not found").
- Panic only for unrecoverable programmer errors (nil pointer on startup config).
  Never panic on user input or runtime errors.

---

## Interfaces

- Define interfaces at the point of use (consumer side), not the provider.
- Keep interfaces small. io.Reader (1 method) is the ideal.
- Accept interfaces, return concrete types.
- Do not define an interface until you have two implementations or a testing need.

---

## Concurrency

```go
// ✓ always pass context for cancellation
func (s *Service) FetchData(ctx context.Context, id string) (*Data, error) {
    return s.repo.Get(ctx, id)
}

// ✓ errgroup for concurrent work with error propagation
g, ctx := errgroup.WithContext(ctx)
g.Go(func() error { return fetchUsers(ctx) })
g.Go(func() error { return fetchOrders(ctx) })
if err := g.Wait(); err != nil {
    return fmt.Errorf("concurrent fetch: %w", err)
}
```

Rules:
- Pass context.Context as the first argument to every function that does I/O.
- Never store context in a struct — pass it explicitly.
- Channels for communication. Mutexes for shared state. Not both for the same thing.
- Always close channels from the sender side, never the receiver.
- Run tests with race detector in CI: go test -race ./...

---

## Testing — table-driven pattern

```go
func TestCalculateDiscount(t *testing.T) {
    tests := []struct {
        name     string
        price    float64
        rate     float64
        expected float64
        wantErr  bool
    }{
        {"valid discount", 100.0, 0.2, 80.0, false},
        {"zero rate",      100.0, 0.0, 100.0, false},
        {"invalid rate",   100.0, 1.5, 0.0,   true},
    }
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got, err := CalculateDiscount(tt.price, tt.rate)
            if (err != nil) != tt.wantErr {
                t.Errorf("unexpected error: %v", err)
            }
            if got != tt.expected {
                t.Errorf("got %v, want %v", got, tt.expected)
            }
        })
    }
}
```

Use table-driven tests for all functions with multiple scenarios.

---

## Tooling — standard Go stack

| Purpose        | Tool          |
|----------------|---------------|
| Formatter      | gofmt/goimports|
| Linter         | golangci-lint |
| Race detector  | go test -race |
| Security audit | govulncheck   |
| Build/release  | goreleaser    |

go vet must pass with zero warnings.
govulncheck in CI to detect known CVEs in dependencies.
