import 'package:get/get.dart';

class ColorPickerController extends GetxController {
  static ColorPickerController get to => Get.find<ColorPickerController>();
  final paletteIndex = 0.obs;

  setPaletteIndex(int value) {
    paletteIndex.value = value;
  }

}