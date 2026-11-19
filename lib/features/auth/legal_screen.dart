import 'package:flutter/material.dart';

/// In-app Privacy Policy and Terms of Service. They describe what this
/// app actually does with data. Review them (and add your contact details)
/// before publishing.
class LegalScreen extends StatelessWidget {
  final String doc; // privacy | terms
  const LegalScreen({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    final privacy = doc == 'privacy';
    final sections = privacy ? _privacy : _terms;
    final t = Theme.of(context).textTheme;
    return Scaffold(
      appBar:
          AppBar(title: Text(privacy ? 'Privacy Policy' : 'Terms of Service')),
      body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Text('Last updated: November 2026', style: t.bodySmall),
            for (final (title, body) in sections) ...[
              const SizedBox(height: 20),
              Text(title, style: t.titleMedium),
              const SizedBox(height: 6),
              Text(body, style: t.bodyMedium?.copyWith(height: 1.5)),
            ],
          ]),
    );
  }
}

const _privacy = [
  (
    'What Syllivo stores on your device',
    'Your lessons, answers, scores, flashcard reviews, XP, streaks, missions, badges, '
        'study time, bookmarks and preferences are stored in a database on your device. '
        'Syllivo works fully offline and does not upload this learning data anywhere.'
  ),
  (
    'If you sign in',
    'Signing in with Google or email uses Google Firebase Authentication. Firebase '
        'receives your email address, and for Google sign-in your name and profile photo, '
        'to create and verify your account. Syllivo keeps a copy of your name, email, photo '
        'link and account ID on your device to show your profile. Passwords and sign-in '
        'tokens are handled by Google’s SDKs and are never stored by Syllivo.'
  ),
  (
    'Microphone and speech',
    'Speaking exercises use your device’s speech-recognition service only while you '
        'hold the microphone button. Depending on your device settings, that service may '
        'process audio on the device or on its provider’s servers. Syllivo stores only the '
        'recognised text and your score, never audio recordings.'
  ),
  (
    'No ads, no tracking',
    'Syllivo shows no advertising and contains no analytics or tracking SDKs.'
  ),
  (
    'Deleting your data',
    'Profile → Delete account removes your sign-in account and can also erase all '
        'learning data on this device. Uninstalling the app removes all local data.'
  ),
  ('Children', 'Syllivo is intended for learners aged 13 and over.'),
];

const _terms = [
  (
    'Using Syllivo',
    'Syllivo is a language-learning app for personal, non-commercial study. You may use '
        'it with or without an account.'
  ),
  (
    'Learning content',
    'Lessons, examinations and level summaries are practice materials. They are not '
        'official CEFR, Goethe-Institut, TestDaF or TOPIK assessments or certificates. '
        'Pronunciation scores come from automatic speech recognition and are a guide only.'
  ),
  (
    'Your account',
    'If you sign in, keep your account secure. You can delete your account at any time '
        'from Profile.'
  ),
  (
    'Availability',
    'The app is provided “as is”. Sign-in features need an internet connection; learning '
        'does not.'
  ),
  (
    'Changes',
    'These terms may be updated with new versions of the app. Continuing to use the app '
        'means you accept the updated terms.'
  ),
];
