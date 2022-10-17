import 'package:flutter/material.dart';
import "package:intl/intl.dart";

import '../../../global/constants/app_colors.dart';
import '../../../global/helper_classes/currency_info.dart';
import '../../../global/helper_methods/methods.dart';
import '../../../global/models/spending_entry.dart';
import 'edit_spending_screen.dart';

class SpendingHistoryScreen extends StatefulWidget {
  final Map<String, num>? numData;
  final Map<String, String>? stringData;

  SpendingHistoryScreen({Key? key, this.numData, this.stringData})
      : super(key: key);

  @override
  State createState() => _SpendingHistoryState();
}

class _SpendingHistoryState extends State<SpendingHistoryScreen>
    with WidgetsBindingObserver {
  String? dayString;
  DateTime? _day;
  int? today;
  List<SpendingEntry>? spendingList;

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now().toLocal();
    today = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;

    widget.numData!["_day"] = DateTime.now().toLocal().millisecondsSinceEpoch;
    spendingList = [];

    queryAllDB().then((entries) {
      setState(() {
        spendingList = entries;
      });
    });
  }

  String dayToString(DateTime dt) {
    return DateFormat('yyyy/MM/dd').format(dt);
  }

  String getMoneyString(num amount) {
    return CurrencyInfo().getCurrencyText(widget.stringData![""]!, amount);
  }

  TextSpan _moneyText(num amount) {
    return TextSpan(
        text: getMoneyString(amount),
        style: TextStyle(color: getColor(amount)));
  }

  Color getColor(i) {
    if (i < 0) return Colors.red;
    if (i > 0) return Colors.green;
    return Colors.black;
  }

  void _openEditWidget(SpendingEntry item) async {
    String? oldContent = item.content;
    double? oldAmount = item.amount;

    final SpendingEntry result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditSpendingScreen(
            item: item,
            currency: widget.stringData![""],
          ),
        ));

    if (result.content == oldContent && result.amount == oldAmount) {
      return;
    }

    for (SpendingEntry i in spendingList!) {
      if (i.id == result.id) {
        i.content = result.content;
        i.amount = result.amount;
        if (i.day == today) {
          widget.numData!["todaySpent"] =
              widget.numData!["todaySpent"]! - oldAmount!;
          widget.numData!["todaySpent"] =
              widget.numData!["todaySpent"]! + result.amount!.toInt();
        } else {
          widget.numData!["totalSaved"] =
              widget.numData!["totalSaved"]! - oldAmount!;
          widget.numData!["totalSaved"] =
              result.amount! + widget.numData!["totalSaved"]!;
          saveSP("totalSaved", widget.numData!["totalSaved"]);
        }
        updateDB(i);
      }
    }
    // Update any values that have changed.
    setState(() {});
  }

  titleText() {
    if (widget.numData!["historyMode"] == 1) {
      return "Spending History";
    }
    return dayToString(_day!) == dayToString(DateTime.now().toLocal())
        ? "Today's Spending"
        : "Spending on $dayString";
  }

  _popUpMenuButton(SpendingEntry i) {
    return PopupMenuButton(
      icon: Icon(Icons.more_horiz),
      onSelected: (selectedIndex) {
        // add this property
        if (selectedIndex == 1) {
          deleteDB(i.id!);
          spendingList?.remove(i);
          if (i.day == today)
            widget.numData!["todaySpent"] =
                widget.numData!["todaySpent"]! - i.amount!;
          else {
            widget.numData!["totalSaved"] =
                widget.numData!["totalSaved"]! - i.amount!;
            saveSP("totalSaved", widget.numData!["totalSaved"]);
          }
          setState(() {});
        } else if (selectedIndex == 0) {
          _openEditWidget(i);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Text("Edit"),
          value: 0,
        ),
        PopupMenuItem(
          child: Text("Delete"),
          value: 1,
        ),
      ],
    );
  }

  getTimeText(SpendingEntry i) {
    DateTime dt = DateTime.fromMillisecondsSinceEpoch(i.timestamp!);
    return "\t\t(" + DateFormat('h:mm a').format(dt) + ")";
  }

  List<Widget> spendingHistory() {
    List<Widget> history = [];
    int? tmp = 0;
    for (SpendingEntry i in spendingList!.reversed) {
      // If In Daily Mode, skip anything from other dates
      if (widget.numData!["historyMode"] == 0 && i.day != today) {
        continue;
      }
      // If in Entire History Mode, show date changes
      if (widget.numData!["historyMode"] == 1 && tmp != i.day) {
        tmp = i.day;
        history.add(Padding(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Text(
              dayToString(DateTime.fromMillisecondsSinceEpoch(tmp!)),
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            )));
      }
      history.add(
        new Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          margin: EdgeInsets.all(5.0),
          color: Colors.white,
          child: ListTile(
            dense: true,
            title: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  _moneyText(i.amount!),
                  TextSpan(
                      text: getTimeText(i),
                      style: TextStyle(color: Colors.black54)),
                ],
              ),
            ),
            subtitle: Text(i.content == "" ? "No Description" : i.content!),
            trailing: _popUpMenuButton(i),
          ),
        ),
      );
    }
    return history.length > 0
        ? history
        : List.from([Text("Nothing Found Here!")]);
  }

  @override
  Widget build(BuildContext context) {
    _day =
        DateTime.fromMillisecondsSinceEpoch(widget.numData!["_day"]!.toInt());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 25, 0, 20),
              child: ListTile(
                dense: true,
                leading: Visibility(
                  visible: widget.numData!["historyMode"] == 0,
                  child: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () {
                      showDatePicker(
                          context: context,
                          initialDate: _day!,
                          firstDate: DateTime(2001),
                          lastDate: DateTime.now(),
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: AppColors.colorBlackButton,
                                  onPrimary: Colors.white,
                                ),
                                buttonTheme: ButtonThemeData(
                                  buttonColor: Color.fromRGBO(149, 213, 178, 1),
                                ),
                              ),
                              child: child!,
                            );
                          }).then((value) {
                        setState(() {
                          if (value != null) {
                            _day = value;
                            widget.numData!["_day"] =
                                _day!.millisecondsSinceEpoch;
                            dayString = dayToString(_day!);
                          }
                        });
                      });
                    },
                  ),
                ),
                title: Text(
                  titleText(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: spendingHistory())
          ],
        ),
      ),
    );
  }
}
