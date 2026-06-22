import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthlive/shared/widgets/empty_state.dart';
import 'package:healthlive/shared/widgets/error_view.dart';
import 'package:healthlive/shared/widgets/loading_skeleton.dart';

/// 统一处理 Riverpod [AsyncValue] 四种 UI 状态的包装组件。
///
/// 按顺序渲染：加载中 → 错误 → 空数据 → 正常内容。
/// 各页面只需传入 [data] 构建函数，避免重复写 `when` 分支。
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

  /// 来自 Provider 的异步状态。
  final AsyncValue<T> value;

  /// 数据就绪且非空时的 UI 构建器。
  final Widget Function(T data) data;

  /// 自定义加载占位，默认 [LoadingSkeleton]。
  final Widget? loading;

  /// 错误态点击「重试」时回调，通常用于 `ref.invalidate(...)`。
  final VoidCallback? onRetry;

  /// 判断数据是否为空；为 `true` 时展示 [empty]。
  final bool Function(T data)? isEmpty;

  /// 自定义空状态 UI，默认 [EmptyState]。
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
