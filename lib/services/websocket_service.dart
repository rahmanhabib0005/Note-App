import 'package:web_socket_channel/web_socket_channel.dart';

class WebsocketService {
  final WebSocketChannel channel;

  WebsocketService(String url) : channel = WebSocketChannel.connect(Uri.parse(url));

  void sendMessage(String message) {
    channel.sink.add(message);
  }

  Stream<dynamic> get stream => channel.stream;

  void dispose() {
    channel.sink.close();
  }
}
