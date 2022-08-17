import 'package:deriv_exercise/models/model_active_symbol.dart';
import 'package:deriv_exercise/widget/dropdrown.dart';
import 'package:deriv_exercise/widget/market_price.dart';
import 'package:flutter/material.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
            child: Column(
              children:  const [
                ///Market places
                DropDown<String>(),
                SizedBox(height: 20,),

                ///Active symbols according to market
                DropDown<ActiveSymbols>(),

                SizedBox(height: 55,),

                /// Live Price of symbols
                MarketPriceText()
              ],
            ),
          ),
        )
    );
  }
}

