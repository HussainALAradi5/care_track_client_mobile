import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/chat_constants.dart';
import '../../dtos/common/page_request.dart';
import '../../enums/chat/conversation_kind.dart';
import '../../interfaces/ui/search_loader.dart';
import '../../models/chat/chat_contact.dart';
import '../../models/chat/chat_hospital.dart';
import '../../models/ui/search_option.dart';
import '../auth/auth_controller.dart';
import '../core/service_providers.dart';
import 'chat_conversations_controller.dart';

/// The Hospitals where the caller may chat; empty signed out.
final chatHospitalsProvider = FutureProvider.autoDispose<List<ChatHospital>>((ref) async {
  if (ref.watch(signedInUserIdProvider) == null) return const [];
  return ref.read(chatServiceProvider).hospitals();
});

/// The contact picker: which Hospital, and starting a conversation with someone found there.
class NewConversationController extends Notifier<ChatHospital?> {
  final _kinds = <String, ConversationKind>{};

  @override
  ChatHospital? build() {
    ref.watch(signedInUserIdProvider);
    return null;
  }

  void chooseHospital(ChatHospital? hospital) => state = hospital;

  /// Only the people the server says the caller may reach, as they type.
  SearchLoader get contactLoader {
    final hospitalId = state?.hospitalId;
    return (term, page) async {
      final contacts = await ref
          .read(chatServiceProvider)
          .contacts(
            hospitalId!,
            PageRequest(
              page: page,
              pageSize: ChatConstants.contactsPageSize,
              filters: {'search': term.isEmpty ? null : term},
            ),
          );
      return contacts.map((ChatContact c) {
        _kinds[c.userId] = c.kind;
        return SearchOption(id: c.userId, label: c.name, detail: c.kind.label);
      });
    };
  }

  /// Starts or reopens a conversation; the returned id is opened.
  Future<String> startWith(SearchOption contact) =>
      _start(_kinds[contact.id] ?? ConversationKind.staff, targetUserId: contact.id);

  /// Asks patient support, which the server assigns.
  Future<String> startSupport() => _start(ConversationKind.patientSupport);

  Future<String> _start(ConversationKind kind, {String? targetUserId}) async {
    final conversation = await ref
        .read(chatServiceProvider)
        .start(hospitalId: state!.hospitalId, kind: kind, targetUserId: targetUserId);
    ref.read(chatConversationsProvider.notifier).upsert(conversation);
    return conversation.id;
  }
}

final newConversationProvider = NotifierProvider.autoDispose<NewConversationController, ChatHospital?>(
  NewConversationController.new,
);
