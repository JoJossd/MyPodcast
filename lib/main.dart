import 'package:flutter/material.dart';
import 'package:my_podcast/ui/homepage.dart';

void main() => runApp(MyPodcastApp());

class MyPodcastApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Podcast',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 255, 219, 0),
        iconTheme: IconThemeData(size: 50.0),
      ),
      home: HomePage(),
    );
  }
}
