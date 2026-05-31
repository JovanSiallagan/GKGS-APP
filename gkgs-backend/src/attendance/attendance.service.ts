import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class AttendanceService {
  constructor(private readonly prisma: PrismaService) { }

  async checkIn(userId: string, eventId: string) {
    // --- DEBUG: Cek isi parameter ---
    console.log('DEBUG - User ID:', userId);
    console.log('DEBUG - Event ID:', eventId);

    if (!userId) {
      throw new BadRequestException('User ID tidak ditemukan. Pastikan Anda sudah login.');
    }

    // 1. Pastikan ID acara (Event ID) tidak kosong
    if (!eventId) {
      throw new BadRequestException('ID Acara (QR Code) tidak valid.');
    }

    // 2. Cek apakah Acara tersebut benar-benar ada di database
    const event = await this.prisma.event.findUnique({
      where: { id: eventId },
    });

    if (!event) {
      throw new NotFoundException('Acara tidak ditemukan atau sudah berakhir.');
    }

    // 3. Cek apakah jemaat sudah absen sebelumnya (Mencegah double check-in)
    const existingAttendance = await this.prisma.attendance.findFirst({
      where: {
        userId: userId,
        eventId: eventId,
      },
    });

    if (existingAttendance) {
      throw new BadRequestException('Anda sudah terdaftar hadir di acara ini.');
    }

    // 4. Jika semua aman, catat kehadiran ke database (tabel Attendance)
    const attendance = await this.prisma.attendance.create({
      data: {
        user: { connect: { id: userId } },
        event: { connect: { id: eventId } },
      },
    });

    // ======================================================================
    // 5. UPDATE TOTAL HADIR DI TABEL EVENT (TAMBAH +1 SECARA FISIK DI DB)
    // ======================================================================
    await this.prisma.event.update({
      where: { id: eventId },
      data: {
        totalHadir: {
          increment: 1, // Ini akan otomatis menaikkan angka di Supabase
        },
      },
    });

    // 6. Kembalikan data yang DIBUTUHKAN oleh Flutter!
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