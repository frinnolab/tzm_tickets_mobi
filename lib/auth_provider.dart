import 'package:flutter/material.dart';
import 'services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  AuthProvider() {
    _checkToken();
  }

  Future<void> _checkToken() async {
    final token = await _apiService.getToken();
    _isAuthenticated = token != null;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    final response = await _apiService.login(email, password);
    if (response['access_token'] != null) {
      await _apiService.saveToken(response['access_token']);
      _isAuthenticated = true;
      notifyListeners();
    } else {
      throw Exception(response['message'] ?? 'Login failed');
    }
  }

  Future<void> register(String name, String email, String password) async {
    final response = await _apiService.register(name, email, password);
    if (response['access_token'] != null) {
      await _apiService.saveToken(response['access_token']);
      _isAuthenticated = true;
      notifyListeners();
    } else {
      throw Exception('Registration failed');
    }
  }

  Future<void> logout() async {
    await _apiService.clearToken();
    _isAuthenticated = false;
    notifyListeners();
  }
}
