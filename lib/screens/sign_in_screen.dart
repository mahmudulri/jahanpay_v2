import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jahanpay/widgets/custom_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jahanpay/controllers/dashboard_controller.dart';
import 'package:jahanpay/controllers/sign_in_controller.dart';
import 'package:jahanpay/global_controller/page_controller.dart';
import 'package:jahanpay/global_controller/languages_controller.dart';
import 'package:jahanpay/routes/routes.dart';

import 'package:jahanpay/screens/sign_up_screen.dart';
import 'package:jahanpay/utils/colors.dart';
import 'package:jahanpay/widgets/authtextfield.dart';
import 'package:jahanpay/widgets/social_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/bottomsheet.dart';
import '../widgets/socialbuttonbox.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  LanguagesController languagesController = Get.put(LanguagesController());
  // final Mypagecontroller mypagecontroller = Get.find();

  // final Mypagecontroller mypagecontroller = Get.find();

  final signInController = Get.find<SignInController>();

  final dashboardController = Get.find<DashboardController>();

  final box = GetStorage();

  final String phoneNumber = "+989059472461";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white, // Status bar background color
        statusBarIconBrightness: Brightness.dark, // For Android
        statusBarBrightness: Brightness.light, // For iOS
      ),
    );
  }

  final Mypagecontroller mypagecontroller = Get.put(Mypagecontroller());
  Future<bool> showExitPopup() async {
    final shouldExit = mypagecontroller.goBack();
    if (shouldExit) {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(languagesController.tr("EXIT_APP")),
              content: Text(languagesController.tr("DO_YOU_WANT_TO_EXIT_APP")),
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

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            height: screenHeight,
            width: screenWidth,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/sign.webp'),
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 0, left: 20, right: 20),
              child: Container(
                child: Column(
                  children: [
                    Image.asset("assets/icons/logo.png", height: 230),
                    SizedBox(height: 65),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        signInController.usernameController.text =
                            "01986072587";
                        signInController.passwordController.text = "00000000";
                      },
                      child: Text("01986"),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        signInController.usernameController.text = "0796321768";
                        signInController.passwordController.text = "00000000";
                      },
                      child: Text("0796321"),
                    ),
                    KText(
                      text: languagesController.tr("ENTER_YOUR_LOGIN_INFO"),
                      fontSize: 15,
                      color: Color(0xffF4F6F8),
                    ),
                    SizedBox(height: 10),
                    Authtextfield(
                      hinttext: languagesController.tr("USERNAME"),
                      controller: signInController.usernameController,
                    ),
                    SizedBox(height: 10),
                    Authtextfield(
                      hinttext: languagesController.tr("PASSWORD"),
                      controller: signInController.passwordController,
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        KText(
                          text: languagesController.tr("FORGOT_YOUR_PASSWORD"),
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        SizedBox(width: 8),
                        KText(
                          text: languagesController.tr("PASSWORD_RECOVERY"),
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Obx(
                      () => SinInbutton(
                        width: screenWidth,
                        height: 50,
                        buttonName: signInController.isLoading.value == false
                            ? languagesController.tr("LOGIN")
                            : languagesController.tr("PLEASE_WAIT"),
                        onpressed: () async {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => BaseScreen(),
                          //   ),
                          // );
                          if (signInController
                                  .usernameController
                                  .text
                                  .isEmpty ||
                              signInController
                                  .passwordController
                                  .text
                                  .isEmpty) {
                            Get.snackbar("Oops!", "Fill the text fields");
                          } else {
                            print("Attempting login...");
                            await signInController.signIn();

                            if (signInController.loginsuccess.value == false) {
                              dashboardController.fetchDashboardData();
                              // Navigating to the BottomNavigationbar page
                              // countryListController.fetchCountryData();
                              Get.toNamed(basescreen);

                              // if (box.read("direction") == "rtl") {
                              //   setState(() {
                              //     EasyLocalization.of(context)!
                              //         .setLocale(Locale('ar', 'AE'));
                              //   });
                              // } else {
                              //   setState(() {
                              //     EasyLocalization.of(context)!
                              //         .setLocale(Locale('en', 'US'));
                              //   });
                              // }
                            } else {
                              print("Navigation conditions not met.");
                            }
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 60,
                      width: screenWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              whatsapp();
                            },
                            child: Icon(FontAwesomeIcons.whatsapp, size: 40),
                          ),
                          SizedBox(width: 50),
                          GestureDetector(
                            onTap: () {
                              showSocialPopup(context);
                            },
                            child: Image.asset(
                              "assets/icons/social-media.png",
                              height: 40,
                            ),
                          ),
                          SizedBox(width: 50),
                          GestureDetector(
                            onTap: () {
                              _makePhoneCall(phoneNumber);
                            },
                            child: Icon(FontAwesomeIcons.phone, size: 28),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        KText(
                          text: languagesController.tr(
                            "HAVE_NOT_REGISTERED_YET",
                          ),
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        SizedBox(width: 8),
                        KText(
                          text: languagesController.tr("REGISTER"),
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class languageBox extends StatelessWidget {
  const languageBox({super.key, this.lanName, this.onpressed});
  final String? lanName;
  final VoidCallback? onpressed;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: GestureDetector(
        onTap: onpressed,
        child: Container(
          margin: EdgeInsets.only(bottom: 6),
          height: 40,
          width: screenWidth,
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              lanName.toString(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SinInbutton extends StatelessWidget {
  final double width;
  final double height;
  final String? buttonName;
  final VoidCallback? onpressed;

  SinInbutton({
    required this.width,
    required this.height,
    this.buttonName,
    this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white.withOpacity(0.3), Colors.transparent],
                  ),
                ),
                child: Center(
                  child: KText(
                    text: buttonName.toString(),
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
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

Future<void> _makePhoneCall(String number) async {
  final Uri url = Uri(scheme: 'tel', path: number);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}
