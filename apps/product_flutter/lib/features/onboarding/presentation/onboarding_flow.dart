import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoutlink_product/features/onboarding/application/onboarding_controller.dart';
import 'package:scoutlink_product/features/auth/application/identity_providers.dart';
import 'package:scoutlink_product/features/onboarding/domain/onboarding_models.dart';

class OnboardingFlow extends ConsumerWidget {
  const OnboardingFlow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(onboardingControllerProvider);
    return asyncState.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, _) => const _LoadError(),
      data: (state) {
        final controller = ref.read(onboardingControllerProvider.notifier);
        Future<void> submit() async {
          final completed = await controller.sendLink();
          if (completed) ref.invalidate(identityProvider);
        }

        return PopScope(
          canPop: state.step == OnboardingStep.welcome,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) controller.back();
          },
          child: Scaffold(
            body: SafeArea(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 240),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: KeyedSubtree(
                  key: ValueKey(state.step),
                  child: switch (state.step) {
                    OnboardingStep.welcome => _WelcomePage(
                      onContinue: controller.next,
                      onSignIn: controller.startSignIn,
                    ),
                    OnboardingStep.opportunity => _PromisePage(
                      step: 1,
                      icon: Icons.sports_soccer,
                      eyebrow: 'BUILD YOUR FOOTBALL IDENTITY',
                      title:
                          'Show what you can do—not how many followers you have.',
                      body:
                          'Your profile brings your position, football details, and approved highlights together in one credible place.',
                      points: const [
                        'A focused player CV built for football',
                        'Highlights and details recruiters can compare',
                        'Designed for Egyptian talent with global ambition',
                      ],
                      onBack: controller.back,
                      onContinue: controller.next,
                    ),
                    OnboardingStep.trust => _PromisePage(
                      step: 2,
                      icon: Icons.handshake_outlined,
                      eyebrow: 'A SAFER PATH TO OPPORTUNITY',
                      title:
                          'Discovery starts online. Every real meeting includes ScoutLink.',
                      body:
                          'Recruiters can discover and shortlist talent, while meetings and introductions stay facilitated by the platform.',
                      points: const [
                        'Recruiter verification is shown clearly',
                        'No public comments or direct contact exchange',
                        'Platform representation at every meeting',
                      ],
                      onBack: controller.back,
                      onContinue: controller.next,
                    ),
                    OnboardingStep.role => _RolePage(
                      state: state,
                      onBack: controller.back,
                      onRole: controller.updateRole,
                      onContinue: controller.next,
                    ),
                    OnboardingStep.account => _AccountPage(
                      state: state,
                      onBack: controller.back,
                      onName: controller.updateFullName,
                      onUsername: controller.updateUsername,
                      onEmail: controller.updateEmail,
                      onContinue: controller.next,
                    ),
                    OnboardingStep.profile => _ProfilePage(
                      state: state,
                      controller: controller,
                    ),
                    OnboardingStep.review => _ReviewPage(
                      state: state,
                      onBack: controller.back,
                      onSubmit: submit,
                    ),
                    OnboardingStep.signIn => _SignInPage(
                      state: state,
                      onBack: controller.back,
                      onEmail: controller.updateEmail,
                      onSubmit: submit,
                    ),
                    OnboardingStep.emailSent => _EmailSentPage(
                      state: state,
                      onResend: controller.resendLink,
                      onChangeEmail: controller.changeEmail,
                    ),
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WelcomePage extends StatelessWidget {
  const _WelcomePage({required this.onContinue, required this.onSignIn});
  final VoidCallback onContinue;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) => _Page(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _BrandMark(),
        const SizedBox(height: 76),
        Text(
          'Your game.\nYour next move.',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            height: 0.98,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 22),
        Text(
          'ScoutLink connects ambitious football talent with recruiters through credible profiles and facilitated meetings.',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(height: 1.45),
        ),
        const SizedBox(height: 44),
        FilledButton(
          onPressed: onContinue,
          child: const Text('See how it works'),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: onSignIn,
          child: const Text('Already have an account? Sign in'),
        ),
        const SizedBox(height: 24),
        Text(
          'EGYPT FIRST · OPPORTUNITY WITHOUT BORDERS',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ],
    ),
  );
}

class _PromisePage extends StatelessWidget {
  const _PromisePage({
    required this.step,
    required this.icon,
    required this.eyebrow,
    required this.title,
    required this.body,
    required this.points,
    required this.onBack,
    required this.onContinue,
  });
  final int step;
  final IconData icon;
  final String eyebrow;
  final String title;
  final String body;
  final List<String> points;
  final VoidCallback onBack;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) => _Page(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(step: '$step/2', onBack: onBack),
        const SizedBox(height: 34),
        CircleAvatar(
          radius: 34,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          child: Icon(
            icon,
            size: 34,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 30),
        Text(
          eyebrow,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
            height: 1.12,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          body,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
        ),
        const SizedBox(height: 28),
        for (final point in points) _PromisePoint(point),
        const SizedBox(height: 30),
        FilledButton(
          onPressed: onContinue,
          child: Text(step == 2 ? 'Choose your role' : 'Continue'),
        ),
      ],
    ),
  );
}

