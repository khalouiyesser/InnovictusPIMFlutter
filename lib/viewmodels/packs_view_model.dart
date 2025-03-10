import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:piminnovictus/Models/ClientModels/packs.dart';
import 'package:piminnovictus/Services/Const.dart';

class PacksViewModel extends ChangeNotifier {
  final Const _const = Const();
  List<Pack> _packs = [];
  bool _isLoading = false;
  String _errorMessage = '';
  Pack? _selectedPack;

  List<Pack> get packs => _packs;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  Pack? get selectedPack => _selectedPack;

  void setSelectedPack(Pack? pack) {
    _selectedPack = pack;
    notifyListeners();
  }

  // Récupérer tous les packs
  Future<void> getAllPacks() async {
    _setLoading(true);
    _clearError();
    
    try {
      final response = await http.get(
        Uri.parse('${_const.url}/packs'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _packs = data.map((json) => Pack.fromJson(json)).toList();
        notifyListeners();
      } else {
        _setError('Erreur lors du chargement des packs: ${response.statusCode}');
      }
    } catch (e) {
      _setError('Exception: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Ajouter un nouveau pack
  Future<Pack?> addPack(Pack pack) async {
    _setLoading(true);
    _clearError();
    
    try {
      final response = await http.post(
        Uri.parse('${_const.url}/packs'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(pack.toJson()),
      );

      if (response.statusCode == 201) {
        final Pack newPack = Pack.fromJson(json.decode(response.body));
        _packs.add(newPack);
        notifyListeners();
        return newPack;
      } else {
        final errorResponse = json.decode(response.body);
        _setError('Erreur lors de l\'ajout du pack: ${errorResponse['message'] ?? response.statusCode}');
        return null;
      }
    } catch (e) {
      _setError('Exception: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Mettre à jour un pack existant
  Future<bool> updatePack(String id, Pack pack) async {
    _setLoading(true);
    _clearError();
    
    try {
      final response = await http.patch(
        Uri.parse('${_const.url}/packs/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(pack.toJson()),
      );

      if (response.statusCode == 200) {
        final updatedPack = Pack.fromJson(json.decode(response.body));
        final index = _packs.indexWhere((p) => p.id == id);
        if (index != -1) {
          _packs[index] = updatedPack;
        }
        
        if (_selectedPack?.id == id) {
          _selectedPack = updatedPack;
        }
        
        notifyListeners();
        return true;
      } else {
        final errorResponse = json.decode(response.body);
        _setError('Erreur lors de la mise à jour du pack: ${errorResponse['message'] ?? response.statusCode}');
        return false;
      }
    } catch (e) {
      _setError('Exception: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Supprimer un pack
  Future<bool> deletePack(String id) async {
    _setLoading(true);
    _clearError();
    
    try {
      final response = await http.delete(
        Uri.parse('${_const.url}/packs/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        _packs.removeWhere((pack) => pack.id == id);
        
        if (_selectedPack?.id == id) {
          _selectedPack = null;
        }
        
        notifyListeners();
        return true;
      } else {
        final errorResponse = json.decode(response.body);
        _setError('Erreur lors de la suppression du pack: ${errorResponse['message'] ?? response.statusCode}');
        return false;
      }
    } catch (e) {
      _setError('Exception: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Récupérer un pack par son ID
  Future<Pack?> getPackById(String id) async {
    _setLoading(true);
    _clearError();
    
    try {
      final response = await http.get(
        Uri.parse('${_const.url}/packs/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final pack = Pack.fromJson(json.decode(response.body));
        _selectedPack = pack;
        notifyListeners();
        return pack;
      } else {
        final errorResponse = json.decode(response.body);
        _setError('Erreur lors de la récupération du pack: ${errorResponse['message'] ?? response.statusCode}');
        return null;
      }
    } catch (e) {
      _setError('Exception: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Rechercher des packs par titre
  Future<List<Pack>> searchPacksByTitle(String query) async {
    if (query.isEmpty) {
      return _packs;
    }
    
    final searchQuery = query.toLowerCase();
    return _packs.where((pack) => 
      pack.title.toLowerCase().contains(searchQuery)
    ).toList();
  }

  // Filtrer les packs par prix
  List<Pack> filterPacksByPriceRange(double minPrice, double maxPrice) {
    return _packs.where((pack) => 
      pack.price >= minPrice && pack.price <= maxPrice
    ).toList();
  }

  // Trier les packs
  void sortPacksByPrice({bool ascending = true}) {
    _packs.sort((a, b) => 
      ascending ? a.price.compareTo(b.price) : b.price.compareTo(a.price)
    );
    notifyListeners();
  }

  // Méthodes utilitaires
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = '';
  }

  // Réinitialiser le ViewModel
  void reset() {
    _packs = [];
    _isLoading = false;
    _errorMessage = '';
    _selectedPack = null;
    notifyListeners();
  }
}