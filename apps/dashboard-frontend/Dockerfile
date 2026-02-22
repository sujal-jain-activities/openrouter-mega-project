# ─── Stage 1: Install dependencies ───────────────────────────────────────────
FROM oven/bun:1.3.3-alpine AS deps

WORKDIR /app

COPY package.json package-lock.json ./

COPY packages/db/package.json                      ./packages/db/
COPY packages/eslint-config/package.json           ./packages/eslint-config/
COPY packages/typescript-config/package.json       ./packages/typescript-config/
COPY packages/ui/package.json                      ./packages/ui/
COPY apps/dashboard-frontend/package.json          ./apps/dashboard-frontend/
COPY apps/primary-backend/package.json             ./apps/primary-backend/

RUN bun install

# ─── Stage 2: Build the frontend bundle ──────────────────────────────────────
FROM oven/bun:1.3.3-alpine AS builder

WORKDIR /app

# Copy node_modules and manifests from deps
COPY --from=deps /app/ ./

# Overlay source code
COPY packages/ui/                  ./packages/ui/
COPY packages/db/                  ./packages/db/
COPY packages/typescript-config/   ./packages/typescript-config/
COPY packages/eslint-config/       ./packages/eslint-config/
COPY apps/primary-backend/src/app.ts ./apps/primary-backend/src/app.ts
COPY apps/dashboard-frontend/      ./apps/dashboard-frontend/

WORKDIR /app/apps/dashboard-frontend

RUN bun run build

# ─── Stage 3: Production runner ───────────────────────────────────────────────
FROM oven/bun:1.3.3-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/packages     ./packages
COPY --from=builder /app/apps         ./apps
COPY --from=builder /app/package.json ./

WORKDIR /app/apps/dashboard-frontend

EXPOSE 3001

CMD ["bun", "src/index.ts"]
