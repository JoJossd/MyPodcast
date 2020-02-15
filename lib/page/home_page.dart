import 'package:flutter/material.dart';
import 'package:my_podcast/model/rssfeed_data.dart';
import 'package:my_podcast/page/episode_page.dart';
import 'package:provider/provider.dart';
import 'package:xml/xml.dart' as xml;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext homepageContext) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Episode List'),
        elevation: 0,
      ),
      backgroundColor: Theme.of(homepageContext).primaryColor,

      /*
      use Consumer to provide a [BuildContext] on which we use the properties in Provider.
      Provider.of<Podcast>(context) cannot create a [BuildContext],
      it can only use the nearest context above.

      Since EpisodeListView or Center is built on Scaffold-body(not Scaffold) widget,
      but that body widget doesn't have a [BuildContext],
      so we have to provide a [BuildContext] before using the properties in ChangeNotifierProvider,
      to make sure the rebuild only apply to Scaffold-body not the whole Scaffold
      */
      body: Consumer<Podcast>(
        builder: (scaffoldBodyContext, podcast, _) {
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
  Widget build(BuildContext episodeListViewContext) {
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
              trailing: IconButton(
                icon: Icon(Icons.file_download),
                onPressed: () {
                  Scaffold.of(episodeListViewContext)
                      .showSnackBar(SnackBar(content: Text('Downloading...')));
                  Provider.of<Podcast>(episodeListViewContext, listen: false)
                      .download(i);
                },
              ),
              onTap: () {
                /*
                we don't want EpisodeListView[ListView widget](or its parent widget: HomePage[Scaffold widget])
                to rebuid every time (Podcast podcast) changes, hence listen: false.

                when set i to selectedItem, 
                we make sure the current value(_selectedItem) is also set to i,
                so that we can notify other widgets,
                which listens to this ChangeNotifier, to rebuild.
                */
                Provider.of<Podcast>(episodeListViewContext, listen: false)
                    .selectedItem = i;
                Navigator.of(episodeListViewContext).push(
                  MaterialPageRoute(builder: (_) => EpisodePage()),
                );
              },
            ),
          )
          .toList(),
    );
  }
}
