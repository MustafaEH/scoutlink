import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scoutlink_product/features/onboarding/application/onboarding_controller.dart';
import 'package:scoutlink_product/features/onboarding/data/onboarding_draft_store.dart';
import 'package:scoutlink_product/features/onboarding/domain/onboarding_models.dart';

class MemoryDraftStore implements OnboardingDraftStore {
  PendingAuth? value;

  @override
  Future<void> clear() async => value = null;

  @override
  Future<PendingAuth?> load() async => value;

  @override
  Future<void> save(PendingAuth value) async => this.value = value;
}

void main() {
  test('interrupted onboarding restores the current page and draft', () async {
    final store = MemoryDraftStore();
    final first = ProviderContainer(
      overrides: [onboardingDraftStoreProvider.overrideWithValue(store)],
    );
    await first.read(onboardingControllerProvider.future);
    final controller = first.read(onboardingControllerProvider.notifier);
    controller.next();
    controller.next();
    controller.next();
    controller.updateRole(OnboardingRole.player);
    controller.next();
    controller.updateFullName('Ahmed Ali');
    controller.updateUsername('ahmed_10');
    controller.updateEmail('ahmed@example.com');
    await Future<void>.delayed(const Duration(milliseconds: 450));
    first.dispose();

    final restored = ProviderContainer(
      overrides: [onboardingDraftStoreProvider.overrideWithValue(store)],
    );
    final state = await restored.read(onboardingControllerProvider.future);

    expect(state.step, OnboardingStep.account);
    expect(state.draft.role, OnboardingRole.player);
    expect(state.draft.fullName, 'Ahmed Ali');
    expect(state.draft.email, 'ahmed@example.com');
    restored.dispose();
  });

  test('username conflicts return the user to the account page', () async {
    final store = MemoryDraftStore();
    final container = ProviderContainer(
      overrides: [onboardingDraftStoreProvider.overrideWithValue(store)],
    );
    await container.read(onboardingControllerProvider.future);
    final controller = container.read(onboardingControllerProvider.notifier);

    controller.showCompletionError('username_taken', 'That username is taken.');
    final state = container.read(onboardingControllerProvider).requireValue;

    expect(state.step, OnboardingStep.account);
    expect(state.error, 'That username is taken.');
    container.dispose();
  });
}
