library animation_list;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnimationList extends StatefulWidget {
  // Native List only parameters
  final Key? key;
  final ScrollController? controller;
  final Axis scrollDirection;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? cacheExtent;
  final List<Widget>? children;
  final int? semanticChildCount;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;
  final Tween<double>? opacityRange;

  // Animation List only parameters
  final int duration;
  final int delay;

  final double bounceAt;
  final double reBounceDepth;

  const AnimationList({
    this.key,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.children,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.duration = 1300,
    this.reBounceDepth = 10,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.scrollDirection = Axis.vertical,
    this.opacityRange,
    this.delay = 0,
    this.bounceAt = .5,
  });

  @override
  _AnimationListState createState() => _AnimationListState();
}

class _AnimationListState extends State<AnimationList>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController controller;
  late Animation<double> bounceUpAnimation,
      // bounceReUpAnimation,
      // bounceDownAnimation,
      opacityAnimation;

  double itemStep = .15;

  double itemAnimate = .5;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: widget.duration),
      vsync: this,
    );

    // bounceDownAnimation =
    //     Tween<double>(begin: 0.0, end: widget.reBounceDepth).animate(
    //   CurvedAnimation(
    //     parent: controller,
    //     curve: Interval(
    //       widget.bounceAt,
    //       (2 - widget.bounceAt) / 2,
    //       curve: Curves.easeInOut,
    //     ),
    //   ),
    // );
    // bounceReUpAnimation =
    //     Tween<double>(begin: 0.0, end: widget.reBounceDepth).animate(
    //   CurvedAnimation(
    //     parent: controller,
    //     curve: const Interval(0.7, 1, curve: Curves.easeInOut),
    //   ),
    // );
    opacityAnimation =
        (widget.opacityRange ?? Tween<double>(begin: 0.0, end: 1)).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 1, curve: Curves.easeInOut),
      ),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return ListView.builder(
          key: widget.key,
          controller: widget.controller,
          primary: widget.primary,
          physics: widget.physics,
          shrinkWrap: widget.shrinkWrap,
          padding: widget.padding,
          addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
          addRepaintBoundaries: widget.addRepaintBoundaries,
          addSemanticIndexes: widget.addSemanticIndexes,
          semanticChildCount: widget.semanticChildCount,
          dragStartBehavior: widget.dragStartBehavior,
          keyboardDismissBehavior: widget.keyboardDismissBehavior,
          restorationId: widget.restorationId,
          clipBehavior: widget.clipBehavior,
          itemCount: widget.children!.length,
          scrollDirection: widget.scrollDirection,
          itemBuilder: (BuildContext context, int index) {
            bounceUpAnimation = Tween<double>(
              begin: MediaQuery.of(context).size.height,
              end: 0,
            ).animate(
              CurvedAnimation(
                parent: controller,
                curve: Interval(
                  (index * itemStep) >= 1 ? 1 : index * itemStep,
                  (index * itemStep + itemAnimate) >= 1
                      ? 1
                      : index * itemStep + itemAnimate,
                  curve: const Cubic(0.175, 0.885, 0.32, 1.1),
                ),
                // curve: Curves.bounceOut,
              ),
            );

            return Opacity(
              opacity: opacityAnimation.value,
              child: Transform.translate(
                offset: Offset(
                  widget.scrollDirection == Axis.vertical
                      ? 0
                      : bounceUpAnimation.value,
                  widget.scrollDirection == Axis.horizontal
                      ? 0
                      : bounceUpAnimation.value,
                ),
                // margin: EdgeInsets.only(
                //   top: widget.scrollDirection == Axis.horizontal
                //       ? 0
                //       : bounceUpAnimation.value,
                //   left: widget.scrollDirection == Axis.vertical
                //       ? 0
                //       : bounceUpAnimation.value,
                // ),
                child: widget.children![index],
              ),
            );
          },
        );
      },
    );
  }
}
