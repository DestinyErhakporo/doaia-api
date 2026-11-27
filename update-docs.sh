#!/usr/bin/env bash
# DOAIA docs update: adds the style guide, "How these docs are built", the technical
# sheet and solution brief (PDF), and aligns existing pages with the style guide.
# Run from the ROOT of your cloned doaia-api repo.
set -euo pipefail
[ -d .git ] && [ -f docs.json ] && [ -f openapi/openapi.yaml ] || { echo "Run this from the root of the doaia-api repo." >&2; exit 1; }

# 1. Check every edit can be applied BEFORE writing anything.
cat > /tmp/apply_edits.py <<'PYEOF'
import sys, pathlib

edits = {
  "docs/introduction.mdx": [
    ("- Teams evaluating how workflow execution and observability could be exposed over REST.",
     "- Teams evaluating how running workflows and tracking runs could be exposed over REST."),
    ("    All 12 endpoints, generated from the OpenAPI contract.\n  </Card>\n</Columns>\n",
     "    All 12 endpoints, generated from the OpenAPI contract.\n  </Card>\n</Columns>\n\n"
     "## About this project\n\n"
     "For a one-page summary, read the [technical sheet and solution brief](/docs/project-brief). "
     "To see how these docs are produced and kept consistent, read [How these docs are built](/docs/how-these-docs-are-built) "
     "and the [style guide](/docs/style-guide).\n"),
  ],
  "docs/concepts/runs-and-states.mdx": [
    ("| `running` | Execution is in progress. | No |", "| `running` | The run is in progress. | No |"),
    ("| `failed` | A step or the execution failed. | Yes |", "| `failed` | A step or the run failed. | Yes |"),
  ],
  "docs/concepts/workflow-steps.mdx": [
    ("## Execution order", "## Step order"),
  ],
  "docs/reference/limits-and-retention.mdx": [
    ("| Execution duration | 10 minutes |", "| Run duration | 10 minutes |"),
    ("A run that exceeds the execution duration", "A run that exceeds the run duration"),
  ],
  "docs/api-reference/overview.mdx": [
    ("| List execution history |", "| List run history |"),
  ],
  "openapi/openapi.yaml": [
    ("Start, monitor, cancel, retry and inspect workflow executions.", "Start, monitor, cancel, retry and inspect workflow runs."),
    ("summary: List execution history", "summary: List run history"),
  ],
  "docs.json": [
    ('          "docs/reference/versioning"\n        ]\n      }\n    ]',
     '          "docs/reference/versioning"\n        ]\n      },\n      {\n        "group": "About this project",\n        "pages": [\n'
     '          "docs/project-brief",\n          "docs/how-these-docs-are-built",\n          "docs/style-guide"\n        ]\n      }\n    ]'),
  ],
  "README.md": [
    ("## What it demonstrates",
     "## Project documents\n\n"
     "- [Technical sheet and solution brief (PDF)](assets/DOAIA-Technical-Sheet-and-Solution-Brief.pdf)\n"
     "- [How these docs are built](docs/how-these-docs-are-built.mdx)\n"
     "- [Style guide and terminology](docs/style-guide.mdx)\n\n"
     "## What it demonstrates"),
    ("|-- snippets/                   # Reusable MDX snippets",
     "|-- snippets/                   # Reusable MDX snippets\n|-- assets/                     # Downloadable PDF: technical sheet and solution brief"),
  ],
}

root = pathlib.Path(".")
problems, texts = [], {}
for f, pairs in edits.items():
    p = root / f
    if not p.exists():
        problems.append(f"missing file: {f}"); continue
    t = p.read_text(encoding="utf-8")
    for old, new in pairs:
        if t.count(old) != 1:
            problems.append(f"{f}: expected exactly one match for: {old[:60]!r} (found {t.count(old)})")
        else:
            t = t.replace(old, new)
    texts[f] = t
if problems:
    print("NOTHING CHANGED. Problems:"); [print(" -", x) for x in problems]; sys.exit(1)
for f, t in texts.items():
    (root / f).write_text(t, encoding="utf-8"); print("edited", f)
PYEOF
echo "Applying edits to existing files..."
python3 /tmp/apply_edits.py

# 2. Unpack the new files.
echo "Adding new files..."
base64 -d <<'DOAIA_PAYLOAD' | tar xz
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
eAAA
DOAIA_PAYLOAD

rm -f /tmp/apply_edits.py -- "$0"
echo "Done. Next: npm run check"
