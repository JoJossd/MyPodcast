import 'package:flutter/material.dart';
import 'package:my_podcast/model/rssfeed_data.dart';
import 'package:my_podcast/widget/audio_control.dart';
import 'package:provider/provider.dart';

final imageUrl = 'http://resezfm.meldingcloud.com/image/1904/1555550145451.jpg';

class EpisodePage extends StatelessWidget {
  @override
  Widget build(BuildContext episodePageContext) {
    /*
    we do want EpisodePage to rebuid(to suit for each item)
     every time (Podcast podcast) changes, hence no listen: false.
    */
    final item = Provider.of<Podcast>(episodePageContext).selectedItem;
    return Scaffold(
      backgroundColor: Theme.of(episodePageContext).primaryColor,
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
                padding: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(imageUrl),
                ),
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
