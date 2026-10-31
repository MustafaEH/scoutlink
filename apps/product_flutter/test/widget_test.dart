import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scoutlink_product/app/app.dart';
import 'package:scoutlink_product/core/theme/scoutlink_theme.dart';
import 'package:scoutlink_product/features/auth/application/sign_out_service.dart';
import 'package:scoutlink_product/features/home/presentation/home_screen.dart';
import 'package:scoutlink_product/features/home/presentation/verified_placeholder_screen.dart';
import 'package:scoutlink_product/features/onboarding/application/onboarding_controller.dart';
import 'package:scoutlink_product/features/onboarding/data/onboarding_draft_store.dart';
import 'package:scoutlink_product/features/onboarding/domain/onboarding_models.dart';
import 'package:scoutlink_product/features/onboarding/presentation/onboarding_flow.dart';

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
  testWidgets('fails safely when authentication is not configured', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: ScoutLinkApp()));
    await tester.pumpAndSettle();

    expect(find.text('Authentication setup required'), findsOneWidget);
  });

  testWidgets('renders the player dashboard by default', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: ScoutLinkTheme.light,
          home: const HomeScreen(role: WorkspaceRole.player),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('ScoutLink'), findsOneWidget);
    expect(find.text('Build the profile that gets you seen.'), findsOneWidget);
    expect(find.text('Continue profile'), findsOneWidget);
  });

  testWidgets('verified users see the temporary workspace placeholder', (
    tester,
  ) async {
    var sessionEnded = false;
    final store = MemoryDraftStore()
      ..value = PendingAuth(
        intent: AuthIntent.createProfile,
        email: 'omar@example.com',
        step: OnboardingStep.emailSent,
        draft: const OnboardingDraft(
          role: OnboardingRole.player,
          fullName: 'Omar Hassan',
          email: 'omar@example.com',
        ),
      );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingDraftStoreProvider.overrideWithValue(store),
          signOutServiceProvider.overrideWithValue(
            SignOutService(
              endSession: () async => sessionEnded = true,
              clearDeviceData: store.clear,
            ),
          ),
        ],
        child: MaterialApp(
          theme: ScoutLinkTheme.light,
          home: const VerifiedPlaceholderScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('You’re verified, Omar'), findsOneWidget);
    expect(
      find.text('Your Player workspace is being prepared.'),
      findsOneWidget,
    );
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.byTooltip('Sign out'));
    await tester.pumpAndSettle();

    expect(sessionEnded, isTrue);
    expect(store.value, isNull);
  });

  testWidgets('onboarding introduces ScoutLink before choosing a role', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingDraftStoreProvider.overrideWithValue(MemoryDraftStore()),
        ],
        child: MaterialApp(
          theme: ScoutLinkTheme.light,
          home: const OnboardingFlow(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Your game.\nYour next move.'), findsOneWidget);
    expect(find.text('I am a player'), findsNothing);

    await tester.tap(find.text('See how it works'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Show what you can do'), findsOneWidget);
    await tester.ensureVisible(find.text('Continue'));
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Discovery starts online'), findsOneWidget);
    await tester.ensureVisible(find.text('Choose your role'));
    await tester.tap(find.text('Choose your role'));
    await tester.pumpAndSettle();

    expect(find.text('How will you use ScoutLink?'), findsOneWidget);
    expect(find.text('I am a player'), findsOneWidget);
    expect(find.text('I am a scout'), findsOneWidget);
  });

  testWidgets('system back moves to the previous onboarding page', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingDraftStoreProvider.overrideWithValue(MemoryDraftStore()),
        ],
        child: MaterialApp(
          theme: ScoutLinkTheme.light,
          home: const OnboardingFlow(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('See how it works'));
    await tester.pumpAndSettle();

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Your game.\nYour next move.'), findsOneWidget);
  });

  test('player age calculation handles exact boundaries', () {
    final today = DateTime(2026, 10, 31);
    expect(ageOn(DateTime(2020, 10, 31), today), 6);
    expect(ageOn(DateTime(2002, 11, 1), today), 23);
    expect(ageOn(DateTime(2002, 10, 31), today), 24);
  });

  test('the global theme owns the date picker appearance', () {
    final theme = ScoutLinkTheme.light;
    expect(theme.datePickerTheme.backgroundColor, theme.colorScheme.surface);
    expect(
      theme.datePickerTheme.headerBackgroundColor,
      theme.colorScheme.primary,
    );
  });

  testWidgets('onboarding remains usable on a small phone viewport', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingDraftStoreProvider.overrideWithValue(MemoryDraftStore()),
        ],
        child: MaterialApp(
          theme: ScoutLinkTheme.light,
          home: const OnboardingFlow(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('See how it works'));
    await tester.tap(find.text('See how it works'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Show what you can do'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
