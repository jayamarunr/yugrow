import { PrismaClient } from '@prisma/client';
export declare const PRISMA = "PRISMA";
export declare const prismaProvider: {
    provide: string;
    useFactory: () => PrismaClient<{
        log: ("info" | "query" | "warn" | "error")[];
    }, never, import("node_modules/@prisma/client/runtime/library").DefaultArgs>;
};
export declare class DatabaseModule {
}
