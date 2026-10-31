import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scoutlink_product/features/auth/application/auth_providers.dart';
import 'package:scoutlink_product/features/auth/data/identity_repository.dart';
import 'package:scoutlink_product/features/onboarding/application/profile_completion_service.dart';
import 'package:scoutlink_product/features/onboarding/data/onboarding_draft_store.dart';
import 'package:scoutlink_product/features/onboarding/data/profile_media_repository.dart';
import 'package:scoutlink_product/features/onboarding/domain/onboarding_models.dart';

final onboardingControllerProvider =
    AsyncNotifierProvider<OnboardingController, OnboardingState>(
      OnboardingController.new,
    );

class OnboardingController extends AsyncNotifier<OnboardingState> {
  Timer? _saveTimer;

  @override
  Future<OnboardingState> build() async {
    ref.onDispose(() => _saveTimer?.cancel());
    final pending = await ref.read(onboardingDraftStoreProvider).load();
    if (pending == null) return const OnboardingState();
    return OnboardingState(
      step: pending.sentAt == null ? pending.step : OnboardingStep.emailSent,
      intent: pending.intent,
      draft: pending.draft ?? OnboardingDraft(email: pending.email),
      sentAt: pending.sentAt,
    );
  }

  OnboardingState get _current => state.requireValue;

  void _set(OnboardingState value, {bool persist = true}) {
    state = AsyncData(value);
    if (persist) _scheduleSave();
  }

