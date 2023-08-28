import 'package:unit_widget_integ_test_app/models/article.dart';

abstract class NewsState {
  const NewsState();
}

class NewsLoading extends NewsState {
  const NewsLoading();
}

class NewsLoaded extends NewsState {
  final List<Article> articles;

  const NewsLoaded(this.articles);
}

class NewsError extends NewsState {
  final String message;

  const NewsError(this.message);
}
