import 'package:flutter/material.dart';

import '../enums/ui/status_tone.dart';

/// Tone and icon of each part of a visit's place: hospital, department and room.
abstract final class VisitPlaceStyles {
  static const hospital = (tone: StatusTone.info, icon: Icons.local_hospital_rounded);
  static const department = (tone: StatusTone.neutral, icon: Icons.medical_services_rounded);
  static const room = (tone: StatusTone.success, icon: Icons.meeting_room_rounded);
  static const plannedRoom = (tone: StatusTone.neutral, icon: Icons.meeting_room_outlined);
  static const noRoom = (tone: StatusTone.neutral, icon: Icons.door_front_door_outlined);
}
