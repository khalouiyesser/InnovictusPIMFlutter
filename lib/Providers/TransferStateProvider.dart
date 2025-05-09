import 'package:flutter/foundation.dart';

class TransferStateProvider with ChangeNotifier {
  bool _isTransferInProgress = false;
  String _transferMessage = '';
  bool _transferSuccess = false;

  bool get isTransferInProgress => _isTransferInProgress;
  String get transferMessage => _transferMessage;
  bool get transferSuccess => _transferSuccess;

  void startTransfer(String message) {
    _isTransferInProgress = true;
    _transferMessage = message;
    _transferSuccess = false;
    notifyListeners();
  }

  void completeTransfer({required bool success, String message = ''}) {
    _isTransferInProgress = false;
    _transferSuccess = success;
    if (message.isNotEmpty) {
      _transferMessage = message;
    }
    notifyListeners();
  }

  void reset() {
    _isTransferInProgress = false;
    _transferMessage = '';
    _transferSuccess = false;
    notifyListeners();
  }
}