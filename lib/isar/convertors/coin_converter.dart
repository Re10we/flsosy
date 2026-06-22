import '../../data/models/coin_model.dart';
import '../models/isar_coin.dart';

/// Converter between the app's [CoinModel] and the Isar collection [IsarCoin].
class CoinConverter {
  /// Convert a persisted [IsarCoin] into the immutable [CoinModel] used in UI/Bloc.
  static CoinModel toAppModel(IsarCoin isarCoin) {
    return CoinModel(
      id: isarCoin.id,
      name: isarCoin.name,
      symbol: isarCoin.symbol,
      price: isarCoin.price,
      imageUrl: isarCoin.imageUrl,
    );
  }

  /// Convert the immutable [CoinModel] into an [IsarCoin] ready for persistence.
  static IsarCoin fromAppModel(CoinModel model) {
    return IsarCoin(
      id: model.id,
      name: model.name,
      symbol: model.symbol,
      price: model.price,
      imageUrl: model.imageUrl,
    );
  }
}
