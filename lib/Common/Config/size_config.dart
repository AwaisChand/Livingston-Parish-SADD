import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);

    // Guard against uninitialized MediaQuery in release mode
    if (_mediaQueryData == null || _mediaQueryData!.size == Size.zero) {
      debugPrint("⚠️ MediaQuery is not initialized. Skipping SizeConfig.");
      return;
    }

    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    orientation = _mediaQueryData!.orientation;

    defaultSize = orientation == Orientation.landscape
        ? screenHeight! * 0.024
        : screenWidth! * 0.024;

    // Debug log to verify proper values
    debugPrint("✅ SizeConfig initialized: width=$screenWidth, height=$screenHeight, defaultSize=$defaultSize");
  }
}

double getFont(double size) {
  if (SizeConfig.defaultSize == null) return size;
  return (SizeConfig.defaultSize! * size) / 10;
}

double getHeight(double inputHeight) {
  if (SizeConfig.screenHeight == null) return inputHeight;
  return (inputHeight / 896.0) * SizeConfig.screenHeight!;
}

double getWidth(double inputWidth) {
  if (SizeConfig.screenWidth == null) return inputWidth;
  return (inputWidth / 414.0) * SizeConfig.screenWidth!;
}
