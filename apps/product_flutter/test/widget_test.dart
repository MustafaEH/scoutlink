import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scoutlink_product/app/app.dart';
import 'package:scoutlink_product/core/theme/scoutlink_theme.dart';
import 'package:scoutlink_product/features/home/presentation/home_screen.dart';

void main() {
  testWidgets('fails safely when authentication is not configured', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: ScoutLinkApp()));
    await tester.pumpAndSettle();

    expect(find.text('Authentication setup required'), findsOneWidget);
  });

  testWidgets('renders the player dashboard by default', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: ScoutLinkTheme.light,
          home: const HomeScreen(role: WorkspaceRole.player),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('ScoutLink'), findsOneWidget);
    expect(find.text('Build the profile that gets you seen.'), findsOneWidget);
    expect(find.text('Continue profile'), findsOneWidget);
  });
}
