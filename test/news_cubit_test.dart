import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_widget_integ_test_app/blocs/news_cubit.dart';
import 'package:unit_widget_integ_test_app/blocs/news_state.dart';
import 'package:unit_widget_integ_test_app/models/article.dart';
import 'package:unit_widget_integ_test_app/services/news_service.dart';

class BadMockNewsServices implements NewsService {
  @override
  Future<List<Article>> getArticles() async {
    return [
      Article(
        title: 'title',
        content: 'content',
      ),
    ];
  }
}

class MockNewsServices extends Mock implements NewsService {}

void main() {
  late NewsCubit newsCubit;
  final badServices = BadMockNewsServices();
  late final MockNewsServices services;

  setUp(() {
    services = MockNewsServices();
    newsCubit = NewsCubit(services);
  });
  test('initial value is correct', () {
    expect(newsCubit.articles, []);
    expect(newsCubit.isLoading, false);
  });

  group('getArticles', () {
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

    test(
      'gets articles using the NewsServices',
      () async {
        arrangeNewsServiceReturns3Articles();
        final future = newsCubit.getArticles();
        expect(newsCubit.state, isA<NewsLoading>());
        await future;
        expect(newsCubit.state, isA<NewsLoaded>());

        expect(
          newsCubit.articles,
          articlesFromService,
        );
        verify(() => services.getArticles()).called(1);
      },
    );
  });
}
