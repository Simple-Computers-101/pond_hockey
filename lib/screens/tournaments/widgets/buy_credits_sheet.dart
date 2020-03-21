import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:pond_hockey/services/iap_helper.dart';
import 'package:pond_hockey/utils/product_ids.dart';

class BuyCreditsSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final products = IAPHelper().products;
    assert(products.length == 2);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _ProductItem(prod: products[0]),
          _ProductItem(prod: products[1]),
        ],
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  const _ProductItem({@required this.prod});

  final ProductDetails prod;

  String _getProductName() {
    switch (prod.id) {
      case ProductIds.creditsOnePackId:
        return 'One Credit';
      case ProductIds.creditsThreePackId:
        return 'Credits (Three Pack)';
    }
    return null;
  }

  String _getImageName() {
    switch (prod.id) {
      case ProductIds.creditsOnePackId:
        return 'assets/img/one_coin.png';
      case ProductIds.creditsThreePackId:
        return 'assets/img/three_coins.png';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final containerHeight = size.height * 0.15;
    final containerWidth = size.width * 0.4;
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () => IAPHelper().buyCredits(prod),
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          height: containerHeight,
          width: containerWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFFEDEDED),
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                offset: Offset(2, 4),
                color: Colors.black.withOpacity(0.25),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _getProductName() ?? 'Unknown',
                textAlign: TextAlign.center,
              ),
              Image.asset(
                _getImageName(),
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              Text(prod.price),
            ],
          ),
        ),
      ),
    );
  }
}
