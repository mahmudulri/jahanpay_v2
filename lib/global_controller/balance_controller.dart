import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class UserBalanceController extends GetxController {
  var isLoading = false.obs;

  RxInt selectedIndex = 0.obs;

  RxString balance = ''.obs;
  RxString comission = ''.obs;
  RxString todaycomission = ''.obs;
  RxString todayvalue = ''.obs;

  Color get currentColor {
    switch (selectedIndex.value) {
      case 0:
      case 2:
        return Colors.green;
      case 1:
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  /// ✅ Computed money formatter
  String get formattedBalance {
    if (balance.value.isEmpty) return '0.00';
    final number = double.tryParse(balance.value.replaceAll(',', '')) ?? 0.0;
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '', // change or remove symbol if needed
      decimalDigits: 2,
    );
    return formatter.format(number);
  }
}
