import 'package:flutter/material.dart';

import '../../../global/helper_classes/currency_info.dart';
import '../../../global/helper_methods/methods.dart';

class SettingsScreen extends StatefulWidget {
  final amountController = TextEditingController();
  final dateController = TextEditingController();
  final Map<String, String> stringData;

  final Map<String, num> numData;
  SettingsScreen(
      {Key? key,
      required this.numData,
      /*this.subscriptions*/ required this.stringData})
      : super(key: key);

  @override
  State createState() => _SettingsState();
}

class _SettingsState extends State<SettingsScreen> {
  String? currentDaily, monthlyReset, currency;
  bool? showSaveButton, showEntireHistory;

  @override
  void initState() {
    super.initState();
    currency = widget.stringData[""];
    currentDaily = widget.numData["dailyLimit"].toString();
    showSaveButton = widget.numData["showSave"] == 1;
    showEntireHistory = widget.numData["historyMode"] == 1;
  }

  Future<void> _showMyDialog(String newValue, BuildContext ctx) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                    'Changing the currency will clear all data and restart. Please back up your data if you need to.'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                  content: Text('Data will be cleared on Save'),
                  duration: Duration(seconds: 5),
                ));
                setState(() {
                  currency = newValue;
                });
                FocusScope.of(context).unfocus();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, false);
        return true;
      },
      child: new GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: new Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff242424),
            elevation: 0,
            title: Text(
              "Settings",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Builder(
            builder: (context) => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // System Values
                  Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                      child: Text(
                        "Settings Value",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      )),
                  Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      margin: EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                              title: new Row(
                            children: <Widget>[
                              new Text("Current daily limit"),
                              Spacer(),
                              new Text(currentDaily!)
                            ],
                          )),
                          ListTile(
                              title: new Row(
                            children: <Widget>[
                              Flexible(
                                  child: TextField(
                                controller: widget.amountController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Change Daily Limit',
                                ),
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                textAlign: TextAlign.end,
                              ))
                            ],
                          )),
                          ListTile(
                              title: new Row(
                            children: <Widget>[
                              Text("Currency"),
                              Spacer(),
                              DropdownButton<String>(
                                value: currency,
                                iconSize: 24,
                                elevation: 16,
                                underline: Container(
                                  height: 2,
                                ),
                                onChanged: (String? newValue) {
                                  if (newValue != currency) {
                                    _showMyDialog(newValue!, context);
                                  }
                                },
                                items: CurrencyInfo()
                                    .currencyList()
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              )
                            ],
                          ))
                        ],
                      )),
                  // System UI
                  Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                      child: Text(
                        "Settings UI",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      )),
                  Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      margin: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ListTile(
                              title: Row(
                            children: <Widget>[
                              Text("Show Save Button"),
                              Spacer(),
                              Switch(
                                  value: showSaveButton!,
                                  onChanged: (value) {
                                    setState(() {
                                      showSaveButton = value;
                                    });
                                  },
                                  activeTrackColor: Colors.grey.shade200,
                                  activeColor: Colors.black),
                            ],
                          )),
                          ListTile(
                              title: Row(
                            children: <Widget>[
                              Text("Show Entire History"),
                              Spacer(),
                              Switch(
                                  value: showEntireHistory!,
                                  onChanged: (value) {
                                    setState(() {
                                      showEntireHistory = value;
                                    });
                                  },
                                  activeTrackColor: Colors.grey.shade200,
                                  activeColor: Colors.black),
                            ],
                          )),
                        ],
                      )),
                  // Manage Subscriptions
                  Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      margin: EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[],
                      )),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                    color: Color(0xff242424),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                            onTap: () {
                              if (widget.amountController.text.isNotEmpty) {
                                if (!isNumeric(widget.amountController.text) ||
                                    (CurrencyInfo().getCurrencyDecimalPlaces(
                                                widget.stringData[""] ?? '') ==
                                            0 &&
                                        !isInt(widget.amountController.text))) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Your Amount is invalid. Please Check again'),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                  return;
                                } else {
                                  widget.numData["dailyLimit"] =
                                      num.parse(widget.amountController.text);
                                  saveSP("dailyLimit",
                                      widget.numData["dailyLimit"]);
                                }
                              }

                              // Checkbox for Disabling Save Button
                              widget.numData["showSave"] = 0;
                              if (showSaveButton!) {
                                widget.numData["showSave"] = 1;
                              }
                              saveSP("showSave", widget.numData["showSave"]);

                              // Checkbox for Disabling Save Button
                              widget.numData["historyMode"] = 0;
                              if (showEntireHistory!) {
                                widget.numData["historyMode"] = 1;
                              }
                              saveSP(
                                  "historyMode", widget.numData["historyMode"]);

                              if (currency != widget.stringData[""]) {
                                widget.stringData[""] = currency!;
                                saveSP("", currency);

                                clearDB();
                                Navigator.pop(context, true);
                              }
                              Navigator.pop(context, false);
                              setState(() {});
                            },
                            title: Text(
                              "Save Setting",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                              textAlign: TextAlign.center,
                            ))
                      ],
                    ),
                  ), // Save Button
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
