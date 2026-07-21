type EventHandler = (event: any) => Promise<void>;
declare class EventBusImpl {
    private handlers;
    private published;
    publish(type: string, data: any): Promise<void>;
    subscribe(type: string, handler: EventHandler): void;
    getHistory(): any[];
}
export declare const EventBus: EventBusImpl;
export {};
