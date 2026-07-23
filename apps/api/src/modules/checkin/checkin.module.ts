import { Module } from '@nestjs/common';
import { CheckinController } from './checkin.controller';
import { CheckinService } from './checkin.service';
import { CommunicationModule } from '../communication/communication.module';
import { IdentityModule } from '../identity/identity.module';

@Module({
  imports: [CommunicationModule, IdentityModule],
  controllers: [CheckinController],
  providers: [CheckinService],
  exports: [CheckinService],
})
export class CheckinModule {}
