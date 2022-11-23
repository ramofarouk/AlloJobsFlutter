import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class Constants {
  static const String logo = "assets/images/logo.png";
  static String appName = "AllôJobs";

  static String host2 = "http://allojobs.ouiidrive.com";

  static String host = "http://allojobs.ouiidrive.com";

  static Color primaryColor = const Color(0xff0F6A4E);
  static Color secondaryColor = const Color(0xffA50F14);
  static Color thridColor = const Color(0xffFDCE1D);

  static String token = "Allojobstogo@2022";

  static String appDescription = "Trouvez du travail plus facilement!";

  static String formatAmount(price) {
    String priceInText = "";
    int counter = 0;
    for (int i = (price.length - 1); i >= 0; i--) {
      counter++;
      String str = price[i];
      if ((counter % 3) != 0 && i != 0) {
        priceInText = "$str$priceInText";
      } else if (i == 0) {
        priceInText = "$str$priceInText";
      } else {
        priceInText = ".$str$priceInText";
      }
    }
    return priceInText.trim();
  }

  static String formatNumber(int number) {
    if (number <= 9) {
      return "0" + number.toString();
    }
    return number.toString();
  }

  static String getRandomInt(int length) {
    const _chars = '1234567890';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }
}

// Colors
const Color kPrimary = Color(0xff0F6A4E);
const Color kSecondary = Color(0xff518039);
const Color kThirdy = Color(0xffE97B2E);
const Color kBlue = Color(0xFF3287B6);
const Color kLightBlue = Color(0xFF086EB6);
const Color kDarkBlue = Color(0xFF1046B3);
const Color kWhite = Color(0xFFFFFFFF);
const Color kGrey = Color(0xFFF4F5F7);
const Color kBlack = Color(0xFF2D3243);

const double kPaddingS = 8.0;
const double kPaddingM = 16.0;
const double kPaddingL = 32.0;

const Color orange = Color(0xFFFC6011);
const Color black = Color(0xFF000000);
const Color primary = Color(0xFF4A4B4D);
const Color secondary = Color(0xFF7C7D7E);
const Color placeholder = Color(0xFFB6B7B7);
const Color placeholderBg = Color(0xFFF2F2F2);

const Color facebookColor = Color(0xFF3B5999);
const Color googleColor = Color(0xFFDE4B39);
const Color backgroundColor = Color(0xFFECF3F9);

const String currentFontFamily = "Metropolis";
