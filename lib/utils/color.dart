import 'package:flutter/material.dart';

extension ColorExt on String {
  Color hexToColor() {
    if (this == '') return null;

    return new Color(int.parse(this.substring(1, 7), radix: 16) + 0xFF000000);
  }
}
