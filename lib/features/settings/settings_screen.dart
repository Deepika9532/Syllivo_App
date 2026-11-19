import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/srs/sm2.dart';
import '../curriculum/curriculum_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduler = ref.watch(schedulerProvider);
    final algo = scheduler is Sm2Scheduler ? 'sm2' : 'fsrs';
    final theme = ref.watch(themeModeProvider);
    final pass = ref.watch(passThresholdProvider);
    final roman = ref.watch(romanizationProvider);
    final t = Theme.of(context).textTheme;

    Widget header(String text) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(text, style: t.titleSmall),
        );

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(children: [
        header('Review algorithm'),
        RadioGroup<String>(
          key: const Key('algorithm-group'),
          groupValue: algo,
          onChanged: (v) => ref.read(schedulerProvider.notifier).use(v!),
          child: const Column(children: [
            RadioListTile<String>(
              value: 'fsrs',
              title: Text('FSRS (recommended)'),
              subtitle: Text(
                  'Models memory stability and difficulty per card. Used by '
                  'Anki; needs fewer reviews for the same retention.'),
            ),
            RadioListTile<String>(
              value: 'sm2',
              title: Text('SM-2 (classic)'),
              subtitle: Text(
                  'The original SuperMemo algorithm with an ease factor per card.'),
            ),
          ]),
        ),
        header('Course'),
        ListTile(
          title: Text('Pass mark for lessons and exams: $pass%'),
          subtitle: Slider(
            key: const Key('pass-slider'),
            value: pass.toDouble(),
            min: 50,
            max: 100,
            divisions: 10,
            label: '$pass%',
            onChanged: (v) =>
                ref.read(passThresholdProvider.notifier).set(v.round()),
          ),
        ),
        SwitchListTile(
          value: roman,
          title: const Text('Show Korean romanization'),
          subtitle: const Text('Helpful while learning Hangul. Turn it off to '
              'read Hangul on its own.'),
          onChanged: (v) => ref.read(romanizationProvider.notifier).set(v),
        ),
        header('Appearance'),
        RadioGroup<String>(
          groupValue: theme,
          onChanged: (v) => ref.read(themeModeProvider.notifier).set(v!),
          child: const Column(children: [
            RadioListTile<String>(
                value: 'system', title: Text('Follow system')),
            RadioListTile<String>(value: 'light', title: Text('Light')),
            RadioListTile<String>(value: 'dark', title: Text('Dark')),
          ]),
        ),
        header('About'),
        const ListTile(
          title: Text("Syllivo 3.0.0"),
          subtitle: Text(
              'Learn naturally. Speak confidently. Offline-first German & Korean learning. '
              'All progress is stored on this device.'),
        ),
      ]),
    );
  }
}
