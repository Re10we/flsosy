import 'package:equatable/equatable.dart';
import 'package:flsosy/data/models/coin_detail.dart';

abstract class CoinDetailState extends Equatable {
  const CoinDetailState();

  @override
  List<Object?> get props => [];
}

final class CoinDetailLoading extends CoinDetailState {
  const CoinDetailLoading();
}

final class CoinDetailLoaded extends CoinDetailState {
  const CoinDetailLoaded({required this.detail});

  final CoinDetail detail;

  @override
  List<Object?> get props => [detail];
}

final class CoinDetailError extends CoinDetailState {
  const CoinDetailError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
