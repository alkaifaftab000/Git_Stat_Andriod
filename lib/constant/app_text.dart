import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText {
  static TextStyle popinsFont(
      {FontWeight fontWt = FontWeight.normal,
      Color color = Colors.black,
      double size = 15}) {
    return GoogleFonts.poppins(
        fontWeight: fontWt, color: color, fontSize: size);
  }
}
