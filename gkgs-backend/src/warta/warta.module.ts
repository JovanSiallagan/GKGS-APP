import { Module } from '@nestjs/common';
import { WartaService } from './warta.service';
import { WartaController } from './warta.controller';

@Module({
  providers: [WartaService],
  controllers: [WartaController]
})
export class WartaModule {}
