
import 'package:auto_route/auto_route_annotations.dart';
import 'package:pond_hockey/initial_screen.dart';
import 'package:pond_hockey/screens/account/account.dart';
import 'package:pond_hockey/screens/home/home.dart';
import 'package:pond_hockey/screens/login/login.dart';
import 'package:pond_hockey/screens/tournaments/add_teams/add_teams.dart';
import 'package:pond_hockey/screens/tournaments/add_tournament/add_tournament.dart';
import 'package:pond_hockey/screens/tournaments/details/team_details.dart';
import 'package:pond_hockey/screens/tournaments/details/tournament_details.dart';
import 'package:pond_hockey/screens/tournaments/tournaments.dart';

@CustomAutoRouter()
class $Router {
  @initial
  InitialScreen init;
  HomeScreen home;
  LoginScreen login;
  AccountScreen account;
  TournamentsScreen tournaments;
  TournamentDetails tournamentDetails;
  TeamDetailsScreen teamDetails;
  AddTournamentScreen addTournament;
  AddTeamsScreen addTeams;
}