import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    Key key,
    this.onPressed,
    this.width = 150,
    this.height = 50,
  }) : super(key: key);

  final VoidCallback onPressed;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.white,
      ),
      height: height,
      width: width,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(50),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  'assets/img/google.png',
                  width: 30,
                  height: 50,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Center(
                  child: Text('Google'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AppleSignInButton extends StatelessWidget {
  const AppleSignInButton({Key key, this.onPressed}) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.white,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image.asset(
                'assets/img/apple.png',
                width: 30,
                height: 50,
              ),
              Text('Apple'),
            ],
          ),
        ),
      ),
    );
  }
}
