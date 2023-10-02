import 'package:flutter/material.dart';

class MediaIconWidget extends StatelessWidget {
  const MediaIconWidget({
    super.key,
    required this.icon,
    required this.color,
    required this.text,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color,
            child: Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
          ),
          //
          const SizedBox(height: 8),
          //
          Text(
            text,
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
