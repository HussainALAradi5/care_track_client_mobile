import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/leave_rules.dart';
import '../../../constants/texts/leave_texts.dart';
import '../../../controllers/workforce/leave_actions.dart';
import '../../../models/ui/confirm_config.dart';
import '../../../models/workforce/leave_request.dart';
import '../../common/feedback/app_snack.dart';
import '../../common/feedback/confirm_sheet.dart';
import '../../common/feedback/reason_sheet.dart';

/// What approving, rejecting and cancelling a leave request looks like, on every screen that offers them.
class LeaveRequestFlows {
  const LeaveRequestFlows._();

  static Future<void> approve(BuildContext context, WidgetRef ref, LeaveRequest request) async {
    await ref.read(leaveActionsProvider).decide(request, approve: true);
    if (context.mounted) AppSnack.success(context, LeaveTexts.approved(request.userName));
  }

  static Future<void> reject(BuildContext context, WidgetRef ref, LeaveRequest request) async {
    final note = await showReasonSheet(
      context,
      ConfirmConfig(
        title: LeaveTexts.rejectTitle,
        message: LeaveTexts.rejectMessage(request.userName, LeaveTexts.days(request.days)),
        confirmLabel: LeaveTexts.reject,
        danger: true,
      ),
      reasonLabel: LeaveTexts.rejectReason,
      maxLength: LeaveRules.noteMax,
    );
    if (note == null) return;
    await ref.read(leaveActionsProvider).decide(request, approve: false, note: note);
    if (context.mounted) AppSnack.success(context, LeaveTexts.rejected(request.userName));
  }

  static Future<void> cancel(BuildContext context, WidgetRef ref, LeaveRequest request) async {
    final config = ConfirmConfig(
      title: LeaveTexts.cancelTitle,
      message: LeaveTexts.cancelMessage(LeaveTexts.days(request.days)),
      confirmLabel: LeaveTexts.cancel,
      danger: true,
    );
    if (!await showConfirmSheet(context, config)) return;
    await ref.read(leaveActionsProvider).cancel(request);
    if (context.mounted) AppSnack.success(context, LeaveTexts.cancelled);
  }
}
