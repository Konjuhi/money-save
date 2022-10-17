import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../global/constants/paths.dart';
import '../../../global/constants/strings.dart';
import '../../../global/constants/theme.dart';
import '../../../global/helper_methods/methods.dart';
import '../widgets/button_widget.dart';
import '../widgets/daily_limit_widget.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, double>? data;
  final dateController = TextEditingController();
  final amountController = TextEditingController();
  HomeScreen({Key? key, this.data}) : super(key: key);

  @override
  State createState() => _SplashState();
}

class _SplashState extends State<HomeScreen> {
  final pageController = PageController(initialPage: 0);
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now().toLocal();

    saveSP("todayDate",
        DateTime(now.year, now.month, now.day).millisecondsSinceEpoch);
  }

  nextPage() {
    setState(() {
      _currentIndex += 1;
      pageController.animateToPage(_currentIndex,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  showSnackBar(BuildContext context, String s) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(s),
      duration: Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> introPages = [
      OnBoardWidget(context),
      DailyLimitWidget(),
    ];
    return Scaffold(
      body: Builder(
          builder: (context) => PageView(
              physics: new NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                FocusScope.of(context).unfocus();
                _currentIndex = index;
              },
              controller: pageController,
              children: introPages)),
    );
  }

  Widget OnBoardWidget(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: [
        const Image(
          image: AssetImage('assets/images/Onboard.png'),
          fit: BoxFit.cover,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15),
              child: Center(
                child: SvgPicture.asset(Paths.appIconDollar),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
              child: Center(
                child: Text(
                  Strings.welcomeText,
                  textAlign: TextAlign.center,
                  style: MoneyTheme.lightTextTheme.headline1,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      Strings.dailyText,
                      style: MoneyTheme.lightTextTheme.bodyText2,
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      Strings.spendingText,
                      style: MoneyTheme.lightTextTheme.bodyText2,
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      Strings.savedText,
                      style: MoneyTheme.lightTextTheme.bodyText2,
                    ),
                  ],
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
              color: Color(0xff242424),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ButtonWidget(
                    text: Strings.next,
                    onTab: () {
                      nextPage();
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
