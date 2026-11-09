import 'package:flutter/material.dart';

import '../enums/facilities/hospital_type.dart';
import '../enums/facilities/opening_state.dart';
import '../enums/ui/status_tone.dart';
import '../models/ui/filter_option.dart';
import '../models/ui/status_style.dart';
import 'texts/care_mode_texts.dart';
import 'texts/hospital_texts.dart';

/// How opening states and hospital types read and look, on cards and filter chips.
class HospitalStyles {
  const HospitalStyles._();

  static const opening = <OpeningState, StatusStyle>{
    OpeningState.open24Hours: StatusStyle(label: 'Open 24 hours', tone: StatusTone.info, icon: Icons.all_inclusive_rounded),
    OpeningState.openNow: StatusStyle(label: 'Open now', tone: StatusTone.success, icon: Icons.door_front_door_rounded),
    OpeningState.closingSoon: StatusStyle(label: 'Closing soon', tone: StatusTone.warning, icon: Icons.hourglass_bottom_rounded),
    OpeningState.closedNow: StatusStyle(label: 'Closed now', tone: StatusTone.danger, icon: Icons.door_back_door_rounded),
  };

  static const type = <HospitalType, StatusStyle>{
    HospitalType.public: StatusStyle(label: 'Public · free', tone: StatusTone.info, icon: Icons.account_balance_rounded),
    HospitalType.private: StatusStyle(label: 'Private · paid', tone: StatusTone.neutral, icon: Icons.payments_rounded),
  };

  static const registered = StatusStyle(
    label: CareModeTexts.registered,
    tone: StatusTone.success,
    icon: Icons.how_to_reg_rounded,
  );

  static final openingFilters = <FilterOption<OpeningState>>[
    const FilterOption(value: null, label: HospitalTexts.all),
    for (final state in OpeningState.values) FilterOption(value: state, label: opening[state]!.label),
  ];

  static final typeFilters = <FilterOption<HospitalType>>[
    const FilterOption(value: null, label: HospitalTexts.publicAndPrivate),
    for (final kind in HospitalType.values) FilterOption(value: kind, label: type[kind]!.label),
  ];
}
