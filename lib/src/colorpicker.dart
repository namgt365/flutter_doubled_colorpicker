
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_doubled_colorpicker/flutter_doubled_colorpicker.dart';
import 'package:flutter_svg/flutter_svg.dart';
// ignore_for_file: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inner_shadow_widget/inner_shadow_widget.dart';
import 'package:clipboard/clipboard.dart';


class ColorPicker extends StatefulWidget {

  final ValueChanged<Color> onChangedColor;

  const ColorPicker({
    Key? key,
    required this.onChangedColor,

  }) : super(key: key);

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  List<Color> _colors = <Color>[];
  final PageController _controller = PageController();
  bool isShowColorWheel = false;

  HSVColor currentHsvColor = HSVColor.fromColor(Colors.white);
  @override
  void initState() {
    super.initState();
    Get.put(ColorPickerController());
    readColorPickerData();

  }

  @override
  void dispose() {
    saveColorPickerData();
    super.dispose();
  }

  void triggerColor(Color color) {
    final index = ColorPickerController.to.paletteIndex.value;
    setState(() {
      currentHsvColor = HSVColor.fromColor(color);
      _colors[index] = color;
    });
    widget.onChangedColor(color);
  }

  readColorPickerData() async {
    final prefs =  await SharedPreferences.getInstance();
    final selected =  prefs.getInt('selectedColorPicker') ?? 0 ;

    final palettes =  prefs.getStringList('ColorPickerPalette');

    // await prefs.setInt('insertedColorPicker', 0);

    if (palettes == null) {
      setState(() {
        _colors = [
          ...defaultPallete,
        ];
      });
    }else {
      setState(() {
        _colors = palettes.map((e) => HexColor.fromHex(e)).toList();
      });
    }

    ColorPickerController.to.setPaletteIndex(selected);

    if (selected > 7) {
      _controller.jumpToPage(1);
    }

    final color = _colors[selected];
    triggerColor(color);
  }

