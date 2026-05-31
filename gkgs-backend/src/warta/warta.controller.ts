import { Controller, Get, UseGuards } from '@nestjs/common';
import { WartaService } from './warta.service';
import { AuthGuard } from '@nestjs/passport';

@Controller('warta')
export class WartaController {
  constructor(private readonly wartaService: WartaService) {}

  @UseGuards(AuthGuard('jwt'))
  @Get('latest')
  async getLatestWarta() {
    return this.wartaService.getLatestWarta();
  }
}
