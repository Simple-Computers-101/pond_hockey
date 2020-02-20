import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pond_hockey/router/router.gr.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/largebg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/img/pondhockeybrand.png'),
                  const SizedBox(height: 25),
                  const Divider(
                    color: Colors.white,
                    thickness: 15,
                    indent: 20,
                    endIndent: 20,
                  ),
                  const SizedBox(height: 25),
                  _PortraitMenuButton(
                    onPressed: () {
                      Router.navigator.pushNamed(Router.tournaments);
                    },
                    text: 'View Results',
                  ),
                  const SizedBox(height: 30),
                  _PortraitMenuButton(
                    onPressed: () {},
                    text: 'Score Games',
                  ),
                  const SizedBox(height: 30),
                  _PortraitMenuButton(
                    onPressed: () {},
                    text: 'Create Tournament',
                  ),
                ],
              );
            } else {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(width: 25),
                  Image.asset('assets/img/pondhockeybrand.png'),
                  const SizedBox(width: 25),
                  const VerticalDivider(
                    color: Colors.white,
                    thickness: 15,
                    indent: 20,
                    endIndent: 20,
                  ),
                  const SizedBox(width: 25),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _LandscapeMenuButton(
                        onPressed: () {},
                        text: 'View Results',
                      ),
                      const SizedBox(height: 30),
                      _LandscapeMenuButton(
                        onPressed: () {},
                        text: 'Score Games',
                      ),
                      const SizedBox(height: 30),
                      _LandscapeMenuButton(
                        onPressed: () {},
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
    );
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
            fontSize: 30,
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
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}
