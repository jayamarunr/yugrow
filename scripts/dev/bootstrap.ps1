<#
.SYNOPSIS
    Yugrow Developer Bootstrap — wrapper for TypeScript orchestrator.
.DESCRIPTION
    This script delegates to the TypeScript bootstrap orchestrator.
    Supports all platforms through a single Node.js entry point.
#>

param(
    [switch]$SkipDocker,
    [switch]$SkipFlutter,
    [switch]$SkipApi,
    [switch]$SkipWeb,
    [switch]$VerifyOnly
)

$ROOT = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$BOOTSTRAP_TS = Join-Path $ROOT "scripts\bootstrap\bootstrap.ts"

# Build args
$args = @()
if ($SkipDocker) { $args += "--skip-docker" }
if ($VerifyOnly) { $args += "--verify-only" }

Write-Host "╔══════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║     Yugrow Bootstrap v1.1                       ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Delegate to TypeScript orchestrator
node -e "
const { execSync } = require('child_process');
try {
  execSync('npx tsx $BOOTSTRAP_TS $args', { stdio: 'inherit', cwd: '$ROOT', shell: true });
} catch(e) {
  process.exit(e.status || 1);
}
"

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n  ✅ Bootstrap complete. See DEV-STATUS.md for details." -ForegroundColor Green
} else {
    Write-Host "`n  ❌ Bootstrap failed. Check DEV-STATUS.md and logs/bootstrap/ for details." -ForegroundColor Red
}