  saveColorPickerData() async {
    final prefs =  await SharedPreferences.getInstance();
    await prefs.setInt('selectedColorPicker' , ColorPickerController.to.paletteIndex.value );
    final list = _colors.map( (e) => e.toHex()).toList();
    await prefs.setStringList('ColorPickerPalette', list);

    Get.delete<ColorPickerController>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 309,
      height: isShowColorWheel ? 468 : 100,
      decoration:
      const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: Colors.white,
      ),
      child: Column(
        children: [
          if (isShowColorWheel)
            HueColorWheel(
              currentHsvColor: currentHsvColor,
              onColorChanged: (value) {
                setState(() {
                  currentHsvColor = value;
                });
                triggerColor(value.toColor());
              },
            ),
          Container(
            width: 309,
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [


                GestureDetector(
                  onTap : () {
                    final string = currentHsvColor.toColor().toHexString();
                    final hex = "#${string.substring(2,8)}";
                    FlutterClipboard.copy(hex);
                  },
                  child: SizedBox(
                    width: 68,
                    height: 68,
                    child:  ColorPlallete(color: currentHsvColor.toColor()),
                  ),
                ),


                const SizedBox(
                  width: 10,
                ),
                PageViewPallete(
                    controller: _controller ,
                    colors: _colors,
                    onSelectedColor: _onSelectedColor
                ),
                const SizedBox(
                  width: 10,
                ),
                const VerticalDivider(width: 1, color: Color(0xffdadfe8)),
                const SizedBox(width: 10),
                Column(
                  children: [
                    GestureDetector(
                      onTap: _openWheel,
                      child: SvgPicture.asset(
                        'assets/images/plus.svg',
                        package: 'flutter_doubled_colorpicker',
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _reset,
                      child: SvgPicture.asset(
                        'assets/images/reset.svg',
                        package: 'flutter_doubled_colorpicker',
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _onSelectedColor(Color color) {
    triggerColor(color);
  }

  _openWheel() async {
    setState(() {
      isShowColorWheel = true;
    });
    final newColor = _colors[ColorPickerController.to.paletteIndex.value];

    final length = _colors.length;

    if (length < 16) {
      setState(() {
        _colors = [
          ..._colors,
          newColor
        ];
      });
      final newIndex = _colors.length -1;

      ColorPickerController.to.setPaletteIndex(newIndex );

    }else {
      //저장 하고
      final prefs =  await SharedPreferences.getInstance();
      final getIndex =   prefs.getInt('insertedColorPicker') ?? 0 ;



      final newIndex = (getIndex % 8) + 8 ;



      setState(() {
        _colors[newIndex] = newColor;
      });
      final inserted = getIndex + 1;
      await prefs.setInt('insertedColorPicker', inserted );
      ColorPickerController.to.setPaletteIndex(newIndex);
    }

    _controller.jumpToPage(1);

    triggerColor(newColor);


  }

  _reset() {
    setState(() {
      isShowColorWheel = false;
      _colors = [
        ...defaultPallete,
      ];
    });
    final index = ColorPickerController.to.paletteIndex.value;
    ColorPickerController.to.setPaletteIndex(index % 8);
    _controller.jumpToPage(0);
  }
}


//ignore: must_be_immutable
class HueColorWheel extends StatefulWidget {
  HSVColor currentHsvColor;
  ValueChanged<HSVColor> onColorChanged;

  HueColorWheel(
      {Key? key,
        required this.onColorChanged,
        required this.currentHsvColor})
      : super(key: key);

  @override
  State<HueColorWheel> createState() => _HueColorWheelState();
}

class _HueColorWheelState extends State<HueColorWheel> {
  HSVColor hsvColor = HSVColor.fromColor(Colors.white);
  String _strAlpha = "";

  @override
  void initState() {
    super.initState();
    hsvColor = widget.currentHsvColor;

    setState(() {
      hsvColor = widget.currentHsvColor;
      _strAlpha = _getAlphaString();
    });
  }

  String _getAlphaString() {
    final colorAlpha = hsvColor.toColor().alpha.toInt();
    final result = colorAlpha * (100 / 255) ;
    final alpha =  result.toInt();
    return "$alpha%";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(16), topLeft: Radius.circular(16)),
        color: Colors.white,
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            width: 216,
            height: 216,
            child: Stack(
              alignment: Alignment.center,
              children: [
                InnerShadow(
                  blur: 10,
                  offset: const Offset(3, 3),
                  color: const Color(0x1f383838),
                  child: Container(
                    width: 216,
                    height: 216,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                    width: 200,
                    height: 200,
                    child: ColorWheel(
                      currentHsvColor: widget.currentHsvColor,
                      onColorChanged: (HSVColor color) {
                        setState(() {
                          hsvColor = color;
                        });
                        widget.onColorChanged(color);
                      },
                    )),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  children: const [
                    Text('밝기', style: captionBold ),
                    Spacer(),
                  ],
                ),
                SizedBox(
                    height: 30,
                    child: ColorPickerSlider(TrackType.saturationForHSL, hsvColor,
                            (HSVColor color) {
                          setState(() {
                            hsvColor = color;
                          });
                          widget.currentHsvColor = color;
                          widget.onColorChanged(color);
                        })),
                const SizedBox(height:16),
                Row(
                  children: [
                    const Text("불투명도", style: captionBold),
                    const Spacer(),
                    Text(_strAlpha, style: captionReqular),
                    const SizedBox(width: 16),
                  ],
                ),
                SizedBox(
                    height: 30,
                    child: ColorPickerSlider(TrackType.alpha, hsvColor,
                            (HSVColor color) {

                          setState(() {
                            hsvColor = color;
                            _strAlpha =  _getAlphaString();
                          });

                          widget.currentHsvColor = color;
                          widget.onColorChanged(color);
                          // widget.onColorChanged(_currentHsvColor);
                        })),
              ],
            ),
          ),
          const SizedBox(height: 16),

        ],
      ),
    );
  }
}



//ignore: must_be_immutable
class ColorWheel extends StatefulWidget {
  HSVColor currentHsvColor;
  ValueChanged<HSVColor> onColorChanged;

  ColorWheel(
      {Key? key,
        required this.onColorChanged,
        required this.currentHsvColor})
      : super(key: key);

  @override
  State<ColorWheel> createState() => _ColorWheelState();
}

class _ColorWheelState extends State<ColorWheel> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;
          return RawGestureDetector(
            gestures: {
              _AlwaysWinPanGestureRecognizer: GestureRecognizerFactoryWithHandlers<
                  _AlwaysWinPanGestureRecognizer>(
                    () => _AlwaysWinPanGestureRecognizer(),
                    (_AlwaysWinPanGestureRecognizer instance) {
                  instance
                    ..onDown = ((details) => _handleGesture(
                        details.globalPosition, context, height, width))
                    ..onUpdate = ((details) => _handleGesture(
                        details.globalPosition, context, height, width));
                },
              ),
            },
            child: Builder(
              builder: (BuildContext context) {
                return SizedBox(
                    width: width,
                    height: height,
                    child: CustomPaint(
                      painter: HUEColorWheelPainter(widget.currentHsvColor),
                    ));
              },
            ),
          );
        });
  }

  void _handleGesture(
      Offset position, BuildContext context, double height, double width) {
    RenderBox? getBox = context.findRenderObject() as RenderBox?;
    if (getBox == null) return;

    Offset localOffset = getBox.globalToLocal(position);
    double horizontal = localOffset.dx.clamp(0.0, width);
    double vertical = localOffset.dy.clamp(0.0, height);

    Offset center = Offset(width / 2, height / 2);
    double radio = width <= height ? width / 2 : height / 2;
    double dist =
        sqrt(pow(horizontal - center.dx, 2) + pow(vertical - center.dy, 2)) /
            radio;
    double rad =
        (atan2(horizontal - center.dx, vertical - center.dy) / pi + 1) /
            2 *
            360;
    _handleColorWheelChange(((rad + 90) % 360).clamp(0, 360), dist.clamp(0, 1));
  }

  void _handleColorWheelChange(double hue, double radio) {
    widget.onColorChanged(
        widget.currentHsvColor.withHue(hue).withSaturation(radio));
  }
}

class _AlwaysWinPanGestureRecognizer extends PanGestureRecognizer {
  @override
  void addAllowedPointer(event) {
    super.addAllowedPointer(event);
    resolve(GestureDisposition.accepted);
  }
  @override
  String get debugDescription => 'alwaysWin';
}
