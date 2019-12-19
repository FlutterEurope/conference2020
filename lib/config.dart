import 'package:flutter/foundation.dart';

class AppConfig {
  final String contentfulSpace;
  final String contentfulApiKey;

  AppConfig({@required this.contentfulSpace, @required this.contentfulApiKey});
}

AppConfig appConfig;
