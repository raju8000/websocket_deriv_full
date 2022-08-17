import 'dart:convert';

import 'package:deriv_exercise/models/model_active_symbol.dart';
import 'package:deriv_exercise/models/model_tick.dart';
import 'package:deriv_exercise/network/web_socket.dart';
import 'package:deriv_exercise/notifier/trade_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final socketProvider = ChangeNotifierProvider<MarketProvider>((ref) {
  return MarketProvider(ref);
});

class MarketProvider extends ChangeNotifier{

  late final WebSocket webSocket = WebSocket(setUpListener());
  late ModelActiveSymbol modelActiveSymbol;
  late ModelTick modelTick;
  Map<String,List<ActiveSymbols>> uniqueActiveSymbolByMarketName = <String,List<ActiveSymbols>>{};
  late String selectedMarket;
  late ActiveSymbols selectedSymbol;
  double defaultPrice =-1;
  bool isSymbolChanged = true;
  final Ref ref;

  MarketProvider(this.ref){
    getMarketPlace();
  }

  getMarketPlace(){
    Map<String,String> activeSymbolRequest ={
      "active_symbols": "brief",
      "product_type": "basic"
    };
    webSocket.sendRequest(activeSymbolRequest);

  }

  Function(dynamic event) setUpListener(){
    return ((event) {
      Map<String, dynamic> response = jsonDecode(event);
      if (response["msg_type"] == "active_symbols") {
        modelActiveSymbol = ModelActiveSymbol.fromJson(response);
        for (var element in modelActiveSymbol.activeSymbols!) {
          if (uniqueActiveSymbolByMarketName.containsKey(element.marketDisplayName)) {
            uniqueActiveSymbolByMarketName[element.marketDisplayName]?.add(element);
          }
          else {
            uniqueActiveSymbolByMarketName.putIfAbsent(element.marketDisplayName!, () => [element]);
          }
        }
        selectedMarket = uniqueActiveSymbolByMarketName.keys.first;
        selectedSymbol = uniqueActiveSymbolByMarketName[selectedMarket]![0];
        notifyListeners();
        getTickData(selectedSymbol);
      }
      if (response["msg_type"] == "tick") {
        modelTick = ModelTick.fromJson(response);
        if(defaultPrice==-1 || isSymbolChanged){
          defaultPrice = modelTick.tick?.quote??-1;
          isSymbolChanged = false;
        }
        ref.read(tickProvider.state).state = AsyncData(modelTick);
      }
    }
    );
  }

  updateValue<T>(T item){
    if(T == String){
      selectedMarket =(item as String);
      selectedSymbol = uniqueActiveSymbolByMarketName[selectedMarket]![0];
    }
    else{
      selectedSymbol = (item as ActiveSymbols);
    }
    isSymbolChanged = true;
    forgetOldTick();
    getTickData(selectedSymbol);
    notifyListeners();
  }

  getTickData(ActiveSymbols activeSymbols){
    Map<String,String> ticksRequest ={
      "ticks": activeSymbols.symbol!,
      "subscribe": "1"
    };
    webSocket.sendRequest(ticksRequest);
  }

  forgetOldTick(){
    Map<String,String> forgetTicksRequest ={
      "forget": modelTick.tick?.id??"",
    };
    webSocket.sendRequest(forgetTicksRequest);
  }

}