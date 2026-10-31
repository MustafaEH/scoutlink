import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scoutlink_product/core/config/app_config.dart';
import 'package:scoutlink_product/features/auth/application/auth_providers.dart';
import 'package:scoutlink_product/features/auth/application/identity_providers.dart';
import 'package:scoutlink_product/features/auth/data/identity_repository.dart';
import 'package:scoutlink_product/features/home/presentation/home_screen.dart';
import 'package:scoutlink_product/features/onboarding/application/onboarding_controller.dart';
import 'package:scoutlink_product/features/onboarding/data/onboarding_draft_store.dart';
import 'package:scoutlink_product/features/onboarding/data/profile_media_repository.dart';
import 'package:scoutlink_product/features/onboarding/presentation/onboarding_flow.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!AppConfig.isAuthConfigured) return const _SetupRequiredScreen();
    final sessionState = ref.watch(authSessionProvider);
    return sessionState.when(
      loading: () => ref.read(authRepositoryProvider).currentSession == null
          ? const OnboardingFlow()
          : const _IdentityGate(),
      error: (error, _) => _ErrorScreen(message: error.toString()),
      data: (session) =>
          session == null ? const OnboardingFlow() : const _IdentityGate(),
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
          error: (error, _) {
            if (error is IdentityFailure &&
                {
                  'username_taken',
                  'player_age_out_of_range',
                  'player_details_required',
                  'scout_country_required',
                  'invalid_avatar_path',
                }.contains(error.code)) {
              return _CompletionRecovery(
                code: error.code,
                message: error.message,
              );
            }
            if (error is ProfileMediaFailure) {
              return _CompletionRecovery(
                code: 'photo_upload_failed',
                message: error.message,
              );
            }
            return _ErrorScreen(
              message: error is IdentityFailure
                  ? error.message
                  : 'We could not load your ScoutLink account.',
              onRetry: () => ref.invalidate(identityProvider),
              onStartOver: () async {
                await ref.read(onboardingDraftStoreProvider).clear();
                ref.invalidate(onboardingControllerProvider);
                await ref.read(authRepositoryProvider).signOut();
              },
            );
          },
          data: (identity) {
            if (identity == null || identity.roles.isEmpty) {
              return const OnboardingFlow();
            }
            return HomeScreen(
              role: WorkspaceRole.fromRoles(identity.roles),
              recruiterVerification: identity.recruiterVerification,
            );
          },
        );
  }
}

class _CompletionRecovery extends ConsumerStatefulWidget {
  const _CompletionRecovery({required this.code, required this.message});
  final String code;
  final String message;

  @override
  ConsumerState<_CompletionRecovery> createState() =>
      _CompletionRecoveryState();
}

class _CompletionRecoveryState extends ConsumerState<_CompletionRecovery> {
  bool applied = false;

  @override
  Widget build(BuildContext context) {
    if (!applied) {
      applied = true;
      Future<void>(() async {
        await ref.read(onboardingControllerProvider.future);
        ref
            .read(onboardingControllerProvider.notifier)
            .showCompletionError(widget.code, widget.message);
      });
    }
    return const OnboardingFlow();
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
  const _ErrorScreen({required this.message, this.onRetry, this.onStartOver});
  final String message;
  final VoidCallback? onRetry;
  final Future<void> Function()? onStartOver;

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
          if (onStartOver != null) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: () async => onStartOver!(),
              child: const Text('Start over'),
            ),
          ],
        ],
      ),
    );
  }
}

class _CenteredPage extends StatelessWidget {
  const _CenteredPage({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
