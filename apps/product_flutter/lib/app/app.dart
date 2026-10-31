import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scoutlink_product/core/theme/scoutlink_theme.dart';
import 'package:scoutlink_product/features/auth/presentation/auth_gate.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [GoRoute(path: '/', builder: (_, _) => const AuthGate())],
  );
});

class ScoutLinkApp extends ConsumerWidget {
  const ScoutLinkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'ScoutLink',
      debugShowCheckedModeBanner: false,
      theme: ScoutLinkTheme.light,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
