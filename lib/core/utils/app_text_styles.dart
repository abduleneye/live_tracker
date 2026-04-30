import 'dart:ui';

import 'package:flutter/src/painting/text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static final TextStyle body = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
      color: Color(0xff1B1C1E)
  );

  static final TextStyle title = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Color(0xff1B1C1E)
  );

  static final TextStyle greyTexts = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color(0xffB3B3B4)
  );

  static final TextStyle semiBold = GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Color(0xff1B1C1E)
  );




}