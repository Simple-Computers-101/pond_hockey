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
          title: Text('Pond Hockey Scoring'),
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

            Center (
              child: Column(
                children: <Widget>[
                  Container(
                    child:
                    Image.asset('assets/img/pondhockeybrand.png'),
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: FlatButton(
                      onPressed: (){},
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                          side: BorderSide(color: Colors.black)
                      ),
                      child: Text(
                        'View Results',
                        style: TextStyle(
                          fontSize: 30.00,
                        ),),
                      color: Colors.lightBlue,
                      padding: EdgeInsets.all(8.0),
                    ),

                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: FlatButton(
                      onPressed: (){},
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                          side: BorderSide(color: Colors.black)
                      ),
                      child: Text(
                        'Score Games',
                        style: TextStyle(
                          fontSize: 30.00,
                        ),),
                      color: Colors.lightBlue,
                      padding: EdgeInsets.all(8.0),
                    ),

                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: FlatButton(
                      onPressed: (){},
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                          side: BorderSide(color: Colors.black)
                      ),
                      child: Text(
                        'Create Tournament',
                        style: TextStyle(
                          fontSize: 30.00,
                        ),),
                      color: Colors.lightBlue,
                      padding: EdgeInsets.all(8.0),
                    ),

                  ),
                ],
              ),
            ),


          ],
        )
    );
  }
}