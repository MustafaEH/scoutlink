enum OnboardingRole { player, scout }

enum OnboardingStep {
  welcome,
  opportunity,
  trust,
  role,
  account,
  profile,
  review,
  signIn,
  emailSent,
}

enum AuthIntent { createProfile, signIn }

class OnboardingDraft {
  const OnboardingDraft({
    this.role,
    this.fullName = '',
    this.username = '',
    this.email = '',
    this.birthDate,
    this.position,
    this.preferredFoot,
    this.localImagePath,
    this.avatarObjectPath,
    this.country = 'Egypt',
    this.organization = '',
  });

  final OnboardingRole? role;
  final String fullName;
  final String username;
  final String email;
  final DateTime? birthDate;
  final String? position;
  final String? preferredFoot;
  final String? localImagePath;
  final String? avatarObjectPath;
  final String country;
  final String organization;

  OnboardingDraft copyWith({
    OnboardingRole? role,
    String? fullName,
    String? username,
    String? email,
    DateTime? birthDate,
    bool clearBirthDate = false,
    String? position,
    String? preferredFoot,
    String? localImagePath,
    String? avatarObjectPath,
    String? country,
    String? organization,
  }) {
    return OnboardingDraft(
      role: role ?? this.role,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      email: email ?? this.email,
      birthDate: clearBirthDate ? null : birthDate ?? this.birthDate,
      position: position ?? this.position,
      preferredFoot: preferredFoot ?? this.preferredFoot,
      localImagePath: localImagePath ?? this.localImagePath,
      avatarObjectPath: avatarObjectPath ?? this.avatarObjectPath,
      country: country ?? this.country,
      organization: organization ?? this.organization,
    );
  }

  Map<String, dynamic> toJson() => {
    'role': role?.name,
    'full_name': fullName,
    'username': username,
    'email': email,
    'birth_date': birthDate?.toIso8601String(),
    'position': position,
    'preferred_foot': preferredFoot,
    'local_image_path': localImagePath,
    'avatar_object_path': avatarObjectPath,
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
    if (avatarObjectPath != null) 'avatar_object_path': avatarObjectPath,
    if (role == OnboardingRole.scout) 'country': country.trim(),
    if (organization.trim().isNotEmpty)
      'organization_name': organization.trim(),
  };

  factory OnboardingDraft.fromJson(Map<String, dynamic> json) {
    final roleName = json['role'] as String?;
    return OnboardingDraft(
      role: roleName == null ? null : OnboardingRole.values.byName(roleName),
      fullName: json['full_name'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      birthDate: json['birth_date'] == null
          ? null
          : DateTime.parse(json['birth_date'] as String),
      position: json['position'] as String?,
      preferredFoot: json['preferred_foot'] as String?,
      localImagePath: json['local_image_path'] as String?,
      avatarObjectPath: json['avatar_object_path'] as String?,
      country: json['country'] as String? ?? 'Egypt',
      organization: json['organization'] as String? ?? '',
    );
  }
}

class PendingAuth {
  const PendingAuth({
    required this.intent,
    required this.email,
    required this.step,
    this.draft,
    this.sentAt,
  });

  final AuthIntent intent;
  final String email;
  final OnboardingStep step;
  final OnboardingDraft? draft;
  final DateTime? sentAt;

  Map<String, dynamic> toJson() => {
    'intent': intent.name,
    'email': email,
    'step': step.name,
    'draft': draft?.toJson(),
    'sent_at': sentAt?.toIso8601String(),
  };

  factory PendingAuth.fromJson(Map<String, dynamic> json) => PendingAuth(
    intent: AuthIntent.values.byName(json['intent'] as String),
    email: json['email'] as String? ?? '',
    step: OnboardingStep.values.byName(
      json['step'] as String? ?? OnboardingStep.welcome.name,
    ),
    draft: json['draft'] == null
        ? null
        : OnboardingDraft.fromJson(json['draft'] as Map<String, dynamic>),
    sentAt: json['sent_at'] == null
        ? null
        : DateTime.parse(json['sent_at'] as String),
  );
}

class OnboardingState {
  const OnboardingState({
    this.step = OnboardingStep.welcome,
    this.intent = AuthIntent.createProfile,
    this.draft = const OnboardingDraft(),
    this.busy = false,
    this.error,
    this.sentAt,
  });

  final OnboardingStep step;
  final AuthIntent intent;
  final OnboardingDraft draft;
  final bool busy;
  final String? error;
  final DateTime? sentAt;

  OnboardingState copyWith({
    OnboardingStep? step,
    AuthIntent? intent,
    OnboardingDraft? draft,
    bool? busy,
    String? error,
    bool clearError = false,
    DateTime? sentAt,
    bool clearSentAt = false,
  }) => OnboardingState(
    step: step ?? this.step,
    intent: intent ?? this.intent,
    draft: draft ?? this.draft,
    busy: busy ?? this.busy,
    error: clearError ? null : error ?? this.error,
    sentAt: clearSentAt ? null : sentAt ?? this.sentAt,
  );
}
