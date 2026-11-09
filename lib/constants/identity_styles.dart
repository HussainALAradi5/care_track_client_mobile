import '../enums/identity/user_type.dart';

/// How account types read.
class IdentityStyles {
  const IdentityStyles._();

  static const userTypeLabels = {
    UserType.patient: 'Patient',
    UserType.doctor: 'Doctor',
    UserType.nurse: 'Nurse',
    UserType.pharmacist: 'Pharmacist',
    UserType.administrator: 'Administrator',
    UserType.employee: 'Employee',
    UserType.accountant: 'Accountant',
  };
}
