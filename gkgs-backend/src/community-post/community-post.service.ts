import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateCommunityPostDto } from './dto/create-community-post.dto';

@Injectable()
export class CommunityPostService {
  constructor(private prisma: PrismaService) { }

  // Logika untuk mengirim postingan baru
  async create(createCommunityPostDto: CreateCommunityPostDto, userId: string) {
    return this.prisma.communityPost.create({
      data: {
        content: createCommunityPostDto.content,
        type: createCommunityPostDto.type,
        userId: userId, // ID User diambil dari token JWT yang sedang login
      },
      include: {
        user: {
          select: { name: true } // Mengembalikan nama pembuat postingan
        }
      }
    });
  }

  // Logika untuk mengambil semua postingan
  async findAll() {
    return this.prisma.communityPost.findMany({
      orderBy: { createdAt: 'desc' }, // Urutkan dari yang paling baru
      include: {
        user: {
          select: { name: true } // Menampilkan nama pembuatnya
        }
      }
    });
  }
}