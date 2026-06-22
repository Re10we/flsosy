import 'package:equatable/equatable.dart';

abstract class CoinDetailEvent extends Equatable {
  const CoinDetailEvent();

  @override
  List<Object?> get props => [];
}

final class CoinDetailFetchRequested extends CoinDetailEvent {
  const CoinDetailFetchRequested({required this.coinId});

  final int coinId;

  @override
  List<Object?> get props => [coinId];
}
