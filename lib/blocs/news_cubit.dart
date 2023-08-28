import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unit_widget_integ_test_app/blocs/news_state.dart';
import 'package:unit_widget_integ_test_app/models/article.dart';
import 'package:unit_widget_integ_test_app/services/news_service.dart';

class NewsCubit extends Cubit<NewsState> {
  final NewsService _newsService;
  NewsCubit(this._newsService) : super(const NewsLoading());

  final List<Article> _articles = [];
  List<Article> get articles => _articles;
  final bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getArticles() async {
    try {
      emit(const NewsLoading());

      final articles = await _newsService.getArticles();
      _articles.addAll(articles);
      emit(NewsLoaded(_articles));
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }
}
