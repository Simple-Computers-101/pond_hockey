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
    final repo = Provider.of<TournamentsRepository>(context);

    Widget buildLoading() {
      return Center(child: CircularProgressIndicator());
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
          stream: Firestore.instance.collection('tournaments').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return buildLoading();
            } else if (snapshot.hasError) {
              return buildError(snapshot.error);
            }
            return TournamentsList(
              documents: snapshot.data.documents,
            );
          },
        ),
      ),
    );
  }
}
