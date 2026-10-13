import 'package:flutter/material.dart';
class SearchScreen extends StatelessWidget {
  final String initialQuery;
  const SearchScreen({super.key, this.initialQuery = ''});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Search — Stage 12')));
}
