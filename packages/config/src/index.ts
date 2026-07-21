// Yugrow Configuration Module

import { registerAs } from '@nestjs/config';

export default registerAs('app', () => ({
  port: parseInt(process.env.PORT || '4000', 10),
  nodeEnv: process.env.NODE_ENV || 'development',
}));

export const databaseConfig = registerAs('database', () => ({
  url: process.env.DATABASE_URL || 'postgresql://yugrow:yugrow@localhost:5432/yugrow',
}));

export const jwtConfig = registerAs('jwt', () => ({
  secret: process.env.JWT_SECRET || 'dev-secret-change-in-production',
  expiration: process.env.JWT_EXPIRATION || '15m',
  refreshExpiration: process.env.JWT_REFRESH_EXPIRATION || '7d',
}));

export const redisConfig = registerAs('redis', () => ({
  url: process.env.REDIS_URL || 'redis://localhost:6379',
}));

export const storageConfig = registerAs('storage', () => ({
  endpoint: process.env.STORAGE_ENDPOINT || 'http://localhost:9000',
  accessKey: process.env.STORAGE_ACCESS_KEY || 'yugrow',
  secretKey: process.env.STORAGE_SECRET_KEY || 'yugrow_secret',
  bucket: process.env.STORAGE_BUCKET || 'yugrow',
}));

export const configs = [databaseConfig, jwtConfig, redisConfig, storageConfig];
