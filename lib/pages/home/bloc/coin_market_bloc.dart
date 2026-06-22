import 'package:flsosy/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'coin_market_event.dart';
import 'coin_market_state.dart';
import '../../../data/coin_market_sdk/coin_market_sdk.dart';
import '../../../data/models/coin_model.dart';

class CoinMarketBloc extends Bloc<CoinMarketEvent, CoinMarketState> {
  CoinMarketBloc() : super(const CoinMarketIdle());

  final _sdk = CoinMarketSdk(
    apiKey: dotenv.env['CMC_API_KEY'] ??
        (() {
          throw Exception('CMC_API_KEY not found in .env');
        })(),
  );

  Future<List<CoinModel>> fetchPage(int pageKey) =>
      _sdk.fetchCoinList(limit: kPaginationLimit, start: pageKey);
}
