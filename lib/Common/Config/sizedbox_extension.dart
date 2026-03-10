import 'package:dp_sad/Common/Config/size_config.dart';
import 'package:flutter/material.dart';

extension Space on num {
  SizedBox get sh => SizedBox(
    height: getHeight(toDouble()),
  );
  SizedBox get sw => SizedBox(
    width: getWidth(toDouble()),
  );
}