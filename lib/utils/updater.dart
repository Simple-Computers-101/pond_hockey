//Prompt users to update app if there is a new version available
//Uses url_launcher package

import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:pond_hockey/components/dialog/dialog_buttons.dart';
import 'package:pond_hockey/router/router.gr.dart';
import 'package:url_launcher/url_launcher.dart';

class Updater {
  static const appStoreUrl =
      'https://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftwareUpdate?id=com.simplecomputers101.pondHockey&mt=8';
  static const playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.simplecomputers101.pond_hockey';

  static const androidVersionKey = 'force_update_current_version_android';
  static const iosVersionKey = 'force_update_current_version_ios';

  void versionCheck(context) async {
    //Get Current installed version of app
    final info = await PackageInfo.fromPlatform();
    final currentVersion = convertToInteger(info.version.trim());

    //Get Latest version info from firebase config
    final remoteConfig = await RemoteConfig.instance;

    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await remoteConfig.activateFetched();
      String unformattedVersion;
      if (Platform.isAndroid) {
        unformattedVersion = remoteConfig.getString(androidVersionKey);
      } else if (Platform.isIOS) {
        unformattedVersion = remoteConfig.getString(iosVersionKey);
      } else if (kIsWeb) {
        return;
      }
      final newVersion = convertToInteger(unformattedVersion);
      if (newVersion > currentVersion) {
        _showVersionDialog(context);
      }
    } on FetchThrottledException {
      // Fetch throttled.
      rethrow;
    } on FormatException {
      debugPrint('Invalid format!');
      rethrow;
    } on Exception {
      debugPrint('Unable to fetch remote config. '
          'Cached or default values will be used');
      rethrow;
    }
  }

  @visibleForTesting
  int convertToInteger(String unformatted) {
    final noSpecChar = unformatted.trim().replaceAll(RegExp(r'[+.]'), '');
    return int.parse(noSpecChar);
  }

//Show Dialog to force user to update
  void _showVersionDialog(context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        var title = "New Update Available";
        var message =
            "There is a newer version of app available please update it now.";
        var btnLabel = "Update Now";
        var btnLabelCancel = "Later";
        return Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  SecondaryDialogButton(
                    text: btnLabelCancel,
                    onPressed: Router.navigator.pop,
                  ),
                  PrimaryDialogButton(
                    text: btnLabel,
                    onPressed: () => _launchURL(appStoreUrl),
                  ),
                ],
              )
            : AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  SecondaryDialogButton(
                    text: btnLabelCancel,
                    onPressed: Router.navigator.pop,
                  ),
                  PrimaryDialogButton(
                    text: btnLabel,
                    onPressed: () => _launchURL(playStoreUrl),
                  ),
                ],
              );
      },
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
