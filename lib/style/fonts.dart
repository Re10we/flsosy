import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SFont {
  SFont._internal();
  static final SFont _instance = SFont._internal();
  factory SFont() => _instance;

  final displayLg = GoogleFonts.inter(
    fontSize: 48.0,
    fontWeight: FontWeight.w600,
    height: 1.1,
    letterSpacing: -0.04 * 48.0,
  );

  final headlineLg = GoogleFonts.inter(
    fontSize: 32.0,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.02 * 32.0,
  );

  final headlineLgMobile = GoogleFonts.inter(
    fontSize: 28.0,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.02 * 28.0,
  );

  final titleMd = GoogleFonts.inter(
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: -0.01 * 20.0,
  );

  final bodyLg = GoogleFonts.inter(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: 0.0,
  );

  final bodySm = GoogleFonts.inter(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: 0.0,
  );

  final labelMd = GoogleFonts.inter(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    height: 1.0,
    letterSpacing: 0.05 * 12.0,
  );

  final monoData = GoogleFonts.inter(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    height: 1.0,
    letterSpacing: -0.02 * 14.0,
  );
}