class _RolePage extends StatelessWidget {
  const _RolePage({
    required this.state,
    required this.onBack,
    required this.onRole,
    required this.onContinue,
  });
  final OnboardingState state;
  final VoidCallback onBack;
  final ValueChanged<OnboardingRole> onRole;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) => _Page(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(step: '01', onBack: onBack),
        const SizedBox(height: 18),
        const _Title('How will you use ScoutLink?'),
        const SizedBox(height: 30),
        _RoleCard(
          title: 'I am a player',
          description: 'Build your football identity and get discovered.',
          icon: Icons.sports_soccer,
          selected: state.draft.role == OnboardingRole.player,
          onTap: () => onRole(OnboardingRole.player),
        ),
        const SizedBox(height: 14),
        _RoleCard(
          title: 'I am a scout',
          description: 'Find talent and request facilitated meetings.',
          icon: Icons.manage_search,
          selected: state.draft.role == OnboardingRole.scout,
          onTap: () => onRole(OnboardingRole.scout),
        ),
        _ErrorText(state.error),
        const SizedBox(height: 28),
        FilledButton(onPressed: onContinue, child: const Text('Continue')),
      ],
    ),
  );
}

class _AccountPage extends StatelessWidget {
  const _AccountPage({
    required this.state,
    required this.onBack,
    required this.onName,
    required this.onUsername,
    required this.onEmail,
    required this.onContinue,
  });
  final OnboardingState state;
  final VoidCallback onBack;
  final ValueChanged<String> onName;
  final ValueChanged<String> onUsername;
  final ValueChanged<String> onEmail;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) => _Page(
    child: AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(step: '02', onBack: onBack),
          const SizedBox(height: 18),
          const _Title('Create your account'),
          const SizedBox(height: 8),
          const Text(
            'Use the details you want recruiters and players to recognize.',
          ),
          const SizedBox(height: 28),
          TextFormField(
            key: const ValueKey('full-name'),
            initialValue: state.draft.fullName,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.name],
            onChanged: onName,
            decoration: const InputDecoration(labelText: 'Full name'),
          ),
          const SizedBox(height: 14),
          TextFormField(
            key: const ValueKey('username'),
            initialValue: state.draft.username,
            autocorrect: false,
            textInputAction: TextInputAction.next,
            onChanged: onUsername,
            decoration: const InputDecoration(
              labelText: 'Username',
              prefixText: '@',
              helperText: '3-24 letters, numbers, or underscores',
            ),
          ),
          const SizedBox(height: 14),
          TextFormField(
            key: const ValueKey('email'),
            initialValue: state.draft.email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.email],
            autocorrect: false,
            onChanged: onEmail,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          _ErrorText(state.error),
          const SizedBox(height: 28),
          FilledButton(onPressed: onContinue, child: const Text('Continue')),
        ],
      ),
    ),
  );
}

