import 'package:flutter/material.dart';

class ImageLicenseText extends StatelessWidget {
  const ImageLicenseText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Image courtesy of https://undraw.co/',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).textTheme.body1.color.withOpacity(0.5),
        ),
      ),
    );
  }
}
