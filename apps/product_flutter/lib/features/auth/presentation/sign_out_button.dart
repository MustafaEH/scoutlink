import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scoutlink_product/features/auth/application/identity_providers.dart';
import 'package:scoutlink_product/features/auth/application/sign_out_service.dart';
import 'package:scoutlink_product/features/onboarding/application/onboarding_controller.dart';

class SignOutButton extends ConsumerStatefulWidget {
  const SignOutButton({super.key});

  @override
  ConsumerState<SignOutButton> createState() => _SignOutButtonState();
}

class _SignOutButtonState extends ConsumerState<SignOutButton> {
  bool busy = false;

  Future<void> _signOut() async {
    if (busy) return;
    setState(() => busy = true);
    try {
      await ref.read(signOutServiceProvider).signOut();
      ref.invalidate(identityProvider);
      ref.invalidate(onboardingControllerProvider);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'We could not sign you out. Check your connection and try again.',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: busy ? 'Signing out' : 'Sign out',
      onPressed: busy ? null : _signOut,
      icon: busy
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.logout),
    );
  }
}
