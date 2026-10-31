import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scoutlink_product/core/config/app_config.dart';
import 'package:scoutlink_product/features/auth/data/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  if (!AppConfig.isAuthConfigured) {
    throw StateError('Supabase authentication is not configured.');
  }
  return AuthRepository(Supabase.instance.client);
});

final authSessionProvider = StreamProvider<Session?>((ref) {
  return ref.watch(authRepositoryProvider).sessions();
});
