import 'dart:ui';

import 'package:flsosy/isar/isar_service.dart';
import 'package:flsosy/l10n/app_localizations.dart';
import 'package:flsosy/style/colors.dart';
import 'package:flsosy/style/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flsosy/pages/main/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await IsarService.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: STheme.darkTheme,
        themeMode: ThemeMode.dark,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        builder: (context, child) {
          final colors = SColors();
          return Stack(
            children: [
              Container(color: colors.accentHeaderGreen),
              Center(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaX: 120,
                    sigmaY: 120,
                    tileMode: TileMode.decal,
                  ),
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      color: colors.accentNeonCyberGreen.withValues(
                        alpha: 0.05,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              if (child != null) child,
            ],
          );
        },
        home: const MainScreen(),
      );
}
