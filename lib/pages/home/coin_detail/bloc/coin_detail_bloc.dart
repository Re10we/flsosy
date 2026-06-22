import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../data/coin_market_sdk/coin_market_sdk.dart';
import 'coin_detail_event.dart';
import 'coin_detail_state.dart';

class CoinDetailBloc extends Bloc<CoinDetailEvent, CoinDetailState> {
  CoinDetailBloc() : super(const CoinDetailLoading()) {
    on<CoinDetailFetchRequested>(_onFetchRequested);
  }

  final _sdk = CoinMarketSdk(
    apiKey: dotenv.env['CMC_API_KEY'] ??
        (() {
          throw Exception('CMC_API_KEY not found in .env');
        })(),
  );

  Future<void> _onFetchRequested(
    CoinDetailFetchRequested event,
    Emitter<CoinDetailState> emit,
  ) async {
    emit(const CoinDetailLoading());

    try {
      // Delegate to the SDK which handles all HTTP logic including the
      // concurrent quotes + info fetch for logo URL.
      final detail = await _sdk.fetchCoinDetail(event.coinId);
      emit(CoinDetailLoaded(detail: detail));
    } catch (e) {
      // Surface a clean error message regardless of the underlying exception type.
      emit(CoinDetailError(message: e.toString()));
    }
  }
}
