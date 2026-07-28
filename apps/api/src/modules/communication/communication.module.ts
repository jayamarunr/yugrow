import { Module, OnModuleInit } from '@nestjs/common';
import { CommunicationController } from './communication.controller';
import { CommunicationService } from './communication.service';

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
  }
}
