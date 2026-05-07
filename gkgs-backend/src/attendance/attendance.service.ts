import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { CreateAttendanceDto } from './dto/create-attendance.dto';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class AttendanceService {
  constructor(private prisma: PrismaService) { }

  async create(dto: CreateAttendanceDto) {
    const { userId, eventId } = dto;

    const event = await this.prisma.event.findUnique({
      where: { id: eventId },
    });

    if (!event) throw new NotFoundException('Acara tidak ditemukan');

    const today = new Date();
    const eventDate = new Date(event.date);

    // Validasi: Harus absen di hari yang sama
    if (today.toDateString() !== eventDate.toDateString()) {
      throw new BadRequestException('Gagal absen: Di luar jadwal acara');
    }

    return this.prisma.attendance.create({
      data: { userId, eventId },
    });
  }

  findAll() {
    return this.prisma.attendance.findMany({
      include: { user: true, event: true }
    });
  }
}