import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_articles/core/utils/confirm_dialog.dart';

void main() {
  // Открывает диалог по нажатию кнопки и запоминает результат.
  Future<void> openDialog(
    WidgetTester tester, {
    required void Function(bool result) onResult,
    String confirmLabel = 'Delete',
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () async {
                  final result = await confirmDestructive(
                    context,
                    title: 'Delete article?',
                    message: 'This cannot be undone.',
                    confirmLabel: confirmLabel,
                  );

                  onResult(result);
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('показывает заголовок, сообщение и обе кнопки', (tester) async {
    await openDialog(tester, onResult: (_) {});

    expect(find.text('Delete article?'), findsOneWidget);
    expect(find.text('This cannot be undone.'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);
  });

  testWidgets('подтверждение возвращает true', (tester) async {
    bool? result;

    await openDialog(tester, onResult: (value) => result = value);
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(result, true);
    expect(find.text('Delete article?'), findsNothing);
  });

  testWidgets('Cancel возвращает false', (tester) async {
    bool? result;

    await openDialog(tester, onResult: (value) => result = value);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(result, false);
  });

  testWidgets('закрытие нажатием мимо диалога тоже возвращает false', (tester) async {
    bool? result;

    await openDialog(tester, onResult: (value) => result = value);
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();

    expect(result, false);
  });

  testWidgets('подпись кнопки подтверждения настраивается', (tester) async {
    await openDialog(tester, onResult: (_) {}, confirmLabel: 'Remove');

    expect(find.text('Remove'), findsOneWidget);
    expect(find.text('Delete'), findsNothing);
  });
}
