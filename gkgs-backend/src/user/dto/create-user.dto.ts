import { IsString, IsEmail, IsNotEmpty, MinLength } from 'class-validator';

export class CreateUserDto {
  @IsString()
  @IsNotEmpty({ message: 'Nama lengkap harus diisi' })
  name: string;

  @IsEmail({}, { message: 'Format email tidak valid' })
  @IsNotEmpty()
  email: string;

  @IsString()
  @MinLength(8, { message: 'Password minimal 8 karakter' }) // Sesuai hint di Flutter Anda
  password: string;
}