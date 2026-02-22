# ─── Stage 1: Install dependencies ───────────────────────────────────────────
FROM oven/bun:1.3.3-alpine AS deps

WORKDIR /app

# Copy root workspace manifests + lockfile
COPY package.json package-lock.json ./

# Copy ALL package manifests so Bun can resolve the full workspace graph
COPY packages/db/package.json                      ./packages/db/
COPY packages/eslint-config/package.json           ./packages/eslint-config/
COPY packages/typescript-config/package.json       ./packages/typescript-config/
COPY packages/ui/package.json                      ./packages/ui/
COPY apps/primary-backend/package.json             ./apps/primary-backend/

# Install ALL workspace deps (hoisted to root node_modules)
RUN bun install

# ─── Stage 2: Generate Prisma client ─────────────────────────────────────────
FROM oven/bun:1.3.3-alpine AS builder

WORKDIR /app

# Copy everything from deps (gets all root and package node_modules + package.jsons)
COPY --from=deps /app/ ./

# Overlay source code
COPY packages/db/           ./packages/db/
COPY packages/typescript-config/ ./packages/typescript-config/
COPY apps/primary-backend/  ./apps/primary-backend/

# Generate Prisma client
RUN cd packages/db && bunx prisma generate --schema=prisma/schema.prisma

# ─── Stage 3: Production runner ───────────────────────────────────────────────
FROM oven/bun:1.3.3-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production

# Copy built artifacts and modules from builder
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/packages     ./packages
COPY --from=builder /app/apps         ./apps
COPY --from=builder /app/package.json ./

WORKDIR /app/apps/primary-backend

EXPOSE 3000

# Run migrations from within the db package so it finds prisma.config.ts, then start the server
CMD ["sh", "-c", "cd ../../packages/db && bunx prisma migrate deploy && cd ../../apps/primary-backend && bun run src/index.ts"]
