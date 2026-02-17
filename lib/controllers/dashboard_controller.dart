import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jahanpay/utils/api_endpoints.dart';

import '../global_controller/balance_controller.dart';
import '../models/dashboard_data_model.dart';
import '../services/dashboard_service.dart';
import 'company_controller.dart';

final box = GetStorage();

final companyController = Get.find<CompanyController>();

class DashboardController extends GetxController {
  void onhomeTabOpened() {
    fetchDashboardData();
    companyController.fetchCompany();
  }

  void setDeactivated(String status, String message) {
    deactiveStatus.value = status;
    deactivateMessage.value = message;
  }

  var isLoading = false.obs;
  final deactiveStatus = ''.obs;
  final deactivateMessage = ''.obs;

  var alldashboardData = DashboardDataModel().obs;

  UserBalanceController userBalanceController = Get.put(
    UserBalanceController(),
  );

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      await DashboardApi().fetchDashboard().then((value) {
        alldashboardData.value = value;
        userBalanceController.balance.value = alldashboardData
            .value
            .data!
            .balance
            .toString();
      });
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
