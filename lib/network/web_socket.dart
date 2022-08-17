import 'dart:convert';
import 'package:deriv_exercise/network/constants.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocket{

  static late WebSocketChannel channel;
  static final WebSocket _webSocket = WebSocket._internal();
  static late Function(dynamic event) listener;

  factory WebSocket(Function(dynamic event) listen) {
    listener = listen;
    return _webSocket;
  }

  WebSocket._internal(){
    channel = WebSocketChannel.connect(
      Uri.parse(CONNECT_URL),
    );
    channel.stream.listen(listener);

  }

  void sendRequest(Map<String,dynamic> request){
    channel.sink.add(jsonEncode(request));
  }

}