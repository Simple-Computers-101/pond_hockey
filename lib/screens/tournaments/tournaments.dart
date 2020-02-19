import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pond_hockey/components/appbar/appbar.dart';
import 'package:pond_hockey/screens/tournaments/widgets/tournaments_list.dart';
import 'package:pond_hockey/services/databases/tournaments_repository.dart';
import 'package:provider/provider.dart';

class TournamentsScreen extends StatelessWidget {
  const TournamentsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stream = Provider.of<TournamentsRepository>(context).ref.snapshots();

    Widget buildLoading() {
      return CircularProgressIndicator();
    }

    Widget buildError(Object error) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Uh oh!',
            style: Theme.of(context).textTheme.display3,
          ),
          Text(error.toString()),
        ],
      );
    }

    return Scaffold(
      appBar: CustomAppBar(title: 'Tournaments'),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: stream,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return buildLoading();
              case ConnectionState.waiting:
                return buildLoading();
              case ConnectionState.active:
                return buildLoading();
              case ConnectionState.done:
                if (snapshot.hasError) {
                  buildError(snapshot.error);
                }
                if (snapshot.hasData) {
                  return TournamentsList(
                    documents: snapshot.data.documents,
                  );
                }
            }
            return null;
          },
        ),
      ),
    );
  }
}
