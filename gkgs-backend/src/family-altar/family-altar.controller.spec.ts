import { Test, TestingModule } from '@nestjs/testing';
import { FamilyAltarController } from './family-altar.controller';
import { FamilyAltarService } from './family-altar.service';

describe('FamilyAltarController', () => {
  let controller: FamilyAltarController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [FamilyAltarController],
      providers: [FamilyAltarService],
    }).compile();

    controller = module.get<FamilyAltarController>(FamilyAltarController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
