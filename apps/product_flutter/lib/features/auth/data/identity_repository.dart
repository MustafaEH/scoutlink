import 'package:dio/dio.dart';
import 'package:scoutlink_product/core/api/api_client.dart';
import 'package:scoutlink_product/features/onboarding/domain/onboarding_models.dart';

class IdentityFailure implements Exception {
  const IdentityFailure(this.code, this.message);
  final String code;
  final String message;

  @override
  String toString() => message;
}

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
    try {
      final response = await client.get<Map<String, dynamic>>('/identity/me');
      return Identity.fromJson(response.data!);
    } on DioException catch (error) {
      throw _failure(error);
    }
  }

  Future<Identity> chooseRole(String role) async {
    final response = await client.post<Map<String, dynamic>>(
      '/identity/roles',
      data: {'role': role},
    );
    return Identity.fromJson(response.data!);
  }

  Future<Identity> completeOnboarding(OnboardingDraft draft) async {
    try {
      final response = await client.post<Map<String, dynamic>>(
        '/identity/onboarding',
        data: draft.toApiJson(),
      );
      return Identity.fromJson(response.data!);
    } on DioException catch (error) {
      throw _failure(error);
    }
  }

  IdentityFailure _failure(DioException error) {
    final data = error.response?.data;
    final detail = data is Map<String, dynamic> ? data['detail'] : null;
    if (detail is Map<String, dynamic>) {
      return IdentityFailure(
        detail['code'] as String? ?? 'request_failed',
        detail['message'] as String? ?? 'We could not update your profile.',
      );
    }
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return const IdentityFailure(
        'network_unavailable',
        'ScoutLink could not reach the server. Check your connection and try again.',
      );
    }
    return const IdentityFailure(
      'request_failed',
      'Something went wrong while loading your account. Try again.',
    );
  }
}
