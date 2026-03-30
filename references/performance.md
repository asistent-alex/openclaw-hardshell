# Performance standards

Load this file when the task involves performance, optimization, scaling, or complexity analysis.

---

## Measure before optimizing

Never optimize code you haven't measured.
Premature optimization is the most common source of complex, unmaintainable code.

Before touching performance:
1. Define what "slow" means. Set a concrete target (e.g., "p95 < 200ms").
2. Profile. Find the actual bottleneck — it is almost never where you think.
3. Fix the bottleneck. Ignore everything else.
4. Measure again. Confirm the improvement.

---

## Algorithmic complexity — know your costs

Always reason about complexity before writing loops inside loops.

| Operation | Complexity | Comment |
|-----------|-----------|---------|
| Hash lookup | O(1) | Use dicts/maps for frequent lookups |
| Array access by index | O(1) | |
| Binary search | O(log n) | Requires sorted data |
| Single loop | O(n) | Acceptable for most cases |
| Nested loops | O(n²) | Alarm bell for n > 1000 |
| Sorting | O(n log n) | Standard sort algorithms |
| Recursive without memoization | O(2ⁿ) or worse | Almost always wrong |

Rules:
- O(n²) is acceptable only for n < ~1000 and non-hot paths.
- If the data set can grow unboundedly, O(n²) is a bug waiting to happen.
- When in doubt, write it simply first. Optimize only after profiling.

---

## Database performance

N+1 queries are the most common performance killer in web applications.

Detecting N+1:
```
# This runs 1 query to get orders, then 1 query per order to get user → N+1
for order in get_all_orders():
    print(order.user.name)  # lazy load triggers a query each time

# This runs 1 query with a JOIN
orders = get_all_orders_with_users()
for order in orders:
    print(order.user.name)
```

Rules:
- Use eager loading / joins when fetching related data in a loop.
- Index columns used in WHERE, JOIN, and ORDER BY clauses.
- Use LIMIT/pagination — never return unbounded result sets.
- Avoid SELECT * in production queries — specify columns.
- Use query explain/analyze to understand execution plans for slow queries.
- Use connection pooling. Never open a new DB connection per request.

---

## Caching

Cache when: data is expensive to compute, read far more often than written,
and tolerable staleness exists.

Do not cache when: data must always be fresh, or the cache adds more complexity than it saves.

Cache hierarchy (fastest to slowest):
```
In-process memory (dict/map)  →  nanoseconds, lost on restart
Distributed cache (Redis)     →  microseconds, shared across instances
CDN / HTTP cache              →  milliseconds, for static/semi-static content
Database query cache          →  use sparingly, easy to misuse
```

Cache invalidation rules:
- Set explicit TTLs. Never cache forever without a TTL.
- Invalidate on write, not on read.
- Cache the result, not the computation. Cache at the highest useful level.
- Monitor cache hit rates. A low hit rate means the cache is not helping.

---

## I/O and concurrency

I/O (network, disk, database) is orders of magnitude slower than CPU.

Rules:
- Batch I/O operations where possible. 1 query for 100 records beats 100 queries for 1 record.
- Use async/non-blocking I/O for I/O-bound work (HTTP calls, file reads).
- Use worker pools/queues for CPU-bound work.
- Never block the main thread/event loop with synchronous I/O.
- Set timeouts on all external calls. An unconfigured timeout is a guaranteed outage.
- Handle backpressure — don't queue unbounded work.

---

## Memory

- Release resources explicitly: close files, connections, cursors.
- Use streaming / pagination for large data sets. Never load millions of records into memory.
- Watch for reference cycles in long-lived objects.
- Profile memory usage under realistic load, not just CPU.

---

## Frontend performance (when applicable)

- Minimize bundle size. Audit and remove unused dependencies.
- Lazy-load code that is not needed on initial render.
- Images: use modern formats (WebP/AVIF), correct dimensions, lazy loading.
- Avoid layout thrashing: batch DOM reads before DOM writes.
- Debounce/throttle event handlers (scroll, resize, input).
- Use browser caching headers correctly (Cache-Control, ETag).

---

## Performance review checklist

Before calling a task complete, check:
- Are there any loops that query a database or make network calls?
- Are result sets bounded by LIMIT or pagination?
- Are indexes in place for the query patterns being used?
- Are external calls covered by timeouts?
- Is there any synchronous blocking I/O on a hot path?
