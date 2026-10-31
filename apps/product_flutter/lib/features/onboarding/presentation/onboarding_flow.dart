import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoutlink_product/core/theme/scoutlink_theme.dart';
import 'package:scoutlink_product/features/auth/application/auth_providers.dart';
import 'package:scoutlink_product/features/onboarding/data/onboarding_draft.dart';

class OnboardingFlow extends ConsumerStatefulWidget {
  const OnboardingFlow({super.key});

  @override
  ConsumerState<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends ConsumerState<OnboardingFlow> {
  final fullNameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final countryController = TextEditingController(text: 'Egypt');
  final organizationController = TextEditingController();

  int step = 0;
  OnboardingRole? role;
  DateTime? birthDate;
  String? position;
  String? preferredFoot;
  XFile? image;
  bool submitting = false;
  String? error;

  @override
  void dispose() {
    fullNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    countryController.dispose();
    organizationController.dispose();
    super.dispose();
  }

  void next() => setState(() {
    error = null;
    step += 1;
  });

  void back() => setState(() {
    error = null;
    step -= 1;
  });

  Future<void> pickImage() async {
    final selected = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 82,
      maxWidth: 1400,
    );
    if (selected != null && mounted) setState(() => image = selected);
  }

  Future<void> pickBirthDate() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: birthDate ?? DateTime(now.year - 16),
      firstDate: DateTime(now.year - 30),
      lastDate: DateTime(now.year - 6),
    );
    if (selected != null && mounted) setState(() => birthDate = selected);
  }

  String? validate() {
    if (fullNameController.text.trim().length < 3) {
      return 'Enter your full name.';
    }
    final username = usernameController.text.trim().toLowerCase();
    if (!RegExp(r'^[a-z0-9_]{3,24}$').hasMatch(username)) {
      return 'Username must be 3–24 letters, numbers, or underscores.';
    }
    if (!emailController.text.trim().contains('@')) {
      return 'Enter a valid email address.';
    }
    if (role == OnboardingRole.player) {
      if (birthDate == null) return 'Add your date of birth.';
      if (position == null) return 'Choose your main position.';
    }
    if (role == OnboardingRole.scout && countryController.text.trim().isEmpty) {
      return 'Add the country you recruit from.';
    }
    return null;
  }

  Future<void> submit() async {
    final validationError = validate();
    if (validationError != null) {
      setState(() => error = validationError);
      return;
    }
    setState(() {
      submitting = true;
      error = null;
    });
    final draft = OnboardingDraft(
      role: role!,
      fullName: fullNameController.text.trim(),
      username: usernameController.text.trim().toLowerCase(),
      email: emailController.text.trim().toLowerCase(),
      birthDate: birthDate,
      position: position,
      preferredFoot: preferredFoot,
      localImagePath: image?.path,
      country: role == OnboardingRole.scout
          ? countryController.text.trim()
          : null,
      organization: role == OnboardingRole.scout
          ? organizationController.text.trim()
          : null,
    );
    try {
      await OnboardingDraft.save(draft);
      await ref.read(authRepositoryProvider).sendMagicLink(draft.email);
      if (mounted) setState(() => step = 3);
    } catch (_) {
      if (mounted) {
        setState(
          () => error = 'We could not send the sign-in link. Try again.',
        );
      }
    } finally {
      if (mounted) setState(() => submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: switch (step) {
            0 => _IntroStep(onContinue: next),
            1 => _RoleStep(
              selected: role,
              onSelected: (value) => setState(() => role = value),
              onBack: back,
              onContinue: role == null ? null : next,
            ),
            2 => _DetailsStep(
              role: role!,
              fullNameController: fullNameController,
              usernameController: usernameController,
              emailController: emailController,
              countryController: countryController,
              organizationController: organizationController,
              birthDate: birthDate,
              position: position,
              preferredFoot: preferredFoot,
              image: image,
              submitting: submitting,
              error: error,
              onPickBirthDate: pickBirthDate,
              onPositionChanged: (value) => setState(() => position = value),
              onFootChanged: (value) => setState(() => preferredFoot = value),
              onPickImage: pickImage,
              onBack: back,
              onSubmit: submit,
            ),
            _ => _EmailSentStep(email: emailController.text.trim()),
          },
        ),
      ),
    );
  }
}

