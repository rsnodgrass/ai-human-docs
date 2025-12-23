<!-- doc-audience: ai -->

# API Reference

This document provides comprehensive API documentation for AI agents and automated tools.

## Authentication

### Overview

All API requests require authentication via Bearer token in the Authorization header.

### Token Format

```
Authorization: Bearer <token>
```

### Token Acquisition

Tokens are obtained via the `/auth/token` endpoint using client credentials.

### Token Expiration

- Access tokens expire after 3600 seconds (1 hour)
- Refresh tokens expire after 604800 seconds (7 days)
- Tokens cannot be extended; request a new token before expiration

### Error Handling

| Status Code | Error Code | Description | Resolution |
|-------------|------------|-------------|------------|
| 401 | `token_missing` | No Authorization header | Include Bearer token |
| 401 | `token_invalid` | Token format incorrect | Check token format |
| 401 | `token_expired` | Token has expired | Request new token |
| 403 | `insufficient_scope` | Token lacks required scope | Request token with correct scopes |

## Endpoints

### GET /api/v1/users

Retrieves a paginated list of users.

#### Request Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `page` | integer | No | 1 | Page number (1-indexed) |
| `per_page` | integer | No | 20 | Items per page (max 100) |
| `sort` | string | No | `created_at` | Sort field |
| `order` | string | No | `desc` | Sort order (`asc` or `desc`) |
| `status` | string | No | - | Filter by status (`active`, `inactive`, `pending`) |

#### Response

```json
{
  "data": [
    {
      "id": "user_01234567-89ab-cdef-0123-456789abcdef",
      "email": "user@example.com",
      "name": "Example User",
      "status": "active",
      "created_at": "2024-01-15T10:30:00Z",
      "updated_at": "2024-01-15T10:30:00Z"
    }
  ],
  "meta": {
    "page": 1,
    "per_page": 20,
    "total": 150,
    "total_pages": 8
  }
}
```

#### Error Responses

| Status | Code | When |
|--------|------|------|
| 400 | `invalid_page` | Page number < 1 |
| 400 | `invalid_per_page` | per_page < 1 or > 100 |
| 400 | `invalid_sort` | Unknown sort field |
| 400 | `invalid_order` | Order not `asc` or `desc` |
| 400 | `invalid_status` | Unknown status value |

### POST /api/v1/users

Creates a new user.

#### Request Body

```json
{
  "email": "newuser@example.com",
  "name": "New User",
  "password": "securepassword123"
}
```

#### Field Validation

| Field | Type | Required | Constraints |
|-------|------|----------|-------------|
| `email` | string | Yes | Valid email format, unique |
| `name` | string | Yes | 1-100 characters |
| `password` | string | Yes | 8-128 characters, 1 uppercase, 1 number |

#### Response (201 Created)

```json
{
  "data": {
    "id": "user_01234567-89ab-cdef-0123-456789abcdef",
    "email": "newuser@example.com",
    "name": "New User",
    "status": "pending",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

#### Error Responses

| Status | Code | When |
|--------|------|------|
| 400 | `email_invalid` | Email format invalid |
| 400 | `email_taken` | Email already registered |
| 400 | `name_required` | Name field missing |
| 400 | `name_too_long` | Name exceeds 100 characters |
| 400 | `password_too_short` | Password under 8 characters |
| 400 | `password_too_weak` | Password missing required characters |

---

*This is an example of an AI-audience doc. AI agents may freely edit, expand, and add detail to this document.*
