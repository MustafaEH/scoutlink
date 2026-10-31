import 'package:flutter/material.dart';
import 'package:scoutlink_product/core/theme/scoutlink_theme.dart';
import 'package:scoutlink_product/features/auth/presentation/auth_gate.dart';

class ScoutLinkApp extends StatelessWidget {
  const ScoutLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ScoutLink',
      debugShowCheckedModeBanner: false,
      theme: ScoutLinkTheme.light,
      home: const AuthGate(),
    );
  }
}
