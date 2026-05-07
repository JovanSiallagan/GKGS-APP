import { Controller, Get, Post, Body } from '@nestjs/common';
import { CommunityPostService } from './community-post.service';
import { CreateCommunityPostDto } from './dto/create-community-post.dto';

@Controller('community-post')
export class CommunityPostController {
  constructor(private readonly communityPostService: CommunityPostService) { }

  @Post()
  create(@Body() createCommunityPostDto: CreateCommunityPostDto) {
    return this.communityPostService.create(createCommunityPostDto);
  }

  @Get()
  findAll() {
    return this.communityPostService.findAll();
  }
}