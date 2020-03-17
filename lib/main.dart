import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_podcast/page/home_page.dart';
import 'package:my_podcast/model/rssfeed_data.dart';

void main() => runApp(MyPodcastApp());

class MyPodcastApp extends StatelessWidget {
  @override
  Widget build(BuildContext myPodcastAppContext) {
    // ChangeNotifierProvider is built on myPodcastAppContext
    return ChangeNotifierProvider(
      /*
      _ is the context of ChangeNotifierProvider,
      which is located below MyPodcastApp widget and above MaterialApp widget,
      which cannot be used.

      when instantiate Podcast(), we need to call getItems() function,
      to get access to _items.

      ..=> execute the function on the returned object(in this case: Podcast()), 
      but after which don't return the result of this function.
      */
      create: (_) => Podcast()..parseFeed(),
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
