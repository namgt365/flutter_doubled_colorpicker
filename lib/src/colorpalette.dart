
import 'package:flutter/material.dart';

class ColorPlallete extends StatefulWidget {
  final Color color;
  const ColorPlallete({Key? key,
    required this.color }) : super(key: key);
  @override
  State<ColorPlallete> createState() => _ColorPlalleteState();
}

class _ColorPlalleteState extends State<ColorPlallete> {
  @override
  Widget build(BuildContext context) {

    return
    LayoutBuilder(builder: (BuildContext context, BoxConstraints contraints) {
      double width = contraints.maxWidth;
      double halfWidth = width / 2;
      return ClipOval(
        child: Stack(
          children: [
            Image.asset('assets/images/opacity-slider-track.png',
              package: 'flutter_doubled_colorpicker',
              width: width,
              height: width,
              fit: BoxFit.cover,
            ),
            Row(
              children: [
                Container(
                  width: halfWidth + 2 ,
                  decoration: BoxDecoration(
                      color: widget.color.withAlpha(255),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(halfWidth),
                          bottomLeft: Radius.circular(halfWidth)
                      )
                  ),
                ),
                const Spacer(),
              ],
            ),
            Row(
              children: [
                const Spacer(),
                Container(
                  width: halfWidth,
                  decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(halfWidth),
                          bottomRight: Radius.circular(halfWidth)
                      )
                  ),
                ),
              ],
            ),
            Container(
                width: width,
                height: width,
                decoration: BoxDecoration(
                  border:  Border.all(
                    color: const Color(0xffabb3c6),
                    //Color(0xffdadfe8),
                    width: 1,
                  ) ,
                  borderRadius : BorderRadius.all(Radius.circular(halfWidth)),
                )
            )
          ],
        ),
      );


    });



  }
}