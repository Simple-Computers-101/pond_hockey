import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  CustomAppBar({
    @required this.title,
    this.actions = const <Widget>[],
    this.transparentBackground = false,
  });

  final String title;
  final List<Widget> actions;
  final bool transparentBackground;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: TextOneLine(
        title,
        // style: Theme.of(context).textTheme.headline5,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontFamily: 'CircularStd',
          fontSize: 24,
        ),
      ),
      centerTitle: true,
      actions: actions,
      backgroundColor: transparentBackground
          ? Colors.transparent
          : Theme.of(context).scaffoldBackgroundColor,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}