  void _scheduleSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 350), () async {
      final value = state.value;
      if (value == null) return;
      await ref
          .read(onboardingDraftStoreProvider)
          .save(
            PendingAuth(
              intent: value.intent,
              email: value.draft.email.trim().toLowerCase(),
              step: value.step,
              draft: value.intent == AuthIntent.createProfile
                  ? value.draft
                  : null,
              sentAt: value.sentAt,
            ),
          );
    });
  }

  void startSignIn() => _set(
    OnboardingState(
      step: OnboardingStep.signIn,
      intent: AuthIntent.signIn,
      draft: OnboardingDraft(email: _current.draft.email),
    ),
  );

  void updateRole(OnboardingRole role) => _set(
    _current.copyWith(
      draft: _current.draft.copyWith(role: role),
      clearError: true,
    ),
  );

  void updateFullName(String value) => _updateDraft(fullName: value);
  void updateUsername(String value) => _updateDraft(username: value);
  void updateEmail(String value) => _updateDraft(email: value);
  void updateCountry(String value) => _updateDraft(country: value);
  void updateOrganization(String value) => _updateDraft(organization: value);
  void updateBirthDate(DateTime value) => _updateDraft(birthDate: value);
  void updatePosition(String? value) => _updateDraft(position: value);
  void updatePreferredFoot(String? value) => _updateDraft(preferredFoot: value);
  void updateImagePath(String value) => _updateDraft(localImagePath: value);

  void _updateDraft({
    String? fullName,
    String? username,
    String? email,
    String? country,
    String? organization,
    DateTime? birthDate,
    String? position,
    String? preferredFoot,
    String? localImagePath,
  }) => _set(
    _current.copyWith(
      draft: _current.draft.copyWith(
        fullName: fullName,
        username: username,
        email: email,
        country: country,
        organization: organization,
        birthDate: birthDate,
        position: position,
        preferredFoot: preferredFoot,
        localImagePath: localImagePath,
      ),
      clearError: true,
    ),
  );

  void next() {
    final current = _current;
    final nextStep = switch (current.step) {
      OnboardingStep.welcome => OnboardingStep.opportunity,
      OnboardingStep.opportunity => OnboardingStep.trust,
      OnboardingStep.trust => OnboardingStep.role,
      OnboardingStep.role when current.draft.role == null => null,
      OnboardingStep.role => OnboardingStep.account,
      OnboardingStep.account =>
        _validateAccount(current.draft) ? OnboardingStep.profile : null,
      OnboardingStep.profile =>
        _validateProfile(current.draft) ? OnboardingStep.review : null,
      _ => null,
    };
    if (nextStep != null) {
      _set(current.copyWith(step: nextStep, clearError: true));
    } else if (current.step == OnboardingStep.role) {
      _set(current.copyWith(error: 'Choose player or scout to continue.'));
    }
  }

  bool _validateAccount(OnboardingDraft draft) {
    if (draft.fullName.trim().length < 3) {
      _set(_current.copyWith(error: 'Enter your full name.'));
      return false;
    }
    if (!RegExp(r'^[a-zA-Z0-9_]{3,24}$').hasMatch(draft.username.trim())) {
      _set(
        _current.copyWith(
          error: 'Username must be 3-24 letters, numbers, or underscores.',
        ),
      );
      return false;
    }
    if (!_validEmail(draft.email)) {
      _set(_current.copyWith(error: 'Enter a valid email address.'));
      return false;
    }
    return true;
  }

  bool _validateProfile(OnboardingDraft draft) {
    if (draft.role == OnboardingRole.player) {
      if (draft.birthDate == null) {
        _set(_current.copyWith(error: 'Add your date of birth.'));
        return false;
      }
      final age = ageOn(draft.birthDate!, DateTime.now());
      if (age < 6 || age > 23) {
        _set(_current.copyWith(error: 'Player profiles are for ages 6-23.'));
        return false;
      }
      if (draft.position == null) {
        _set(_current.copyWith(error: 'Choose your main position.'));
        return false;
      }
    } else if (draft.country.trim().length < 2) {
      _set(_current.copyWith(error: 'Add the country you recruit from.'));
      return false;
    }
    return true;
  }

  void back() {
    final current = _current;
    final previous = switch (current.step) {
      OnboardingStep.opportunity => OnboardingStep.welcome,
      OnboardingStep.trust => OnboardingStep.opportunity,
      OnboardingStep.role => OnboardingStep.trust,
      OnboardingStep.account => OnboardingStep.role,
      OnboardingStep.profile => OnboardingStep.account,
      OnboardingStep.review => OnboardingStep.profile,
      OnboardingStep.signIn => OnboardingStep.welcome,
      OnboardingStep.emailSent when current.intent == AuthIntent.signIn =>
        OnboardingStep.signIn,
      OnboardingStep.emailSent => OnboardingStep.review,
      _ => null,
    };
    if (previous != null) {
      _set(current.copyWith(step: previous, clearError: true));
    }
  }

  Future<bool> sendLink() async {
    final current = _current;
    if (!_validEmail(current.draft.email)) {
      _set(current.copyWith(error: 'Enter a valid email address.'));
      return false;
    }
    if (current.intent == AuthIntent.createProfile &&
        (!_validateAccount(current.draft) ||
            !_validateProfile(current.draft))) {
      return false;
    }

    _set(current.copyWith(busy: true, clearError: true), persist: false);
    try {
      final existingSession = ref.read(authRepositoryProvider).currentSession;
      if (current.intent == AuthIntent.createProfile &&
          existingSession != null) {
        final completion = ref.read(profileCompletionServiceProvider);
        if (completion == null) {
          throw const IdentityFailure(
            'session_unavailable',
            'Your session expired. Request a new sign-in link.',
          );
        }
        await completion.complete(current.draft);
        _set(current.copyWith(busy: false, clearError: true), persist: false);
        return true;
      }

      final email = current.draft.email.trim().toLowerCase();
      final auth = ref.read(authRepositoryProvider);
      if (current.intent == AuthIntent.createProfile) {
        await auth.sendSignUpLink(email);
      } else {
        await auth.sendSignInLink(email);
      }
      final sentAt = DateTime.now();
      final sent = current.copyWith(
        step: OnboardingStep.emailSent,
        busy: false,
        sentAt: sentAt,
        clearError: true,
      );
      _set(sent, persist: false);
      await ref
          .read(onboardingDraftStoreProvider)
          .save(
            PendingAuth(
              intent: sent.intent,
              email: email,
              step: sent.step,
              draft: sent.intent == AuthIntent.createProfile
                  ? sent.draft
                  : null,
              sentAt: sentAt,
            ),
          );
      return false;
    } on IdentityFailure catch (error) {
      showCompletionError(error.code, error.message);
      return false;
    } on ProfileMediaFailure catch (error) {
      _set(
        current.copyWith(
          step: OnboardingStep.profile,
          busy: false,
          error: error.message,
        ),
        persist: false,
      );
      return false;
    } catch (_) {
      _set(
        current.copyWith(
          busy: false,
          error: current.intent == AuthIntent.signIn
              ? 'We could not send a sign-in link. Check the email and try again.'
              : 'We could not send the verification link. Try again.',
        ),
        persist: false,
      );
      return false;
    }
  }

  Future<void> resendLink() async {
    final sentAt = _current.sentAt;
    if (sentAt != null && DateTime.now().difference(sentAt).inSeconds < 30) {
      _set(
        _current.copyWith(error: 'Please wait before requesting another link.'),
      );
      return;
    }
    await sendLink();
  }

  Future<void> changeEmail() async {
    final current = _current;
    await ref.read(onboardingDraftStoreProvider).clear();
    _set(
      current.copyWith(
        step: current.intent == AuthIntent.signIn
            ? OnboardingStep.signIn
            : OnboardingStep.account,
        clearError: true,
        clearSentAt: true,
      ),
    );
  }

  void showCompletionError(String code, String message) {
    final target = switch (code) {
      'username_taken' => OnboardingStep.account,
      'player_age_out_of_range' ||
      'player_details_required' => OnboardingStep.profile,
      'photo_upload_failed' => OnboardingStep.profile,
      _ => OnboardingStep.review,
    };
    _set(_current.copyWith(step: target, error: message, busy: false));
  }
}

bool _validEmail(String value) =>
    RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value.trim().toLowerCase());

int ageOn(DateTime birthDate, DateTime onDate) =>
    onDate.year -
    birthDate.year -
    ((onDate.month < birthDate.month ||
            (onDate.month == birthDate.month && onDate.day < birthDate.day))
        ? 1
        : 0);
