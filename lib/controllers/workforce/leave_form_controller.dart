import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/leave_rules.dart';
import '../../constants/texts/leave_texts.dart';
import '../../dtos/workforce/create_leave_request.dart';
import '../../models/workforce/leave_balance.dart';
import '../../models/workforce/leave_draft.dart';
import '../../utilities/workforce/leave.dart';
import '../core/service_providers.dart';
import 'my_leave_controller.dart';

/// The Ask for leave form; it starts empty each time the screen opens.
class LeaveFormController extends Notifier<LeaveDraft> {
  @override
  LeaveDraft build() => const LeaveDraft();

  void setType(String? value) => state = state.copyWith(leaveTypeId: value);
  void setStart(DateTime value) => state = state.copyWith(start: value);
  void setEnd(DateTime value) => state = state.copyWith(end: value);
  void setReason(String value) => state = state.copyWith(reason: value);
  void removeSickNote() => state = state.withSickNote(null);

  /// From a sick note's Use for my leave: fills its days and picks a sick leave type (by name).
  Future<void> attachSickNote(String documentId) async {
    final note = await ref.read(writtenDocumentServiceProvider).mineById(documentId);
    final mine = await ref.read(myLeaveProvider.future);
    final balances = mine?.balances ?? const <LeaveBalance>[];
    final sick = balances.where((b) => b.name.toLowerCase().contains('sick')).firstOrNull ?? balances.firstOrNull;
    state = state.withSickNote(
      note,
      start: note.restFrom,
      end: note.restTo,
      leaveTypeId: state.leaveTypeId ?? sick?.leaveTypeId,
    );
  }

  int get chosenDays {
    final draft = state;
    return draft.start == null || draft.end == null ? 0 : leaveDays(draft.start!, draft.end!);
  }

  /// Why the chosen days cannot be asked for, before the server is asked.
  String? problem(List<LeaveBalance> balances) {
    final draft = state;
    final days = chosenDays;
    if (days == 0) return null;
    if (draft.start!.year != draft.end!.year) return LeaveTexts.oneYear;
    if (days > LeaveRules.maxDays) return LeaveTexts.tooLong;
    final left = balances.where((b) => b.leaveTypeId == draft.leaveTypeId).firstOrNull?.left;
    return left != null && days > left ? LeaveTexts.notEnough(left) : null;
  }

  Future<void> ask() async {
    final organizationId = ref.read(leaveOrganizationIdProvider);
    final draft = state;
    if (organizationId == null) return;
    final reason = draft.reason.trim();
    await ref
        .read(leaveServiceProvider)
        .ask(
          organizationId,
          CreateLeaveRequest(
            leaveTypeId: draft.leaveTypeId!,
            startDate: draft.start!,
            endDate: draft.end!,
            reason: reason.isEmpty ? null : reason,
            sickNoteId: draft.sickNote?.id,
          ),
        );
    state = LeaveDraft(leaveTypeId: draft.leaveTypeId);
    ref.invalidate(myLeaveProvider);
  }
}

final leaveFormProvider = NotifierProvider.autoDispose<LeaveFormController, LeaveDraft>(LeaveFormController.new);
