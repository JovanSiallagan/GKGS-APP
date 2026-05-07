import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateFamilyAltarDto } from './dto/create-family-altar.dto';

@Injectable()
export class FamilyAltarService {
  constructor(private prisma: PrismaService) { }

  create(dto: CreateFamilyAltarDto) {
    const { date, ...rest } = dto; // Pisahkan 'date' dari data lainnya

    return this.prisma.familyAltar.create({
      data: {
        ...rest,
        date: new Date(date), // Ubah string tanggal menjadi format Date
      },
    });
  }

  findAll() {
    return this.prisma.familyAltar.findMany();
  }
}