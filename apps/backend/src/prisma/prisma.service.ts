import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import { Pool } from 'pg';

@Injectable()
export class PrismaService implements OnModuleInit, OnModuleDestroy {
  private prisma: PrismaClient;

  constructor() {
    const connectionString = process.env.DATABASE_URL;
    const pool = new Pool({ connectionString });
    const adapter = new PrismaPg(pool);
    this.prisma = new PrismaClient({ adapter });
  }

  async onModuleInit() {
    await this.prisma.$connect();
    console.log('✅ Database connected successfully');
  }

  async onModuleDestroy() {
    await this.prisma.$disconnect();
  }

  // Expose prisma client methods
  get patient() {
    return this.prisma.patient;
  }

  get doctor() {
    return this.prisma.doctor;
  }

  get user() {
    return this.prisma.user;
  }

  get medicalRecord() {
    return this.prisma.medicalRecord;
  }

  get blockchainSyncLog() {
    return this.prisma.blockchainSyncLog;
  }
}
