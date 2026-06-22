import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateCommunityPostDto } from './dto/create-community-post.dto';

@Injectable()
export class CommunityPostService {
  constructor(private prisma: PrismaService) { }

  async create(createCommunityPostDto: CreateCommunityPostDto, userId: string) {
    return this.prisma.communityPost.create({
      data: {
        content: createCommunityPostDto.content,
        type: createCommunityPostDto.type,
        userId: userId,
      },
      include: {
        user: {
          select: { name: true }
        }
      }
    });
  }

  async findAll() {
    return this.prisma.communityPost.findMany({
      orderBy: { createdAt: 'desc' },
      include: {
        user: {
          select: { name: true }
        }
      }
    });
  }
}