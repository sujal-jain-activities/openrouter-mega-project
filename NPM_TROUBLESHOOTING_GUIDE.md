# Node.js Troubleshooting & Installation Guide (Windows)

Saved this guide as a reference for resolving common installation issues (`EACCES`, `EPERM`, `node_modules` conflicts) in any Node.js project.

## 🛠️ The "Nuclear" Reset Command
Run this in **PowerShell (Run as Administrator)** to completely reset your environment and reinstall:

```powershell
# Delete node_modules and lock files, clean cache, and reinstall
rm -Force -Recurse node_modules; rm -Force bun.lock, package-lock.json; npm cache clean --force; npm install
```

---

## 📋 Step-by-Step Breakdown

### 1. Identify the Right Package Manager
Before running commands, check which file exists in the project root:
- `package-lock.json` → Use **NPM** (`npm install`)
- `yarn.lock` → Use **Yarn** (`yarn install`)
- `pnpm-lock.yaml` → Use **PNPM** (`pnpm install`)
- `bun.lock / bun.lockb` → Use **Bun** (`bun install`)

### 2. Resolution Levels

#### Level 1: Simple Reinstall (Try this first)
Recommended if you just suspect a single corrupt package.
```powershell
rm -Force -Recurse node_modules
npm install
```

#### Level 2: Clean slate with cache refresh
Recommended for `EACCES` or "permission denied" errors.
```powershell
rm -Force -Recurse node_modules
npm cache clean --force
npm install
```

#### Level 3: Full Reset (The "Nuclear" option)
Only use this if Level 1 & 2 fail, or if you have major version conflicts.
```powershell
rm -Force -Recurse node_modules
rm -Force package-lock.json  # WARNING: This updates all package versions to the latest allowed
npm cache clean --force
npm install
```

---

## 💡 Pro-Tips to Avoid Errors
- **Run as Administrator**: Right-click your Terminal/PowerShell and select "Run as Administrator". This prevents 90% of `EACCES` errors on Windows.
- **Close Editor/Dev Servers**: Ensure VS Code, a running `npm run dev` server, or your antivirus isn't "locking" the `node_modules` folder while you install.
- **Node Version**: If a project fails to build, check if you have the correct Node version installed (`node -v`). Many projects specify a version in `package.json` under `"engines"`.
