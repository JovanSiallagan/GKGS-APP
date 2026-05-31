import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common'; // Tambahkan ini

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Mengaktifkan CORS untuk koneksi dari Flutter
  app.enableCors();

  // Mengaktifkan validasi global
  app.useGlobalPipes(new ValidationPipe({
    whitelist: true, // Otomatis membuang properti yang tidak ada di DTO
    forbidNonWhitelisted: true, // Menolak request jika ada properti aneh
  }));

  // Menjalankan di port 9425 sesuai di api_service.dart
  await app.listen(9425);
}
bootstrap();