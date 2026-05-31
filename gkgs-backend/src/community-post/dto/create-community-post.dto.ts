import { IsString, IsNotEmpty, IsEnum } from 'class-validator';
import { PostType } from '@prisma/client';

export class CreateCommunityPostDto {
  @IsString()
  @IsNotEmpty({ message: 'Konten postingan tidak boleh kosong' })
  content: string;

  @IsEnum(PostType, { message: 'Tipe harus PRAYER atau TESTIMONY' })
  type: PostType;
}