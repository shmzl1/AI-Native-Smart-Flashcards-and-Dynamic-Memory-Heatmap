# API Spec (v1)

Purpose: Contract between frontend and backend (URL/method/request/response JSON).
Any API change MUST update this file.

## Conventions

- Base path: `/api/v1`
- Content-Type: `application/json`
- Field naming: `camelCase`
- Time: ISO-8601 UTC (e.g. `2026-04-06T12:00:00Z`)
- Response wrapper:
  - success: `{ "code": 0, "message": "", "data": ... }`
  - error: `{ "code": 400/401/500, "message": "reason", "data": null }`

---

## 1. Cards (CRUD)

### POST /cards

Purpose: Create a new flashcard.

Request:

```json
{ "question": "string", "answer": "string", "tags": ["string"] }
```

Response:

```json
{
  "code": 0,
  "message": "",
  "data": {
    "id": 1,
    "question": "string",
    "answer": "string",
    "tags": ["string"],
    "reviewCount": 0,
    "easeFactor": 2.5,
    "createdAt": "2026-04-06T12:00:00Z",
    "updatedAt": "2026-04-06T12:00:00Z"
  }
}
```

### GET /cards?page=1&pageSize=20

Purpose: List flashcards (paginated).

Response:

```json
{
  "code": 0,
  "message": "",
  "data": {
    "items": [
      {
        "id": 1,
        "question": "string",
        "answer": "string",
        "tags": ["string"],
        "reviewCount": 0,
        "easeFactor": 2.5,
        "createdAt": "2026-04-06T12:00:00Z",
        "updatedAt": "2026-04-06T12:00:00Z"
      }
    ],
    "total": 1
  }
}
```

### GET /cards/

Purpose: Get one card by id.

Response:

```json
{
  "code": 0,
  "message": "",
  "data": {
    "id": 1,
    "question": "string",
    "answer": "string",
    "tags": ["string"],
    "reviewCount": 0,
    "easeFactor": 2.5,
    "createdAt": "2026-04-06T12:00:00Z",
    "updatedAt": "2026-04-06T12:00:00Z"
  }
}
```

### PATCH /cards/

Purpose: Update one card (partial update).

Request (partial):

```json
{ "question": "string", "answer": "string", "tags": ["string"] }
```

Response:

```json
{
  "code": 0,
  "message": "",
  "data": {
    "id": 1,
    "question": "string",
    "answer": "string",
    "tags": ["string"],
    "reviewCount": 0,
    "easeFactor": 2.5,
    "createdAt": "2026-04-06T12:00:00Z",
    "updatedAt": "2026-04-06T12:00:00Z"
  }
}
```

### DELETE /cards/

Purpose: Delete one card.

Response:

```json
{ "code": 0, "message": "", "data": true }
```

---

## 2. Review

### POST /reviewEvents

Purpose: Create a review event and update `cards.reviewCount` and `cards.easeFactor`.

Rating range: **0 ~ 5** (team fixed)

Request:

```json
{ "cardId": 1, "rating": 5, "reviewTimeMs": 1200 }
```

Response:

```json
{
  "code": 0,
  "message": "",
  "data": {
    "reviewEventId": 10,
    "cardId": 1,
    "reviewCountAfter": 1,
    "easeFactorAfter": 2.6,
    "createdAt": "2026-04-06T12:00:00Z"
  }
}
```

---

## 3. VLM (DAG extraction)

### POST /vlm/extractDag

Purpose: Send input (text/image) to VLM and return a DAG JSON that conforms to `spec/vlm-dag-schema.json`.

Request (text example):

```json
{ "inputType": "text", "text": "..." }
```

Response:

```json
{
  "code": 0,
  "message": "",
  "data": {
    "schemaVersion": "1.0",
    "nodes": [],
    "edges": []
  }
}
```

Notes:

- The returned DAG must conform to `spec/vlm-dag-schema.json`.

---

## 4. Graph (rendering)

### GET /graph

Purpose: Get graph data for rendering (nodes + edges).

Response:

```json
{
  "code": 0,
  "message": "",
  "data": {
    "nodes": [
      {
        "id": "n1",
        "label": "Concept A",
        "type": "concept",
        "props": {},
        "createdAt": "2026-04-06T12:00:00Z"
      }
    ],
    "edges": [
      {
        "id": "e1",
        "source": "n1",
        "target": "n2",
        "relation": "causes",
        "props": {},
        "createdAt": "2026-04-06T12:00:00Z"
      }
    ]
  }
}
```
