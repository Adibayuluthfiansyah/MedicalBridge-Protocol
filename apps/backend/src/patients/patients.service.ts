import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { Prisma } from '@prisma/client';

@Injectable()
export class PatientsService {
  constructor(private readonly prisma: PrismaService) {}

  async create(data: Prisma.PatientCreateInput) {
    return this.prisma.patient.create({ data });
  }

  async findAll() {
    return this.prisma.patient.findMany({
      take: 10,
      orderBy: { createdAt: 'desc' },
    });
  }

  async findOne(id: string) {
    return this.prisma.patient.findUnique({
      where: { id },
      include: {
        medicalRecords: {
          include: {
            doctor: true,
          },
        },
      },
    });
  }

  async update(id: string, data: Prisma.PatientUpdateInput) {
    return this.prisma.patient.update({
      where: { id },
      data,
    });
  }

  async remove(id: string) {
    return this.prisma.patient.delete({
      where: { id },
    });
  }
}
