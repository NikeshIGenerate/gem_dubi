import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gem_dubi/common/utils/app_router.dart';
import 'package:gem_dubi/common/widgets/image_slider_screen.dart';

class MultiImageViewer extends HookWidget {
  final List<String> imageUrls;

  const MultiImageViewer({
    Key? key,
    required this.imageUrls,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _contentRender(),
    );
  }

  List<Widget> _contentRender() {
    switch (imageUrls.length) {
      case 1:
        return _singleImageView();

      case 2:
        return _twoImageView();

      case 3:
        return _threeImageView();

      case 4:
        return _foureImageView();

      default:
        return _multipleImageView();
    }
  }

  List<Widget> _singleImageView() {
    return [
      Expanded(
        flex: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: _ImageWidget(
            images: imageUrls,
            index: 0,
            fit: BoxFit.cover,
          ),
        ),
      ),
    ];
  }

  List<Widget> _twoImageView() {
    return [
      Expanded(
        flex: 1,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
          child: _ImageWidget(
            images: imageUrls,
            index: 0,
            fit: BoxFit.cover,
          ),
        ),
      ),
      const SizedBox(width: 5),
      Expanded(
        flex: 1,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child: _ImageWidget(
            images: imageUrls,
            index: 1,
            fit: BoxFit.cover,
          ),
        ),
      )
    ];
  }

  List<Widget> _threeImageView() {
    return [
      Expanded(
        flex: 1,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
          child: _ImageWidget(
            images: imageUrls,
            index: 0,
            fit: BoxFit.cover,
          ),
        ),
      ),
      const SizedBox(width: 5),
      Expanded(
        flex: 1,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                ),
                child: _ImageWidget(
                  images: imageUrls,
                  index: 1,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(20),
                ),
                child: _ImageWidget(
                  images: imageUrls,
                  index: 2,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _foureImageView() {
    return [
      Expanded(
        flex: 2,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
          child: _ImageWidget(
            images: imageUrls,
            index: 0,
            fit: BoxFit.cover,
          ),
        ),
      ),
      const SizedBox(width: 5),
      Expanded(
        flex: 1,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                ),
                child: _ImageWidget(
                  images: imageUrls,
                  index: 1,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              flex: 1,
              child: ClipRRect(
                child: _ImageWidget(
                  images: imageUrls,
                  index: 2,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(20),
                ),
                child: _ImageWidget(
                  images: imageUrls,
                  index: 3,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _multipleImageView() {
    return [
      Expanded(
        flex: 2,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
          child: _ImageWidget(
            images: imageUrls,
            index: 0,
            fit: BoxFit.cover,
          ),
        ),
      ),
      const SizedBox(width: 5),
      Expanded(
        flex: 1,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                ),
                child: _ImageWidget(
                  images: imageUrls,
                  index: 1,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              flex: 1,
              child: ClipRRect(
                child: _ImageWidget(
                  images: imageUrls,
                  index: 2,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              flex: 1,
              child: Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(20),
                    ),
                    child: _ImageWidget(
                      images: imageUrls,
                      index: 3,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Text(
                        '+${imageUrls.length - 4}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ];
  }
}

class _ImageWidget extends StatelessWidget {
  const _ImageWidget({
    Key? key,
    required this.images,
    required this.fit,
    required this.index,
  }) : super(key: key);

  final List<String> images;
  final int index;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // showImageViewerPager(
        //   context,
        //   ProductsImageProvider(images, index),
        //   swipeDismissible: true,
        // );
        router.push(ImageViewerScreen(images: images, index: index));
      },
      child: Hero(
        tag: images[index],
        child: CachedNetworkImage(
          imageUrl: images[index],
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
