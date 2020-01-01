import 'package:flutter/foundation.dart';

class AppConfig {
  final String contentfulSpace;
  final String contentfulApiKey;
  final String flavor;

  AppConfig({
    @required this.contentfulSpace,
    @required this.contentfulApiKey,
    @required this.flavor,
  });
}

AppConfig appConfig;
