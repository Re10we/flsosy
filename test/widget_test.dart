import 'package:flutter_test/flutter_test.dart';
import 'package:flsosy/main.dart';
import 'package:flsosy/pages/main/main_screen.dart';

void main() {
  testWidgets('App renders MainScreen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    // Verify that MainScreen is rendered.
    expect(find.byType(MainScreen), findsOneWidget);
  });
}
