import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scoutlink_product/features/auth/application/auth_providers.dart';
import 'package:scoutlink_product/features/auth/data/identity_repository.dart';
import 'package:scoutlink_product/features/onboarding/data/onboarding_draft_store.dart';
import 'package:scoutlink_product/features/onboarding/data/profile_media_repository.dart';
import 'package:scoutlink_product/features/onboarding/domain/onboarding_models.dart';

final profileCompletionServiceProvider = Provider<ProfileCompletionService?>((
  ref,
) {
  final auth = ref.watch(authRepositoryProvider);
  final session = auth.currentSession;
  if (session == null) return null;
  return ProfileCompletionService(
    identityRepository: IdentityRepository(session.accessToken),
    mediaRepository: ProfileMediaRepository(auth.client),
    draftStore: ref.watch(onboardingDraftStoreProvider),
  );
});

class ProfileCompletionService {
  ProfileCompletionService({
    required this.identityRepository,
    required this.mediaRepository,
    required this.draftStore,
  });

  final IdentityRepository identityRepository;
  final ProfileMediaRepository mediaRepository;
  final OnboardingDraftStore draftStore;

  Future<Identity> complete(OnboardingDraft draft) async {
    var readyDraft = draft;
    final localImagePath = draft.localImagePath;
    if (localImagePath != null && draft.avatarObjectPath == null) {
      final objectPath = await mediaRepository.uploadAvatar(localImagePath);
      readyDraft = draft.copyWith(avatarObjectPath: objectPath);
    }
    final identity = await identityRepository.completeOnboarding(readyDraft);
    await draftStore.clear();
    return identity;
  }
}
