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
  BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final dashboardController = Get.find<DashboardController>();

  int _selectedIndex = 0;
  final Mypagecontroller mypagecontroller = Get.put(Mypagecontroller());

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  var currentIndex = 0;

  var selectedFlexIndex = 0.obs;

  @override
  void initState() {
    super.initState();
    dashboardController.fetchDashboardData();
    mypagecontroller.setUpdateIndexCallback(_onItemTapped);
  }

  LanguagesController languagesController = Get.put(LanguagesController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  MyDrawerController drawerController = Get.put(MyDrawerController());

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    Future<bool> showExitPopup() async {
      final shouldExit = mypagecontroller.goBack();
      if (shouldExit) {
        return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(languagesController.tr("EXIT_APP")),
                content: Text(
                  languagesController.tr("DO_YOU_WANT_TO_EXIT_APP"),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(languagesController.tr("NO")),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      exit(0);
                    },
                    child: Text(languagesController.tr("YES")),
                  ),
                ],
              ),
            ) ??
            false;
      }
      setState(() {}); // Rebuild screen after popping
      return false;
    }

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        backgroundColor: Color(0xffF1F3FF),
        body: Container(
          height: screenHeight,
          width: screenWidth,
          child: Stack(
            children: [
              Positioned.fill(
                child: Obx(() => mypagecontroller.pageStack.last),
              ),
              Positioned(
                bottom: 0,
                child: SafeArea(
                  child: Container(
                    height: 70,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 5),
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: selectedFlexIndex.value == 0 ? 2 : 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedFlexIndex.value =
                                      0; // Set this container to active
                                  mypagecontroller.changePage(Homepages());
                                });
                              },
                              child: Container(
                                child: Obx(
                                  () => Center(
                                    child: selectedFlexIndex.value == 0
                                        ? _buildFullStack(
                                            selectedFlexIndex.value == 0
                                                ? Color(0xff6A32F6)
                                                : Color(0xff6A32F6),
                                            languagesController.tr("HOME"),
                                            "assets/icons/homeicon.png",
                                          ) // Show full Stack design
                                        : _buildSimpleStack(
                                            Color(0xff6A32F6),
                                            "assets/icons/homeicon.png",
                                            languagesController.tr("HOME"),
                                          ), // Show reduced Stack design
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            flex: selectedFlexIndex.value == 1 ? 2 : 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedFlexIndex.value =
                                      1; // Set this container to active
                                  print("Order");
                                  mypagecontroller.changePage(Orders());
                                });
                              },
                              child: Container(
                                child: Obx(
                                  () => Center(
                                    child: selectedFlexIndex.value == 1
                                        ? _buildFullStack(
                                            selectedFlexIndex.value == 0
                                                ? Color(0xff2ecc71)
                                                : Color(0xff2ecc71),
                                            languagesController.tr("ORDERS"),
                                            "assets/icons/ordericon.png",
                                          )
                                        : _buildSimpleStack(
                                            Color(0xff2ecc71),
                                            "assets/icons/ordericon.png",
                                            languagesController.tr("ORDERS"),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            flex: selectedFlexIndex.value == 2 ? 2 : 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedFlexIndex.value =
                                      2; // Set this container to active
                                  mypagecontroller.changePage(
                                    TransactionsType(),
                                  );

                                  print("Transactions");
                                });
                              },
                              child: Container(
                                child: Obx(
                                  () => Center(
                                    child: selectedFlexIndex.value == 2
                                        ? _buildFullStack(
                                            selectedFlexIndex.value == 0
                                                ? Color(0xff2c3e50)
                                                : Color(0xff2c3e50),
                                            languagesController.tr(
                                              "TRANSACTIONS",
                                            ),
                                            "assets/icons/transactionsicon.png",
                                          )
                                        : _buildSimpleStack(
                                            Color(0xff2c3e50),
                                            "assets/icons/transactionsicon.png",
                                            languagesController.tr(
                                              "TRANSACTIONS",
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            flex: selectedFlexIndex.value == 3 ? 2 : 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedFlexIndex.value =
                                      3; // Set this container to active
                                  mypagecontroller.changePage(Network());
                                });
                              },
                              child: Container(
                                child: Obx(
                                  () => Center(
                                    child: selectedFlexIndex.value == 3
                                        ? _buildFullStack(
                                            selectedFlexIndex.value == 0
                                                ? Color(0xffe74c3c)
                                                : Color(0xffe74c3c),
                                            languagesController.tr("NETWORK"),
                                            "assets/icons/sub_reseller.png",
                                          )
                                        : _buildSimpleStack(
                                            Color(0xffe74c3c),
                                            "assets/icons/sub_reseller.png",
                                            languagesController.tr("NETWORK"),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> imagedata = [
    "assets/icons/homeicon.png",
    "assets/icons/transactionsicon.png",
    "assets/icons/ordericon.png",
    "assets/icons/sub_reseller.png",
  ];
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
