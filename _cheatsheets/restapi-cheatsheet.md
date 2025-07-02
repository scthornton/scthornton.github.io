---
layout: cheatsheet
title: "REST-API reference and notes"
description: "Notes on REST"
date: 2025-04-20
categories: [programming]
tags: [restful, restapi, http, api,]
---


# REST API Comprehensive Cheatsheet

## Table of Contents
1. [REST Fundamentals](#rest-fundamentals)
2. [HTTP Methods](#http-methods)
3. [HTTP Status Codes](#http-status-codes)
4. [Request and Response Structure](#request-and-response-structure)
5. [URL Design and Best Practices](#url-design-and-best-practices)
6. [Authentication and Authorization](#authentication-and-authorization)
7. [API Versioning](#api-versioning)
8. [Error Handling](#error-handling)
9. [Pagination, Filtering, and Sorting](#pagination-filtering-and-sorting)
10. [Content Negotiation](#content-negotiation)
11. [CORS (Cross-Origin Resource Sharing)](#cors-cross-origin-resource-sharing)
12. [Rate Limiting](#rate-limiting)
13. [Caching](#caching)
14. [API Documentation](#api-documentation)
15. [Testing REST APIs](#testing-rest-apis)
16. [Security Best Practices](#security-best-practices)
17. [Performance Optimization](#performance-optimization)
18. [WebSockets and Real-time APIs](#websockets-and-real-time-apis)
19. [GraphQL vs REST](#graphql-vs-rest)
20. [Tools and Resources](#tools-and-resources)

## REST Fundamentals

### What is REST?
REST (Representational State Transfer) is an architectural style for designing networked applications. Think of it as a set of rules for how web services should communicate - like a common language that allows different systems to talk to each other over the internet.

### REST Principles
1. **Client-Server Architecture**: Separation of concerns between UI and data storage
2. **Statelessness**: Each request contains all information needed to understand it
3. **Cacheability**: Responses must define themselves as cacheable or not
4. **Uniform Interface**: Consistent way to interact with resources
5. **Layered System**: Architecture can have multiple layers
6. **Code on Demand** (optional): Server can send executable code to client

### Key Concepts
- **Resource**: Any information that can be named (user, order, product)
- **Representation**: How a resource is presented (JSON, XML, HTML)
- **State Transfer**: Moving resource representations between client and server
- **Endpoint**: Specific URL where a resource can be accessed
- **Idempotency**: Same request produces same result if repeated

## HTTP Methods

### CRUD Operations
```
CREATE  → POST
READ    → GET
UPDATE  → PUT/PATCH
DELETE  → DELETE
```

### Method Details

#### GET - Retrieve Resources
```http
GET /api/users
GET /api/users/123
GET /api/users?age=25&city=NYC

# Characteristics:
- Safe (no side effects)
- Idempotent
- Cacheable
- Body should be empty
```

#### POST - Create Resources
```http
POST /api/users
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com"
}

# Characteristics:
- Not safe
- Not idempotent
- Usually not cacheable
- Body contains new resource data
```

#### PUT - Update/Replace Resources
```http
PUT /api/users/123
Content-Type: application/json

{
  "id": 123,
  "name": "John Doe Updated",
  "email": "john.new@example.com"
}

# Characteristics:
- Not safe
- Idempotent
- Not cacheable
- Replaces entire resource
```

#### PATCH - Partial Update
```http
PATCH /api/users/123
Content-Type: application/json

{
  "email": "john.updated@example.com"
}

# Characteristics:
- Not safe
- Not idempotent (can be)
- Not cacheable
- Updates specific fields
```

#### DELETE - Remove Resources
```http
DELETE /api/users/123

# Characteristics:
- Not safe
- Idempotent
- Not cacheable
- Body usually empty
```

#### HEAD - Get Headers Only
```http
HEAD /api/users/123

# Same as GET but returns only headers
# Useful for checking if resource exists
```

#### OPTIONS - Get Allowed Methods
```http
OPTIONS /api/users

# Response headers:
Allow: GET, POST, PUT, DELETE, OPTIONS
```

## HTTP Status Codes

### Success Codes (2xx)
```
200 OK                  - Successful request
201 Created             - Resource created (POST)
202 Accepted            - Request accepted for processing
204 No Content          - Success with no body (DELETE)
206 Partial Content     - Partial resource returned
```

### Redirection Codes (3xx)
```
301 Moved Permanently   - Resource moved permanently
302 Found               - Resource moved temporarily
304 Not Modified        - Cached version is valid
307 Temporary Redirect  - Repeat request to new URL
308 Permanent Redirect  - Permanent redirect (keeps method)
```

### Client Error Codes (4xx)
```
400 Bad Request         - Invalid request syntax
401 Unauthorized        - Authentication required
403 Forbidden           - Authentication successful, but access denied
404 Not Found           - Resource doesn't exist
405 Method Not Allowed  - HTTP method not supported
406 Not Acceptable      - Can't provide requested content type
408 Request Timeout     - Request took too long
409 Conflict            - Request conflicts with current state
410 Gone                - Resource no longer available
413 Payload Too Large   - Request body too large
414 URI Too Long        - Request URI too long
415 Unsupported Media Type - Media type not supported
422 Unprocessable Entity - Validation errors
429 Too Many Requests   - Rate limit exceeded
```

### Server Error Codes (5xx)
```
500 Internal Server Error - Generic server error
501 Not Implemented      - Feature not implemented
502 Bad Gateway          - Invalid response from upstream
503 Service Unavailable  - Server temporarily unavailable
504 Gateway Timeout      - Upstream server timeout
```

## Request and Response Structure

### Request Structure
```http
POST /api/users HTTP/1.1
Host: api.example.com
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJIUzI1NiIs...
Accept: application/json
User-Agent: MyApp/1.0
X-Request-ID: 12345

{
  "name": "John Doe",
  "email": "john@example.com",
  "age": 30
}
```

### Common Request Headers
```http
# Content headers
Content-Type: application/json
Content-Length: 348
Content-Encoding: gzip

# Accept headers
Accept: application/json
Accept-Language: en-US
Accept-Encoding: gzip, deflate

# Authentication
Authorization: Bearer <token>
Authorization: Basic <base64>
API-Key: <api-key>

# Caching
If-None-Match: "etag-value"
If-Modified-Since: Wed, 21 Oct 2023 07:28:00 GMT

# Custom headers
X-Request-ID: uuid-12345
X-API-Version: v2
X-Rate-Limit-Remaining: 99
```

### Response Structure
```http
HTTP/1.1 200 OK
Content-Type: application/json
Content-Length: 234
Cache-Control: max-age=3600
ETag: "33a64df551"
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 99
X-RateLimit-Reset: 1619496000

{
  "id": 123,
  "name": "John Doe",
  "email": "john@example.com",
  "created_at": "2023-10-21T10:30:00Z",
  "updated_at": "2023-10-21T10:30:00Z"
}
```

### Common Response Headers
```http
# Content headers
Content-Type: application/json; charset=utf-8
Content-Length: 1234
Content-Encoding: gzip
Content-Language: en

# Caching
Cache-Control: public, max-age=3600
ETag: "33a64df551"
Last-Modified: Wed, 21 Oct 2023 07:28:00 GMT
Expires: Wed, 21 Oct 2023 08:28:00 GMT

# CORS headers
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, POST, PUT, DELETE
Access-Control-Allow-Headers: Content-Type, Authorization

# Rate limiting
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 99
X-RateLimit-Reset: 1619496000

# Pagination
X-Total-Count: 1000
Link: <https://api.example.com/users?page=2>; rel="next"
```

## URL Design and Best Practices

### Resource Naming
```
# Use nouns, not verbs
GOOD: /api/users
BAD:  /api/getUsers

# Use plural nouns
GOOD: /api/users
BAD:  /api/user

# Use lowercase
GOOD: /api/users
BAD:  /api/Users

# Use hyphens for readability
GOOD: /api/user-profiles
BAD:  /api/user_profiles or /api/userProfiles
```

### URL Structure
```
# Collection of resources
GET    /api/users              # List all users
POST   /api/users              # Create new user

# Specific resource
GET    /api/users/123          # Get user 123
PUT    /api/users/123          # Update user 123
PATCH  /api/users/123          # Partially update user 123
DELETE /api/users/123          # Delete user 123

# Nested resources
GET    /api/users/123/orders   # Get orders for user 123
POST   /api/users/123/orders   # Create order for user 123
GET    /api/users/123/orders/456  # Get specific order

# Resource relationships
GET    /api/orders/456/user    # Get user who placed order 456
GET    /api/users/123/orders/456/items  # Deep nesting (avoid if possible)
```

### Query Parameters
```
# Filtering
GET /api/users?status=active&role=admin
GET /api/products?price_min=10&price_max=100

# Sorting
GET /api/users?sort=name
GET /api/users?sort=-created_at  # Descending with -
GET /api/users?sort=name,-created_at  # Multiple sorts

# Pagination
GET /api/users?page=2&limit=20
GET /api/users?offset=20&limit=20

# Field selection
GET /api/users?fields=id,name,email
GET /api/users?exclude=password,secret

# Search
GET /api/users?q=john
GET /api/products?search=laptop

# Date ranges
GET /api/orders?created_after=2023-01-01&created_before=2023-12-31
```

### Anti-Patterns to Avoid
```
# Don't use verbs in URLs
BAD:  /api/users/create
GOOD: POST /api/users

# Don't mix singular and plural
BAD:  /api/user/123/order
GOOD: /api/users/123/orders

# Avoid deep nesting (more than 2-3 levels)
BAD:  /api/users/123/orders/456/items/789/reviews
GOOD: /api/reviews?item_id=789

# Don't include format in URL
BAD:  /api/users.json
GOOD: /api/users with Accept: application/json
```

## Authentication and Authorization

### Authentication Methods

#### API Keys
```http
# Header
GET /api/users
X-API-Key: abcdef123456

# Query parameter (less secure)
GET /api/users?api_key=abcdef123456

# Best practices:
- Use HTTPS only
- Rotate keys regularly
- Limit key permissions
- Monitor key usage
```

#### Basic Authentication
```http
GET /api/users
Authorization: Basic dXNlcm5hbWU6cGFzc3dvcmQ=

# Base64 encoded "username:password"
# Only use over HTTPS!
```

#### Bearer Token (JWT)
```http
GET /api/users
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# JWT structure:
# Header.Payload.Signature

# Decoded payload example:
{
  "sub": "1234567890",
  "name": "John Doe",
  "iat": 1516239022,
  "exp": 1516242622
}
```

#### OAuth 2.0 Flow
```
1. Client requests authorization
   GET /oauth/authorize?
     response_type=code&
     client_id=CLIENT_ID&
     redirect_uri=REDIRECT_URI&
     scope=read:users&
     state=RANDOM_STATE

2. User authorizes, receives code
   GET REDIRECT_URI?code=AUTH_CODE&state=RANDOM_STATE

3. Exchange code for token
   POST /oauth/token
   {
     "grant_type": "authorization_code",
     "code": "AUTH_CODE",
     "client_id": "CLIENT_ID",
     "client_secret": "CLIENT_SECRET"
   }

4. Receive access token
   {
     "access_token": "ACCESS_TOKEN",
     "token_type": "Bearer",
     "expires_in": 3600,
     "refresh_token": "REFRESH_TOKEN"
   }
```

### Authorization Patterns
```http
# Role-based access
GET /api/admin/users
Authorization: Bearer <token>
# Token contains: {"role": "admin"}

# Resource-based access
GET /api/users/123/profile
Authorization: Bearer <token>
# Token contains: {"user_id": 123}

# Scope-based access
GET /api/users/123/email
Authorization: Bearer <token>
# Token contains: {"scope": "read:email"}
```

## API Versioning

### Versioning Strategies

#### URL Path Versioning
```http
GET /api/v1/users
GET /api/v2/users

# Pros: Clear, easy to route
# Cons: URL pollution
```

#### Query Parameter Versioning
```http
GET /api/users?version=1
GET /api/users?v=2

# Pros: Clean base URL
# Cons: Can be missed
```

#### Header Versioning
```http
GET /api/users
API-Version: 1

GET /api/users
X-API-Version: 2

# Pros: Clean URLs
# Cons: Less discoverable
```

#### Accept Header Versioning
```http
GET /api/users
Accept: application/vnd.company.api+json;version=1

# Pros: RESTful approach
# Cons: Complex
```

### Versioning Best Practices
```
1. Version from the start
2. Support at least one previous version
3. Deprecate gracefully with notices
4. Document version differences
5. Use semantic versioning

# Deprecation header
Sunset: Sat, 31 Dec 2023 23:59:59 GMT
Deprecation: true
Link: <https://api.example.com/v2/users>; rel="successor-version"
```

## Error Handling

### Error Response Format
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Validation failed",
    "details": [
      {
        "field": "email",
        "code": "INVALID_FORMAT",
        "message": "Email format is invalid"
      },
      {
        "field": "age",
        "code": "OUT_OF_RANGE",
        "message": "Age must be between 18 and 100"
      }
    ],
    "request_id": "req_12345",
    "timestamp": "2023-10-21T10:30:00Z"
  }
}
```

### Standard Error Codes
```json
// 400 Bad Request
{
  "error": {
    "code": "BAD_REQUEST",
    "message": "The request format is invalid"
  }
}

// 401 Unauthorized
{
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Authentication credentials are missing or invalid"
  }
}

// 403 Forbidden
{
  "error": {
    "code": "FORBIDDEN",
    "message": "You don't have permission to access this resource"
  }
}

// 404 Not Found
{
  "error": {
    "code": "NOT_FOUND",
    "message": "The requested resource was not found"
  }
}

// 422 Unprocessable Entity
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "The request data is invalid",
    "errors": {
      "email": ["Email is already taken"],
      "password": ["Password must be at least 8 characters"]
    }
  }
}

// 429 Too Many Requests
{
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Too many requests",
    "retry_after": 3600
  }
}

// 500 Internal Server Error
{
  "error": {
    "code": "INTERNAL_ERROR",
    "message": "An unexpected error occurred",
    "request_id": "req_12345"
  }
}
```

### Error Handling Best Practices
```
1. Use consistent error format
2. Include helpful error messages
3. Provide error codes for programmatic handling
4. Include request IDs for debugging
5. Don't expose sensitive information
6. Use appropriate HTTP status codes
7. Include field-level errors for validation
8. Provide links to documentation
```

## Pagination, Filtering, and Sorting

### Pagination Strategies

#### Offset-Based Pagination
```http
GET /api/users?offset=20&limit=10

Response:
{
  "data": [...],
  "pagination": {
    "offset": 20,
    "limit": 10,
    "total": 100,
    "links": {
      "first": "/api/users?offset=0&limit=10",
      "prev": "/api/users?offset=10&limit=10",
      "next": "/api/users?offset=30&limit=10",
      "last": "/api/users?offset=90&limit=10"
    }
  }
}
```

#### Page-Based Pagination
```http
GET /api/users?page=3&per_page=10

Response:
{
  "data": [...],
  "pagination": {
    "current_page": 3,
    "per_page": 10,
    "total_pages": 10,
    "total_items": 100,
    "links": {
      "first": "/api/users?page=1&per_page=10",
      "prev": "/api/users?page=2&per_page=10",
      "next": "/api/users?page=4&per_page=10",
      "last": "/api/users?page=10&per_page=10"
    }
  }
}
```

#### Cursor-Based Pagination
```http
GET /api/users?cursor=eyJpZCI6MTIzfQ&limit=10

Response:
{
  "data": [...],
  "pagination": {
    "cursor": "eyJpZCI6MTMzfQ",
    "has_more": true,
    "links": {
      "next": "/api/users?cursor=eyJpZCI6MTMzfQ&limit=10"
    }
  }
}

# Best for real-time data
# Cursor typically encodes the last seen ID or timestamp
```

#### Link Header Pagination
```http
GET /api/users?page=3

Response headers:
Link: <https://api.example.com/users?page=1>; rel="first",
      <https://api.example.com/users?page=2>; rel="prev",
      <https://api.example.com/users?page=4>; rel="next",
      <https://api.example.com/users?page=10>; rel="last"
X-Total-Count: 100
```

### Filtering
```http
# Simple filtering
GET /api/users?status=active&role=admin

# Range filtering
GET /api/products?price_min=10&price_max=100
GET /api/orders?created_after=2023-01-01

# Multiple values
GET /api/users?role=admin,moderator
GET /api/users?role[]=admin&role[]=moderator

# Nested filtering
GET /api/users?address.city=NYC
GET /api/users?filter[address][city]=NYC

# Complex filtering with operators
GET /api/users?age[gte]=18&age[lt]=65
GET /api/products?name[contains]=laptop
GET /api/users?email[ends_with]=@company.com

# Filter operators:
# eq     - equals
# ne     - not equals
# gt     - greater than
# gte    - greater than or equal
# lt     - less than
# lte    - less than or equal
# in     - in array
# nin    - not in array
# contains - contains substring
# starts_with - starts with
# ends_with - ends with
```

### Sorting
```http
# Simple sorting
GET /api/users?sort=name
GET /api/users?sort=-created_at  # Descending

# Multiple sort fields
GET /api/users?sort=status,-created_at
GET /api/users?sort[]=status&sort[]=-created_at

# Nested field sorting
GET /api/users?sort=address.city
```

### Combined Example
```http
GET /api/products?
  category=electronics&
  price_min=100&
  price_max=1000&
  brand=apple,samsung&
  in_stock=true&
  sort=-price,name&
  page=2&
  per_page=20

Response:
{
  "data": [
    {
      "id": 123,
      "name": "iPhone 13",
      "price": 999,
      "brand": "apple",
      "category": "electronics",
      "in_stock": true
    },
    // ... more products
  ],
  "meta": {
    "pagination": {
      "page": 2,
      "per_page": 20,
      "total": 150,
      "pages": 8
    },
    "filters": {
      "category": "electronics",
      "price_range": [100, 1000],
      "brands": ["apple", "samsung"],
      "in_stock": true
    },
    "sort": ["-price", "name"]
  }
}
```

## Content Negotiation

### Accept Headers
```http
# Request specific format
GET /api/users/123
Accept: application/json

GET /api/users/123
Accept: application/xml

GET /api/users/123
Accept: text/html

# Multiple formats with priority
GET /api/users/123
Accept: application/json;q=0.9, application/xml;q=0.8, */*;q=0.1

# Version negotiation
GET /api/users/123
Accept: application/vnd.api+json;version=2
```

### Content-Type Headers
```http
# JSON request
POST /api/users
Content-Type: application/json
{
  "name": "John Doe"
}

# Form data
POST /api/users
Content-Type: application/x-www-form-urlencoded
name=John+Doe&email=john%40example.com

# Multipart form data
POST /api/users
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary
------WebKitFormBoundary
Content-Disposition: form-data; name="user"
{"name": "John Doe"}
------WebKitFormBoundary
Content-Disposition: form-data; name="avatar"; filename="avatar.jpg"
Content-Type: image/jpeg
[binary data]
------WebKitFormBoundary--

# Custom content types
POST /api/import
Content-Type: text/csv
name,email
John Doe,john@example.com
```

### Language Negotiation
```http
GET /api/messages
Accept-Language: en-US,en;q=0.9,es;q=0.8

Response:
Content-Language: en-US
{
  "welcome": "Welcome",
  "goodbye": "Goodbye"
}
```

## CORS (Cross-Origin Resource Sharing)

### Preflight Request
```http
OPTIONS /api/users
Origin: https://example.com
Access-Control-Request-Method: POST
Access-Control-Request-Headers: Content-Type, Authorization

Response:
Access-Control-Allow-Origin: https://example.com
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Headers: Content-Type, Authorization
Access-Control-Max-Age: 86400
Access-Control-Allow-Credentials: true
```

### Simple CORS Request
```http
GET /api/users
Origin: https://example.com

Response:
Access-Control-Allow-Origin: https://example.com
Access-Control-Allow-Credentials: true
Access-Control-Expose-Headers: X-Total-Count
```

### CORS Configuration Examples
```javascript
// Express.js
app.use(cors({
  origin: ['https://example.com', 'https://app.example.com'],
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  exposedHeaders: ['X-Total-Count', 'X-Page-Count']
}));

// Spring Boot
@CrossOrigin(
  origins = {"https://example.com"},
  methods = {RequestMethod.GET, RequestMethod.POST},
  allowedHeaders = {"Content-Type", "Authorization"},
  exposedHeaders = {"X-Total-Count"},
  allowCredentials = "true",
  maxAge = 3600
)

// .NET Core
services.AddCors(options => {
  options.AddPolicy("ApiCors", builder => {
    builder
      .WithOrigins("https://example.com")
      .AllowAnyMethod()
      .AllowAnyHeader()
      .AllowCredentials()
      .WithExposedHeaders("X-Total-Count");
  });
});
```

## Rate Limiting

### Rate Limit Headers
```http
GET /api/users

Response:
X-RateLimit-Limit: 100         # Max requests per window
X-RateLimit-Remaining: 99      # Remaining requests
X-RateLimit-Reset: 1619496000  # Window reset time (Unix timestamp)
X-RateLimit-Reset-After: 3600  # Seconds until reset
X-RateLimit-Bucket: api        # Rate limit bucket
```

### Rate Limit Exceeded Response
```http
HTTP/1.1 429 Too Many Requests
Retry-After: 3600
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 0
X-RateLimit-Reset: 1619496000

{
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "API rate limit exceeded",
    "retry_after": 3600
  }
}
```

### Rate Limiting Strategies
```
# Per IP address
Rate limit: 100 requests per hour per IP

# Per API key
Rate limit: 1000 requests per hour per API key

# Per user
Rate limit: 10000 requests per day per authenticated user

# Tiered limits
Basic: 100 requests/hour
Premium: 1000 requests/hour
Enterprise: 10000 requests/hour

# Endpoint-specific limits
GET endpoints: 1000 requests/hour
POST endpoints: 100 requests/hour
File uploads: 10 requests/hour
```

### Token Bucket Algorithm
```javascript
// Conceptual implementation
class TokenBucket {
  constructor(capacity, refillRate) {
    this.capacity = capacity;
    this.tokens = capacity;
    this.refillRate = refillRate;
    this.lastRefill = Date.now();
  }
  
  consume(tokens = 1) {
    this.refill();
    if (this.tokens >= tokens) {
      this.tokens -= tokens;
      return true;
    }
    return false;
  }
  
  refill() {
    const now = Date.now();
    const timePassed = (now - this.lastRefill) / 1000;
    const tokensToAdd = timePassed * this.refillRate;
    this.tokens = Math.min(this.capacity, this.tokens + tokensToAdd);
    this.lastRefill = now;
  }
}
```

## Caching

### Cache Headers
```http
# Client request with cache validation
GET /api/users/123
If-None-Match: "33a64df551"
If-Modified-Since: Wed, 21 Oct 2023 07:28:00 GMT

# Server response (not modified)
HTTP/1.1 304 Not Modified
ETag: "33a64df551"
Cache-Control: private, max-age=3600

# Server response (modified)
HTTP/1.1 200 OK
ETag: "44b75eg662"
Last-Modified: Thu, 22 Oct 2023 09:30:00 GMT
Cache-Control: private, max-age=3600
```

### Cache-Control Directives
```http
# Public caching (CDN friendly)
Cache-Control: public, max-age=3600

# Private caching (user-specific)
Cache-Control: private, max-age=3600

# No caching
Cache-Control: no-cache, no-store, must-revalidate

# Immutable resources
Cache-Control: public, max-age=31536000, immutable

# Stale while revalidate
Cache-Control: max-age=3600, stale-while-revalidate=86400

# Common patterns
Static assets: public, max-age=31536000, immutable
API responses: private, max-age=300
User data: private, no-cache
Sensitive data: no-store
```

### ETag Strategies
```javascript
// Weak ETag (semantic equivalence)
ETag: W/"123456"

// Strong ETag (byte-for-byte identical)
ETag: "123456"

// Generation strategies:
// 1. Content hash
const etag = crypto.createHash('md5').update(content).digest('hex');

// 2. Version + timestamp
const etag = `${version}-${lastModified.getTime()}`;

// 3. Database version
const etag = `${record.id}-${record.updated_at}`;
```

### Conditional Requests
```http
# Conditional GET
GET /api/users/123
If-None-Match: "123456"

# Conditional PUT (optimistic locking)
PUT /api/users/123
If-Match: "123456"
{
  "name": "Updated Name"
}

# Response if precondition fails
HTTP/1.1 412 Precondition Failed
{
  "error": {
    "code": "PRECONDITION_FAILED",
    "message": "Resource has been modified"
  }
}
```

## API Documentation

### OpenAPI (Swagger) Specification
```yaml
openapi: 3.0.0
info:
  title: User API
  version: 1.0.0
  description: API for managing users
  contact:
    email: api@example.com
  license:
    name: MIT
    url: https://opensource.org/licenses/MIT

servers:
  - url: https://api.example.com/v1
    description: Production server
  - url: https://staging-api.example.com/v1
    description: Staging server

paths:
  /users:
    get:
      summary: List users
      operationId: listUsers
      tags:
        - Users
      parameters:
        - in: query
          name: page
          schema:
            type: integer
            default: 1
          description: Page number
        - in: query
          name: limit
          schema:
            type: integer
            default: 20
            maximum: 100
          description: Items per page
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    type: array
                    items:
                      $ref: '#/components/schemas/User'
                  meta:
                    $ref: '#/components/schemas/PaginationMeta'
        '401':
          $ref: '#/components/responses/Unauthorized'
          
    post:
      summary: Create user
      operationId: createUser
      tags:
        - Users
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateUserRequest'
      responses:
        '201':
          description: User created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
        '400':
          $ref: '#/components/responses/BadRequest'
        '422':
          $ref: '#/components/responses/ValidationError'

  /users/{id}:
    get:
      summary: Get user by ID
      operationId: getUser
      tags:
        - Users
      parameters:
        - in: path
          name: id
          required: true
          schema:
            type: integer
          description: User ID
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
        '404':
          $ref: '#/components/responses/NotFound'

components:
  schemas:
    User:
      type: object
      properties:
        id:
          type: integer
          example: 123
        name:
          type: string
          example: John Doe
        email:
          type: string
          format: email
          example: john@example.com
        created_at:
          type: string
          format: date-time
        updated_at:
          type: string
          format: date-time
          
    CreateUserRequest:
      type: object
      required:
        - name
        - email
      properties:
        name:
          type: string
          minLength: 1
          maxLength: 100
        email:
          type: string
          format: email
          
    Error:
      type: object
      properties:
        code:
          type: string
        message:
          type: string
        details:
          type: object
          
  responses:
    BadRequest:
      description: Bad request
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
            
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
      
security:
  - bearerAuth: []
```

### API Documentation Best Practices
```
1. Include clear descriptions
2. Provide request/response examples
3. Document all parameters
4. Explain error responses
5. Include authentication details
6. Version your documentation
7. Provide SDKs/client libraries
8. Include rate limit information
9. Offer interactive testing (Swagger UI)
10. Keep documentation up-to-date
```

## Testing REST APIs

### cURL Examples
```bash
# GET request
curl https://api.example.com/users

# GET with headers
curl -H "Authorization: Bearer token" \
     -H "Accept: application/json" \
     https://api.example.com/users

# POST request
curl -X POST \
     -H "Content-Type: application/json" \
     -d '{"name":"John Doe","email":"john@example.com"}' \
     https://api.example.com/users

# PUT request
curl -X PUT \
     -H "Content-Type: application/json" \
     -d '{"name":"Jane Doe"}' \
     https://api.example.com/users/123

# DELETE request
curl -X DELETE \
     -H "Authorization: Bearer token" \
     https://api.example.com/users/123

# File upload
curl -X POST \
     -F "file=@/path/to/file.jpg" \
     -F "description=Profile photo" \
     https://api.example.com/upload

# Download file
curl -O https://api.example.com/files/document.pdf

# Follow redirects
curl -L https://api.example.com/redirect

# Include response headers
curl -i https://api.example.com/users

# Verbose output
curl -v https://api.example.com/users

# Save response to file
curl -o response.json https://api.example.com/users
```

### HTTPie Examples
```bash
# GET request
http GET api.example.com/users

# POST with JSON
http POST api.example.com/users name="John Doe" email="john@example.com"

# Custom headers
http GET api.example.com/users Authorization:"Bearer token"

# Form data
http --form POST api.example.com/users name="John Doe"

# Download file
http --download api.example.com/files/document.pdf
```

### Postman/Insomnia Features
```
- Collections for organizing requests
- Environment variables
- Pre-request scripts
- Test scripts
- Response validation
- Mock servers
- Documentation generation
- Team collaboration
- Automated testing
- CI/CD integration
```

### API Testing with JavaScript
```javascript
// Using fetch
const response = await fetch('https://api.example.com/users', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer token'
  },
  body: JSON.stringify({
    name: 'John Doe',
    email: 'john@example.com'
  })
});

const data = await response.json();

// Using axios
const axios = require('axios');

const response = await axios.post('https://api.example.com/users', {
  name: 'John Doe',
  email: 'john@example.com'
}, {
  headers: {
    'Authorization': 'Bearer token'
  }
});

// Automated testing with Jest
describe('User API', () => {
  test('should create user', async () => {
    const response = await axios.post('/users', {
      name: 'John Doe',
      email: 'john@example.com'
    });
    
    expect(response.status).toBe(201);
    expect(response.data).toHaveProperty('id');
    expect(response.data.name).toBe('John Doe');
  });
  
  test('should handle validation errors', async () => {
    try {
      await axios.post('/users', {
        name: '' // Invalid
      });
    } catch (error) {
      expect(error.response.status).toBe(422);
      expect(error.response.data.error).toHaveProperty('code', 'VALIDATION_ERROR');
    }
  });
});
```

## Security Best Practices

### Authentication & Authorization
```
1. Use HTTPS everywhere
2. Implement proper authentication (OAuth 2.0, JWT)
3. Use API keys for service-to-service communication
4. Implement role-based access control (RBAC)
5. Validate tokens on every request
6. Use short-lived access tokens
7. Implement refresh token rotation
8. Store sensitive data securely
9. Never expose sensitive data in URLs
10. Implement proper session management
```

### Input Validation
```javascript
// Example validation schema (Joi)
const userSchema = Joi.object({
  name: Joi.string().min(1).max(100).required(),
  email: Joi.string().email().required(),
  age: Joi.number().integer().min(18).max(120),
  password: Joi.string().min(8).pattern(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/)
});

// SQL injection prevention
// Bad
const query = `SELECT * FROM users WHERE id = ${userId}`;

// Good
const query = 'SELECT * FROM users WHERE id = ?';
db.query(query, [userId]);

// XSS prevention
const sanitizedInput = DOMPurify.sanitize(userInput);
```

### Security Headers
```http
# Prevent XSS
X-Content-Type-Options: nosniff
X-XSS-Protection: 1; mode=block

# Prevent clickjacking
X-Frame-Options: DENY

# HTTPS enforcement
Strict-Transport-Security: max-age=31536000; includeSubDomains

# Content Security Policy
Content-Security-Policy: default-src 'self'

# Referrer policy
Referrer-Policy: no-referrer-when-downgrade

# Permissions policy
Permissions-Policy: geolocation=(), microphone=(), camera=()

# CORS
Access-Control-Allow-Origin: https://trusted-domain.com
Access-Control-Allow-Credentials: true
```

### API Security Checklist
```
□ Use HTTPS with valid certificates
□ Implement authentication and authorization
□ Validate all input data
□ Sanitize output data
□ Implement rate limiting
□ Use parameterized queries
□ Log security events
□ Implement CORS properly
□ Keep dependencies updated
□ Regular security audits
□ Implement request signing for sensitive operations
□ Use Web Application Firewall (WAF)
□ Monitor for anomalous behavior
□ Implement API versioning
□ Document security requirements
```

## Performance Optimization

### Response Optimization
```
1. Use compression (gzip, brotli)
2. Implement pagination for large datasets
3. Use field filtering to reduce payload
4. Cache responses appropriately
5. Use CDN for static content
6. Implement database indexing
7. Use database query optimization
8. Implement connection pooling
9. Use asynchronous processing for heavy operations
10. Implement request/response streaming for large data
```

### Database Optimization
```javascript
// N+1 query problem
// Bad
const users = await db.query('SELECT * FROM users');
for (const user of users) {
  user.posts = await db.query('SELECT * FROM posts WHERE user_id = ?', [user.id]);
}

// Good - Use joins or eager loading
const users = await db.query(`
  SELECT u.*, p.*
  FROM users u
  LEFT JOIN posts p ON u.id = p.user_id
`);

// Or use ORM with eager loading
const users = await User.findAll({
  include: [Post]
});
```

### Caching Strategies
```
1. Browser caching (Cache-Control headers)
2. CDN caching for static assets
3. API gateway caching
4. Redis/Memcached for application caching
5. Database query result caching
6. HTTP caching proxies (Varnish)

// Redis caching example
const cacheKey = `user:${userId}`;
let user = await redis.get(cacheKey);

if (!user) {
  user = await db.query('SELECT * FROM users WHERE id = ?', [userId]);
  await redis.setex(cacheKey, 3600, JSON.stringify(user));
} else {
  user = JSON.parse(user);
}
```

### Async Operations
```javascript
// Queue long-running tasks
app.post('/api/reports/generate', async (req, res) => {
  // Queue the job
  const jobId = await queue.add('generate-report', {
    userId: req.user.id,
    reportType: req.body.type
  });
  
  // Return immediately
  res.status(202).json({
    jobId,
    status: 'processing',
    checkStatusUrl: `/api/jobs/${jobId}`
  });
});

// Check job status
app.get('/api/jobs/:id', async (req, res) => {
  const job = await queue.getJob(req.params.id);
  
  res.json({
    id: job.id,
    status: job.status,
    progress: job.progress,
    result: job.status === 'completed' ? job.result : null
  });
});
```

## WebSockets and Real-time APIs

### WebSocket Connection
```javascript
// Client-side
const ws = new WebSocket('wss://api.example.com/ws');

ws.onopen = () => {
  console.log('Connected');
  ws.send(JSON.stringify({
    type: 'subscribe',
    channel: 'updates'
  }));
};

ws.onmessage = (event) => {
  const data = JSON.parse(event.data);
  console.log('Received:', data);
};

ws.onerror = (error) => {
  console.error('WebSocket error:', error);
};

ws.onclose = () => {
  console.log('Disconnected');
  // Implement reconnection logic
};

// Server-side (Node.js with ws)
const WebSocket = require('ws');
const wss = new WebSocket.Server({ port: 8080 });

wss.on('connection', (ws) => {
  ws.on('message', (message) => {
    const data = JSON.parse(message);
    
    if (data.type === 'subscribe') {
      // Add to subscription list
      subscribeToChannel(ws, data.channel);
    }
  });
  
  ws.on('close', () => {
    // Clean up subscriptions
    unsubscribeAll(ws);
  });
});

// Broadcast to all clients
function broadcast(channel, data) {
  wss.clients.forEach((client) => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(JSON.stringify({
        channel,
        data
      }));
    }
  });
}
```

### Server-Sent Events (SSE)
```javascript
// Server-side
app.get('/api/events', (req, res) => {
  res.writeHead(200, {
    'Content-Type': 'text/event-stream',
    'Cache-Control': 'no-cache',
    'Connection': 'keep-alive',
    'Access-Control-Allow-Origin': '*'
  });
  
  // Send event
  const sendEvent = (data) => {
    res.write(`data: ${JSON.stringify(data)}\n\n`);
  };
  
  // Send initial event
  sendEvent({ type: 'connected', timestamp: Date.now() });
  
  // Send periodic updates
  const interval = setInterval(() => {
    sendEvent({
      type: 'update',
      data: { /* ... */ }
    });
  }, 5000);
  
  // Clean up on disconnect
  req.on('close', () => {
    clearInterval(interval);
  });
});

// Client-side
const eventSource = new EventSource('https://api.example.com/events');

eventSource.onmessage = (event) => {
  const data = JSON.parse(event.data);
  console.log('Received:', data);
};

eventSource.onerror = (error) => {
  console.error('SSE error:', error);
};
```

### WebSocket vs REST
```
WebSocket advantages:
- Real-time bidirectional communication
- Lower latency
- Less overhead per message
- Persistent connection

REST advantages:
- Simpler to implement
- Better caching support
- Stateless
- Works with existing HTTP infrastructure
- Better for request-response patterns

Use WebSocket for:
- Chat applications
- Live notifications
- Real-time collaboration
- Gaming
- Financial trading

Use REST for:
- CRUD operations
- File uploads/downloads
- Traditional request-response
- Public APIs
- Mobile applications with intermittent connectivity
```

## GraphQL vs REST

### Comparison
```
REST:
- Multiple endpoints
- Fixed data structure
- Over/under fetching
- Simple caching
- HTTP status codes
- Mature ecosystem

GraphQL:
- Single endpoint
- Flexible queries
- Exact data fetching
- Complex caching
- Always returns 200 OK
- Growing ecosystem

// REST - Multiple requests
GET /api/users/123
GET /api/users/123/posts
GET /api/users/123/followers

// GraphQL - Single request
POST /graphql
{
  user(id: 123) {
    name
    email
    posts {
      title
      content
    }
    followers {
      name
    }
  }
}
```

### When to Use Each
```
Use REST when:
- Simple CRUD operations
- File uploads/downloads
- Public APIs
- Caching is important
- Team is familiar with REST

Use GraphQL when:
- Complex data requirements
- Mobile applications (bandwidth)
- Rapid frontend development
- Multiple client types
- Real-time subscriptions needed
```

## Tools and Resources

### API Development Tools
```
# API Design & Documentation
- Swagger/OpenAPI
- Postman
- Insomnia
- Stoplight
- API Blueprint
- RAML

# API Testing
- Postman
- Insomnia
- REST Client (VS Code)
- HTTPie
- cURL
- Paw (Mac)
- SoapUI

# API Monitoring
- Pingdom
- New Relic
- Datadog
- Prometheus
- Grafana
- ELK Stack

# API Gateways
- Kong
- AWS API Gateway
- Apigee
- Zuul
- Traefik
- Nginx

# Mock Servers
- JSON Server
- Mockoon
- WireMock
- Postman Mock Server
- MSW (Mock Service Worker)
```

### Code Libraries
```javascript
// Node.js
- Express.js
- Fastify
- Koa
- Hapi
- NestJS

// Python
- FastAPI
- Django REST Framework
- Flask-RESTful
- Falcon

// Java
- Spring Boot
- JAX-RS
- Dropwizard

// .NET
- ASP.NET Core Web API
- ServiceStack

// Go
- Gin
- Echo
- Fiber
- Chi

// Ruby
- Ruby on Rails API
- Grape
- Sinatra
```

### Best Practices Summary
```
1. Use proper HTTP methods and status codes
2. Version your API
3. Implement comprehensive error handling
4. Use consistent naming conventions
5. Document everything
6. Implement security best practices
7. Use pagination for large datasets
8. Implement proper caching
9. Monitor and log API usage
10. Design for backward compatibility
11. Use HTTPS everywhere
12. Implement rate limiting
13. Validate input data
14. Use proper content negotiation
15. Test thoroughly
```

---

*Building great REST APIs requires attention to detail, consistency, and a deep understanding of HTTP. Follow these patterns and practices to create APIs that developers love to use!*