import '../../constants/texts/hospital_texts.dart';
import '../../enums/facilities/opening_state.dart';
import '../../models/facilities/opening_status.dart';
import '../time/dates.dart';

/// When the state changes, on this device's clock: "Closes at 16:00" while open, "Opens today 08:00" or
/// "Opens Mon 08:00" while closed. Null for 24-hour hospitals and when no change is coming.
String? nextChangeLabel(OpeningStatus? opening, DateTime now) {
  final at = opening?.nextChangeAt?.toLocal();
  if (opening == null || at == null || opening.state == OpeningState.open24Hours) return null;
  final time = timeOfDayLabel(at);
  if (opening.state != OpeningState.closedNow) return HospitalTexts.closesAt(time);
  return HospitalTexts.opensAt(isSameDay(at, now) ? '${HospitalTexts.today} $time' : '${weekdayLabel(at)} $time');
}
