import 'dart:async';

import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'models/isar_coin.dart';
import 'convertors/coin_converter.dart';
import '../data/models/coin_model.dart';

/// Singleton service that encapsulates all Isar database operations for
/// favorite coins. It provides an async initialization, a reactive stream of
/// favorites and basic CRUD helpers.
class IsarService {
  IsarService._();
  static final IsarService instance = IsarService._();

  late final Future<Isar> _isarFuture;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _isarFuture = Isar.open(
      [IsarCoinSchema],
      directory: dir.path,
      inspector: false,
    );
    await _isarFuture;
  }

  Future<Isar> _instance() async => await _isarFuture;

  /// Streams the list of favorite coins as immutable [CoinModel] objects.
  /// The stream emits the current list immediately (`fireImmediately: true`).
  Stream<List<CoinModel>> watchFavorites() async* {
    final isar = await _instance();
    yield* isar.isarCoins
        .where()
        .watch(fireImmediately: true)
        .map((isarCoins) => isarCoins.map(CoinConverter.toAppModel).toList());
  }

  /// Adds a coin to the favorites collection.
  Future<void> addFavorite(CoinModel coin) async {
    final isar = await _instance();
    final isarCoin = CoinConverter.fromAppModel(coin);
    await isar.writeTxn(() async => await isar.isarCoins.put(isarCoin));
  }

  /// Removes a favorite coin by its original string id.
  Future<void> removeFavorite(String coinId) async {
    final isar = await _instance();
    await isar.writeTxn(() async {
      await isar.isarCoins.filter().idEqualTo(coinId).deleteAll();
    });
  }

  /// Clears all favorite entries.
  Future<void> clearAllFavorites() async {
    final isar = await _instance();
    await isar.writeTxn(() async => await isar.isarCoins.clear());
  }

  /// Returns true if a coin with [coinId] is already in the favorites collection.
  ///
  /// Uses a filtered count query which is cheaper than loading the full object.
  Future<bool> isFavorite(String coinId) async {
    final isar = await _instance();
    final count = await isar.isarCoins.filter().idEqualTo(coinId).count();
    return count > 0;
  }
}
