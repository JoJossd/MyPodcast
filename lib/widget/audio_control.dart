import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:my_podcast/model/rssfeed_data.dart';
import 'package:provider/provider.dart';

class AudioControl extends StatefulWidget {
  @override
  _AudioControlState createState() => _AudioControlState();
}

class _AudioControlState extends State<AudioControl> {
  FlutterSound _sound;
  bool _isPlaying = false;
  double _playPosition;
  Stream<PlayStatus> _playerSubscription;

  // set the initial value of some variables when the app lunchs.
  @override
  void initState() {
    super.initState();
    _sound = FlutterSound();
    _playPosition = 0;
  }

  Future<void> _play(String url) async {
    await _sound.startPlayer(url);
    /*
    Stream.listen() returns a StreamSubscription,
    hence we use Stream..listen() to get the returns of flutterSound.onPlayerStateChanged,
    which is a Stream, then use it as 'e' in the following listen part
    */
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
    final item = Provider.of<Podcast>(context).selectedItem;
    return Container(
        // height: 100,
        child: Column(
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
                  _play(item.findElements('guid').single.text);
                }
              },
            ),
          ],
        ),
      ],
    ));
  }
}
