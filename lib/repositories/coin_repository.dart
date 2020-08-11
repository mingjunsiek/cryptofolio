import 'package:cryptofolio/data_provider/coin_gecko_api_client.dart';
import 'package:cryptofolio/models/freezed_classes.dart';

class CoinRepository {
  final CoinGeckoApiClient coinGeckoApiClient;
  List<Coin> _coinList;
  CoinRepository(this.coinGeckoApiClient);

  List<Coin> get coinList {
    return _coinList;
  }

  Future<List<Coin>> fetchTop100Coins() async {
    _coinList = await coinGeckoApiClient.fetchTop100Coins();
    return _coinList;
  }
}

class NetworkException implements Exception {}
