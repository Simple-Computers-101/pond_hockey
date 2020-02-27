import 'package:flutter/material.dart';
import 'package:pond_hockey/models/game.dart';
import 'package:pond_hockey/services/databases/games_repository.dart';

class GameItem extends StatelessWidget {
  const GameItem({Key key, this.game}) : super(key: key);

  final Game game;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: GamesRepository().getStreamFromGameId(game.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          var gameData = Game.fromDocument(snapshot.data);
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text('Team One'),
                  Text('${gameData.teamOne['score']}'),
                ],
              ),
              Column(
                children: <Widget>[
                  Text('Team Two'),
                  Text('${gameData.teamTwo['score']}'),
                ],
              ),
            ],
          );
        }
        return null;
      },
    );
  }
}
