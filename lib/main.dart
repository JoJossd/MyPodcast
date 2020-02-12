import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

final feedUrl = 'https://aezfm.meldingcloud.com/rss/program/11';

void main() => runApp(MyPodcastApp());

class Podcast with ChangeNotifier {
  void getItem() async {
    final response = await http.get(feedUrl);
    if (response != null && response.statusCode == 200) {
      final rssString = utf8.decode(response.bodyBytes);
      final rssDocument = xml.parse(rssString);
      final items = rssDocument.findAllElements('item');
    }
    notifyListeners();
  }
}

class MyPodcastApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Podcast(),
      child: MaterialApp(
        title: 'My Podcast',
        theme: ThemeData(
          primaryColor: Color.fromARGB(255, 255, 219, 0),
          iconTheme: IconThemeData(size: 50.0),
        ),
        home: EpisodesPage(),
      ),
    );
  }
}

class EpisodesPage extends StatelessWidget {
  final feedUrl = 'https://aezfm.meldingcloud.com/rss/program/11';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Episode List'),
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: FutureBuilder(
          future: http.get(feedUrl),
          builder: (context, AsyncSnapshot<http.Response> snapshot) {
            if (snapshot.hasData) {
              final response = snapshot.data;
              if (response.statusCode == 200) {
                final rssString = utf8.decode(response.bodyBytes);
                var rssDocument = xml.parse(rssString);
                var items = rssDocument.findAllElements('item');
                return EpisodeListView(items: items);
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

class EpisodeListView extends StatelessWidget {
  const EpisodeListView({Key key, @required this.items}) : super(key: key);

  final Iterable<xml.XmlElement> items;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: items
          .map(
            (i) => ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Text(
                i.findElements('title').single.text,
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text(
                i.findElements('itunes:summary').single.text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => PlayerPage(item: i)));
              },
            ),
          )
          .toList(),
    );
  }
}

class PlayerPage extends StatelessWidget {
  PlayerPage({this.item});
  final xml.XmlElement item;

  final imageurl =
      'http://resezfm.meldingcloud.com/image/1904/1555550145451.jpg?x-oss-process=image/resize,w_350';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(item.findElements('title').single.text),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 8,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                    child: Card(
                      elevation: 16,
                      child: Image.network(imageurl),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text('some episode description'),
                  )
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: Panel(),
            )
          ],
        ),
      ),
    );
  }
}

class Panel extends StatefulWidget {
  @override
  _PanelState createState() => _PanelState();
}

class _PanelState extends State<Panel> {
  bool _isPlaying = false;
  FlutterSound _sound;
  final feedUrl = 'https://aezfm.meldingcloud.com/rss/program/11';
  // TODO: Why can't play local audio?
  // final uri = 'assets/sample.mp3';
  double _playPosition;
  Stream<PlayStatus> _playerSubscription;

  // TODO: Why should we set initState?
  // -> to set the initial value of some variables when the app lunchs.
  @override
  void initState() {
    super.initState();
    _sound = FlutterSound();
    _playPosition = 0;
  }

  Future<void> _play() async {
    await _sound.startPlayer(feedUrl);
    // Stream.listen() returns a StreamSubscription,
    // hence we use Stream..listen() to get the returns of flutterSound.onPlayerStateChanged,
    // which is a Stream, then use it as 'e' in the following listen part
    _playerSubscription = _sound.onPlayerStateChanged
      ..listen((e) {
        if (e != null) {
          print(e.currentPosition);
          setState(() => _playPosition = e.currentPosition / e.duration);
        }
      });
    setState(() => _isPlaying = true);
  }

  Future<void> _pause() async {
    await _sound.stopPlayer();
    setState(() => _isPlaying = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Slider(
          value: _playPosition,
          onChanged: null,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: _isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
              iconSize: Theme.of(context).iconTheme.size,
              color: Colors.black,
              onPressed: () {
                if (_isPlaying) {
                  _pause();
                } else {
                  _play();
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
