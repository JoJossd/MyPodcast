import 'dart:async';

import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  _prepare() async {
    const _duration = Duration(seconds: 2);
    return Timer(_duration, navHomePage);
  }

  navHomePage() {
    Navigator.of(context).pushReplacementNamed('/HomePage');
  }

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/roundtable_image.jpg'),
      ),
    );
  }
}
