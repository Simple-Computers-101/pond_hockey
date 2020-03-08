import 'package:flutter/material.dart';
import 'package:pond_hockey/enums/game_status.dart';
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
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${gameData.teamOne.name}',
                                maxLines: 1,
                              ),
                              Text(
                                '${gameData.teamOne.score}',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 32,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                '${gameData.teamTwo.name}',
                                maxLines: 1,
                              ),
                              Text(
                                '${gameData.teamTwo.score}',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 32,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      child: Text(
                        gameStatus[gameData.status],
                        textAlign: TextAlign.right,
                      ),
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
