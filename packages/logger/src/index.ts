// Yugrow Pino Logger Module

import { LoggerModule } from 'nestjs-pino';
import { randomUUID } from 'crypto';

export const loggerConfig = LoggerModule.forRoot({
  pinoHttp: {
    transport:
      process.env.NODE_ENV !== 'production'
        ? { target: 'pino-pretty', options: { colorize: true } }
        : undefined,
    genReqId: () => randomUUID(),
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
