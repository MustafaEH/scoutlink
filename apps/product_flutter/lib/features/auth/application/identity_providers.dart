import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scoutlink_product/features/auth/application/auth_providers.dart';
import 'package:scoutlink_product/features/auth/data/identity_repository.dart';
import 'package:scoutlink_product/features/onboarding/data/onboarding_draft.dart';

final identityRepositoryProvider = Provider<IdentityRepository?>((ref) {
  final session = ref.watch(authSessionProvider).value;
  return session == null ? null : IdentityRepository(session.accessToken);
});

final identityProvider = FutureProvider<Identity?>((ref) async {
  final repository = ref.watch(identityRepositoryProvider);
  if (repository == null) return null;

  final identity = await repository.getMe();
  if (identity.onboardingComplete) return identity;

  final draft = await OnboardingDraft.load();
  if (draft == null) return identity;

  final completedIdentity = await repository.completeOnboarding(draft);
  await OnboardingDraft.clear();
  return completedIdentity;
});
