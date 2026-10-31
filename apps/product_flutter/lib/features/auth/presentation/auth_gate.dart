import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scoutlink_product/core/config/app_config.dart';
import 'package:scoutlink_product/features/auth/application/auth_providers.dart';
import 'package:scoutlink_product/features/auth/application/identity_providers.dart';
import 'package:scoutlink_product/features/home/presentation/home_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!AppConfig.isAuthConfigured) {
      return const _SetupRequiredScreen();
    }
    return ref
        .watch(authSessionProvider)
        .when(
          loading: () => const _LoadingScreen(),
          error: (error, _) => _ErrorScreen(message: error.toString()),
          data: (session) =>
              session == null ? const SignInScreen() : const _IdentityGate(),
        );
  }
}

class _IdentityGate extends ConsumerWidget {
  const _IdentityGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(identityProvider)
        .when(
          loading: () => const _LoadingScreen(),
          error: (error, _) => _ErrorScreen(
            message: 'We could not load your ScoutLink account.',
            onRetry: () => ref.invalidate(identityProvider),
          ),
          data: (identity) {
            if (identity == null || identity.roles.isEmpty) {
              return const RoleChoiceScreen();
            }
            return HomeScreen(
              role: WorkspaceRole.fromRoles(identity.roles),
              recruiterVerification: identity.recruiterVerification,
            );
          },
        );
  }
}

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final emailController = TextEditingController();
  bool submitting = false;
  String? message;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    final email = emailController.text.trim();
    if (!email.contains('@')) {
      setState(() => message = 'Enter a valid email address.');
      return;
    }
    setState(() {
      submitting = true;
      message = null;
    });
    try {
      await ref.read(authRepositoryProvider).sendMagicLink(email);
      if (mounted) {
        setState(
          () => message = 'Check your email for the secure sign-in link.',
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() => message = 'Sign-in could not be started. Try again.');
      }
    } finally {
      if (mounted) {
        setState(() => submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _CenteredPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sign in to ScoutLink',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          const Text('We will email you a secure, password-free sign-in link.'),
          const SizedBox(height: 28),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => submitting ? null : submit(),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: submitting ? null : submit,
            child: Text(submitting ? 'Sending…' : 'Send sign-in link'),
          ),
          if (message != null) ...[const SizedBox(height: 16), Text(message!)],
        ],
      ),
    );
  }
}

class RoleChoiceScreen extends ConsumerStatefulWidget {
  const RoleChoiceScreen({super.key});

  @override
  ConsumerState<RoleChoiceScreen> createState() => _RoleChoiceScreenState();
}

class _RoleChoiceScreenState extends ConsumerState<RoleChoiceScreen> {
  String? submittingRole;
  String? error;

  Future<void> choose(String role) async {
    setState(() {
      submittingRole = role;
      error = null;
    });
    try {
      await ref.read(identityRepositoryProvider)!.chooseRole(role);
      ref.invalidate(identityProvider);
    } catch (_) {
      if (mounted) {
        setState(() => error = 'We could not save that role. Try again.');
      }
    } finally {
      if (mounted) {
        setState(() => submittingRole = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const choices = [
      ('adult_player', 'Player aged 18–23', Icons.sports_soccer),
      ('guardian', 'Guardian of a minor player', Icons.family_restroom),
      ('recruiter', 'Football recruiter', Icons.manage_search),
      (
        'academy_representative',
        'Academy representative',
        Icons.shield_outlined,
      ),
    ];
    return _CenteredPage(
      maxWidth: 640,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How will you use ScoutLink?',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          const Text(
            'Choose your starting role. Staff permissions can never be self-assigned.',
          ),
          const SizedBox(height: 24),
          for (final choice in choices) ...[
            Card(
              child: ListTile(
                minTileHeight: 68,
                leading: Icon(choice.$3),
                title: Text(
                  choice.$2,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                trailing: submittingRole == choice.$1
                    ? const SizedBox.square(
                        dimension: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.arrow_forward),
                onTap: submittingRole == null ? () => choose(choice.$1) : null,
              ),
            ),
            const SizedBox(height: 10),
          ],
          if (error != null)
            Text(
              error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
        ],
      ),
    );
  }
}

class _SetupRequiredScreen extends StatelessWidget {
  const _SetupRequiredScreen();

  @override
  Widget build(BuildContext context) {
    return const _CenteredPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.construction, size: 40),
          SizedBox(height: 18),
          Text(
            'Authentication setup required',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 12),
          Text(
            'Run the app with SUPABASE_URL and SUPABASE_PUBLISHABLE_KEY. No secrets should be committed to the repository.',
          ),
        ],
      ),
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({required this.message, this.onRetry});
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return _CenteredPage(
      child: Column(
        children: [
          Text(message, textAlign: TextAlign.center),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ],
      ),
    );
  }
}

class _CenteredPage extends StatelessWidget {
  const _CenteredPage({required this.child, this.maxWidth = 480});
  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
