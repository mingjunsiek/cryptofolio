import 'package:cryptofolio/helpers/size_helpers.dart';
import 'package:cryptofolio/models/freezed_classes.dart';
import 'package:cryptofolio/widgets/home/coin_card/title_with_button_bar.dart';
import 'package:cryptofolio/widgets/home/coin_card/twenty_four_percentage.dart';
import 'package:flutter/material.dart';

import 'current_price.dart';

class CoinLists extends StatelessWidget {
  final List<Coin> coinList;
  final Favourites favourites;
  final String title;
  final String buttonText;
  final Function buttonFunction;
  const CoinLists({
    Key key,
    this.coinList,
    this.favourites,
    this.title,
    this.buttonText,
    this.buttonFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Coin> favouriteList = [];
    print('top_twenty_coin.dart: Favourites $favourites');

    if (favourites != null) {
      favouriteList = coinList.where((coin) {
        return favourites.favouriteList.contains(coin.id);
      }).toList();
    }

    return Container(
      margin: EdgeInsets.only(
        top: 30,
      ),
      child: Column(
        children: [
          TitleWithButtonBar(
            title: this.title,
            buttonText: this.buttonText,
            buttonFunction: this.buttonFunction,
          ),
          Container(
            height: _getFavouriteHeight(
              favourites,
              displayHeight(context),
              MediaQuery.of(context).padding.top,
            ),
            width: displayWidth(context) * 0.95,
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                itemCount: favourites == null ? 20 : favouriteList.length,
                itemBuilder: (context, index) {
                  final currentCoin = favourites == null
                      ? coinList[index]
                      : favouriteList[index];
                  return Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 4,
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            if (favourites == null)
                              Container(
                                width: 30,
                                child: Text(
                                  (index + 1).toString(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: Image.network(
                                currentCoin.image.replaceAll("large", "small"),
                                alignment: Alignment.center,
                                scale: 1.7,
                              ),
                            ),
                            Container(
                              width: 65,
                              child: Text(
                                currentCoin.name,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            TwentyFourPercentage(
                              percentage:
                                  currentCoin.price_change_percentage_24h,
                            ),
                            CurrentPrice(
                              currentPrice: currentCoin.current_price,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

double _getFavouriteHeight(
  Favourites favourites,
  double displayHeight,
  double top,
) {
  final finalHeight = (displayHeight - top - kToolbarHeight);
  if (favourites == null) return finalHeight * 0.7;
  if (favourites.favouriteList.length == 2)
    return finalHeight * 0.25;
  else if (favourites.favouriteList.length == 1) return displayHeight * 0.10;
  return finalHeight * 0.40;
}
