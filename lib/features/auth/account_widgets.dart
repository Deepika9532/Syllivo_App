import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../gamification/game_providers.dart';
import '../gamification/game_widgets.dart';
import 'auth_providers.dart';

/// Shows the Google profile photo when signed in (falling back to the
/// chosen avatar offline or for guests).
class AccountAvatar extends ConsumerWidget {
  final double size;
  const AccountAvatar({super.key, this.size = 48});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final account = ref.watch(accountProvider).valueOrNull;
    final fallback =
        ProfileAvatar(style: profile.avatar, name: profile.name, size: size);
    final url = account?.photoUrl;
    if (url == null || url.isEmpty) return fallback;
    return Semantics(
      label: 'Profile photo',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: size * 0.05),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 8,
                offset: const Offset(0, 3))
          ],
        ),
        child: ClipOval(
          child: Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => fallback,
            loadingBuilder: (_, child, progress) =>
                progress == null ? child : fallback,
          ),
        ),
      ),
    );
  }
}
