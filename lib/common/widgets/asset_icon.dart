import 'package:flutter/material.dart';

class AssetIcon extends StatelessWidget {
  const AssetIcon({
    Key? key,
    required this.icon,
    this.color,
    this.size,
  }) : super(key: key);

  final String icon;
  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icons/$icon.png',
      color: color,
      width: size,
      height: size,
    );
  }
}
