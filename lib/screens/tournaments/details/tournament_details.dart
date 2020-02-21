import 'package:flutter/material.dart';
import 'package:pond_hockey/models/tournament.dart';

class TournamentDetails extends StatefulWidget {
  const TournamentDetails({Key key, this.tournament}) : super(key: key);

  final Tournament tournament;

  @override
  _TournamentDetailsState createState() => _TournamentDetailsState();
}

class _TournamentDetailsState extends State<TournamentDetails> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Color(0xFF0094FF),
        body: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              SliverAppBar(
                centerTitle: true,
                title: Text(
                  widget.tournament.name,
                  style: Theme.of(context).textTheme.headline5,
                ),
                bottom: TabBar(
                  tabs: [
                    Tab(text: 'Item One'),
                    Tab(text: 'Item Two'),
                    Tab(text: 'Item Three'),
                  ],
                  indicator: UnderlineTabIndicator(
                    insets: const EdgeInsets.symmetric(horizontal: 150),
                    borderSide: BorderSide(
                      width: 2,
                      
                    ),
                  ),
                ),
              ),
            ];
          },
          body: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              color: Color(0xFFE9E9E9),
            ),
            child: TabBarView(children: [
              Container(
                color: Colors.green,
              ),
              Container(
                color: Colors.red,
              ),
              Container(
                color: Colors.yellow,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
