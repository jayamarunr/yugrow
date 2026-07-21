// ─── Yugrow File Storage Engine — HTTP Controller ───────────────────

import {
  Controller,
  Get,
  Post,
  Delete,
  Param,
  Query,
  UploadedFile,
  UseInterceptors,
  BadRequestException,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiTags, ApiConsumes } from '@nestjs/swagger';
import { FileStorageService } from './file-storage.service';
import { RequireCapability } from '../../common/decorators/capabilities.decorator';

@ApiTags('File Storage Engine')
@Controller('api/v1/files')
export class FileStorageController {
  constructor(private readonly storage: FileStorageService) {}

  @Post('upload/:workspaceId')
  @UseInterceptors(FileInterceptor('file'))
  @ApiConsumes('multipart/form-data')
  @RequireCapability('storage.files.upload')
  async upload(
    @Param('workspaceId') workspaceId: string,
    @UploadedFile() file: any,
  ) {
    if (!file) throw new BadRequestException('No file provided');
    return this.storage.upload(workspaceId, {
      originalname: file.originalname,
      buffer: file.buffer,
      mimetype: file.mimetype,
      size: file.size,
    }, 'current-person-id');
  }

  @Get(':id')
  async get(@Param('id') id: string) {
    return this.storage.getFile(id);
  }

  @Get('list/:workspaceId')
  async list(
    @Param('workspaceId') workspaceId: string,
    @Query('mimeType') mimeType?: string,
    @Query('limit') limit?: string,
  ) {
    return this.storage.listFiles(workspaceId, {
      mimeType,
      limit: limit ? parseInt(limit) : undefined,
    });
  }

  @Delete(':id')
  async delete(@Param('id') id: string) {
    return this.storage.deleteFile(id);
  }
}
