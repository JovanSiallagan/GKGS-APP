import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { JwtModule } from '@nestjs/jwt';
import { PrismaService } from '../prisma/prisma.service';
import { JwtStrategy } from './jwt.strategy'; // <-- Import ini

@Module({
  imports: [
    JwtModule.register({
      global: true,
      secret: 'RAHASIA_GKGS_APP_123',
      signOptions: { expiresIn: '7d' },
    }),
  ],
  providers: [AuthService, PrismaService, JwtStrategy], // <-- Tambahkan di sini
  controllers: [AuthController],
})
export class AuthModule {}