class _ProfilePage extends StatelessWidget {
  const _ProfilePage({required this.state, required this.controller});
  final OnboardingState state;
  final OnboardingController controller;

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final earliest = DateTime(
      now.year - 24,
      now.month,
      now.day,
    ).add(const Duration(days: 1));
    final latest = DateTime(now.year - 6, now.month, now.day);
    final initial =
        state.draft.birthDate ?? DateTime(now.year - 16, now.month, now.day);
    final selected = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(earliest) || initial.isAfter(latest)
          ? DateTime(now.year - 16, now.month, now.day)
          : initial,
      firstDate: earliest,
      lastDate: latest,
      helpText: 'PLAYER DATE OF BIRTH',
    );
    if (selected != null) controller.updateBirthDate(selected);
  }

  Future<void> _pickImage() async {
    final selected = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 82,
      maxWidth: 1400,
      maxHeight: 1400,
    );
    if (selected != null) controller.updateImagePath(selected.path);
  }

  @override
  Widget build(BuildContext context) {
    final player = state.draft.role == OnboardingRole.player;
    final imagePath = state.draft.localImagePath;
    final imageFile = imagePath == null ? null : File(imagePath);
    return _Page(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(step: '03', onBack: controller.back),
          const SizedBox(height: 18),
          _Title(player ? 'Your player details' : 'Your scouting details'),
          const SizedBox(height: 8),
          Text(
            player
                ? 'These details help recruiters understand your football profile.'
                : 'Tell players who you recruit for. Verification happens separately.',
          ),
          const SizedBox(height: 26),
          if (player) ...[
            Center(
              child: InkWell(
                onTap: _pickImage,
                borderRadius: BorderRadius.circular(64),
                child: CircleAvatar(
                  radius: 58,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainer,
                  backgroundImage: imageFile != null && imageFile.existsSync()
                      ? FileImage(imageFile)
                      : null,
                  child: imageFile == null || !imageFile.existsSync()
                      ? const Icon(Icons.add_a_photo_outlined, size: 32)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text('Photo optional now · required before publishing'),
            ),
            const SizedBox(height: 22),
            OutlinedButton.icon(
              onPressed: () => _pickDate(context),
              icon: const Icon(Icons.cake_outlined),
              label: Text(
                state.draft.birthDate == null
                    ? 'Date of birth'
                    : MaterialLocalizations.of(
                        context,
                      ).formatMediumDate(state.draft.birthDate!),
              ),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              initialValue: state.draft.position,
              decoration: const InputDecoration(labelText: 'Main position'),
              items: _positions
                  .map(
                    (value) =>
                        DropdownMenuItem(value: value, child: Text(value)),
                  )
                  .toList(),
              onChanged: controller.updatePosition,
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              initialValue: state.draft.preferredFoot,
              decoration: const InputDecoration(
                labelText: 'Preferred foot (optional)',
              ),
              items: const ['Right', 'Left', 'Both']
                  .map(
                    (value) =>
                        DropdownMenuItem(value: value, child: Text(value)),
                  )
                  .toList(),
              onChanged: controller.updatePreferredFoot,
            ),
          ] else ...[
            TextFormField(
              initialValue: state.draft.country,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              onChanged: controller.updateCountry,
              decoration: const InputDecoration(labelText: 'Country'),
            ),
            const SizedBox(height: 14),
            TextFormField(
              initialValue: state.draft.organization,
              textCapitalization: TextCapitalization.words,
              onChanged: controller.updateOrganization,
              decoration: const InputDecoration(
                labelText: 'Club, academy, or organization (optional)',
              ),
            ),
          ],
          _ErrorText(state.error),
          const SizedBox(height: 28),
          FilledButton(
            onPressed: controller.next,
            child: const Text('Review profile'),
          ),
        ],
      ),
    );
  }
}

class _ReviewPage extends StatelessWidget {
  const _ReviewPage({
    required this.state,
    required this.onBack,
    required this.onSubmit,
  });
  final OnboardingState state;
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final draft = state.draft;
    return _Page(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(step: '04', onBack: onBack),
          const SizedBox(height: 18),
          const _Title('Review and verify'),
          const SizedBox(height: 8),
          const Text(
            'We will email a secure sign-in link to confirm this account.',
          ),
          const SizedBox(height: 26),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _ReviewRow(
                    'Role',
                    draft.role == OnboardingRole.player ? 'Player' : 'Scout',
                  ),
                  _ReviewRow('Name', draft.fullName),
                  _ReviewRow('Username', '@${draft.username.toLowerCase()}'),
                  _ReviewRow('Email', draft.email.toLowerCase()),
                  if (draft.role == OnboardingRole.player) ...[
                    _ReviewRow('Position', draft.position ?? '—'),
                    _ReviewRow(
                      'Born',
                      draft.birthDate == null
                          ? '—'
                          : MaterialLocalizations.of(
                              context,
                            ).formatMediumDate(draft.birthDate!),
                    ),
                  ] else
                    _ReviewRow('Country', draft.country),
                ],
              ),
            ),
          ),
          _ErrorText(state.error),
          const SizedBox(height: 28),
          FilledButton.icon(
            onPressed: state.busy ? null : onSubmit,
            icon: state.busy
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.mark_email_unread_outlined),
            label: Text(state.busy ? 'Sending…' : 'Verify email'),
          ),
          const SizedBox(height: 12),
          const Text(
            'No password needed. Never share a sign-in link with anyone.',
          ),
        ],
      ),
    );
  }
}

