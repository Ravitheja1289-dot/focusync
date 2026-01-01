import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:focusync/main.dart';

void main() {
  testWidgets('App initializes smoke test', (WidgetTester tester) async {
    // Build Focusync app and trigger a frame
    await tester.pumpWidget(const ProviderScope(child: FocusyncApp()));

    // Verify that the app loads
    expect(find.byType(FocusyncApp), findsOneWidget);
  });
}
