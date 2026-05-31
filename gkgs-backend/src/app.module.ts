import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PrismaModule } from './prisma/prisma.module';
import { AttendanceModule } from './attendance/attendance.module';
import { UserModule } from './user/user.module';
import { EventModule } from './event/event.module';
import { CommunityPostModule } from './community-post/community-post.module';
import { FamilyAltarModule } from './family-altar/family-altar.module';
import { AuthModule } from './auth/auth.module';
import { WartaModule } from './warta/warta.module';

@Module({
  imports: [PrismaModule, AttendanceModule, UserModule, EventModule, CommunityPostModule, FamilyAltarModule, AuthModule, WartaModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
