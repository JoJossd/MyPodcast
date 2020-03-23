import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:provider/provider.dart';

import 'package:my_podcast/model/rssfeed_data.dart';

class AudioControl extends StatefulWidget {
  @override
  _AudioControlState createState() => _AudioControlState();
}

class _AudioControlState extends State<AudioControl> {
  // AudioCache audioCache = AudioCache();
  AudioPlayer audioPlayer = AudioPlayer();

  bool _isPlaying = false;
  bool _isStarted = false;
  Duration _duration;
  Duration _playPosition;
  int time;
  String timeLeft = "";
  double progress = 0.0;

  // set the initial value of some variables when the app lunchs.
  @override
  void initState() {
    super.initState();

    audioPlayer.onAudioPositionChanged.listen((Duration p) async {
      print('Current position: $p');
      time = await audioPlayer.getDuration();
      _duration = p;
      if (_duration == null) {
        timeLeft = "Time Left 0s/0s";
      } else {
        timeLeft = "Time Left ${_duration.inSeconds}s/${time / 1000}s";
      }
      if (time == null || _duration == null) {
        progress = 0.0;
      } else {
        progress = (_duration.inMilliseconds) / time;
      }
      print(progress);
      setState(() {});
    });

    audioPlayer.onPlayerStateChanged.listen((AudioPlayerState state) {
      print("$state");
      if (state == AudioPlayerState.PLAYING) {
        setState(() {
          _isPlaying = true;
        });
      } else {
        if (mounted) {
          setState(() {
            _isPlaying = false;
          });
        }
      }
    });
  }

  Future<void> _play(String url) async {
    if (!_isStarted) {
      await audioPlayer.play(url);
      setState(() => _isStarted = true);
    } else
      await audioPlayer.resume();

    // setState(() => _isPlaying = true);
  }

  Future<void> _pause() async {
    await audioPlayer.pause();
    // setState(() => _isPlaying = false);
  }

  // Future<void> _slideJump(double _newPosition) async {
  //   String result = await _sound.seekToPlayer(_newPosition.toInt());
  //   setState(() => _playPosition = _newPosition);
  // }
  @override
  void dispose() async {
    await audioPlayer.release();
    await audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = Provider.of<Podcast>(context).selectedItem;
    return SizedBox(
        width: 300,
        height: 120,
        child: Column(
          children: <Widget>[
            // TODO: implement draggable controller
            Slider.adaptive(
              value: 0,
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
                    _isPlaying ? _pause() : _play(item.enclosure.url);
                  },
                ),
              ],
            ),
          ],
        ));
  }
}
