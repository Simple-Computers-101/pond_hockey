import 'package:auto_route/auto_route.dart';
import 'package:auto_route/auto_route_annotations.dart';
import 'package:pond_hockey/router/guard.dart';
import 'package:pond_hockey/screens/account/account.dart';
import 'package:pond_hockey/screens/home/home.dart';
import 'package:pond_hockey/screens/login/forget.dart';
import 'package:pond_hockey/screens/login/login.dart';
import 'package:pond_hockey/screens/tournaments/add_teams/add_teams.dart';
import 'package:pond_hockey/screens/tournaments/add_tournament/add_tournament.dart';
import 'package:pond_hockey/screens/tournaments/details/managing/manage_game.dart';
import 'package:pond_hockey/screens/tournaments/details/managing/manage_tournament.dart';
import 'package:pond_hockey/screens/tournaments/details/scoring/score_tournament.dart';
import 'package:pond_hockey/screens/tournaments/details/viewing/view_team.dart';
import 'package:pond_hockey/screens/tournaments/details/viewing/view_tournament.dart';
import 'package:pond_hockey/screens/tournaments/tournaments.dart';

@CustomAutoRouter(transitionsBuilder: TransitionsBuilders.slideBottom)
class $Router {
  @initial
  HomeScreen home;

  @GuardedBy([UnAuthGuard])
  LoginScreen login;

  ForgotPassword forgotPassword;

  @GuardedBy([AuthGuard])
  AccountScreen account;

  TournamentsScreen tournaments;

  ViewTournament tournamentDetails;

  @GuardedBy([AuthGuard])
  ScoreTournament scoreTournament;

  @GuardedBy([AuthGuard])
  ManageTournament manageTournament;

  @GuardedBy([AuthGuard])
  ManageGame manageGame;

  TeamDetailsScreen teamDetails;

  @GuardedBy([AuthGuard])
  AddTournamentScreen addTournament;

  @GuardedBy([AuthGuard])
  AddTeamsScreen addTeams;
}
