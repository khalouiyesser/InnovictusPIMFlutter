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
        Function(double)? onAvailableAmountReceived,
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

    socket.on('transferProgress', (data) {
      debugPrint('📊 Transfer progress: $data');
      if (data is Map<String, dynamic> && data.containsKey('progress_percent')) {
        final progressPercent = (data['progress_percent'] as num).toDouble();

        // Appeler le callback avec juste le pourcentage comme avant
        if (onTransferProgressReceived != null) {
          onTransferProgressReceived(progressPercent);
        }

        // Mettre à jour le provider avec le pourcentage et d'autres informations pertinentes
        if (_transferStateProvider != null) {
          // Mise à jour du pourcentage
          _transferStateProvider!.updateTransferProgress(progressPercent);

          // Mise à jour des informations supplémentaires si votre provider les prend en charge
          if (data.containsKey('energy_transferred') && data.containsKey('target')) {
            final energyTransferred = (data['energy_transferred'] as num).toDouble();
            final target = (data['target'] as num).toDouble();
            _transferStateProvider!.updateTransferDetails(
                energyTransferred: energyTransferred,
                target: target
            );
          }
        }
      }
    });

    socket.on('availableAmount', (data) {
      debugPrint('📈 Available amount update: $data');
      if (data is Map && data.containsKey('currentAmount')) {
        // Get the raw double value
        final rawAmount = (data['currentAmount'] as num).toDouble();

        // Format to exactly two decimal places
        final formattedAmount = double.parse(rawAmount.toStringAsFixed(2));

        // Call the callback with the formatted amount
        if (onAvailableAmountReceived != null) {
          onAvailableAmountReceived(formattedAmount);
        }
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