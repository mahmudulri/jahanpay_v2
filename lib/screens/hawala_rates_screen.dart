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
                () => hawalacurrencycontroller.isLoading.value == false
                    ? SingleChildScrollView(
                        // vertical scroll only, as you had
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: borderColor, width: 1),
                          ),
                          margin: EdgeInsets.all(8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: DataTableTheme(
                              data: DataTableThemeData(
                                headingRowColor: MaterialStateProperty.all(
                                  headerBg,
                                ),
                                headingTextStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  letterSpacing: 0.3,
                                ),
                                dataTextStyle: TextStyle(
                                  fontSize: 12,
                                  height: 1.2,
                                ),
                                dividerThickness: 1,
                                horizontalMargin: 12,
                                columnSpacing: 12,
                              ),
                              child: DataTable(
                                showCheckboxColumn: false,
                                headingRowHeight: 40,
                                dataRowMinHeight: 36,
                                dataRowMaxHeight: 44,
                                border: TableBorder(
                                  horizontalInside: BorderSide(
                                    color: borderColor.withOpacity(0.25),
                                    width: 1,
                                  ),
                                  verticalInside: BorderSide(
                                    color: borderColor.withOpacity(0.15),
                                    width: 1,
                                  ),
                                  top: BorderSide(color: borderColor, width: 1),
                                  bottom: BorderSide(
                                    color: borderColor,
                                    width: 1,
                                  ),
                                  left: BorderSide(
                                    color: borderColor,
                                    width: 1,
                                  ),
                                  right: BorderSide(
                                    color: borderColor,
                                    width: 1,
                                  ),
                                ),
                                columns: [
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          languagesController.tr("AMOUNT"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: headerText,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          languagesController.tr("FROM"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: headerText,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          languagesController.tr("TO"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: headerText,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          languagesController.tr("BUY"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: headerText,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          languagesController.tr("SELL"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: headerText,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: List<DataRow>.generate(
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
                                    final isEven = i.isEven;

                                    return DataRow(
                                      color:
                                          MaterialStateProperty.resolveWith<
                                            Color?
                                          >((states) {
                                            if (states.contains(
                                              MaterialState.selected,
                                            )) {
                                              return selectTint;
                                            }
                                            if (states.contains(
                                              MaterialState.hovered,
                                            )) {
                                              return hoverTint;
                                            }
                                            return isEven
                                                ? stripeLight
                                                : stripeTint;
                                          }),
                                      // If you don't need row selection visuals, you can remove this line.
                                      onSelectChanged: (_) {},
                                      cells: [
                                        DataCell(
                                          Center(
                                            child: Text(
                                              data.amount.toString(),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Center(
                                            child: Text(
                                              data.fromCurrency?.name ?? "-",
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Center(
                                            child: Text(
                                              data.toCurrency?.name ?? "-",
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Center(
                                            child: Text(
                                              "${data.buyRate ?? '-'} ${data.toCurrency?.symbol ?? ''}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Center(
                                            child: Text(
                                              "${data.sellRate ?? '-'} ${data.toCurrency?.symbol ?? ''}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.red,
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
                      )
                    : Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
