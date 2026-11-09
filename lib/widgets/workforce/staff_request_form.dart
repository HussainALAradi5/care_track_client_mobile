import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/staff_request_rules.dart';
import '../../constants/texts/staff_request_texts.dart';
import '../../controllers/workforce/my_requests_controller.dart';
import '../../dtos/workforce/create_staff_request.dart';
import '../../enums/workforce/staff_request_type.dart';
import '../common/buttons/app_button.dart';
import '../common/feedback/app_snack.dart';

/// Raise a request to HR: its type and what is needed. Sending stays off until both are filled in.
class StaffRequestForm extends ConsumerStatefulWidget {
  const StaffRequestForm({super.key});

  @override
  ConsumerState<StaffRequestForm> createState() => _StaffRequestFormState();
}

class _StaffRequestFormState extends ConsumerState<StaffRequestForm> {
  final _details = TextEditingController();
  StaffRequestType? _type;

  @override
  void dispose() {
    _details.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    await ref.read(myRequestsProvider.notifier).add(CreateStaffRequest(type: _type!, details: _details.text));
    if (!mounted) return;
    _details.clear();
    setState(() => _type = null);
    AppSnack.success(context, StaffRequestTexts.sent);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canSend = _type != null && _details.text.trim().isNotEmpty;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              StaffRequestTexts.newRequest,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<StaffRequestType>(
              key: ValueKey(_type),
              initialValue: _type,
              decoration: const InputDecoration(labelText: StaffRequestTexts.type),
              items: [
                for (final entry in StaffRequestTexts.types.entries)
                  DropdownMenuItem(value: entry.key, child: Text(entry.value)),
              ],
              onChanged: (type) => setState(() => _type = type),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _details,
              minLines: 2,
              maxLines: 5,
              maxLength: StaffRequestRules.detailsMax,
              decoration: const InputDecoration(
                labelText: StaffRequestTexts.details,
                helperText: StaffRequestTexts.detailsHint,
                helperMaxLines: 2,
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            AppButton(
              label: StaffRequestTexts.send,
              icon: Icons.send_rounded,
              expand: true,
              onPressed: canSend ? _send : null,
            ),
          ],
        ),
      ),
    );
  }
}
