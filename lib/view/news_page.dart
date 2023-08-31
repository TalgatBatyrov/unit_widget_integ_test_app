import 'package:flutter/material.dart';
import 'package:unit_widget_integ_test_app/models/article.dart';

class NewsPage extends StatelessWidget {
  final Article article;
  const NewsPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(article.content),
        ),
      ),
    );
  }
}
