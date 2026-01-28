import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:jahanpay/widgets/custom_text.dart';
import 'package:jahanpay/widgets/default_button1.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jahanpay/controllers/bundle_controller.dart';
import 'package:jahanpay/controllers/confirm_pin_controller.dart';
import 'package:jahanpay/controllers/country_list_controller.dart';
import 'package:jahanpay/controllers/dashboard_controller.dart';
import 'package:jahanpay/controllers/drawer_controller.dart';
import 'package:jahanpay/global_controller/languages_controller.dart';
import 'package:jahanpay/screens/credit_transfer.dart';
import 'package:jahanpay/widgets/bottomsheet.dart';
import 'package:jahanpay/widgets/drawer.dart';
import '../controllers/categories_list_controller.dart';
import '../controllers/company_controller.dart';
import '../controllers/conversation_controller.dart';
import '../controllers/custom_recharge_controller.dart';
import '../controllers/history_controller.dart';
import '../controllers/slider_controller.dart';
import '../global_controller/balance_controller.dart';
import '../global_controller/page_controller.dart';
import '../screens/order_details_screen.dart';
import '../screens/service_screen.dart';
import '../utils/colors.dart';

class Homepages extends StatefulWidget {
  Homepages({super.key});

  @override
  State<Homepages> createState() => _HomepagesState();
}

class _HomepagesState extends State<Homepages> {
  List serviceimages = [
    "assets/images/cat1.png",
    "assets/images/cat2.png",
    "assets/images/cat3.png",
    "assets/images/cat4.png",
  ];

  final dashboardController = Get.find<DashboardController>();

  final categorisListController = Get.find<CategorisListController>();

  final box = GetStorage();

  final sliderController = Get.find<SliderController>();

  final confirmPinController = Get.find<ConfirmPinController>();

  final bundleController = Get.find<BundleController>();

  LanguagesController languagesController = Get.put(LanguagesController());
  MyDrawerController drawerController = Get.put(MyDrawerController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  CountryListController countrylistController = Get.put(
    CountryListController(),
  );

  final historyController = Get.find<HistoryController>();

  int currentIndex = 0;
  int selectedIndex = 0;
  RxString title = "Balance".obs;
  RxString balance = "".obs;

  // var items = <Map<String, String>>[].obs;
  List<Map<String, String>> get items {
    return [
      {'name': languagesController.tr("BALANCE")},
      {'name': languagesController.tr("DEBIT")},
      {'name': languagesController.tr("PROFIT")},
      {'name': languagesController.tr("SALE")},
      {'name': languagesController.tr("COMISSION")},
    ];
  }

  final ScrollController scrollController = ScrollController();
  Future<void> refresh() async {
    final int totalPages =
        historyController.allorderlist.value.payload?.pagination!.totalPages ??
        0;
    final int currentPage = historyController.initialpage;

    // Prevent loading more pages if we've reached the last page
    if (currentPage >= totalPages) {
      print(
        "End..........................................End.....................",
      );
      return;
    }

    // Check if the scroll position is at the bottom
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      historyController.initialpage++;

      // Prevent fetching if the next page exceeds total pages
      if (historyController.initialpage <= totalPages) {
        print("Load More...................");
        historyController.fetchHistory();
      } else {
        historyController.initialpage =
            totalPages; // Reset to the last valid page
        print("Already on the last page");
      }
    }
  }

  final RxString titleKey = "BALANCE".obs;
  UserBalanceController userBalanceController = Get.put(
    UserBalanceController(),
  );

