import 'package:flutter/material.dart';
import 'package:my_podcast/page/home_page.dart';
import 'package:provider/provider.dart';

import 'model/rssfeed_data.dart';

void main() => runApp(MyPodcastApp());

class MyPodcastApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // _ represents the context of ChangeNotifierProvider
      create: (_) => Podcast()..getItems(),
      child: MaterialApp(
        title: 'My Podcast',
        theme: ThemeData(
          primaryColor: Color.fromARGB(255, 255, 219, 0),
          iconTheme: IconThemeData(size: 50.0),
        ),
        home: HomePage(),
      ),
    );
  }
}
