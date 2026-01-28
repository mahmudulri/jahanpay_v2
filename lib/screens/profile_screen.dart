import 'dart:io';

import 'package:jahanpay/widgets/custom_text.dart';
import 'package:jahanpay/widgets/default_button1.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jahanpay/controllers/dashboard_controller.dart';
import 'package:jahanpay/controllers/drawer_controller.dart';
import 'package:jahanpay/global_controller/languages_controller.dart';
import 'package:jahanpay/pages/homepages.dart';
import 'package:jahanpay/screens/change_pin.dart';
import 'package:jahanpay/utils/colors.dart';
import 'package:jahanpay/widgets/bottomsheet.dart';
import 'package:jahanpay/widgets/button_one.dart';
import 'package:jahanpay/widgets/drawer.dart';

import '../global_controller/page_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final dashboardController = Get.find<DashboardController>();

  LanguagesController languagesController = Get.put(LanguagesController());

  final Mypagecontroller mypagecontroller = Get.find();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  MyDrawerController drawerController = Get.put(MyDrawerController());
  final box = GetStorage();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryColor,
        statusBarIconBrightness: Brightness.light, // For Android
        statusBarBrightness: Brightness.light, // For iOS
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/back.webp'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 40),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          mypagecontroller.handleBack();
                          ;
                        },
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Icon(FontAwesomeIcons.chevronLeft),
                          ),
                        ),
                      ),
                      Spacer(),
                      Obx(
                        () => KText(
                          text: languagesController.tr("PROFILE"),
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.045,
                          color: Colors.white,
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          CustomFullScreenSheet.show(context);
                        },
                        child: Container(
                          height: 42,
                          width: 42,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.menu, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Center(
              child:
                  dashboardController
                          .alldashboardData
                          .value
                          .data!
                          .userInfo!
                          .profileImageUrl !=
                      null
                  ? Container(
                      height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            dashboardController
                                .alldashboardData
                                .value
                                .data!
                                .userInfo!
                                .profileImageUrl
                                .toString(),
                          ),
                          fit: BoxFit.cover,
                        ),
                        shape: BoxShape.circle,
                      ),
                    )
                  : Container(
                      height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 100,
                        ),
                      ),
                    ),
            ),
            SizedBox(height: 15),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 100),
            //   child: GestureDetector(
            //     onTap: () {
            //       mypagecontroller.changePage(
            //         ChangePinScreen(),
            //         isMainPage: false,
            //       );
            //     },
            //     child: DefaultButton1(
            //       width: double.maxFinite,
            //       height: 45,
            //       buttonName: languagesController.tr("CHANGE_PIN"),
            //     ),
            //   ),
            // ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  child: ListView(
                    padding: EdgeInsets.all(0),
                    children: [
                      SizedBox(height: 10),
                      Obx(
                        () => Profilebox(
                          boxname: languagesController.tr("FULL_NAME"),
                          data: dashboardController
                              .alldashboardData
                              .value
                              .data!
                              .userInfo!
                              .resellerName
                              .toString(),
                        ),
                      ),
                      SizedBox(height: 7),
                      Obx(
                        () => Profilebox(
                          boxname: languagesController.tr("EMAIL"),
                          data: dashboardController
                              .alldashboardData
                              .value
                              .data!
                              .userInfo!
                              .email
                              .toString(),
                        ),
                      ),
                      SizedBox(height: 7),
                      Obx(
                        () => Profilebox(
                          boxname: languagesController.tr("PHONENUMBER"),
                          data: dashboardController
                              .alldashboardData
                              .value
                              .data!
                              .userInfo!
                              .phone
                              .toString(),
                        ),
                      ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Profilebox(
                      //   boxname: "Location",
                      //   data: "IRAN, RAZAVIKHHORASAN, MASHHAD",
                      // ),
                      SizedBox(height: 7),
                      Obx(
                        () => Profilebox(
                          boxname: languagesController.tr("BALANCE"),
                          data:
                              dashboardController
                                  .alldashboardData
                                  .value
                                  .data!
                                  .userInfo!
                                  .balance
                                  .toString() +
                              " " +
                              box.read("currency_code"),
                        ),
                      ),
                      SizedBox(height: 7),
                      Obx(
                        () => Profilebox(
                          boxname: languagesController.tr("LOAN_BALANCE"),
                          data:
                              dashboardController
                                  .alldashboardData
                                  .value
                                  .data!
                                  .userInfo!
                                  .loanBalance
                                  .toString() +
                              " " +
                              box.read("currency_code"),
                        ),
                      ),
                      SizedBox(height: 7),
                      Obx(
                        () => Profilebox(
                          boxname: languagesController.tr("TOTAL_SOLD_AMOUNT"),
                          data:
                              dashboardController
                                  .alldashboardData
                                  .value
                                  .data!
                                  .totalSoldAmount
                                  .toString() +
                              " " +
                              box.read("currency_code"),
                        ),
                      ),
                      SizedBox(height: 7),
                      Obx(
                        () => Profilebox(
                          boxname: languagesController.tr("TOTAL_REVENUE"),
                          data:
                              dashboardController
                                  .alldashboardData
                                  .value
                                  .data!
                                  .totalRevenue
                                  .toString() +
                              " " +
                              box.read("currency_code"),
                        ),
                      ),

                      SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Profilebox extends StatelessWidget {
  Profilebox({super.key, this.boxname, this.data});

  String? boxname;
  String? data;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight * 0.065,
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            KText(text: boxname.toString()),
            KText(text: data.toString(), fontSize: screenHeight * 0.0150),
          ],
        ),
      ),
    );
  }
}
