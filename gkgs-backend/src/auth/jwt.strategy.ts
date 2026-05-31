import { ExtractJwt, Strategy } from 'passport-jwt';
import { PassportStrategy } from '@nestjs/passport';
import { Injectable } from '@nestjs/common';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor() {
    super({
      // Mengambil token dari header "Authorization: Bearer <token>"
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      // Harus sama persis dengan yang ada di auth.module.ts
      secretOrKey: 'RAHASIA_GKGS_APP_123', 
    });
  }

  // Fungsi ini otomatis berjalan jika token valid
  async validate(payload: any) {
    // Return data user yang akan disisipkan ke dalam request
    // Nantinya kita bisa panggil request.user di Controller
    return { userId: payload.sub, email: payload.email, name: payload.name };
  }
}