import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class FamilyAltarService {
  constructor(private prisma: PrismaService) { }

  async findAll() {
    return this.prisma.familyAltar.findMany({
      orderBy: { date: 'desc' },
    });
  }

  async create(data: any) {
    return this.prisma.familyAltar.create({
      data: {
        title: data.title,
        date: new Date(data.date),
        description: data.description,
        bibleVerse: data.bibleVerse,
        content: data.content,
      }
    });
  }
}