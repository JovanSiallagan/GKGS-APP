import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateEventDto } from './dto/create-event.dto';

@Injectable()
export class EventService {
  constructor(private prisma: PrismaService) { }

  create(dto: CreateEventDto) {
    return this.prisma.event.create({
      data: {
        ...dto,
        date: new Date(dto.date), // Ubah string ke format Date
      },
    });
  }

  findAll() {
    // Sangat simpel! Prisma otomatis akan membawa data 'totalHadir'
    // bersama dengan id, title, description, dan date ke Flutter.
    return this.prisma.event.findMany({
      orderBy: {
        date: 'desc', // Mengurutkan dari acara yang paling baru
      },
    });
  }
}