import { Module, OnModuleInit } from '@nestjs/common';
import { CommunicationController } from './communication.controller';
import { CommunicationService } from './communication.service';
import { EventBus as EventBusInstance } from '@core/event-bus';

@Module({
  controllers: [CommunicationController],
  providers: [CommunicationService],
  exports: [CommunicationService],
})
export class CommunicationModule implements OnModuleInit {
  constructor(private readonly communicationService: CommunicationService) {}

  async onModuleInit() {
    // Seed the Yugrow system persona at startup
    await this.communicationService.ensureSystemPersona();

    // Subscribe to person registration — auto-create Yugrow chat
    EventBusInstance.subscribe('Identity.Person.Registered', async (event) => {
      const { personId } = event.data;
      if (personId) {
        try {
          await this.communicationService.initSystemConversation(personId);
        } catch (err) {
          console.error('[Communication] Failed to init system conversation:', err);
        }
      }
    });

    console.log('[Communication] Subscribed to Identity.Person.Registered');
  }
}
