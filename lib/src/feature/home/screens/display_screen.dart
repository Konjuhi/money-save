import 'package:flutter/material.dart';

import '../../../global/helper_classes/currency_info.dart';

class DisplayWidget extends StatefulWidget {
  final Map<String, num> numData;
  final Map<String, String> stringData;

  DisplayWidget({Key? key, required this.numData, required this.stringData})
      : super(key: key);

  @override
  State createState() => _DisplayState();
}

class _DisplayState extends State<DisplayWidget> {
  getRemaining() {
    return widget.numData["dailyLimit"]! + widget.numData["todaySpent"]!;
  }

  getTotalSaved() {
    return widget.numData["totalSaved"];
  }

  String getMoneyString(num amount) {
    return CurrencyInfo().getCurrencyText(widget.stringData[""]!, amount);
  }

  // Currently defaults is US Dollars
  Widget _moneyText(num amount) {
    return Center(
        child: Text(getMoneyString(amount),
            style: TextStyle(fontSize: 40.0, color: getColor(amount))));
  }

  Color getColor(i) {
    if (i < 0) return Colors.red;
    if (i > 0) return Colors.black;
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16, top: 30),
          decoration: BoxDecoration(
            color: const Color(0xffF3A6FF),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              _moneyText(getRemaining()),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 50, 0, 30),
                child: Center(
                    child: Text(
                  "Remaining Today",
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                )),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16),
          decoration: BoxDecoration(
            color: const Color(0xffF5EDFD),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              _moneyText(getTotalSaved()),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 50, 0, 30),
                child: Center(
                  child: Text(
                    "Total Saved",
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
