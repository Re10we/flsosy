import 'package:flsosy/data/models/coin_detail.dart';
import 'package:flsosy/data/coin_market_sdk/repositories/coin_market_repository.dart';
import 'package:flsosy/data/coin_market_sdk/repositories/coin_market_repository_impl.dart';

import '../models/coin_model.dart';

/// SDK entry point for CoinMarketCap Pro API.
class CoinMarketSdk {
  CoinMarketSdk({required this.apiKey}) {
    repository = CoinMarketRepositoryImpl(apiKey: apiKey);
  }

  /// API key required by CoinMarketCap. Must be provided by the caller.
  final String apiKey;

  /// Repository handling low‑level HTTP requests.
  late final CoinMarketRepository repository;

  /// Fetches a list of top cryptocurrencies starting at [start] (1-based offset).
  ///
  /// [limit] – number of coins to return.
  /// [start] – 1-based index of the first coin (default 1, i.e., from the top).
  Future<List<CoinModel>> fetchCoinList({int limit = 20, int start = 1}) =>
      repository.fetchCoins(limit: limit, start: start);

  /// Retrieves detailed information for a specific coin identified by [coinId].
  Future<CoinDetail> fetchCoinDetail(int coinId) =>
      repository.fetchCoinDetail(coinId);
}
