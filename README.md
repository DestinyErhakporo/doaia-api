# DOAIA API

Conceptual AI workflow orchestration API contract and developer documentation.

> **DOAIA is a fictional portfolio project.** There is no live API, no execution backend and no AI provider integration. The server URL (`https://api.example.com`), API keys and IDs are placeholders. Limits and retention periods are illustrative design assumptions.

Published docs: _add the Mintlify URL here after deployment._

## What it demonstrates

- An OpenAPI 3.1 contract with reusable schemas, bearer auth, cursor pagination, idempotency and a standard error envelope.
- A Mintlify documentation site with guides, concepts and a generated API reference.
- Automated pull-request checks for the contract and the docs.

## v1 scope

- Predefined (read-only) and custom workflows, with soft archive.
- Three sequential step types: `ai.generate`, `ai.summarize`, `data.transform`.
- Synchronous and asynchronous runs, status polling and results.
- Cancellation of queued or running runs and manual retry of failed runs.
- Account-wide and per-workflow run history.

Out of scope: webhooks, scheduling, automatic retries, parallel or conditional steps, arbitrary HTTP steps, billing and team administration.

## Stack

GitHub, OpenAPI 3.1, Mintlify, GitHub Actions, Redocly CLI.

## Repository layout

```text
doaia-api/
|-- openapi/openapi.yaml        # Canonical API contract (source of truth)
|-- docs.json                   # Mintlify site configuration and navigation
|-- docs/                       # Guides, concepts, reference pages
|-- snippets/                   # Reusable MDX snippets
|-- logo/, favicon.svg          # Branding (dark blue and white)
|-- redocly.yaml                # OpenAPI lint rules
|-- package.json                # Scripts for local checks
`-- .github/                    # CI workflow and PR template
```

The API reference pages are generated from `openapi/openapi.yaml`. Do not copy endpoint definitions into MDX.

## First-time setup

Requires Node.js 20.17 or later (22 recommended).

```bash
npm install --save-dev --save-exact @redocly/cli mint
git add package.json package-lock.json
```

This writes exact tool versions into `package.json` and creates `package-lock.json`. Commit both: CI runs `npm ci` and needs the lockfile to stay pinned.

## Validate locally

```bash
npm run lint:openapi      # Redocly lint of the OpenAPI file
npm run validate:docs     # Mintlify validation (pages, navigation, OpenAPI reference)
npm run check:links       # Internal link check
npx mint dev              # Local preview at http://localhost:3000
```

These checks validate the contract and the docs. They are not integration tests, because there is no backend to test against.

## Known limitations

- No running service, mock server or SDK.
- Contract behavior has been reviewed as design, not executed.
- Numeric rate limits are not specified.

## Contributing

Open an issue or pull request. Keep the OpenAPI file and the affected docs pages in the same change.
