import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scoutlink_product/features/auth/application/auth_providers.dart';
import 'package:scoutlink_product/features/auth/data/identity_repository.dart';

final identityRepositoryProvider = Provider<IdentityRepository?>((ref) {
  final session = ref.watch(authSessionProvider).value;
  return session == null ? null : IdentityRepository(session.accessToken);
});

final identityProvider = FutureProvider<Identity?>((ref) async {
  final repository = ref.watch(identityRepositoryProvider);
  return repository?.getMe();
});
