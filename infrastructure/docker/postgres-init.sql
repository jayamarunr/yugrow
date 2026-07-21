-- Yugrow PostgreSQL initialization
-- Installs required extensions for the platform.

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";    -- UUID generation
CREATE EXTENSION IF NOT EXISTS "pgcrypto";     -- Encryption utilities
CREATE EXTENSION IF NOT EXISTS "pg_trgm";      -- Fuzzy text search
CREATE EXTENSION IF NOT EXISTS "vector";       -- AI embeddings (pgvector)
CREATE EXTENSION IF NOT EXISTS "citext";       -- Case-insensitive text
CREATE EXTENSION IF NOT EXISTS "unaccent";     -- Accent-insensitive search
