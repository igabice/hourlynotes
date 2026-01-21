import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyle {
  static TextStyle twentyFour700({Color? color}) {
    return GoogleFonts.figtree(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.appBlack);
  }

  static TextStyle twenty600({Color? color}) {
    return GoogleFonts.figtree(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.appBlack);
  }

  static TextStyle fourteen400({Color? color}) {
    return GoogleFonts.figtree(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: color ?? AppColors.appGrey,
    );
  }

  static TextStyle fourteen700({Color? color}) {
    return GoogleFonts.figtree(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: color ?? AppColors.appGrey,
    );
  }

  static TextStyle sixteen700({Color? color}) {
    return GoogleFonts.figtree(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: color ?? AppColors.appGrey,
    );
  }

  static TextStyle sixteen500({Color? color}) {
    return GoogleFonts.figtree(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: color ?? AppColors.appGrey,
    );
  }

  static TextStyle sixteen400({Color? color}) {
    return GoogleFonts.figtree(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: color ?? AppColors.appGrey,
    );
  }
}
