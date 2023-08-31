import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_widget_integ_test_app/services/news_service.dart';

class MockNewsServices extends Mock implements NewsService {}

void main() {
  late final MockNewsServices services;

  setUp(() {
    services = MockNewsServices();
  });

  test('test 1', () async {
    expect(1, 1);
  });

  testWidgets('news page', (widgetTester) {
    expect(1, 1);

    return widgetTester.pumpAndSettle();
  });
}
