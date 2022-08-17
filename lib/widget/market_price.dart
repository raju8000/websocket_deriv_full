import 'package:deriv_exercise/notifier/market_notifier.dart';
import 'package:deriv_exercise/notifier/trade_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MarketPriceText extends ConsumerWidget {
  const MarketPriceText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var tickNotifier = ref.watch(tickProvider);
    var defaultValue = ref.read(socketProvider).defaultPrice;

    return tickNotifier.maybeWhen(
      data:(data){
        var currentValue = data.tick!.quote!;
        Color color = currentValue > defaultValue? Colors.green : currentValue < defaultValue ? Colors.red : Colors.grey;
        return Text(data.tick?.quote.toString()??"",
          style: TextStyle(fontSize: 20,color:color ),);
      },
      orElse: () => const Center(
        child: Text("Loading...."),
      ),);
  }
}
