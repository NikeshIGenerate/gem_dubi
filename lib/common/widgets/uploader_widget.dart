import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploaderWidget extends StatefulWidget {
  const UploaderWidget({
    Key? key,
    this.onChange,
    this.image,
    this.emptyIcon,
    this.ratio = 1.8,
  }) : super(key: key);

  final double ratio;
  final String? image;
  final Widget? emptyIcon;
  final void Function(File file)? onChange;

  @override
  State<UploaderWidget> createState() => _UploaderWidgetState();
}

class _UploaderWidgetState extends State<UploaderWidget> {
  ImageProvider? provider;

  _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final file = File(image.path);
    widget.onChange?.call(file);
    setState(() => provider = FileImage(file));
  }

  @override
  void initState() {
    if (widget.image != null) provider = NetworkImage(widget.image!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: AspectRatio(
        aspectRatio: widget.ratio,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: Colors.grey[400]),
            if (provider != null) Image(image: provider!, fit: BoxFit.fill),
            if (widget.emptyIcon != null) widget.emptyIcon!,
          ],
        ),
      ),
    );
  }
}
