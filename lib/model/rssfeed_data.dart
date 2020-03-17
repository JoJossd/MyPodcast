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

class Podcast with ChangeNotifier {
  /*
  _items is the current value in the app,
  and it is acquired by getItems() function.
  once _items is acquired, items is also availiable through getter.

  Why bother use a private variable?
  => to notify other widgets when the variable gets modified.
  */

  RssFeed _feed;
  RssItem _selectedItem;

  RssFeed get feed => _feed;

  Future<void> parseFeed() async {
    final response = await http.get(feedUrl);
    if (response.statusCode == 200) {
      final rssString = utf8.decode(response.bodyBytes);
      _feed = RssFeed.parse(rssString);
    } else {
      throw Exception('bad http response status ${response.statusCode}');
    }
    notifyListeners();
  }

  RssItem get selectedItem => _selectedItem;

  set selectedItem(RssItem value) {
    _selectedItem = value;
    notifyListeners();
  }

  void download(RssItem item) async {
    // mp3 src need to be fixed
    final mediaUri = item.enclosure.url;

    final client = http.Client();
    final req = http.Request('GET', Uri.parse(mediaUri));
    final res = await client.send(req);

    if (res.statusCode != 200) {
      throw Exception('bad mediaUri response status ${res.statusCode}');
    }

    final file = File(await _getDownloadPath(path.split(mediaUri).last));

    res.stream.pipe(file.openWrite()).whenComplete(() {
      print('downloading complete');
    });
  }
}

Future<String> _getDownloadPath(String filename) async {
  final dir = await getApplicationDocumentsDirectory();
  final pathPrefix = dir.path;
  final absolutePath = path.join(pathPrefix, filename);
  return absolutePath;
}
