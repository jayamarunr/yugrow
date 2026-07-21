// ─── Identity Service Interface ─────────────────────────────────────
// Contract for the Identity Engine's public capabilities.

export interface IIdentityService {
  // Authentication
  login(email: string, password: string): Promise<AuthResult>;
  register(email: string, password: string, name: string): Promise<AuthResult>;
  refreshToken(refreshToken: string): Promise<AuthResult>;

  // User Management
  getCurrentUser(userId: string): Promise<UserProfile>;
  updateProfile(userId: string, data: Partial<UserProfile>): Promise<UserProfile>;
  deactivateUser(userId: string): Promise<void>;

  // Roles & Permissions
  createRole(orgId: string, name: string, description?: string): Promise<RoleResult>;
  assignRole(userId: string, orgId: string, roleId: string): Promise<void>;
}

export interface AuthResult {
  accessToken: string;
  refreshToken: string;
  user: UserProfile;
}

export interface UserProfile {
  id: string;
  email: string;
  firstName?: string;
  lastName?: string;
  status: string;
  memberships?: any[];
}

export interface RoleResult {
  id: string;
  name: string;
  description?: string;
}
