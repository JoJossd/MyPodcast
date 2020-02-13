import 'package:flutter/material.dart';
import 'package:my_podcast/model/rssfeed_data.dart';
import 'package:my_podcast/widget/audio_control.dart';
import 'package:provider/provider.dart';

class EpisodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final item = Provider.of<Podcast>(context).selectedItem;
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
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Image.network(imageurl),
              ),
            ),
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Text(
                    item.findElements('itunes:summary').single.text,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
            AudioControl(),
          ],
        ),
      ),
    );
  }
}
