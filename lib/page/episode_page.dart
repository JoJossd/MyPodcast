import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_podcast/page/app_theme.dart';
import 'package:my_podcast/model/rssfeed_data.dart';
import 'package:my_podcast/widget/audio_control.dart';

class EpisodePage extends StatelessWidget {
  @override
  Widget build(BuildContext episodePageContext) {
    /*
    we do want EpisodePage to rebuid(to suit for each item)
     every time (Podcast podcast) changes, hence no listen: false.
    */
    final itemTile = Provider.of<Podcast>(episodePageContext).selectedItemTile;

    return Scaffold(
      appBar: AppBar(
        title: Text(itemTile.item.title),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 400,
              width: 400,
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset('assets/images/roundtable_image.jpg'),
                ),
              ),
            ),
            Container(
              height: 210,
              child: Padding(
                padding: const EdgeInsets.all(36),
                child: SingleChildScrollView(
                  child: Text(
                    itemTile.item.itunes.summary,
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
