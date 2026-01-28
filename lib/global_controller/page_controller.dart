import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jahanpay/pages/network.dart';
import 'package:jahanpay/pages/orders.dart';
import 'package:jahanpay/pages/transactions.dart';

import '../pages/homepages.dart';

// class Mypagecontroller extends GetxController {
//   var currentPage = Rx<Widget>(Homepages());
//   int lastSelectedIndex = 0; // Store the last selected bottom menu index

//   final List<Widget> mainPages = [
//     Homepages(),
//     Orders(),
//     Transactions(),
//     Network(),
//   ];

//   Function(int)? updateIndexCallback;

//   void setUpdateIndexCallback(Function(int) callback) {
//     updateIndexCallback = callback;
//   }

//   void changePage(Widget page, {bool isMainPage = true}) {
//     if (isMainPage) {
//       lastSelectedIndex = mainPages
//           .indexWhere((element) => element.runtimeType == page.runtimeType);
//     }
//     currentPage.value = page;

//     if (updateIndexCallback != null) {
//       if (isMainPage) {
//         updateIndexCallback!(lastSelectedIndex);
//       } else {
//         updateIndexCallback!(-1); // Unselect bottom menu for new pages
//       }
//     }
//   }

//   void goBackToLastMainPage() {
//     currentPage.value =
//         mainPages[lastSelectedIndex]; // Restore last selected main page
//     updateIndexCallback!(lastSelectedIndex);
//   }
// }

class Mypagecontroller extends GetxController {
  RxList<Widget> pageStack = <Widget>[Homepages()].obs;
  int lastSelectedIndex = 0;

  final List<Widget> mainPages = [
    Homepages(),
    Transactions(),
    Orders(),
    Network(),
  ];

  Function(int)? updateIndexCallback;

  void setUpdateIndexCallback(Function(int) callback) {
    updateIndexCallback = callback;
  }

  void changePage(Widget page, {bool isMainPage = true}) {
    if (isMainPage) {
      lastSelectedIndex = mainPages.indexWhere(
        (element) => element.runtimeType == page.runtimeType,
      );
      pageStack.value = [page]; // reset stack for main page change
    } else {
      pageStack.add(page);
    }

    if (updateIndexCallback != null) {
      updateIndexCallback!(isMainPage ? lastSelectedIndex : -1);
    }
  }

  bool goBack() {
    if (pageStack.length > 1) {
      pageStack.removeLast();
      return false; // don't exit
    } else {
      return true; // allow exit
    }
  }

  void goToMainPageByIndex(int index) {
    lastSelectedIndex = index;
    changePage(mainPages[index], isMainPage: true);
  }
}
