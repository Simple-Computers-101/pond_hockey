import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pond Hockey',
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      backgroundColor: Colors.black,
      image: Image.asset('assets/img/logo.png'),
      loadingText: Text(
        'Loading Pond Hockey Scoring App',
        style: TextStyle(fontSize: 15, color: Colors.white),
      ),
      loaderColor: Colors.white,
      photoSize: 150,
      navigateAfterSeconds: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
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
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/img/largebg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                children: <Widget>[
                  Image.asset('assets/img/pondhockeybrand.png'),
                  const SizedBox(height: 50),
                  FlatButton(
                    onPressed: () {},
                    color: Colors.lightBlue,
                    padding: EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(color: Colors.black),
                    ),
                    child: Text(
                      'View Results',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  FlatButton(
                    onPressed: () {},
                    padding: EdgeInsets.all(8.0),
                    color: Colors.lightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(color: Colors.black),
                    ),
                    child: Text(
                      'Score Games',
                      style: TextStyle(
                        fontSize: 30.00,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  FlatButton(
                    onPressed: () {},
                    color: Colors.lightBlue,
                    padding: EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(color: Colors.black),
                    ),
                    child: Text(
                      'Create Tournament',
                      style: TextStyle(
                        fontSize: 30.00,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
