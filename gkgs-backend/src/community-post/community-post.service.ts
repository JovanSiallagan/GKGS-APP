import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateCommunityPostDto } from './dto/create-community-post.dto';

@Injectable()
export class CommunityPostService {
  constructor(private prisma: PrismaService) {}

  create(dto: CreateCommunityPostDto) {
    return this.prisma.communityPost.create({
      data: { ...dto, isAnon: dto.isAnon ?? false },
    });
  }

  findAll() {
    return this.prisma.communityPost.findMany({
      orderBy: { createdAt: 'desc' },
      include: { user: { select: { name: true } } }
    });
  }
}