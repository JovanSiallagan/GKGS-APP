import { Controller, Get, Post, Body, UseGuards, Request } from '@nestjs/common';
import { CommunityPostService } from './community-post.service';
import { CreateCommunityPostDto } from './dto/create-community-post.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('community-post')
export class CommunityPostController {
  constructor(private readonly communityPostService: CommunityPostService) { }

  @Get()
  findAll() {
    return this.communityPostService.findAll();
  }

  @UseGuards(JwtAuthGuard)
  @Post()
  create(@Body() createCommunityPostDto: CreateCommunityPostDto, @Request() req) {
    const userId = req.user.userId;
    return this.communityPostService.create(createCommunityPostDto, userId);
  }
}