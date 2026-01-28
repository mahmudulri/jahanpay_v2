import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jahanpay/utils/api_endpoints.dart';

import '../global_controller/balance_controller.dart';
import '../models/dashboard_data_model.dart';
import 'company_controller.dart';

final box = GetStorage();

final companyController = Get.find<CompanyController>();

class DashboardController extends GetxController {
  void onhomeTabOpened() {
    fetchDashboardData();
    companyController.fetchCompany();
  }

  RxString message = "".obs;
  RxString myerror = "".obs;
  var isLoading = false.obs;

  var alldashboardData = DashboardDataModel().obs;

  UserBalanceController userBalanceController = Get.put(
    UserBalanceController(),
  );

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  /// Wrapper method
  void fetchDashboardData() async {
    try {
      isLoading.value = true;

      final data = await fetchDashbordApi();
      if (data != null) {
        alldashboardData.value = data;

        // Update balance safely
        userBalanceController.balance.value =
            data.data?.balance?.toString() ?? "0";

        myerror.value = "";
        message.value = "";
      }
    } catch (e) {
      print("Dashboard fetch error: $e");
      myerror.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// API call with error handling
  Future<DashboardDataModel?> fetchDashbordApi() async {
    final url = Uri.parse(
      ApiEndPoints.baseUrl + ApiEndPoints.otherendpoints.dashboard,
    );

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
      );

      final results = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // ✅ Success
        myerror.value = "";
        message.value = "";
        return DashboardDataModel.fromJson(results);
      } else if (response.statusCode == 403) {
        // ❌ Account Deactivated / Forbidden
        myerror.value = results["errors"] ?? "Deactivated";
        message.value = results["message"] ?? "Access forbidden";

        Fluttertoast.showToast(
          msg: message.value,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );

        return null; // ⚠️ no crash
      } else {
        // ❌ Other errors
        message.value = "Failed to fetch dashboard [${response.statusCode}]";

        Fluttertoast.showToast(
          msg: message.value,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );

        return null;
      }
    } catch (e) {
      print("Dashboard API exception: $e");

      message.value = "Network error! Please try again.";
      Fluttertoast.showToast(
        msg: message.value,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

      return null;
    }
  }
}
