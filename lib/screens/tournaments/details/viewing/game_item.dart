import 'package:flutter/material.dart';
import 'package:pond_hockey/models/game.dart';
import 'package:pond_hockey/services/databases/games_repository.dart';

class GameItem extends StatelessWidget {
  const GameItem({@required this.gameId, this.onTap});

  final String gameId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Widget buildLoading() {
      return Center(child: CircularProgressIndicator());
    }

    return FutureBuilder(
      future: GamesRepository().getStreamFromGameId(gameId),
      builder: (context, future) {
        if (!future.hasData) {
          return buildLoading();
        }
        var stream = future.data as Stream<Game>;
        return StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {
            if ((snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.connectionState == ConnectionState.none) ||
                !snapshot.hasData) {
              return buildLoading();
            }
            var gameData = snapshot.data as Game;
            return InkWell(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text('${gameData.teamOne.name}'),
                        Text(
                          '${gameData.teamOne.score}',
                          style: TextStyle(
                            fontSize: 32,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text('${gameData.teamTwo.name}'),
                        Text(
                          '${gameData.teamTwo.score}',
                          style: TextStyle(
                            fontSize: 32,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
