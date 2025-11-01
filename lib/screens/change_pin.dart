import 'package:jahanpay/pages/homepages.dart';
import 'package:jahanpay/widgets/custom_text.dart';
import 'package:jahanpay/widgets/default_button1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:jahanpay/controllers/change_pin_controller.dart';
import 'package:jahanpay/global_controller/languages_controller.dart';
import 'package:jahanpay/global_controller/page_controller.dart';
import 'package:jahanpay/screens/profile_screen.dart';
import 'package:jahanpay/widgets/bottomsheet.dart';
import 'package:jahanpay/widgets/button_one.dart';
import 'package:jahanpay/widgets/drawer.dart';
import 'package:get_storage/get_storage.dart';

import '../global_controller/font_controller.dart';
import '../utils/colors.dart';
import 'change_balance.dart';

class ChangePinScreen extends StatefulWidget {
  ChangePinScreen({super.key});

  @override
  State<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> {
  final ChangePinController changePinController = Get.put(
    ChangePinController(),
  );

  LanguagesController languagesController = Get.put(LanguagesController());

  final Mypagecontroller mypagecontroller = Get.find();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                          mypagecontroller.goBack();
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
                          text: languagesController.tr("CHANGE_PIN"),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(0, 0),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Obx(
                            () => KText(
                              text: languagesController.tr("OLD_PIN"),
                              color: Colors.grey.shade600,
                              fontSize: screenHeight * 0.020,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Obx(
                        () => ChangePinBox(
                          hintText: languagesController.tr("ENTER_OLD_PIN"),
                          controller: changePinController.oldPinController,
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Obx(
                            () => KText(
                              text: languagesController.tr("NEW_PIN"),
                              color: Colors.grey.shade600,
                              fontSize: screenHeight * 0.020,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Obx(
                        () => ChangePinBox(
                          hintText: languagesController.tr("ENTER_NEW_PIN"),
                          controller: changePinController.newPinController,
                        ),
                      ),
                      SizedBox(height: 25),
                      Obx(
                        () => DefaultButton2(
                          height: 50,
                          width: screenWidth,
                          buttonName:
                              changePinController.isLoading.value == false
                              ? languagesController.tr("CHANGE_NOW")
                              : languagesController.tr("PLEASE_WAIT"),
                          onpressed: () {
                            if (changePinController
                                    .oldPinController
                                    .text
                                    .isEmpty ||
                                changePinController
                                    .newPinController
                                    .text
                                    .isEmpty) {
                              Fluttertoast.showToast(
                                msg: languagesController.tr(
                                  "FILL_DATA_CORRECTLY",
                                ),
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            } else {
                              changePinController.change();
                            }
                          },
                        ),
                      ),
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

class ChangePinBox extends StatelessWidget {
  ChangePinBox({super.key, this.hintText, this.controller});

  String? hintText;
  TextEditingController? controller;

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight * 0.065,
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,

              // suffixIcon: Icon(
              //   Icons.visibility_off,
              // ),
            ),
            style: TextStyle(
              fontFamily: box.read("language").toString() == "Fa"
                  ? Get.find<FontController>().currentFont
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
