import 'dart:math';

final _random = Random.secure();

/// A random idempotency key for one message, so a retry can never create a second one.
String generateClientKey() =>
    List.generate(16, (_) => _random.nextInt(256).toRadixString(16).padLeft(2, '0')).join();
