// Yugrow Core — Base classes, guards, interceptors, filters, EventBus

export { EventBus } from './event-bus/index';

import {
  Injectable,
  CanActivate,
  ExecutionContext,
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpException,
  HttpStatus,
} from '@nestjs/common';
import { Request, Response } from 'express';

// ─── Custom Exception Hierarchy ─────────────────────────────────────

export class AppException extends Error {
  constructor(
    public readonly code: string,
    public readonly message: string,
    public readonly statusCode: number = 500,
    public readonly details?: Record<string, unknown>,
  ) {
    super(message);
    this.name = this.constructor.name;
  }
}

export class NotFoundException extends AppException {
  constructor(resource: string, id: string) {
    super('NOT_FOUND', `${resource} with id ${id} not found`, 404);
  }
}

export class ConflictException extends AppException {
  constructor(message: string) {
    super('CONFLICT', message, 409);
  }
}

export class ValidationException extends AppException {
  constructor(details: Record<string, unknown>) {
    super('VALIDATION_ERROR', 'Validation failed', 400, details);
  }
}

export class UnauthorizedException extends AppException {
  constructor(message = 'Unauthorized') {
    super('UNAUTHORIZED', message, 401);
  }
}

export class ForbiddenException extends AppException {
  constructor(message = 'Forbidden') {
    super('FORBIDDEN', message, 403);
  }
}

// ─── Global Exception Filter ────────────────────────────────────────

@Catch()
export class GlobalExceptionFilter implements ExceptionFilter {
  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();

    let status = HttpStatus.INTERNAL_SERVER_ERROR;
    let code = 'INTERNAL_ERROR';
    let message = 'An unexpected error occurred';
    let details: Record<string, unknown> | undefined;

    if (exception instanceof AppException) {
      status = exception.statusCode;
      code = exception.code;
      message = exception.message;
      details = exception.details;
    } else if (exception instanceof HttpException) {
      status = exception.getStatus();
      const res = exception.getResponse();
      if (typeof res === 'object' && res !== null) {
        message = (res as Record<string, unknown>).message as string || exception.message;
        code = (res as Record<string, unknown>).error as string || 'HTTP_ERROR';
      }
    }

    response.status(status).json({
      error: { code, message, details, path: request.url, timestamp: new Date().toISOString() },
    });
  }
}

// ─── JWT Auth Guard ─────────────────────────────────────────────────

@Injectable()
export class JwtAuthGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest();
    return !!request.user;
  }
}

// ─── Roles Guard ────────────────────────────────────────────────────

@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private readonly allowedRoles: string[]) {}

  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest();
    const user = request.user;
    if (!user) return false;
    return this.allowedRoles.includes(user.role);
  }
}
