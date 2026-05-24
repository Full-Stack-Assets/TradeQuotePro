#!/bin/bash

# ------------------------------
# One-click deploy for active app (Next.js + Supabase + Stripe)
# ------------------------------

set -euo pipefail

echo "🚀 Starting deployment..."

# Precedence: APP > ACTIVE_APP > default tradequote
APP="${APP:-${ACTIVE_APP:-tradequote}}"
MIGRATION_FILE="packages/database/$APP/01_schema.sql"

case "$APP" in
  tradequote|inkmanager|invoiceflow) ;;
  *)
    echo "❌ Unsupported APP value: $APP"
    echo "Allowed values: tradequote, inkmanager, invoiceflow"
    exit 1
    ;;
esac

# 1. Check environment variables
required_vars=(
  STRIPE_SECRET_KEY
  NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY
  SUPABASE_PROJECT_REF
  DATABASE_URL
  NEXT_PUBLIC_SUPABASE_URL
  NEXT_PUBLIC_SUPABASE_ANON_KEY
  STRIPE_WEBHOOK_SECRET
)

for var_name in "${required_vars[@]}"; do
  if [ -z "${!var_name:-}" ]; then
    echo "❌ Please set $var_name environment variable"
    exit 1
  fi
done

# 2. Initialize Supabase (if not already)
if [ ! -d "supabase" ]; then
  echo "📁 Initializing Supabase project..."
  supabase init
fi

# 3. Link to remote Supabase project
echo "🔗 Linking to Supabase project..."
supabase link --project-ref "$SUPABASE_PROJECT_REF"

# 4. Run migrations
if [ -f "$MIGRATION_FILE" ]; then
  echo "📦 Running database migrations for $APP..."
  supabase db execute --db-url "$DATABASE_URL" --file "$MIGRATION_FILE"
else
  echo "❌ Migration file not found: $MIGRATION_FILE"
  exit 1
fi

# 5. Set environment variables in Supabase
echo "🔐 Setting Supabase secrets..."
supabase secrets set \
  STRIPE_SECRET_KEY="$STRIPE_SECRET_KEY" \
  NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY="$NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY"

# 6. Deploy to Vercel
echo "🌐 Deploying to Vercel..."
vercel --prod \
  --env NEXT_PUBLIC_SUPABASE_URL="$NEXT_PUBLIC_SUPABASE_URL" \
  --env NEXT_PUBLIC_SUPABASE_ANON_KEY="$NEXT_PUBLIC_SUPABASE_ANON_KEY" \
  --env STRIPE_SECRET_KEY="$STRIPE_SECRET_KEY" \
  --env NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY="$NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY" \
  --env STRIPE_WEBHOOK_SECRET="$STRIPE_WEBHOOK_SECRET"

echo "✅ Deployment complete! Your site is live."
