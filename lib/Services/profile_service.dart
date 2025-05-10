
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:piminnovictus/Models/ClientModels/profile.dart';
import 'package:piminnovictus/Services/Const.dart';
import 'package:piminnovictus/Services/session_manager.dart';

class ProfileService {
  final String baseBcUrl = "${Const().urlBlockChain}";

  final String baseUrl;
  final SessionManager _sessionManager;
  ProfileService({required this.baseUrl, required SessionManager sessionManager})
      : _sessionManager = sessionManager;
      

  Future<Map<String, String>> _getHeaders() async {
    final token = await _sessionManager.getAccessToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<List<ProfileModel>> getProfiles() async {
    try {
      final userId = await _sessionManager.getUserId();
      if (userId == null) throw Exception('User not authenticated');

      final response = await http.get(
        Uri.parse('$baseUrl/profile/user/$userId'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ProfileModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load profiles');
      }
    } catch (e) {
      throw Exception('Error fetching profiles: $e');
    }
  }

  Future<ProfileModel> createProfile(String name, String? imageUrl) async {
    try {
      final userId = await _sessionManager.getUserId();
      if (userId == null) throw Exception('User not authenticated');

      final response = await http.post(
        Uri.parse('$baseUrl/profile'),
        headers: await _getHeaders(),
        body: json.encode({
          'name': name,
          'image': imageUrl,
          'userId': userId,
          'packId': 'default'
        }),
      );

      if (response.statusCode == 201) {
        return ProfileModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create profile');
      }
    } catch (e) {
      throw Exception('Error creating profile: $e');
    }
  }



//
  Future<List<dynamic>> transfer( String quantite) async {
        final userId = await _sessionManager.getUserId();
    print("**********************************object");
    //print(userId);
    try {
          print("**********************************tryyyy");
      // Prepare the request body
      final Map<String, dynamic> body = {
        'quantite': quantite,
      };

      // Send the POST request to the API
      final response = await http.post(
        //Uri.parse('http://192.168.1.186:3009/surplus/transfer/67fc0fc891dd216a7100505e'),
        Uri.parse('$baseUrl/surplus/transfer/$userId'),
        headers: {
          'Content-Type': 'application/json', // Set the content type to JSON
        },
        body: json.encode(body), // Convert the body to JSON
      );
      print(response.statusCode );
      // Check if the response is successful
      if (response.statusCode == 201) {
        print("----------------------------------------------------response.body");
        print(response.body);  
        
         final Map<String, dynamic> data = json.decode(response.body);

      final List<dynamic> usersList = data['usersList'];
      print('🟢 Users List: $usersList');

      return usersList;      // Parse the response if needed
      
      } else {
        print( 'Error: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (error) {
      print( 'Error during transfer: $error');
      return [];
    }
    
  }



//
// Updated transaction method that supports batching multiple recipients
Future<Map<String, dynamic>> transaction({
  required String senderId,
  required List<String> receiverIds,  // Now accepts a list of receiver IDs
  required List<double> amounts,      // Now accepts a list of amounts
  required String senderPrivateKey,
}) async {
  try {
    // Input validation
    if (receiverIds.isEmpty || amounts.isEmpty) {
      throw Exception('Receiver IDs and amounts cannot be empty');
    }
    
    if (receiverIds.length != amounts.length) {
      throw Exception('Receiver IDs and amounts must have the same length');
    }
    
    final url = Uri.parse('$baseBcUrl/transferTokens');

    // Log what we're about to send
    print('📤 Sending batch transaction to $receiverIds with amounts $amounts');
    
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'senderId': senderId,
        'receiverIds': receiverIds,  // Already a list
        'amounts': amounts,          // Already a list
        'senderPrivateKey': senderPrivateKey,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('✅ Batch transaction success: $data');
      return data;
    } else {
      print('🔴 Batch transaction failed: ${response.statusCode} - ${response.body}');
      throw Exception('Failed batch transaction: ${response.statusCode}');
    }
  } catch (e) {
    print('🔴 Error calling /transferTokens: $e');
    throw Exception('Transaction error: $e');
  }
}
/*
Future<Map<String, dynamic>> transaction({
    required String senderId,
    required String receiverId,
    required double amount,
    required String senderPrivateKey,
  }) async {
    try {
      final url = Uri.parse('$baseBcUrl/transferTokens');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'senderId': senderId,
          'receiverIds': [receiverId],  // Wrap in list
          'amounts': [amount], 
          'senderPrivateKey': senderPrivateKey,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Transaction success: $data');
        return data;
      } else {
        print('🔴 Transaction failed: ${response.statusCode} - ${response.body}');
        throw Exception('Failed transaction: ${response.statusCode}');
      }
    } catch (e) {
      print('🔴 Error calling /transferTokens: $e');
      throw Exception('Transaction error: $e');
    }
  }
*/














  // Other API methods...
}