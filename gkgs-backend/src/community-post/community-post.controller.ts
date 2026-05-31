import { Controller, Get, Post, Body, UseGuards, Request } from '@nestjs/common';
import { CommunityPostService } from './community-post.service';
import { CreateCommunityPostDto } from './dto/create-community-post.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard'; // Pastikan path importnya benar

@Controller('community-post')
export class CommunityPostController {
  constructor(private readonly communityPostService: CommunityPostService) { }

  // Endpoint untuk mengambil data (Bisa diakses tanpa login)
  @Get()
  findAll() {
    return this.communityPostService.findAll();
  }

  // Endpoint untuk membuat postingan (DILINDUNGI JWT!)
  @UseGuards(JwtAuthGuard)
  @Post()
  create(@Body() createCommunityPostDto: CreateCommunityPostDto, @Request() req) {
    // req.user berisi data dari jwt.strategy.ts (hasil extract token)
    const userId = req.user.userId;
    return this.communityPostService.create(createCommunityPostDto, userId);
  }
}