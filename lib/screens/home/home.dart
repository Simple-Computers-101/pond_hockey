import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:pond_hockey/components/appbar/appbar.dart';
import 'package:pond_hockey/enums/viewing_mode.dart';
import 'package:pond_hockey/router/router.gr.dart';
import 'package:pond_hockey/screens/tournaments/widgets/tournament_viewing.dart';

class HomeScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setNavigationBarColor(Colors.white);
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);

    void _scoreGameButtonPress(
        GlobalKey<ScaffoldState> scaffoldKey, bool hasKey) {
      if (hasKey) {
        TournamentViewing.of(context).changeMode(ViewingMode.scoring);
        Router.navigator.pushNamed(Router.tournaments);
      } else {
        _scaffoldKey.currentState.removeCurrentSnackBar();
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text("Please log in to score games"),
            action: SnackBarAction(
              label: "log in",
              onPressed: () async {
                Router.navigator.pushNamed(Router.login);
              },
            ),
          ),
        );
      }
    }

    _manageTournamentButtonPress(
      GlobalKey<ScaffoldState> scaffoldKey,
      bool hasKey,
    ) {
      if (hasKey) {
        TournamentViewing.of(context).changeMode(ViewingMode.editing);
        Router.navigator.pushNamed(Router.tournaments);
      } else {
        _scaffoldKey.currentState.removeCurrentSnackBar();
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text("Please log in to manage tournaments"),
            action: SnackBarAction(
              label: "log in",
              onPressed: () async {
                Router.navigator.pushNamed(Router.login);
              },
            ),
          ),
        );
      }
    }

    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, snapshot) {
        return Scaffold(
          key: _scaffoldKey,
          extendBodyBehindAppBar: true,
          extendBody: true,
          appBar: CustomAppBar(
            title: '',
            transparentBackground: true,
            actions: <Widget>[
              snapshot.hasData
                  ? Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      margin: const EdgeInsets.only(
                        right: 16,
                        top: 8,
                        bottom: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 2),
                            blurRadius: 1,
                            color: Colors.grey,
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () => Router.navigator.pushNamed(
                            Router.account,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'Account',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
          body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/img/largebg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: OrientationBuilder(
                  builder: (context, orientation) {
                    if (orientation == Orientation.portrait) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(height: 50),
                          Image.asset(
                            'assets/img/pondhockeybrand.png',
                            height: MediaQuery.of(context).size.height * 0.5,
                          ),
                          const SizedBox(height: 50),
                          _PortraitMenuButton(
                            onPressed: () {
                              TournamentViewing.of(context)
                                  .changeMode(ViewingMode.viewing);
                              Router.navigator.pushNamed(Router.tournaments);
                            },
                            text: 'View Results',
                          ),
                          const SizedBox(height: 30),
                          _PortraitMenuButton(
                            onPressed: () {
                              _scoreGameButtonPress(
                                _scaffoldKey,
                                snapshot.hasData,
                              );
                            },
                            text: 'Score Games',
                          ),
                          const SizedBox(height: 30),
                          _PortraitMenuButton(
                            onPressed: () {
                              _manageTournamentButtonPress(
                                _scaffoldKey,
                                snapshot.hasData,
                              );
                            },
                            text: 'Manage Tournaments',
                          ),
                        ],
                      );
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/img/pondhockeybrand.png',
                            height: MediaQuery.of(context).size.height * 0.8,
                          ),
                          const SizedBox(width: 50),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              _LandscapeMenuButton(
                                onPressed: () {
                                  TournamentViewing.of(context)
                                      .changeMode(ViewingMode.viewing);
                                  Router.navigator
                                      .pushNamed(Router.tournaments);
                                },
                                text: 'View Results',
                              ),
                              const SizedBox(height: 30),
                              _LandscapeMenuButton(
                                onPressed: () {
                                  _scoreGameButtonPress(
                                    _scaffoldKey,
                                    snapshot.data,
                                  );
                                },
                                text: 'Score Games',
                              ),
                              const SizedBox(height: 30),
                              _LandscapeMenuButton(
                                onPressed: () {
                                  _manageTournamentButtonPress(
                                    _scaffoldKey,
                                    snapshot.hasData,
                                  );
                                },
                                text: 'Manage Tournaments',
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LandscapeMenuButton extends StatelessWidget {
  const _LandscapeMenuButton({
    this.onPressed,
    this.text,
  });

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    var btnWidth = MediaQuery.of(context).size.width * 0.35;
    var fontSize = MediaQuery.of(context).size.width * 0.03;
    var btnHeight = MediaQuery.of(context).size.height * 0.13;

    return Container(
      width: btnWidth,
      height: btnHeight,
      child: RaisedButton(
        onPressed: onPressed,
        color: Colors.white,
        padding: EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          maxLines: 1,
          style: TextStyle(
            fontSize: fontSize,
            fontFamily: 'CircularStd',
          ),
        ),
      ),
    );
  }
}

class _PortraitMenuButton extends StatelessWidget {
  const _PortraitMenuButton({
    this.onPressed,
    this.text,
  });

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    var btnWidth = MediaQuery.of(context).size.width * 0.75;
    var fontSize = MediaQuery.of(context).size.width * 0.06;
    var btnHeight = MediaQuery.of(context).size.height * 0.07;

    return Container(
      width: btnWidth,
      height: btnHeight,
      child: RaisedButton(
        onPressed: onPressed,
        color: Colors.white,
        padding: EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize,
            fontFamily: 'CircularStd',
          ),
        ),
      ),
    );
  }
}
