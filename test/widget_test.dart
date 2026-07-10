import 'package:flutter_test/flutter_test.dart';
import 'package:wage_calculator/main.dart';

void main() {
  testWidgets('app loads with the calculator title', (WidgetTester tester) async {
    await tester.pumpWidget(const WageCalculatorApp());

    expect(find.text('Wage Calculator'), findsOneWidget);
    expect(find.text('Sacks (बोरा)'), findsOneWidget);
  });
}
