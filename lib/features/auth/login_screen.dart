import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/widgets/companion.dart';
import '../../core/widgets/syllivo_widgets.dart';
import '../gamification/game_providers.dart';
import 'auth_providers.dart';
import 'auth_service.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _busy = false;

  void _next() =>
      context.go(ref.read(profileProvider).onboarded ? '/home' : '/onboarding');

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
      if (mounted) _next();
    } on AuthFailure catch (e) {
      if (mounted && !e.cancelled) showAuthError(context, e.message);
    } catch (e) {
      if (mounted) showAuthError(context, 'Sign-in failed: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _google() async {
    final auth = ref.read(authServiceProvider);
    if (!auth.available) {
      showAuthError(context, notConfiguredMessage);
      return;
    }
    await _run(() async {
      final user = await ref.read(authControllerProvider).signInWithGoogle();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Signed in as ${user.email ?? user.name ?? 'Google user'}. Your progress is saved to this account.'),
        ));
      }
    });
  }

  Future<void> _email() async {
    final auth = ref.read(authServiceProvider);
    if (!auth.available) {
      showAuthError(context, notConfiguredMessage);
      return;
    }
    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const EmailAuthSheet(),
    );
    if (ok == true && mounted) _next();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [cs.primaryContainer, cs.surface],
            begin: Alignment.topCenter,
            end: Alignment.center,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, c) => SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: c.maxHeight),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(children: [
                            const SizedBox(height: 32),
                            const SyllivoLogo(size: 30),
                            const SizedBox(height: 28),
                            Sylli(
                                size: min(180, c.maxHeight * 0.24),
                                mood: SylliMood.wave),
                            const SizedBox(height: 24),
                            Text('Your Language Journey Starts Here.',
                                key: const Key('login-title'),
                                textAlign: TextAlign.center,
                                style: t.headlineMedium),
                            const SizedBox(height: 10),
                            Text('Learn German and Korean, one day at a time.',
                                textAlign: TextAlign.center,
                                style: t.titleMedium
                                    ?.copyWith(color: cs.onSurfaceVariant)),
                          ]),
                          Column(children: [
                            const SizedBox(height: 32),
                            _GoogleButton(
                                onPressed: _busy ? null : _google, busy: _busy),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                key: const Key('email-sign-in'),
                                onPressed: _busy ? null : _email,
                                icon: const Icon(Icons.mail_outline_rounded),
                                label: const Text('Sign in with email'),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              key: const Key('continue-guest'),
                              onPressed: _busy
                                  ? null
                                  : () {
                                      ref
                                          .read(authControllerProvider)
                                          .continueAsGuest();
                                      _next();
                                    },
                              child: const Text('Continue as Guest'),
                            ),
                            Text(
                                'Guest progress stays on this device. You can sign in later from '
                                'Profile without losing anything.',
                                textAlign: TextAlign.center,
                                style: t.bodySmall),
                            const SizedBox(height: 16),
                            Wrap(alignment: WrapAlignment.center, children: [
                              TextButton(
                                  onPressed: () =>
                                      context.push('/legal/privacy'),
                                  child: const Text('Privacy Policy')),
                              TextButton(
                                  onPressed: () => context.push('/legal/terms'),
                                  child: const Text('Terms of Service')),
                            ]),
                            const SizedBox(height: 8),
                          ]),
                        ]),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showAuthError(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      key: const Key('auth-error'),
      content: Text(message),
      backgroundColor: SyllivoColors.navy,
      duration: const Duration(seconds: 6),
    ));
}

/// Standard "Continue with Google" button (white, with the G mark).
class _GoogleButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool busy;
  const _GoogleButton({required this.onPressed, required this.busy});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: FilledButton(
          key: const Key('google-sign-in'),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF1F1F1F),
            side: const BorderSide(color: Color(0xFF747775)),
            elevation: 0,
          ),
          onPressed: onPressed,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            if (busy)
              const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2))
            else
              const GoogleMark(size: 20),
            const SizedBox(width: 12),
            const Flexible(
                child: Text('Continue with Google',
                    maxLines: 1, overflow: TextOverflow.ellipsis)),
          ]),
        ),
      );
}

