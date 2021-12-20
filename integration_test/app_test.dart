import 'package:flutter_test/flutter_test.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:integration_test/integration_test.dart';
import 'package:geo_journal_v001/main.dart' as app;

import 'robots/home_robot.dart';


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  HomeRobot homeRobot;

  group('End-to-end test\n', () {
    testWidgets('Whole app test', (WidgetTester tester) async {
      app.main();
      homeRobot = HomeRobot(tester);
      await homeRobot.findTitle();
      await homeRobot.scrollThePage();
      await homeRobot.clickFirstButton();
    });
  });
}