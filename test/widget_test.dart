
import 'package:flutter_test/flutter_test.dart';

import 'package:habita/main.dart';

void main() {
  testWidgets('Habita home screen shows brand and tagline', (WidgetTester tester) async {
    await tester.pumpWidget(const HabitaApp());

    expect(find.text('Habita'), findsOneWidget);
    expect(find.text('Find it. Own it. Live it.'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
} 