import 'package:flutter/material.dart';

/// A usual shift start (morning, day, evening, night) offered as one tap.
class ShiftQuickStart {
  const ShiftQuickStart({required this.label, required this.time, required this.icon});

  final String label;
  final TimeOfDay time;
  final IconData icon;
}
