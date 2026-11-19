import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/lang.dart';
import '../../core/providers.dart';
import '../../core/widgets/syllivo_widgets.dart';
import '../auth/account_widgets.dart';
import '../auth/auth_providers.dart';
import '../auth/auth_service.dart';
import '../auth/login_screen.dart';
import '../curriculum/curriculum_providers.dart';
import '../gamification/game_providers.dart';
import '../gamification/game_widgets.dart';
import '../home/language_picker.dart';

/// Profile: identity, account, learning preferences, app settings, legal.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _editName(
      BuildContext context, WidgetRef ref, String current) async {
    final c = TextEditingController(text: current);
    final v = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Your name'),
        content: TextField(
          key: const Key('profile-name-field'),
          controller: c,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, c.text),
              child: const Text('Save')),
        ],
      ),
    );
    if (v != null) ref.read(profileProvider.notifier).setName(v);
  }

  Future<void> _linkGoogle(BuildContext context, WidgetRef ref) async {
    if (!ref.read(authServiceProvider).available) {
      showAuthError(context, notConfiguredMessage);
      return;
    }
    try {
      final u = await ref.read(authControllerProvider).signInWithGoogle();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Signed in as ${u.email ?? u.name}. All your progress was kept.')));
      }
    } on AuthFailure catch (e) {
      if (context.mounted && !e.cancelled) showAuthError(context, e.message);
    }
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text(
            'Your learning progress stays on this device. You can sign in again '
            'or continue as a guest.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
              key: const Key('confirm-sign-out'),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Sign out')),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(authControllerProvider).signOut();
    if (context.mounted) context.go('/login');
  }

  Future<void> _delete(BuildContext context, WidgetRef ref,
      {required bool signedIn}) async {
    var erase = !signedIn;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(signedIn ? 'Delete account?' : 'Erase all progress?'),
          content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(signedIn
                    ? 'This permanently deletes your Syllivo sign-in account. This cannot be undone.'
                    : 'This permanently erases your XP, streaks, lessons and history on this device.'),
                if (signedIn)
                  CheckboxListTile(
                    key: const Key('erase-local'),
                    contentPadding: EdgeInsets.zero,
                    value: erase,
                    onChanged: (v) => setState(() => erase = v ?? false),
                    title: const Text(
                        'Also erase learning progress on this device'),
                  ),
              ]),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel')),
            FilledButton(
              key: const Key('confirm-delete'),
              style:
                  FilledButton.styleFrom(backgroundColor: SyllivoColors.error),
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(signedIn ? 'Delete account' : 'Erase'),
            ),
          ],
        ),
      ),
    );
    if (ok != true) return;
    try {
      if (signedIn) {
        await ref
            .read(authControllerProvider)
            .deleteAccount(eraseLocalData: erase);
      } else {
        await ref
            .read(databaseProvider)
            .eraseLearningData(ref.read(clockProvider)());
        ref.read(profileProvider.notifier).resetAll();
        ref.read(authChoiceProvider.notifier).set(null);
      }
      for (final l in languages.keys) {
        ref.invalidate(learnStateProvider(l));
      }
      if (context.mounted) {
        context.go('/login');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                signedIn ? 'Your account was deleted.' : 'Progress erased.')));
      }
    } on AuthFailure catch (e) {
      if (context.mounted) showAuthError(context, e.message);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(profileProvider);
    final account = ref.watch(accountProvider).valueOrNull;
    final lang = ref.watch(languageProvider);
    final xp = ref.watch(totalXpProvider).valueOrNull ?? 0;
    final streak = ref.watch(streakProvider).valueOrNull ?? 0;
    final theme = ref.watch(themeModeProvider);
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final signedIn = account != null;
    final displayName =
        p.name.isNotEmpty ? p.name : (account?.displayName ?? 'Learner');

    Widget group(List<Widget> children) => Card(
          child: Column(children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) const Divider(height: 1, indent: 56),
              children[i],
            ],
          ]),
        );

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          children: [
            // Identity
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  const AccountAvatar(size: 88),
                  const SizedBox(height: 12),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Flexible(
                        child: Text(displayName,
                            key: const Key('profile-name'),
                            style: t.headlineSmall,
                            overflow: TextOverflow.ellipsis)),
                    IconButton(
                      tooltip: 'Edit name',
                      icon: const Icon(Icons.edit_rounded, size: 20),
                      onPressed: () => _editName(context, ref, p.name),
                    ),
                  ]),
                  Text(
                      account?.email ?? 'Guest — progress saved on this device',
                      key: const Key('profile-email'),
                      style:
                          t.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
                  const SizedBox(height: 16),
                  Row(children: [
                    _Mini(
                        value: '$xp',
                        label: 'Total XP',
                        icon: Icons.bolt_rounded,
                        color: SyllivoColors.amber),
                    _Mini(
                        value: '$streak',
                        label: 'Day streak',
                        icon: Icons.local_fire_department_rounded,
                        color: const Color(0xFFF97316)),
                    _Mini(
                        value: '${p.bestStreak}',
                        label: 'Best streak',
                        icon: Icons.emoji_events_rounded,
                        color: SyllivoColors.indigo),
                  ]),
                  if (account?.photoUrl == null) ...[
                    const SizedBox(height: 16),
                    Text('Avatar', style: t.labelLarge),
                    const SizedBox(height: 8),
                    Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        children: [
                          for (var i = 0; i < avatarStyles.length; i++)
                            Semantics(
                              button: true,
                              selected: p.avatar == i,
                              label: 'Avatar ${i + 1}',
                              child: Pressable(
                                onTap: () => ref
                                    .read(profileProvider.notifier)
                                    .setAvatar(i),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: p.avatar == i
                                            ? cs.primary
                                            : Colors.transparent,
                                        width: 2.5),
                                  ),
                                  child: ProfileAvatar(
                                      style: i, name: '', size: 40),
                                ),
                              ),
                            ),
                        ]),
                  ],
                ]),
              ),
            ),

            const SectionHeader('Account'),
            group([
              if (signedIn) ...[
                ListTile(
                  leading: Icon(account.provider == 'google'
                      ? Icons.account_circle_rounded
                      : Icons.mail_rounded),
                  title: Text(account.provider == 'google'
                      ? 'Signed in with Google'
                      : 'Signed in with email'),
                  subtitle: Text(account.accountCreatedAt == null
                      ? account.email ?? ''
                      : 'Member since ${MaterialLocalizations.of(context).formatMediumDate(account.accountCreatedAt!)}'),
                ),
                ListTile(
                  key: const Key('sign-out'),
                  leading: const Icon(Icons.logout_rounded),
                  title: const Text('Sign out'),
                  onTap: () => _signOut(context, ref),
                ),
              ] else
                ListTile(
                  key: const Key('link-google'),
                  leading: const GoogleMark(size: 22),
                  title: const Text('Sign in with Google'),
                  subtitle: const Text('Keep all your current progress'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _linkGoogle(context, ref),
                ),
              ListTile(
                key: const Key('delete-account'),
                leading: const Icon(Icons.delete_forever_rounded,
                    color: SyllivoColors.error),
                title: Text(signedIn ? 'Delete account' : 'Erase all progress',
                    style: const TextStyle(color: SyllivoColors.error)),
                onTap: () => _delete(context, ref, signedIn: signedIn),
              ),
            ]),

            const SectionHeader('Learning'),
            group([
              ListTile(
                key: const Key('profile-language'),
                leading: Text(languages[lang]!.flag,
                    style: const TextStyle(fontSize: 24)),
                title: const Text('Active language'),
                subtitle: Text(languages[lang]!.name),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => showLanguagePicker(context),
              ),
              ListTile(
                leading:
                    const Icon(Icons.bolt_rounded, color: SyllivoColors.amber),
                title: const Text('Daily goal'),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Wrap(spacing: 6, runSpacing: 6, children: [
                    for (final g in dailyGoalOptions)
                      ChoiceChip(
                        key: Key('goal-chip-${g.xp}'),
                        label: Text('${g.label} ${g.xp}'),
                        selected: p.dailyGoalXp == g.xp,
                        onSelected: (_) => ref
                            .read(profileProvider.notifier)
                            .setDailyGoal(g.xp),
                      ),
                  ]),
                ),
              ),
              SwitchListTile(
                key: const Key('hearts-switch'),
                secondary: const Icon(Icons.favorite_rounded,
                    color: SyllivoColors.coral),
                title: const Text('Hearts'),
                subtitle: const Text('Lose a heart per mistake in lessons'),
                value: p.heartsEnabled,
                onChanged: (v) =>
                    ref.read(profileProvider.notifier).setHeartsEnabled(v),
              ),
              ListTile(
                leading: const Icon(Icons.flag_rounded),
                title: const Text('Starting level & placement test'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push('/learn/$lang'),
              ),
            ]),

            const SectionHeader('App'),
            group([
              ListTile(
                leading: const Icon(Icons.palette_outlined),
                title: const Text('Theme'),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: SegmentedButton<String>(
                    key: const Key('theme-switch'),
                    segments: const [
                      ButtonSegment(value: 'system', label: Text('Auto')),
                      ButtonSegment(value: 'light', label: Text('Light')),
                      ButtonSegment(value: 'dark', label: Text('Dark')),
                    ],
                    selected: {theme},
                    showSelectedIcon: false,
                    onSelectionChanged: (s) =>
                        ref.read(themeModeProvider.notifier).set(s.first),
                  ),
                ),
              ),
              ListTile(
                key: const Key('open-settings'),
                leading: const Icon(Icons.tune_rounded),
                title: const Text('Learning settings'),
                subtitle:
                    const Text('Review algorithm, pass mark, romanization'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push('/settings'),
              ),
              ListTile(
                leading: const Icon(Icons.restart_alt_rounded),
                title: const Text('Run onboarding again'),
                subtitle: const Text('Your progress is kept'),
                onTap: () {
                  ref.read(profileProvider.notifier).restartOnboarding();
                  context.go('/onboarding');
                },
              ),
            ]),

            const SectionHeader('About'),
            group([
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('Privacy Policy'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push('/legal/privacy'),
              ),
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: const Text('Terms of Service'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push('/legal/terms'),
              ),
            ]),
            const SizedBox(height: 24),
            const Center(child: SyllivoLogo(size: 22)),
            const SizedBox(height: 4),
            Center(child: Text('Version 4.0.0', style: t.bodySmall)),
          ]),
    );
  }
}

class _Mini extends StatelessWidget {
  final String value, label;
  final IconData icon;
  final Color color;
  const _Mini(
      {required this.value,
      required this.label,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(children: [
          Icon(icon, color: color),
          const SizedBox(height: 2),
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w800)),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ]),
      );
}
