// ─── Yugrow Event Bus ──────────────────────────────────────────────
// Platform event infrastructure. Currently in-memory for development.
// Will be replaced with RabbitMQ/Kafka as the platform scales.

type EventHandler = (event: any) => Promise<void>;

class EventBusImpl {
  private handlers: Map<string, EventHandler[]> = new Map();
  private published: any[] = [];

  async publish(type: string, data: any): Promise<void> {
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

  subscribe(type: string, handler: EventHandler): void {
    const handlers = this.handlers.get(type) || [];
    handlers.push(handler);
    this.handlers.set(type, handlers);
  }

  getHistory(): any[] {
    return this.published;
  }
}

export const EventBus = new EventBusImpl();
