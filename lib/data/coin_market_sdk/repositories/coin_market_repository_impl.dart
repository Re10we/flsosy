import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/coin_model.dart';
import '../../models/coin_detail.dart';
import '../../models/dto/coin_summary_dto.dart';
import '../../models/dto/coin_detail_dto.dart';
import 'coin_market_repository.dart';

class CoinMarketRepositoryImpl implements CoinMarketRepository {
  static const _baseUrl = 'https://pro-api.coinmarketcap.com/v1';

  final String apiKey;

  CoinMarketRepositoryImpl({required this.apiKey});

  Map<String, String> get _headers => {
        'Accept': 'application/json',
        'X-CMC_PRO_API_KEY': apiKey,
      };

  @override
  Future<List<CoinModel>> fetchCoins({int limit = 20, int start = 1}) async {
    final uri = Uri.parse('$_baseUrl/cryptocurrency/listings/latest').replace(
        queryParameters: {
          'limit': limit.toString(),
          'start': start.toString()
        });
    final response = await http.get(uri, headers: _headers);
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to fetch coin list (status: ${response.statusCode})');
    }
    final Map<String, dynamic> jsonBody =
        jsonDecode(response.body) as Map<String, dynamic>;
    final List<dynamic> data = jsonBody['data'] as List<dynamic>;
    // Convert each raw map to a DTO and then to the domain model.
    return data.map((raw) {
      final dto = CoinSummaryDTO.fromJson(raw as Map<String, dynamic>);
      return CoinModel(
        id: dto.id.toString(),
        name: dto.name,
        symbol: dto.symbol,
        price: dto.priceUsd,
        imageUrl:
            'https://s2.coinmarketcap.com/static/img/coins/64x64/${dto.id}.png',
        percentChange24h: dto.percentChange24h,
      );
    }).toList();
  }

  @override
  Future<CoinDetail> fetchCoinDetail(int coinId) async {
    final quotesUri = Uri.parse('$_baseUrl/cryptocurrency/quotes/latest')
        .replace(queryParameters: {'id': coinId.toString()});
    final infoUri = Uri.parse('$_baseUrl/cryptocurrency/info')
        .replace(queryParameters: {'id': coinId.toString()});

    // We make concurrent requests to both the quotes API (for price and other metrics)
    // and the metadata info API (for the logo URL).
    // This optimization minimizes total waiting time, since sequential requests would
    // double the network latency.
    final results = await Future.wait([
      http.get(quotesUri, headers: _headers),
      http.get(infoUri, headers: _headers),
    ]);

    final quotesResponse = results[0];
    final infoResponse = results[1];

    if (quotesResponse.statusCode != 200) {
      throw Exception(
          'Failed to fetch coin quotes (status: ${quotesResponse.statusCode})');
    }
    if (infoResponse.statusCode != 200) {
      throw Exception(
          'Failed to fetch coin info (status: ${infoResponse.statusCode})');
    }

    final Map<String, dynamic> quotesJson =
        jsonDecode(quotesResponse.body) as Map<String, dynamic>;
    final Map<String, dynamic> infoJson =
        jsonDecode(infoResponse.body) as Map<String, dynamic>;

    final Map<String, dynamic> quotesData = (quotesJson['data']
        as Map<String, dynamic>)[coinId.toString()] as Map<String, dynamic>;
    final Map<String, dynamic> infoData = (infoJson['data']
        as Map<String, dynamic>)[coinId.toString()] as Map<String, dynamic>;

    final dto = CoinDetailDTO.fromJson(quotesData);
    final logo = infoData['logo'] as String? ??
        'https://s2.coinmarketcap.com/static/img/coins/64x64/$coinId.png';

    return dto.toDomain(logo: logo);
  }
}
