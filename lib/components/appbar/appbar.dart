import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  CustomAppBar({
    Key key,
    @required this.title,
    this.actions = const <Widget>[],
    this.transparentBackground = false,
  }) : super(key: key);

  final String title;
  final List<Widget> actions;
  final bool transparentBackground;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline,
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
