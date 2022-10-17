import 'dart:math';

import 'package:flutter/material.dart';

import '../../../global/helper_classes/currency_info.dart';
import '../../../global/helper_methods/methods.dart';
import '../../../global/models/spending_entry.dart';

class SpendMoneyScreen extends StatefulWidget {
  final Map<String, num> numData;
  final Map<String, String> stringData;
  final _myController = TextEditingController();

  SpendMoneyScreen({
    Key? key,
    required this.numData,
    required this.stringData,
  }) : super(key: key);

  @override
  State createState() => _SpendMoneyState();
}

class _SpendMoneyState extends State<SpendMoneyScreen> {
  String amount = '';

  @override
  void initState() {
    super.initState();

    widget.numData["keypadVisibility"] = 1.0;

    // KeyboardVisibility.onChange.listen((bool visible) {
    //   widget.numData["keypadVisibility"] = 1.0;
    //   if (visible) {
    //     widget.numData["keypadVisibility"] = 0.0;
    //   }
    //   if (this.mounted) {
    //     setState(() {});
    //   }
    // });
  }

  String getMoneyText() {
    return CurrencyInfo().getCurrencyText(
            widget.stringData[''] ?? "",
            num.parse(amount) /
                pow(
                    10,
                    CurrencyInfo().getCurrencyDecimalPlaces(
                            widget.stringData[''] ?? '') ??
                        0)) ??
        '';
  }

  Widget buildButton(String s, Color? color,
      [Icon? i, Color? c, double? fontSize]) {
    return Expanded(
        child: Container(
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(40.0),
      // ),
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
      child: MaterialButton(
        child: i == null
            ? Text(
                s,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: fontSize == null ? 20.0 : fontSize,
                ),
              )
            : i,
        color: c,
        padding: new EdgeInsets.all(20.0),
        onPressed: () => buttonPressed(s),
      ),
    ));
  }

  void buttonPressed(String s) {
    if (s == "erase") {
      if (amount.length > 1) {
        amount = amount.substring(0, amount.length - 1);
      } else {
        amount = "0";
      }
    } else if (s == "Spend" || s == "Save") {
      FocusScope.of(context).unfocus();
      double val = num.parse(amount) /
          pow(
              10,
              CurrencyInfo().getCurrencyDecimalPlaces(
                widget.stringData['']!,
              ));

      if (val > 0) {
        String content = widget._myController.text.isEmpty
            ? ("")
            : widget._myController.text;

        SpendingEntry entry = SpendingEntry();

        if (s == "Spend") {
          val *= -1;
        }

        DateTime dt = DateTime.now().toLocal();
        entry.timestamp = dt.millisecondsSinceEpoch;
        entry.day = DateTime(dt.year, dt.month, dt.day).millisecondsSinceEpoch;
        entry.amount = val;
        entry.content = content;
        // Save new Entry
        saveDB(entry);

        widget.numData["todaySpent"] = widget.numData["todaySpent"]! + val;
        saveSP("todaySpent", widget.numData["todaySpent"]);
        // Reset Amount and Content
        amount = "0";
        widget._myController.text = "";
      }
    } else if (s == "C") {
      amount = "0";
    } else {
      amount += s;
    }

    setState(() {
      widget.numData["spendAmount"] = int.parse(amount);
    });
  }

  @override
  Widget build(BuildContext context) {
    amount = widget.numData["spendAmount"]!.toInt().toString();
    widget._myController.text = widget.stringData["spendContent"] ?? '';
    widget._myController.selection = TextSelection.fromPosition(
        TextPosition(offset: widget._myController.text.length));

    return new GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: new Container(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 55, 0, 30),
                      child: Text(
                        getMoneyText(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 50,
                        ),
                      ),
                    ),
                    ListTile(
                        title: Row(
                      children: <Widget>[
                        Flexible(
                            child: TextFormField(
                          controller: widget._myController,
                          onChanged: (text) {
                            widget.stringData["spendContent"] = text;
                          },
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: 'Enter Description',
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 2.0),
                            ),
                          ),
                          textAlign: TextAlign.start,
                        ))
                      ],
                    )),
                    Expanded(child: Container()),
                    Visibility(
                        visible: widget.numData["keypadVisibility"] == 1.0,
                        child: new Column(
                          children: [
                            Row(
                              children: [
                                buildButton("1", Color(0xff242424)),
                                buildButton("2", Color(0xff242424)),
                                buildButton("3", Color(0xff242424)),
                              ],
                            ),
                            Row(
                              children: [
                                buildButton("4", Color(0xff242424)),
                                buildButton("5", Color(0xff242424)),
                                buildButton("6", Color(0xff242424)),
                              ],
                            ),
                            Row(
                              children: [
                                buildButton("7", Color(0xff242424)),
                                buildButton("8", Color(0xff242424)),
                                buildButton("9", Color(0xff242424)),
                              ],
                            ),
                            Row(
                              children: [
                                buildButton("C", Color(0xff242424)),
                                buildButton("0", Color(0xff242424)),
                                buildButton("erase", Color(0xff242424),
                                    Icon(Icons.backspace)),
                              ],
                            )
                          ],
                        )),
                    IntrinsicHeight(
                      child: Row(children: [
                        Visibility(
                          visible: widget.numData["showSave"] == 1,
                          child: buildButton(
                              "Save", Colors.black, null, Color(0xffF5EDFD)),
                        ),
                        Visibility(
                            visible: widget.numData["showSave"] == 1,
                            child: Container(
                              width: 1,
                              color: Colors.black12,
                            )),
                        buildButton(
                            "Spend", Colors.white, null, Color(0xff242424)),
                      ]),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
