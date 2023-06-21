import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gem_dubi/const/resource.dart';

class AvatarImage extends StatelessWidget {
  const AvatarImage({
    Key? key,
    this.image,
    this.radius = 70,
    this.strokeWidth = 5,
    this.padding = 4,
    this.child,
    this.onTap,
    this.file,
  }) : super(key: key);

  final File? file;
  final String? image;
  final double radius;
  final double strokeWidth;
  final double padding;
  final Widget? child;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius + padding + strokeWidth,
        backgroundColor: Colors.black,
        child: CircleAvatar(
          radius: radius + padding,
          backgroundColor: Colors.black,
          child: CircleAvatar(
            radius: radius,
            backgroundColor: Colors.black,
            backgroundImage: file != null
                ? FileImage(file!)
                : image == null
                    ? const AssetImage(R.ASSETS_LOGO_LOGO_PNG)
                    : NetworkImage(image!) as ImageProvider,
            child: child == null
                ? null
                : Align(
                    alignment: const Alignment(1, 1),
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      child: child,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
