import "package:intl/intl.dart";

class CurrencyInfo {
  Map<String, List<dynamic>> currencyFormat = {
    "POUND": [NumberFormat.currency(symbol: "\£", decimalDigits: 0), 0],
    "USD": [NumberFormat.currency(symbol: "\$", decimalDigits: 2), 2],
    "EURO": [NumberFormat.currency(symbol: "\€", decimalDigits: 0), 0],
  };

  currencyList() {
    return currencyFormat.keys;
  }

  getCurrencyText(String currency, num amount) {
    return currencyFormat[currency]?[0].format(amount);
  }

  getCurrencyDecimalPlaces(String currency) {
    if (currency.isNotEmpty) {
      return currencyFormat[currency]![1];
    }
  }
}
