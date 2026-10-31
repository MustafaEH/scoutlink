import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scoutlink_product/features/auth/application/auth_providers.dart';
import 'package:scoutlink_product/features/onboarding/data/onboarding_draft_store.dart';

final signOutServiceProvider = Provider<SignOutService>((ref) {
  return SignOutService(
    endSession: ref.watch(authRepositoryProvider).signOut,
    clearDeviceData: ref.watch(onboardingDraftStoreProvider).clear,
  );
});

class SignOutService {
  const SignOutService({
    required this.endSession,
    required this.clearDeviceData,
  });

  final Future<void> Function() endSession;
  final Future<void> Function() clearDeviceData;

  Future<void> signOut() async {
    try {
      await endSession();
    } finally {
      // Never expose one account's device-only draft to the next signed-in user.
      await clearDeviceData();
    }
  }
}
