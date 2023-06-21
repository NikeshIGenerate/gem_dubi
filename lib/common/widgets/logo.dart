import 'package:flutter/material.dart';
import 'package:gem_dubi/const/resource.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key, this.size}) : super(key: key);

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'logo',
      child: Image.asset(
        R.ASSETS_LOGO_LOGO_PNG,
        width: size,
        height: size,
        color: Colors.white,
        // color: Theme.of(context).primaryColor,
      ),
    );
  }
}
