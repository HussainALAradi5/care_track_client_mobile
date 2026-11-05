import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

/// A document body: server-cleaned HTML (headings, emphasis, lists, alignment), read-only, in the app's text style.
class DocumentBody extends StatelessWidget {
  const DocumentBody({super.key, required this.html});

  final String? html;

  @override
  Widget build(BuildContext context) =>
      HtmlWidget((html ?? '').trim(), textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.55));
}
