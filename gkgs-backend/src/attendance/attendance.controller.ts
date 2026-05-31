import { Controller, Post, Body, Req, UseGuards } from '@nestjs/common';
import { AttendanceService } from './attendance.service';
import { AuthGuard } from '@nestjs/passport'; // Mengamankan rute dengan JWT

@Controller('attendance')
export class AttendanceController {
  constructor(private readonly attendanceService: AttendanceService) { }

  // Memastikan yang absen harus punya token login
  @UseGuards(AuthGuard('jwt'))
  @Post('check-in')
  checkIn(@Req() req, @Body('eventId') eventId: string) {
    // jwt.strategy.ts mengembalikan payload berupa { userId: ..., email: ..., name: ... }
    const userId = req.user?.userId;

    return this.attendanceService.checkIn(userId, eventId);
  }
}