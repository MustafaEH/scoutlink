import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scoutlink_product/app/app.dart';

void main() {
  testWidgets('renders the player dashboard by default', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: ScoutLinkApp()));
    await tester.pumpAndSettle();
    expect(find.text('ScoutLink'), findsOneWidget);
    expect(find.text('Build the profile that gets you seen.'), findsOneWidget);
    expect(find.text('Continue profile'), findsOneWidget);
  });
}
