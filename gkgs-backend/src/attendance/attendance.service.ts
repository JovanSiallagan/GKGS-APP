import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class AttendanceService {
  constructor(private readonly prisma: PrismaService) { }

  async checkIn(userId: string, eventId: string) {
    console.log('DEBUG - User ID:', userId);
    console.log('DEBUG - Event ID:', eventId);

    if (!userId) {
      throw new BadRequestException('User ID tidak ditemukan. Pastikan Anda sudah login.');
    }

    if (!eventId) {
      throw new BadRequestException('ID Acara (QR Code) tidak valid.');
    }

    const event = await this.prisma.event.findUnique({
      where: { id: eventId },
    });

    if (!event) {
      throw new NotFoundException('Acara tidak ditemukan atau sudah berakhir.');
    }

    const existingAttendance = await this.prisma.attendance.findFirst({
      where: {
        userId: userId,
        eventId: eventId,
      },
    });

    if (existingAttendance) {
      throw new BadRequestException('Anda sudah terdaftar hadir di acara ini.');
    }

    const attendance = await this.prisma.attendance.create({
      data: {
        user: { connect: { id: userId } },
        event: { connect: { id: eventId } },
      },
    });

    await this.prisma.event.update({
      where: { id: eventId },
      data: {
        totalHadir: {
          increment: 1,
        },
      },
    });
    return {
      success: true,
      message: 'Absensi berhasil',
      data: {
        title: event.title,
        description: event.description,
        date: event.date,
      }
    };
  }
}