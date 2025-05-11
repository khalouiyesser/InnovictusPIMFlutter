import 'package:flutter/foundation.dart';
import 'package:piminnovictus/Providers/TransferStateProvider.dart';
import 'package:piminnovictus/Services/Const.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;
  String api = Const().urlSocket;
  TransferStateProvider? _transferStateProvider;

  void connectToSocket(
    Function(Map<String, dynamic>) onBatteryStatsReceived, {
    Function(double)? onTransferProgressReceived, // Rendu optionnel
    TransferStateProvider? transferStateProvider,
  }) {
    _transferStateProvider = transferStateProvider;

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

    socket.onAny((event, data) {
      debugPrint('DEBUG - Received event: $event with data: $data');
    });

    socket.on('batteryStats', (data) {
      debugPrint('Battery stats update: $data');
      if (data is Map<String, dynamic>) {
        onBatteryStatsReceived(data);
      }
    });

    // Écouteur pour transferProgress
    socket.on('transferProgress', (data) {
      debugPrint('📊 Transfer progress: $data');
      if (data is Map<String, dynamic> && data.containsKey('progress_percent')) {
        final progressPercent = (data['progress_percent'] as num).toDouble();
        // Appeler le callback seulement s'il est fourni
        onTransferProgressReceived?.call(progressPercent);
      }
    });

    socket.on('startTransfer', (data) {
      debugPrint('⚡ Transfer started: $data');
      if (data is Map<String, dynamic> && _transferStateProvider != null) {
        try {
          final senderId = data['userId']?.toString() ?? '';
          final usersList = data['usersList'] as List<dynamic>? ?? [];
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