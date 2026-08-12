# TradeQuotePro Monorepo Scaffold

This repository is a provider-neutral scaffold for three product concepts:

- TradeQuote Pro
- InkManager
- InvoiceFlow

The `apps/*` directories currently contain placeholders rather than runnable applications. No production deployment is configured or claimed. A deploy workflow should be added only after the selected app contains a real build, its runtime requirements are known, and the target connection has been independently verified.

## Select an app

```bash
./scripts/switch-app.sh tradequote
./scripts/switch-app.sh inkmanager
./scripts/switch-app.sh invoiceflow
```

The script updates the `active-app` symlink. Selection does not deploy or provision infrastructure.

## Database migrations

App-specific starter migrations live at:

- `packages/database/tradequote/01_schema.sql`
- `packages/database/inkmanager/01_schema.sql`
- `packages/database/invoiceflow/01_schema.sql`

Review and complete a migration before applying it to any database. When a verified Supabase project exists, an operator can apply a migration explicitly:

```bash
export APP=tradequote
export DATABASE_URL='postgresql://...'
supabase db execute --db-url "$DATABASE_URL" --file "packages/database/$APP/01_schema.sql"
```

Do not store credentials in this repository.

## Scaffold verification

`.github/workflows/scaffold-check.yml` verifies that:

- each supported app directory exists;
- each starter migration exists;
- app selection works for all three names;
- shell scripts pass syntax checks; and
- no placeholder deployment workflow is treated as a production path.

Run the same checks locally:

```bash
bash -n scripts/switch-app.sh switch-app.sh
for app in tradequote inkmanager invoiceflow; do
  ./scripts/switch-app.sh "$app"
  test "$(readlink active-app)" = "apps/$app"
done
rm -f active-app
```

## Activation gate

Before enabling deployment for any app, add and verify at minimum:

1. a real application and lockfile under `apps/<app>/`;
2. deterministic build and test commands;
3. completed database migrations and rollback instructions;
4. documented runtime and secret names;
5. an authenticated target environment; and
6. a smoke test that proves the deployed artifact matches the reviewed commit.

Until those gates exist, this repository remains a scaffold and must fail closed rather than advertise an unavailable deployment.
