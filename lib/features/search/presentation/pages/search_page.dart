import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthlive/app/router/routes.dart';
import 'package:healthlive/features/search/presentation/providers/search_providers.dart';
import 'package:healthlive/shared/widgets/async_value_widget.dart';
import 'package:healthlive/shared/widgets/content_card.dart';
import 'package:healthlive/shared/widgets/empty_state.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyword = ref.watch(searchKeywordProvider);
    final history = ref.watch(searchHistoryProvider);
    final resultsAsync = ref.watch(searchResultProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: '搜索作息、运动、饮食相关内容',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            ref.read(searchResultProvider.notifier).search(value);
          },
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              onPressed: () {
                _controller.clear();
                ref.read(searchKeywordProvider.notifier).state = '';
                ref.read(searchResultProvider.notifier).search('');
              },
              icon: const Icon(Icons.clear),
            ),
        ],
      ),
      body: keyword.isEmpty
          ? _HistoryView(
              history: history,
              onTap: (value) {
                _controller.text = value;
                ref.read(searchResultProvider.notifier).search(value);
              },
              onClear: () => ref.read(searchHistoryProvider.notifier).clear(),
            )
          : AsyncValueWidget(
              value: resultsAsync,
              onRetry: () =>
                  ref.read(searchResultProvider.notifier).search(keyword),
              isEmpty: (items) => items.isEmpty,
              empty: const EmptyState(
                title: '没有找到相关内容',
                subtitle: '换个关键词试试',
              ),
              data: (items) => ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final content = items[index];
                  return ContentCard(
                    content: content,
                    onTap: () => context.push(
                      AppRoutes.contentDetailPath(content.id),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class _HistoryView extends StatelessWidget {
  const _HistoryView({
    required this.history,
    required this.onTap,
    required this.onClear,
  });

  final List<String> history;
  final ValueChanged<String> onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const EmptyState(
        title: '输入关键词开始搜索',
        subtitle: '可搜索标题、标签与摘要',
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('搜索历史', style: Theme.of(context).textTheme.titleMedium),
            TextButton(onPressed: onClear, child: const Text('清空')),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: history
              .map(
                (keyword) => ActionChip(
                  label: Text(keyword),
                  onPressed: () => onTap(keyword),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
