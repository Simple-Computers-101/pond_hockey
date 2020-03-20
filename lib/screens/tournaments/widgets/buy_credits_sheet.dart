import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:pond_hockey/services/iap_helper.dart';

class BuyCreditsSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: IAPHelper().initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final products = IAPHelper().products;
        assert(products.length == 2);
        return Container(
          height: MediaQuery.of(context).size.height * 0.20,
          decoration: BoxDecoration(
              color: Color(0xFFFCFCFC),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(25),
              ),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -2),
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.25),
                )
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _ProductItem(prod: products[0]),
              _ProductItem(prod: products[1]),
            ],
          ),
        );
      },
    );
  }
}

class _ProductItem extends StatelessWidget {
  const _ProductItem({@required this.prod});

  final ProductDetails prod;

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
              Text(prod.title),
              Text(prod.price),
            ],
          ),
        ),
      ),
    );
  }
}
