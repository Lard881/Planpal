// app/lib/features/search/presentation/search_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/layout/breakpoints.dart';
import '../../../core/widgets/avatar.dart';
import '../../../core/widgets/empty_state.dart';
import '../models/search_models.dart';
import '../providers/search_providers.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String initialQuery;
  const SearchScreen({super.key, this.initialQuery = ''});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late TextEditingController _ctrl;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initialQuery);
    if (widget.initialQuery.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(searchProvider.notifier).search(widget.initialQuery);
      });
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onQueryChanged(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(searchProvider.notifier).search(q);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktopLayout;
    final state = ref.watch(searchProvider);
    final c = context.colors;

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () {
          if (context.canPop()) context.pop();
        },
      },
      child: Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with search field
            Padding(
              padding: EdgeInsets.fromLTRB(
                  isDesktop ? 32 : 16, isDesktop ? 24 : 16,
                  isDesktop ? 32 : 16, 0),
              child: Row(
                children: [
                  if (!isDesktop)
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 36, height: 36, margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: c.surface,
                          borderRadius: BorderRadius.circular(AppRadius.control),
                          border: Border.all(color: c.border),
                        ),
                        child: Icon(LucideIcons.arrowLeft, size: 18, color: c.textPrimary),
                      ),
                    ),
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: c.surfaceAlt,
                        borderRadius: BorderRadius.circular(AppRadius.control),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          Icon(LucideIcons.search, size: 16, color: c.textMuted),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _ctrl,
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: 'Search tasks, docs, people...',
                                hintStyle: AppText.body.copyWith(color: c.textMuted),
                                border: InputBorder.none,
                                filled: false,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: _onQueryChanged,
                              onSubmitted: (q) =>
                                  ref.read(searchProvider.notifier).search(q),
                            ),
                          ),
                          if (_ctrl.text.isNotEmpty)
                            IconButton(
                              icon: Icon(LucideIcons.x, size: 16, color: c.textMuted),
                              onPressed: () {
                                _ctrl.clear();
                                ref.read(searchProvider.notifier).search('');
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                  // Desktop: scope switch (fix F17)
                  if (isDesktop) ...[
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        Text(state.scopeAll ? 'All my workspaces' : 'This workspace',
                          style: AppText.bodyMedium.copyWith(
                            color: state.scopeAll ? c.primary : c.textMuted,
                            fontWeight: state.scopeAll
                                ? FontWeight.w600 : FontWeight.w400)),
                        const SizedBox(width: 8),
                        Switch(
                          value: state.scopeAll,
                          onChanged: (_) =>
                              ref.read(searchProvider.notifier).toggleScope(),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            // Title
            if (state.query.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.fromLTRB(
                    isDesktop ? 32 : 16, 16, isDesktop ? 32 : 16, 0),
                child: Text(
                  'Results for "${state.query}"',
                  style: (isDesktop ? AppText.pageTitle : AppText.pageTitleMobile)
                      .copyWith(color: c.textPrimary),
                ),
              ),
              const SizedBox(height: 12),
              // Filter chips with counts
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16),
                child: Row(
                  children: [
                    _SearchChip('All', 'all', state.results.totalCount, state.filter),
                    const SizedBox(width: 8),
                    _SearchChip('Tasks', 'task', state.results.taskCount, state.filter),
                    const SizedBox(width: 8),
                    _SearchChip(isDesktop ? 'Documents' : 'Docs',
                        'document', state.results.documentCount, state.filter),
                    const SizedBox(width: 8),
                    _SearchChip('People', 'person', state.results.peopleCount, state.filter),
                  ],
                ),
              ),
            ],
            if (state.results.isOffline)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  isDesktop ? 32 : 16,
                  8,
                  isDesktop ? 32 : 16,
                  0,
                ),
                child: Text(
                  AppLocalizations.of(context).searchOfflineNotice,
                  style: AppText.caption.copyWith(color: c.textMuted),
                ),
              ),
            const SizedBox(height: 16),
            // Results
            Expanded(
              child: state.query.isEmpty
                  ? Center(
                      child: Text('Type to search tasks, documents and people.',
                        style: AppText.body.copyWith(color: c.textMuted)))
                  : state.loading
                      ? const Center(child: CircularProgressIndicator())
                      : state.results.totalCount == 0
                          ? EmptyState(
                              icon: LucideIcons.searchX,
                              title: 'No results for "${state.query}"')
                          : _ResultsList(
                              results: state.results,
                              filter: state.filter,
                              isDesktop: isDesktop,
                            ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class _SearchChip extends ConsumerWidget {
  final String label;
  final String value;
  final int count;
  final String current;
  const _SearchChip(this.label, this.value, this.count, this.current);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final selected = current == value;
    return GestureDetector(
      onTap: () => ref.read(searchProvider.notifier).setFilter(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? c.primary : c.surfaceAlt,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text('$label · $count',
          style: AppText.bodyMedium.copyWith(
            color: selected ? Colors.white : c.textMuted)),
      ),
    );
  }
}

class _ResultsList extends StatelessWidget {
  final SearchResults results;
  final String filter;
  final bool isDesktop;
  const _ResultsList({
    required this.results, required this.filter, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final List<SearchResult> tasks =
        filter == 'all' || filter == 'task' ? results.tasks : [];
    final List<SearchResult> docs =
        filter == 'all' || filter == 'document' ? results.documents : [];
    final List<SearchResult> people =
        filter == 'all' || filter == 'person' ? results.people : [];

    return ListView(
      padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 32 : 16, vertical: 0),
      children: [
        if (tasks.isNotEmpty) ...[
          _GroupHeader('TASKS'),
          ...tasks.map((r) => _TaskResultCard(result: r, results: results)),
          const SizedBox(height: 16),
        ],
        if (docs.isNotEmpty) ...[
          _GroupHeader('DOCUMENTS'),
          ...docs.map((r) => _DocumentResultCard(result: r, results: results)),
          const SizedBox(height: 16),
        ],
        if (people.isNotEmpty) ...[
          _GroupHeader('PEOPLE'),
          ...people.map((r) => _PersonResultCard(result: r)),
          const SizedBox(height: 16),
        ],
        const SizedBox(height: 24),
      ],
    );
  }
}

class _GroupHeader extends StatelessWidget {
  final String label;
  const _GroupHeader(this.label);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(label,
        style: AppText.caption.copyWith(
          color: context.colors.textMuted,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        )),
    );
  }
}

