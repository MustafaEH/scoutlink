import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum OnboardingRole { player, scout }

class OnboardingDraft {
  const OnboardingDraft({
    required this.role,
    required this.fullName,
    required this.username,
    required this.email,
    this.birthDate,
    this.position,
    this.preferredFoot,
    this.localImagePath,
    this.country,
    this.organization,
  });

  static const storageKey = 'scoutlink_onboarding_draft';

  final OnboardingRole role;
  final String fullName;
  final String username;
  final String email;
  final DateTime? birthDate;
  final String? position;
  final String? preferredFoot;
  final String? localImagePath;
  final String? country;
  final String? organization;

  Map<String, dynamic> toJson() => {
    'role': role.name,
    'full_name': fullName,
    'username': username,
    'email': email,
    'birth_date': birthDate?.toIso8601String(),
    'position': position,
    'preferred_foot': preferredFoot,
    'local_image_path': localImagePath,
    'country': country,
    'organization': organization,
  };

  Map<String, dynamic> toApiJson() => {
    'role': role == OnboardingRole.player ? 'player' : 'recruiter',
    'full_name': fullName.trim(),
    'username': username.trim().toLowerCase(),
    if (birthDate != null)
      'birth_date': birthDate!.toIso8601String().split('T').first,
    if (position != null) 'position': position,
    if (preferredFoot != null) 'preferred_foot': preferredFoot,
    if (country != null) 'country': country,
    if (organization != null && organization!.trim().isNotEmpty)
      'organization_name': organization!.trim(),
  };

  factory OnboardingDraft.fromJson(Map<String, dynamic> json) {
    return OnboardingDraft(
      role: OnboardingRole.values.byName(json['role'] as String),
      fullName: json['full_name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      birthDate: json['birth_date'] == null
          ? null
          : DateTime.parse(json['birth_date'] as String),
      position: json['position'] as String?,
      preferredFoot: json['preferred_foot'] as String?,
      localImagePath: json['local_image_path'] as String?,
      country: json['country'] as String?,
      organization: json['organization'] as String?,
    );
  }

  static Future<void> save(OnboardingDraft draft) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(storageKey, jsonEncode(draft.toJson()));
  }

  static Future<OnboardingDraft?> load() async {
    final preferences = await SharedPreferences.getInstance();
    final value = preferences.getString(storageKey);
    if (value == null) return null;
    return OnboardingDraft.fromJson(jsonDecode(value) as Map<String, dynamic>);
  }

  static Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(storageKey);
  }
}
