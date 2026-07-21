// Yugrow Shared Types

// Common entity fields for all database models
export interface BaseEntity {
  id: string;
  orgId: string;
  createdAt: Date;
  updatedAt: Date;
  deletedAt?: Date;
}

// Standard API response wrapper
export interface ApiResponse<T> {
  data: T;
  meta?: {
    total?: number;
    page?: number;
    pageSize?: number;
    cursor?: string;
  };
}

// Standard API error
export interface ApiError {
  error: {
    code: string;
    message: string;
    details?: Record<string, unknown>;
  };
}

// Pagination parameters
export interface PaginationParams {
  cursor?: string;
  limit?: number;
  page?: number;
  pageSize?: number;
}

// User roles for RBAC
export enum UserRole {
  ADMIN = 'admin',
  MANAGER = 'manager',
  MEMBER = 'member',
  VIEWER = 'viewer',
}

// Tenant context injected by auth middleware
export interface TenantContext {
  orgId: string;
  userId: string;
  role: UserRole;
}

// JWT payload
export interface JwtPayload {
  sub: string;
  orgId: string;
  role: UserRole;
  iat?: number;
  exp?: number;
}
