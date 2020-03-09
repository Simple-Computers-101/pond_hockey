import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pond_hockey/bloc/add_contributers_form/add_contributers_form.dart';
import 'package:pond_hockey/components/appbar/tabbar.dart';
import 'package:pond_hockey/screens/tournaments/details/managing/contributers/editor/editor.dart';
import 'package:pond_hockey/screens/tournaments/details/managing/contributers/scorer/scorer.dart';

class ManageContributors extends StatelessWidget {
  const ManageContributors({this.tournamentId});

  final String tournamentId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddContributorsFormBloc(),
      child: Builder(
        builder: (context) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: CustomAppBarWithTabBar(
                title: 'Manage Contributors',
                transparentBackground: true,
                tabs: <Widget>[
                  Tab(text: 'Editors'),
                  Tab(text: 'Scorers'),
                ],
              ),
              extendBodyBehindAppBar: true,
              body: TabBarView(
                children: <Widget>[
                  ManageEditors(tournamentId: tournamentId),
                  ManageScorers(tournamentId: tournamentId),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
