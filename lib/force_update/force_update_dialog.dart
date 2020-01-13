import 'dart:io';
import 'package:conferenceapp/force_update/store_urls.dart';
import 'package:conferenceapp/utils/url_launcher.dart';
import 'package:flutter/material.dart';

showForceUpdateDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return _ForceUpdateDialog();
    },
  );
}

class _ForceUpdateDialog extends StatelessWidget {
  const _ForceUpdateDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("Ups, the app seems a bit outdated."),
      contentPadding: EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 12.0),
      children: <Widget>[
        Text(
            "Please update the app by downloading it from the store. It seems that we had a bug that we had to fix."),
        SizedBox(
          height: 16,
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: FlatButton(
            child: new Text("Update"),
            onPressed: () {
              final url =
                  Platform.isAndroid ? StoreUrls.Android : StoreUrls.IOS;

              UrlLauncher.launch(url);
            },
          ),
        ),
      ],
    );
  }
}
