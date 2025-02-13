import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heartbeat_app/main.dart';

void main() {
  testWidgets('Heartbeat animation test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(HeartbeatApp());

    // Verify that the heart icon is present in the widget tree.
    expect(find.byIcon(Icons.favorite), findsOneWidget);

    // Verify that at least one greeting message is visible.
    expect(find.textContaining("Happy Valentine's Day!"), findsWidgets);

    // Verify that the timer starts correctly.
    expect(find.textContaining("Timer:"), findsOneWidget);

    // Ensure the animation can be interacted with.
    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pump();
  });
}
