import 'package:jahanpay/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../global_controller/font_controller.dart';

class KText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;
  final String? fontFamily;
  final TextAlign? textAlign;
  final bool isCustomFont;

  const KText({
    Key? key,
    required this.text,
    this.fontSize = 15,
    this.color,
    this.fontWeight = FontWeight.normal,
    this.fontFamily,
    this.textAlign,
    this.isCustomFont = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    String? selectedFont;

    if (isCustomFont) {
      selectedFont =
          fontFamily ??
          (box.read("language").toString() == "Fa"
              ? Get.find<FontController>().currentFont
              : null);
    } else {
      selectedFont = null;
    }
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        color: color ?? Colors.black,
        fontWeight: fontWeight,
        fontFamily: selectedFont,
      ),
    );
  }
}

//=======================

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';

// import '../global_controller/font_controller.dart';

// class KText extends StatelessWidget {
//   final String text;
//   final double fontSize;
//   final Color? color;
//   final FontWeight fontWeight;
//   final String? fontFamily;
//   final TextAlign? textAlign;
//   final bool isCustomFont;

//   const KText({
//     Key? key,
//     required this.text,
//     this.fontSize = 15,
//     this.color,
//     this.fontWeight = FontWeight.normal,
//     this.fontFamily,
//     this.textAlign,
//     this.isCustomFont = true,
//   }) : super(key: key);

//   bool isAlphabet(String char) {
//     return RegExp(r'[A-Za-z؀-ۿ]').hasMatch(char);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final box = GetStorage();

//     String? customFont =
//         fontFamily ??
//         (box.read("language").toString() == "Fa"
//             ? Get.find<FontController>().currentFont
//             : null);

//     List<TextSpan> spans = [];

//     for (int i = 0; i < text.length; i++) {
//       String char = text[i];

//       spans.add(
//         TextSpan(
//           text: char,
//           style: TextStyle(
//             fontSize: fontSize,
//             color: color ?? Colors.black,
//             fontWeight: fontWeight,

//             /// alphabet হলে font apply
//             fontFamily: (isCustomFont && isAlphabet(char)) ? customFont : null,
//           ),
//         ),
//       );
//     }

//     return RichText(
//       textAlign: textAlign ?? TextAlign.start,
//       text: TextSpan(children: spans),
//     );
//   }
// }