/// The four-colour Google "G", drawn in code.
class GoogleMark extends StatelessWidget {
  final double size;
  const GoogleMark({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _GPainter());
}

class _GPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final stroke = s * 0.2;
    final rect = Rect.fromLTWH(stroke / 2, stroke / 2, s - stroke, s - stroke);
    Paint p(Color c) => Paint()
      ..color = c
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    canvas.drawArc(rect, -0.25 * pi, -0.55 * pi, false,
        p(const Color(0xFFEA4335))); // red (top)
    canvas.drawArc(rect, -0.8 * pi, -0.45 * pi, false,
        p(const Color(0xFFFBBC05))); // yellow (left)
    canvas.drawArc(rect, 0.75 * pi, -0.75 * pi, false,
        p(const Color(0xFF34A853))); // green (bottom)
    canvas.drawArc(
        rect, 0, -0.08 * pi, false, p(const Color(0xFF4285F4))); // blue (right)
    canvas.drawRect(
        Rect.fromLTWH(s * 0.5, s * 0.4, s * 0.5 - stroke / 4, stroke),
        Paint()..color = const Color(0xFF4285F4));
    canvas.drawArc(rect, 0, 0.25 * pi, false, p(const Color(0xFF4285F4)));
  }

  @override
  bool shouldRepaint(_GPainter oldDelegate) => false;
}

/// Email sign-in / registration / password reset.
class EmailAuthSheet extends ConsumerStatefulWidget {
  const EmailAuthSheet({super.key});

  @override
  ConsumerState<EmailAuthSheet> createState() => _EmailAuthSheetState();
}

class _EmailAuthSheetState extends ConsumerState<EmailAuthSheet> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  bool _register = false;
  bool _busy = false;
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final c = ref.read(authControllerProvider);
      _register
          ? await c.register(_email.text, _password.text, _name.text)
          : await c.signInWithEmail(_email.text, _password.text);
      if (mounted) Navigator.pop(context, true);
    } on AuthFailure catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _reset() async {
    if (!_email.text.contains('@')) {
      setState(() => _error = 'Enter your email address first.');
      return;
    }
    try {
      await ref.read(authControllerProvider).sendPasswordReset(_email.text);
      setState(() => _error = null);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('Password reset email sent to ${_email.text.trim()}.')));
      }
    } on AuthFailure catch (e) {
      setState(() => _error = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(
          24, 0, 24, 24 + MediaQuery.viewInsetsOf(context).bottom),
      child: Form(
        key: _form,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(_register ? 'Create your account' : 'Sign in with email',
                  style: t.headlineSmall),
              const SizedBox(height: 16),
              if (_register) ...[
                TextFormField(
                  controller: _name,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person_outline)),
                ),
                const SizedBox(height: 12),
              ],
              TextFormField(
                key: const Key('email-field'),
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                decoration: const InputDecoration(
                    labelText: 'Email', prefixIcon: Icon(Icons.mail_outline)),
                validator: (v) => (v ?? '').contains('@')
                    ? null
                    : 'Enter a valid email address',
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const Key('password-field'),
                controller: _password,
                obscureText: _obscure,
                autofillHints: [
                  _register ? AutofillHints.newPassword : AutofillHints.password
                ],
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    tooltip: _obscure ? 'Show password' : 'Hide password',
                    icon: Icon(_obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
                validator: (v) =>
                    (v ?? '').length >= 6 ? null : 'At least 6 characters',
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!,
                    key: const Key('email-error'),
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error)),
              ],
              const SizedBox(height: 20),
              FilledButton(
                key: const Key('email-submit'),
                onPressed: _busy ? null : _submit,
                child: _busy
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : Text(_register ? 'Create account' : 'Sign in'),
              ),
              if (!_register)
                TextButton(
                    onPressed: _busy ? null : _reset,
                    child: const Text('Forgot password?')),
              TextButton(
                onPressed: _busy
                    ? null
                    : () => setState(() {
                          _register = !_register;
                          _error = null;
                        }),
                child: Text(_register
                    ? 'I already have an account'
                    : 'New here? Create an account'),
              ),
            ]),
      ),
    );
  }
}
