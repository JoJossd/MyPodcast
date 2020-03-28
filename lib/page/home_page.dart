import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webfeed/webfeed.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:my_podcast/model/rssfeed_data.dart';
import 'package:my_podcast/page/episode_page.dart';
import 'package:my_podcast/widget/custom_bottom_navbar.dart';

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
    // Consumer will call builder method each time Podcast calls notifyListeners()
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
    return Consumer<Podcast>(builder: (consumerContext, podcast, _) {
      return ListView.builder(
        itemCount: rssFeed.items.length,
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: EdgeInsets.all(16),
            title: Text(
              podcast.itemTiles[index].item.title,
              style: TextStyle(fontSize: 20),
            ),
            subtitle: Text(
              podcast.itemTiles[index].item.itunes.summary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: ConditionalSwitch.single<DownloadState>(
              context: consumerContext,
              valueBuilder: (BuildContext _) =>
                  podcast.itemTiles[index].downloadState,
              caseBuilders: {
                DownloadState.untouched: (BuildContext context) => IconButton(
                      icon: Icon(Icons.file_download),
                      onPressed: () {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('Downloading...'),
                          backgroundColor: Colors.blue[600],
                        ));
                        podcast.download(podcast.itemTiles[index]);
                      },
                    ),
                DownloadState.downloading: (BuildContext _) => IconButton(
                      icon: Icon(Icons.swap_vertical_circle),
                      onPressed: () {},
                    ),
                DownloadState.finished: (BuildContext _) => IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {},
                    ),
              },
              fallbackBuilder: (BuildContext consumerContext) => IconButton(
                icon: Icon(Icons.error),
                onPressed: () {},
              ),
            ),
            onTap: () {
              podcast.selectedItemTile = podcast.itemTiles[index];
              Navigator.of(consumerContext).push(
                MaterialPageRoute(builder: (_) => EpisodePage()),
              );
            },
          );
        },
      );
    });
  }
}

// TODO: add like list
class DummyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Dummy Page'),
    );
  }
}
