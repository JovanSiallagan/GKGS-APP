import { Controller, Post, Body, Get, Patch, Req, UseGuards, UnauthorizedException } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport'; 
import { UserService } from './user.service';
import { CreateUserDto } from './dto/create-user.dto';

@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Post('register')
  register(@Body() createUserDto: CreateUserDto) {
    return this.userService.register(createUserDto);
  }

  // Endpoint untuk mengambil profil
  @UseGuards(AuthGuard('jwt'))
  @Get('me')
  getProfile(@Req() req) {
    // KITA TAMBAHKAN req.user?.userId DI SINI
    const userId = req.user?.userId || req.user?.id || req.user?.sub; 
    
    if (!userId) {
       throw new UnauthorizedException('Token JWT tidak mengandung ID pengguna.');
    }
    
    return this.userService.getUserById(userId);
  }

  // Endpoint untuk mengubah profil
  @UseGuards(AuthGuard('jwt'))
  @Patch('me')
  updateProfile(@Req() req, @Body() updateData: any) {
    // KITA TAMBAHKAN req.user?.userId DI SINI
    const userId = req.user?.userId || req.user?.id || req.user?.sub;
    
    if (!userId) {
       throw new UnauthorizedException('Token JWT tidak mengandung ID pengguna.');
    }
    
    return this.userService.updateProfile(userId, updateData);
  }
}