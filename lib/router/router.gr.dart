// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:pond_hockey/screens/home/home.dart';
import 'package:pond_hockey/screens/login/login.dart';
import 'package:pond_hockey/screens/account/account.dart';
import 'package:pond_hockey/screens/tournaments/tournaments.dart';
import 'package:pond_hockey/screens/tournaments/details/tournament_details.dart';
import 'package:pond_hockey/models/tournament.dart';
import 'package:pond_hockey/screens/tournaments/details/settings.dart';
import 'package:pond_hockey/screens/tournaments/details/team_details.dart';
import 'package:pond_hockey/models/team.dart';
import 'package:pond_hockey/screens/tournaments/add_tournament/add_tournament.dart';
import 'package:pond_hockey/screens/tournaments/add_teams/add_teams.dart';

class Router {
  static const home = '/';
  static const login = '/login';
  static const account = '/account';
  static const tournaments = '/tournaments';
  static const tournamentDetails = '/tournament-details';
  static const tournamentSettings = '/tournament-settings';
  static const teamDetails = '/team-details';
  static const addTournament = '/add-tournament';
  static const addTeams = '/add-teams';
  static const _guardedRoutes = const {};
  static final navigator = ExtendedNavigator();
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Router.home:
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) => HomeScreen(),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.slideTop,
        );
      case Router.login:
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) => LoginScreen(),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.fadeIn,
        );
      case Router.account:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) =>
              AccountScreen(key: typedArgs),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        );
      case Router.tournaments:
        if (hasInvalidArgs<TournamentsScreenArguments>(args)) {
          return misTypedArgsRoute<TournamentsScreenArguments>(args);
        }
        final typedArgs =
            args as TournamentsScreenArguments ?? TournamentsScreenArguments();
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) =>
              TournamentsScreen(
                  key: typedArgs.key,
                  scoringMode: typedArgs.scoringMode,
                  editMode: typedArgs.editMode),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        );
      case Router.tournamentDetails:
        if (hasInvalidArgs<TournamentDetailsArguments>(args)) {
          return misTypedArgsRoute<TournamentDetailsArguments>(args);
        }
        final typedArgs =
            args as TournamentDetailsArguments ?? TournamentDetailsArguments();
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) =>
              TournamentDetails(
                  key: typedArgs.key, tournament: typedArgs.tournament),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.slideRightWithFade,
        );
      case Router.tournamentSettings:
        if (hasInvalidArgs<TournamentSettingsScreenArguments>(args)) {
          return misTypedArgsRoute<TournamentSettingsScreenArguments>(args);
        }
        final typedArgs = args as TournamentSettingsScreenArguments ??
            TournamentSettingsScreenArguments();
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) =>
              TournamentSettingsScreen(
                  key: typedArgs.key, tournament: typedArgs.tournament),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.slideRightWithFade,
        );
      case Router.teamDetails:
        if (hasInvalidArgs<TeamDetailsScreenArguments>(args)) {
          return misTypedArgsRoute<TeamDetailsScreenArguments>(args);
        }
        final typedArgs =
            args as TeamDetailsScreenArguments ?? TeamDetailsScreenArguments();
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) =>
              TeamDetailsScreen(key: typedArgs.key, team: typedArgs.team),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.slideRightWithFade,
        );
      case Router.addTournament:
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) =>
              AddTournamentScreen(),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.slideRight,
        );
      case Router.addTeams:
        if (hasInvalidArgs<Tournament>(args, isRequired: true)) {
          return misTypedArgsRoute<Tournament>(args);
        }
        final typedArgs = args as Tournament;
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) =>
              AddTeamsScreen(tournament: typedArgs),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.slideRight,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

//**************************************************************************
// Arguments holder classes
//***************************************************************************

//TournamentsScreen arguments holder class
class TournamentsScreenArguments {
  final Key key;
  final bool scoringMode;
  final bool editMode;
  TournamentsScreenArguments(
      {this.key, this.scoringMode = false, this.editMode = false});
}

//TournamentDetails arguments holder class
class TournamentDetailsArguments {
  final Key key;
  final Tournament tournament;
  TournamentDetailsArguments({this.key, this.tournament});
}

//TournamentSettingsScreen arguments holder class
class TournamentSettingsScreenArguments {
  final Key key;
  final Tournament tournament;
  TournamentSettingsScreenArguments({this.key, this.tournament});
}

//TeamDetailsScreen arguments holder class
class TeamDetailsScreenArguments {
  final Key key;
  final Team team;
  TeamDetailsScreenArguments({this.key, this.team});
}
