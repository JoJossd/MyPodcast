import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_podcast/widget/theme_manager.dart';
import 'package:my_podcast/page/home_page.dart';
import 'package:my_podcast/model/rssfeed_data.dart';

void main() => runApp(MyPodcastApp());

class MyPodcastApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Podcast()..parseFeed()),
        ChangeNotifierProvider(create: (_) => ThemeManager()),
      ],
      child: Consumer<ThemeManager>(
        builder: (_, themeManager, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'My Podcast',
            theme: themeManager.themeData,
            home: HomePage(),
          );
        },
      ),
    );
  }
}
