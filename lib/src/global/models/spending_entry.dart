import '../constants/database_strings.dart';

class SpendingEntry {
  int? id, timestamp, day;
  String? content;
  double? amount;

  SpendingEntry();

  SpendingEntry.fromMap(Map<dynamic, dynamic> map) {
    id = map[columnId];
    timestamp = map[columnTimeStamp];
    day = map[columnDay];
    amount = map[columnAmount];
    content = map[columnContent];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTimeStamp: timestamp,
      columnDay: day,
      columnAmount: amount,
      columnContent: content,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "{id: $id, day: $day, amount: $amount, content: $content}";
  }
}
