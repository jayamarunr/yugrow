"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.EventBus = void 0;
class EventBusImpl {
    constructor() {
        this.handlers = new Map();
        this.published = [];
    }
    async publish(type, data) {
        const event = {
            specversion: '1.0',
            id: crypto.randomUUID(),
            source: `/yugrow/engine/${type.split('.')[0].toLowerCase()}`,
            type,
            datacontenttype: 'application/json',
            time: new Date().toISOString(),
            data,
        };
        this.published.push(event);
        const handlers = this.handlers.get(type) || [];
        await Promise.all(handlers.map((h) => h(event).catch((e) => console.error(`Event handler failed: ${type}`, e))));
    }
    subscribe(type, handler) {
        const handlers = this.handlers.get(type) || [];
        handlers.push(handler);
        this.handlers.set(type, handlers);
    }
    getHistory() {
        return this.published;
    }
}
exports.EventBus = new EventBusImpl();
//# sourceMappingURL=index.js.map