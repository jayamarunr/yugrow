"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.loggerConfig = void 0;
const nestjs_pino_1 = require("nestjs-pino");
const crypto_1 = require("crypto");
exports.loggerConfig = nestjs_pino_1.LoggerModule.forRoot({
    pinoHttp: {
        transport: process.env.NODE_ENV !== 'production'
            ? { target: 'pino-pretty', options: { colorize: true } }
            : undefined,
        genReqId: () => (0, crypto_1.randomUUID)(),
        autoLogging: true,
        serializers: {
            req: (req) => ({
                id: req.id,
                method: req.method,
                url: req.url,
            }),
            res: (res) => ({
                statusCode: res.statusCode,
            }),
        },
    },
});
//# sourceMappingURL=index.js.map