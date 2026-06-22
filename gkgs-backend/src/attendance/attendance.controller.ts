import { Controller, Post, Body, Req, UseGuards } from '@nestjs/common';
import { AttendanceService } from './attendance.service';
import { AuthGuard } from '@nestjs/passport';

@Controller('attendance')
export class AttendanceController {
  constructor(private readonly attendanceService: AttendanceService) { }

  @UseGuards(AuthGuard('jwt'))
  @Post('check-in')
  checkIn(@Req() req, @Body('eventId') eventId: string) {
    const userId = req.user?.userId;

    return this.attendanceService.checkIn(userId, eventId);
  }
}