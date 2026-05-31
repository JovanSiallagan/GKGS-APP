import { Test, TestingModule } from '@nestjs/testing';
import { WartaController } from './warta.controller';

describe('WartaController', () => {
  let controller: WartaController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [WartaController],
    }).compile();

    controller = module.get<WartaController>(WartaController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
