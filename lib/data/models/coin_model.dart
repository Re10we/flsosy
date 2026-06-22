import 'package:flutter/foundation.dart';

/// Immutable model representing a cryptocurrency coin used throughout the app.
///
/// This unified model represents coins in the market list, search view,
/// details view, and local persistent storage (Isar).
@immutable
class CoinModel {
  const CoinModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.price,
    required this.imageUrl,
    this.percentChange24h = 0.0,
  });

  /// Unique identifier for the coin, typically parsed from the API and stored as String.
  final String id;

  /// The full name of the cryptocurrency (e.g., "Bitcoin").
  final String name;

  /// The ticker symbol representing the coin (e.g., "BTC").
  final String symbol;

  /// The current price in USD.
  final double price;

  /// The URL to the logo image of the cryptocurrency.
  final String imageUrl;

  /// The 24-hour percentage price change, defaulting to 0.0 if not supplied (e.g. for favorites).
  final double percentChange24h;

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    final quote = json['quote'] as Map<String, dynamic>? ?? {};
    final usd = quote['USD'] as Map<String, dynamic>? ?? {};
    final idVal = json['id'];
    final idStr = idVal.toString();
    final logoUrl =
        'https://s2.coinmarketcap.com/static/img/coins/64x64/$idStr.png';

    return CoinModel(
      id: idStr,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      price: (usd['price'] as num?)?.toDouble() ?? 0.0,
      percentChange24h: (usd['percent_change_24h'] as num?)?.toDouble() ?? 0.0,
      imageUrl: logoUrl,
    );
  }
}
