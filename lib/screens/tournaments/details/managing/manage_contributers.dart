import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pond_hockey/bloc/add_contributers_form/add_contributers_form.dart';
import 'package:pond_hockey/components/appbar/tabbar.dart';

class ManageContributers extends StatelessWidget {
  const ManageContributers({this.tournamentId});

  final String tournamentId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddContributersFormBloc(),
      child: Builder(
        builder: (context) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: CustomAppBarWithTabBar(
                title: 'Manage Contributers',
                transparentBackground: true,
                tabs: <Widget>[
                  Tab(text: 'Editors'),
                  Tab(text: 'Scorers'),
                ],
              ),
              extendBodyBehindAppBar: true,
              body: TabBarView(
                children: <Widget>[
                  _ManageEditors(tournamentId: tournamentId),
                  _ManageScorers(tournamentId: tournamentId),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ManageEditors extends StatelessWidget {
  const _ManageEditors({this.tournamentId});

  final String tournamentId;

  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
      query: null,
      itemBuilder: null,
    );
  }
}

class _ManageScorers extends StatelessWidget {
  const _ManageScorers({this.tournamentId});

  final String tournamentId;

  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
      query: null,
      itemBuilder: null,
    );
  }
}
