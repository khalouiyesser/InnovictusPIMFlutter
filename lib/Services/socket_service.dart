import 'package:flutter/foundation.dart';
import 'package:piminnovictus/Providers/TransferStateProvider.dart';
import 'package:piminnovictus/Services/Const.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;
  String api = Const().urlSocket;
  
  void connectToSocket(
    Function(Map<String, dynamic>) onDataReceived, {
    TransferStateProvider? transferProvider,
  }) {
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

    // Listen for 'startTransfer' event
    socket.on('startTransfer', (data) {
      if (data is Map<String, dynamic>) {
        if (transferProvider != null) {
          final bool success = data['success'] ?? false;
          final String message = data['message'] ?? 'Transfer in progress...';
          
          if (!success) {
            transferProvider.startTransfer(message);
          }
        }
      }
    });

    // Listen for 'completeTransfer' event
    socket.on('completeTransfer', (data) {
      if (data is Map<String, dynamic> && transferProvider != null) {
        final bool success = data['success'] ?? false;
        final String message = data['message'] ?? 'Transfer completed';
        
        transferProvider.completeTransfer(
          success: success,
          message: message,
        );
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