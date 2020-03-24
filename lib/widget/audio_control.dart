import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:provider/provider.dart';
import 'package:my_podcast/model/rssfeed_data.dart';

// TODO: set volumn
enum PlayerState { stopped, playing, paused }

class AudioControl extends StatefulWidget {
  @override
  _AudioControlState createState() => _AudioControlState();
}

class _AudioControlState extends State<AudioControl> {
  // AudioCache audioCache = AudioCache();
  AudioPlayer audioPlayer;
  AudioPlayerState _audioPlayerState;

  StreamSubscription<Duration> _positionSubscription;
  StreamSubscription<Duration> _durationSubscription;
  StreamSubscription<AudioPlayerState> _playerStateSubscription;
  StreamSubscription<void> _playerCompleteSubscription;
  StreamSubscription<String> _playerErrorSubscription;

  Duration _duration;
  Duration _position;

  PlayerState _playerState = PlayerState.stopped;

  get _isPlaying => _playerState == PlayerState.playing;
  // get _isPaused => _playerState == PlayerState.paused;
  get _durationText => _duration?.toString()?.split('.')?.first ?? '';
  get _positionText => _position?.toString()?.split('.')?.first ?? '';

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();

    _durationSubscription = audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription =
        audioPlayer.onAudioPositionChanged.listen((Duration p) async {
      print('Current position: $p');
      setState(() => _position = p);
    });

    _playerStateSubscription = audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      print('Current state: $state');
      setState(() => _audioPlayerState = state);
    });

    _playerCompleteSubscription =
        audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = _duration;
      });
    });

    _playerErrorSubscription = audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        _playerState = PlayerState.stopped;
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
      });
    });
  }

  Future<void> _play(String url) async {
    final playPosition = (_position != null &&
            _duration != null &&
            _position.inMilliseconds > 0 &&
            _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;
    final result = await audioPlayer.play(url, position: playPosition);
    if (result == 1) {
      setState(() => _playerState = PlayerState.playing);
    }
    audioPlayer.setPlaybackRate(playbackRate: 1.0);
  }

  Future<void> _pause() async {
    final result = await audioPlayer.pause();
    if (result == 1) {
      setState(() => _playerState = PlayerState.paused);
    }
  }

  Future<void> _jumpTo(double v) async {
    final newPosition = v * _duration.inMilliseconds;
    await audioPlayer.seek(Duration(milliseconds: newPosition.toInt()));
  }

  @override
  void dispose() {
    audioPlayer.stop();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = Provider.of<Podcast>(context).selectedItem;
    return SizedBox(
        width: 400,
        height: 130,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 0, 28, 0),
          child: Column(
            children: <Widget>[
              Slider.adaptive(
                value: (_position != null &&
                        _duration != null &&
                        _position.inMilliseconds > 0 &&
                        _position.inMilliseconds < _duration.inMilliseconds)
                    ? _position.inMilliseconds / _duration.inMilliseconds
                    : 0.0,
                onChanged: (v) => _jumpTo(v),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    _position != null ? '${_positionText ?? ''}' : '',
                  ),
                  Text(
                    _position != null
                        ? '${_durationText ?? ''}'
                        : _duration != null ? _durationText : '',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.fast_rewind),
                    iconSize: Theme.of(context).iconTheme.size,
                    color: Colors.black,
                    onPressed: () {},
                  ),
                  IconButton(
                    icon:
                        _isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                    iconSize: Theme.of(context).iconTheme.size,
                    color: Colors.black,
                    onPressed: () {
                      _isPlaying ? _pause() : _play(item.enclosure.url);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.fast_forward),
                    iconSize: Theme.of(context).iconTheme.size,
                    color: Colors.black,
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
