import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthlive/shared/widgets/empty_state.dart';
import 'package:healthlive/shared/widgets/error_view.dart';
import 'package:healthlive/shared/widgets/loading_skeleton.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.onRetry,
    this.isEmpty,
    this.empty,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final Widget? loading;
  final VoidCallback? onRetry;
  final bool Function(T data)? isEmpty;
  final Widget? empty;

  @override
  Widget build(BuildContext context) {
    return value.when(
      loading: () => loading ?? const LoadingSkeleton(),
      error: (error, _) => ErrorView(
        message: error.toString(),
        onRetry: onRetry,
      ),
      data: (result) {
        if (isEmpty != null && isEmpty!(result)) {
          return empty ??
              const EmptyState(
                title: '暂无内容',
                subtitle: '稍后再来看看吧',
              );
        }
        return data(result);
      },
    );
  }
}
