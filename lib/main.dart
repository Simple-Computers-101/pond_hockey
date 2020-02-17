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
    return new Scaffold(
        appBar: AppBar(
          title: Text('Pond Hockey Timing'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: new Stack(
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("assets/img/largebg.jpg"),
                  fit: BoxFit.cover,),
              ),
            ),
            new Column(
              children: <Widget>[
                Text('Create Tournment')
              ],
            ),
            new Center(
              child: new FlatButton(
                  onPressed: (){},
                  child: Text('View Results'),
                  color: Colors.lightBlue,
                  )
            ),
          ],
        )
    );
  }
}