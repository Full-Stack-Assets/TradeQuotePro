# TradeQuotePro Monorepo Starter

One-click deploy scaffold for:
- TradeQuote Pro
- InkManager
- InvoiceFlow

This repo is a scaffold: the `apps/*` folders are placeholders. To deploy successfully, each app you deploy must contain a real Next.js project (at minimum `apps/<app>/package.json`).

## Deployment model

This repository uses a **multi-app, per-environment deployment model**:
- App selector: `tradequote`, `inkmanager`, `invoiceflow`
- Environment selector: `dev`, `staging`, `prod`
- CI creates an `active-app` symlink with `./scripts/switch-app.sh <app>` before install/build/deploy
- `push` to `main` deploys defaults (`tradequote`, `prod`)
- `workflow_dispatch` supports explicit app/environment selection

## Prerequisites

```bash
npm install -g vercel
brew install supabase/tap/supabase
# or: curl -fsSL https://supabase.com/install.sh | sh
```

## One-time setup

```bash
git clone https://github.com/Full-Stack-Assets/TradeQuotePro.git tradequote-pro
cd tradequote-pro

export STRIPE_SECRET_KEY=sk_test_...
export NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_...
export SUPABASE_PROJECT_REF=your_supabase_ref
export DATABASE_URL=postgresql://postgres:[password]@db.your-project.supabase.co:5432/postgres
export NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
export NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key
export STRIPE_WEBHOOK_SECRET=whsec_...
```

## Deploy any app

```bash
./scripts/switch-app.sh tradequote && ./scripts/deploy.sh
./scripts/switch-app.sh inkmanager && ./scripts/deploy.sh
./scripts/switch-app.sh invoiceflow && ./scripts/deploy.sh
```

If you prefer, you can also deploy by setting `APP` directly (this also updates `./active-app` automatically):

```bash
APP=tradequote ./scripts/deploy.sh
```

Run DB migrations only when needed:

```bash
RUN_DB_MIGRATIONS=true ./scripts/deploy.sh
```

## Duplicate this repo for a specific app (one command)

```bash
git clone https://github.com/Full-Stack-Assets/TradeQuotePro.git my-app \
  && cd my-app \
  && ./scripts/switch-app.sh tradequote
```

## Migration files

- `/packages/database/tradequote/01_schema.sql`
- `/packages/database/inkmanager/01_schema.sql`
- `/packages/database/invoiceflow/01_schema.sql`

Apply app-specific migration file:

```bash
supabase db execute --db-url "$DATABASE_URL" --file "packages/database/$APP/01_schema.sql"
```

## CI/CD

GitHub Actions workflows are available at:

- `/.github/workflows/deploy.yml` (Vercel)
- `/.github/workflows/google-cloudrun-source.yml` (Cloud Run)

### Required GitHub secrets

Global:
- `VERCEL_TOKEN`
- `VERCEL_ORG_ID`
- `NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY`
- `GCP_PROJECT_ID`
- `GCP_REGION`
- `GCP_CLOUD_RUN_SERVICE`
- `GCP_WORKLOAD_IDENTITY_PROVIDER`
- `GCP_SERVICE_ACCOUNT_EMAIL`

Per app + environment Vercel project IDs:
- `VERCEL_PROJECT_ID_TRADEQUOTE_DEV`
- `VERCEL_PROJECT_ID_TRADEQUOTE_STAGING`
- `VERCEL_PROJECT_ID_TRADEQUOTE_PROD`
- `VERCEL_PROJECT_ID_INKMANAGER_DEV`
- `VERCEL_PROJECT_ID_INKMANAGER_STAGING`
- `VERCEL_PROJECT_ID_INKMANAGER_PROD`
- `VERCEL_PROJECT_ID_INVOICEFLOW_DEV`
- `VERCEL_PROJECT_ID_INVOICEFLOW_STAGING`
- `VERCEL_PROJECT_ID_INVOICEFLOW_PROD`

Per environment application secrets:
- `NEXT_PUBLIC_SUPABASE_URL_DEV`, `NEXT_PUBLIC_SUPABASE_URL_STAGING`, `NEXT_PUBLIC_SUPABASE_URL_PROD`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY_DEV`, `NEXT_PUBLIC_SUPABASE_ANON_KEY_STAGING`, `NEXT_PUBLIC_SUPABASE_ANON_KEY_PROD`
- `STRIPE_SECRET_KEY_DEV`, `STRIPE_SECRET_KEY_STAGING`, `STRIPE_SECRET_KEY_PROD`
- `STRIPE_WEBHOOK_SECRET_DEV`, `STRIPE_WEBHOOK_SECRET_STAGING`, `STRIPE_WEBHOOK_SECRET_PROD`

### Branch/environment paths

- `main` push => `tradequote` to `prod`
- Manual dispatch => selected app to selected environment (`dev`/`staging`/`prod`)
