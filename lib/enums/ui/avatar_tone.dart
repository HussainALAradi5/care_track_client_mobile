/// Colour treatment of an [Avatar] tile.
enum AvatarTone {
  /// Default: a soft primary tile.
  primary,

  /// A quieter tile for things that have not started yet.
  secondary,

  /// Filled primary, for the selected or currently active item.
  solid,

  /// Translucent, on a coloured (gradient) card.
  inverse,
}
