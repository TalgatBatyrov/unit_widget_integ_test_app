import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unit_widget_integ_test_app/blocs/news_cubit.dart';
import 'package:unit_widget_integ_test_app/blocs/news_state.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    context.read<NewsCubit>().getArticles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
      ),
      body: BlocBuilder<NewsCubit, NewsState>(
        builder: (context, state) {
          if (state is NewsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is NewsLoaded) {
            return ListView.builder(
              itemCount: state.articles.length,
              itemBuilder: (context, index) {
                final article = state.articles[index];
                return ListTile(
                  title: Text(article.title),
                  subtitle: Text(article.content),
                );
              },
            );
          }
          if (state is NewsError) {
            return Center(
              child: Text(state.message),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
