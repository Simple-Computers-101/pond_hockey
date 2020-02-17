import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
    
    void main () {
      runApp(new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: new MyApp(),
      ));
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
          loadingText: Text('Loading Pond Hockey Scoring App', style: TextStyle(fontSize: 15, color: Colors.white)),
          loaderColor: Colors.white,
          photoSize: 150,
          navigateAfterSeconds: MainScreen(),

        );
      }
    }


class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
          centerTitle: true,
          title: Text('Pond Hockey Scoring')
      ),
      body: Center(
        child: Text(
          'MainScreen',
          style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}