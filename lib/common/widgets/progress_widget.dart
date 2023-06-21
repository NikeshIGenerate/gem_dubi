import 'package:flutter/material.dart';

class ProgressWidget extends StatelessWidget {
  const ProgressWidget({
    Key? key,
    this.total = 7,
    this.current = 3,
    this.height = 10,
    this.margin = const EdgeInsets.only(bottom: 20),
  }) : super(key: key);

  final int total;

  final int current;

  final double height;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: current / total,
        child: Container(
          height: 12,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.horizontal(left: Radius.circular(3)),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColorDark,
                blurRadius: 3,
                offset: Offset(-3, 0),
              )
            ],
          ),
        ),
      ),
    );
    // return Container(
    //   margin: margin,
    //   width: double.infinity,
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(height / 2),
    //     boxShadow: const [
    //       BoxShadow(
    //         color: Colors.black26,
    //         offset: Offset(1, 2),
    //         blurStyle: BlurStyle.normal,
    //         blurRadius: 3,
    //       ),
    //     ],
    //   ),
    //   // clipBehavior: Clip.antiAlias,
    //   child: Row(
    //     children: [
    //       for (var i = 0; i < total; i++) ...[
    //         if (i != 0) Container(width: 2, color: Colors.black26),
    //         Expanded(
    //           child: Container(
    //             height: height,
    //
    //             decoration: BoxDecoration(
    //                 color: i < current
    //                     ? Theme.of(context).primaryColor
    //                     : Theme.of(context).cardColor,
    //                 boxShadow: [
    //                   BoxShadow(
    //                     color: Theme.of(context).primaryColor,
    //                     blurRadius: 5,
    //                   ),
    //                 ]),
    //             // margin: const EdgeInsets.symmetric(horizontal: 1),
    //           ),
    //         ),
    //       ],
    //     ],
    //   ),
    // );
  }
}
