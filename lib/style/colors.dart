import 'package:flutter/material.dart';

class SColors {
  // Private constructor for singleton
  SColors._internal();
  static final SColors _instance = SColors._internal();
  factory SColors() => _instance;

  // Core palette
  final baseObsidianBlack = const Color(0xFF0A0D14);
  final accentNeonCyberGreen = const Color(0xFF00FF66);
  final neutralMutedSilverGray = const Color(0xFF8F94A3);
  final pureWhite = const Color(0xFFFFFFFF);
  final accentHeaderGreen = const Color(0xFF0C160C);
  final borderGreen = const Color(0xFF3B4B3A);

  // Semantic aliases
  Color get surface => baseObsidianBlack;
  Color get surfaceDim => baseObsidianBlack;
  Color get surfaceBright => const Color(0xFF14171F);
  Color get surfaceContainerLowest => baseObsidianBlack;
  Color get surfaceContainerLow => const Color(0xFF14171F);
  Color get surfaceContainer => const Color(0xFF14171F);
  Color get surfaceContainerHigh => const Color(0xFF14171F);
  Color get surfaceContainerHighest => const Color(0xFF14171F);
  Color get onSurface => pureWhite;
  Color get onSurfaceVariant => neutralMutedSilverGray;
  Color get inverseSurface => pureWhite;
  Color get inverseOnSurface => baseObsidianBlack;
  Color get outline => neutralMutedSilverGray;
  Color get outlineVariant => const Color.fromRGBO(255, 255, 255, 0.08);
  Color get surfaceTint => accentNeonCyberGreen;

  // Primary palette
  Color get primary => accentNeonCyberGreen;
  Color get onPrimary => baseObsidianBlack;
  Color get primaryContainer => accentNeonCyberGreen;
  Color get onPrimaryContainer => baseObsidianBlack;
  Color get inversePrimary => accentNeonCyberGreen;
  Color get primaryFixed => accentNeonCyberGreen;
  Color get primaryFixedDim => const Color(0xFF00E55B);
  Color get onPrimaryFixed => baseObsidianBlack;
  Color get onPrimaryFixedVariant => baseObsidianBlack;

  // Secondary palette
  Color get secondary => neutralMutedSilverGray;
  Color get onSecondary => pureWhite;
  Color get secondaryContainer => neutralMutedSilverGray;
  Color get onSecondaryContainer => pureWhite;
  Color get secondaryFixed => neutralMutedSilverGray;
  Color get secondaryFixedDim => neutralMutedSilverGray;
  Color get onSecondaryFixed => baseObsidianBlack;
  Color get onSecondaryFixedVariant => baseObsidianBlack;

  // Tertiary palette
  Color get tertiary => neutralMutedSilverGray;
  Color get onTertiary => pureWhite;
  Color get tertiaryContainer => neutralMutedSilverGray;
  Color get onTertiaryContainer => pureWhite;
  Color get tertiaryFixed => neutralMutedSilverGray;
  Color get tertiaryFixedDim => neutralMutedSilverGray;
  Color get onTertiaryFixed => baseObsidianBlack;
  Color get onTertiaryFixedVariant => baseObsidianBlack;

  // Error palette
  Color get error => const Color(0xFFFF4D4D);
  Color get onError => pureWhite;
  Color get errorContainer => const Color(0xFFCC0000);
  Color get onErrorContainer => pureWhite;

  // Background & surface variant
  Color get background => baseObsidianBlack;
  Color get surfaceVariant => const Color(0xFF14171F);
}
