import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scoutlink_product/features/onboarding/domain/onboarding_models.dart';

final onboardingDraftStoreProvider = Provider<OnboardingDraftStore>(
  (_) => SecureOnboardingDraftStore(),
);

abstract interface class OnboardingDraftStore {
  Future<void> save(PendingAuth value);
  Future<PendingAuth?> load();
  Future<void> clear();
}

class SecureOnboardingDraftStore implements OnboardingDraftStore {
  SecureOnboardingDraftStore({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(encryptedSharedPreferences: true),
          );

  static const _key = 'scoutlink_pending_auth_v2';
  final FlutterSecureStorage _storage;

  @override
  Future<void> save(PendingAuth value) =>
      _storage.write(key: _key, value: jsonEncode(value.toJson()));

  @override
  Future<PendingAuth?> load() async {
    final value = await _storage.read(key: _key);
    if (value == null) return null;
    try {
      return PendingAuth.fromJson(jsonDecode(value) as Map<String, dynamic>);
    } on FormatException {
      await clear();
      return null;
    } on StateError {
      await clear();
      return null;
    }
  }

  @override
  Future<void> clear() => _storage.delete(key: _key);
}
