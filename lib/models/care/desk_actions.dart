/// Desk actions open for one appointment right now.
class DeskActions {
  const DeskActions({required this.checkIn, required this.noShow, required this.notSeen});

  static const none = DeskActions(checkIn: false, noShow: false, notSeen: false);

  final bool checkIn;
  final bool noShow;
  final bool notSeen;

  bool get any => checkIn || noShow || notSeen;
}
