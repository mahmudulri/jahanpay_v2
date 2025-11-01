import 'package:dotted_border/dotted_border.dart';
import 'package:jahanpay/global_controller/font_controller.dart';
import 'package:jahanpay/global_controller/languages_controller.dart';
import 'package:jahanpay/utils/colors.dart';
import 'package:jahanpay/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:intl/intl.dart';

import '../global_controller/time_zone_controller.dart';
import '../helpers/capture_image_helper.dart';

import '../helpers/localtime_helper.dart';
import '../helpers/share_image_helper.dart';
import '../widgets/normaltext.dart';

class OrderDetailsScreen extends StatefulWidget {
  OrderDetailsScreen({
    super.key,
    this.createDate,
    this.status,
    this.rejectReason,
    this.companyName,
    this.bundleTitle,
    this.rechargebleAccount,
    this.validityType,
    this.sellingPrice,
    this.buyingPrice,
    this.orderID,
    this.resellerName,
    this.resellerPhone,
    this.companyLogo,
    this.amount,
  });
  String? createDate;
  String? status;
  String? rejectReason;
  String? companyName;
  String? bundleTitle;
  String? rechargebleAccount;
  String? validityType;
  String? sellingPrice;
  String? buyingPrice;
  String? orderID;
  String? resellerName;
  String? resellerPhone;
  String? companyLogo;
  String? amount;
  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final TimeZoneController timeZoneController = Get.put(TimeZoneController());

  LanguagesController languagesController = Get.put(LanguagesController());

