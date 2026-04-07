-- Purpose: PostgreSQL schema for MVP
-- Conventions:
-- - table names: lowercase (no quotes)
-- - column names: camelCase (MUST use double quotes in SQL)
-- - time columns: TIMESTAMPTZ, default now()

CREATE TABLE IF NOT EXISTS cards (
  id BIGSERIAL PRIMARY KEY,
  "question" TEXT NOT NULL,
  "answer" TEXT NOT NULL,
  "tags" JSONB NOT NULL DEFAULT '[]'::jsonb,

  "reviewCount" INT NOT NULL DEFAULT 0,
  "easeFactor" REAL NOT NULL DEFAULT 2.5,

  "createdAt" TIMESTAMPTZ NOT NULL DEFAULT now(),
  "updatedAt" TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_cards_createdAt ON cards ("createdAt" DESC);

-- Each review produces one event row (for heatmap/report/time series)
CREATE TABLE IF NOT EXISTS review_events (
  id BIGSERIAL PRIMARY KEY,
  "cardId" BIGINT NOT NULL REFERENCES cards(id) ON DELETE CASCADE,

  "rating" INT NOT NULL,     -- Decide range in spec: 0-5 or 1-5
  "reviewTimeMs" INT,
  "createdAt" TIMESTAMPTZ NOT NULL DEFAULT now(),

  "easeFactorAfter" REAL,
  "reviewCountAfter" INT
);

CREATE INDEX IF NOT EXISTS idx_review_events_cardId_createdAt
  ON review_events ("cardId", "createdAt" DESC);

-- Graph nodes (normalized)
CREATE TABLE IF NOT EXISTS graph_nodes (
  id TEXT PRIMARY KEY,
  "label" TEXT NOT NULL,
  "type" TEXT NOT NULL,
  "props" JSONB NOT NULL DEFAULT '{}'::jsonb,
  "createdAt" TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Graph edges (normalized)
CREATE TABLE IF NOT EXISTS graph_edges (
  id TEXT PRIMARY KEY,
  "source" TEXT NOT NULL REFERENCES graph_nodes(id) ON DELETE CASCADE,
  "target" TEXT NOT NULL REFERENCES graph_nodes(id) ON DELETE CASCADE,
  "relation" TEXT NOT NULL,
  "props" JSONB NOT NULL DEFAULT '{}'::jsonb,
  "createdAt" TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_graph_edges_source ON graph_edges ("source");
CREATE INDEX IF NOT EXISTS idx_graph_edges_target ON graph_edges ("target");