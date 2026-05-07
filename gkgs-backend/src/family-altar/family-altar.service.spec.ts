import { Test, TestingModule } from '@nestjs/testing';
import { FamilyAltarService } from './family-altar.service';

describe('FamilyAltarService', () => {
  let service: FamilyAltarService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [FamilyAltarService],
    }).compile();

    service = module.get<FamilyAltarService>(FamilyAltarService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
