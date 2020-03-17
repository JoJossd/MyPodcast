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
        title: Text(item.title),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              // flex: 3,
              height: 400,
              width: 400,
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(imageUrl),
                ),
              ),
            ),
            Container(
              // flex: 2,
              height: 210,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Text(
                    item.itunes.summary,
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
