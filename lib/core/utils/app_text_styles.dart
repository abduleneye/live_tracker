import 'dart:ui';

import 'package:flutter/src/painting/text_style.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static final TextStyle body = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 18
  );

  static final TextStyle title = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
}