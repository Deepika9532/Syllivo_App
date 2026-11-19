import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../lang.dart';
import '../providers.dart';

/// Speaks [text] and shows a helpful message if the device voice is missing.
Future<void> speakSafely(
  BuildContext context,
  WidgetRef ref,
  String text,
  String lang, {
  bool slow = false,
}) async {
  try {
    await ref.read(ttsProvider).speak(text, lang, rate: slow ? 0.3 : 0.45);
  } catch (_) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Couldn’t play audio. Install the '
          '${languages[lang]!.name} text-to-speech voice in your device '
          'settings (Settings → Accessibility → Text-to-speech).'),
    ));
  }
}

class SpeakButton extends ConsumerWidget {
  final String text;
  final String lang;
  final bool slow;
  final double size;

  const SpeakButton(
      {super.key,
      required this.text,
      required this.lang,
      this.slow = false,
      this.size = 24});

  @override
  Widget build(BuildContext context, WidgetRef ref) => IconButton(
        tooltip: slow ? 'Play slowly' : 'Play',
        iconSize: size,
        icon: Icon(slow ? Icons.slow_motion_video : Icons.volume_up),
        onPressed: () => speakSafely(context, ref, text, lang, slow: slow),
      );
}
