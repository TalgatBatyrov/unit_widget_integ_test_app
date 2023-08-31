import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_widget_integ_test_app/blocs/news_cubit.dart';
import 'package:unit_widget_integ_test_app/models/article.dart';
import 'package:unit_widget_integ_test_app/services/news_service.dart';
import 'package:unit_widget_integ_test_app/view/article_page.dart';
import 'package:unit_widget_integ_test_app/view/news_page.dart';

class MockNewsServices extends Mock implements NewsService {}

void main() {
  // IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late final MockNewsServices services;

  setUp(() {
    services = MockNewsServices();
  });

  final articlesFromService = [
    Article(title: 'Test 1', content: 'Test 1 content'),
    Article(title: 'Test 2', content: 'Test 2 content'),
    Article(title: 'Test 3', content: 'Test 3 content')
  ];

  void arrangeNewsServiceReturns3Articles() {
    when(() => services.getArticles()).thenAnswer(
      (_) async => articlesFromService,
    );
  }

  Widget createWidgetUnderTest() {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => NewsCubit(services),
        child: const NewsPage(),
      ),
    );
  }

  testWidgets(
    'tapping on the first article excerpt open the article page where the full article content is displayed!!!',
    (widgetTester) async {
      arrangeNewsServiceReturns3Articles();

      await widgetTester.pumpWidget(createWidgetUnderTest());

      await widgetTester.pump();

      await widgetTester.tap(find.text('Test 1'));

      await widgetTester.pumpAndSettle();

      expect(find.byType(NewsPage), findsNothing);
      expect(find.byType(ArticlePage), findsOneWidget);
      expect(find.text('Test 1'), findsOneWidget);
      expect(find.text('Test 1 content'), findsOneWidget);
    },
  );
}
