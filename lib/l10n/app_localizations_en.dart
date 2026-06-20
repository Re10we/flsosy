// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get market => 'Market';

  @override
  String get favorites => 'Favorites';

  @override
  String get sosy => 'Sosy';

  @override
  String get sosynAnalyzing => 'sosyn is analyzing the markets...';

  @override
  String get watchlistEmpty =>
      'Your watchlist is empty. Tap the star icon on the Market tab to track your favorite coins.';

  @override
  String get failedToLoadMarketData => 'Failed to load market data';

  @override
  String get retry => 'Retry';

  @override
  String get buy => 'Buy';

  @override
  String get sell => 'Sell';

  @override
  String get marketCap => 'Market Cap';

  @override
  String get volume24h => '24h Volume';

  @override
  String get high24h => '24h High';
}
