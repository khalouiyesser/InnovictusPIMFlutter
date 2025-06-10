import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:piminnovictus/Models/config/language/translations.dart';

// Define enum for transfer states
enum TransferState {
  idle,
  transferring,
  receiving,
  systemBusy
}

class TransferStateProvider with ChangeNotifier {

  TransferState _state = TransferState.idle;
  String _userId = '';
  List<dynamic> _usersList = [];
    double _progressPercent = 0.0;
  double _energyTransferred = 0.0;
  double _targetEnergy = 0.0;

    double get progressPercent => _progressPercent;
  double get energyTransferred => _energyTransferred;
   double get targetEnergy => _targetEnergy;
  double get completionRatio => _targetEnergy > 0 ? _energyTransferred / _targetEnergy : 0.0;

  // Constructor can take an initial userId if needed
  TransferStateProvider({String? userId}) {
    if (userId != null) {
      _userId = userId;
    }
  }

  // Getter for current state
  TransferState get state => _state;
 
  // Set the user ID
  void setUserId(String userId) {
    _userId = userId;
    notifyListeners();
  }



bool isSender(String senderId) {
  return _userId == senderId; // Ensure both are strings
}

bool isRecipient(List<dynamic> usersList) {
  if (_userId.isEmpty) return false;
  return usersList.any((user) => user['user_id']?.toString() == _userId);
}


  // Start a transfer operation and update state accordingly
 void startTransfer(String senderId, List<dynamic> usersList) {
  if (isSender(senderId)) {
    _state = TransferState.transferring;
    debugPrint('📤 User is the sender, setting state to TRANSFERRING');
  } else if (isRecipient(usersList)) {
    _state = TransferState.receiving;
    debugPrint('📥 User is a recipient, setting state to RECEIVING');
  } else {
    _state = TransferState.systemBusy;
    debugPrint('⌛ Other users are transacting, setting state to SYSTEM_BUSY');
  }
  _usersList = usersList;
  notifyListeners();
}
  void updateTransferDetails({
    double? energyTransferred,
    double? target,
  }) {
    if (energyTransferred != null) {
      _energyTransferred = energyTransferred;
    }
    if (target != null) {
      _targetEnergy = target;
    }
    notifyListeners();
  }

  void updateTransferProgress(double progressPercent) {
    _progressPercent = progressPercent;
    notifyListeners();
  }
  // Reset state to idle
  void resetTransfer() {
    _state = TransferState.idle;
    _usersList = [];
    notifyListeners();
  }

String getStateMessage(BuildContext context) {
  switch (_state) {
    case TransferState.transferring:
        return AppLocalizations.of(context).translate("transfer_sending_message");
    case TransferState.receiving:
        return AppLocalizations.of(context).translate("transfer_receiving_message");
    case TransferState.systemBusy:
        return AppLocalizations.of(context).translate("transfer_system_busy_message");
    default:
      return "";
  }
}
}
