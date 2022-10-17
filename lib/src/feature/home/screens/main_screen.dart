import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../global/helper_methods/methods.dart';

class MainScreen extends StatefulWidget {
  @override
  State createState() => _MainState();
}

class _MainState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    Timer(new Duration(milliseconds: 10), () {
      checkFirstSeen(context);
    });
    return Scaffold(body: new Container());
  }
}
