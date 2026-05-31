import { Test, TestingModule } from '@nestjs/testing';
import { WartaService } from './warta.service';

describe('WartaService', () => {
  let service: WartaService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [WartaService],
    }).compile();

    service = module.get<WartaService>(WartaService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
