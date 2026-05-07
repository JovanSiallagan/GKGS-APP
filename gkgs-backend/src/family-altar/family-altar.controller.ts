import { Controller, Get, Post, Body } from '@nestjs/common';
import { FamilyAltarService } from './family-altar.service';
import { CreateFamilyAltarDto } from './dto/create-family-altar.dto';

@Controller('family-altar')
export class FamilyAltarController {
  constructor(private readonly familyAltarService: FamilyAltarService) { }

  @Post()
  create(@Body() dto: CreateFamilyAltarDto) {
    return this.familyAltarService.create(dto);
  }

  @Get()
  findAll() {
    return this.familyAltarService.findAll();
  }
}