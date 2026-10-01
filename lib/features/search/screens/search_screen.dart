import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/search_providers.dart';
import '../widgets/search_input_field.dart';
import '../widgets/recent_searches_list.dart';
import '../widgets/search_results_view.dart';

/// Main search screen
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();

    // Auto-focus on desktop
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    // Listen to controller changes and update provider
    _controller.addListener(() {
      ref.read(searchQueryProvider.notifier).state = _controller.text;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchSubmit() {
    final query = _controller.text.trim();
    if (query.length >= 2) {
      addRecentSearch(ref, query);
    }
  }

  void _selectRecentSearch(String query) {
    _controller.text = query;
    ref.read(searchQueryProvider.notifier).state = query;
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final hasQuery = query.trim().length >= 2;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: SearchInputField(
          controller: _controller,
          focusNode: _focusNode,
          onSubmitted: (_) => _onSearchSubmit(),
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                ref.read(searchQueryProvider.notifier).state = '';
              },
              tooltip: 'Clear',
            ),
        ],
      ),
      body: hasQuery
          ? SearchResultsView(query: query)
          : RecentSearchesList(
              onSelectSearch: _selectRecentSearch,
            ),
    );
  }
}
