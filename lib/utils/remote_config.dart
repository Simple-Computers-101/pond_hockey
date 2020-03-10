//Prompt users to update app if there is a new version available
//Uses url_launcher package

import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

const appStoreUrl =
    'https://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftwareUpdate?id=com.simplecomputers101.pondHockey&mt=8';
const playStoreUrl =
    'https://play.google.com/store/apps/details?id=com.simplecomputers101.pond_hockey';

versionCheck(context) async {
  //Get Current installed version of app
  final info = await PackageInfo.fromPlatform();
  var currentVersion = double.parse(info.version.trim().replaceAll(".", ""));

  //Get Latest version info from firebase config
  final remoteConfig = await RemoteConfig.instance;

  try {
    // Using default duration to force fetching from remote server.
    await remoteConfig.fetch(expiration: const Duration(seconds: 0));
    await remoteConfig.activateFetched();
    remoteConfig.getString('force_update_current_version');
    var newVersion = double.parse(remoteConfig
        .getString('force_update_current_version')
        .trim()
        .replaceAll(".", ""));
    if (newVersion > currentVersion) {
      _showVersionDialog(context);
    }
  } on FetchThrottledException catch (exception) {
    // Fetch throttled.
    print(exception);
  } on Exception {
    print('Unable to fetch remote config. Cached or default values will be '
        'used');
  }
}

//Show Dialog to force user to update
_showVersionDialog(context) async {
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
                FlatButton(
                  child: Text(btnLabel),
                  onPressed: () => _launchURL(appStoreUrl),
                ),
                FlatButton(
                  child: Text(btnLabelCancel),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            )
          : AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                  child: Text(btnLabel),
                  onPressed: () => _launchURL(playStoreUrl),
                ),
                FlatButton(
                  child: Text(btnLabelCancel),
                  onPressed: () => Navigator.pop(context),
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
