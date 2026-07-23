# Yugrow Local Testing Guide

## Prerequisites

- Node.js >= 22
- pnpm
- Flutter SDK
- PostgreSQL (or skip — app works with empty DB for UI testing)

---

## Quick Start (Full Stack)

### Terminal 1 — API

```bash
cd apps/api
pnpm run build
pnpm run start
```

API runs at `http://localhost:4000`
Swagger docs at `http://localhost:4000/api/docs`

### Terminal 2 — Flutter Web

```bash
cd apps/mobile
flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0
```

Flutter Web runs at `http://0.0.0.0:8080`

---

## Testing From Another Device (Phone)

1. Find your machine's local IP:
   ```bash
   ipconfig
   ```
   or
   ```bash
   (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -notlike "*Loopback*"}).IPAddress
   ```

2. Start the Flutter web server as above.

3. On your phone (same Wi-Fi), open:
   ```
   http://<YOUR_IP>:8080
   ```

4. Configure the API URL by running Flutter with a custom API endpoint:
   ```bash
   flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0 \
     --dart-define=API_BASE_URL=http://<YOUR_IP>:4000
   ```

   This overrides the API URL without modifying source code.

---

## Environment Configuration

| Flag | Default | Description |
|------|---------|-------------|
| `--dart-define=API_BASE_URL=http://...` | `http://localhost:4000` | API server URL |

Source: `lib/core/config/environment.dart`

---

## Debug Screen

Long-press the **Yugrow "Y" logo** in the app bar to open the debug screen. Shows:
- App version and build number
- API URL
- Last API call status
- Test action buttons (alpha)

Only available in debug builds. Removed before production.

---

## Known API Limitations

| Issue | Impact |
|-------|--------|
| Route prefix mismatch — some endpoints at `/api/v1/api/v1/...` instead of `/api/v1/...` | Checkin endpoints are correct (`/api/v1/checkin/...`). Other engines have wrong prefix. |
| No database = empty API responses | The app shows empty states gracefully. To seed data, you need a running PostgreSQL. |
| Auth stubs — login/refresh throw "Not yet implemented" | Registration works; login does not. For demo, the app works without real auth. |
