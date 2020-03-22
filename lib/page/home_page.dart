import 'package:flutter/material.dart';
import 'package:my_podcast/model/rssfeed_data.dart';
import 'package:my_podcast/page/episode_page.dart';
import 'package:my_podcast/widget/custom_bottom_navbar.dart';
import 'package:provider/provider.dart';
import 'package:webfeed/webfeed.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var navIndex = 0;

  final List<Widget> pages = [
    EpisodeListPage(),
    DummyPage(),
  ];

  final List<IconData> iconList = [
    Icons.home,
    Icons.bookmark,
  ];

  @override
  Widget build(BuildContext homepageContext) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Episode List'),
        elevation: 0,
      ),
      backgroundColor: Theme.of(homepageContext).primaryColor,
      body: pages[navIndex],
      bottomNavigationBar: MyNavBar(
        icons: iconList,
        onPressed: (i) {
          setState(() => navIndex = i);
        },
        activeIndex: navIndex,
      ),
    );
  }
}

class EpisodeListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /*
    use Consumer to provide a [BuildContext] on which we use the properties in Provider.
    Provider.of<Podcast>(context) cannot create a [BuildContext],
    it can only use the nearest context above.

    Since EpisodeListView or Center is built on Scaffold-body widget(not Scaffold, also not HomePage),
    but that body widget doesn't have a [BuildContext],
    so we have to provide a [BuildContext] before using the properties in ChangeNotifierProvider,
    to make sure the rebuild only apply to Scaffold-body not the whole Scaffold
    */
    return Consumer<Podcast>(builder: (consumerContext, podcast, _) {
      return podcast.feed != null
          ? EpisodeListView(rssFeed: podcast.feed)
          : Center(child: CircularProgressIndicator());
    });
  }
}

class EpisodeListView extends StatelessWidget {
  const EpisodeListView({Key key, @required this.rssFeed}) : super(key: key);
  final RssFeed rssFeed;

  @override
  Widget build(BuildContext episodeListViewContext) {
    return ListView(
      children: rssFeed.items
          .map(
            (i) => ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Text(
                i.title,
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text(
                i.itunes.summary,
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

class DummyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Dummy Page'),
    );
  }
}
