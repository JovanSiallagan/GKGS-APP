import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Mengaktifkan CORS secara eksplisit agar 100% aman di browser/web
  app.enableCors({
    origin: '*', 
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
    credentials: true,
  });

  // Mengaktifkan validasi global
  app.useGlobalPipes(new ValidationPipe({
    whitelist: true, 
    forbidNonWhitelisted: true, 
  }));

  // PENTING: Gunakan port dari Vercel saat online, dan 9425 saat di laptop
  const port = process.env.PORT || 9425;
  await app.listen(port);
}
bootstrap();