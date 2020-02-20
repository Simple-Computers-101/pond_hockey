
import 'package:auto_route/auto_route_annotations.dart';
import 'package:pond_hockey/initial_screen.dart';
import 'package:pond_hockey/screens/home/home.dart';
import 'package:pond_hockey/screens/login/login.dart';
import 'package:pond_hockey/screens/tournaments/tournaments.dart';

@AutoRouter(generateRouteList: true)
class $Router {
  @initial
  InitialScreen init;
  HomeScreen home;
  LoginScreen login;
  TournamentsScreen tournaments;
}