import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_gestao/main.dart';

void main() {
  testWidgets('exibe a tela de login inicial', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('E-mail'), findsOneWidget);
    expect(find.text('Senha'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });

  testWidgets('mostra erro com credenciais incorretas',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byType(TextField).at(0), 'erro@email.com');
    await tester.enterText(find.byType(TextField).at(1), '123');
    await tester.tap(find.text('Entrar'));
    await tester.pump();

    expect(find.textContaining('incorret'), findsOneWidget);
  });
}
