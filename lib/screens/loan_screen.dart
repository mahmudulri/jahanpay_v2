import 'package:jahanpay/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jahanpay/controllers/dashboard_controller.dart';
import 'package:jahanpay/controllers/drawer_controller.dart';
import 'package:jahanpay/global_controller/languages_controller.dart';
import 'package:jahanpay/global_controller/page_controller.dart';
import 'package:jahanpay/screens/add_new_user.dart';
import 'package:jahanpay/widgets/bottomsheet.dart';
import '../controllers/loanlist_controller.dart';
import '../controllers/payments_controller.dart';
import '../controllers/request_loan_controller.dart';
import '../global_controller/font_controller.dart';
import '../widgets/custom_text.dart';
import '../widgets/normaltext.dart';
import 'create_payments_screen.dart';

class RequestLoanScreen extends StatefulWidget {
  const RequestLoanScreen({super.key});

  @override
  State<RequestLoanScreen> createState() => _RequestLoanScreenState();
}

final Mypagecontroller mypagecontroller = Get.find();

LanguagesController languagesController = Get.put(LanguagesController());

class _RequestLoanScreenState extends State<RequestLoanScreen> {
  List orderStatus = [];
  String defaultValue = "";

  String secondDropDown = "";
  @override
  void initState() {
    super.initState();

    loanlistController.fetchLoan();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryColor,
        statusBarIconBrightness: Brightness.light, // For Android
        statusBarBrightness: Brightness.light, // For iOS
      ),
    );
  }

  final box = GetStorage();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final dashboardController = Get.find<DashboardController>();
  MyDrawerController drawerController = Get.put(MyDrawerController());

  LoanlistController loanlistController = Get.put(LoanlistController());
  RequestLoanController requestLoanController = Get.put(
    RequestLoanController(),
  );

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: Color(0xffF1F3FF),
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
                          text: languagesController.tr("LOAN_REQUEST"),
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
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
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
                width: screenWidth,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                content: Container(
                                  height: 200,
                                  width: screenWidth,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      KText(
                                        text: languagesController.tr(
                                          "ENTER_LOAN_AMOUNT",
                                        ),
                                        fontSize: 20,
                                      ),
                                      Container(
                                        height: 50,
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 1,
                                            color: Colors.grey.shade300,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  style: TextStyle(),
                                                  controller:
                                                      requestLoanController
                                                          .amountController,
                                                  keyboardType:
                                                      TextInputType.phone,
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText:
                                                        languagesController.tr(
                                                          "ENTER_AMOUNT",
                                                        ),
                                                    hintStyle: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily:
                                                          box
                                                                  .read(
                                                                    "language",
                                                                  )
                                                                  .toString() ==
                                                              "Fa"
                                                          ? Get.find<
                                                                  FontController
                                                                >()
                                                                .currentFont
                                                          : null,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              KText(
                                                text: box.read("currency_code"),
                                                color: Colors.grey.shade600,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: 45,
                                          width: screenWidth,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                height: 45,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Center(
                                                  child: KText(
                                                    text: languagesController
                                                        .tr("CANCEL"),
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  if (requestLoanController
                                                      .amountController
                                                      .text
                                                      .isNotEmpty) {
                                                    requestLoanController
                                                        .requestloan();
                                                  } else {
                                                    Fluttertoast.showToast(
                                                      msg: languagesController.tr(
                                                        "FILL_DATA_CORRECTLY",
                                                      ),
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.TOP,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                          Colors.red,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0,
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  height: 45,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xffff04B75D),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  child: Center(
                                                    child: Obx(
                                                      () => KText(
                                                        text:
                                                            requestLoanController
                                                                    .isLoading
                                                                    .value ==
                                                                false
                                                            ? languagesController
                                                                  .tr("SUBMIT")
                                                            : languagesController
                                                                  .tr(
                                                                    "PLEASE_WAIT",
                                                                  ),
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          height: 50,
                          width: screenWidth,
                          child: Obx(
                            () => Container(
                              decoration: BoxDecoration(
                                color: Color(0xff04B75D),
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
                                          colors: [
                                            Colors.white.withOpacity(
                                              0.3,
                                            ), // উপরের দিকের হালকা সাদা
                                            Colors.transparent, // নিচে স্বচ্ছ
                                          ],
                                        ),
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 10),
                                            KText(
                                              text: languagesController.tr(
                                                "ADD_NEW_REQUEST",
                                              ),
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ],
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
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                width: screenWidth,
                // color: Colors.grey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Obx(
                    () => loanlistController.isLoading.value == false
                        ? ListView.separated(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.all(0),
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 10);
                            },
                            itemCount: loanlistController
                                .allloanlist
                                .value
                                .data!
                                .balances!
                                .data!
                                .length,
                            itemBuilder: (context, index) {
                              final data = loanlistController
                                  .allloanlist
                                  .value
                                  .data!
                                  .balances!
                                  .data![index];
                              return GestureDetector(
                                onTap: () {},
                                child: Container(
                                  height: 160,
                                  width: screenWidth,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 1,
                                      color: data.status.toString() == "pending"
                                          ? Color(0xffFFC107)
                                          : data.status.toString() ==
                                                "completed"
                                          ? Colors.green
                                          : Color(0xffFF4842),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color:
                                                data.status.toString() ==
                                                    "pending"
                                                ? Color(
                                                    0xffFFC107,
                                                  ).withOpacity(0.12)
                                                : data.status.toString() ==
                                                      "completed"
                                                ? Colors.green.withOpacity(0.12)
                                                : Color(
                                                    0xffFF4842,
                                                  ).withOpacity(0.4),
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                KText(
                                                  text: languagesController.tr(
                                                    "AMOUNT",
                                                  ),
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                Spacer(),
                                                DKText(
                                                  text: data.amount.toString(),
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                SizedBox(width: 4),
                                                KText(
                                                  text: data.currency!.symbol
                                                      .toString(),
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  KText(
                                                    text: languagesController
                                                        .tr("TRANSACTION_TYPE"),
                                                  ),
                                                  KText(
                                                    text: data.transactionType
                                                        .toString(),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  KText(
                                                    text: languagesController
                                                        .tr(
                                                          "REMAINING_BALANCE",
                                                        ),
                                                  ),
                                                  Spacer(),
                                                  DKText(
                                                    text: data.remainingBalance
                                                        .toString(),
                                                  ),
                                                  SizedBox(width: 4),
                                                  KText(
                                                    text: data.currency!.code
                                                        .toString(),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  KText(
                                                    text: languagesController
                                                        .tr("NOTES"),
                                                  ),
                                                  SizedBox(width: 100),
                                                  Expanded(
                                                    child: Text(
                                                      data.description
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontFamily:
                                                            box
                                                                    .read(
                                                                      "language",
                                                                    )
                                                                    .toString() ==
                                                                "Fa"
                                                            ? Get.find<
                                                                    FontController
                                                                  >()
                                                                  .currentFont
                                                            : null,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.right,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  KText(
                                                    text: languagesController
                                                        .tr("STATUS"),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      color:
                                                          data.status
                                                                  .toString() ==
                                                              "pending"
                                                          ? Colors.grey
                                                          : data.status
                                                                    .toString() ==
                                                                "completed"
                                                          ? Colors.green
                                                          : Color(
                                                              0xffFF4842,
                                                            ).withOpacity(0.4),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 5,
                                                            vertical: 2,
                                                          ),
                                                      child: KText(
                                                        text:
                                                            data.status
                                                                    .toString() ==
                                                                "pending"
                                                            ? languagesController
                                                                  .tr("PENDING")
                                                            : data.status
                                                                      .toString() ==
                                                                  "completed"
                                                            ? languagesController
                                                                  .tr(
                                                                    "COMPLETED",
                                                                  )
                                                            : languagesController
                                                                  .tr(
                                                                    "ROLLBACKED",
                                                                  ),
                                                        color:
                                                            data.status
                                                                    .toString() ==
                                                                "pending"
                                                            ? Colors.white
                                                            : data.status
                                                                      .toString() ==
                                                                  "completed"
                                                            ? Colors.white
                                                            : Colors.white,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  KText(
                                                    text: languagesController
                                                        .tr("DATE"),
                                                  ),
                                                  DKText(
                                                    text:
                                                        DateFormat(
                                                          'dd MMM yyyy',
                                                        ).format(
                                                          DateTime.parse(
                                                            data.createdAt
                                                                .toString(),
                                                          ),
                                                        ),
                                                    fontSize: 13,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
