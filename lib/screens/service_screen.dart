import 'package:jahanpay/controllers/currency_controller.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jahanpay/controllers/drawer_controller.dart';
import 'package:jahanpay/screens/social_bundles.dart';
import 'package:jahanpay/widgets/bottomsheet.dart';

import 'package:jahanpay/controllers/country_list_controller.dart';
import 'package:jahanpay/controllers/custom_history_controller.dart';

import 'package:jahanpay/global_controller/languages_controller.dart';
import 'package:jahanpay/global_controller/page_controller.dart';

import 'package:jahanpay/utils/colors.dart';

import '../controllers/bundle_controller.dart';
import '../controllers/categories_controller.dart';
import '../controllers/categories_list_controller.dart';
import '../controllers/company_controller.dart';

import '../controllers/dashboard_controller.dart';
import '../controllers/service_controller.dart';
import 'recharge_screen.dart';

class ServiceScreen extends StatefulWidget {
  ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final customhistoryController = Get.find<CustomHistoryController>();

  final countryListController = Get.find<CountryListController>();
  LanguagesController languagesController = Get.put(LanguagesController());
  CurrencyController currencyController = Get.put(CurrencyController());

  final dashboardController = Get.find<DashboardController>();
  final serviceController = Get.find<ServiceController>();
  final box = GetStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currencyController.fetchCurrency();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryColor,
        statusBarIconBrightness: Brightness.light, // For Android
        statusBarBrightness: Brightness.light, // For iOS
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  MyDrawerController drawerController = Get.put(MyDrawerController());
  final bundleController = Get.find<BundleController>();
  final categorisListController = Get.find<CategorisListController>();

  @override
  Widget build(BuildContext context) {
    final Mypagecontroller mypagecontroller = Get.find();
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    // ignore: deprecated_member_use
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
                        () => Text(
                          languagesController.tr("SERVICES"),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.045,
                            color: Colors.white,
                          ),
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
            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 15),
                children: [
                  Container(
                    width: screenWidth,
                    // color: Colors.cyan,
                    child: Obx(
                      () => categorisListController.isLoading.value == false
                          ? ListView.builder(
                              padding: EdgeInsets.all(0.0),
                              shrinkWrap: true,
                              itemCount:
                                  categorisListController.combinedList.length,
                              itemBuilder: (context, index) {
                                final data =
                                    categorisListController.combinedList[index];
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data["countryName"],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Container(
                                      height: 125,
                                      width: screenWidth,
                                      // color: Colors.red,
                                      child: ListView.builder(
                                        physics: BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: data["categories"].length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              serviceController.reserveDigit
                                                  .clear();
                                              bundleController.finalList
                                                  .clear();

                                              box.write(
                                                "maxlength",
                                                data["phoneNumberLength"],
                                              );

                                              box.write("validity_type", "");
                                              box.write("company_id", "");
                                              box.write("search_tag", "");
                                              box.write(
                                                "country_id",
                                                data["countryId"],
                                              );
                                              box.write(
                                                "countryName",
                                                data["countryName"],
                                              );

                                              box.write(
                                                "service_category_id",
                                                data["categories"][index]["categoryId"],
                                              );

                                              bundleController.initialpage = 1;
                                              // print(data["countryId"]);
                                              // print(data["phoneNumberLength"]);
                                              // print(data["categories"][index]
                                              //     ["categoryId"]);
                                              bundleController
                                                  .fetchallbundles();

                                              mypagecontroller.changePage(
                                                RechargeScreen(),
                                                isMainPage: false,
                                              );
                                            },
                                            child: Card(
                                              child: Container(
                                                width: 175,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      spreadRadius: 2,
                                                      blurRadius: 2,
                                                      offset: Offset(0, 0),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 30,
                                                      backgroundColor:
                                                          Colors.white,
                                                      backgroundImage:
                                                          CachedNetworkImageProvider(
                                                            data["countryImage"]
                                                                .toString(),
                                                          ),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      data["categories"][index]["categoryName"],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                  ],
                                );
                              },
                            )
                          : Center(child: CircularProgressIndicator()),
                    ),
                  ),

                  // Display Social Service Categories without Country
                  Obx(
                    () => categorisListController.isLoading.value == false
                        ? Column(
                            children: categorisListController
                                .allcategorieslist
                                .value!
                                .data!
                                .servicecategories!
                                .where((category) => category.type == "social")
                                .map((category) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        category.categoryName.toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      GridView.builder(
                                        padding: EdgeInsets.all(0.0),
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              crossAxisSpacing: 3.0,
                                              mainAxisSpacing: 3.0,
                                              childAspectRatio: 0.9,
                                            ),
                                        itemCount:
                                            category.services?.length ?? 0,
                                        itemBuilder: (context, serviceIndex) {
                                          final service =
                                              category.services![serviceIndex];
                                          return GestureDetector(
                                            onTap: () {
                                              bundleController.finalList
                                                  .clear();
                                              box.write("validity_type", "");
                                              box.write(
                                                "company_id",
                                                service.companyId.toString(),
                                              );
                                              box.write("search_tag", "");
                                              box.write(
                                                "country_id",
                                                service.company!.countryId
                                                    .toString(),
                                              );
                                              box.write(
                                                "service_category_id",
                                                category.id.toString(),
                                              );
                                              bundleController.initialpage = 1;

                                              mypagecontroller.changePage(
                                                SocialBundles(),
                                                isMainPage: false,
                                              );
                                            },
                                            child: Card(
                                              color: Colors.white,
                                              child: Container(
                                                width: 152,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      spreadRadius: 2,
                                                      blurRadius: 2,
                                                      offset: Offset(0, 0),
                                                    ),
                                                  ],
                                                ),
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 30,
                                                        backgroundColor:
                                                            Colors.white,
                                                        backgroundImage:
                                                            CachedNetworkImageProvider(
                                                              service
                                                                  .company!
                                                                  .companyLogo
                                                                  .toString(),
                                                            ),
                                                      ),
                                                      SizedBox(height: 8),
                                                      Text(
                                                        service
                                                            .company!
                                                            .companyName
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                })
                                .toList(),
                          )
                        : SizedBox(),
                  ),

                  SizedBox(height: 70),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
