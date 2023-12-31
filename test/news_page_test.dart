import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_widget_integ_test_app/blocs/news_cubit.dart';
import 'package:unit_widget_integ_test_app/main.dart';
import 'package:unit_widget_integ_test_app/models/article.dart';
import 'package:unit_widget_integ_test_app/services/news_service.dart';
import 'package:unit_widget_integ_test_app/view/news_page.dart';

class MockNewsServices extends Mock implements NewsService {}

void main() {
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

  void arrangeNewsServiceReturns3ArticlesAfter2SecondWait() {
    when(() => services.getArticles()).thenAnswer(
      (_) async {
        await Future.delayed(const Duration(seconds: 2));
        return articlesFromService;
      },
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
    'title is displayed',
    (widgetTester) async {
      arrangeNewsServiceReturns3Articles();

      await widgetTester.pumpWidget(createWidgetUnderTest());

      expect(find.text('News'), findsOneWidget);
    },
  );

  testWidgets(
    'loading indicator is displayed while waiting for articles',
    (widgetTester) async {
      arrangeNewsServiceReturns3ArticlesAfter2SecondWait();

      await widgetTester.pumpWidget(createWidgetUnderTest());

      await widgetTester.pump(const Duration(seconds: 1));

      expect(find.byKey(const Key('news_loading_indicator')), findsOneWidget);

      await widgetTester.pumpAndSettle();
    },
  );

  testWidgets('articles are displayed', (widgetTester) async {
    arrangeNewsServiceReturns3Articles();

    await widgetTester.pumpWidget(createWidgetUnderTest());

    await widgetTester.pumpAndSettle();

    expect(find.byType(ListTile), findsNWidgets(3));

    // expect(find.text('Test 1'), findsOneWidget);
    // expect(find.text('Test 2'), findsOneWidget);
    // expect(find.text('Test 3'), findsOneWidget);

    for (final article in articlesFromService) {
      expect(find.text(article.title), findsOneWidget);
      expect(find.text(article.content), findsOneWidget);
    }
  });
}
