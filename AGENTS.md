Trang cần clone: https://2gold.biz
Tài khoản: MF / Mf566186

## graphify

This project has a knowledge graph at graphify-out/ with god nodes, community structure, and cross-file relationships.

When the user types `/graphify`, use the installed graphify skill or instructions before doing anything else.

Rules:
- When graphify-out/graph.json exists, run `graphify query "<question>"` before your first grep, search or source-file read for a codebase question, and put this rule in every subagent prompt that explores code. Read raw files only for lines the graph or an earlier read already located. Use `graphify path "<A>" "<B>"` for relationships and `graphify explain "<concept>"` for focused concepts. These return a scoped subgraph, usually much smaller than GRAPH_REPORT.md or raw grep output.
- Dirty graphify-out/ files are expected after hooks or incremental updates; dirty graph files are not a reason to skip graphify. Only skip graphify if the task is about stale or incorrect graph output, or the user explicitly says not to use it.
- If graphify-out/wiki/index.md exists, use it for broad navigation instead of raw source browsing.
- Read graphify-out/GRAPH_REPORT.md only for broad architecture review or when query/path/explain do not surface enough context.
- After modifying code, run `graphify update .` to keep the graph current (AST-only, no API cost).
- A committed graphify-out/graph.json is rewritten whole on every build, so a large diff to it in a pull request is expected. Do not flag it as churn or suggest skipping the graph rebuild or its hooks.

## Frontend styling

- Build and update frontend UI with Tailwind CSS utility classes in Vue templates.
- Do not add component or layout styling rules to `frontend/src/style.css`; reserve it for Tailwind/DaisyUI imports, theme configuration, font imports, and design tokens that utilities reference.
- Prefer standard Tailwind utilities, and use arbitrary utility values when needed to preserve the established design precisely.
- Preserve existing component dimensions, spacing, and typography unless the user explicitly requests a visual change.


## Vue form validation

- Use `vee-validate` 4.15.1 with `@vee-validate/zod` 4.15.1 and `zod` 3.25.76 for Vue form validation. Keep these exact versions pinned in `frontend/package.json` and `pnpm-lock.yaml`.
- Add `novalidate` when vee-validate owns a form's client-side validation, and render accessible field errors in the Vue template.
- Keep server-side validation authoritative; client validation is for immediate user feedback.
