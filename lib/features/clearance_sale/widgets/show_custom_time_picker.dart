import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/main.dart';


Future<TimeOfDay?> showCustomTimePicker() async {
  return await showTimePicker(
    context: Get.context!, initialTime: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
  );

}