import 'package:get/get.dart';
import 'package:jahanpay/controllers/sign_in_controller.dart';

import '../controllers/history_controller.dart';

class SignInControllerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInController>(() => SignInController());
    Get.lazyPut<HistoryController>(() => HistoryController());
  }
}
