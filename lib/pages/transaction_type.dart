import 'package:jahanpay/widgets/button_one.dart';
import 'package:jahanpay/widgets/custom_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jahanpay/controllers/transaction_controller.dart';
import 'package:jahanpay/global_controller/languages_controller.dart';
import 'package:jahanpay/utils/colors.dart';
import 'package:jahanpay/widgets/bottomsheet.dart';
import 'package:jahanpay/widgets/drawer.dart';

import '../controllers/dashboard_controller.dart';
import '../controllers/drawer_controller.dart';
import '../global_controller/page_controller.dart';
import '../screens/commission_transfer_screen.dart';
import '../screens/hawala_list_screen.dart';
import '../screens/hawala_rates_screen.dart';
import '../screens/receipts_screen.dart';
import '../screens/loan_screen.dart';
import '../screens/sign_in_screen.dart';
import '../widgets/default_button1.dart';
import '../widgets/payment_button.dart';
import 'transactions.dart';

class TransactionsType extends StatefulWidget {
  TransactionsType({super.key});

  @override
  State<TransactionsType> createState() => _TransactionsTypeState();
}

class _TransactionsTypeState extends State<TransactionsType> {
  final Mypagecontroller mypagecontroller = Get.find();

  final transactionController = Get.find<TransactionController>();
  LanguagesController languagesController = Get.put(LanguagesController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final dashboardController = Get.find<DashboardController>();
  MyDrawerController drawerController = Get.put(MyDrawerController());

  @override
  void initState() {
    super.initState();
    dashboardController.fetchDashboardData();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryColor,
        statusBarIconBrightness: Brightness.light, // For Android
        statusBarBrightness: Brightness.light, // For iOS
      ),
    );
    transactionController.fetchTransactionData();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Obx(() {
      if (dashboardController.isLoading.value) {
        return Scaffold(
          body: Center(
            child: GestureDetector(
              onTap: () {
                print(dashboardController.isLoading.value.toString());
              },
              child: CircularProgressIndicator(color: Colors.grey),
            ),
          ),
        );
      } else if (dashboardController.myerror.value.trim().toLowerCase() ==
          "deactivated") {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dashboardController.myerror.toString(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 70),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17),
                            ),
                            contentPadding: EdgeInsets.all(0),
                            content: ContactDialogBox(),
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 45,
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/icons/whatsapp.png",
                            height: 30,
                            color: Colors.white,
                          ),
                          SizedBox(width: 20),
                          KText(
                            text: languagesController.tr("CONTACTUS"),
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          contentPadding: EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          content: LogoutDialogBox(),
                        );
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      child: Text(
                        languagesController.tr("LOGOUT"),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          key: _scaffoldKey,
          backgroundColor: Colors.white,
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
                          Obx(() {
                            final profileImageUrl = dashboardController
                                .alldashboardData
                                .value
                                .data
                                ?.userInfo
                                ?.profileImageUrl;

                            if (dashboardController.isLoading.value ||
                                profileImageUrl == null ||
                                profileImageUrl.isEmpty) {
                              return Container(
                                height: 42,
                                width: 42,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                  size: 30,
                                ),
                              );
                            }

                            return Container(
                              height: 42,
                              width: 42,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Colors.white,
                                image: DecorationImage(
                                  image: NetworkImage(profileImageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }),
                          Spacer(),
                          Obx(
                            () => KText(
                              text: languagesController.tr("TRANSACTIONS_TYPE"),
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
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.menu,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    width: screenWidth,
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
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Obx(
                                () => KText(
                                  text: languagesController.tr("SELECT"),
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff8082ED),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          PaymentButton(
                            buttonName: languagesController.tr(
                              "PAYMENT_RECEIPT_REQUEST",
                            ),
                            imagelink: "assets/icons/wallet.png",
                            mycolor: Color(0xff04B75D),
                            onpressed: () {
                              mypagecontroller.changePage(
                                ReceiptsScreen(),
                                isMainPage: false,
                              );
                            },
                          ),
                          SizedBox(height: 10),
                          PaymentButton(
                            buttonName: languagesController.tr(
                              "REQUES_LOAN_BALANCE",
                            ),
                            imagelink: "assets/icons/transactionsicon.png",
                            mycolor: Color(0xff3498db),
                            onpressed: () {
                              mypagecontroller.changePage(
                                RequestLoanScreen(),
                                isMainPage: false,
                              );
                            },
                          ),
                          SizedBox(height: 10),
                          PaymentButton(
                            buttonName: languagesController.tr("HAWALA"),
                            imagelink: "assets/icons/exchange.png",
                            mycolor: Color(0xffFE8F2D),
                            onpressed: () {
                              mypagecontroller.changePage(
                                HawalaListScreen(),
                                isMainPage: false,
                              );
                            },
                          ),
                          SizedBox(height: 10),
                          PaymentButton(
                            buttonName: languagesController.tr("HAWALA_RATES"),
                            imagelink: "assets/icons/exchange-rate.png",
                            mycolor: Color(0xff4B7AFC),
                            onpressed: () {
                              mypagecontroller.changePage(
                                HawalaCurrencyScreen(),
                                isMainPage: false,
                              );
                            },
                          ),
                          SizedBox(height: 10),
                          PaymentButton(
                            buttonName: languagesController.tr(
                              "BALANCE_TRANSACTIONS",
                            ),
                            imagelink: "assets/icons/transactionsicon.png",
                            mycolor: Color(0xffDE4B5E),
                            onpressed: () {
                              mypagecontroller.changePage(
                                Transactions(),
                                isMainPage: false,
                              );
                            },
                          ),
                          SizedBox(height: 10),
                          PaymentButton(
                            buttonName: languagesController.tr(
                              "TRANSFER_COMISSION_TO_BALANCE",
                            ),
                            imagelink: "assets/icons/transactionsicon.png",
                            mycolor: Color(0xff9b59b6),
                            onpressed: () {
                              mypagecontroller.changePage(
                                CommissionTransferScreen(),
                                isMainPage: false,
                              );
                            },
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
    });
  }
}
