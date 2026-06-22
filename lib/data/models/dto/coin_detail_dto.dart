import '../coin_detail.dart';

class CoinDetailDTO {
  const CoinDetailDTO({
    required this.id,
    required this.name,
    required this.symbol,
    required this.priceUsd,
    required this.percentChange24h,
    required this.marketCapUsd,
    required this.volume24hUsd,
    required this.circulatingSupply,
  });

  final int id;
  final String name;
  final String symbol;
  final double priceUsd;
  final double percentChange24h;
  final double marketCapUsd;
  final double volume24hUsd;
  final double circulatingSupply;

  factory CoinDetailDTO.fromJson(Map<String, dynamic> json) {
    final quote = json['quote'] as Map<String, dynamic>? ?? {};
    final usd = quote['USD'] as Map<String, dynamic>? ?? {};
    return CoinDetailDTO(
      id: json['id'] as int,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      priceUsd: (usd['price'] as num?)?.toDouble() ?? 0.0,
      percentChange24h: (usd['percent_change_24h'] as num?)?.toDouble() ?? 0.0,
      marketCapUsd: (usd['market_cap'] as num?)?.toDouble() ?? 0.0,
      volume24hUsd: (usd['volume_24h'] as num?)?.toDouble() ?? 0.0,
      circulatingSupply:
          (json['circulating_supply'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Convert the DTO into the domain model used by the UI, combining it with
  /// the metadata [logo] URL.
  CoinDetail toDomain({required String logo}) => CoinDetail(
        id: id,
        name: name,
        symbol: symbol,
        price: priceUsd,
        percentChange24h: percentChange24h,
        marketCap: marketCapUsd,
        volume24h: volume24hUsd,
        circulatingSupply: circulatingSupply,
        logo: logo,
      );
}
