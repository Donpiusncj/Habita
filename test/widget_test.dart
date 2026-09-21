import 'package:flutter_test/flutter_test.dart';

import 'package:habita/main.dart';

void main() {
  testWidgets('Splash screen shows brand and tagline', (WidgetTester tester) async {
    await tester.pumpWidget(const HabitaApp());

    // Splash screen's first frame shows the brand and tagline.
    expect(find.text('Habita'), findsOneWidget);
    expect(find.text('Find it. Own it. Live it.'), findsOneWidget);

    // Advance past the splash screen's 2-second timer so it doesn't leak
    // into the test as a pending timer, and land on the Home tab.
    await tester.pump(const Duration(seconds: 3));
    expect(find.text('Recommended for you'), findsOneWidget);
  });
}