  bool showSelling = true; // 246 show korebe default
  bool showBuying = false;

  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[700],
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF2C2C2C), // dark gray
              Color.fromARGB(255, 83, 82, 82), // lighter gray
            ],
          ),
        ),
        height: screenHeight,
        width: screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: RepaintBoundary(
                key: catpureKey,
                child: RepaintBoundary(
                  key: shareKey,
                  child: Container(
                    height: 550,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(height: 5),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                  child: Container(
                                    height: 50,
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Image.asset(
                                          "assets/icons/onlylogo.png",
                                          // color: Colors.red,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                box.read("language").toString() == "Fa"
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "PAY",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            ),
                                          ),
                                          SizedBox(width: 3),
                                          Text(
                                            "JAHAN",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primaryColor,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "JAHAN",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primaryColor,
                                            ),
                                          ),
                                          SizedBox(width: 3),
                                          Text(
                                            "PAY",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),

                                SizedBox(height: 5),

                                Column(
                                  children: [
                                    KText(
                                      text: widget.status.toString() == "0"
                                          ? languagesController.tr("PENDING")
                                          : widget.status.toString() == "1"
                                          ? languagesController.tr("CONFIRMED")
                                          : languagesController.tr("REJECTED"),
                                      fontWeight: FontWeight.w600,
                                      color: widget.status.toString() == "0"
                                          ? Colors.black
                                          : widget.status.toString() == "1"
                                          ? Colors.green
                                          : Colors.red,
                                      fontSize: 15,
                                    ),
                                    SizedBox(height: 2),
                                    Image.asset(
                                      widget.status.toString() == "0"
                                          ? "assets/icons/info-circle.png"
                                          : widget.status.toString() == "1"
                                          ? "assets/icons/confirmed.png"
                                          : "assets/icons/close-circle.png",
                                      height: 40,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Visibility(
                                  visible: widget.status.toString() == "2",
                                  child: Text(
                                    widget.rejectReason.toString(),
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                            color: Color(0xffE8F4FF),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      KText(
                                        text: languagesController.tr(
                                          "COMPANY_NAME",
                                        ),
                                        color: Color(0xff637381),
                                      ),
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                              widget.companyLogo.toString(),
                                            ),
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      KText(
                                        text: languagesController.tr(
                                          "BUNDLE_TITLE",
                                        ),

                                        color: Color(0xff637381),
                                      ),
                                      Text(
                                        widget.bundleTitle.toString(),
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Color(0xff637381),

                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      KText(
                                        text: languagesController.tr(
                                          "VALIDITY",
                                        ),
                                        color: Color(0xff637381),
                                        fontSize: 14,
                                      ),
                                      KText(
                                        text:
                                            widget.validityType.toString() ==
                                                "yearly"
                                            ? languagesController.tr("YEARLY")
                                            : widget.validityType.toString() ==
                                                  "unlimited"
                                            ? languagesController.tr(
                                                "UNLIMITED",
                                              )
                                            : widget.validityType.toString() ==
                                                  "monthly"
                                            ? languagesController.tr("MONTHLY")
                                            : widget.validityType.toString() ==
                                                  "weekly"
                                            ? languagesController.tr("WEEKLY")
                                            : widget.validityType.toString() ==
                                                  "daily"
                                            ? languagesController.tr("DAILY")
                                            : widget.validityType.toString() ==
                                                  "hourly"
                                            ? languagesController.tr("HOURLY")
                                            : widget.validityType.toString() ==
                                                  "nightly"
                                            ? languagesController.tr("NIGHTLY")
                                            : "",
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff637381),
                                        fontSize: 14,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      KText(
                                        text: languagesController.tr(
                                          "ORDER_ID",
                                        ),
                                        color: Color(0xff637381),
                                        fontSize: 14,

                                        fontWeight: FontWeight.w400,
                                      ),
                                      DKText(
                                        text:
                                            "JP#- " + widget.orderID.toString(),
                                        fontSize: 14,
                                        color: Color(0xff637381),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      print(widget.createDate.toString());
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        KText(
                                          text: languagesController.tr("DATE"),
                                          fontSize: 14,
                                          color: Color(0xff637381),
                                          fontWeight: FontWeight.w400,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          convertToDate(
                                            widget.createDate.toString(),
                                          ),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff637381),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      KText(
                                        text: languagesController.tr("TIME"),
                                        fontSize: 14,
                                        color: Color(0xff637381),
                                        fontWeight: FontWeight.w400,
                                      ),
                                      SizedBox(width: 5),

                                      Text(
                                        convertToLocalTime(
                                          widget.createDate.toString(),
                                        ),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff637381),

                                          // or any color you like
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(20),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      KText(
                                        text: languagesController.tr(
                                          "PHONE_NUMBER",
                                        ),
                                        fontSize: 14,
                                        color: Color(0xff637381),
                                        fontWeight: FontWeight.w400,
                                      ),
                                      SizedBox(width: 10),
                                      Flexible(
                                        child: Text(
                                          widget.rechargebleAccount.toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff637381),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        KText(
                                          text: languagesController.tr(
                                            "SENDER",
                                          ),
                                          fontSize: 14,
                                          color: Color(0xff637381),
                                          fontWeight: FontWeight.w400,
                                        ),
                                        SizedBox(width: 10),
                                        Flexible(
                                          child: KText(
                                            text: widget.resellerName
                                                .toString(),
                                            fontSize: 14,
                                            color: Color(0xff637381),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: showSelling,
                                    child: Container(
                                      margin: EdgeInsets.only(top: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          KText(
                                            text: languagesController.tr(
                                              "PRICE",
                                            ),
                                            fontSize: 14,
                                            color: Color(0xff637381),
                                            fontWeight: FontWeight.w400,
                                          ),
                                          Row(
                                            children: [
                                              KText(
                                                text: box.read("currency_code"),
                                                fontSize: 12,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              SizedBox(width: 8),
                                              DKText(
                                                text:
                                                    NumberFormat.currency(
                                                      locale: 'en_US',
                                                      symbol: '',
                                                      decimalDigits: 2,
                                                    ).format(
                                                      double.parse(
                                                        widget.sellingPrice
                                                            .toString(),
                                                      ),
                                                    ),
                                                color: Color(0xff637381),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Visibility(
                                      visible: showBuying,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          KText(
                                            text: languagesController.tr(
                                              "BUYING_PRICE",
                                            ),
                                            fontSize: 14,
                                            color: Color(0xff637381),
                                            fontWeight: FontWeight.w400,
                                          ),
                                          Row(
                                            children: [
                                              KText(
                                                text: box.read("currency_code"),
                                                fontSize: 12,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              SizedBox(width: 8),
                                              DKText(
                                                text:
                                                    NumberFormat.currency(
                                                      locale: 'en_US',
                                                      symbol: '',
                                                      decimalDigits: 2,
                                                    ).format(
                                                      double.parse(
                                                        widget.buyingPrice
                                                            .toString(),
                                                      ),
                                                    ),
                                                color: Color(0xff637381),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
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
                          ),
                        ),
                        // Container(
                        //   margin: EdgeInsets.only(left: 20, right: 20),
                        //   height: 1,
                        //   width: screenWidth,
                        //   color: Colors.green,
                        // ),

                        // SizedBox(height: 5),
                        Container(
                          height: 50,
                          width: screenWidth,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),

                          child: Center(
                            child: Text(
                              "جهان پی ارسال سریع و مطمین",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Iranfontregular",
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
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Container(
                height: 45,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      KText(
                        text: languagesController.tr("SELLING_PRICE"),
                        fontSize: 14,
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showSelling = !showSelling;
                          });
                        },
                        child: Icon(
                          showSelling ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                      ),
                      Spacer(),
                      KText(
                        text: languagesController.tr("BUYING_PRICE"),
                        fontSize: 14,
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showBuying = !showBuying;
                          });
                        },
                        child: Icon(
                          showBuying ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Container(
                decoration: BoxDecoration(
                  // color: Colors.white,
                  // borderRadius: BorderRadius.vertical(
                  //   bottom: Radius.circular(20),
                  // ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 50,
                        width: double.maxFinite,
                        // color: Colors.red,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () async {
                                  capturePng();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Color(0xff2196F3),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: KText(
                                      text: languagesController.tr(
                                        "SAVE_TO_GALLERY",
                                      ),
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () async {
                                  captureImageFromWidgetAsFile(shareKey);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xff2196F3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: KText(
                                      text: languagesController.tr("SHARE"),
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 50,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.shade300,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: KText(
                              text: languagesController.tr("CLOSE"),
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
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