class _TaskResultCard extends StatelessWidget {
  final SearchResult result;
  final SearchResults results;
  const _TaskResultCard({required this.result, required this.results});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final pct = results.scorePercent(result);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () => context.push('/tasks/${result.id}'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: c.border),
          ),
          child: Row(
            children: [
              Container(
                width: 20, height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: c.border, width: 1.5)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(result.title,
                      style: AppText.bodyStrong.copyWith(color: c.textPrimary)),
                    if (result.subtitle.isNotEmpty)
                      Text(result.subtitle,
                        style: AppText.caption.copyWith(color: c.textMuted)),
                  ],
                ),
              ),
              Text('$pct%',
                style: AppText.bodyStrong.copyWith(color: c.success)),
            ],
          ),
        ),
      ),
    );
  }
}

class _DocumentResultCard extends StatelessWidget {
  final SearchResult result;
  final SearchResults results;
  const _DocumentResultCard({required this.result, required this.results});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final pct = results.scorePercent(result);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () => context.push('/documents/${result.id}'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: c.border),
          ),
          child: Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: c.primarySoft,
                  borderRadius: BorderRadius.circular(AppRadius.control)),
                child: Icon(LucideIcons.fileText, size: 18, color: c.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(result.title,
                      style: AppText.bodyStrong.copyWith(color: c.textPrimary)),
                    if (result.subtitle.isNotEmpty)
                      Text(result.subtitle,
                        style: AppText.caption.copyWith(color: c.textMuted)),
                  ],
                ),
              ),
              Text('$pct%',
                style: AppText.bodyStrong.copyWith(color: c.success)),
            ],
          ),
        ),
      ),
    );
  }
}

class _PersonResultCard extends StatelessWidget {
  final SearchResult result;
  const _PersonResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () => context.push('/team'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: c.border),
          ),
          child: Row(
            children: [
              Avatar(userId: result.id, name: result.title, size: 36),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(result.title,
                      style: AppText.bodyStrong.copyWith(color: c.textPrimary)),
                    if (result.subtitle.isNotEmpty)
                      Text(result.subtitle,
                        style: AppText.caption.copyWith(color: c.textMuted)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
