// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'freezed_classes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Coin _$_$_CoinFromJson(Map<String, dynamic> json) {
  return _$_Coin(
    json['id'] as String,
    json['symbol'] as String,
    json['name'] as String,
    json['image'] as String,
    (json['current_price'] as num)?.toDouble(),
    json['market_cap'] as int,
    json['market_cap_rank'] as int,
    (json['fully_diluted_valuation'] as num)?.toDouble(),
    (json['total_volume'] as num)?.toDouble(),
    (json['high_24h'] as num)?.toDouble(),
    (json['low_24h'] as num)?.toDouble(),
    (json['price_change_24h'] as num)?.toDouble(),
    (json['price_change_percentage_24h'] as num)?.toDouble(),
    (json['market_cap_change_24h'] as num)?.toDouble(),
    (json['market_cap_change_percentage_24h'] as num)?.toDouble(),
    (json['circulating_supply'] as num)?.toDouble(),
    (json['total_supply'] as num)?.toDouble(),
    (json['max_supply'] as num)?.toDouble(),
    (json['ath'] as num)?.toDouble(),
    (json['ath_change_percentage'] as num)?.toDouble(),
    json['ath_date'] as String,
    (json['atl'] as num)?.toDouble(),
    (json['atl_change_percentage'] as num)?.toDouble(),
    json['atl_date'] as String,
    json['roi'] as Map<String, dynamic>,
    json['last_updated'] as String,
  );
}

Map<String, dynamic> _$_$_CoinToJson(_$_Coin instance) => <String, dynamic>{
      'id': instance.id,
      'symbol': instance.symbol,
      'name': instance.name,
      'image': instance.image,
      'current_price': instance.current_price,
      'market_cap': instance.market_cap,
      'market_cap_rank': instance.market_cap_rank,
      'fully_diluted_valuation': instance.fully_diluted_valuation,
      'total_volume': instance.total_volume,
      'high_24h': instance.high_24h,
      'low_24h': instance.low_24h,
      'price_change_24h': instance.price_change_24h,
      'price_change_percentage_24h': instance.price_change_percentage_24h,
      'market_cap_change_24h': instance.market_cap_change_24h,
      'market_cap_change_percentage_24h':
          instance.market_cap_change_percentage_24h,
      'circulating_supply': instance.circulating_supply,
      'total_supply': instance.total_supply,
      'max_supply': instance.max_supply,
      'ath': instance.ath,
      'ath_change_percentage': instance.ath_change_percentage,
      'ath_date': instance.ath_date,
      'atl': instance.atl,
      'atl_change_percentage': instance.atl_change_percentage,
      'atl_date': instance.atl_date,
      'roi': instance.roi,
      'last_updated': instance.last_updated,
    };

_$_PortfolioItem _$_$_PortfolioItemFromJson(Map<String, dynamic> json) {
  return _$_PortfolioItem(
    coindId: json['coindId'] as String,
    portfolioId: json['portfolioId'] as String,
    coinAmount: (json['coinAmount'] as num)?.toDouble(),
    price: (json['price'] as num)?.toDouble(),
    purchaseDate: json['purchaseDate'] == null
        ? null
        : DateTime.parse(json['purchaseDate'] as String),
  );
}

Map<String, dynamic> _$_$_PortfolioItemToJson(_$_PortfolioItem instance) =>
    <String, dynamic>{
      'coindId': instance.coindId,
      'portfolioId': instance.portfolioId,
      'coinAmount': instance.coinAmount,
      'price': instance.price,
      'purchaseDate': instance.purchaseDate?.toIso8601String(),
    };

_$_User _$_$_UserFromJson(Map<String, dynamic> json) {
  return _$_User(
    json['id'] as String,
    json['name'] as String,
    (json['favourites'] as List)?.map((e) => e as String)?.toList(),
    (json['portfolioItem'] as List)
        ?.map((e) => e == null
            ? null
            : PortfolioItem.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$_$_UserToJson(_$_User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'favourites': instance.favourites,
      'portfolioItem': instance.portfolioItem,
    };

_$_Favourites _$_$_FavouritesFromJson(Map<String, dynamic> json) {
  return _$_Favourites(
    (json['favouriteList'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$_$_FavouritesToJson(_$_Favourites instance) =>
    <String, dynamic>{
      'favouriteList': instance.favouriteList,
    };
