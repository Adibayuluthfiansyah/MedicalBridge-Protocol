-- CreateEnum
CREATE TYPE "Role" AS ENUM ('ADMIN', 'STAFF', 'DOCTOR');

-- CreateEnum
CREATE TYPE "Gender" AS ENUM ('MALE', 'FEMALE');

-- CreateEnum
CREATE TYPE "SyncStatus" AS ENUM ('PENDING', 'VERIFIED', 'TAMPERED');

-- CreateTable
CREATE TABLE "users" (
    "id" SERIAL NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "password" VARCHAR(255) NOT NULL,
    "role" "Role" NOT NULL DEFAULT 'STAFF',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "doctors" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER,
    "name" VARCHAR(100) NOT NULL,
    "sip" VARCHAR(50) NOT NULL,
    "specialization" VARCHAR(100),
    "wallet_address" VARCHAR(255),
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "doctors_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "patients" (
    "id" UUID NOT NULL,
    "nik" VARCHAR(16),
    "bpjs_number" VARCHAR(20),
    "full_name" VARCHAR(100) NOT NULL,
    "date_of_birth" DATE,
    "gender" "Gender",
    "mother_name" VARCHAR(100),
    "phone_number" VARCHAR(15),
    "address" TEXT,
    "is_anonymous" BOOLEAN NOT NULL DEFAULT false,
    "temp_emergency_id" VARCHAR(50),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "patients_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "medical_records" (
    "id" UUID NOT NULL,
    "patient_id" UUID NOT NULL,
    "doctor_id" INTEGER NOT NULL,
    "diagnosis" TEXT,
    "treatment" TEXT,
    "prescription" TEXT,
    "local_hash" VARCHAR(255),
    "visit_date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "medical_records_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "blockchain_sync_logs" (
    "id" SERIAL NOT NULL,
    "medical_record_id" UUID NOT NULL,
    "transaction_hash" VARCHAR(255),
    "smart_contract_address" VARCHAR(255),
    "status" "SyncStatus" NOT NULL DEFAULT 'PENDING',
    "verified_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "blockchain_sync_logs_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "doctors_user_id_key" ON "doctors"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "patients_nik_key" ON "patients"("nik");

-- CreateIndex
CREATE UNIQUE INDEX "patients_bpjs_number_key" ON "patients"("bpjs_number");

-- CreateIndex
CREATE UNIQUE INDEX "patients_temp_emergency_id_key" ON "patients"("temp_emergency_id");

-- CreateIndex
CREATE INDEX "patients_nik_idx" ON "patients"("nik");

-- CreateIndex
CREATE INDEX "patients_full_name_date_of_birth_mother_name_idx" ON "patients"("full_name", "date_of_birth", "mother_name");

-- AddForeignKey
ALTER TABLE "doctors" ADD CONSTRAINT "doctors_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "medical_records" ADD CONSTRAINT "medical_records_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "medical_records" ADD CONSTRAINT "medical_records_doctor_id_fkey" FOREIGN KEY ("doctor_id") REFERENCES "doctors"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "blockchain_sync_logs" ADD CONSTRAINT "blockchain_sync_logs_medical_record_id_fkey" FOREIGN KEY ("medical_record_id") REFERENCES "medical_records"("id") ON DELETE CASCADE ON UPDATE CASCADE;
