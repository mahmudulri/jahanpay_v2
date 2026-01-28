import 'dart:io';

import 'package:jahanpay/widgets/custom_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:jahanpay/controllers/dashboard_controller.dart';
import 'package:jahanpay/global_controller/languages_controller.dart';
import 'package:jahanpay/global_controller/page_controller.dart';
import 'package:jahanpay/pages/homepages.dart';
import 'package:jahanpay/pages/network.dart';
import 'package:jahanpay/pages/orders.dart';
import 'package:jahanpay/pages/transactions.dart';
import 'package:jahanpay/utils/colors.dart';
import 'package:jahanpay/widgets/drawer.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/drawer_controller.dart';
import '../pages/transaction_type.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final dashboardController = Get.find<DashboardController>();
  final Mypagecontroller mypagecontroller = Get.put(Mypagecontroller());
  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );
  final MyDrawerController drawerController = Get.put(MyDrawerController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  void _onTabTap(int index) {
    if (mypagecontroller.selectedIndex.value == index) return;

    HapticFeedback.lightImpact();
    mypagecontroller.onTabSelected(index);
    mypagecontroller.goToMainPageByIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: mypagecontroller.handleBack,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        backgroundColor: const Color(0xffF1F3FF),
        body: SizedBox(
          height: screenHeight,
          width: screenWidth,
          child: Stack(
            children: [
              /// MAIN PAGE CONTENT (FROM NAVIGATOR)
              Positioned.fill(
                child: Navigator(
                  key: mypagecontroller.navigatorKey,
                  onGenerateRoute: (_) => MaterialPageRoute(
                    builder: (_) => Obx(
                      () => mypagecontroller
                          .mainPages[mypagecontroller.selectedIndex.value],
                    ),
                  ),
                ),
              ),

              /// BOTTOM BAR (DESIGN UNCHANGED)
              Positioned(
                bottom: 0,
                child: SafeArea(
                  child: Container(
                    height: 70,
                    width: screenWidth,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
                    child: Obx(() {
                      final index = mypagecontroller.selectedIndex.value;

                      return Row(
                        children: [
                          Expanded(
                            flex: index == 0 ? 2 : 1,
                            child: GestureDetector(
                              onTap: () => _onTabTap(0),
                              child: Center(
                                child: index == 0
                                    ? _buildFullStack(
                                        const Color(0xff6A32F6),
                                        languagesController.tr("HOME"),
                                        "assets/icons/homeicon.png",
                                      )
                                    : _buildSimpleStack(
                                        const Color(0xff6A32F6),
                                        "assets/icons/homeicon.png",
                                        languagesController.tr("HOME"),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),

                          Expanded(
                            flex: index == 1 ? 2 : 1,
                            child: GestureDetector(
                              onTap: () => _onTabTap(1),
                              child: Center(
                                child: index == 1
                                    ? _buildFullStack(
                                        const Color(0xff2ecc71),
                                        languagesController.tr("ORDERS"),
                                        "assets/icons/ordericon.png",
                                      )
                                    : _buildSimpleStack(
                                        const Color(0xff2ecc71),
                                        "assets/icons/ordericon.png",
                                        languagesController.tr("ORDERS"),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),

                          Expanded(
                            flex: index == 2 ? 2 : 1,
                            child: GestureDetector(
                              onTap: () => _onTabTap(2),
                              child: Center(
                                child: index == 2
                                    ? _buildFullStack(
                                        const Color(0xff2c3e50),
                                        languagesController.tr("TRANSACTIONS"),
                                        "assets/icons/transactionsicon.png",
                                      )
                                    : _buildSimpleStack(
                                        const Color(0xff2c3e50),
                                        "assets/icons/transactionsicon.png",
                                        languagesController.tr("TRANSACTIONS"),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),

                          Expanded(
                            flex: index == 3 ? 2 : 1,
                            child: GestureDetector(
                              onTap: () => _onTabTap(3),
                              child: Center(
                                child: index == 3
                                    ? _buildFullStack(
                                        const Color(0xffe74c3c),
                                        languagesController.tr("NETWORK"),
                                        "assets/icons/sub_reseller.png",
                                      )
                                    : _buildSimpleStack(
                                        const Color(0xffe74c3c),
                                        "assets/icons/sub_reseller.png",
                                        languagesController.tr("NETWORK"),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildFullStack(Color color, String menuname, String image) {
  final box = GetStorage();
  return Container(
    height: 50,
    width: 130,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: color,
    ),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(image.toString(), color: Colors.white, height: 30),
            KText(
              text: menuname,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ],
        ),
      ),
    ),
  );
}

// Simple Stack Design (Without the first container)
Widget _buildSimpleStack(Color color, String image, String name) {
  return Container(
    height: 50,
    width: 130,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: color,
    ),
    child: Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(image.toString(), color: Colors.white, height: 20),
              KText(text: name, fontSize: 8, color: Colors.white),
            ],
          ),
        ),
      ),
    ),
  );
}
