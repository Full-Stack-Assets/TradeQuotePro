# TradeQuotePro Monorepo Starter

One-click deploy scaffold for:
- TradeQuote Pro
- InkManager
- InvoiceFlow

## Prerequisites

```bash
npm install -g vercel
brew install supabase/tap/supabase
# or: curl -fsSL https://supabase.com/install.sh | sh
```

## One-time setup

```bash
git clone https://github.com/your-username/microsaas-starter.git tradequote-pro
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
./scripts/switch-app.sh tradequote && APP=tradequote ./scripts/deploy.sh
./scripts/switch-app.sh inkmanager && APP=inkmanager ./scripts/deploy.sh
./scripts/switch-app.sh invoiceflow && APP=invoiceflow ./scripts/deploy.sh
```

## Duplicate this repo for a specific app (one command)

```bash
git clone https://github.com/your-username/microsaas-starter.git my-app \
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

GitHub Actions workflow is available at:

- `/.github/workflows/deploy.yml`

Required GitHub secrets:

- `VERCEL_TOKEN`
- `VERCEL_ORG_ID`
- `VERCEL_PROJECT_ID`
- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- `STRIPE_SECRET_KEY`
- `STRIPE_WEBHOOK_SECRET`
