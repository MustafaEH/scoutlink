import 'package:dio/dio.dart';
import 'package:scoutlink_product/core/api/api_client.dart';
import 'package:scoutlink_product/features/onboarding/data/onboarding_draft.dart';

class Identity {
  const Identity({
    required this.id,
    required this.email,
    required this.fullName,
    required this.username,
    required this.onboardingComplete,
    required this.roles,
    required this.recruiterVerification,
  });

  factory Identity.fromJson(Map<String, dynamic> json) {
    return Identity(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
      username: json['username'] as String?,
      onboardingComplete: json['onboarding_complete'] as bool? ?? false,
      roles: List<String>.from(json['roles'] as List),
      recruiterVerification: json['recruiter_verification'] as String?,
    );
  }

  final String id;
  final String email;
  final String? fullName;
  final String? username;
  final bool onboardingComplete;
  final List<String> roles;
  final String? recruiterVerification;
}

class IdentityRepository {
  IdentityRepository(String accessToken)
    : client = createApiClient(accessToken);

  final Dio client;

  Future<Identity> getMe() async {
    final response = await client.get<Map<String, dynamic>>('/identity/me');
    return Identity.fromJson(response.data!);
  }

  Future<Identity> chooseRole(String role) async {
    final response = await client.post<Map<String, dynamic>>(
      '/identity/roles',
      data: {'role': role},
    );
    return Identity.fromJson(response.data!);
  }

  Future<Identity> completeOnboarding(OnboardingDraft draft) async {
    final response = await client.post<Map<String, dynamic>>(
      '/identity/onboarding',
      data: draft.toApiJson(),
    );
    return Identity.fromJson(response.data!);
  }
}