class _SignInPage extends StatelessWidget {
  const _SignInPage({
    required this.state,
    required this.onBack,
    required this.onEmail,
    required this.onSubmit,
  });
  final OnboardingState state;
  final VoidCallback onBack;
  final ValueChanged<String> onEmail;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) => _Page(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(onBack: onBack),
        const SizedBox(height: 30),
        const _Title('Welcome back'),
        const SizedBox(height: 10),
        const Text('Enter the email connected to your ScoutLink account.'),
        const SizedBox(height: 28),
        TextFormField(
          initialValue: state.draft.email,
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
          autocorrect: false,
          onChanged: onEmail,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        _ErrorText(state.error),
        const SizedBox(height: 28),
        FilledButton(
          onPressed: state.busy ? null : onSubmit,
          child: Text(state.busy ? 'Sending…' : 'Email me a sign-in link'),
        ),
      ],
    ),
  );
}

class _EmailSentPage extends StatefulWidget {
  const _EmailSentPage({
    required this.state,
    required this.onResend,
    required this.onChangeEmail,
  });
  final OnboardingState state;
  final Future<void> Function() onResend;
  final Future<void> Function() onChangeEmail;

  @override
  State<_EmailSentPage> createState() => _EmailSentPageState();
}

class _EmailSentPageState extends State<_EmailSentPage> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  int get remaining {
    final sentAt = widget.state.sentAt;
    if (sentAt == null) return 0;
    final value = 30 - DateTime.now().difference(sentAt).inSeconds;
    return value.clamp(0, 30);
  }

  @override
  Widget build(BuildContext context) => _Page(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 54),
        Icon(
          Icons.mark_email_read_outlined,
          size: 58,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 26),
        const _Title('Check your email'),
        const SizedBox(height: 14),
        Text(
          'We sent a secure ScoutLink link to ${widget.state.draft.email}. Open it on this phone to continue.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
        ),
        const SizedBox(height: 18),
        const _PromisePoint('The link expires for your security'),
        const _PromisePoint('Check spam or promotions if it is missing'),
        const _PromisePoint('Never forward the link to another person'),
        _ErrorText(widget.state.error),
        const SizedBox(height: 28),
        OutlinedButton(
          onPressed: remaining == 0 && !widget.state.busy
              ? widget.onResend
              : null,
          child: Text(
            remaining == 0 ? 'Resend email' : 'Resend in ${remaining}s',
          ),
        ),
        TextButton(
          onPressed: widget.state.busy ? null : widget.onChangeEmail,
          child: const Text('Use a different email'),
        ),
      ],
    ),
  );
}

class _Page extends StatelessWidget {
  const _Page({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: child,
        ),
      ),
    ),
  );
}

class _Header extends StatelessWidget {
  const _Header({required this.onBack, this.step});
  final VoidCallback onBack;
  final String? step;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      IconButton(
        tooltip: 'Back',
        onPressed: onBack,
        icon: const Icon(Icons.arrow_back),
      ),
      const Spacer(),
      if (step != null)
        Text(
          step!,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.w900,
          ),
        ),
    ],
  );
}

class _Title extends StatelessWidget {
  const _Title(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
      fontWeight: FontWeight.w900,
      height: 1.1,
    ),
  );
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(Icons.adjust, color: Theme.of(context).colorScheme.secondary),
      const SizedBox(width: 9),
      const Text(
        'SCOUTLINK',
        style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.8),
      ),
    ],
  );
}

class _PromisePoint extends StatelessWidget {
  const _PromisePoint(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 13),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_circle,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 11),
        Expanded(child: Text(text, style: const TextStyle(height: 1.35))),
      ],
    ),
  );
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
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: selected ? colors.primary : colors.surfaceContainer,
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
                color: selected ? colors.onPrimary : colors.primary,
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
                        color: selected ? colors.onPrimary : colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: TextStyle(
                        height: 1.35,
                        color: selected
                            ? colors.onPrimary.withValues(alpha: 0.78)
                            : colors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                selected ? Icons.check_circle : Icons.arrow_forward,
                color: selected ? colors.onPrimary : colors.onSurface,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 88,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    ),
  );
}

class _ErrorText extends StatelessWidget {
  const _ErrorText(this.message);
  final String? message;

  @override
  Widget build(BuildContext context) => message == null
      ? const SizedBox.shrink()
      : Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Semantics(
            liveRegion: true,
            child: Text(
              message!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
}

class _LoadError extends ConsumerWidget {
  const _LoadError();

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('We could not restore your setup.'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => ref.invalidate(onboardingControllerProvider),
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    ),
  );
}

const _positions = [
  'Goalkeeper',
  'Centre back',
  'Full back',
  'Defensive midfielder',
  'Central midfielder',
  'Attacking midfielder',
  'Winger',
  'Striker',
];
