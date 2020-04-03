import 'package:flutter/material.dart';
import 'package:my_podcast/page/settings_page.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent.withOpacity(0.7),
      width: MediaQuery.of(context).size.width * 0.45,
      height: MediaQuery.of(context).size.height,
      // color: Theme.of(context).primaryColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.9)),
            child: null,
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.settings),
                Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text("Settings"),
                )
              ],
            ),
            onTap: () {
              // close the drawer when navigate to other page
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (newContext) => SettingsPage()),
              );
            },
          )
        ],
      ),
    );
  }
}
