import 'package:flutter_test/flutter_test.dart';

import 'package:ndaku/app.dart';

void main() {
  testWidgets('Ndaku app starts', (WidgetTester tester) async {
    await tester.pumpWidget(const NdakuApp(firebaseReady: false));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
  });
}
