import 'package:cryptofolio/data_provider/coin_gecko_api_client.dart';
import 'package:cryptofolio/models/freezed_classes.dart';

class CoinRepository {
  final CoinGeckoApiClient coinGeckoApiClient;

  CoinRepository(this.coinGeckoApiClient);

  Future<List<Coin>> fetchTop20Coins() async {
    return await coinGeckoApiClient.fetchTop20Coins();
  }
}

class NetworkException implements Exception {}