class _IntroStep extends StatelessWidget {
  const _IntroStep({required this.onContinue});
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return _Page(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _BrandMark(),
          const Spacer(),
          Text(
            'Your game.\nYour next move.',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              height: 0.98,
              fontWeight: FontWeight.w900,
              color: ScoutLinkColors.ink,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'ScoutLink helps ambitious football players build a credible profile and helps recruiters discover talent worth meeting.',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(height: 1.45),
          ),
          const SizedBox(height: 34),
          const _Promise(
            icon: Icons.sports_soccer,
            text: 'Show the player, not the follower count.',
          ),
          const _Promise(
            icon: Icons.manage_search,
            text: 'Focused discovery for serious recruiters.',
          ),
          const _Promise(
            icon: Icons.handshake_outlined,
            text: 'Every meeting stays facilitated by ScoutLink.',
          ),
          const Spacer(),
          FilledButton(
            onPressed: onContinue,
            child: const Text('Build your profile'),
          ),
          const SizedBox(height: 10),
          const Text('Egypt first. Opportunity without borders.'),
        ],
      ),
    );
  }
}

class _RoleStep extends StatelessWidget {
  const _RoleStep({
    required this.selected,
    required this.onSelected,
    required this.onBack,
    required this.onContinue,
  });
  final OnboardingRole? selected;
  final ValueChanged<OnboardingRole> onSelected;
  final VoidCallback onBack;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    return _Page(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepHeader(
            step: '01',
            title: 'How will you use ScoutLink?',
            onBack: onBack,
          ),
          const SizedBox(height: 34),
          _RoleCard(
            title: 'I am a player',
            description:
                'Build your football identity, share highlights, and get discovered.',
            icon: Icons.sports_soccer,
            selected: selected == OnboardingRole.player,
            onTap: () => onSelected(OnboardingRole.player),
          ),
          const SizedBox(height: 14),
          _RoleCard(
            title: 'I am a scout',
            description:
                'Find players, save shortlists, and request facilitated meetings.',
            icon: Icons.manage_search,
            selected: selected == OnboardingRole.scout,
            onTap: () => onSelected(OnboardingRole.scout),
          ),
          const Spacer(),
          FilledButton(onPressed: onContinue, child: const Text('Continue')),
        ],
      ),
    );
  }
}

class _DetailsStep extends StatelessWidget {
  const _DetailsStep({
    required this.role,
    required this.fullNameController,
    required this.usernameController,
    required this.emailController,
    required this.countryController,
    required this.organizationController,
    required this.birthDate,
    required this.position,
    required this.preferredFoot,
    required this.image,
    required this.submitting,
    required this.error,
    required this.onPickBirthDate,
    required this.onPositionChanged,
    required this.onFootChanged,
    required this.onPickImage,
    required this.onBack,
    required this.onSubmit,
  });

