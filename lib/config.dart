import 'package:flutter/foundation.dart';

class AppConfig {
  final String contentfulSpace;
  final String contentfulApiKey;
  final String snapfeedProjectId;
  final String snapfeedSecret;
  final String flavor;
  final String bugfenderKey;

  AppConfig({
    @required this.contentfulSpace,
    @required this.contentfulApiKey,
    @required this.flavor,
    @required this.snapfeedProjectId,
    @required this.snapfeedSecret,
    @required this.bugfenderKey,
  });
}

AppConfig appConfig;
