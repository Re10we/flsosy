import '../../models/coin_model.dart';
import '../../models/coin_detail.dart';

/// Abstract contract for fetching coin market data.
abstract class CoinMarketRepository {
  /// Fetch a list of coins.
  ///
  /// Returns a list of domain‑level [CoinModel] objects.
  Future<List<CoinModel>> fetchCoins({int limit = 20, int start = 1});

  /// Fetch detailed information about a single coin.
  ///
  /// The [coinId] corresponds to the identifier used by the API.
  Future<CoinDetail> fetchCoinDetail(int coinId);
}
