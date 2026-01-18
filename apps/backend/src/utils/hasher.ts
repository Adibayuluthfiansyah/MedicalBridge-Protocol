import * as crypto from 'crypto';

export const generateMedicalHash = (
  diagnosis: string,
  treatment: string,
  patientId: string,
): string => {
  const dataString = `${diagnosis}|${treatment}|${patientId}`;

  return crypto.createHash('sha256').update(dataString).digest('hex');
};
