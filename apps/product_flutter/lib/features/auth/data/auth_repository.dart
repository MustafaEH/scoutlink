import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/app_config.dart';

class AuthRepository {
  AuthRepository(this.client);

  final SupabaseClient client;

  Stream<Session?> sessions() async* {
    yield client.auth.currentSession;
    yield* client.auth.onAuthStateChange.map((event) => event.session);
  }

  Future<void> sendMagicLink(String email) async {
    await client.auth.signInWithOtp(
      email: email.trim().toLowerCase(),
      emailRedirectTo: AppConfig.authRedirectUrl,
    );
  }

  Future<void> signOut() => client.auth.signOut();
}
