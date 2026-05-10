---
paths:
  - "app/src/**/*.py"
  - "**/api/**/*.yml"
  - "**/api/**/*.yaml"
---

# API Design Rules

## REST Conventions

- Always prefer using **nouns** in URIs and the HTTP method to express the action. IF the action doesn't fit standard CRUD operations, use a controller resource with a verb that describes the state transition (e.g. `POST /orders/{orderId}/cancel`).
- **Wire format:** request/response JSON fields use `camelCase` and query params use `camelCase`, regardless of Python's internal `snake_case` convention. Convert at the serialization boundary.
- `kebab-case` for resource paths (URLs).
- `Content-Type: application/json` on every request/response with a body.

## URI Patterns

```
# Collection resource
POST   /products

# Singleton resource (no ID in URL)
GET    /products/{productId}
GET    /profile

# Sub-resources (max 2 levels)
GET    /orders/{orderId}/items
DELETE /customers/{customerId}/addresses/{addressId}

# Controller resource (state transitions that don't map to HTTP methods)
POST /orders/{orderId}/confirm
POST /inventories/{inventoryId}/products/{productId}/release
```

## Response schema

```json
{
  "data": {}, # Object if single resource, array if collection
  "meta": {
    "pagination": { # Pagination info for collection responses
      "limit": 20,
      "cursor": "eyJsYXN0S2V5IjogIjEyMyJ9",
      "hasMore": true
    }
  },
  "links": { # Hypermedia links for pagination if applicable
    "self": "/products?limit=20&cursor=eyJsYXN0S2V5IjogIjEyMyJ9", # URL of the current page
    "next": "/products?limit=20&cursor=dnN4dF9rZXlfNDU2" # URL of the next page, if hasMore=true
  }
}
```

### Error schema

```json
{
  "status": 400, # HTTP status code
  "code": "ERR_RESOURCE_VALIDATION_FAILED", # Application-specific error code
  "message": "The provided value for 'fieldName' is invalid.", # Human-readable error message
}
```