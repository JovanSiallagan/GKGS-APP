import { Controller, Get, Post, Body } from '@nestjs/common';
import { FamilyAltarService } from './family-altar.service';

@Controller('family-altar')
export class FamilyAltarController {
  constructor(private readonly familyAltarService: FamilyAltarService) {}

  @Get()
  findAll() {
    return this.familyAltarService.findAll();
  }

  @Post()
  create(@Body() data: any) {
    return this.familyAltarService.create(data);
  }
}