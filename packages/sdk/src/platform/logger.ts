// ─── Platform SDK: Logger ───────────────────────────────────────────
// Structured logging for all engines and products.

export enum LogLevel {
  DEBUG = 'debug',
  INFO = 'info',
  WARN = 'warn',
  ERROR = 'error',
}

export interface LogEntry {
  level: LogLevel;
  message: string;
  module: string;
  action?: string;
  personId?: string;
  workspaceId?: string;
  requestId?: string;
  duration?: number;
  error?: any;
  metadata?: Record<string, any>;
  timestamp: string;
}

class LoggerSDK {
  private module: string;

  constructor(module: string) {
    this.module = module;
  }

  private log(level: LogLevel, message: string, data?: Partial<LogEntry>) {
    const entry: LogEntry = {
      level,
      message,
      module: this.module,
      timestamp: new Date().toISOString(),
      ...data,
    };

    const output = JSON.stringify(entry);

    switch (level) {
      case LogLevel.ERROR:
        console.error(output);
        break;
      case LogLevel.WARN:
        console.warn(output);
        break;
      default:
        console.log(output);
    }
  }

  info(message: string, data?: Partial<LogEntry>) { return this.log(LogLevel.INFO, message, data); }
  warn(message: string, data?: Partial<LogEntry>) { return this.log(LogLevel.WARN, message, data); }
  error(message: string, data?: Partial<LogEntry>) { return this.log(LogLevel.ERROR, message, data); }
  debug(message: string, data?: Partial<LogEntry>) { return this.log(LogLevel.DEBUG, message, data); }
}

export function createLogger(module: string): LoggerSDK {
  return new LoggerSDK(module);
}
