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

  async findAll() {
    // 1. Minta Prisma mengambil data acara + jumlah absennya
    const events = await this.prisma.event.findMany({
      include: {
        _count: {
          select: { attendances: true }, // Menghitung dari relasi tabel Attendance
        },
      },
      orderBy: {
        date: 'desc' // (Bonus) Mengurutkan dari acara yang paling baru
      }
    });

    // 2. Format ulang bentuk JSON-nya agar lebih rapi untuk Flutter
    return events.map((event) => ({
      id: event.id,
      title: event.title,
      date: event.date,
      description: event.description,
      total_hadir: event._count.attendances, // Menyisipkan hasil hitungan ke variabel ini
    }));
  }
}