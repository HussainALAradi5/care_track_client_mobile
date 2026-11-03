const _maxInitials = 2;

/// "Fatima Al Aradi" → "FA".
String initialsOf(String name) =>
    name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).take(_maxInitials).map((p) => p[0].toUpperCase()).join();
