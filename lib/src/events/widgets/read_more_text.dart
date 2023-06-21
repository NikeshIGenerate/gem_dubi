import 'package:flutter/material.dart';

class ReadMoreText extends StatefulWidget {
  const ReadMoreText(this.text, {Key? key, this.style}) : super(key: key);

  final String text;
  final TextStyle? style;

  @override
  State<ReadMoreText> createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  bool showALl = false;
  bool hasMore = false;

  final int shownLength = 200;

  @override
  void initState() {
    hasMore = widget.text.length > shownLength;
    showALl = !hasMore;

    super.initState();
  }

  @override
  void didUpdateWidget(covariant ReadMoreText oldWidget) {
    hasMore = widget.text.length > shownLength;
    showALl = !hasMore;

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          showALl ? widget.text : widget.text.substring(0, shownLength),
        ),
        if (hasMore)
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            onPressed: () {
              setState(() => showALl = !showALl);
            },
            child: showALl
                ? const Text(
                    'Hide',
                    style: TextStyle(color: Colors.white),
                  )
                : const Text(
                    'Read more',
                    style: TextStyle(color: Colors.white),
                  ),
          ),
      ],
    );
  }
}
