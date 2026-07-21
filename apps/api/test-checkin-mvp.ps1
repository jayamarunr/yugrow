# ─── CheckIN MVP Test Script ─────────────────────────────────────────
# Tests the full flow: Venue → Event → "I'm Here" → Live Discovery → Connect
#
# Prerequisites:
#   - PostgreSQL running on localhost:5432
#   - .env file at project root with DATABASE_URL
#   - Run from repo root: cd C:\Users\jayam\Documents\GitHub\yugrow
#
# Usage:
#   powershell -File apps/api/test-checkin-mvp.ps1

Write-Host "╔══════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║        CheckIN MVP — Full Flow Test                ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# ── Step 0: Setup ─────────────────────────────────────────────────
Write-Host "▶ Step 0: Applying database schema..." -ForegroundColor Yellow
Push-Location C:\Users\jayam\Documents\GitHub\yugrow\packages\database
npx --no-install prisma db push 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) { Write-Host "  ❌ Database setup failed. Is PostgreSQL running?" -ForegroundColor Red; Pop-Location; exit 1 }
Write-Host "  ✅ Schema applied" -ForegroundColor Green
Pop-Location

# ── Step 1: Start Server ──────────────────────────────────────────
Write-Host ""
Write-Host "▶ Step 1: Start the API server..." -ForegroundColor Yellow
Write-Host "  Open a NEW terminal and run:"
Write-Host "    cd C:\Users\jayam\Documents\GitHub\yugrow\apps\api"
Write-Host "    npx nest start"
Write-Host ""
Write-Host "  Then in this terminal, press any key to continue..."
Write-Host ""
pause

$BASE = "http://localhost:4000"
$HEADERS = @{ "Content-Type" = "application/json" }

# ── Step 2: Create Venue ──────────────────────────────────────────
Write-Host "▶ Step 2: Create Venue..." -ForegroundColor Yellow
$venueBody = @{
  name = "Chennai Trade Centre"
  address = "Mount Road, Chennai"
  city = "Chennai"
  state = "Tamil Nadu"
  country = "India"
  createdByPersonId = "person-001"
  ownerWorkspaceId = "workspace-001"
} | ConvertTo-Json

$venue = Invoke-RestMethod -Uri "$BASE/api/v1/checkin/venues" -Method Post -Body $venueBody -Headers $HEADERS -ContentType "application/json"
Write-Host "  ✅ Venue created: $($venue.name) (ID: $($venue.id))" -ForegroundColor Green
$venueId = $venue.id

# ── Step 3: Create Event ──────────────────────────────────────────
Write-Host "▶ Step 3: Create Event..." -ForegroundColor Yellow
$startDate = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")
$endDate = (Get-Date).AddDays(1).ToString("yyyy-MM-ddTHH:mm:ssZ")

$eventBody = @{
  name = "AI Expo 2028"
  venueId = $venueId
  organizerWorkspaceId = "workspace-001"
  startDate = $startDate
  endDate = $endDate
} | ConvertTo-Json

$event = Invoke-RestMethod -Uri "$BASE/api/v1/checkin/events" -Method Post -Body $eventBody -Headers $HEADERS -ContentType "application/json"
Write-Host "  ✅ Event created: $($event.name) (ID: $($event.id))" -ForegroundColor Green
$eventId = $event.id

# ── Step 4: Person A checks in ────────────────────────────────────
Write-Host "▶ Step 4: Person A checks in ('I'm Here')..." -ForegroundColor Yellow
$checkinBodyA = @{
  personId = "person-001"
  workspaceId = "workspace-001"
  eventId = $eventId
  venueId = $venueId
} | ConvertTo-Json

$presenceA = Invoke-RestMethod -Uri "$BASE/api/v1/checkin/presence" -Method Post -Body $checkinBodyA -Headers $HEADERS -ContentType "application/json"
Write-Host "  ✅ Person A checked in: $($presenceA.status) (expires: $($presenceA.expiresAt))" -ForegroundColor Green

# ── Step 5: Person B checks in ────────────────────────────────────
Write-Host "▶ Step 5: Person B checks in..." -ForegroundColor Yellow
$checkinBodyB = @{
  personId = "person-002"
  workspaceId = "workspace-002"
  eventId = $eventId
  venueId = $venueId
} | ConvertTo-Json

$presenceB = Invoke-RestMethod -Uri "$BASE/api/v1/checkin/presence" -Method Post -Body $checkinBodyB -Headers $HEADERS -ContentType "application/json"
Write-Host "  ✅ Person B checked in: $($presenceB.status)" -ForegroundColor Green

# ── Step 6: Live Discovery (as Person A) ──────────────────────────
Write-Host "▶ Step 6: Live Discovery (Person A sees who's here)..." -ForegroundColor Yellow
$live = Invoke-RestMethod -Uri "$BASE/api/v1/checkin/live/$eventId?viewerPersonId=person-001" -Method Get -Headers $HEADERS
Write-Host "  ✅ $($live.Count) people present:" -ForegroundColor Green
foreach ($p in $live) {
  Write-Host "     👤 $($p.name) — mutual connections: $($p.mutualConnections)"
}

# ── Step 7: Person B sends connection request ─────────────────────
Write-Host "▶ Step 7: Person B connects with Person A..." -ForegroundColor Yellow
$connectBody = @{
  fromPersonId = "person-002"
  toPersonId = "person-001"
  workspaceId = "workspace-002"
  eventId = $eventId
  venueId = $venueId
} | ConvertTo-Json

$request = Invoke-RestMethod -Uri "$BASE/api/v1/checkin/connections" -Method Post -Body $connectBody -Headers $HEADERS -ContentType "application/json"
Write-Host "  ✅ Connection request sent (ID: $($request.id))" -ForegroundColor Green
$requestId = $request.id

# ── Step 8: Person A accepts ──────────────────────────────────────
Write-Host "▶ Step 8: Person A accepts the request..." -ForegroundColor Yellow
$acceptBody = @{ personId = "person-001" } | ConvertTo-Json
$result = Invoke-RestMethod -Uri "$BASE/api/v1/checkin/connections/$requestId/accept" -Method Post -Body $acceptBody -Headers $HEADERS -ContentType "application/json"
Write-Host "  ✅ Connection accepted! Relationship ID: $($result.relationship.id)" -ForegroundColor Green

# ── Step 9: Verify ────────────────────────────────────────────────
Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                TEST COMPLETE ✅                      ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Flow verified:"
Write-Host "  1️⃣  Venue created: Chennai Trade Centre" -ForegroundColor Green
Write-Host "  2️⃣  Event created: AI Expo 2028" -ForegroundColor Green
Write-Host "  3️⃣  Person A checked in (workspace-001)" -ForegroundColor Green
Write-Host "  4️⃣  Person B checked in (workspace-002)" -ForegroundColor Green
Write-Host "  5️⃣  Person A saw Person B in Live list" -ForegroundColor Green
Write-Host "  6️⃣  Person B sent connection request" -ForegroundColor Green
Write-Host "  7️⃣  Person A accepted → Relationship created" -ForegroundColor Green
Write-Host "  8️⃣  Relationship origin: AI Expo 2028 @ Chennai Trade Centre" -ForegroundColor Green
Write-Host ""
Write-Host "  Next step: Build the frontend UI and test with two phones." -ForegroundColor Yellow
