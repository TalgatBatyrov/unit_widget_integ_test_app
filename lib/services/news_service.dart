import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:unit_widget_integ_test_app/models/article.dart';

class NewsService {
// Simulating a remote database
  final _articles = List.generate(
    10,
    (_) => Article(
      title: lorem(paragraphs: 1, words: 3),
      content: lorem(paragraphs: 2, words: 100),
    ),
  );

  Future<List<Article>> getArticles() async {
    await Future.delayed(const Duration(seconds: 1));
    return _articles;
  }
}
