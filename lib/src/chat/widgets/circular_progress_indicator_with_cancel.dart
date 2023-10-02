import 'package:flutter/material.dart';

class CircularProgressIndicatorWithCancel extends StatefulWidget {
  const CircularProgressIndicatorWithCancel({
    super.key,
    required this.onTap,
    required this.progress,
    required this.color,
    required this.scale,
    this.margin = const EdgeInsets.only(left: 10, bottom: 10),
  });

  final double scale;
  final double progress;
  final Color color;
  final EdgeInsets margin;
  final void Function() onTap;

  @override
  CircularProgressIndicatorWithCancelState createState() => CircularProgressIndicatorWithCancelState();
}

class CircularProgressIndicatorWithCancelState extends State<CircularProgressIndicatorWithCancel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      decoration: const BoxDecoration(
        color: Colors.black45,
        shape: BoxShape.circle,
      ),
      margin: widget.margin,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.scale(
            scale: widget.scale,
            child: CircularProgressIndicator(
              value: widget.progress,
              color: widget.color,
            ),
          ),
          InkWell(
            onTap: widget.onTap,
            child: const Icon(
              Icons.close_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
