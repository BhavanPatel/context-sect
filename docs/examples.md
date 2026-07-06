# Examples

## Alignment Gate in Action

**Your prompt:** "refactor the auth module"

**Without ContextSect:** Agent reads 12 files, implements session-based refactor. You wanted JWT migration. 15,000 tokens wasted.

**With ContextSect:**
```
Objective: Extract token validation into standalone middleware, removing duplication.

Path:
1. Create src/middleware/auth-validator.ts
2. Update src/routes/users.ts — replace inline validation
3. Update src/routes/admin.ts — same
4. Update src/routes/api.ts — same

Check: Should this maintain session-based auth, or migrate to stateless JWT?

→ "Go" to proceed, or answer the question.
```
**Cost:** 100 tokens. **Prevented:** 15,000 tokens wrong direction.

---

## Output Contract — Before/After

**Without ContextSect (1,200 tokens):**
```
Sure! I'd be happy to help you with that bug. Let me take a look at the code.

After examining the auth middleware, I can see that the issue is in the token
expiry check. The problem is that you're using `<` instead of `<=`...

Here's the updated file:
[entire 200-line file]

In summary, the fix was changing < to <=. Let me know if you need anything else!
```

**With ContextSect (80 tokens):**
```
Bug: token expiry uses `<` not `<=`. Tokens at exact current timestamp pass validation.

File: src/middleware/auth.ts

<<<<<<< SEARCH
if (decoded.exp < Date.now() / 1000) {
=======
if (decoded.exp <= Date.now() / 1000) {
>>>>>>> REPLACE
```

**93% reduction. Same fix. Same accuracy.**

---

## Search-First — Token Impact

```
WITHOUT search-first:
  Read auth.ts (450 lines)     → 1,800 tokens
  Read user.ts (380 lines)     → 1,520 tokens  
  Read session.ts (200 lines)  → 800 tokens
  Total: 4,120 tokens (needed only 60 lines)

WITH search-first:
  Symbol lookup "validateToken" → line 145-167
  Read auth.ts:140-170         → 120 tokens
  Grep "refreshSession"        → line 89-102
  Read session.ts:84-107       → 92 tokens
  Total: 212 tokens (95% reduction)
```
