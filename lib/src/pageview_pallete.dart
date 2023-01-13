
import 'package:flutter/material.dart';
import 'package:flutter_doubled_colorpicker/flutter_doubled_colorpicker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class PageViewPallete extends StatefulWidget {
  List<Color> colors;
  final PageController controller;
  final ValueChanged<Color> onSelectedColor;

  PageViewPallete({
    Key? key,
    required this.controller,
    required this.colors,
    required this.onSelectedColor,
  }) : super(key: key);

  @override
  State<PageViewPallete> createState() => _PageViewPalleteState();
}

class _PageViewPalleteState extends State<PageViewPallete> {

  @override
  void initState() {
    super.initState();
    Get.put(ColorPickerController());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _colors = widget.colors;
    return SizedBox(
      width: 136,
      child:PageView.builder(
          controller: widget.controller,
          itemCount: 2,
          itemBuilder: (context, pageIndex) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 4,
                children: List.generate(8, (index) {
                  final idx = (pageIndex * 8) + index;
                  Color? color;
                  Color? checkColor;
                  if (idx < _colors.length) {
                    color = _colors[idx];

                    if ((color.green.toInt() >= 242 ||
                        color.blue.toInt() >= 242) ||
                        (color.red.toInt() >= 242 || color.blue.toInt() >= 242) ||
                        (color.red.toInt() >= 242 ||
                            color.green.toInt() >= 242)) {
                      checkColor = Color(0xff000000);
                    } else {
                      checkColor = Color(0xffffffff);
                    }
                    // print(color.red);
                    // print(color.blue);
                    // print(color.green);

                  } else {
                    color = null;
                  }
                  return color == null
                      ? const SizedBox(
                    width: 0,
                    height: 0,
                  )
                      : GestureDetector(
                    onTap: () {
                      _selectPalette(idx);
                    },
                    child: Obx(() {
                      return Stack(children: [
                        SizedBox(
                          width: 28,
                          height: 28,
                          child: ColorPlallete(color: color!,),
                        ),

                        if (checkColor != null &&
                            idx ==
                                ColorPickerController.to.paletteIndex.value)
                          Center(
                              child:SizedBox(
                                width: 11.7,
                                height: 9,
                                child: SvgPicture.asset('assets/images/check.svg',
                                  package: 'flutter_doubled_colorpicker',),
                              )
                          )
                      ]);
                    }),
                  );
                }),
              ),
            );
          }),
    );
  }

  _selectPalette(int index) {
    ColorPickerController.to.setPaletteIndex(index);
    final color = widget.colors[index];
    widget.onSelectedColor(color);
  }
}

