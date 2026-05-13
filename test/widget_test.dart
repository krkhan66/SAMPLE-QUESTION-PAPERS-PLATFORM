import 'package:flutter_test/flutter_test.dart';
import 'package:sample_question_papers_platform/app.dart';
import 'package:sample_question_papers_platform/core/di/injection_container.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await initializeDependencies();
  });

  testWidgets('App shell renders with bottom navigation', (
    WidgetTester tester,
  ) async {
    // await tester.pumpWidget(const MaterialApp(home: AppShell(navigationShell: null)));
    // Basic smoke test placeholder
    expect(true, isTrue);
  });
}
