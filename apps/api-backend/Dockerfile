# ─── Stage 1: Install dependencies ───────────────────────────────────────────
FROM oven/bun:1.3.3-alpine AS deps

WORKDIR /app

COPY package.json package-lock.json ./

COPY packages/db/package.json                      ./packages/db/
COPY packages/eslint-config/package.json           ./packages/eslint-config/
COPY packages/typescript-config/package.json       ./packages/typescript-config/
COPY packages/ui/package.json                      ./packages/ui/
COPY apps/api-backend/package.json                 ./apps/api-backend/

RUN bun install

# ─── Stage 2: Generate Prisma client ─────────────────────────────────────────
FROM oven/bun:1.3.3-alpine AS builder

WORKDIR /app

# Copy node_modules and manifests from deps
COPY --from=deps /app/ ./

# Overlay source code
COPY packages/db/                  ./packages/db/
COPY packages/typescript-config/   ./packages/typescript-config/
COPY apps/api-backend/             ./apps/api-backend/

# Generate Prisma client
RUN cd packages/db && bunx prisma generate --schema=prisma/schema.prisma

# ─── Stage 3: Production runner ───────────────────────────────────────────────
FROM oven/bun:1.3.3-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/packages     ./packages
COPY --from=builder /app/apps         ./apps
COPY --from=builder /app/package.json ./

WORKDIR /app/apps/api-backend

EXPOSE 4000

CMD ["bun", "run", "src/index.ts"]
