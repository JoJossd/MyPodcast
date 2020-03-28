import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

final feedUrl = 'https://aezfm.meldingcloud.com/rss/program/11';

// seems adding nonexist path doesn't work
final pathSuffix = 'dashcast/downloads';

class ItemTile {
  RssItem item;
  DownloadState downloadState;

  ItemTile({this.item, this.downloadState});
}

enum DownloadState { untouched, downloading, finished }

// TODO: keep ItemState consistant after restart
class Podcast with ChangeNotifier {
  /*
  Why bother use a private variable?
  => to notify other widgets when the variable gets modified.
  */
  RssFeed _feed;
  RssFeed get feed => _feed;

  RssItem _selectedItem;
  RssItem get selectedItem => _selectedItem;
  set selectedItem(RssItem value) {
    _selectedItem = value;
    notifyListeners();
  }

  List<ItemTile> _itemTiles = [];
  List<ItemTile> get itemTiles => _itemTiles;

  // DownloadState _downloadState = DownloadState.untouched;
  // DownloadState get downloadState => _downloadState;

  // get isUntouched => downloadState == DownloadState.untouched;
  // get isDownloading => downloadState == DownloadState.downloading;
  // get isFinished => downloadState == DownloadState.finished;

  Future<void> parseFeed() async {
    final response = await http.get(feedUrl);
    if (response.statusCode == 200) {
      // decode machine code to character
      final rssString = utf8.decode(response.bodyBytes);
      _feed = RssFeed.parse(rssString);
    } else {
      throw Exception('bad http response status ${response.statusCode}');
    }
    prepareItemTiles();
    notifyListeners();
  }

  void prepareItemTiles() {
    List<ItemTile> list = [];
    for (RssItem _i in _feed.items) {
      list.add(ItemTile(
        item: _i,
        downloadState: DownloadState.untouched,
      ));
    }
    _itemTiles = list;
  }

  // TODO: add downloading status (change download icon to progress circle)
  Future<void> download(ItemTile itemTile) async {
    final mediaUri = itemTile.item.enclosure.url;

    final client = http.Client();
    final req = http.Request('GET', Uri.parse(mediaUri));
    final res = await client.send(req);

    if (res.statusCode != 200) {
      throw Exception('bad mediaUri response status ${res.statusCode}');
    }

    final file = File(await _getDownloadPath(path.split(mediaUri).last));
    itemTile.downloadState = DownloadState.downloading;
    notifyListeners();
    print('start downloading');

    final sink = file.openWrite();
    res.stream.pipe(sink).whenComplete(() {
      print('downloading complete');
      print('$file');
      itemTile.downloadState = DownloadState.finished;
      notifyListeners();
    });
  }
}

Future<String> _getDownloadPath(String filename) async {
  final dir = await getApplicationDocumentsDirectory();
  final pathPrefix = dir.path;
  final absolutePath = path.join(pathPrefix, filename);
  return absolutePath;
}
