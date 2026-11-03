import '../identity/enrolled_hospital.dart';

/// The patient's Hospitals and the one every patient screen works in.
class PatientContext {
  const PatientContext({required this.hospitals, required this.selectedId});

  final List<EnrolledHospital> hospitals;
  final String? selectedId;

  EnrolledHospital? get hospital {
    for (final h in hospitals) {
      if (h.id == selectedId) return h;
    }
    return hospitals.isEmpty ? null : hospitals.first;
  }
}
