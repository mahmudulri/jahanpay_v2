import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

import '../controllers/dashboard_controller.dart';

class UserBalanceController extends GetxController {
  var isLoading = false.obs;

  RxInt selectedIndex = 0.obs;

  RxString balance = ''.obs;
  RxString comission = ''.obs;
  RxString todaycomission = ''.obs;
  RxString todayvalue = ''.obs;
}
