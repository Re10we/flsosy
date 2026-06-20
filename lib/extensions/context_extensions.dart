import 'package:flutter/widgets.dart';
import 'package:flsosy/l10n/app_localizations.dart';
import 'package:flsosy/style/colors.dart';
import 'package:flsosy/style/fonts.dart';

/// Extension on [BuildContext] to provide easy access to common singletons.
extension ContextX on BuildContext {
  /// Safe access to localization strings; returns null if unavailable.
  AppLocalizations? get strings => AppLocalizations.of(this);

  /// Global color palette singleton.
  SColors get colors => SColors();

  /// Global fonts singleton.
  SFont get fonts => SFont();
}
