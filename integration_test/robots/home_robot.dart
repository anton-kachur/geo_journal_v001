import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class HomeRobot {
  final WidgetTester tester;

  const HomeRobot(this.tester);

  Future<void> findTitle() async {
    await tester.pumpAndSettle();
    expect(find.text("GeoJournal"), findsOneWidget);
  }

  Future<void> scrollThePage({bool scrollUp = false}) async {
    final listFinder = find.byKey(const Key('singleChildScrollView'));
    if (scrollUp) {
      await tester.fling(listFinder, const Offset(0, 500), 10000);
      await tester.pumpAndSettle();
      expect(find.text("Сторінка адміністратора"), findsOneWidget);
    } else {
      
      await tester.fling(listFinder, const Offset(0, -500), 10000);
      await tester.pumpAndSettle();
      expect(find.text("Прогноз погоди"), findsOneWidget);
    }
  }           
  
  Future<void> clickFirstButton() async {
    final btnFinder = find.byKey(const Key('admin_page_button'));
    await tester.ensureVisible(btnFinder);
    await tester.tap(btnFinder);
    await tester.pumpAndSettle();
  }
  
  Future<void> clickSecondButton() async {
    await tester.pageBack();
    await tester.pumpAndSettle();
  }
}