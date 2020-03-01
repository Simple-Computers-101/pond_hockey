import 'package:flutter/material.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';

class CustomAppBarWithTabBar extends StatelessWidget with PreferredSizeWidget {
  CustomAppBarWithTabBar({
    @required this.title,
    @required this.tabs,
    this.actions = const <Widget>[],
    this.transparentBackground = false,
  });

  final String title;
  final List<Widget> tabs;
  final List<Widget> actions;
  final bool transparentBackground;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
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
      bottom: TabBar(
        tabs: tabs,
        isScrollable: false,
        labelStyle: TextStyle(
          fontWeight: FontWeight.w700,
        ),
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: Color(0xFF1a73e8),
        unselectedLabelColor: Color(0xFF5f6368),
        indicator: MD2Indicator(
          indicatorHeight: 3,
          indicatorColor: Color(0xFF1a73e8),
          indicatorSize: MD2IndicatorSize.normal,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(104);
}
