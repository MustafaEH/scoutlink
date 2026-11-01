import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scoutlink_product/features/auth/application/auth_providers.dart';
import 'package:scoutlink_product/features/auth/data/identity_repository.dart';
import 'package:scoutlink_product/features/onboarding/application/profile_completion_service.dart';
import 'package:scoutlink_product/features/onboarding/data/onboarding_draft_store.dart';
import 'package:scoutlink_product/features/onboarding/domain/onboarding_models.dart';

final identityRepositoryProvider = Provider<IdentityRepository?>((ref) {
  final session = ref.watch(authRepositoryProvider).currentSession;
  return session == null ? null : IdentityRepository(session.accessToken);
});

final identityProvider = FutureProvider<Identity?>((ref) async {
  final repository = ref.watch(identityRepositoryProvider);
  if (repository == null) return null;

  final identity = await repository.getMe();
  final pending = await ref.read(onboardingDraftStoreProvider).load();
  if (identity.onboardingComplete) {
    if (pending?.intent == AuthIntent.signIn) {
      await ref.read(onboardingDraftStoreProvider).clear();
    }
    return identity;
  }

  final draft = pending?.draft;
  if (draft == null) return identity;

  final completion = ref.read(profileCompletionServiceProvider);
  return completion == null ? identity : completion.complete(draft);
});
