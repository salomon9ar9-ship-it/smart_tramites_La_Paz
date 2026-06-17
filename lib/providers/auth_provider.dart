import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';

/// 🟦 Gestiona el estado de autenticación y sesión del usuario
class AuthProvider extends ChangeNotifier {
  final _repo = UserRepository();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoggedIn = false;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;

  /// 🔐 Iniciar sesión
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _repo.loginWithEmail(email, password);
      if (result.success && result.user != null) {
        _currentUser = result.user;
        _isLoggedIn = true;
        notifyListeners();
        return true;
      }
      _setError(result.message);
      return false;
    } catch (e) {
      _setError('Error inesperado: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// 📝 Registro de nuevo usuario
  Future<bool> register(UserModel userData) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _repo.registerUser(userData);
      if (result.success && result.user != null) {
        _currentUser = result.user;
        _isLoggedIn = true;
        notifyListeners();
        return true;
      }
      _setError(result.message);
      return false;
    } catch (e) {
      _setError('Error en registro: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// 🚪 Cerrar sesión
  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    _clearError();
    notifyListeners();
    // TODO: Limpiar SharedPreferences / Hive aquí
  }

  /// 🔄 Verificar sesión al iniciar la app
  Future<void> checkSession() async {
    _setLoading(true);
    // TODO: Leer token/usuario de almacenamiento local
    // Si existe, cargar _currentUser y _isLoggedIn = true
    _setLoading(false);
  }

  // Utilidades internas
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String msg) {
    _errorMessage = msg;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}
