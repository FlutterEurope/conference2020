import 'dart:io';

import 'package:conferenceapp/common/logger.dart';
import 'package:conferenceapp/config.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info/package_info.dart';

class ForceUpdate {
  static void onForceUpdate(Function callback) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final remoteConfig = await RemoteConfig.instance;

    if (appConfig.flavor == 'dev') return;

    try {
      await remoteConfig.fetch();
    } catch (e, s) {
      logger.errorException(e, s);
    }

    await remoteConfig.activateFetched();

    final requiredBuildNumber = remoteConfig.getInt(Platform.isAndroid
        ? 'android_min_build_number'
        : 'ios_min_build_number');

    final currentBuildNumber = int.parse(packageInfo.buildNumber);

    logger.info(
        "ForceUpdate. Current: $currentBuildNumber. Required: $requiredBuildNumber. " +
            "Update?: ${currentBuildNumber < requiredBuildNumber}");

    if (currentBuildNumber < requiredBuildNumber) {
      callback();
    }
  }
}
