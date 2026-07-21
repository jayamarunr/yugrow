// ─── Platform SDK: Event Bus ────────────────────────────────────────
// Platform event infrastructure. Currently in-memory.
// Will use RabbitMQ/Kafka at scale.

type EventHandler = (event: any) => Promise<void>;

interface YugrowEvent {
  specversion: string;
  id: string;
  source: string;
  type: string;
  datacontenttype: string;
  time: string;
  data: any;
}

class EventBusSDK {
  private handlers: Map<string, EventHandler[]> = new Map();
  private history: YugrowEvent[] = [];

  async publish(type: string, data: any): Promise<void> {
    const event: YugrowEvent = {
      specversion: '1.0',
      id: crypto.randomUUID(),
      source: `/yugrow/engine/${type.split('.')[0].toLowerCase()}`,
      type,
      datacontenttype: 'application/json',
      time: new Date().toISOString(),
      data,
    };

    this.history.push(event);
    const handlers = this.handlers.get(type) || [];
    await Promise.allSettled(
      handlers.map((h) => h(event).catch((e) => console.error(`[EventBus] Handler failed: ${type}`, e)))
    );
  }

  subscribe(type: string, handler: EventHandler): void {
    const handlers = this.handlers.get(type) || [];
    handlers.push(handler);
    this.handlers.set(type, handlers);
  }

  unsubscribe(type: string, handler: EventHandler): void {
    const handlers = this.handlers.get(type) || [];
    this.handlers.set(type, handlers.filter((h) => h !== handler));
  }

  getHistory(type?: string): YugrowEvent[] {
    if (type) return this.history.filter((e) => e.type === type);
    return this.history;
  }
}

export const eventBus = new EventBusSDK();
