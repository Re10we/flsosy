class CoinDetail {
  const CoinDetail({
    required this.id,
    required this.name,
    required this.symbol,
    required this.price,
    required this.percentChange24h,
    required this.marketCap,
    required this.volume24h,
    required this.circulatingSupply,
    required this.logo,
  });

  final int id;
  final String name;
  final String symbol;
  final double price;
  final double percentChange24h;
  final double marketCap;
  final double volume24h;
  final double circulatingSupply;
  final String logo;
}
