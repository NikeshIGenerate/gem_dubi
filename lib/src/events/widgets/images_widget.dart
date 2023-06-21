import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImagesWidget extends StatefulWidget {
  ImagesWidget({
    Key? key,
    required this.images,
    PageController? controller,
    this.duration = const Duration(milliseconds: 7000),
    this.animationDuration = const Duration(milliseconds: 1000),
  })  : controller = controller ?? PageController(),
        super(key: key);

  final PageController controller;
  final Duration animationDuration;
  final Duration duration;

  final List<String> images;

  @override
  State<ImagesWidget> createState() => _ImagesWidgetState();
}

class _ImagesWidgetState extends State<ImagesWidget> {
  StreamSubscription? subscription;

  @override
  void initState() {
    subscription = Stream.periodic(widget.duration, (i) {
      if (widget.images.length < 2) return;

      final box = context.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero);

      if (position.dy > -10 &&
          position.dy < MediaQuery.of(context).size.height / 2) {
        widget.controller.animateToPage(
          widget.controller.page!.toInt() + 1,
          duration: widget.animationDuration,
          curve: Curves.bounceOut,
        );
      }
    }).listen((event) {});
    super.initState();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  // void goToNext() {
  //   EasyDebounce.debounce(
  //     'image_scroller$hashCode',
  //     const Duration(seconds: 1),
  //     () {
  //       if (!mounted) return goToNext();
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return const SizedBox();

    if (widget.images.length == 1) {
      return CachedNetworkImage(
        imageUrl: widget.images[0],
        fit: BoxFit.cover,
      );
    }

    return PageView.builder(
      controller: widget.controller,
      onPageChanged: (i) {},
      itemBuilder: (context, index) => CachedNetworkImage(
        imageUrl: widget.images[index % widget.images.length],
        fit: BoxFit.cover,
      ),
    );
  }
}
