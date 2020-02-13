import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

final feedUrl = 'https://aezfm.meldingcloud.com/rss/program/11';
final imageurl =
    'http://resezfm.meldingcloud.com/image/1904/1555550145451.jpg?x-oss-process=image/resize,w_350';

class Podcast with ChangeNotifier {
  Iterable<xml.XmlElement> _items;
  Iterable<xml.XmlElement> get items => _items;
  Future<void> getItems() async {
    final response = await http.get(feedUrl);
    final rssString = utf8.decode(response.bodyBytes);
    final rssDocument = xml.parse(rssString);
    _items = rssDocument.findAllElements('item');
    notifyListeners();
  }

  xml.XmlElement _selectedItem;
  xml.XmlElement get selectedItem => _selectedItem;
  set selectedItem(xml.XmlElement value) {
    _selectedItem = value;
    notifyListeners();
  }
}
