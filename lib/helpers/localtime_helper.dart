import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:jahanpay/global_controller/time_zone_controller.dart';

import '../global_controller/font_controller.dart';

final TimeZoneController timeZoneController = Get.put(TimeZoneController());
final box = GetStorage();
String convertToDate(String utcTimeString) {
  try {
    DateTime utcTime = DateTime.parse(utcTimeString);
    Duration offset = Duration(
      hours: int.tryParse(timeZoneController.hour) ?? 0,
      minutes: int.tryParse(timeZoneController.minute) ?? 0,
    );
    DateTime localTime = timeZoneController.sign == "+"
        ? utcTime.add(offset)
        : utcTime.subtract(offset);
    return DateFormat('yyyy-MM-dd', 'en_US').format(localTime);
  } catch (e) {
    print("Error in convertToDate: $e");
    return '';
  }
}

String convertToLocalTime(String utcTimeString) {
  try {
    // 🕓 Parse the UTC time (e.g. "2025-10-31 13:52:02.000Z")
    DateTime utcTime = DateTime.parse(utcTimeString);

    // 🧮 Safe timezone offset parsing
    int hours = int.tryParse(timeZoneController.hour) ?? 0;
    int minutes = int.tryParse(timeZoneController.minute) ?? 0;
    String sign = timeZoneController.sign ?? '+';

    Duration offset = Duration(hours: hours, minutes: minutes);

    // ➕ or ➖ Apply timezone offset
    DateTime localTime = sign == "+"
        ? utcTime.add(offset)
        : utcTime.subtract(offset);

    // 🕘 Format to readable 12-hour format (e.g. "01:52 PM")
    return DateFormat('hh:mm a', 'en_US').format(localTime);
  } catch (e) {
    print("Error converting time: $e");
    return '--';
  }
}
