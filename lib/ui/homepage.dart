import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

final imageurl =
    'http://resezfm.meldingcloud.com/image/1904/1555550145451.jpg?x-oss-process=image/resize,w_350';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('Round Table'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 8,
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                      child: Image.network(imageurl),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('some episode description'),
                    )
                  ],
                ),
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
  final url =
      'https://chtbl.com/track/9G554/podcasts-cri.meldingcloud.com/WJSL_YFMD/WJSL_YFMD/54c6f9582a80fc1e70ff5575/1B3D617D4C624591BE032AC15813546F.mp3';
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
    await _sound.startPlayer(url);
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
