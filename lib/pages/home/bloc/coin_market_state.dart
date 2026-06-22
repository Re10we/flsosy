import 'package:equatable/equatable.dart';

abstract class CoinMarketState extends Equatable {
  const CoinMarketState();

  @override
  List<Object?> get props => [];
}

class CoinMarketIdle extends CoinMarketState {
  const CoinMarketIdle();
}
