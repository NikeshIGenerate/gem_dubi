import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'loading_widget.dart';

class RefreshWidget extends StatelessWidget {
  RefreshWidget({
    Key? key,
    required this.child,
    this.onRefresh,
    this.onLoadMore,
    RefreshController? controller,
  })  : controller = controller ?? RefreshController(),
        super(key: key);

  final RefreshController controller;

  final Widget child;
  final Future Function()? onRefresh;
  final Future<bool> Function()? onLoadMore;
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: controller,
      onRefresh: () async {
        try {
          await onRefresh?.call();
          controller.refreshToIdle();
          controller.resetNoData();
          // await Future.delayed(const Duration(seconds: 1));
          //
          // controller.headerMode?.value = RefreshStatus.idle;
        } catch (e) {
          controller.refreshFailed();

          rethrow;
        }
      },
      enablePullUp: true,
      onLoading: () async {
        try {
          final hasMore = await onLoadMore?.call() ?? false;

          if (hasMore) {
            controller.loadComplete();
          } else {
            controller.loadNoData();
          }
        } catch (e) {
          controller.loadFailed();
          rethrow;
        }
      },
      header: const WaterDropHeader(
        refresh: LoadingWidget(size: 50),
      ),
      child: child,
    );
  }
}
