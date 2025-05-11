import 'package:flutter/foundation.dart';
import 'package:piminnovictus/Models/config/Theme/theme_provider.dart';
import 'package:piminnovictus/Providers/TransferStateProvider.dart';
import 'package:piminnovictus/Services/Const.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:provider/provider.dart';

class SocketService {
  late IO.Socket socket;
  String api = Const().urlSocket;
  TransferStateProvider? _transferStateProvider;

  void connectToSocket(
    Function(Map<String, dynamic>) onDataReceived, {
    TransferStateProvider? transferStateProvider,
  }) {
    // Store the provider reference if provided
    _transferStateProvider = transferStateProvider;

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
   /* socket.on('startTransfer', (data) {
      debugPrint('⚡ Transfer started: $data');
      if (data is Map<String, dynamic> && _transferStateProvider != null) {
        final senderId = data['userId'] as String? ?? '';
        final usersList = data['usersList'] as List<dynamic>? ?? [];
        
        // Update transfer state through provider
        _transferStateProvider!.startTransfer(senderId, usersList);
        
        // Set a timeout to reset the state after 30 seconds
        Future.delayed(const Duration(seconds: 30), () {
          _transferStateProvider!.resetTransfer();
        });
      }
    });*/
 socket.on('startTransfer', (data) {
  debugPrint('⚡ Transfer started: $data');
  
  if (data is Map<String, dynamic> && _transferStateProvider != null) {
    try {
      // Extract senderId and usersList from the socket data
      final senderId = data['userId']?.toString() ?? ''; // Use userId for sender
      final usersList = data['usersList'] as List<dynamic>? ?? [];
      
      debugPrint('🔍 Transfer data received - Sender: $senderId, Users list: $usersList');
      
      // Update transfer state through provider
      _transferStateProvider!.startTransfer(senderId, usersList);
    } catch (e) {
      debugPrint('❌ Error processing transfer data: $e');
    }
  }
});

socket.on('transferComplete', (_) {
  debugPrint('⚡ Transfer completed');
  if (_transferStateProvider != null) {
    _transferStateProvider!.resetTransfer();
  }
});
    socket.onError((error) {
      debugPrint('⚠️ WebSocket Error: $error');
    });
  }

  void emitResetEnergy() {
    socket.emit('message', {
      'topic': 'resetEnergy',
      'message': 'reset'
    });
  }

  void disconnect() {
    socket.disconnect();
  }
}