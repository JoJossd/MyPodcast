import 'package:flutter/material.dart';
import 'package:my_podcast/widget/theme_manager.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: appThemeData.length,
          itemBuilder: (BuildContext context, int index) {
            final ThemeName theme = ThemeName.values[index];
            return Card(
              color: appThemeData[theme].primaryColor,
              child: ListTile(
                onTap: () => Provider.of<ThemeManager>(context, listen: false)
                    .setTheme(theme),
                title: Text(
                  enumParse(theme),
                  style: appThemeData[theme].textTheme.body1,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
