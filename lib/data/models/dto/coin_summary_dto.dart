class CoinSummaryDTO {
  const CoinSummaryDTO({
    required this.id,
    required this.name,
    required this.symbol,
    required this.priceUsd,
    required this.percentChange24h,
  });

  final int id;
  final String name;
  final String symbol;
  final double priceUsd;
  final double percentChange24h;

  factory CoinSummaryDTO.fromJson(Map<String, dynamic> json) {
    final quote = json['quote'] as Map<String, dynamic>? ?? {};
    final usd = quote['USD'] as Map<String, dynamic>? ?? {};
    return CoinSummaryDTO(
      id: json['id'] as int,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      priceUsd: (usd['price'] as num?)?.toDouble() ?? 0.0,
      percentChange24h: (usd['percent_change_24h'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
