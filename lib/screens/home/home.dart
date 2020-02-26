import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pond_hockey/components/appbar/appbar.dart';
import 'package:pond_hockey/router/router.gr.dart';
import 'package:pond_hockey/screens/login/login.dart';

class HomeScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
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
              FlatButton(
                color: Colors.white,
                onPressed: () async {
                  Router.navigator.pushNamed(Router.account);
                },
                child: Text("Account"),
              )
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
                          SvgPicture.asset(
                            'assets/svg/pondhockey.svg',
                            height: MediaQuery.of(context).size.height * 0.4,
                          ),
                          const SizedBox(height: 50),
                          _PortraitMenuButton(
                            onPressed: () {
                              Router.navigator.pushNamed(Router.tournaments);
                            },
                            text: 'View Results',
                          ),
                          const SizedBox(height: 30),
                          _PortraitMenuButton(
                            onPressed: () {
                              _scoreGameButtonPress(
                                  _scaffoldKey, context, snapshot.hasData);
                            },
                            text: 'Score Games',
                          ),
                          const SizedBox(height: 30),
                          _PortraitMenuButton(
                            onPressed: () {
                              _manageTournamentButtonPress(
                                  _scaffoldKey, context, snapshot.hasData);
                            },
                            text: 'Manage Tournaments',
                          ),
                        ],
                      );
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset(
                            'assets/svg/pondhockey.svg',
                            height: MediaQuery.of(context).size.height * 0.8,
                          ),
                          const SizedBox(width: 50),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              _LandscapeMenuButton(
                                onPressed: () {
                                  Router.navigator
                                      .pushNamed(Router.tournaments);
                                },
                                text: 'View Results',
                              ),
                              const SizedBox(height: 30),
                              _LandscapeMenuButton(
                                onPressed: () {
                                  _scoreGameButtonPress(
                                      _scaffoldKey, context, snapshot.data);
                                },
                                text: 'Score Games',
                              ),
                              const SizedBox(height: 30),
                              _LandscapeMenuButton(
                                onPressed: () {
                                  _manageTournamentButtonPress(
                                      _scaffoldKey, context, snapshot.hasData);
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

  _scoreGameButtonPress(
      GlobalKey<ScaffoldState> scaffoldKey, BuildContext context, bool hasKey) {
    if (hasKey) {
      Router.navigator.pushNamed(
        Router.tournaments,
        arguments: TournamentsScreenArguments(
          scoringMode: true,
        ),
      );
    } else {
      _scaffoldKey.currentState.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Please log in to score games"),
          action: SnackBarAction(
              label: "log in",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginScreen(),
                    fullscreenDialog: true,
                  ),
                );
              }),
        ),
      );
    }
  }

  _manageTournamentButtonPress(
      GlobalKey<ScaffoldState> scaffoldKey, BuildContext context, bool hasKey) {
    if (hasKey) {
      Router.navigator.pushNamed(
        Router.tournaments,
        arguments: TournamentsScreenArguments(
          scoringMode: false,
          editMode: true,
        ),
      );
    } else {
      _scaffoldKey.currentState.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Please log in to manage tournaments"),
          action: SnackBarAction(
              label: "log in",
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginScreen(),
                    fullscreenDialog: true,
                  ),
                );
              }),
        ),
      );
    }
  }
}

class _LandscapeMenuButton extends StatelessWidget {
  const _LandscapeMenuButton({
    Key key,
    this.onPressed,
    this.text,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    var btnSize = MediaQuery.of(context).size.width * 0.35;
    var fontSize = MediaQuery.of(context).size.width * 0.03;

    return Container(
      width: btnSize,
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
          ),
        ),
      ),
    );
  }
}

class _PortraitMenuButton extends StatelessWidget {
  const _PortraitMenuButton({
    Key key,
    this.onPressed,
    this.text,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    var btnSize = MediaQuery.of(context).size.width * 0.75;
    var fontSize = MediaQuery.of(context).size.width * 0.06;

    return Container(
      width: btnSize,
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
          ),
        ),
      ),
    );
  }
}
