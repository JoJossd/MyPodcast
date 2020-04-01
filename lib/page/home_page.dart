import 'package:flutter/material.dart';
import 'package:my_podcast/page/drawer.dart';
import 'package:provider/provider.dart';
import 'package:webfeed/webfeed.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_podcast/page/like_page.dart';
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
    LikePage(),
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
      drawer: MyDrawer(),
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
    // Consumer will call builder method each time Podcast calls notifyListeners()
    return Consumer<Podcast>(builder: (_, podcast, __) {
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
    return Consumer<Podcast>(builder: (_, podcast, __) {
      return ListView.builder(
        itemCount: rssFeed.items.length,
        itemBuilder: (context, index) {
          return podcast.itemTiles[index].downloadState ==
                  DownloadState.finished
              ? Slidable(
                  child: MyListTile(tileIndex: index),
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.2,
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      // caption: 'Delete',
                      color: Theme.of(context).primaryColor,
                      iconWidget: Icon(
                        Icons.delete,
                        size: 24,
                        color: Colors.black45,
                      ),
                      onTap: () {
                        podcast.delete(podcast.itemTiles[index]);
                      },
                    ),
                  ],
                )
              : MyListTile(tileIndex: index);
        },
      );
    });
  }
}

class MyListTile extends StatelessWidget {
  const MyListTile({@required this.tileIndex});

  final int tileIndex;

  @override
  Widget build(BuildContext context) {
    return Consumer<Podcast>(builder: (_, podcast, __) {
      return ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          podcast.itemTiles[tileIndex].item.title,
        ),
        subtitle: Text(
          podcast.itemTiles[tileIndex].item.itunes.summary,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: ConditionalSwitch.single<DownloadState>(
          context: context,
          valueBuilder: (BuildContext _) =>
              podcast.itemTiles[tileIndex].downloadState,
          caseBuilders: {
            DownloadState.untouched: (BuildContext context) => IconButton(
                  icon: Icon(Icons.file_download),
                  onPressed: () {
                    // Scaffold.of(context).showSnackBar(SnackBar(
                    //   content: Text('Downloading...'),
                    //   backgroundColor: Colors.blue[600],
                    // ));
                    podcast.download(podcast.itemTiles[tileIndex]);
                  },
                ),
            // TODO: resize and reposition CircularProgressIndicator
            DownloadState.connecting: (BuildContext _) => SizedBox(
                  child: CircularProgressIndicator(
                      backgroundColor: Colors.blue[600]),
                  height: 10,
                  width: 10,
                ),
            DownloadState.downloading: (BuildContext _) => IconButton(
                  icon: Icon(Icons.swap_vertical_circle),
                  color: Theme.of(context).accentColor,
                  onPressed: () {},
                ),
            DownloadState.finished: (BuildContext _) => IconButton(
                  icon: Icon(Icons.ac_unit),
                  disabledColor: Theme.of(context).scaffoldBackgroundColor,
                  onPressed: null,
                ),
          },
          fallbackBuilder: (BuildContext consumerContext) => IconButton(
            icon: Icon(Icons.error),
            onPressed: () {},
          ),
        ),
        onTap: () {
          podcast.selectedItemTile = podcast.itemTiles[tileIndex];
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => EpisodePage()),
          );
        },
      );
    });
  }
}
