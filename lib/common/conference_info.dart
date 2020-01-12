import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class ConferenceInfo extends StatelessWidget {
  const ConferenceInfo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: DottedBorder(
        borderType: BorderType.Rect,
        dashPattern: [4, 4],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Venue:',
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      'Conference Centre',
                      textAlign: TextAlign.left,
                      softWrap: true,
                      maxLines: 2,
                    ),
                    Text(
                      'Copernicus Science Centre',
                      textAlign: TextAlign.left,
                      softWrap: true,
                      maxLines: 2,
                    ),
                    Text(
                      'Wybrzeże Kościuszkowskie 20',
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      '00-390 Warsaw',
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: Icon(LineIcons.map_signs),
              onPressed: () async {
                if (await canLaunch('https://goo.gl/maps/ChCCX5G71E5VRmWX6')) {
                  launch('https://goo.gl/maps/ChCCX5G71E5VRmWX6');
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
