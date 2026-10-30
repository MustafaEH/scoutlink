import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scoutlink_product/core/theme/scoutlink_theme.dart';

enum DemoRole { player, recruiter, staff }

extension on DemoRole {
  String get label => switch (this) {
    DemoRole.player => 'Player',
    DemoRole.recruiter => 'Recruiter',
    DemoRole.staff => 'Platform staff',
  };
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  DemoRole role = DemoRole.player;
  int destination = 0;

  static const destinations = [
    NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
    NavigationDestination(icon: Icon(Icons.search), label: 'Discover'),
    NavigationDestination(
      icon: Icon(Icons.calendar_month_outlined),
      label: 'Meetings',
    ),
    NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final expanded = constraints.maxWidth >= 1024;
        return Scaffold(
          appBar: AppBar(
            title: const _Wordmark(),
            actions: [
              DropdownButtonHideUnderline(
                child: DropdownButton<DemoRole>(
                  value: role,
                  borderRadius: BorderRadius.circular(8),
                  items: [
                    for (final item in DemoRole.values)
                      DropdownMenuItem(
                        value: item,
                        child: Text('${item.label} preview'),
                      ),
                  ],
                  onChanged: (value) => setState(() => role = value ?? role),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: Row(
            children: [
              if (expanded)
                NavigationRail(
                  selectedIndex: destination,
                  onDestinationSelected: (value) =>
                      setState(() => destination = value),
                  labelType: NavigationRailLabelType.all,
                  destinations: [
                    for (final item in destinations)
                      NavigationRailDestination(
                        icon: item.icon,
                        label: Text(item.label),
                      ),
                  ],
                ),
              Expanded(child: _Dashboard(role: role)),
            ],
          ),
          bottomNavigationBar: expanded
              ? null
              : NavigationBar(
                  selectedIndex: destination,
                  onDestinationSelected: (value) =>
                      setState(() => destination = value),
                  destinations: destinations,
                ),
        );
      },
    );
  }
}

class _Wordmark extends StatelessWidget {
  const _Wordmark();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 17,
          backgroundColor: ScoutLinkColors.field,
          child: Text(
            'S',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
          ),
        ),
        SizedBox(width: 10),
        Text('ScoutLink', style: TextStyle(fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _Dashboard extends StatelessWidget {
  const _Dashboard({required this.role});
  final DemoRole role;

  @override
  Widget build(BuildContext context) {
    final content = switch (role) {
      DemoRole.player => (
        'PLAYER HOME',
        'Build the profile that gets you seen.',
        'Continue profile',
        0.62,
      ),
      DemoRole.recruiter => (
        'RECRUITER DESK',
        'Find talent with evidence, not noise.',
        'Explore players',
        0.28,
      ),
      DemoRole.staff => (
        'OPERATIONS DESK',
        'Keep every opportunity safe and moving.',
        'Open review queue',
        0.41,
      ),
    };
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                content.$1,
                style: const TextStyle(
                  color: ScoutLinkColors.field,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.8,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                content.$2,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Focused profiles, approved highlights, and platform-facilitated meetings.',
                style: TextStyle(fontSize: 18, height: 1.5),
              ),
              const SizedBox(height: 28),
              FilledButton(onPressed: () {}, child: Text(content.$3)),
              const SizedBox(height: 48),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _StatusCard(
                    label: 'Profile readiness',
                    value: '${(content.$4 * 100).round()}%',
                    progress: content.$4,
                  ),
                  const _StatusCard(
                    label: 'Upcoming meetings',
                    value: '0',
                    progress: 0,
                  ),
                  const _StatusCard(
                    label: 'Unread updates',
                    value: '0',
                    progress: 0,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        color: ScoutLinkColors.field,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Recruiter contact and meetings stay inside a guardian-aware, platform-facilitated workflow.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.label,
    required this.value,
    required this.progress,
  });
  final String label;
  final String value;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label),
              const SizedBox(height: 18),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              LinearProgressIndicator(value: progress, minHeight: 5),
            ],
          ),
        ),
      ),
    );
  }
}
