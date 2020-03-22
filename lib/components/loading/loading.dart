import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
        child: LoadingBouncingGrid.square(
          backgroundColor: Colors.red,
        ),
      ),
    );
  }
}
