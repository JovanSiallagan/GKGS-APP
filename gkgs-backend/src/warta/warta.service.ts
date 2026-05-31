import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class WartaService {
  constructor(private prisma: PrismaService) {}

  async getLatestWarta() {
    return this.prisma.warta.findFirst({
      orderBy: { tanggal: 'desc' },
    });
  }
}
