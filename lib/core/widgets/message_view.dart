import 'package:flutter/material.dart';

class MessageView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final Widget? action;

  const MessageView({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 64, color: t.colorScheme.primary),
          const SizedBox(height: 16),
          Text(title,
              style: t.textTheme.headlineSmall, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(body, style: t.textTheme.bodyLarge, textAlign: TextAlign.center),
          if (action != null) ...[const SizedBox(height: 24), action!],
        ]),
      ),
    );
  }
}
