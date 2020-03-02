import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGuard extends RouteGuard {
  @override
  Future<bool> canNavigate(
      BuildContext context, String routeName, Object arguments) async {
    var user = await FirebaseAuth.instance.currentUser();
    return user != null;
  }
}
