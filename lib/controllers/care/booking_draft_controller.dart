import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/texts/common_texts.dart';
import '../../dtos/care/create_booking_request.dart';
import '../../models/care/booking_draft.dart';
import '../../models/care/time_slot.dart';
import '../../models/common/user_facing_error.dart';
import '../../validations/care/booking_interval.dart';
import '../core/service_providers.dart';
import 'bookings_controller.dart';
import 'care_team_controller.dart';
import 'patient_context_controller.dart';

const _lastStep = 3;

/// The booking wizard: Hospital → doctor → day and time → review and send.
class BookingDraftController extends Notifier<BookingDraft> {
  @override
  BookingDraft build() => BookingDraft();

  bool get canContinue {
    final draft = state;
    return switch (draft.step) {
      0 => ref.read(selectedHospitalProvider) != null,
      1 => (ref.read(bookableDoctorsProvider).value ?? const []).any((c) => c.id == draft.clinicianId),
      2 => draft.slot != null,
      _ => true,
    };
  }

  void next() {
    if (canContinue) state = state.copyWith(step: (state.step + 1).clamp(0, _lastStep));
  }

  void back() => state = state.copyWith(step: (state.step - 1).clamp(0, _lastStep));

  Future<void> chooseHospital(String hospitalId) async {
    if (ref.read(selectedHospitalProvider)?.id == hospitalId) return;
    await ref.read(patientContextProvider.notifier).select(hospitalId);
    state = state.copyWith(clinicianId: () => null, slot: () => null);
  }

  void chooseClinician(String clinicianId) => state = state.copyWith(clinicianId: () => clinicianId, slot: () => null);
  void chooseDay(DateTime day) => state = state.copyWith(day: day, slot: () => null);
  void chooseDuration(int minutes) => state = state.copyWith(durationMinutes: minutes, slot: () => null);
  void chooseSlot(TimeSlot slot) => state = state.copyWith(slot: () => slot);

  /// Sends the request; throws a readable message when the chosen time is no longer valid.
  Future<void> submit() async {
    final hospital = ref.read(selectedHospitalProvider);
    final draft = state;
    final slot = draft.slot;
    if (hospital == null || draft.clinicianId == null || slot == null) {
      throw const UserFacingError(CommonTexts.genericError);
    }
    if (!isValidBookingInterval(slot.startsAt, slot.endsAt, DateTime.now())) {
      state = draft.copyWith(step: 2, slot: () => null);
      throw UserFacingError(CommonTexts.errorCodes['BOOKING_INTERVAL_INVALID']!);
    }
    await ref
        .read(bookingServiceProvider)
        .create(hospital.id, CreateBookingRequest(clinicianId: draft.clinicianId!, startsAt: slot.startsAt, endsAt: slot.endsAt));
    ref.invalidate(bookingsProvider);
    state = BookingDraft();
  }
}

final bookingDraftProvider = NotifierProvider.autoDispose<BookingDraftController, BookingDraft>(
  BookingDraftController.new,
);
