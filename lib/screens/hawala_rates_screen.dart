import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/dashboard_controller.dart';
import '../controllers/hawala_currency_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../utils/colors.dart';
import '../widgets/bottomsheet.dart';

class HawalaCurrencyScreen extends StatefulWidget {
  const HawalaCurrencyScreen({super.key});

  @override
  State<HawalaCurrencyScreen> createState() => _HawalaCurrencyScreenState();
}

class _HawalaCurrencyScreenState extends State<HawalaCurrencyScreen> {
  final box = GetStorage();

  HawalaCurrencyController hawalacurrencycontroller = Get.put(
    HawalaCurrencyController(),
  );

  LanguagesController languagesController = Get.put(LanguagesController());

  final Mypagecontroller mypagecontroller = Get.find();

  final Color headerBg = AppColors.primaryColor;
  final Color headerText = Colors.white;
  final Color stripeLight = Colors.white;
  final Color stripeTint = AppColors.primaryColor.withOpacity(0.04);
  final Color hoverTint = AppColors.primaryColor.withOpacity(0.08);
  final Color selectTint = AppColors.primaryColor.withOpacity(0.15);
  final Color borderColor = AppColors.primaryColor;
  @override
  void initState() {
    super.initState();
    hawalacurrencycontroller.fetchcurrency();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryColor,
        statusBarIconBrightness: Brightness.light, // For Android
        statusBarBrightness: Brightness.light, // For iOS
      ),
    );
  }

  final dashboardController = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                        () => Text(
                          languagesController.tr("HAWALA_RATES"),
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
              child: Obx(
                () => hawalacurrencycontroller.isLoading.value
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                            gradient: LinearGradient(
                              colors: [Colors.white, Colors.grey.shade100],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: DataTableTheme(
                                data: DataTableThemeData(
                                  headingRowColor: MaterialStateProperty.all(
                                    Colors.blueGrey.shade800,
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.5,
                                  ),
                                  dataTextStyle: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  dividerThickness: 0.5,
                                  horizontalMargin: 16,
                                  columnSpacing: 16,
                                ),
                                child: DataTable(
                                  showCheckboxColumn: false,
                                  headingRowHeight: 45,
                                  dataRowMinHeight: 42,
                                  dataRowMaxHeight: 52,
                                  border: TableBorder.symmetric(
                                    inside: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 0.5,
                                    ),
                                  ),
                                  columns: [
                                    DataColumn(
                                      label: Center(
                                        child: Text(
                                          languagesController.tr("AMOUNT"),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Center(
                                        child: Text(
                                          languagesController.tr("FROM"),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Center(
                                        child: Text(
                                          languagesController.tr("TO"),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Center(
                                        child: Text(
                                          languagesController.tr("BUY"),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Center(
                                        child: Text(
                                          languagesController.tr("SELL"),
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: List.generate(
                                    hawalacurrencycontroller
                                            .allcurrencylist
                                            .value
                                            .data
                                            ?.rates
                                            ?.length ??
                                        0,
                                    (i) {
                                      final data = hawalacurrencycontroller
                                          .allcurrencylist
                                          .value
                                          .data!
                                          .rates![i];

                                      return DataRow(
                                        color:
                                            MaterialStateProperty.resolveWith<
                                              Color?
                                            >((states) {
                                              if (states.contains(
                                                MaterialState.hovered,
                                              )) {
                                                return Colors.blue.shade50;
                                              }
                                              return i.isEven
                                                  ? Colors.grey.shade100
                                                  : Colors.white;
                                            }),
                                        onSelectChanged: (_) {},
                                        cells: [
                                          DataCell(
                                            Center(
                                              child: Text(
                                                data.amount.toString(),
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                data.fromCurrency?.name ?? "-",
                                                style: TextStyle(
                                                  color:
                                                      Colors.blueGrey.shade700,
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                data.toCurrency?.name ?? "-",
                                                style: TextStyle(
                                                  color:
                                                      Colors.blueGrey.shade700,
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                "${data.buyRate ?? '-'} ${data.toCurrency?.symbol ?? ''}",
                                                style: TextStyle(
                                                  color: Colors.green.shade700,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                "${data.sellRate ?? '-'} ${data.toCurrency?.symbol ?? ''}",
                                                style: TextStyle(
                                                  color: Colors.red.shade700,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
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
