import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jahanpay/controllers/dashboard_controller.dart';
import 'package:jahanpay/global_controller/languages_controller.dart';
import 'package:jahanpay/utils/colors.dart';

import 'routes/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final dashboardController = Get.find<DashboardController>();
  final box = GetStorage();
  LanguagesController languagesController = Get.put(LanguagesController());

  checkData() async {
    String languageShortName = box.read("language") ?? "En";

    final matchedLang = languagesController.alllanguagedata.firstWhere(
      (lang) => lang["name"] == languageShortName,
      orElse: () => {"isoCode": "en", "direction": "ltr"},
    );

    final isoCode = matchedLang["isoCode"] ?? "en";

    final direction = matchedLang["direction"] ?? "ltr";

    box.write("language", languageShortName);
    box.write("direction", direction);

    languagesController.changeLanguage(languageShortName);

    Locale locale;

    switch (isoCode) {
      case "fa":
        locale = const Locale("fa", "IR");
        break;

      case "ar":
        locale = const Locale("ar", "AE");
        break;

      case "ps":
        locale = const Locale("ps", "AF");
        break;

      case "tr":
        locale = const Locale("tr", "TR");
        break;

      case "bn":
        locale = const Locale("bn", "BD");
        break;

      default:
        locale = const Locale("en", "US");
    }

    await context.setLocale(locale);

    if (!mounted) return;

    if (box.read('userToken') == null) {
      Get.offNamed(signinscreen);
    } else {
      dashboardController.fetchDashboardData();
      Get.offNamed(basescreen);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () async {
      if (!mounted) return;
      await checkData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Image.asset("assets/icons/logo.png", height: 240)],
        ),
      ),
    );
  }
}
