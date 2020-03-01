import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:pond_hockey/models/tournament.dart';

class TournamentSettingsScreen extends StatelessWidget {
  const TournamentSettingsScreen({this.tournament});

  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    Widget buildDivider() {
      return const Divider(
        height: 15,
        indent: 15,
        endIndent: 15,
      );
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            color: Colors.red,
            height: MediaQuery.of(context).size.height * 0.25,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.08,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.2,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 30,
              vertical: MediaQuery.of(context).size.height * 0.15,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Material(
              type: MaterialType.transparency,
              child: Column(
                children: <Widget>[
                  SettingsTile(
                    text: 'Editors',
                    icon: OMIcons.edit,
                    onTap: () {},
                  ),
                  buildDivider(),
                  SettingsTile(
                    text: 'Another Setting',
                    icon: OMIcons.edit,
                    onTap: () {},
                  ),
                  buildDivider(),
                  SettingsTile(
                    text: 'Another Setting',
                    icon: OMIcons.edit,
                    onTap: () {},
                  ),
                  buildDivider(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    this.icon,
    this.text,
    this.onTap,
  });

  final IconData icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 25,
      ),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[300],
        ),
        child: Icon(icon, color: Colors.blueAccent,),
      ),
      title: Text(text),
      onTap: onTap,
    );
  }
}
