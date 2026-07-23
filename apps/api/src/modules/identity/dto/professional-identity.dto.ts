// ─── Professional Identity DTO ──────────────────────────────────────
// Canonical profile — single source of truth for all profile data.

import {
  IsString, IsOptional, IsArray, IsBoolean, IsNumber, IsObject,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class UpdateProfessionalDto {
  @ApiPropertyOptional({ example: 'Rajesh Kumar' })
  @IsString()
  @IsOptional()
  name?: string;

  @ApiPropertyOptional({ example: 'Founder & CEO' })
  @IsString()
  @IsOptional()
  title?: string;

  @ApiPropertyOptional({ example: 'Kovai Automation' })
  @IsString()
  @IsOptional()
  company?: string;

  @ApiPropertyOptional({ example: '+91-9876543210' })
  @IsString()
  @IsOptional()
  phone?: string;

  @ApiPropertyOptional({ example: 'https://kovai-auto.com' })
  @IsString()
  @IsOptional()
  website?: string;

  @ApiPropertyOptional({ example: 'https://avatars.example.com/raj.jpg' })
  @IsString()
  @IsOptional()
  avatarUrl?: string;

  @ApiPropertyOptional({ example: 'Built Kovai Automation from a garage workshop to a 200-employee company.' })
  @IsString()
  @IsOptional()
  bio?: string;

  @ApiPropertyOptional({ example: ['Industrial Automation', 'Lean Manufacturing'] })
  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  skills?: string[];

  @ApiPropertyOptional({ example: 'Automation partners, distributors in South India' })
  @IsString()
  @IsOptional()
  lookingFor?: string;

  @ApiPropertyOptional({ example: ['Manufacturing', 'Technology'] })
  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  industries?: string[];
}

export class ProfessionalIdentityResponse {
  @ApiProperty()
  id: string;

  @ApiProperty()
  workspaceId: string;

  @ApiProperty()
  personId: string;

  @ApiProperty()
  name: string;

  @ApiPropertyOptional()
  title?: string;

  @ApiPropertyOptional()
  company?: string;

  @ApiPropertyOptional()
  avatarUrl?: string;

  @ApiPropertyOptional()
  bio?: string;

  @ApiProperty()
  skills: string[];

  @ApiPropertyOptional()
  lookingFor?: string;

  @ApiProperty()
  industries: string[];

  @ApiProperty()
  verified: boolean;

  @ApiProperty()
  recommendations: number;
}
