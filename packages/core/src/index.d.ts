export { EventBus } from './event-bus/index';
import { CanActivate, ExecutionContext, ExceptionFilter, ArgumentsHost } from '@nestjs/common';
export declare class AppException extends Error {
    readonly code: string;
    readonly message: string;
    readonly statusCode: number;
    readonly details?: Record<string, unknown> | undefined;
    constructor(code: string, message: string, statusCode?: number, details?: Record<string, unknown> | undefined);
}
export declare class NotFoundException extends AppException {
    constructor(resource: string, id: string);
}
export declare class ConflictException extends AppException {
    constructor(message: string);
}
export declare class ValidationException extends AppException {
    constructor(details: Record<string, unknown>);
}
export declare class UnauthorizedException extends AppException {
    constructor(message?: string);
}
export declare class ForbiddenException extends AppException {
    constructor(message?: string);
}
export declare class GlobalExceptionFilter implements ExceptionFilter {
    catch(exception: unknown, host: ArgumentsHost): void;
}
export declare class JwtAuthGuard implements CanActivate {
    canActivate(context: ExecutionContext): boolean;
}
export declare class RolesGuard implements CanActivate {
    private readonly allowedRoles;
    constructor(allowedRoles: string[]);
    canActivate(context: ExecutionContext): boolean;
}
