// @dart=2.9
import 'package:geo_journal_v001/folderForProjects/ProjectPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {  
  ProjectPage projectPage;
  ProjectPageState projectPageState;
  Key testKey;

  // As all ProjectPage is a Scaffold widget, it'll be impossible to test it.
  // So let's add MaterialApp wrapper for it.
  Widget createWidgetForTesting({Widget child}) => MaterialApp(home: child);

  // Group of tests for ProjectPage
  group('Project Page tests\n', (){
    setUp(() {
      testKey = Key('new proj');

      projectPage = ProjectPage(
                        key: testKey, 
                        name: 'project1', 
                        number: '12', 
                        date: '13-09-2023', 
                        notes: 'notes'
                      );
    });

    testWidgets('Test #1: Find text widgets\n', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting(child: projectPage));

      expect(find.text('project1'), findsOneWidget);
      expect(find.text('Номер: 12'), findsOneWidget);
      expect(find.text('Дата закінчення: 13-09-2023'), findsOneWidget);
      expect(find.text('notes'), findsOneWidget);
    }); 
  
    testWidgets('Test #2: Find widget by key\n', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting(child: projectPage));

      expect(find.byKey(testKey), findsOneWidget);
    });

    testWidgets('Test #3: Find instance\n', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetForTesting(child: projectPage));

      expect(find.byWidget(projectPage), findsOneWidget);
    });

    tearDown(() {});
  }); 

  // Group of tests for ProjectPageState
  group('Project Page State tests\n', (){
    setUp(() {
      projectPageState = ProjectPageState();
    });

    testWidgets('Test #1: Find function by key\n', (WidgetTester tester) async {
      bool found = false;
      await tester.pumpWidget(createWidgetForTesting(
          child: Scaffold(
            key: Key('buttonConstructor'),
            body: projectPageState.buttonConstructor(Icons.add)
          )
        )
      );
      
      tester.allWidgets.forEach((Widget element) {
        if(element.key.toString().contains('buttonConstructor')){
          debugPrint('Found buttonConstructor Widget!');
          found = true;
        }
      });
      
      expect(found, true);
    });


    testWidgets('Test #2: Test function\n', (WidgetTester tester) async {
      bool found = false;
      await tester.pumpWidget(createWidgetForTesting(
          child: Scaffold(
            body: projectPageState.buttonConstructor(Icons.add)
          )
        )
      );
      
      expect(find.byType(ClipRRect), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });


    tearDown(() {});
  });

  /*group('End-to-end test', () {
    testWidgets('\nWhole app test', (WidgetTester tester) async {
      expect(true, true);
      expect(true, true);
      expect(true, true);
    });
  });*/
}
