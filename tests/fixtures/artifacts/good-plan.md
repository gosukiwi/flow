# Greeting Endpoint Implementation Plan

> **Execution:** Use /flow-execute with subagents. TDD required.

**Goal:** Add GET `/hello` returning `{ "message": "hello" }`
**Spec:** docs/flow/specs/2026-05-23-greeting.md
**Architecture:** Single route on existing HTTP server.

---

### Task 1: Hello endpoint

**Files:**
- Modify: `src/server.ts`
- Test: `tests/hello.test.ts`

- [ ] **Step 1: Write failing test**

```typescript
test('GET /hello returns greeting', async () => {
  const res = await request(app).get('/hello');
  expect(res.status).toBe(200);
  expect(res.body).toEqual({ message: 'hello' });
});
```

- [ ] **Step 2: Run test to verify fail**

Run: `npm test -- tests/hello.test.ts`
Expected: FAIL — route not found

- [ ] **Step 3: Implement minimal handler**

Register GET `/hello` returning `{ message: 'hello' }`.

- [ ] **Step 4: Run test to verify pass**

Run: `npm test -- tests/hello.test.ts`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add src/server.ts tests/hello.test.ts
git commit -m "feat: add hello endpoint"
```
