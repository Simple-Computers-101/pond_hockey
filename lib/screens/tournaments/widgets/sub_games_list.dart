import 'package:flutter/material.dart';
import 'package:pond_hockey/models/game.dart';
import 'package:pond_hockey/router/router.gr.dart';
import 'package:pond_hockey/screens/tournaments/widgets/game_item.dart';

class SubGamesList extends StatelessWidget {
  const SubGamesList({@required this.data, @required this.isManaging});

  final List<Game> data;
  final bool isManaging;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: data.length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (cntx, indx) {
        var game = data[indx];
        return GameItem(
          gameId: game.id,
          onTap: isManaging
              ? () {
                  Router.navigator.pushNamed(
                    Routes.manageGame,
                    arguments: game,
                  );
                }
              : null,
        );
      },
      separatorBuilder: (cntx, _) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.015,
      ),
    );
  }
}
