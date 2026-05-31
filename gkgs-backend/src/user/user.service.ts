import { Injectable, ConflictException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateUserDto } from './dto/create-user.dto';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UserService {
  constructor(private prisma: PrismaService) { }

  async register(createUserDto: CreateUserDto) {
    const existingUser = await this.prisma.user.findUnique({
      where: { email: createUserDto.email },
    });

    if (existingUser) {
      throw new ConflictException('Email ini sudah terdaftar!');
    }

    const saltRounds = 10;
    const hashedPassword = await bcrypt.hash(createUserDto.password, saltRounds);

    const user = await this.prisma.user.create({
      data: {
        name: createUserDto.name,
        email: createUserDto.email,
        password: hashedPassword,
      },
      select: {
        id: true,
        name: true,
        email: true,
        createdAt: true,
        updatedAt: true,
      }
    });

    return user;
  }

  // --- MENGAMBIL PROFIL LENGKAP ---
  async getUserById(id: string) {
    return this.prisma.user.findUnique({
      where: { id },
      select: {
        id: true,
        name: true,
        email: true,
        dob: true,      // Tampilkan Tanggal Lahir
        gender: true,   // Tampilkan Jenis Kelamin
        address: true,  // Tampilkan Alamat
        phone: true,    // Tampilkan Nomor Telepon
        // Password tetap disembunyikan
      }
    });
  }

  // --- MENYIMPAN PERUBAHAN PROFIL ---
  async updateProfile(userId: string, data: any) {
    // Jika ada tanggal lahir, pastikan formatnya diubah menjadi Date agar diterima Prisma
    if (data.dob) {
      data.dob = new Date(data.dob);
    }

    return this.prisma.user.update({
      where: { id: userId },
      data: {
        name: data.name,
        dob: data.dob,
        gender: data.gender,
        address: data.address,
        phone: data.phone,
      },
      // Kembalikan data terbaru setelah diupdate
      select: {
        id: true,
        name: true,
        email: true,
        dob: true,
        gender: true,
        address: true,
        phone: true,
      }
    });
  }
}