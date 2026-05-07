import { PartialType } from '@nestjs/mapped-types';
import { CreateFamilyAltarDto } from './create-family-altar.dto';

export class UpdateFamilyAltarDto extends PartialType(CreateFamilyAltarDto) {}