  @override
  void initState() {
    super.initState();

    _checkforUpdate();
    historyController.finalList.clear();

    historyController.initialpage = 1;
    historyController.fetchHistory();
    scrollController.addListener(refresh);
    companyController.fetchCompany();
    countrylistController.fetchCountryData();
    dashboardController.fetchDashboardData();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryColor,
        statusBarIconBrightness: Brightness.light, // For Android
        statusBarBrightness: Brightness.light, // For iOS
      ),
    );
  }

  Future<void> _checkforUpdate() async {
    print("checking");
    await InAppUpdate.checkForUpdate()
        .then((info) {
          setState(() {
            if (info.updateAvailability == UpdateAvailability.updateAvailable) {
              print("update available");
              _update();
            }
          });
        })
        .catchError((error) {
          print(error.toString());
        });
  }

  void _update() async {
    print("Updating");
    await InAppUpdate.startFlexibleUpdate();
    InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((error) {
      print(error.toString());
    });
  }

  final companyController = Get.find<CompanyController>();
  ConversationController conversationController = Get.put(
    ConversationController(),
  );

  @override
  Widget build(BuildContext context) {
    // conversationController.resetConversion();
    // customRechargeController.amountController.clear();
    // confirmPinController.numberController.clear();
    final Mypagecontroller mypagecontroller = Get.find();

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
                          SizedBox(width: 10),
                          Obx(
                            () => dashboardController.isLoading.value == false
                                ? Column(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          KText(
                                            text: dashboardController
                                                .alldashboardData
                                                .value
                                                .data!
                                                .userInfo!
                                                .resellerName
                                                .toString(),
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),

                                          // only for reseller...................
                                          Visibility(
                                            visible:
                                                dashboardController
                                                        .alldashboardData
                                                        .value
                                                        .data
                                                        ?.resellerGroup !=
                                                    null &&
                                                dashboardController
                                                        .alldashboardData
                                                        .value
                                                        .data!
                                                        .resellerGroup !=
                                                    "null",
                                            child: Text(
                                              dashboardController
                                                      .alldashboardData
                                                      .value
                                                      .data
                                                      ?.resellerGroup ??
                                                  '',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : SizedBox(),
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
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(0.0),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Obx(() {
                          if (dashboardController.isLoading.value) {
                            return SizedBox(
                              height: 130,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final sliderList =
                              dashboardController
                                  .alldashboardData
                                  .value
                                  .data
                                  ?.advertisementSliders ??
                              [];

                          if (sliderList.isEmpty) {
                            return SizedBox(
                              height: 130,
                              child: Center(
                                child: Text("هیچ تبلیغی موجود نیست"),
                              ),
                            );
                          }

                          return CarouselSlider.builder(
                            itemCount: sliderList.length,
                            itemBuilder: (context, index, realIdx) {
                              final item = sliderList[index];
                              final imageUrl = item.adSliderImageUrl;

                              final ImageProvider imageProvider =
                                  (imageUrl != null && imageUrl.isNotEmpty)
                                  ? NetworkImage(imageUrl)
                                  : AssetImage("assets/images/demoslider.png")
                                        as ImageProvider;

                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                // child: Align(
                                //   alignment: Alignment.bottomLeft,
                                //   child: Container(
                                //     width: double.infinity,
                                //     padding:
                                //         EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                //     decoration: BoxDecoration(
                                //       color: Colors.black.withOpacity(0.5),
                                //       borderRadius: BorderRadius.only(
                                //         bottomLeft: Radius.circular(10),
                                //         bottomRight: Radius.circular(10),
                                //       ),
                                //     ),
                                //     child: Text(
                                //       item.advertisementTitle ?? '',
                                //       style: TextStyle(
                                //         color: Colors.white,
                                //         fontSize: 14,
                                //         fontWeight: FontWeight.w500,
                                //       ),
                                //       maxLines: 1,
                                //       overflow: TextOverflow.ellipsis,
                                //     ),
                                //   ),
                                // ),
                              );
                            },
                            options: CarouselOptions(
                              height: 130,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 4),
                              enlargeCenterPage: true,
                              viewportFraction: 0.87,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          height: 130,
                          width: screenWidth,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              12,
                            ), // optional, makes it modern
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(
                                  0.09,
                                ), // light shadow
                                spreadRadius: 8,
                                blurRadius: 8,
                                offset: Offset(0, 4), // shadow direction (x,y)
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    // color: Colors.red,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Obx(
                                              () =>
                                                  dashboardController
                                                          .isLoading
                                                          .value ==
                                                      false
                                                  ? Text(
                                                      userBalanceController
                                                          .balance
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color:
                                                            userBalanceController
                                                                        .selectedIndex ==
                                                                    0 ||
                                                                userBalanceController
                                                                        .selectedIndex ==
                                                                    2
                                                            ? Colors.green
                                                            : userBalanceController
                                                                      .selectedIndex ==
                                                                  1
                                                            ? Colors.red
                                                            : Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  : Text(
                                                      "",
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color:
                                                            userBalanceController
                                                                        .selectedIndex ==
                                                                    0 ||
                                                                userBalanceController
                                                                        .selectedIndex ==
                                                                    2
                                                            ? Colors.green
                                                            : userBalanceController
                                                                      .selectedIndex ==
                                                                  1
                                                            ? Colors.red
                                                            : Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                            ),
                                            SizedBox(width: 10),
                                            GestureDetector(
                                              onTap: () {
                                                dashboardController
                                                    .fetchDashboardData();
                                              },
                                              child: Text(
                                                box.read("currency_code"),
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color:
                                                      userBalanceController
                                                                  .selectedIndex ==
                                                              0 ||
                                                          userBalanceController
                                                                  .selectedIndex ==
                                                              2
                                                      ? Colors.green
                                                      : userBalanceController
                                                                .selectedIndex ==
                                                            1
                                                      ? Colors.red
                                                      : Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Visibility(
                                          visible:
                                              userBalanceController
                                                      .selectedIndex ==
                                                  2 ||
                                              userBalanceController
                                                      .selectedIndex ==
                                                  3,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Obx(
                                                () =>
                                                    dashboardController
                                                            .isLoading
                                                            .value ==
                                                        false
                                                    ? Text(
                                                        userBalanceController
                                                            .todayvalue
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                              userBalanceController
                                                                          .selectedIndex ==
                                                                      0 ||
                                                                  userBalanceController
                                                                          .selectedIndex ==
                                                                      2
                                                              ? Colors.green
                                                              : userBalanceController
                                                                        .selectedIndex ==
                                                                    1
                                                              ? Colors.red
                                                              : Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )
                                                    : Text(
                                                        "",
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          color:
                                                              userBalanceController
                                                                          .selectedIndex ==
                                                                      0 ||
                                                                  userBalanceController
                                                                          .selectedIndex ==
                                                                      2
                                                              ? Colors.green
                                                              : userBalanceController
                                                                        .selectedIndex ==
                                                                    1
                                                              ? Colors.red
                                                              : Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                              ),
                                              SizedBox(width: 10),
                                              Row(
                                                children: [
                                                  Text(
                                                    box.read("currency_code"),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          userBalanceController
                                                                      .selectedIndex ==
                                                                  0 ||
                                                              userBalanceController
                                                                      .selectedIndex ==
                                                                  2
                                                          ? Colors.green
                                                          : userBalanceController
                                                                    .selectedIndex ==
                                                                1
                                                          ? Colors.red
                                                          : Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    // color: Colors.green,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: List.generate(5, (index) {
                                        final isSelected =
                                            selectedIndex == index;
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedIndex = index;
                                              if (index == 0) {
                                                titleKey.value = "BALANCE";
                                                userBalanceController
                                                    .balance
                                                    .value = dashboardController
                                                    .alldashboardData
                                                    .value
                                                    .data!
                                                    .balance
                                                    .toString();
                                                userBalanceController
                                                        .selectedIndex
                                                        .value =
                                                    0;
                                                print(
                                                  userBalanceController
                                                      .selectedIndex
                                                      .toString(),
                                                );
                                              } else if (index == 1) {
                                                titleKey.value = "DEBIT";
                                                userBalanceController
                                                    .balance
                                                    .value = dashboardController
                                                    .alldashboardData
                                                    .value
                                                    .data!
                                                    .loanBalance
                                                    .toString();

                                                userBalanceController
                                                        .selectedIndex
                                                        .value =
                                                    1;
                                                print(
                                                  userBalanceController
                                                      .selectedIndex
                                                      .toString(),
                                                );
                                              } else if (index == 2) {
                                                titleKey.value = "PROFIT";
                                                userBalanceController
                                                    .balance
                                                    .value = dashboardController
                                                    .alldashboardData
                                                    .value
                                                    .data!
                                                    .totalRevenue
                                                    .toString();
                                                userBalanceController
                                                    .todayvalue
                                                    .value = dashboardController
                                                    .alldashboardData
                                                    .value
                                                    .data!
                                                    .todayProfit
                                                    .toString();
                                                userBalanceController
                                                        .selectedIndex
                                                        .value =
                                                    2;
                                              } else if (index == 3) {
                                                titleKey.value = "SALE";
                                                userBalanceController
                                                    .balance
                                                    .value = dashboardController
                                                    .alldashboardData
                                                    .value
                                                    .data!
                                                    .totalSoldAmount
                                                    .toString();
                                                userBalanceController
                                                    .todayvalue
                                                    .value = dashboardController
                                                    .alldashboardData
                                                    .value
                                                    .data!
                                                    .todaySale
                                                    .toString();
                                                userBalanceController
                                                        .selectedIndex
                                                        .value =
                                                    3;
                                              } else if (index == 4) {
                                                title.value = titleKey.value =
                                                    "COMMISSION";
                                                userBalanceController
                                                    .balance
                                                    .value = dashboardController
                                                    .alldashboardData
                                                    .value
                                                    .data!
                                                    .userInfo!
                                                    .totalearning
                                                    .toString();
                                                userBalanceController
                                                        .selectedIndex
                                                        .value =
                                                    4;
                                              } else {
                                                title.value = "Unknown";
                                              }
                                              print(title);
                                            });
                                          },
                                          child: Obx(() {
                                            final item = items[index];
                                            return Container(
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? AppColors.primaryColor
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    textAlign: TextAlign.center,
                                                    item['name']!,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: isSelected
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                        );
                                      }),
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
                        child: GestureDetector(
                          onTap: () {
                            mypagecontroller.openSubPage(ServiceScreen());
                            categorisListController.fetchcategories();
                          },
                          child: Container(
                            height: 50,
                            width: screenWidth,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.primarycolor2,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(
                                    "assets/icons/menu.png",
                                    color: Colors.white,
                                    height: 22,
                                  ),
                                  KText(
                                    text: languagesController.tr(
                                      "VIEW_PRODUCTS",
                                    ),
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: DefaultButton1(
                          height: 45,
                          width: screenWidth,
                          buttonName: languagesController.tr("CREDIT_TRANSFER"),
                          onpressed: () {
                            // if (countrylistController
                            //     .finalCountryList
                            //     .isNotEmpty) {
                            //   // Find the country where the name is "Afghanistan"
                            //   var afghanistan = countrylistController
                            //       .finalCountryList
                            //       .firstWhere(
                            //         (country) =>
                            //             country['country_name'] ==
                            //             "Afghanistan",
                            //         orElse: () =>
                            //             null, // Return null if not found
                            //       );

                            //   if (afghanistan != null) {
                            //     print(
                            //       "The ID for Afghanistan is: ${afghanistan['id']}",
                            //     );
                            //     box.write("country_id", "${afghanistan['id']}");
                            //     box.write("maxlength", "10");
                            //   } else {
                            //     print("Afghanistan not found in the list");
                            //   }
                            // } else {
                            //   print("Country list is empty.");
                            // }

                            mypagecontroller.openSubPage(CreditTransfer());
                          },
                        ),
                      ),
                      SizedBox(height: 8),
                      Obx(
                        () => historyController.isLoading.value == true
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(),
                      ),
                      Obx(
                        () => historyController.isLoading.value == false
                            ? Container(
                                child:
                                    historyController
                                        .allorderlist
                                        .value
                                        .data!
                                        .orders
                                        .isNotEmpty
                                    ? SizedBox()
                                    : Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/icons/empty.png",
                                              height: 80,
                                            ),
                                            Text("No Data found"),
                                          ],
                                        ),
                                      ),
                              )
                            : SizedBox(),
                      ),
                      Container(
                        height: 400,
                        width: screenWidth,
                        child: Obx(
                          () =>
                              historyController.isLoading.value == false &&
                                  historyController.finalList.isNotEmpty
                              ? RefreshIndicator(
                                  onRefresh: refresh,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: ListView.separated(
                                      padding: EdgeInsets.all(0.0),
                                      shrinkWrap: false,
                                      physics: AlwaysScrollableScrollPhysics(),
                                      controller: scrollController,
                                      separatorBuilder: (context, index) {
                                        return SizedBox(height: 5);
                                      },
                                      itemCount:
                                          historyController.finalList.length,
                                      itemBuilder: (context, index) {
                                        final data =
                                            historyController.finalList[index];
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    OrderDetailsScreen(
                                                      createDate: data.createdAt
                                                          .toString(),
                                                      status: data.status
                                                          .toString(),
                                                      rejectReason: data
                                                          .rejectReason
                                                          .toString(),
                                                      companyName: data
                                                          .bundle!
                                                          .service!
                                                          .company!
                                                          .companyName
                                                          .toString(),
                                                      bundleTitle: data
                                                          .bundle!
                                                          .bundleTitle!
                                                          .toString(),
                                                      rechargebleAccount: data
                                                          .rechargebleAccount!
                                                          .toString(),
                                                      validityType:
                                                          data
                                                              .bundle
                                                              ?.validityType
                                                              ?.toString() ??
                                                          "",
                                                      sellingPrice: data
                                                          .bundle!
                                                          .sellingPrice
                                                          .toString(),
                                                      orderID: data.id!
                                                          .toString(),
                                                      resellerName:
                                                          dashboardController
                                                              .alldashboardData
                                                              .value
                                                              .data!
                                                              .userInfo!
                                                              .contactName
                                                              .toString(),
                                                      resellerPhone:
                                                          dashboardController
                                                              .alldashboardData
                                                              .value
                                                              .data!
                                                              .userInfo!
                                                              .phone
                                                              .toString(),
                                                      companyLogo: data
                                                          .bundle!
                                                          .service!
                                                          .company!
                                                          .companyLogo
                                                          .toString(),
                                                    ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            height: 60,
                                            width: screenWidth,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 1,
                                                color: Colors.grey.shade200,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color:
                                                  AppColors.listbuilderboxColor,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                5.0,
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 40,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image:
                                                            CachedNetworkImageProvider(
                                                              data
                                                                  .bundle!
                                                                  .service!
                                                                  .company!
                                                                  .companyLogo
                                                                  .toString(),
                                                            ),
                                                      ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            left: 5,
                                                          ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Flexible(
                                                            child: Text(
                                                              data
                                                                  .bundle!
                                                                  .bundleTitle
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            data.rechargebleAccount
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          NumberFormat.currency(
                                                            locale: 'en_US',
                                                            symbol: '',
                                                            decimalDigits: 2,
                                                          ).format(
                                                            double.parse(
                                                              data
                                                                  .bundle!
                                                                  .sellingPrice
                                                                  .toString(),
                                                            ),
                                                          ),
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        SizedBox(width: 2),
                                                        Text(
                                                          " " +
                                                              box.read(
                                                                "currency_code",
                                                              ),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 11,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            data.status
                                                                        .toString() ==
                                                                    "0"
                                                                ? languagesController
                                                                      .tr(
                                                                        "PENDING",
                                                                      )
                                                                : data.status
                                                                          .toString() ==
                                                                      "1"
                                                                ? languagesController.tr(
                                                                    "CONFIRMED",
                                                                  )
                                                                : languagesController
                                                                      .tr(
                                                                        "REJECTED",
                                                                      ),
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              : historyController.finalList.isEmpty
                              ? SizedBox()
                              : RefreshIndicator(
                                  onRefresh: refresh,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: ListView.separated(
                                      padding: EdgeInsets.all(0.0),
                                      shrinkWrap: false,
                                      physics: AlwaysScrollableScrollPhysics(),
                                      controller: scrollController,
                                      separatorBuilder: (context, index) {
                                        return SizedBox(height: 5);
                                      },
                                      itemCount:
                                          historyController.finalList.length,
                                      itemBuilder: (context, index) {
                                        final data =
                                            historyController.finalList[index];
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    OrderDetailsScreen(
                                                      createDate: data.createdAt
                                                          .toString(),
                                                      status: data.status
                                                          .toString(),
                                                      rejectReason: data
                                                          .rejectReason
                                                          .toString(),
                                                      companyName: data
                                                          .bundle!
                                                          .service!
                                                          .company!
                                                          .companyName
                                                          .toString(),
                                                      bundleTitle: data
                                                          .bundle!
                                                          .bundleTitle!
                                                          .toString(),
                                                      rechargebleAccount: data
                                                          .rechargebleAccount!
                                                          .toString(),
                                                      validityType:
                                                          data
                                                              .bundle
                                                              ?.validityType
                                                              ?.toString() ??
                                                          "",
                                                      sellingPrice: data
                                                          .bundle!
                                                          .sellingPrice
                                                          .toString(),
                                                      orderID: data.id!
                                                          .toString(),
                                                      resellerName:
                                                          dashboardController
                                                              .alldashboardData
                                                              .value
                                                              .data!
                                                              .userInfo!
                                                              .contactName
                                                              .toString(),
                                                      resellerPhone:
                                                          dashboardController
                                                              .alldashboardData
                                                              .value
                                                              .data!
                                                              .userInfo!
                                                              .phone
                                                              .toString(),
                                                      companyLogo: data
                                                          .bundle!
                                                          .service!
                                                          .company!
                                                          .companyLogo
                                                          .toString(),
                                                    ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            height: 60,
                                            width: screenWidth,
                                            decoration: BoxDecoration(
                                              // border: Border.all(
                                              //   width: 1,
                                              //   color: Colors.grey,
                                              // ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color:
                                                  AppColors.listbuilderboxColor,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                5.0,
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 40,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image:
                                                            CachedNetworkImageProvider(
                                                              data
                                                                  .bundle!
                                                                  .service!
                                                                  .company!
                                                                  .companyLogo
                                                                  .toString(),
                                                            ),
                                                      ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            left: 5,
                                                          ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Flexible(
                                                            child: Text(
                                                              data
                                                                  .bundle!
                                                                  .bundleTitle
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            data.rechargebleAccount
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          NumberFormat.currency(
                                                            locale: 'en_US',
                                                            symbol: '',
                                                            decimalDigits: 2,
                                                          ).format(
                                                            double.parse(
                                                              data
                                                                  .bundle!
                                                                  .sellingPrice
                                                                  .toString(),
                                                            ),
                                                          ),
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        SizedBox(width: 2),
                                                        Text(
                                                          " " +
                                                              box.read(
                                                                "currency_code",
                                                              ),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 11,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          // Icon(
                                                          //   Icons.check,
                                                          //   color: Colors.green,
                                                          //   size: 14,
                                                          // ),
                                                          Text(
                                                            data.status
                                                                        .toString() ==
                                                                    "0"
                                                                ? languagesController
                                                                      .tr(
                                                                        "PENDING",
                                                                      )
                                                                : data.status
                                                                          .toString() ==
                                                                      "1"
                                                                ? languagesController.tr(
                                                                    "CONFIRMED",
                                                                  )
                                                                : languagesController
                                                                      .tr(
                                                                        "REJECTED",
                                                                      ),
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          // Text(
                                                          //   "2 days ago",
                                                          //   style: TextStyle(
                                                          //     color: Colors.green,
                                                          //     fontSize: 10,
                                                          //     fontWeight:
                                                          //         FontWeight.w600,
                                                          //   ),
                                                          // ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 80),
                    ],
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
