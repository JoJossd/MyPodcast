import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

final feedUrl = 'https://aezfm.meldingcloud.com/rss/program/11';

// define a higher level ItemTile class, including item's download status and item itself
class ItemTile {
  RssItem item;
  DownloadState downloadState;

  ItemTile({this.item, this.downloadState});
}

enum DownloadState { untouched, connecting, downloading, finished }

String defaultDirPath;

class Podcast with ChangeNotifier {
  // Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  /*
  Why bother use a private variable?
  => to notify other widgets when the variable gets modified.
  */
  RssFeed _feed;
  RssFeed get feed => _feed;

  List<ItemTile> _itemTiles = [];
  List<ItemTile> get itemTiles => _itemTiles;

  ItemTile _selectedItemTile;
  ItemTile get selectedItemTile => _selectedItemTile;
  set selectedItemTile(ItemTile value) {
    _selectedItemTile = value;
    notifyListeners();
  }

  Future<void> parseFeed() async {
    final response = await http.get(feedUrl);
    if (response.statusCode == 200) {
      // decode machine code to character
      final rssString = utf8.decode(response.bodyBytes);
      _feed = RssFeed.parse(rssString);
    } else {
      throw Exception('bad http response status ${response.statusCode}');
    }

    final dir = await getApplicationDocumentsDirectory();
    defaultDirPath = dir.path;

    List<ItemTile> list = [];
    for (RssItem _i in _feed.items) {
      String _fileName = path.split(_i.enclosure.url).last;
      String _savePath = '$defaultDirPath/$_fileName';
      bool _fileExists = await File(_savePath).exists();

      list.add(ItemTile(
        item: _i,
        downloadState:
            _fileExists ? DownloadState.finished : DownloadState.untouched,
      ));
    }
    _itemTiles = list;
    notifyListeners();
  }

  // TODO: add downloading status (change download icon to progress circle)
  Future<void> download(ItemTile itemTile) async {
    itemTile.downloadState = DownloadState.connecting;
    final mediaUri = itemTile.item.enclosure.url;
    final client = http.Client();
    final req = http.Request('GET', Uri.parse(mediaUri));
    final res = await client.send(req);

    if (res.statusCode != 200) {
      throw Exception('bad mediaUri response status ${res.statusCode}');
    }

    final downloadedFilePath =
        path.join(defaultDirPath, path.split(mediaUri).last);
    final file = File(downloadedFilePath);
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

  delete(ItemTile itemTile) {
    final fileName = itemTile.item.enclosure.url;
    final fileFullPath = path.join(defaultDirPath, path.split(fileName).last);
    final dir = Directory(fileFullPath);
    dir.deleteSync(recursive: true);
    itemTile.downloadState = DownloadState.untouched;
    notifyListeners();
  }

  // TODO: add drag to refresh function
  refresh() {
    parseFeed();
  }
}
