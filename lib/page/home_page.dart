import 'package:flutter/material.dart';
import 'package:my_podcast/model/rssfeed_data.dart';
import 'package:my_podcast/page/episode_page.dart';
import 'package:provider/provider.dart';
import 'package:xml/xml.dart' as xml;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Episode List'),
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Consumer<Podcast>(
        builder: (context, podcast, _) {
          return podcast.items != null
              ? EpisodeListView(items: podcast.items)
              : Center(child: CircularProgressIndicator());
        },
      ),
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
                // TODO: What for?
                Provider.of<Podcast>(context, listen: false).selectedItem = i;
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => EpisodePage()),
                );
              },
            ),
          )
          .toList(),
    );
  }
}
