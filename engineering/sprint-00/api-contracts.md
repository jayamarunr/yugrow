---
Sprint: 0
Title: API Contracts
Owner: Backend Architect
---

# Sprint 0 — API Contracts

> Sprint 0 focuses on infrastructure and foundation. No business APIs yet.
> The only endpoint required is the health check.

## Health Check

```
GET /api/health
```

**Response 200:**
```json
{
  "status": "ok",
  "timestamp": "2026-07-16T00:00:00Z",
  "services": {
    "database": "connected",
    "redis": "connected",
    "storage": "connected"
  }
}
```

## API Standards (Established for Sprint 1+)

### Base URL
```
http://localhost:4000/api/v1
```

### Authentication
```
Authorization: Bearer <jwt_token>
```

### Response Format
```json
// Success
{
  "data": { ... },
  "meta": { "total": 100, "page": 1, "pageSize": 20 }
}

// Error
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Human-readable message",
    "details": [{ "field": "email", "message": "Email is required" }]
  }
}
```

### Pagination
```
GET /api/v1/resource?cursor=abc&limit=20
GET /api/v1/resource?page=1&pageSize=20
```

### HTTP Status Codes
| Code | Usage |
|------|-------|
| 200 | Success |
| 201 | Created |
| 400 | Bad request / validation error |
| 401 | Unauthorized |
| 403 | Forbidden |
| 404 | Not found |
| 409 | Conflict |
| 422 | Unprocessable entity |
| 429 | Rate limited |
| 500 | Internal server error |

### Rate Limiting
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 99
X-RateLimit-Reset: 1626412800
```
