import 'package:piminnovictus/Services/Const.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart';

class SocketService {
  late IO.Socket socket;
  String api = Const().urlSocket;
  void connectToSocket(Function(Map<String, dynamic>) onDataReceived) {
    // Initialize socket connection
    socket = IO.io(api, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      debugPrint('✅ Successfully connected to WebSocket server!');
    });

    socket.onDisconnect((_) {
      debugPrint('❌ Disconnected from WebSocket');
    });

    // Debug all incoming events
    socket.onAny((event, data) {
      debugPrint('DEBUG - Received event: $event with data: $data');
    });

    // Listen for 'batteryStats' event
    socket.on('batteryStats', (data) {
      debugPrint('Battery stats update: $data');
      
      if (data is Map<String, dynamic>) {
        onDataReceived(data);
      }
    });

    socket.onError((error) {
      debugPrint('⚠️ WebSocket Error: $error');
    });
  }

  void disconnect() {
    socket.disconnect();
  }
}
