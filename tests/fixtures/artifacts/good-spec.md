# [Greeting Endpoint] Spec

## Goal

Add a GET `/hello` endpoint that returns `{ "message": "hello" }`.

## Success Criteria

- GET `/hello` returns 200 with JSON body `{ "message": "hello" }`
- Test covers success response
- No auth required

## Scope

- One route handler
- One integration test

## Out of Scope

- Other routes
- Database
- Authentication

## Design

Add handler in existing HTTP router. Register route at `/hello`.

## Testing Approach

TDD: write failing integration test, implement handler, verify pass.

## Open Questions

None
