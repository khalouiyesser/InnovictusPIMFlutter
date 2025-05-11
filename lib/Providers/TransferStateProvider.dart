import 'package:flutter/foundation.dart';

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

  // Reset state to idle
  void resetTransfer() {
    _state = TransferState.idle;
    _usersList = [];
    notifyListeners();
  }

String getStateMessage() {
  switch (_state) {
    case TransferState.transferring:
      return "Vous êtes en train de recevoir de l'énergie, merci de patienter jusqu'à la fin de l'opération";
    case TransferState.receiving:
      return "Vous êtes en train de transférer l'énergie, merci de patienter jusqu'à la fin de l'opération";
    case TransferState.systemBusy:
      return "Il y a une opération de transfert en cours, vous pouvez acheter de l'énergie après la finalisation de l'opération en cours !!";
    default:
      return "";
  }
}
}