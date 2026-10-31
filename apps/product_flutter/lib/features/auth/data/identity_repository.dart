import 'package:dio/dio.dart';
import 'package:scoutlink_product/core/api/api_client.dart';

class Identity {
  const Identity({
    required this.id,
    required this.email,
    required this.roles,
    required this.recruiterVerification,
  });

  factory Identity.fromJson(Map<String, dynamic> json) {
    return Identity(
      id: json['id'] as String,
      email: json['email'] as String,
      roles: List<String>.from(json['roles'] as List),
      recruiterVerification: json['recruiter_verification'] as String?,
    );
  }

  final String id;
  final String email;
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
}
