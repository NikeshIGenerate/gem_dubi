import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gem_dubi/common/utils/app_router.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageViewerScreen extends HookWidget {
  const ImageViewerScreen({
    Key? key,
    required this.images,
    this.index = 0,
  }) : super(key: key);

  final List<String> images;
  final int index;

  @override
  Widget build(BuildContext context) {
    final controller = usePageController(initialPage: index);

    return Stack(
      fit: StackFit.expand,
      children: [
        PhotoViewGallery(
          pageOptions: images
              .map(
                (e) => PhotoViewGalleryPageOptions(
                  imageProvider: CachedNetworkImageProvider(e),
                  heroAttributes: PhotoViewHeroAttributes(tag: e),
                ),
              )
              .toList(),
          pageController: controller,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: Colors.white24,
              ),
              onPressed: () => router.pop(),
              icon: const Icon(Icons.close),
            ),
          ),
        ),
      ],
    );
  }
}

// class ProductsImageProvider extends EasyImageProvider {
//   final List<String> images;
//   @override
//   final int initialIndex;
//
//   ProductsImageProvider(this.images, this.initialIndex);
//
//   @override
//   ImageProvider<Object> imageBuilder(BuildContext context, int index) {
//     return CachedNetworkImageProvider(images[index]);
//   }
//
//   @override
//   int get imageCount => images.length;
// }
