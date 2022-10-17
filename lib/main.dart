import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:money_save/src/feature/home/screens/main_screen.dart';
import 'package:money_save/src/global/constants/theme.dart';

import 'src/feature/home/screens/home_screen.dart';
import 'src/feature/home/widgets/bottom_navigation_widget.dart';

void main() => runApp(Phoenix(child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = MoneyTheme.light();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Money Tracker',
        theme: theme,
        home: MainScreen(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) =>
              BottomNavigationWidget(parentCtx: context),
          '/splash': (BuildContext context) => HomeScreen(),
        });
  }
}
