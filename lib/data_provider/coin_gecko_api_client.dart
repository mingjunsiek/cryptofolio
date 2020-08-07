import 'dart:convert';

import 'package:cryptofolio/models/freezed_classes.dart';
import 'package:http/http.dart' as http;

class CoinGeckoApiClient {
  final _baseUrl = 'https://api.coingecko.com/api/v3';
  final http.Client httpClient;

  CoinGeckoApiClient(this.httpClient);

  Future<List<Coin>> fetchTop20Coins() async {
    final url =
        '$_baseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20&page=1&sparkline=false';
    final response = await this.httpClient.get(url);
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw 'Error Code: ${response.statusCode}';
    }
    final List<dynamic> responseJson = jsonDecode(response.body);
    final list =
        responseJson.map((coinData) => Coin.fromJson(coinData)).toList();
    //print(list);
    return list;
  }
}