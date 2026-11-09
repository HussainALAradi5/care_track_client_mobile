import '../../models/chat/chat_message.dart';

/// Oldest first, as a thread shows them.
List<ChatMessage> orderedMessages(List<ChatMessage> messages) =>
    ([...messages]..sort((a, b) => a.sequence.compareTo(b.sequence)));

/// A page joined to what is held; the page wins for a message in both, since it is the newer copy.
List<ChatMessage> mergedMessages(List<ChatMessage> held, List<ChatMessage> page) =>
    orderedMessages([...{for (final m in [...held, ...page]) m.id: m}.values]);
