import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/spending_entry.dart';
import '../services/database_helpers.dart';

Future checkFirstSeen(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool _seen = (prefs.getBool('seen') ?? false);

  if (_seen) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  } else {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/splash', (Route<dynamic> route) => false);
  }
}

bool isNumeric(String? s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

finishSplash(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('seen', true);
  Navigator.of(context)
      .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
}

saveSP(String key, dynamic value) async {
  final prefs = await SharedPreferences.getInstance();

  if (value is String) {
    prefs.setString(key, value);
  } else if (value is bool) {
    prefs.setBool(key, value);
  } else if (value is int) {
    prefs.setInt(key, value);
  } else if (value is double) {
    prefs.setDouble(key, value);
  } else {
    prefs.setStringList(key, value);
  }
}

showSnackBar(BuildContext context, String s) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(s),
    duration: Duration(seconds: 3),
  ));
}

saveDB(SpendingEntry entry) async {
  DatabaseHelper helper = DatabaseHelper.instance;
  await helper.insertSpending(entry);
}

Future<dynamic> readSP(String key) async {
  final prefs = await SharedPreferences.getInstance();
  dynamic value = prefs.get(key);
  return value;
}

Future<List<SpendingEntry>> queryDBDay(num day) async {
  DatabaseHelper helper = DatabaseHelper.instance;
  return await helper.queryDay(day);
}

deleteDB(int id) async {
  DatabaseHelper helper = DatabaseHelper.instance;
  await helper.deleteSingleEntry(id);
}

updateDB(SpendingEntry entry) async {
  DatabaseHelper helper = DatabaseHelper.instance;
  await helper.updateSingleEntry(entry);
}

Future<List<SpendingEntry>> queryAllDB() async {
  DatabaseHelper helper = DatabaseHelper.instance;
  return await helper.queryAllSpending();
}

bool isInt(String? s) {
  if (s == null) {
    return false;
  }
  return int.tryParse(s) != null;
}

clearDB() async {
  DatabaseHelper helper = DatabaseHelper.instance;
  helper.clearSpendingTable();
}
