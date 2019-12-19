import 'package:flutter/material.dart';

class TicketClipper extends CustomClipper<Path> {
  final bool clipTop;
  final bool clipBottom;

  TicketClipper([this.clipTop = false, this.clipBottom = false]);

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height);
    double x = 0;
    double y = size.height;
    double increment = size.width / 20;

    if (clipBottom) {
      path.lineTo(x + increment / 2, y);
      x += increment / 2;

      while (x < size.width) {
        x += increment;
        path.arcToPoint(Offset(x, y), radius: Radius.circular(1));
        path.lineTo(x + increment / 2, y);
        x += increment / 2;
      }
    } else {
      path.lineTo(size.width, size.height);
      x = size.width;
    }

    path.lineTo(size.width, 0.0);
    y = 0;
    path.lineTo(x - increment / 2, y);
    x -= increment / 2;

    if (clipTop) {
      while (x > 0) {
        x -= increment;
        path.arcToPoint(Offset(x, y), radius: Radius.circular(1));
        path.lineTo(x - increment / 2, y);
        x -= increment / 2;
      }
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper old) {
    return old != this;
  }
}
