import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart' as qr;

class QrImage extends StatelessWidget {
  final String data;
  final int version;
  final int errorCorrectionLevel;
  final Color color;
  final Color backgroundColor;
  final ImageProvider<dynamic> embeddedImage;
  final Size imageSize;

  const QrImage({
    Key key,
    this.data,
    this.version = 4,
    this.errorCorrectionLevel = qr.QrErrorCorrectLevel.M,
    this.color = Colors.black,
    this.backgroundColor = Colors.white,
    this.embeddedImage,
    this.imageSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final qr.QrPainter _painter = qr.QrPainter(
      data: data,
      version: qr.QrVersions.auto,
      errorCorrectionLevel: errorCorrectionLevel,
      color: color,
      gapless: true,
      emptyColor: backgroundColor,
    );

    // return qr.QrImage(
    //   foregroundColor: color,
    //   backgroundColor: backgroundColor,
    //   data: data,
    //   errorCorrectionLevel: errorCorrectionLevel,
    //   version: version,
    //   embeddedImage: embeddedImage,
    //   embeddedImageStyle:
    //       imageSize == null ? null : qr.QrEmbeddedImageStyle(size: imageSize),
    // );

    return FutureBuilder<ByteData>(
      future: _painter.toImageData(300.0),
      builder: (BuildContext context, AsyncSnapshot<ByteData> snapshot) {
        return AnimatedCrossFade(
          firstChild: Container(
            alignment: Alignment.center,
          ),
          secondChild: Builder(builder: (BuildContext context) {
            if (snapshot.data == null || data == null) {
              return Center(
                child: Text('No data provided.'),
              );
            }

            return Image.memory(
              snapshot.data.buffer.asUint8List(),
              fit: BoxFit.contain,
            );
          }),
          crossFadeState: snapshot.connectionState == ConnectionState.done
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
          layoutBuilder: (Widget topChild, Key topChildKey, Widget bottomChild,
              Key bottomChildKey) {
            return Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned.fill(
                  key: bottomChildKey,
                  left: 0.0,
                  top: 0.0,
                  right: 0.0,
                  child: bottomChild,
                ),
                Positioned.fill(
                  key: topChildKey,
                  child: topChild,
                ),
                if (embeddedImage != null)
                  Center(
                    child: Container(
                      height: imageSize != null ? imageSize.height : null,
                      width: imageSize != null ? imageSize.width : null,
                      child: Image(image: embeddedImage),
                    ),
                  )
              ],
            );
          },
        );
      },
    );
  }
}
