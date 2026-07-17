# Tool Selection

## Purpose
Prevent MCP schema bloat and wasted tool calls. Every registered MCP tool adds its full JSON schema to the system prompt — 50 tools × 200 tokens each = 10,000 tokens of fixed overhead per turn. Smart tool selection reduces both the schema tax and wasted exploratory calls.

## Rules

1. Prefer the most specific tool available:
   - File read tool over `cat` in shell
   - Symbol lookup over grep for function definitions
   - Dedicated search over generic `find` commands
   - Project-specific tools over generic equivalents

2. Before calling a tool, verify it's necessary:
   - Will this tool call produce information I don't already have?
   - Is there a simpler way to get the same answer?
   - Can I combine multiple needs into one call?

3. Batch when possible:
   - Read multiple related files in one call (if tool supports it)
   - Combine grep patterns: `pattern1|pattern2` over two separate searches
   - Use directory listing before individual file reads

4. Avoid tool thrashing:
   - Don't alternate between read → search → read → search on the same area
   - Gather what you need, then act
   - One targeted search + one targeted read > five exploratory reads

## MCP Schema Hygiene

When multiple MCP servers are configured:
- Use only tools relevant to the current task
- Don't invoke discovery/list tools unless you need to find something specific
- Prefer tools that return structured data over raw text dumps
- If a tool returns paginated results, request only the page you need

## Tool Call Budget Per Task

| Task complexity | Tool call budget |
|----------------|-----------------|
| Simple question | 1-3 calls |
| Single file fix | 3-5 calls |
| Multi-file change | 8-15 calls |
| Investigation | 5-10 calls |
| Large feature | 15-25 calls |

If exceeding budget without progress, stop and reassess approach.

## Anti-Patterns
- Calling the same tool with slightly different args hoping for better results
- Using shell commands when dedicated tools exist (cat vs read, grep vs search)
- Loading all MCP tool schemas when only one server is needed
- Making exploratory tool calls "just to see what's there"
