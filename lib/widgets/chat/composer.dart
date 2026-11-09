import 'package:flutter/material.dart';

import '../../constants/app_spacing.dart';
import '../../constants/texts/chat_texts.dart';

/// The message box of a thread: attach, write, send. While editing it holds the message's text.
class Composer extends StatefulWidget {
  const Composer({
    super.key,
    required this.onSend,
    this.onChanged,
    this.onAttach,
    this.editingText,
    this.canSendEmpty = false,
    this.blocked = false,
  });

  final ValueChanged<String> onSend;
  final VoidCallback? onChanged;
  final VoidCallback? onAttach;

  /// The text of the message being edited; null when writing a new one.
  final String? editingText;

  /// Ready attachments mean a message can go with no text.
  final bool canSendEmpty;

  /// A file is still uploading.
  final bool blocked;

  @override
  State<Composer> createState() => _ComposerState();
}

class _ComposerState extends State<Composer> {
  final _controller = TextEditingController();

  @override
  void didUpdateWidget(Composer old) {
    super.didUpdateWidget(old);
    if (widget.editingText != old.editingText) _controller.text = widget.editingText ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (widget.blocked || (text.isEmpty && !widget.canSendEmpty)) return;
    _controller.clear();
    widget.onSend(text);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.tiny, AppSpacing.tiny, AppSpacing.small, AppSpacing.small),
        child: Row(
          children: [
            if (widget.onAttach != null)
              IconButton(
                tooltip: ChatTexts.attach,
                onPressed: widget.onAttach,
                icon: const Icon(Icons.attach_file_rounded),
              ),
            Expanded(
              child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(hintText: ChatTexts.composerHint),
                onChanged: (_) => widget.onChanged?.call(),
              ),
            ),
            IconButton(
              tooltip: ChatTexts.send,
              onPressed: _send,
              icon: const Icon(Icons.send_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
