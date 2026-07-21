"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.RolesGuard = exports.JwtAuthGuard = exports.GlobalExceptionFilter = exports.ForbiddenException = exports.UnauthorizedException = exports.ValidationException = exports.ConflictException = exports.NotFoundException = exports.AppException = exports.EventBus = void 0;
var index_1 = require("./event-bus/index");
Object.defineProperty(exports, "EventBus", { enumerable: true, get: function () { return index_1.EventBus; } });
const common_1 = require("@nestjs/common");
class AppException extends Error {
    constructor(code, message, statusCode = 500, details) {
        super(message);
        this.code = code;
        this.message = message;
        this.statusCode = statusCode;
        this.details = details;
        this.name = this.constructor.name;
    }
}
exports.AppException = AppException;
class NotFoundException extends AppException {
    constructor(resource, id) {
        super('NOT_FOUND', `${resource} with id ${id} not found`, 404);
    }
}
exports.NotFoundException = NotFoundException;
class ConflictException extends AppException {
    constructor(message) {
        super('CONFLICT', message, 409);
    }
}
exports.ConflictException = ConflictException;
class ValidationException extends AppException {
    constructor(details) {
        super('VALIDATION_ERROR', 'Validation failed', 400, details);
    }
}
exports.ValidationException = ValidationException;
class UnauthorizedException extends AppException {
    constructor(message = 'Unauthorized') {
        super('UNAUTHORIZED', message, 401);
    }
}
exports.UnauthorizedException = UnauthorizedException;
class ForbiddenException extends AppException {
    constructor(message = 'Forbidden') {
        super('FORBIDDEN', message, 403);
    }
}
exports.ForbiddenException = ForbiddenException;
let GlobalExceptionFilter = class GlobalExceptionFilter {
    catch(exception, host) {
        const ctx = host.switchToHttp();
        const response = ctx.getResponse();
        const request = ctx.getRequest();
        let status = common_1.HttpStatus.INTERNAL_SERVER_ERROR;
        let code = 'INTERNAL_ERROR';
        let message = 'An unexpected error occurred';
        let details;
        if (exception instanceof AppException) {
            status = exception.statusCode;
            code = exception.code;
            message = exception.message;
            details = exception.details;
        }
        else if (exception instanceof common_1.HttpException) {
            status = exception.getStatus();
            const res = exception.getResponse();
            if (typeof res === 'object' && res !== null) {
                message = res.message || exception.message;
                code = res.error || 'HTTP_ERROR';
            }
        }
        response.status(status).json({
            error: { code, message, details, path: request.url, timestamp: new Date().toISOString() },
        });
    }
};
exports.GlobalExceptionFilter = GlobalExceptionFilter;
exports.GlobalExceptionFilter = GlobalExceptionFilter = __decorate([
    (0, common_1.Catch)()
], GlobalExceptionFilter);
let JwtAuthGuard = class JwtAuthGuard {
    canActivate(context) {
        const request = context.switchToHttp().getRequest();
        return !!request.user;
    }
};
exports.JwtAuthGuard = JwtAuthGuard;
exports.JwtAuthGuard = JwtAuthGuard = __decorate([
    (0, common_1.Injectable)()
], JwtAuthGuard);
let RolesGuard = class RolesGuard {
    constructor(allowedRoles) {
        this.allowedRoles = allowedRoles;
    }
    canActivate(context) {
        const request = context.switchToHttp().getRequest();
        const user = request.user;
        if (!user)
            return false;
        return this.allowedRoles.includes(user.role);
    }
};
exports.RolesGuard = RolesGuard;
exports.RolesGuard = RolesGuard = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [Array])
], RolesGuard);
//# sourceMappingURL=index.js.map