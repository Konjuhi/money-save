import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/svg.dart';

import '../../../global/constants/paths.dart';
import '../../../global/helper_methods/methods.dart';
import '../../../global/models/spending_entry.dart';
import '../../spend/screens/settings_screen.dart';
import '../../spend/screens/spending_history_screen.dart';
import '../screens/display_screen.dart';
import '../screens/spend_money_screen.dart';

class BottomNavigationWidget extends StatefulWidget {
  final BuildContext parentCtx;

  BottomNavigationWidget({Key? key, required this.parentCtx});

  @override
  State createState() => _HomeState();
}

class _HomeState extends State<BottomNavigationWidget> {
  final pageController = PageController(initialPage: 0);
  int _currentIndex = 0;
  int? today;
  bool ready = false;
  bool patched = false;

  Map<String, String>? stringData;
  Map<String, num>? numData;
  List<SpendingEntry>? todaySpending;
  // List<SubscriptionEntry> subscriptions;

  @override
  void initState() {
    super.initState();

    SystemChannels.lifecycle.setMessageHandler((msg) async {
      if (msg == AppLifecycleState.resumed.toString()) {
        checkNewDay();
        setState(() {});
      }
      return null;
    });

    // Create Map for the session and load the data from Shared Preference.
    numData = new Map<String, num>();
    numData!["todaySpent"] = 0;
    numData!["SpendValue"] = 0;

    stringData = new Map<String, String>();
    stringData!["SpendContent"] = "";

    loadValues();
  }

  loadValues() {
    // System Values
    readSP("").then((val) {
      stringData![''] = val ?? "USD";
    });
    readSP("dailyLimit").then((val) {
      numData!["dailyLimit"] = val ?? 0;
    });

    readSP("totalSaved").then((val) {
      numData!["totalSaved"] = val ?? 0;
    });

    readSP("todayDate").then((todayDate) {
      numData!["todayDate"] = todayDate ?? 0;

      queryDBDay(todayDate ?? 0).then((entries) {
        todaySpending = entries;
        for (SpendingEntry i in entries) {
          numData!["todaySpent"] = numData!["todaySpent"]! + i.amount!;
        }
      });
    });

    //
    numData!["spendAmount"] = 0;
    //

    // UI Parameters
    readSP("showSave").then((val) {
      numData!["showSave"] = val ?? 0;
    });
    readSP("historyMode").then((val) {
      numData!["historyMode"] = val ?? 0;
    });
    readSP("version").then((val) {
      numData!["version"] = val ?? 0;
    });
  }

  // This will run on startup to check if a new day has past.
  void checkNewDay() {
    // Date depends on local
    DateTime now = DateTime.now().toLocal();
    today = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;

    // If its a new day, accumulate the savings into monthly saving and reset daily
    if (numData!["todayDate"] != today) {
      DateTime prevDate =
          DateTime.fromMillisecondsSinceEpoch(numData!["todayDate"]!.toInt());

      //Get 'yesterday' spending
      // Accumulate how much was saved yesterday
      numData!["totalSaved"] = numData!["totalSaved"]! +
          (numData!["dailyLimit"]! + numData!["todaySpent"]!);
      numData!["todaySpent"] = 0;

      numData!["todayDate"] = today!;

      saveSP("todayDate", numData!["todayDate"]);
      saveSP("totalSaved", numData!["totalSaved"]);
      setState(() {});
    }
  }

  patch() {
    setState(() {
      patched = true;
    });
  }

  List<Widget> _children() => [
        SpendMoneyScreen(numData: numData!, stringData: stringData!),
        DisplayWidget(
            numData: numData!,
            //   subscriptions: subscriptions,
            stringData: stringData!),
        SpendingHistoryScreen(
          numData: numData,
          stringData: stringData,
        ),
      ];

  void _pushSettings(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsScreen(
            numData: numData!,
            stringData: stringData!,
          ),
        ));

    setState(() {});
    if (result) {
      todaySpending!.clear();
      numData!["totalSaved"] = 0;
      saveSP("totalSaved", numData!["totalSaved"]);
      if (!mounted) return;
      Phoenix.rebirth(widget.parentCtx);
    }
  }

  changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  isLoaded() {
    return numData != null && todaySpending != null;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = _children();

    if (!ready) {
      new Timer(new Duration(milliseconds: 500), () {
        ready = true;
        setState(() {});
      });
    }
    if (isLoaded()) {
      patch();
    }
    if (!isLoaded() || !ready || !patched) {
      return Scaffold(
        body: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15),
              child: Center(
                child: Image(
                  image: AssetImage(Paths.appWalletImage),
                  width: 150,
                ),
              ),
            ),
          ],
        ),
      );
    }

    checkNewDay();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff242424),
        elevation: 0,
        title: Text(
          "Money Tracker",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                _pushSettings(context);
              })
        ],
      ),
      body: PageView(
          onPageChanged: (index) {
            FocusScope.of(context).unfocus();
            changePage(index);
          },
          controller: pageController,
          children: children),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        selectedLabelStyle: TextStyle(color: Colors.black),
        unselectedLabelStyle: TextStyle(color: Colors.black), // new
        currentIndex: _currentIndex, // new
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(Paths.spend),
            activeIcon: SvgPicture.asset(Paths.spendb),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(Paths.display),
            activeIcon: SvgPicture.asset(Paths.displayb),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(Paths.history),
            activeIcon: SvgPicture.asset(Paths.historyb),
            label: '',
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(
      () {
        _currentIndex = index;
        pageController.animateToPage(index,
            duration: Duration(milliseconds: 500), curve: Curves.ease);
      },
    );
  }
}
