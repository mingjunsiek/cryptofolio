import 'package:meta/meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'freezed_classes.freezed.dart';
part 'freezed_classes.g.dart';

@freezed
abstract class Coin with _$Coin {
  const factory Coin(
    String id,
    String symbol,
    String name,
    String image,
    double current_price,
    int market_cap,
    int market_cap_rank,
    int total_volume,
    @nullable double high_24h,
    @nullable double low_24h,
    @nullable double price_change_24h,
    @nullable double price_change_percentage_24h,
    @nullable double market_cap_change_24h,
    @nullable double market_cap_change_percentage_24h,
    @nullable double circulating_supply,
    @nullable double total_supply,
    @nullable double ath,
    @nullable double ath_change_percentage,
    @nullable String ath_date,
    @nullable double atl,
    @nullable double atl_change_percentage,
    @nullable String atl_date,
    @nullable Map<String, dynamic> roi,
    String last_updated,
  ) = _Coin;
  factory Coin.fromJson(Map<String, dynamic> json) => _$CoinFromJson(json);
}

@freezed
abstract class PortfolioItem with _$PortfolioItem {
  const factory PortfolioItem(
    String coindId,
    double coinAmount,
    double price,
    DateTime purchaseDate,
  ) = _PortfolioItem;
  factory PortfolioItem.fromJson(Map<String, dynamic> json) =>
      _$PortfolioItemFromJson(json);
}

@freezed
abstract class User with _$User {
  const factory User(
    String id,
    String name,
    List<String> favourites,
    List<PortfolioItem> portfolioItem,
  ) = _User;
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
abstract class Favourites with _$Favourites {
  const factory Favourites(
    List<String> favouriteList,
  ) = _Favourites;
  factory Favourites.fromJson(Map<String, dynamic> json) =>
      _$FavouritesFromJson(json);
}
