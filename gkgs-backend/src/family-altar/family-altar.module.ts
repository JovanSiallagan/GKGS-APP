import { Module } from '@nestjs/common';
import { FamilyAltarService } from './family-altar.service';
import { FamilyAltarController } from './family-altar.controller';

@Module({
  controllers: [FamilyAltarController],
  providers: [FamilyAltarService],
})
export class FamilyAltarModule {}
