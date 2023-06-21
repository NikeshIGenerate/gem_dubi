import 'dart:ui';

import 'package:flutter/material.dart';

class NavItem {
  final IconData icon;

  NavItem({required this.icon});
}

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({
    Key? key,
    required this.icons,
    required this.index,
    required this.onChange,
  }) : super(key: key);

  final List<NavItem> icons;
  final int index;
  final void Function(int index) onChange;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.8),
          borderRadius: BorderRadius.circular(25),
        ),
        clipBehavior: Clip.antiAlias,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 10.0,
            sigmaY: 10.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (var i = 0; i < icons.length; i++)
                Expanded(
                  child: GestureDetector(
                    onTap: () => onChange(i),
                    behavior: HitTestBehavior.translucent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icons[i].icon,
                          shadows: [
                            if (index == i)
                              const BoxShadow(
                                color: Colors.white,
                                blurRadius: 3,
                                // spreadRadius: 2,
                                blurStyle: BlurStyle.outer,
                                offset: Offset(1, 0),
                              ),
                          ],
                          color: index == i ? Colors.white : Colors.white30,
                        ),
                        if (index == i)
                          Container(
                            height: 1,
                            width: 10,
                            margin: const EdgeInsets.only(top: 3),
                            decoration: BoxDecoration(color: Colors.white),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