  final OnboardingRole role;
  final TextEditingController fullNameController;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController countryController;
  final TextEditingController organizationController;
  final DateTime? birthDate;
  final String? position;
  final String? preferredFoot;
  final XFile? image;
  final bool submitting;
  final String? error;
  final VoidCallback onPickBirthDate;
  final ValueChanged<String?> onPositionChanged;
  final ValueChanged<String?> onFootChanged;
  final VoidCallback onPickImage;
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final player = role == OnboardingRole.player;
    return _Page(
      scrollable: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepHeader(
            step: '02',
            title: player
                ? 'Create your player profile'
                : 'Create your scout profile',
            onBack: onBack,
          ),
          const SizedBox(height: 24),
          if (player) ...[
            Center(
              child: InkWell(
                onTap: onPickImage,
                borderRadius: BorderRadius.circular(60),
                child: CircleAvatar(
                  radius: 52,
                  backgroundColor: ScoutLinkColors.paperDeep,
                  backgroundImage: image == null
                      ? null
                      : FileImage(File(image!.path)),
                  child: image == null
                      ? const Icon(Icons.add_a_photo_outlined, size: 30)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(child: Text('Add a profile photo (optional)')),
            const SizedBox(height: 22),
          ],
          TextField(
            controller: fullNameController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Full name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: usernameController,
            autocorrect: false,
            decoration: const InputDecoration(
              labelText: 'Username',
              prefixText: '@',
              helperText: 'Letters, numbers, and underscores',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          if (player) ...[
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: onPickBirthDate,
              icon: const Icon(Icons.cake_outlined),
              label: Text(
                birthDate == null
                    ? 'Date of birth'
                    : '${birthDate!.day}/${birthDate!.month}/${birthDate!.year}',
              ),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              initialValue: position,
              decoration: const InputDecoration(
                labelText: 'Main position',
                border: OutlineInputBorder(),
              ),
              items:
                  const [
                        'Goalkeeper',
                        'Centre back',
                        'Full back',
                        'Defensive midfielder',
                        'Central midfielder',
                        'Attacking midfielder',
                        'Winger',
                        'Striker',
                      ]
                      .map(
                        (value) =>
                            DropdownMenuItem(value: value, child: Text(value)),
                      )
                      .toList(),
              onChanged: onPositionChanged,
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              initialValue: preferredFoot,
              decoration: const InputDecoration(
                labelText: 'Preferred foot (optional)',
                border: OutlineInputBorder(),
              ),
              items: const ['Right', 'Left', 'Both']
                  .map(
                    (value) =>
                        DropdownMenuItem(value: value, child: Text(value)),
                  )
                  .toList(),
              onChanged: onFootChanged,
            ),
          ] else ...[
            const SizedBox(height: 14),
            TextField(
              controller: countryController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Country',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: organizationController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Club, academy, or organization (optional)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
          if (error != null) ...[
            const SizedBox(height: 14),
            Text(
              error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: submitting ? null : onSubmit,
            child: Text(submitting ? 'Sending…' : 'Verify email and continue'),
          ),
          const SizedBox(height: 10),
          const Text('We use a secure email link—no password needed.'),
        ],
      ),
    );
  }
}

class _EmailSentStep extends StatelessWidget {
  const _EmailSentStep({required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    return _Page(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          const Icon(
            Icons.mark_email_read_outlined,
            size: 54,
            color: ScoutLinkColors.field,
          ),
          const SizedBox(height: 24),
          Text(
            'Check your email',
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 14),
          Text(
            'We sent a secure ScoutLink sign-in link to $email. Open it on this phone to finish your profile.',
          ),
          const SizedBox(height: 20),
          const Text(
            'Your answers are saved on this device until setup is complete.',
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _Page extends StatelessWidget {
  const _Page({required this.child, this.scrollable = false});
  final Widget child;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
      child: child,
    );
    return scrollable
        ? SingleChildScrollView(child: content)
        : SizedBox.expand(child: content);
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.adjust, color: ScoutLinkColors.signal),
        SizedBox(width: 9),
        Text(
          'SCOUTLINK',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.8),
        ),
      ],
    );
  }
}

class _Promise extends StatelessWidget {
  const _Promise({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(icon, size: 21, color: ScoutLinkColors.field),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({
    required this.step,
    required this.title,
    required this.onBack,
  });
  final String step;
  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back),
          padding: EdgeInsets.zero,
        ),
        const SizedBox(height: 14),
        Text(
          step,
          style: const TextStyle(
            color: ScoutLinkColors.signal,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.selected,
    required this.onTap,
  });
  final String title;
  final String description;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? ScoutLinkColors.field : ScoutLinkColors.paperDeep,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: selected ? Colors.white : ScoutLinkColors.field,
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: selected ? Colors.white : ScoutLinkColors.ink,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: TextStyle(
                        height: 1.35,
                        color: selected ? Colors.white70 : ScoutLinkColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                selected ? Icons.check_circle : Icons.arrow_forward,
                color: selected ? Colors.white : ScoutLinkColors.ink,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
