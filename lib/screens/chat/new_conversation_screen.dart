import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_spacing.dart';
import '../../constants/route_paths.dart';
import '../../constants/texts/chat_texts.dart';
import '../../controllers/chat/new_conversation_controller.dart';
import '../../enums/ui/button_variant.dart';
import '../../models/chat/chat_hospital.dart';
import '../../models/ui/search_option.dart';
import '../../widgets/chat/chat_action.dart';
import '../../widgets/common/buttons/app_button.dart';
import '../../widgets/common/feedback/async_body.dart';
import '../../widgets/common/feedback/empty_state.dart';
import '../../widgets/common/inputs/search_select_field.dart';

/// Starts a conversation with someone the server says the caller may reach, or asks patient support.
class NewConversationScreen extends ConsumerWidget {
  const NewConversationScreen({super.key});

  Future<void> _open(BuildContext context, Future<String> Function() start) => runChatAction(context, () async {
    final conversationId = await start();
    if (context.mounted) context.pushReplacement(RoutePaths.chatThread(conversationId));
  });

  Future<void> _chooseContact(BuildContext context, WidgetRef ref, SearchOption? contact) async {
    if (contact != null) await _open(context, () => ref.read(newConversationProvider.notifier).startWith(contact));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chosen = ref.watch(newConversationProvider);
    final controller = ref.read(newConversationProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text(ChatTexts.newConversation)),
      body: AsyncBody<List<ChatHospital>>(
        value: ref.watch(chatHospitalsProvider),
        onRetry: () => ref.invalidate(chatHospitalsProvider),
        data: (hospitals) => hospitals.isEmpty
            ? const EmptyState(icon: Icons.forum_outlined, title: ChatTexts.noContacts)
            : ListView(
                padding: AppSpacing.page,
                children: [
                  DropdownButtonFormField<ChatHospital>(
                    initialValue: chosen,
                    decoration: const InputDecoration(labelText: ChatTexts.chooseHospital),
                    items: [for (final h in hospitals) DropdownMenuItem(value: h, child: Text(h.name))],
                    onChanged: controller.chooseHospital,
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  SearchSelectField(
                    key: ValueKey(chosen?.hospitalId),
                    label: ChatTexts.searchPeople,
                    placeholder: ChatTexts.searchPeople,
                    icon: Icons.person_search_rounded,
                    value: null,
                    enabled: chosen != null,
                    load: controller.contactLoader,
                    onChanged: (contact) => _chooseContact(context, ref, contact),
                  ),
                  if (chosen?.patient ?? false) ...[
                    const SizedBox(height: AppSpacing.medium),
                    AppButton(
                      label: ChatTexts.patientSupport,
                      icon: Icons.support_agent_rounded,
                      variant: ButtonVariant.tonal,
                      expand: true,
                      onPressed: () => _open(context, controller.startSupport),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
